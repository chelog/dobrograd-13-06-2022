SWEP.PrintName = L.keypad_cracker
SWEP.Category = L.dobrograd
SWEP.Slot = 4
SWEP.SlotPos = 1
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = true
SWEP.Author = 'chelog & Wani4ka'
SWEP.Instructions = L.instruction_keypad_cracker
SWEP.Contact = ''
SWEP.Purpose = ''
SWEP.ViewModel = Model('models/weapons/v_c4.mdl')
SWEP.WorldModel = Model('models/weapons/w_c4.mdl')

SWEP.Spawnable = true
SWEP.AdminOnly = true
SWEP.AnimPrefix = 'python'

SWEP.Sound = Sound('weapons/deagle/deagle-1.wav')

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ''

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ''

SWEP.IdleStance = 'slam'
SWEP.Icon = 'octoteam/icons/keypad_cracker.png'

function SWEP:Initialize()
	self:SetHoldType(self.IdleStance)
end

function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire(CurTime() + 0.4)
end

function SWEP:Holster()
	return true
end

function SWEP:Reload()
	return true
end
