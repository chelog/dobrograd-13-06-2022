gmpanel.registerAction('ragdoll', function(obj, ply)
	local status, players = obj.value or false, gmpanel.buildTargets(obj.players or {})
	for _,pl in ipairs(players) do
		local state = IsValid(pl.sgRagdoll)
		if status ~= state then
			ply:Say('~ragdoll ' .. pl:SteamID())
		end
	end
end)
