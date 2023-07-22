include 'shared.lua'
AddCSLuaFile 'cl_init.lua'
AddCSLuaFile 'shared.lua'

function SWEP:PrimaryAttack()
	-- nothing
end

function SWEP:SecondaryAttack()
	-- nothing
end

function SWEP:Reload()

	local ct = CurTime()
	if ct < (self.nextReload or 0) then return end

	local newVal = not self:GetNetVar('filming')
	self:SetNetVar('filming', newVal)

	self.nextReload = ct + 0.5

end

function SWEP:HideOwner(hide)

	local ply = self:GetOwner()
	if not IsValid(ply) then return end
	ply:MakeInvisible(hide)

end

function SWEP:Deploy()
	self:HideOwner(true)
end

function SWEP:Holster()
	self:HideOwner(false)
	return true
end

function SWEP:OnRemove()
	self:HideOwner(false)
end

hook.Add('canDropWeapon', 'octocamera', function(ply, wep)
	if wep:GetClass() == 'octo_camera' then return false end
end)
