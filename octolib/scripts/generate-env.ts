import fs from 'fs'
import path from 'path'
import config from '../config'

const envPath = path.resolve(__dirname, '../../.env.json')
fs.writeFileSync(envPath, JSON.stringify(config, null, 2))
import './generate-lsac'

// allow dynamic imports
export default {}
