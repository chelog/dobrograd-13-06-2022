gmpanel.registerAction('notifications', function(obj)
	local players = gmpanel.buildTargets(obj.players or {})
	local msg = octolib.string.splitByUrl(tostring(obj.text or 'Уведомление'))
	for _,pl in ipairs(players) do
		pl:Notify(obj.channel or 'rp', unpack(msg))
	end
end)
