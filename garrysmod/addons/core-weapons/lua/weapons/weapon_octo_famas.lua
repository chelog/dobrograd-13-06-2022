SWEP.Base						= "weapon_octo_base_rifle"
SWEP.Category					= L.dobrograd
SWEP.Spawnable			= true
SWEP.AdminSpawnable		= false
SWEP.PrintName						= "FAMAS"

if SERVER then

	AddCSLuaFile()

end

SWEP.Primary.Sound 				= Sound( "famas.fire" )
SWEP.Primary.DistantSound 		= Sound( "famas.fire-distant" )
SWEP.Primary.Damage				= 22
SWEP.Primary.RPM				= 950
SWEP.Primary.ClipSize			= 30
SWEP.Primary.DefaultClip = 0
SWEP.Primary.KickUp			 = 0
SWEP.Primary.KickDown		   = 1.05
SWEP.Primary.KickHorizontal	 = 0.5

SWEP.WorldModel					= "models/weapons/w_rif_famas.mdl"
SWEP.MuzzlePos = Vector(20, -1, 7.4)
SWEP.MuzzleAng = Angle(-8, 0, 0)
SWEP.AimPos = Vector(-6, -0.91, 7.6)
SWEP.AimAng = Angle(-8, 0, 0)
