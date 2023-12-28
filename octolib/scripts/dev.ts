import './_prerun'

import { resolve } from 'path'
import { info, ok } from '../core/log'
import { app, tester } from '../core/tester'
import config from '../config'

import './start-server'

const htmlPath = resolve(__dirname, '../sender/index.html')
app.get('/', (req, res) => res.sendFile(htmlPath))
app.get('/status', (req, res) => res.send(tester.isConnected))
app.post('/eval', async (req, res) => {
	try {
		res.send(await tester.exec(req.body))
	} catch (e: any) {
		res.send(e.toString())
	}
})

info('Waiting for game server to connect...')
tester.server.registerToken('main', config.keys.services!)
tester.waitForConnection().then(() => ok('Game server connected! Open http://localhost:8888 to send code'))
