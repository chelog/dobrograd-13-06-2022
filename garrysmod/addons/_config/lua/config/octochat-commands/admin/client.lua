octochat.defineCommand('/spectate', {
	permission = 'FSpectate',
	aliases = {'!spectate', '~spectate'},
})
octochat.defineCommand('/spawn', {
	check = DarkRP.isAdmin,
	aliases = {'/respawn'},
})
octochat.defineCommand('!invisible', {
	aliases = {'~invisible', '/invisible', '!cloak', '~cloak', '/cloak'},
	permission = 'Invisible',
})

local adminData = {check = DarkRP.isAdmin}
octochat.defineCommand('/resetname', adminData)
octochat.defineCommand('/resetdesc', adminData)
octochat.defineCommand('/forceunlock', adminData)
octochat.defineCommand('/forcelock', adminData)
octochat.defineCommand('/forceown', adminData)
octochat.defineCommand('/forceunown', adminData)
octochat.defineCommand('/admintell', adminData)
octochat.defineCommand('/admintellall', adminData)
octochat.defineCommand('/teamban', adminData)
octochat.defineCommand('/teamunban', adminData)


local superAdminData = {check = DarkRP.isSuperAdmin}
octochat.defineCommand('/addjailpos', superAdminData)
octochat.defineCommand('/clearjailpos', superAdminData)
octochat.defineCommand('/groupown', superAdminData)
octochat.defineCommand('/groupunown', superAdminData)
octochat.defineCommand('/jobown', superAdminData)
octochat.defineCommand('/jobunown', superAdminData)
