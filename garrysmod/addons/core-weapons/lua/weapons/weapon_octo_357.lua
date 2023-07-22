SWEP.Base						= "weapon_octo_base_pistol"
SWEP.Category					= L.dobrograd
SWEP.Spawnable			= true
SWEP.AdminSpawnable		= false
SWEP.PrintName						= "Colt .357"

if SERVER then

	AddCSLuaFile()

end

SWEP.Primary.Sound 				= Sound("revolver.fire")
SWEP.Primary.DistantSound 		= Sound("revolver.fire-distant")
SWEP.Primary.Damage				= 34
SWEP.Primary.RPM				= 300
SWEP.Primary.ClipSize			= 6
SWEP.Primary.DefaultClip = 0
SWEP.Primary.KickUp				= 3.24
SWEP.Primary.KickDown			= 0.72
SWEP.Primary.KickHorizontal		= 0.02

SWEP.WorldModel					= "models/weapons/w_357.mdl"
SWEP.MuzzlePos = Vector(12, -0.8, 4.7)
SWEP.MuzzleAng = Angle(-4, -0.5, 4)
SWEP.AimPos = Vector(-10.5, -0.79, 4.6)
SWEP.AimAng = Angle(-4, -0.5, 4)
