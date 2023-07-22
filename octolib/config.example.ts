import Config from './octolib/core/config'

const config: Config = {
	dev: true,
	serverGroupID: 'test',
	serverID: 'test',

	tickrate: 66,
	port: 27015,
	language: 'en',
	workshopCollection: -1,
	gamemode: 'sandbox',
	map: 'gm_construct',
	maxPlayers: 16,
	hibernateThink: true,

	octoservicesURL: 'https://octothorp.team/api',

	serverAccount: '',
	steamKey: '',
	imgurKey: '',

	keys: {},

	webhooks: {},

	db: {
		host: 'localhost',
		user: 'root',
		pass: '',
		port: 3306,

		main: 'test',
		admin: 'test',
		shop: 'test',
	},
}

export default config
