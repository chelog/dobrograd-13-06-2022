local pending = {}
function octolib.request.send(ply, fields, callback, cancel)
	local id = octolib.string.uuid()
	netstream.Start(ply, 'octolib.request', id, fields)

	pending[id] = { ply, callback, cancel }
	timer.Create('octolib.requestTimeout' .. id, 600, 1, function()
		local request = pending[id]
		if not request then return end

		local cancel = request[3]
		if cancel then cancel() end
		pending[id] = nil
	end)
end

netstream.Hook('octolib.request', function(ply, id, data)
	if not pending[id] or pending[id][1] ~= ply then return end

	timer.Remove('octolib.requestTimeout' .. id)
	if data then
		pending[id][2](data)
	elseif pending[id][3] then
		pending[id][3]()
	end

	pending[id] = nil
end)

hook.Add('PlayerDisconnected', 'octolib.request', function(ply)
	for id, r in pairs(pending) do
		if r[1] == ply then
			timer.Remove('octolib.requestTimeout' .. id)
			if r[3] then r[3]() end
			pending[id] = nil
			octolib.msg('Removing active request due to player leave: %s', id)
		end
	end
end)
