AddCSLuaFile('shared.lua')
AddCSLuaFile('cl_init.lua')
include('shared.lua')

function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire(CurTime() + 0.4)

	if not IsValid(self.Owner) or self.Owner.hacking then return end

	local ent = self.Owner:GetEyeTrace().Entity
	if not IsValid(ent) or not ent.IsKeypad then return end
	if ent:GetPos():DistToSqr(self.Owner:GetShootPos()) > 2500 then return end
	if ent:CPPIGetOwner() == self.Owner then return end

	self:SetHoldType('pistol')
	self.Owner:Hack(ent, function()

		local vPoint = ent:GetPos()
		local effect = EffectData()
		effect:SetStart(vPoint)
		effect:SetOrigin(vPoint)
		effect:SetEntity(ent)
		util.Effect('sparks_manhack', effect)
		ent:EmitSound('buttons/combine_button7.wav', 70)

	end, nil, function()
		self:SetHoldType(self.IdleStance)
	end)
end
