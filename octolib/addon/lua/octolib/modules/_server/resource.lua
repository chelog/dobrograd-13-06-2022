RunConsoleCommand('sv_downloadurl', 'https://cdn.octothorp.team/gmod/')

hook.Add('InitPostEntity', 'octolib.content', function()

	if file.Exists('config/content.lua', 'LUA') then
		octolib.server('config/content')
	end

end)
