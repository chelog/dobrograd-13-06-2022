import { EventEmitter } from 'events'
import { Server } from 'http'
import WebSocket from 'ws'
import { Client, ClientSocket } from './client'
import { Message, MessageType } from './message'

type ReplyFunc = (data?: any) => void
type HandlerFunc = (reply: ReplyFunc, client: Client, data?: any) => void
type HandlerAllowFunc = (socket: Client, method: string, data?: any) => boolean
type PendingRequest = [(data: unknown) => void, NodeJS.Timeout]

export type Handler = {
	allow?: string[] | HandlerAllowFunc
	handle: HandlerFunc
}

export class SocketServer extends EventEmitter {
	clients: Map<string, Client> = new Map()
	server: WebSocket.Server
	authTimeout: number = 10
	requestTimeout: number = 15
	heartbeatInterval: number = 30

	private _nextMessageID = 0
	private _pendingRequests: Map<number, PendingRequest> = new Map()
	private _requestHandlers: Map<string, Handler> = new Map()
	private _tokenMap: Map<string, string> = new Map()

	constructor (server: Server) {
		super()

		this.server = new WebSocket.Server({ server })
		this.server.on('connection', (socket: ClientSocket) => this._handleConnection(socket))
	}

	registerToken(clientID: string, token: string) {
		this._tokenMap.set(token, clientID)
	}

	isConnected(clientID: string) {
		return this.clients.has(clientID)
	}

	send(clientID: string, msg: Message) {
		const payload = msg.toJSON()
		this.clients.get(clientID)?.socket.send(payload)
	}

	request(clientSelector: string | Client, method: string, data?: any) {
		const client = typeof clientSelector === 'string' ? this.clients.get(clientSelector) : clientSelector
		const msgID = this._nextMessageID ++
		const promise = new Promise((res, rej) => {
			if (!client) {
				this._pendingRequests.delete(msgID)
				rej('no clients connected')
				return
			}

			client.send(Message.request(msgID, method, data))
			const timeout = setTimeout(() => {
				rej('request timed out')
				this._pendingRequests.delete(msgID)
			}, this.requestTimeout * 1000)

			this._pendingRequests.set(msgID, [res, timeout])
		})

		return promise
	}

	listen(method: string, handler: Handler) {
		this._requestHandlers.set(method, handler)
	}

	private _handleConnection(socket: ClientSocket) {
		const timeout = setTimeout(() => {
			socket.send('Auth timed out.')
			socket.close()
		}, this.authTimeout * 1000)

		socket.once('message', key => {
			clearTimeout(timeout)

			const clientID = this._tokenMap.get(key.toString())
			if (!clientID) {
				socket.send('No access.')
				socket.close()
				return
			}

			if (this.isConnected(clientID)) {
				socket.send('Client with this ID is already connected.')
				socket.close()
				return
			}

			this._setupClient(clientID, socket)
		})
	}

	private _setupClient(clientID: string, socket: ClientSocket) {
		const client = new Client(this, socket, clientID)
		socket.on('close', reason => this._handleDisconnect(socket, reason.toString()))
		socket.on('error', err => this.emit('error', socket, err))
		socket.on('message', msg => this._handleMessage(socket, msg))
		socket.client = client
		this.clients.set(clientID, client)

		socket.send('ok')
		const heartbeatInterval = setInterval(() => {
			this.request(client, '_hb').catch(() => {
				clearInterval(heartbeatInterval)
				this._handleDisconnect(socket, 'heartbeat timeout')
			})
		}, this.heartbeatInterval * 1000)

		this.emit('connected', client)
	}

	private _handleDisconnect(socket: ClientSocket, reason: string) {
		if (!socket.client) return

		this.clients.delete(socket.client.clientID)
		this.emit('disconnected', socket.client, reason)
	}

	private _handleMessage(socket: ClientSocket, payload: any) {
		const client = socket.client
		if (!client) return

		let msg
		try {
			const [type, msgID, methodOrData, data] = JSON.parse(payload)
			msg = new Message(type, msgID, methodOrData, data)
		} catch (e: any) {
			socket.send(e)
			return
		}

		switch (msg.type) {
			case MessageType.Request: this._handleRequest(client, msg); break;
			case MessageType.Response: this._handleReply(client, msg); break;
			default: client.send(Message.response(msg.id, { error: 'Unknown message type.' })); break;
		}
	}

	private _handleRequest(client: Client, msg: Message) {
		const handler = this._requestHandlers.get(msg.method)
		if (!handler) return client.send(Message.response(msg.id, { error: 'Unknown method.' }))

		if (handler.allow) {
			if (
				(handler.allow.constructor === Array && handler.allow.indexOf(client.clientID) === -1) ||
				(typeof(handler.allow) === 'function' && !handler.allow(client, msg.method, msg.data))
			)
				return client.send(Message.response(msg.id, { error: 'No access.' }))
		}

		handler.handle(data => client.send(Message.response(msg.id, data)), client, msg.data)
		this.emit('request', client, msg.id, msg.method, msg.data)
	}

	private _handleReply(client: Client, msg: Message) {
		const request = this._pendingRequests.get(msg.id)
		if (!request) return

		const [resolve, timeout] = request
		this._pendingRequests.delete(msg.id)

		clearTimeout(timeout)
		resolve(msg.data)
	}
}
