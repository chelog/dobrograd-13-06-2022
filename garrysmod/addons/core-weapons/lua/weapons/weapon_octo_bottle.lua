SWEP.Base				= 'weapon_octo_base_cold'
SWEP.Category			= L.dobrograd .. ' - Холодное'
SWEP.Spawnable			= true
SWEP.AdminSpawnable	= false
SWEP.PrintName			= 'Бутылка'

if SERVER then

	AddCSLuaFile()

end

SWEP.Primary.Ammo		= 'sharp'
SWEP.HitDistance		= 35
SWEP.HitInclination	= 0.2
SWEP.HitPushback		= 100
SWEP.HitRate			= 0.50
SWEP.Damage				= {2, 8}
SWEP.ScareMultiplier	= 0.2

SWEP.SwingSound		= Sound('WeaponFrag.Roll')
SWEP.HitSoundWorld	= Sound('GlassBottle.Break')
SWEP.HitSoundBody		= Sound('GlassBottle.Break')

SWEP.Icon				= 'octoteam/icons/bottle_empty.png'
SWEP.ViewModel			= Model('models/weapons/HL2meleepack/v_bottle.mdl')
SWEP.WorldModel		= Model('models/weapons/HL2meleepack/w_bottle.mdl')
SWEP.ActiveHoldType	= 'melee'

function SWEP:OnBulletShot()
	if SERVER then
		self:Remove()
		self.Owner:Give('weapon_octo_bottle_broken')
		self.Owner:SelectWeapon('weapon_octo_bottle_broken')
	end
end
