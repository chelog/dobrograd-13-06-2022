SWEP.Base						= "weapon_octo_base_smg"
SWEP.Category					= L.dobrograd
SWEP.Spawnable			= true
SWEP.AdminSpawnable		= false
SWEP.PrintName						= "MP5"

if SERVER then

	AddCSLuaFile()

end

SWEP.Primary.Sound 				= Sound( "mp5navy.fire" )
SWEP.Primary.DistantSound 		= Sound( "mp5navy.fire-distant" )
SWEP.Primary.Damage				= 18
SWEP.Primary.RPM				= 800
SWEP.Primary.ClipSize			= 30
SWEP.Primary.DefaultClip = 0
SWEP.Primary.KickUp			 = 0.3
SWEP.Primary.KickDown		   = 0.63
SWEP.Primary.KickHorizontal	 = 0.7


SWEP.WorldModel					= "models/weapons/w_smg_mp5.mdl"
SWEP.MuzzlePos = Vector(12, -0.6, 7.5)
SWEP.MuzzleAng = Angle(-7.5, 2.2, 0)
SWEP.AimPos = Vector(-7, -1.38, 7.4)
SWEP.AimAng = Angle(-7.5, 2.2, 0)

SWEP.ActiveHoldType			 = "smg"
