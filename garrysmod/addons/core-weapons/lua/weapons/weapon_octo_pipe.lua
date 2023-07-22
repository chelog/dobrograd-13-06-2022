SWEP.Base				= 'weapon_octo_base_cold'
SWEP.Category			= L.dobrograd .. ' - Холодное'
SWEP.Spawnable			= true
SWEP.AdminSpawnable	= false
SWEP.PrintName			= 'Труба'

if SERVER then

	AddCSLuaFile()

end

SWEP.Primary.Ammo		= 'blunt'
SWEP.HitDistance		= 45
SWEP.HitInclination	= 0.2
SWEP.HitPushback		= 400
SWEP.HitRate			= 1.1
SWEP.Damage				= {34, 50}
SWEP.ScareMultiplier	= 0.4

SWEP.SwingSound		= Sound('WeaponFrag.Roll')
SWEP.HitSoundWorld	= Sound('Canister.ImpactHard')
SWEP.HitSoundBody		= Sound('Flesh.ImpactHard')

SWEP.Icon				= 'octoteam/icons/pipe.png'
SWEP.ViewModel			= Model('models/weapons/HL2meleepack/v_pipe.mdl')
SWEP.WorldModel		= Model('models/props_canal/mattpipe.mdl')
SWEP.ActiveHoldType	= 'melee2'
