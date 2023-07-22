if SERVER then
	AddCSLuaFile()
end

SWEP.Base 			= 'weapon_base'
SWEP.Category		= L.dobrograd
SWEP.PrintName		= 'Собака'
SWEP.Instructions 	= 'ЛКМ - укусить\nПКМ - полаять'
SWEP.Slot			= 1
SWEP.SlotPos		= 1
SWEP.DrawAmmo		= false
SWEP.DrawCrosshair	= true
SWEP.ViewModelFlip	= false
SWEP.ViewModelFOV	= 62
SWEP.ViewModel		= Model('models/weapons/v_crowbar.mdl')
SWEP.WorldModel		= Model('models/weapons/w_crowbar.mdl')
SWEP.HoldType		= 'normal'
SWEP.AutoSwitchTo	= false
SWEP.AutoSwitchFrom	= false
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

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
end

function SWEP:Holster()
	return true
end

function SWEP:Deploy()
	self:SetNextPrimaryFire(CurTime() + 0.5)
	self:SetNextSecondaryFire(CurTime() + 0.5)
end
