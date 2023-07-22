if SERVER then AddCSLuaFile 'shared.lua' end

SWEP.PrintName = L.zombie_heal
SWEP.Author = 'chelog'
SWEP.DrawAmmo		   = true
SWEP.Slot = 2
SWEP.SlotPos = 0
SWEP.Contact = ''
SWEP.Purpose = ''
SWEP.Instructions = L.instruction_zombie_heal

SWEP.Spawnable = true
SWEP.AdminOnly = true
SWEP.Category = 'DarkRP (Utility)'

SWEP.ViewModel = 'models/weapons/c_medkit.mdl'
SWEP.WorldModel = 'models/weapons/w_medkit.mdl'
SWEP.UseHands = true

SWEP.Primary.Recoil = 0
SWEP.Primary.ClipSize = 200
SWEP.Primary.DefaultClip = 200
SWEP.Primary.Automatic  = true
SWEP.Primary.Delay = 0.1

SWEP.Secondary.Recoil = 0
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Delay = 0.3

function SWEP:PrimaryAttack()

	if CLIENT then return end -- yeah yeah fuck off, it's a swep for 1-day event
	self:SetNextPrimaryFire(CurTime() + 1)

	local ent = self.Owner:GetEyeTrace().Entity
	if IsValid(ent) and ent:GetClass() == 'prop_ragdoll' and ent:GetModel() == 'models/player/zombie_fast.mdl' and ent:GetPos():DistToSqr(self.Owner:GetPos()) < 10000 then
		local ply = ent:GetNetVar('RagdollOwner')
		if IsValid(ply) then ply.pendingZombie = nil end
		ent:Remove()

		self.Owner:EmitSound('hl1/fvox/boop.wav', 65, 50, 1, CHAN_AUTO)
		self:SetNextPrimaryFire(CurTime() + 3)
	end

end

function SWEP:SecondaryAttack()

	-- nothing

end
