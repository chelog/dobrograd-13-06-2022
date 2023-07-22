SWEP.PrintName = L.zombie
SWEP.Category		 = 'Other'
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = false
SWEP.CSMuzzleFlashes = false
SWEP.IconLetter			= 'J'

SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.HoldType = 'knife'
SWEP.Author = 'ErrolLiamP'
SWEP.Purpose = 'Kill Humans'
SWEP.Instructions = L.instruction_zombie

SWEP.ViewModel = ''
SWEP.WorldModel = ''

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = 'none'
SWEP.Primary.Delay = 1.6

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = 'none'

function SWEP:Think()

	if SERVER and CurTime() > (self.nextAutoMoan or 0) then
		self:SecondaryAttack()
		self.nextAutoMoan = CurTime() + math.random(30, 120)
	end

	if not self.NextHit or CurTime() < self.NextHit then return end
	self.NextHit = nil

	local pl = self.Owner

	local vStart = pl:EyePos() + Vector(0, 0, -10)
	local trace = util.TraceLine({start=vStart, endpos = vStart + pl:GetAimVector() * 71, filter = pl, mask = MASK_SHOT})

	local ent
	if trace.HitNonWorld then
		ent = trace.Entity
	elseif self.PreHit and self.PreHit:IsValid() and not (self.PreHit:IsPlayer() and not self.PreHit:Alive()) and self.PreHit:GetPos():Distance(vStart) < 110 then
		ent = self.PreHit
		trace.Hit = true
	end

	if SERVER then
		pl:EmitSound('npc/zombie/zombie_voice_idle'..math.random(1, 14)..'.wav')
		if trace.Hit then 
			pl:EmitSound('npc/zombie/claw_strike'..math.random(1, 3)..'.wav')
		else
			pl:EmitSound('npc/zombie/claw_miss'..math.random(1, 2)..'.wav')
		end
	end

	self.PreHit = nil

	if ent and ent:IsValid() and not (ent:IsPlayer() and not ent:Alive()) then
		local damage = 25
		local phys = ent:GetPhysicsObject()
		if phys:IsValid() and not ent:IsNPC() and phys:IsMoveable() then
			local vel = damage * 487 * pl:GetAimVector()

			phys:ApplyForceOffset(vel, (ent:NearestPoint(pl:GetShootPos()) + ent:GetPos() * 2) / 3)
			if ent.SetPhysicsAttacker then
				ent:SetPhysicsAttacker(pl)
			end

		end

		if SERVER then self:Damage(ent, damage, pl) end
	end

end

SWEP.NextSwing = 0
function SWEP:PrimaryAttack()

	if CurTime() < self.NextSwing then return end

	self.Owner:DoAnimationEvent(ACT_GMOD_GESTURE_RANGE_ZOMBIE)

	timer.Simple(1.4, function()
		if not IsValid(self) or not IsValid(self.Owner) then return end
	end)

	self.NextSwing = CurTime() + self.Primary.Delay
	self.NextHit = CurTime() + 1
	local vStart = self.Owner:EyePos() + Vector(0, 0, -10)
	local trace = util.TraceLine({start=vStart, endpos = vStart + self.Owner:GetAimVector() * 65, filter = self.Owner, mask = MASK_SHOT})
	if trace.HitNonWorld then
		self.PreHit = trace.Entity
	end
	
end

SWEP.NextMoan = 0
function SWEP:SecondaryAttack()

	if CurTime() < self.NextMoan then return end
	if SERVER then
		self.Owner:DoAnimation(ACT_GMOD_GESTURE_TAUNT_ZOMBIE)
		self.Owner:EmitSound('npc/zombie/zombie_voice_idle'..math.random(1, 14)..'.wav')
	end
	self.NextMoan = CurTime() + 3

end
