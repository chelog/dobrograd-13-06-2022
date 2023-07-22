gmpanel.registerAction('move', function(obj, ply)
	if not (isvector(obj.pos) and isangle(obj.ang)) then return end
	local players = gmpanel.buildTargets(obj.players or {})
	for _, target in ipairs(players) do
		target:SetPos(obj.pos)
		target:SetEyeAngles(obj.ang)
		hook.Run('gmpanel.moved', ply, target, obj.pos, obj.ang)
	end
end)
