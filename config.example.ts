import Config from './octolib/core/config'

export interface DobrogradConfig extends Config {
	defaultHostName?: string
	adminMention?: string
	testEnabled?: boolean
	disableGCrash?: boolean
	requireLauncher?: boolean
}

const config: DobrogradConfig = {
	dev: true,
	serverGroupID: 'dbg_dev',
	serverID: 'dbg_dev',

	tickrate: 16,
	port: 27015,
	language: 'ru',
	workshopCollection: 570795184,
	gamemode: 'darkrp',
	map: 'rp_evocity_dbg_220222',
	maxPlayers: 16,
	hibernateThink: true,

	octoservicesURL: 'https://octothorp.team/api',

	serverAccount: '',
	steamKey: '',
	imgurKey: '',

	keys: {
		services: '',
		cats: '',
		logs: '',
		test: '',
	},

	webhooks: {},

	db: {
		host: 'mariadb',
		user: 'root',
		pass: '',
		port: 3306,

		main: 'gmod_dobrograd',
		admin: 'gmod_dobrograd',
		shop: 'gmod_dobrograd',
	},

	disableGCrash: true,
	testEnabled: false,
	defaultHostName: 'DBG DEV',
	adminMention: '',
	requireLauncher: false,
}

export default config
