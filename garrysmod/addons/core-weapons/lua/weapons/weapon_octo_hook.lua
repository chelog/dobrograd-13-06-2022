SWEP.Base				= 'weapon_octo_base_cold'
SWEP.Category			= L.dobrograd .. ' - Холодное'
SWEP.Spawnable			= true
SWEP.AdminSpawnable	= false
SWEP.PrintName			= L.hook

if SERVER then

	AddCSLuaFile()

end

SWEP.Primary.Ammo		= 'sharp'
SWEP.HitDistance		= 50
SWEP.HitInclination	= 0.4
SWEP.HitPushback		= -1000
SWEP.HitRate			= 1.25
SWEP.Damage				= {34, 50}
SWEP.ScareMultiplier	= 0.7

SWEP.SwingSound		= Sound('WeaponFrag.Roll')
SWEP.HitSoundWorld	= Sound('Canister.ImpactHard')
SWEP.HitSoundBody		= Sound('Flesh.Break')
SWEP.PushSoundBody	= Sound('Flesh.ImpactSoft')

SWEP.Icon				= 'octoteam/icons/crowbar.png'
SWEP.ViewModel			= Model('models/weapons/HL2meleepack/v_hook.mdl')
SWEP.WorldModel		= Model('models/weapons/HL2meleepack/w_hook.mdl')
SWEP.ActiveHoldType	= 'melee'
