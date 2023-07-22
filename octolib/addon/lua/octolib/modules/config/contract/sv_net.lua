netstream.Listen('octolib.config.get', function(reply, ply, id)
	local option = octolib.config.storedOptions[id]
	if not option or not option:CanRead(ply) then
		return reply()
	end

	reply(option:Get())
end)

netstream.Listen('octolib.config.set', function(reply, ply, id, value)
	local option = octolib.config.storedOptions[id]
	if not option or not option:CanWrite(ply) then
		return reply(false)
	end

	option:Set(value)

	reply(true)
end)
