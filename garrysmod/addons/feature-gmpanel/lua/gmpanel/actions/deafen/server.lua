local dsps = {
	1, -- normal
	15, -- medium
	16, -- hard
}

gmpanel.registerAction('deafen', function(obj)
	if not isnumber(obj.screen) or not isnumber(obj.sound) then return false end
	local players = gmpanel.buildTargets(obj.players or {})
	local dsp = dsps[obj.sound + 1] or dsps[1]
	for _,ply in ipairs(players) do
		ply:SetDSP(dsp)
		netstream.Start(ply, 'gmpanel.darkenScreen', obj.screen)
	end
end)
