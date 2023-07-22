local plugin = plugin

local command = {}

command.help	= 'Редактировать Watchlist\'ы игрока'
command.command   = 'watch'
command.arguments = {'player'}
command.permissions = 'DBG: WatchLists'
command.immunity  = SERVERGUARD.IMMUNITY.LESSOREQUAL

function command:Execute(admin, silent, arguments)
	local target = util.FindPlayer(arguments[1], admin, true)
	if admin == target then
		admin:Notify('warning', 'Любишь быть в центре внимания?')
		return
	end
	plugin:OpenEditor(admin, IsValid(target) and target:SteamID() or arguments[1])
	return true
end

serverguard.command:Add(command)
