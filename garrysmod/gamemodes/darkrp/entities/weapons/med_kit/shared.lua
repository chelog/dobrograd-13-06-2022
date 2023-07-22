if SERVER then
	AddCSLuaFile("shared.lua")
end

SWEP.PrintName = L.medkit
SWEP.Author = "DarkRP Developers"
SWEP.DrawAmmo		   = true
SWEP.Slot = 2
SWEP.SlotPos = 0
SWEP.Description = "Heals the wounded."
SWEP.Contact = ""
SWEP.Purpose = ""
SWEP.Instructions = L.instruction_medkit

SWEP.Spawnable = true
SWEP.AdminOnly = true
SWEP.Category = "DarkRP (Utility)"

SWEP.ViewModel = "models/weapons/c_medkit.mdl"
SWEP.WorldModel = "models/weapons/w_medkit.mdl"
SWEP.UseHands = true

SWEP.Primary.Recoil = 0
SWEP.Primary.ClipSize = 200
SWEP.Primary.DefaultClip = 200
SWEP.Primary.Automatic  = true
SWEP.Primary.Delay = 0.1
SWEP.Primary.Ammo = "medkit"

SWEP.Secondary.Recoil = 0
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Delay = 0.3
SWEP.Secondary.Ammo = "medkit"

game.AddAmmoType({
	name = "medkit",
	dmgtype = DMG_GENERIC,
	tracer = TRACER_LINE,
	plydmg = 0,
	npcdmg = 0,
	force = 0,
	minsplash = 0,
	maxsplash = 0,
})

function SWEP:PrimaryAttack()

	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	if self:Clip1() <= 0 then return end

	local ply = self:GetOwner()

	ply:LagCompensation(true)
	local target = octolib.use.getTrace(ply).Entity
	ply:LagCompensation(false)
	if not (IsValid(target) and target:IsPlayer()) then return end

	local maxhealth = math.min(target:GetMaxHealth() or 100, ply:getJobTable().maxHealAmount or ply:isMedic() and 100 or 50)
	local health = target:Health()
	if health >= maxhealth then return end

	target:SetHealth(health + 1)
	self:EmitSound("hl1/fvox/boop.wav", 65, health / maxhealth * 100, 1, CHAN_AUTO)
	self:TakePrimaryAmmo(1)

end

function SWEP:SecondaryAttack()

	self:SetNextSecondaryFire(CurTime() + self.Secondary.Delay)
	if self:Clip1() <= 0 then return end

	local ply = self:GetOwner()
	if not IsValid(ply) then return end
	local maxhealth = math.min(ply:GetMaxHealth() or 100, ply:getJobTable().maxHealAmount or ply:isMedic() and 100 or 50)
	local health = ply:Health()
	if health >= maxhealth then return end

	ply:SetHealth(health + 1)
	self:EmitSound("hl1/fvox/boop.wav", 65, health / maxhealth * 100, 1, CHAN_AUTO)
	self:TakePrimaryAmmo(1)

end
