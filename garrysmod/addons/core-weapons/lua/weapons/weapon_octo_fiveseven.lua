SWEP.Base						= "weapon_octo_base_pistol"
SWEP.Category					= L.dobrograd
SWEP.Spawnable			= true
SWEP.AdminSpawnable		= false
SWEP.PrintName						= "FiveseveN"

if SERVER then

	AddCSLuaFile()

end

SWEP.Primary.Sound 				= Sound( "fiveseven.fire" )
SWEP.Primary.DistantSound 		= Sound( "fiveseven.fire-distant" )
SWEP.Primary.Damage				= 25
SWEP.Primary.RPM				= 500
SWEP.Primary.ClipSize			= 20
SWEP.Primary.DefaultClip = 0
SWEP.Primary.KickUp			 = 1
SWEP.Primary.KickDown		   = 0.3
SWEP.Primary.KickHorizontal	 = 0.03

SWEP.WorldModel					= "models/weapons/w_pist_fiveseven.mdl"
SWEP.AimPos = Vector(-10.5, -1.25, 3.92)
SWEP.AimAng = Angle(-2, 5, 0)
