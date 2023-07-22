SWEP.Base				= 'weapon_octo_base_cold'
SWEP.Category			= L.dobrograd .. ' - Холодное'
SWEP.Spawnable			= true
SWEP.AdminSpawnable	= false
SWEP.PrintName			= 'Кирка'

if SERVER then

	AddCSLuaFile()

end

SWEP.Primary.Ammo		= 'sharp'
SWEP.HitDistance		= 40
SWEP.HitInclination	= 0.4
SWEP.HitPushback		= 1000
SWEP.HitRate			= 1.35
SWEP.Damage				= {34, 50}
SWEP.ScareMultiplier	= 0.7

SWEP.SwingSound		= Sound('WeaponFrag.Roll')
SWEP.HitSoundWorld	= Sound('Canister.ImpactHard')
SWEP.HitSoundBody		= Sound('Flesh.ImpactHard')
SWEP.PushSoundBody	= Sound('Flesh.ImpactSoft')

SWEP.Icon				= 'octoteam/icons/pickaxe.png'
SWEP.ViewModel			= Model('models/weapons/HL2meleepack/v_pickaxe.mdl')
SWEP.WorldModel		= Model('models/weapons/HL2meleepack/w_pickaxe.mdl')
SWEP.ActiveHoldType	= 'melee2'
