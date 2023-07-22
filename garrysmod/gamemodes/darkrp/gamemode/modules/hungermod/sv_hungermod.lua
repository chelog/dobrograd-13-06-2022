local function HMThink()
	octolib.func.throttle(player.GetAll(), 10, 0.2, function(v)
		if not IsValid(v) or not v:Alive() or v:IsGhost() then return end
		v:hungerUpdate()
	end)
end
timer.Create('HMThink', 10, 0, HMThink)
