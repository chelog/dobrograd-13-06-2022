import './_prerun'

import fs from 'fs'
import path from 'path'
import mysql from 'mysql2/promise'
import ora from 'ora'
import config from '../../config'

async function reset() {
	const spinner = ora({
		spinner: 'moon',
	})

	spinner.start('Resetting database...')
	try {
		const conn = await mysql.createConnection({
			host: config.db.host,
			port: config.db.port,
			user: config.db.user,
			password: config.db.pass,
		})
		await conn.execute(`drop database if exists \`${config.db.main}\``)
		await conn.execute(`create database \`${config.db.main}\` collate 'utf8mb4_unicode_ci'`)
		conn.destroy()
		spinner.succeed('Database reset')
	} catch (e: any) {
		spinner.fail('Database reset failed')
		throw e
	}

	spinner.start('Resetting data folder...')
	try {
		const dataPath = path.resolve(__dirname, '../../garrysmod/data')
		if (fs.existsSync(dataPath))
			fs.rmdirSync(dataPath, { recursive: true })
		spinner.succeed('Data folder reset')
	} catch (e: any) {
		spinner.fail('Data folder reset failed')
		throw e
	}
}
