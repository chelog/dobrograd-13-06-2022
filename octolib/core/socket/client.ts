import WebSocket from 'ws'
import { Message } from './message'
import { SocketServer } from './server'

export class ClientSocket extends WebSocket {
	public client?: Client
}

export class Client {
	public clientID: string
	public socket: ClientSocket
	public server: SocketServer

	constructor(server: SocketServer, socket: ClientSocket, id: string) {
		this.server = server
		this.socket = socket
		this.clientID = id
	}

	send(message: Message) {
		this.socket.send(message.toJSON())
	}

	request(method: string, data?: any) {
		return this.server.request(this, method, data)
	}
}
