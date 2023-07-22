import './_prerun'

import fs from 'fs'
import path from 'path'
import sudo from 'sudo-prompt'
import ora from 'ora'
import mysql from 'mysql2/promise'
import Config from '../core/config'

async function setup() {
	const spinner = ora({
		spinner: 'moon',
	})

	// config
	let config: Config
	spinner.start('Checking config file...')
	try {
		const configPath = path.resolve(__dirname, '../../config.ts')
		if (!fs.existsSync(configPath)) {
			const configExampleProjectPath = path.resolve(__dirname, '../../config.example.ts')
			if (fs.existsSync(configExampleProjectPath))
				// if available use project example
				fs.copyFileSync(configExampleProjectPath, configPath)
			else
				// if not use octolib example
				fs.copyFileSync(path.resolve(__dirname, '../config.example.ts'), configPath)
		}
		config = (await import(configPath)).default as Config
		if (!config.db) throw new Error('Config file is corrupted')
		spinner.succeed('Config file is OK')
	} catch (e: any) {
		spinner.fail('Config file check failed')
		throw e
	}

	// .env
	spinner.start('Generating environment file...')
	try {
		await import('./generate-env')
		spinner.succeed('Environment file is OK')
	} catch {
		spinner.succeed('Environment file generation failed')
	}

	// gmod addon
	spinner.start('Checking gmod addon...')
	try {
		const addonPath = path.resolve(__dirname, '../../garrysmod/addons/local-octolib')
		const addonSource = path.resolve(__dirname, '../addon')
		if (!fs.existsSync(addonPath)) {
			if (process.platform === 'win32')
				sudo.exec(`mklink /D "${addonPath}" "${addonSource}"`, {
					name: 'octolib',
				}, function(error, stdout, stderr) {
					if (error) {
						spinner.fail('Could not install gmod addon')
						throw error
					}
					console.log('stdout: ' + stdout)
				})
			else
				fs.symlinkSync(addonSource, addonPath)
		}
		spinner.succeed('GMod addon is OK')
	} catch (e: any) {
		spinner.fail('GMod addon check failed')
		throw(e)
	}

	// database
	spinner.start('Checking database...')
	try {
		const conn = await mysql.createConnection({
			host: config.db.host,
			port: config.db.port,
			user: config.db.user,
			password: config.db.pass,
		})
		await conn.execute(`create database if not exists \`${config.db.main}\` collate 'utf8mb4_unicode_ci'`)
		conn.destroy()
		spinner.succeed('Database is OK')
	} catch (e: any) {
		spinner.fail('Database check failed')
		throw e
	}
}
setup()
