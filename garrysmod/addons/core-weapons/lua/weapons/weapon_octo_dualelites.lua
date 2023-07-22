SWEP.Base						= "weapon_octo_base_pistol"
SWEP.Category					= L.dobrograd
SWEP.Spawnable			= true
SWEP.AdminSpawnable		= false
SWEP.PrintName						= "Dual Elites"

if SERVER then

	AddCSLuaFile()

end

SWEP.Primary.Sound 				= Sound( "elite.fire" )
SWEP.Primary.DistantSound 		= Sound( "elite.fire-distant" )
SWEP.Primary.Damage				= 25
SWEP.Primary.RPM				= 800
SWEP.Primary.ClipSize			= 30
SWEP.Primary.DefaultClip = 0
SWEP.Primary.KickUp				= 0.9
SWEP.Primary.KickDown			= 0.3
SWEP.Primary.KickHorizontal		= 1.4
SWEP.Primary.Spread 			= 0.06

SWEP.WorldModel					= "models/weapons/w_pist_elite.mdl"

SWEP.ActiveHoldType			 = "duel"
SWEP.ReloadTime 				= 2.5

SWEP.AimPos = Vector(-10.5, -2.85, 4.5)
SWEP.AimAng = Angle(0, 11, 0)
