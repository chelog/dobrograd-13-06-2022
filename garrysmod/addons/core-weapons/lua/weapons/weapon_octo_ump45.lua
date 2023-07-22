SWEP.Base						= "weapon_octo_base_smg"
SWEP.Category					= L.dobrograd
SWEP.Spawnable			= true
SWEP.AdminSpawnable		= false
SWEP.PrintName						= "UMP45"

if SERVER then

	AddCSLuaFile()

end

SWEP.Primary.Sound 				= Sound( "ump45.fire" )
SWEP.Primary.DistantSound 		= Sound( "ump45.fire-distant" )
SWEP.Primary.Damage				= 23
SWEP.Primary.RPM				= 600
SWEP.Primary.ClipSize			= 25
SWEP.Primary.DefaultClip = 0
SWEP.Primary.KickUp			 = 0.1
SWEP.Primary.KickDown		   = 0.072
SWEP.Primary.KickHorizontal	 = 1


SWEP.WorldModel					= "models/weapons/w_smg_ump45.mdl"
SWEP.MuzzlePos = Vector(12, -0.9, 7)
SWEP.MuzzleAng = Angle(-9.5, 0, 0)
SWEP.AimPos = Vector(-7, -0.8, 5.4)
SWEP.AimAng = Angle(-9.5, 0, 0)

SWEP.ActiveHoldType			 = "smg"
