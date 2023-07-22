SWEP.Base						= "weapon_octo_base_rifle"
SWEP.Category					= L.dobrograd
SWEP.Spawnable			= true
SWEP.AdminSpawnable		= false
SWEP.PrintName						= "Galil"

if SERVER then

	AddCSLuaFile()

end

SWEP.Primary.Sound 				= Sound( "galil.fire" )
SWEP.Primary.DistantSound 		= Sound( "galil.fire-distant" )
SWEP.Primary.Damage				= 20
SWEP.Primary.RPM				= 750
SWEP.Primary.ClipSize			= 25
SWEP.Primary.DefaultClip = 0
SWEP.Primary.KickUp				= 0
SWEP.Primary.KickDown			= 1.27
SWEP.Primary.KickHorizontal		= 0.8

SWEP.WorldModel					= "models/weapons/w_rif_galil.mdl"
SWEP.MuzzlePos = Vector(25, -1, 8.2)
SWEP.MuzzleAng = Angle(-10, 0, 0)
SWEP.AimPos = Vector(-4, -0.75, 5.6)
SWEP.AimAng = Angle(-10, 0, 0)
