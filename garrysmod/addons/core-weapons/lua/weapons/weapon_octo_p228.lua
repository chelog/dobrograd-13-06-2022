SWEP.Base						= "weapon_octo_base_pistol"
SWEP.Category					= L.dobrograd
SWEP.Spawnable			= true
SWEP.AdminSpawnable		= false
SWEP.PrintName						= "P228"

if SERVER then

	AddCSLuaFile()

end

SWEP.Primary.Sound 				= Sound( "p228.fire" )
SWEP.Primary.DistantSound 		= Sound( "p228.fire-distant" )
SWEP.Primary.Damage				= 30
SWEP.Primary.RPM				= 400
SWEP.Primary.ClipSize			= 15
SWEP.Primary.DefaultClip = 0
SWEP.Primary.KickUp			 = 0.95
SWEP.Primary.KickDown		   = 0.3
SWEP.Primary.KickHorizontal	 = 0.03

SWEP.WorldModel					= "models/weapons/w_pist_p228.mdl"
SWEP.AimPos = Vector(-10.5, -1.16, 4.15)
SWEP.AimAng = Angle(-2, 5, 0)
