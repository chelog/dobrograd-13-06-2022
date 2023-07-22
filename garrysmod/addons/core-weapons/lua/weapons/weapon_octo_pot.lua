SWEP.Base				= 'weapon_octo_base_cold'
SWEP.Category			= L.dobrograd .. ' - Холодное'
SWEP.Spawnable			= true
SWEP.AdminSpawnable	= false
SWEP.PrintName			= L.pot

if SERVER then

	AddCSLuaFile()

end

SWEP.Primary.Ammo		= 'blunt'
SWEP.HitDistance		= 40
SWEP.HitInclination	= 0.2
SWEP.HitPushback		= 200
SWEP.HitRate			= 0.90
SWEP.Damage				= {10, 15}
SWEP.ScareMultiplier	= 0.4

SWEP.SwingSound		= Sound('WeaponFrag.Roll')
SWEP.HitSoundWorld	= Sound('Metal_Box.ImpactHard')
SWEP.HitSoundBody		= Sound('Flesh.ImpactHard')

SWEP.Icon				= 'octoteam/icons/pot.png'
SWEP.ViewModel			= Model('models/weapons/HL2meleepack/v_pot.mdl')
SWEP.WorldModel		= Model('models/weapons/HL2meleepack/w_pot.mdl')
SWEP.ActiveHoldType	= 'melee'
