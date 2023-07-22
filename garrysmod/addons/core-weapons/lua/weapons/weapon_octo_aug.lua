SWEP.Base						= "weapon_octo_base_zoom"
SWEP.Category					= L.dobrograd
SWEP.Spawnable			= true
SWEP.AdminSpawnable		= false
SWEP.PrintName						= "AUG"

if SERVER then

	AddCSLuaFile()

end

SWEP.Primary.Sound 				= Sound( "aug.fire" )
SWEP.Primary.DistantSound 		= Sound( "aug.fire-distant" )
SWEP.Primary.Damage				= 26
SWEP.Primary.RPM				= 720
SWEP.Primary.ClipSize			= 30
SWEP.Primary.DefaultClip = 0
SWEP.Primary.KickUp			 = 0
SWEP.Primary.KickDown		   = 1.05
SWEP.Primary.KickHorizontal	 = 0.5
SWEP.Primary.Spread				= 0

SWEP.WorldModel					= "models/weapons/w_rif_aug.mdl"
SWEP.AimPos = Vector(-5, -0.68, 5.6)
SWEP.AimAng = Angle(-9, 0, 0)
SWEP.SightPos = Vector(-3.2, -0.67, 5.87)
SWEP.SightAng = Angle(0, -90, 100)
SWEP.SightSize = 1
SWEP.SightFOV = 18
