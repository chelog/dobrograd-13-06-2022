SWEP.Base						= "weapon_octo_base"
SWEP.Category					= L.dobrograd
SWEP.Spawnable			= false
SWEP.AdminSpawnable		= false

if SERVER then

	AddCSLuaFile()

end

SWEP.Primary.Ammo				= "air"
SWEP.Primary.Automatic			= true
SWEP.Primary.Sound 				= Sound("weapon.BulletImpact")
SWEP.Primary.DistantSound 		= Sound( "" )
SWEP.Primary.Damage				= 0
SWEP.Primary.RPM				= 60

SWEP.PassiveHoldType 			= "passive"
SWEP.ActiveHoldType 			= "ar2"

SWEP.Primary.ClipSize			= 10
SWEP.Primary.DefaultClip = 0
SWEP.Primary.KickUp			 = 3.35
SWEP.Primary.KickDown		   = 0.6
SWEP.Primary.KickHorizontal	 = 0.01

SWEP.ReloadTime					= 2.2
SWEP.Icon = 'octoteam/icons/gun_rifle.png'

SWEP.CanScare						= false
SWEP.IsLethal						= false -- shouldn't take karma whet shots fired

function SWEP:CustomFireBullets(shootPos, shootDir)

	local ply = self:GetOwner()
	local ang = shootDir:Angle()
	local spread = self.Primary.Spread
	for _ = 1, self.Primary.NumShots or 1 do
		local dir = shootDir + ang:Right() * math.Rand(-spread, spread) + ang:Up() * math.Rand(-spread, spread)
		local tr = util.TraceLine({
			start = shootPos,
			endpos = shootPos + dir * (self.Primary.Distance or 200),
			filter = self:GetOwner(),
		})

		if IsValid(tr.Entity) then
			local dmg = DamageInfo()
			dmg:SetAttacker(ply)
			dmg:SetInflictor(self)
			dmg:SetDamage(self.Primary.Damage)
			dmg:SetDamageForce(self.Primary.Damage * shootDir)
			dmg:SetDamageType(DMG_BULLET)
			dmg:SetDamagePosition(tr.HitPos)
			if SERVER then tr.Entity:TakeDamageInfo(dmg) end
			self:BulletHitCallback(tr, {})
		end
	end

	return true

end
