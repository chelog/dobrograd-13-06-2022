local pending = {}

netstream.Hook('octolib.guiEntries', function(ply, id, res)
	if not pending[ply] or not pending[ply][id] then return end
	pending[ply][id](res)
end)

netstream.Hook('octolib.guiEntries.close', function(ply, id)
	if pending[ply] then pending[ply][id] = nil end
end)

hook.Add('PlayerDisconnected', 'octolib.guiEntries.close', function(ply)
	pending[ply] = nil
end)

function octolib.entries.gui(ply, title, data, res)
	local id = octolib.string.uuid()
	pending[ply] = pending[ply] or {}
	pending[ply][id] = res
	netstream.Start(ply, 'octolib.guiEntries', id, title, data)
end
