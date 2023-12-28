import fs from 'fs'
import path from 'path'
import config from '../config'

const envPath = path.resolve(__dirname, '../../garrysmod/addons/util-lsac')
if (fs.existsSync(envPath))
	fs.writeFileSync(path.resolve(envPath, 'mysql.txt'), JSON.stringify({
		DBIPAddress: config.db.host,
		DBPort: config.db.port,
		DBUsername: config.db.user,
		DBPassword: config.db.pass,
		DBSchema: config.db.main,
	}))

// allow dynamic imports
export default {}
