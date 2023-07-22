octochat.defineCommand('/whisper', {
	aliases = {'/w'},
})
octochat.defineCommand('/yell', {
	aliases = {'/y'},
})

octochat.defineCommand('/me', true)
octochat.defineCommand('/it', true)
octochat.defineCommand('/pit', true)
octochat.defineCommand('/toit', true)
octochat.defineCommand('/whispertoit', {
	aliases = {'/wtoit'},
})
octochat.defineCommand('/yelltoit', {
	aliases = {'/ytoit'},
})
octochat.defineCommand('//it', {
	permission = 'DBG: Глобальный IT',
})

octochat.defineCommand('/d', true)
octochat.defineCommand('/sms', true)

octochat.defineCommand('/roll', true)
octochat.defineCommand('/dice', true)
octochat.defineCommand('/coin', true)
octochat.defineCommand('/card', true)
octochat.defineCommand('/rockpaperscissors', true)
octochat.defineCommand('/dbg_getidea', true)

octochat.defineCommand('/give', true)
octochat.defineCommand('/dropmoney', {
	aliases = {'/moneydrop'},
})
octochat.defineCommand('/putmoney', {
	aliases = {'/moneyput'},
})
