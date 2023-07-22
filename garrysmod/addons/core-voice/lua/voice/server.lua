local ranges = { 10000, 150000, 500000, 2250000 }

local function updateVoiceMod(ply, mod)
	if not IsValid(ply) then return end
	mod = mod or ply.talkRangeMod or 2

	if mod == 4 then mod = 3 end
	if mod == 3 and ply:isGov() then
		local veh = ply:GetVehicle()
		if IsValid(veh) and IsValid(veh:GetParent()) and veh:GetParent().police then
			mod = 4
		else
			veh = octolib.use.getTrace(ply).Entity
			if IsValid(veh) and veh.police then mod = 4 end
		end
	end

	ply:SetNetVar('TalkRange', ranges[mod] or ranges[2])
	ply.talkRangeMod = mod

end

netstream.Hook('IWannaChangeVoiceMod', updateVoiceMod)

timer.Create('dbg-voice.updateMods', 4, 0, function()
	octolib.func.throttle(player.GetAll(), 10, 0.3, updateVoiceMod)
end)
