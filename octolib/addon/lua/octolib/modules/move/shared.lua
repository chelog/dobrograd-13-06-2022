if CFG.disabledModules.move then return end

hook.Add('StartCommand', 'octolib.move', function(ply, cmd)

	local fwd = cmd:GetForwardMove()
	if cmd:KeyDown(IN_SPEED) then
		local side = cmd:GetSideMove()
		if (fwd < 0 or (fwd == 0 and side ~= 0)) and ply:GetMoveType() ~= MOVETYPE_NOCLIP then
			cmd:RemoveKey(IN_SPEED)
			cmd:RemoveKey(IN_WALK)
		end
	end

	if cmd:KeyDown(IN_JUMP) and ply:GetJumpPower() == 0 and not ply:InVehicle() then
		cmd:RemoveKey(IN_JUMP)
	end

	if not cmd:KeyDown(IN_DUCK) and ply:GetNetVar('nostand') and not ply:InVehicle() then
		cmd:SetButtons(cmd:GetButtons() + IN_DUCK)
	end

	if ply:GetNetVar('norun') then
		cmd:RemoveKey(IN_SPEED)
		cmd:RemoveKey(IN_WALK)
	end

end)
