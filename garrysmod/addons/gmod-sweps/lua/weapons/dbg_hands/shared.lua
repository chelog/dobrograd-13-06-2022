if SERVER then
	AddCSLuaFile()
end

SWEP.Base 			= "weapon_base"
SWEP.Category		= L.dobrograd
SWEP.PrintName		= L.hands
SWEP.Instructions 	= L.instruction_hand
SWEP.Slot			= 1
SWEP.SlotPos		= 1
SWEP.DrawAmmo		= false
SWEP.DrawCrosshair	= true
SWEP.ViewModelFlip	= false
SWEP.ViewModelFOV	= 62
SWEP.ViewModel		= "models/weapons/v_crowbar.mdl"
SWEP.WorldModel		= "models/weapons/w_crowbar.mdl"
SWEP.HoldType		= "normal"
SWEP.UseHands	   = true
SWEP.AutoSwitchTo	= false
SWEP.AutoSwitchFrom	= false
SWEP.Spawnable		= true
SWEP.AdminOnly		= true
SWEP.Author			= ""
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= "ЛКМ - указать/тащить\nПКМ - боевая стойка\nR - переключить отображение прицела"
SWEP.Sound = "doors/door_latch3.wav"
SWEP.UseHands = true

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""

SWEP.doNotDrag = {
	func_breakable_surf = true,
	prop_door_rotating = true,
	func_door_rotating = true,
	func_door = true,
	func_breakable = true,
	gmod_sent_vehicle_fphysics_wheel = true,
}

function SWEP:SetupDataTables()

	self:NetworkVar( "Float", 0, "NextMeleeAttack" )

end

function SWEP:Initialize()

	self.Weapon:DrawShadow(false)
	self:SetHoldType(self.HoldType)

end

function SWEP:Holster()

	return true

end

function SWEP:Deploy()

	self:SetNextPrimaryFire( CurTime() + 0.5 )
	self:SetNextSecondaryFire( CurTime() + 0.5 )

end
