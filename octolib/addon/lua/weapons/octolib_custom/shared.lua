if SERVER then
	AddCSLuaFile()
end

SWEP.Base 			= 'weapon_base'
SWEP.Category		= 'octolib'
SWEP.PrintName		= 'Кастомная модель'
SWEP.Instructions 	= ''
SWEP.Slot			= 0
SWEP.SlotPos		= 9
SWEP.DrawAmmo		= false
SWEP.DrawCrosshair	= false
SWEP.ViewModel		= ''
SWEP.Spawnable		= false
SWEP.AdminOnly		= false

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ''

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ''

SWEP.HoldType		= 'knife'
SWEP.WorldModel = 'models/props_lab/cleaver.mdl'
SWEP.WorldModelAtt = 'anim_attachment_rh'
SWEP.WorldModelPos = Vector(-3.1, -0.6, 0.1)
SWEP.WorldModelAng = Angle(-18.4, 0, 0)
SWEP.WorldModelScale = 1
SWEP.WorldModelSkin = 0
SWEP.WorldModelBodyGroups = {}
