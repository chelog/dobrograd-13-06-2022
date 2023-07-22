if SERVER then
	AddCSLuaFile()
end

SWEP.Base = 'weapon_base'

SWEP.Category = 'Handcuffs'
SWEP.Author = 'Wani4ka'
SWEP.Instructions = ''

SWEP.Spawnable = false
SWEP.AdminOnly = false
SWEP.AdminSpawnable = false

SWEP.Slot = 5
SWEP.PrintName = 'Handcuffs'

SWEP.ViewModelFOV = 60
SWEP.Weight = 5
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.WorldModel = 'models/props_junk/cardboard_box004a.mdl'
SWEP.ViewModel = 'models/weapons/c_bugbait.mdl'
SWEP.UseHands = true

SWEP.Primary.Recoil = 1
SWEP.Primary.Damage = 5
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0
SWEP.Primary.Delay = 0.25

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = 'none'
SWEP.Primary.ClipMax = -1

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = 'none'
SWEP.Secondary.ClipMax = -1

SWEP.DeploySpeed = 1.5

SWEP.PrimaryAnim = ACT_VM_PRIMARYATTACK
SWEP.ReloadAnim = ACT_VM_RELOAD

SWEP.CuffTime = 1.0
SWEP.CuffSound = Sound('buttons/lever7.wav')

SWEP.CuffMaterial = 'phoenix_storms/metalfloor_2-3'
SWEP.CuffRope = 'cable/cable2'

SWEP.RopeLength = 0

SWEP.CuffReusable = false -- Can reuse (ie, not removed on use)
SWEP.CuffRecharge = 30 -- Time before re-use

SWEP.RemoveTime = 10

SWEP.CanBlind = false
SWEP.CanGag = false

function SWEP:Initialize()
	self:SetHoldType('slam')
	if SERVER then
		self:SetNetVar('RopeLength', self.RopeLength)
	end
end
function SWEP:SecondaryAttack() end
function SWEP:Reload() end
