include 'shared.lua'

SWEP.PrimaryAttack = octolib.func.zero
SWEP.SecondaryAttack = octolib.func.zero
SWEP.Reload = octolib.func.zero

function SWEP:GetCSModel()

	if not self.TypeData then return end

	local mdl = self.csmodel
	if not IsValid(mdl) then
		mdl = ClientsideModel(self.WorldModel)

		local pos, ang = unpack(self.TypeData)
		local ply = self:GetOwner()
		mdl:SetParent(ply, ply:LookupAttachment('anim_attachment_rh'))
		mdl:SetLocalPos(pos)
		mdl:SetLocalAngles(ang)

		self.csmodel = mdl
	end

	return mdl

end

function SWEP:RemoveCSEnt()
	if IsValid(self.csmodel) then self.csmodel:Remove() end
end

function SWEP:DrawWorldModel()

	local mdl = self:GetNetVar('WorldModel')
	if self.lastMdl ~= mdl then
		self.WorldModel = mdl
		self.TypeData = self.Types[mdl]
		self.lastMdl = mdl
	end

	self:GetCSModel()

end

function SWEP:Holster()
	self:RemoveCSEnt()
	return true
end

SWEP.OwnerChanged = SWEP.RemoveCSEnt
SWEP.OnRemove = SWEP.RemoveCSEnt

local lastAng
hook.Add('CreateMove', 'dbg_shield', function(cmd)

	local ply = LocalPlayer()
	local wep = ply:GetActiveWeapon()
	if not IsValid(wep) or wep:GetClass() ~= 'dbg_shield' then
		lastAng = nil
		return
	end

	local ang = cmd:GetViewAngles()
	if not ply:Crouching() then
		ang.p = math.Clamp(ang.p, -45, 5)
	else
		lastAng = lastAng or ang
		ang = Angle(math.Clamp(ang.p, -35, -7), lastAng.y, lastAng.r)
	end

	cmd:SetViewAngles(ang)
	lastAng = ang

end)