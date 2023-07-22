SWEP.Base						= "weapon_octo_base_sniper"
SWEP.Category					= L.dobrograd
SWEP.Spawnable			= true
SWEP.AdminSpawnable		= false
SWEP.PrintName						= "Scout"

if SERVER then

	AddCSLuaFile()

end

SWEP.Primary.Sound 				= Sound( "scout.fire" )
SWEP.Primary.DistantSound 		= Sound( "scout.fire-distant" )
SWEP.Primary.Damage				= 35
SWEP.Primary.RPM				= 60
SWEP.Primary.ClipSize			= 10
SWEP.Primary.DefaultClip = 0
SWEP.Primary.KickUp				= 6.7
SWEP.Primary.KickDown			= 1.2
SWEP.Primary.KickHorizontal		= 0.02
SWEP.Primary.Spread				= 0

SWEP.WorldModel					= "models/weapons/w_snip_scout.mdl"
SWEP.AimPos = Vector(-0.5, -0.98, 5.8)
SWEP.AimAng = Angle(-9, 0, 0)
SWEP.SightPos = Vector(1.6, -0.99, 6.17)
SWEP.SightAng = Angle(0, -90, 100)
SWEP.SightSize = 1.3
SWEP.SightFOV = 10
SWEP.SightZNear = 12
