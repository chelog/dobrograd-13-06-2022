include('shared.lua')
AddCSLuaFile('shared.lua')

SWEP.Weight = 5
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

local switchSound = Sound('flashlight.toggle')

function SWEP:OnDrop()

	local ply = self:GetOwner()
	if self:GetActive() and IsValid(ply) and not ply:GetNetVar('Invisible') then
		ply:EmitSound(switchSound)
	end
	self:KillLight()

end

function SWEP:Holster()

	local ply = self:GetOwner()
	if self:GetActive() and IsValid(ply) and not ply:GetNetVar('Invisible') then
		ply:EmitSound(switchSound)
	end
	self:KillLight()

	return true

end

function SWEP:PrimaryAttack()

	self:SetNextSecondaryFire(CurTime() + 0.23)
	if not self:GetOwner():GetNetVar('Invisible') then
		self:GetOwner():EmitSound(switchSound)
	end

	if not IsValid(self.projectedlight) then
		self:BuildLight()
		return
	end

	local newState = not self:GetActive()
	self:SetActive(newState)

	if newState then
		self.projectedlight:Fire('TurnOn')
		self:SetHoldType('pistol')
	else
		self.projectedlight:Fire('TurnOff')
		self:SetHoldType('normal')
	end

end

function SWEP:Deploy()

	self:SetNextSecondaryFire(CurTime() + 0.835)
	self:SetNextPrimaryFire(CurTime() + 0.835)
	self:SetNextReload(CurTime() + 1.835)
	if not self:GetOwner():GetNetVar('Invisible') then
		self:GetOwner():EmitSound(switchSound)
	end
	self:BuildLight()
	self:SetHoldType(self:GetActive() and 'pistol' or 'normal')

	return true

end

function SWEP:OnRemove()

	local ply = self:GetOwner()
	if self:GetActive() and IsValid(ply) and not ply:GetNetVar('Invisible') then
		ply:EmitSound(switchSound)
	end
	self:KillLight()

end

function SWEP:BuildLight()

	if not IsValid(self) then return end

	local ply = self:GetOwner()
	if not IsValid(ply) or ply:GetActiveWeapon() ~= self then return end

	self.projectedlight = ents.Create('env_projectedtexture')
	self.projectedlight:SetParent(ply)
	self.projectedlight:SetPos(ply:GetShootPos())
	self.projectedlight:SetAngles(ply:GetAngles())
	self.projectedlight:SetKeyValue('enableshadows', 1)
	self.projectedlight:SetKeyValue('nearz', 7)
	self.projectedlight:SetKeyValue('farz', 750.0)
	self.projectedlight:SetKeyValue('lightcolor', self.FlashColor)
	self.projectedlight:SetKeyValue('lightfov', 70)
	self.projectedlight:Spawn()
	self.projectedlight:Input('SpotlightTexture', NULL, NULL, 'effects/flashlight001')
	self.projectedlight:Fire('setparentattachment', 'anim_attachment_RH', 0.01)
	self:DeleteOnRemove(self.projectedlight)
	cleanup.Add(ply, 'flspot', self.projectedlight)

	self:SetActive(true)

end

function SWEP:KillLight()

	self:SetActive(false)
	if IsValid(self.projectedlight) then
		SafeRemoveEntity (self.projectedlight)
	end

end
