octolib.server('dbg-winter/sv_winter')
octolib.client('dbg-winter/cl_winter')
octolib.client('dbg-winter/cl_editor')

hook.Add('Think', 'dbg-winter.init', function()
	hook.Remove('Think', 'dbg-winter.init')

	local mapFile = 'dbg-winter/map_' .. game.GetMap()
	if file.Exists(mapFile .. '.lua', 'LUA') then
		octolib.client(mapFile)
	end
end)
