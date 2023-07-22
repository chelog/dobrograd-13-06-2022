SWEP.Base				= 'weapon_octo_base_cold'
SWEP.Category			= L.dobrograd .. ' - Холодное'
SWEP.Spawnable			= true
SWEP.AdminSpawnable	= false
SWEP.PrintName			= L.knife
SWEP.Instructions		= 'ПКМ - прицелиться.\nЛКМ - атаковать.\nR - мощный удар (наносит огромный урон при ударе в спину)'

if SERVER then

	AddCSLuaFile()

end

SWEP.Primary.Ammo		= 'sharp'
SWEP.HitDistance		= 54
SWEP.HitPushback		= 0
SWEP.HitRate			= 0.4
SWEP.Damage				= {5, 15}
SWEP.ScareMultiplier	= 0.6

local slash = Sound('Weapon_Knife.Slash')
local stab = Sound('Weapon_Knife.Stab')
SWEP.SwingSound		= slash
SWEP.HitSoundWorld	= Sound('Weapon_Knife.HitWall')
SWEP.HitSoundBody		= Sound('Weapon_Knife.Hit')

SWEP.Icon				= 'octoteam/icons/knife.png'
SWEP.ViewModel			= Model('models/weapons/v_knife_t.mdl')
SWEP.WorldModel		= Model('models/weapons/w_knife_t.mdl')
SWEP.ActiveHoldType	= 'knife'
SWEP.TrajectoryType = 'point'
SWEP.DeploySound	= Sound('Weapon_Knife.Deploy')

function SWEP:GetDamage(tr)
	local ent = tr.Entity
	if not IsValid(ent) then return 0 end
	if self.powerful then
		return self:EntityFaceBack(ent) and 195 or 65
	else return math.random(6) == 3 and 20 or 15 end
end

function SWEP:OnBulletShot()
	self.nextReload = CurTime() + 5
end

function SWEP:EntityFaceBack(ent)

	local angle = self.Owner:GetAngles().y -ent:GetAngles().y
	if angle < -180 then angle = 360 + angle end
	if angle <= 90 and angle >= -90 then return true end
	return false

end

function SWEP:Reload()
	if not IsFirstTimePredicted() then return end
	local time = CurTime()
	local ok = self:GetNetVar('CanSetReady') and self:GetNetVar('IsReady') and (self.nextReload or 0) <= time and self.Owner:GetNetVar('ScareState', 0) <= 0.6
	if not ok then return end

	self:SetNextPrimaryFire(time + 5)
	self.nextReload = CurTime() + 5
	self.Owner:SetAnimation(PLAYER_ATTACK1)

	if SERVER then
		if self.SwingSound then self.Owner:EmitSound(self.SwingSound) end -- prevent doubling on client
		timer.Create('hitdelay' .. self:EntIndex(), 0.1, 1, function()
			self.powerful, self.SwingSound = true, stab
			self:Attack()
			self.powerful, self.SwingSound = false, slash
		end)
	end

end

function SWEP:DoImpactEffect(tr)
	util.Decal('ManhackCut', tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal)
	return true
end
