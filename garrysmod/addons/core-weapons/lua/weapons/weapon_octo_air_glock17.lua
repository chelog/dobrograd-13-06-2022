SWEP.Base						= "weapon_octo_base_air"
SWEP.Category					= L.dobrograd
SWEP.Spawnable			= true
SWEP.AdminSpawnable		= false
SWEP.PrintName						= "Пневмат. Glock 17"

if SERVER then

	AddCSLuaFile()

end

SWEP.Primary.RPM				= 825
SWEP.Primary.ClipSize			= 17
SWEP.Primary.DefaultClip = 0
SWEP.Primary.KickUp			 = 1.2
SWEP.Primary.KickDown		   = 0.3
SWEP.Primary.KickHorizontal	 = 0.03
SWEP.Primary.Spread			 = 0.02
SWEP.Primary.Automatic			= false

SWEP.PassiveHoldType 			= "normal"
SWEP.ActiveHoldType 			= "revolver"
SWEP.ReloadTime 				= 2.5

SWEP.WorldModel					= "models/weapons/w_pist_glock18.mdl"
SWEP.Icon = 'octoteam/icons/gun_pistol.png'
SWEP.AimPos = Vector(-10.5, -1.19, 4)
SWEP.AimAng = Angle(-2, 5, 0)
