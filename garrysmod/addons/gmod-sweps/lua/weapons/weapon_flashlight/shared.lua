
SWEP.PrintName = L.flashlight
SWEP.Category = L.dobrograd
SWEP.Author = "Paynamia + chelog"
SWEP.Contact = ""
SWEP.Purpose = ""
SWEP.Instructions = L.instruction_flashlight

SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.UseHands = true

SWEP.ViewModel = "models/weapons/c_flashlight_zm.mdl"
SWEP.WorldModel = "models/weapons/w_flashlight_zm.mdl"

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Damage = 10
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.Icon = 'octoteam/icons/flashlight.png'

SWEP.FlashColor = '255 255 255 255'

sound.Add({
	name = 'flashlight.toggle',
	channel = CHAN_WEAPON,
	volume = 0.8,
	sound = 'weapons/flashlight_toggle.ogg',
	pitch = {95, 105},
	level = 65,
})

function SWEP:Precache()

	util.PrecacheSound( "HL2Player.FlashLightOn" )

end

function SWEP:Initialize()

	self:SetHoldType( "pistol" )

end

function SWEP:SetupDataTables()

	self:NetworkVar( "Bool", 0, "Active" )
	self:NetworkVar( "Float", 1, "NextReload" )
	self:NetworkVar( "Float", 2, "NextPrimaryFire" )
	self:NetworkVar( "Float", 3, "NextSecondaryFire" )

end

function SWEP:Reload()

	-- keep calm and do nothing

end

function SWEP:SecondaryAttack()

	-- keep calm and do nothing

end

function SWEP:Think()

	-- keep calm and do nothing

end
