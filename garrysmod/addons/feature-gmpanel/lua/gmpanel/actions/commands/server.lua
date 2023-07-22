gmpanel.registerAction('commands', function(obj, ply)
	if not isstring(obj.value) then return false end
	local cmd, players = obj.value, gmpanel.buildTargets(obj.players or {})
	for _,pl in ipairs(players) do
		ply:Say(cmd:gsub('@p', pl:SteamID()))
	end
end)
