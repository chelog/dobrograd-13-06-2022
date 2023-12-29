import '../scripts/generate-env'

import childProcess from 'child_process'
import { info, ok, fail } from '../core/log'
import config from '../config'

export const start = () => {
	info('Launching game server...')
	const exePath = process.platform === 'win32' ? '../srcds.exe' : '../srcds_run'
	const gameServer = childProcess.spawn(exePath, [
		'-allowlocalhttp',
		'-console',
		'-game', 'garrysmod',
		'-tickrate', config.tickrate.toString(),
		'-port', config.port.toString(),
		'+sv_setsteamaccount', config.serverAccount,
		'+host_workshop_collection', config.workshopCollection.toString(),
		'+gmod_language', config.language,
		'+gamemode', config.gamemode,
		'+map', config.map,
		'+maxplayers', config.maxPlayers.toString(),
		'+sv_hibernate_think', config.hibernateThink ? '1' : '0',
		'-ip 0.0.0.0',
		'+net_public_adr 89.35.52.89',
	], {
		stdio: 'inherit',
	})

	gameServer.on('close', code => {
		if (code === 0)
			ok('Game server shut down')
		else
			fail('Game server exited with non-ok code ' + code)
	})

	const killServer = () => {
		if (!gameServer.killed) {
			gameServer.kill()
			ok('Killed game server')
		}
	}

	process.on('beforeExit', killServer)
	process.on('uncaughtException', error => {
		killServer()
		throw error
	})

	if (gameServer.stdin)
		process.stdin.pipe(gameServer.stdin)

	return gameServer
}
