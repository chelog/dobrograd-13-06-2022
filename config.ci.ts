import base from './config.example'

const config = Object.assign({}, base)

config.port = 28015
config.hibernateThink = true

config.octoservicesURL = 'https://octothorp.team/api'
config.keys.services = ''

config.db = {
	host: 'mariadb',
	user: 'root',
	pass: 'octoteam ci/cd',
	port: 3306,

	main: 'gmod_dbg_dev',
	admin: 'gmod_dbg_dev',
	shop: 'gmod_dbg_dev',
}

export default config
