import express from 'express'
import EventEmitter from 'events'
import { SocketServer } from './socket/server'
import { Client } from './socket/client'

type GameResult = {
	/** Error message, if occured */
	error: string
	/** Data returned from game */
	returns: any
}

class Tester extends EventEmitter {

	/** Is game server connected to socket */
	isConnected: boolean = false
	/** Our socket-server */
	server: SocketServer
	/** Game's WebSocket client */
	client?: Client

	constructor(server: SocketServer) {
		super()

		this.server = server

		this.server.on('connected', (client: Client) => {
			this.client = client
			this.isConnected = true
			this.emit('connected', client)
		})

		this.server.on('disconnected', client => {
			if (client !== this.client) return
			delete this.client
			this.isConnected = false
			this.emit('disconnected', client)
		})
	}

	/** Wait for server connections */
	waitForConnection(): Promise<void> {
		return new Promise((res, rej) => {
			if (this.isConnected) return res()
			this.once('connected', res)
		})
	}

	/** Execute lua code on server and return results (if returned from lua) */
	exec(code: any): Promise<GameResult> {
		if (!this.client) throw new Error('No socket connected')
		return this.server.request(this.client, 'eval', { code }) as Promise<GameResult>
	}

	/** Run method on connected game client */
	request(method: string, data?: any): Promise<any> {
		if (!this.client) throw new Error('No socket connected')
		return this.server.request(this.client, method, data)
	}

}

export const app = express()
export const http = app.listen(8888)
export const socket = new SocketServer(http)
export const tester = new Tester(socket)

app.use(express.text() as any)
