--[[
	© 2017 Thriving Ventures Limited do not share, re-distribute or modify
	
	without permission of its author (gustaf@thrivingventures.com).
]]

--[[
	OBS_MODE_NONE - (number - 0)
	OBS_MODE_IN_EYE - (number - 4)
	OBS_MODE_DEATHCAM - (number - 1)
	OBS_MODE_FIXED - (number - 3)
	OBS_MODE_CHASE - (number - 5)
	OBS_MODE_FREEZECAM - (number - 2)
	OBS_MODE_ROAMING - (number - 6)
	
	
	MOVETYPE_PUSH - (number - 7)
	MOVETYPE_OBSERVER - (number - 10)
	MOVETYPE_CUSTOM - (number - 11)
	MOVETYPE_NOCLIP - (number - 8)
	MOVETYPE_ISOMETRIC - (number - 1)
	MOVETYPE_FLY - (number - 4)
	MOVETYPE_NONE - (number - 0)
	MOVETYPE_STEP - (number - 3)
	MOVETYPE_VPHYSICS - (number - 6)
	MOVETYPE_WALK - (number - 2)
	MOVETYPE_LADDER - (number - 9)
	MOVETYPE_FLYGRAVITY - (number - 5)
]]

hook.Add("KeyPress", "serverguard.spectate.KeyPress", function(player, key)
	if (player:Team() == TEAM_SPECTATOR and player.sg_spectating) then
		if (key == IN_ATTACK) then
			if (player:GetObserverMode() == OBS_MODE_CHASE or player:GetObserverMode() == OBS_MODE_IN_EYE) then
				serverguard.player:SpectateTarget(player);
			else
				local target = serverguard.player:GetSpectatorTarget(player);

				if (IsValid(target)) then
					player:SetPos(target:EyePos())
				end
			end
		end
		
		if (key == IN_ATTACK2) then
			if (player:GetObserverMode() == OBS_MODE_CHASE or player:GetObserverMode() == OBS_MODE_IN_EYE) then
				serverguard.player:SpectateTarget(player, true);
			else
				local target = serverguard.player:GetSpectatorTarget(player, true);

				if (IsValid(target)) then
					player:SetPos(target:EyePos())
				end
			end
		end
		
		if (key == IN_JUMP) then
			serverguard.player:ChangeSpectatorMode(player);
		end
		
		if (key == IN_DUCK) then
			serverguard.player:StopSpectate(player);
		end
	end
end)