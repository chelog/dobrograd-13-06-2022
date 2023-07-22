SWEP.Base						= "weapon_octo_base_zoom"
SWEP.Category					= L.dobrograd
SWEP.Spawnable			= true
SWEP.AdminSpawnable		= false
SWEP.PrintName						= "G3SG1"

if SERVER then

	AddCSLuaFile()

end

SWEP.Primary.Sound 				= Sound( "g3sg1.fire" )
SWEP.Primary.DistantSound 		= Sound( "g3sg1.fire-distant" )
SWEP.Primary.Damage				= 35
SWEP.Primary.RPM				= 450
SWEP.Primary.ClipSize			= 20
SWEP.Primary.DefaultClip = 0
SWEP.Primary.KickUp				= 2
SWEP.Primary.KickDown			= 0.3
SWEP.Primary.KickHorizontal		= 0.03
SWEP.Primary.Spread				= 0

SWEP.WorldModel					= "models/weapons/w_snip_g3sg1.mdl"
SWEP.AimPos = Vector(-6.2, -0.94, 6.7)
SWEP.AimAng = Angle(-9, 0, 0)
SWEP.SightPos = Vector(-3.6, -0.94, 6.98)
SWEP.SightAng = Angle(0, -90, 100)
SWEP.SightSize = 1.6
SWEP.SightFOV = 12
