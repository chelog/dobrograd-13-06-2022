SWEP.Base						= "weapon_octo_base_pistol"
SWEP.Category					= L.dobrograd
SWEP.Spawnable			= true
SWEP.AdminSpawnable		= false
SWEP.PrintName						= "USP"

if SERVER then

	AddCSLuaFile()

end

SWEP.Primary.Sound 				= Sound( "usp.fire" )
SWEP.Primary.DistantSound 		= Sound( "usp.fire-distant" )
SWEP.Primary.Damage				= 25
SWEP.Primary.RPM				= 825
SWEP.Primary.ClipSize			= 12
SWEP.Primary.DefaultClip = 0
SWEP.Primary.KickUp			 = 0.42
SWEP.Primary.KickDown		   = 0.075
SWEP.Primary.KickHorizontal	 = 0.03

SWEP.WorldModel					= "models/weapons/w_pist_usp.mdl"
SWEP.AimPos = Vector(-10.5, -1.13, 4.05)
SWEP.AimAng = Angle(-2, 5, 0)
