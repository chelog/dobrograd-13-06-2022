SWEP.Base				= 'weapon_octo_base_cold'
SWEP.Category			= L.dobrograd .. ' - Холодное'
SWEP.Spawnable			= true
SWEP.AdminSpawnable	= false
SWEP.PrintName			= L.shovel

if SERVER then

	AddCSLuaFile()

end

SWEP.Primary.Ammo		= 'blunt'
SWEP.HitDistance		= 50
SWEP.HitInclination	= 0.4
SWEP.HitPushback		= 2000
SWEP.HitRate			= 1.25
SWEP.Damage				= {15, 25}
SWEP.ScareMultiplier	= 0.7

SWEP.SwingSound		= Sound('WeaponFrag.Roll')
SWEP.HitSoundWorld	= Sound('Canister.ImpactHard')
SWEP.HitSoundBody		= Sound('Flesh.ImpactHard')
SWEP.PushSoundBody	= Sound('Flesh.ImpactSoft')

SWEP.Icon				= 'octoteam/icons/shovel.png'
SWEP.ViewModel			= Model('models/weapons/HL2meleepack/v_shovel.mdl')
SWEP.WorldModel		= Model('models/weapons/HL2meleepack/w_shovel.mdl')
SWEP.ActiveHoldType	= 'melee2'
