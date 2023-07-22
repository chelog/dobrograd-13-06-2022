import './_prerun'

import { empty, fail, info, ok } from '../core/log'
import { tester } from '../core/tester'
import { start } from '../core/gameServer'
import config from '../../config'

type TestSection = {
	name: string
	level: number
}

type TestResult = {
	name: string
	time: number
	error?: string
}

const gameServer = process.argv[2] == 'server' ? start() : undefined

info('Waiting for game server to connect...')
tester.server.registerToken('main', config.keys.services!)

let curLevel = -1
let noErrors = true
tester.server.listen('printSection', {
	handle(reply, client, section: TestSection) {
		reply()

		curLevel = section.level
		const prefix = '   '.repeat(curLevel)
		info(`${prefix}${section.name.underline.bold}`)
	}
})

tester.server.listen('testResult', {
	handle(reply, client, result: TestResult) {
		reply()

		const prefix = '   '.repeat(curLevel + 1)
		if (result.error) {
			info(`${prefix}${'❌'.red} ${result.name} (${Math.round(result.time * 1000)}ms):\n${result.error}`)
			noErrors = false
		}
		else
			info(`${prefix}${'✔'.green} ${result.name} (${Math.round(result.time * 1000)}ms)`)
	},
})

tester.server.listen('finish', {
	handle(reply, client, data) {
		reply()
		empty()
		gameServer?.kill()

		if (noErrors) {
			ok('All tests finished successfully!')
			process.exit(0)
		}
		else {
			fail('Some tests failed. See the report above')
			process.exit(1)
		}
	},
})

tester.waitForConnection().then(() => {
	ok('Game server connected! Starting tests...')
	empty()
	tester.request('runTests')
})
