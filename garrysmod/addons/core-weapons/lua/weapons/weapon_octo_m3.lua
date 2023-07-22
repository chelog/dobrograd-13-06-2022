SWEP.Base						= "weapon_octo_base_shotgun"
SWEP.Category					= L.dobrograd
SWEP.Spawnable			= true
SWEP.AdminSpawnable		= false
SWEP.PrintName						= "M3"

if SERVER then

	AddCSLuaFile()

end

SWEP.Primary.Sound 				= Sound( "m3.fire" )
SWEP.Primary.DistantSound 		= Sound( "m3.fire-distant" )
SWEP.Primary.Damage				= 13
SWEP.Primary.RPM				= 70
SWEP.Primary.ClipSize			= 7
SWEP.Primary.DefaultClip = 0
SWEP.Primary.KickUp			 = 5.28
SWEP.Primary.KickDown		   = 0.3
SWEP.Primary.KickHorizontal	 = 0.03
SWEP.Primary.Spread			 = 0.1
SWEP.Primary.Distance			= 1250

SWEP.WorldModel					= "models/weapons/w_shot_m3super90.mdl"
SWEP.AimPos = Vector(-5, -0.94, 4.6)
SWEP.AimAng = Angle(-9, 0, 0)

SWEP.Primary.NumShots			= 8
