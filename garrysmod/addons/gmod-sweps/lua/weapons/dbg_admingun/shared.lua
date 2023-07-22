if SERVER then
	AddCSLuaFile()
end

SWEP.Base 			= "weapon_base"
SWEP.Category		= L.dobrograd
SWEP.PrintName		= L.admin_tool
SWEP.Instructions 	= L.instruction_admin_tool
SWEP.Slot			= 1
SWEP.SlotPos		= 9
SWEP.DrawAmmo		= false
SWEP.DrawCrosshair	= true
SWEP.ViewModelFlip	= false
SWEP.ViewModelFOV	= 62
SWEP.ViewModel		= ""
SWEP.WorldModel		= ""
SWEP.HoldType		= "normal"
SWEP.UseHands	   = true
SWEP.AutoSwitchTo	= false
SWEP.AutoSwitchFrom	= false
SWEP.Spawnable		= true
SWEP.AdminOnly		= true
SWEP.Author			= ""
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= "ЛКМ - вызвать админ-меню игрока\nПКМ - запретить игроку разговаривать\nR - переключить невидимость и бессмертие"
SWEP.UseHands		= true

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""


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
