SWEP.Base						= "weapon_octo_base_air"
SWEP.Category					= L.dobrograd
SWEP.Spawnable			= true
SWEP.AdminSpawnable		= false
SWEP.PrintName						= "Пневмат. P228"

if SERVER then

	AddCSLuaFile()

end

SWEP.Primary.RPM				= 400
SWEP.Primary.ClipSize			= 15
SWEP.Primary.DefaultClip = 0
SWEP.Primary.KickUp			 = 0.47
SWEP.Primary.KickDown		   = 0.15
SWEP.Primary.KickHorizontal	 = 0.01

SWEP.Primary.Automatic			= false

SWEP.PassiveHoldType 			= "normal"
SWEP.ActiveHoldType 			= "revolver"
SWEP.ReloadTime 				= 1.1

SWEP.WorldModel					= "models/weapons/w_pist_p228.mdl"
SWEP.AimPos = Vector(-10.5, -1.16, 4.15)
SWEP.AimAng = Angle(-2, 5, 0)
SWEP.Icon = 'octoteam/icons/gun_pistol.png'
