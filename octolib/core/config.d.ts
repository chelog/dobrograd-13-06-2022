export default interface Config {
	dev: boolean
	serverGroupID: string
	serverID: string

	tickrate: number
	port: number
	language: string
	workshopCollection: number
	gamemode: string
	map: string
	maxPlayers: number
	hibernateThink: boolean

	/** octoservices api base url */
	octoservicesURL: string

	/** Steam account token from https://steamcommunity.com/dev/managegameservers */
	serverAccount: string
	steamKey: string
	imgurKey?: string

	keys: {
		services?: string
		logs?: string
		cats?: string
		test?: string
	}

	webhooks: {
		cats?: string
		cheats?: string
		error?: string
		unban?: string
	}

	db: {
		host: string
		user: string
		pass: string
		port: number
		socket?: string

		/** Main server database name */
		main: string
		/** Admin (ranks, bans, etc.) database name */
		admin: string
		/** Donate shop database name */
		shop: string
	}
}
