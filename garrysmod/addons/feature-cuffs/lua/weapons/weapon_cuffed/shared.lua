if SERVER then
	AddCSLuaFile()
end

SWEP.Base = 'weapon_base'

SWEP.Category = 'Handcuffs'
SWEP.Author = 'Wani4ka'
SWEP.Instructions = 'Наслаждайся'

SWEP.Spawnable = false
SWEP.AdminOnly = false
SWEP.AdminSpawnable = false

SWEP.Slot = 5
SWEP.PrintName = L.handcuffed

SWEP.ViewModelFOV = 60
SWEP.Weight = 5
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.WorldModel = 'models/weapons/w_toolgun.mdl'
SWEP.ViewModel = 'models/weapons/c_arms_citizen.mdl'
SWEP.UseHands = true

SWEP.Primary.Recoil = 1
SWEP.Primary.Damage = 5
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0
SWEP.Primary.Delay = 1

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
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
SWEP.HoldType = 'passive'

SWEP.IsHandcuffs = true
SWEP.CuffType = ''

-- For anything that might try to drop this
SWEP.CanDrop = false
SWEP.PreventDrop = true

function SWEP:PrimaryAttack() end
function SWEP:SecondaryAttack() end
function SWEP:Reload() end

function SWEP:Holster()
	return false
end
