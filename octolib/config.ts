import Config from './core/config'

const config: Config = {
	dev: true,
	serverGroupID: 'test',
	serverID: 'test',

	tickrate: 16,
	port: 27015,
	language: 'ru',
	workshopCollection: 570795184,
	gamemode: 'darkrp',
	map: 'rp_ndbg_winter',
	maxPlayers: 16,
	hibernateThink: true,

	octoservicesURL: 'https://octothorp.team/api',

	serverAccount: '',
	steamKey: '',
	imgurKey: '',

	keys: {},

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
}

export default config
 