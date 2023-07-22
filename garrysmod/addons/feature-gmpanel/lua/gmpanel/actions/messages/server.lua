gmpanel.registerAction('messages', function(data)
	if data.action ~= '' then
		data.action = ' ' .. data.action
	end
	data.players = gmpanel.buildTargets(data.players or {})

	local msg = {octochat.textColors.rp, data.name, data.action}
	if data.message ~= '' then
		msg = {octochat.textColors.rp, data.name, data.action, ': ', color_white, data.message}
	end

	for _,pl in ipairs(data.players) do
		octochat.talkTo(pl, unpack(msg))
		if data.voice and data.message ~= '' then pl:DoVoice(data.message, data.voice, pl) end
	end
end)
