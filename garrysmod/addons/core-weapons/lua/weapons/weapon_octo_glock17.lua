SWEP.Base						= "weapon_octo_base_pistol"
SWEP.Category					= L.dobrograd
SWEP.Spawnable			= true
SWEP.AdminSpawnable		= false
SWEP.PrintName						= "Glock 17"

if SERVER then

	AddCSLuaFile()

end

SWEP.Primary.Sound 				= Sound( "glock18.fire" )
SWEP.Primary.DistantSound 		= Sound( "glock18.fire-distant" )
SWEP.Primary.Damage				= 26
SWEP.Primary.RPM				= 825
SWEP.Primary.ClipSize			= 17
SWEP.Primary.DefaultClip = 0
SWEP.Primary.KickUp			 = 1.2
SWEP.Primary.KickDown		   = 0.3
SWEP.Primary.KickHorizontal	 = 0.03
SWEP.Primary.Spread			 = 0.02

SWEP.WorldModel					= "models/weapons/w_pist_glock18.mdl"
SWEP.AimPos = Vector(-10.5, -1.23, 4)
SWEP.AimAng = Angle(-2, 5, 0)
