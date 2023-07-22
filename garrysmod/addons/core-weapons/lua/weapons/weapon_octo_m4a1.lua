SWEP.Base						= "weapon_octo_base_rifle"
SWEP.Category					= L.dobrograd
SWEP.Spawnable			= true
SWEP.AdminSpawnable		= false
SWEP.PrintName						= "M4A1"

if SERVER then

	AddCSLuaFile()

end

SWEP.Primary.Sound 				= Sound( "m4a1.fire" )
SWEP.Primary.DistantSound 		= Sound( "m4a1.fire-distant" )
SWEP.Primary.Damage				= 27
SWEP.Primary.RPM				= 750
SWEP.Primary.ClipSize			= 30
SWEP.Primary.DefaultClip = 0
SWEP.Primary.KickUp			 = 0
SWEP.Primary.KickDown		   = 0.66
SWEP.Primary.KickHorizontal	 = 0.64

SWEP.WorldModel					= "models/weapons/w_rif_m4a1.mdl"
SWEP.AimPos = Vector(-8, -0.97, 5.9)
SWEP.AimAng = Angle(-9, 0, 0)
