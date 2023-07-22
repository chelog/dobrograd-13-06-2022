SWEP.Base						= "weapon_octo_base_shotgun"
SWEP.Category					= L.dobrograd
SWEP.Spawnable			= true
SWEP.AdminSpawnable		= false
SWEP.PrintName						= "XM1014"

if SERVER then
	AddCSLuaFile()
end

SWEP.Primary.Sound 				= Sound( "xm1014.fire" )
SWEP.Primary.DistantSound 		= Sound( "xm1014.fire-distant" )
SWEP.Primary.Damage				= 15
SWEP.Primary.RPM				= 200
SWEP.Primary.ClipSize			= 7
SWEP.Primary.DefaultClip = 0
SWEP.Primary.KickUp			 = 5.28
SWEP.Primary.KickDown		   = 0.3
SWEP.Primary.KickHorizontal	 = 0.03
SWEP.Primary.Spread			 = 0.1
SWEP.Primary.Distance			= 1250

SWEP.WorldModel					= "models/weapons/w_shot_xm1014.mdl"
SWEP.AimPos = Vector(-5, -0.8, 4.2)
SWEP.AimAng = Angle(-9, 0, 0)

SWEP.Primary.NumShots			= 8
