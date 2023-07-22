if SERVER then
	AddCSLuaFile()
end

SWEP.Base 			= "weapon_octo_base"
SWEP.Category		= L.dobrograd
SWEP.PrintName		= 'Удочка'
SWEP.Instructions 	= 'ЛКМ - забросить\nПКМ - тянуть\nE по приманке - надеть приманку\nR - снять приманку'
SWEP.Slot			= 1
SWEP.SlotPos		= 9
SWEP.DrawAmmo		= false
SWEP.DrawCrosshair	= false
SWEP.ViewModelFlip	= false
SWEP.ViewModelFOV				= 62
SWEP.ViewModel					= "models/weapons/v_crowbar.mdl"
SWEP.WorldModel				= "models/fishingmod_custom/fishingrod_beta2.mdl"
SWEP.HoldType					= "revolver"
SWEP.UseHands					= true
SWEP.AutoSwitchTo				= false
SWEP.AutoSwitchFrom			= true
SWEP.Spawnable					= true
SWEP.AdminOnly					= false
SWEP.Author						= "Wani4ka (Otothorp Team)"
SWEP.Contact					= ""
SWEP.Purpose					= "Ловля рыбы"
SWEP.UseHands					= true
SWEP.Model						= 'models/fishingmod_custom/fishingrod_beta2.mdl'

SWEP.Primary.Ammo 			= 'none'
SWEP.Primary.ClipSize 		= -1
SWEP.Primary.DefaultCip 	= -1
SWEP.Primary.Automatic 		= false

SWEP.Secondary.ClipSize 	= -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic 	= false
SWEP.Secondary.Ammo 			= 'none'

SWEP.CanScare			  = false
SWEP.IsLethal = false
