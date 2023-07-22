/** Enum for socket message types */
export enum MessageType {
	Unknown = -1,
	Request = 0,
	Response = 1,
}

export class Message {
	public type: MessageType = MessageType.Unknown
	public id: number = -1
	public method: string = ''
	public data: any

	constructor (type: MessageType, msgID: number, methodOrData: string | any, data?: any) {
		this.type = type
		this.id = msgID

		switch (type) {
			case MessageType.Request:
				this.method = methodOrData
				this.data = data
				break
			case MessageType.Response:
				this.data = methodOrData
				break
			default: throw new Error('Unknown message type')
		}
	}

	/** Create request message object */
	static request(id: number, method: string, data: any): Message {
		return new this(MessageType.Request, id, method, data)
	}

	/** Create response message object */
	static response(id: number, data: any): Message {
		return new this(MessageType.Response, id, data)
	}

	serialize () {
		switch (this.type) {
			case MessageType.Request:
				return [this.type, this.id, this.method, this.data]
			case MessageType.Response:
				return [this.type, this.id, this.data]
			default: throw new Error('Data corrupted')
		}
	}

	toJSON () {
		return JSON.stringify(this.serialize())
	}
}
