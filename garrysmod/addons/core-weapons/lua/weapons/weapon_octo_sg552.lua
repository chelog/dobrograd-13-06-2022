SWEP.Base						= "weapon_octo_base_zoom"
SWEP.Category					= L.dobrograd
SWEP.Spawnable			= true
SWEP.AdminSpawnable		= false
SWEP.PrintName						= "SG552"

if SERVER then

	AddCSLuaFile()

end

SWEP.Primary.Sound 				= Sound( "sg552.fire" )
SWEP.Primary.DistantSound 		= Sound( "sg552.fire-distant" )
SWEP.Primary.Damage				= 28
SWEP.Primary.RPM				= 690
SWEP.Primary.ClipSize			= 30
SWEP.Primary.DefaultClip = 0
SWEP.Primary.KickUp			 = 0
SWEP.Primary.KickDown		   = 0.55
SWEP.Primary.KickHorizontal	 = 0.9
SWEP.Primary.Spread				= 0

SWEP.WorldModel					= "models/weapons/w_rif_sg552.mdl"
SWEP.AimPos = Vector(-4, -0.89, 5.6)
SWEP.AimAng = Angle(-9, 0, 0)
SWEP.SightPos = Vector(-0.8, -0.89, 6.2)
SWEP.SightAng = Angle(0, -90, 100)
SWEP.SightSize = 1.4
SWEP.SightFOV = 18
