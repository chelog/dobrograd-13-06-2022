SWEP.Base				= 'weapon_octo_base_cold'
SWEP.Category			= L.dobrograd .. ' - Холодное'
SWEP.Spawnable			= true
SWEP.AdminSpawnable	= false
SWEP.PrintName			= L.pan

if SERVER then

	AddCSLuaFile()

end

SWEP.Primary.Ammo		= 'blunt'
SWEP.HitDistance		= 40
SWEP.HitInclination	= 0.2
SWEP.HitPushback		= 300
SWEP.HitRate			= 1
SWEP.Damage				= {12, 18}
SWEP.ScareMultiplier	= 0.5

SWEP.SwingSound		= Sound('WeaponFrag.Roll')
SWEP.HitSoundWorld	= Sound('Metal_Box.ImpactHard')
SWEP.HitSoundBody		= Sound('Flesh.ImpactHard')

SWEP.Icon				= 'octoteam/icons/pan.png'
SWEP.ViewModel			= Model('models/weapons/HL2meleepack/v_pan.mdl')
SWEP.WorldModel		= Model('models/weapons/HL2meleepack/w_pan.mdl')
SWEP.ActiveHoldType	= 'melee'
