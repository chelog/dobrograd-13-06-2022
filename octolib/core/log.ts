import day from 'dayjs'

export const empty = (lines: number = 1) =>
	console.log('\n'.repeat(lines - 1))

export const now = () =>
	`[${day().format('MM.DD HH:mm:ss')}]`

export const info = (text: any) =>
	console.log(`${now()} ${text}`)

export const ok = (text: any) =>
	console.log(`${now()} ${'✔'.green} ${text}`)

export const fail = (text: any) =>
	console.log(`${now()} ${'❌'.red} ${text}`)
