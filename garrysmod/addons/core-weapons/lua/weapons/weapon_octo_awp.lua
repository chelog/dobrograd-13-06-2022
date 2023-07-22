SWEP.Base						= "weapon_octo_base_sniper"
SWEP.Category					= L.dobrograd
SWEP.Spawnable			= true
SWEP.AdminSpawnable		= false
SWEP.PrintName						= "AWP"

if SERVER then

	AddCSLuaFile()

end

SWEP.Primary.Sound 				= Sound( "awp.fire" )
SWEP.Primary.DistantSound 		= Sound( "awp.fire-distant" )
SWEP.Primary.Damage				= 50
SWEP.Primary.RPM				= 50
SWEP.Primary.ClipSize			= 10
SWEP.Primary.DefaultClip = 0
SWEP.Primary.KickUp				= 6.7
SWEP.Primary.KickDown			= 1.2
SWEP.Primary.KickHorizontal		= 0.02
SWEP.Primary.Spread				= 0
SWEP.ZoomAmount = 50

SWEP.WorldModel					= "models/weapons/w_snip_awp.mdl"
SWEP.AimPos = Vector(-3, -0.8, 6.5)
SWEP.AimAng = Angle(-9, 0, 0)
SWEP.SightPos = Vector(-0.52, -0.78, 6.88)
SWEP.SightAng = Angle(0, -90, 100)
SWEP.SightSize = 1.6
SWEP.SightFOV = 10
SWEP.SightZNear = 12
