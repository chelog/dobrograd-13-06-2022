gmpanel.registerAction('sounds', function(obj)

	if isstring(obj.soundId) then
		obj.soundId = utf8.sub(obj.soundId, 1, 48)
	else obj.soundId = nil end

	if istable(obj.stopsounds) and table.IsSequential(obj.stopsounds) then
		for i = #obj.stopsounds, 1, -1 do
			local str = obj.stopsounds[i]
			if not isstring(str) then
				table.remove(obj.stopsounds, i)
				continue
			end
			str = utf8.sub(str:gsub(' ', ''), 1, 48)
			if str == '' then
				table.remove(obj.stopsounds, i)
				continue
			end
			obj.stopsounds[i] = str
		end
	else obj.stopsounds = {} end

	local players = gmpanel.buildTargets(obj.players or {})
	obj.players = nil
	netstream.Start(players, 'dbg-event.action.sound', obj)
end)
