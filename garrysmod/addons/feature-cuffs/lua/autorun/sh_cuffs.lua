local pmeta = FindMetaTable('Player')

function pmeta:IsHandcuffed()
	local wep = self:GetActiveWeapon()
	if IsValid(wep) and wep.IsHandcuffs then
		return true, wep
	end
	return false
end

hook.Add('dbg-travel.canTransfer', 'dbg-cuffs', function(ply)
	if ply:IsHandcuffed() then return false, L.dontdoincuffs end
end)

local maxSid = GetConVar('cl_sidespeed'):GetInt() - 21
local maxFwd = GetConVar('cl_forwardspeed'):GetInt() - 21

hook.Add('StartCommand', 'dbg-cuffs.drag', function(ply, cmd)

	local cuffed, wep = ply:IsHandcuffed()
	if cuffed and IsValid(ply:GetNetVar('dragger')) then
		local cop = ply:GetNetVar('dragger')

		local pos = cop:EyePos() + cop:GetAimVector() * wep:GetNetVar('RopeLength', 100)
		local dirFwd = ply:GetAimVector()
		local dirTgt = pos - ply:GetPos()
		local dist = dirTgt:Length2DSqr()
		if SERVER and dist > 100000 then
			ply:SetNetVar('dragger')
			ply:SetNetVar('dragging')
		end

		cmd:ClearMovement()

		local ang = ply.lastEyeAngles or ply:EyeAngles()
		ang.p = cmd:GetViewAngles().p
		ang.y = octolib.math.lerpAngle(ang.y, cop:EyeAngles().y, FrameTime() * 2, FrameTime() * 4)
		ply.lastEyeAngles = ang
		cmd:SetViewAngles(ang)
		cmd:SetButtons(0)
		if SERVER and cop:KeyDown(IN_JUMP) then
			cmd:SetButtons(IN_JUMP)
		end

		if dist > 50 then
			dirFwd.z = 0
			dirTgt.z = 0
			dirFwd:Normalize()
			dirTgt:Normalize()
			local dirSid = Vector(dirFwd.x, dirFwd.y, 0)
			dirSid:Rotate(Angle(0, 90, 0))

			cmd:SetForwardMove(dirFwd:Dot(dirTgt) * math.min(maxFwd, dist))
			cmd:SetSideMove(-dirSid:Dot(dirTgt) * math.min(maxSid, dist))
		end
	end

end)
