if CFG.disabledModules.afk then return end

netstream.Hook('octolib.afk', function(ply, afk)

	afk = tobool(afk)
	if ply:IsAFK() ~= afk then hook.Run('octolib.afk.changed', ply, afk) end
	ply:SetNetVar('afk', afk and CurTime() - CFG.afkTime or nil)

end)

CFG.afkKickTime = CFG.afkKickTime or 600
timer.Create('octolib.afk.kick', 60, 0, function()

	octolib.func.throttle(player.GetAll(), 10, 0.1, function(ply)
		if not IsValid(ply) then return end

		if ply:GetAFKTime() > CFG.afkKickTime and not ply:IsAdmin() then
			ply:Kick('AFK')
		end
	end)

end)
