AddCSLuaFile('effects/fire_hose_effect.lua')

SWEP.PrintName = 'Пожарный рукав'
SWEP.Author = ''
SWEP.Category = 'Доброград'
SWEP.Contact = ''
SWEP.Purpose = ''
SWEP.Instructions = ''

SWEP.AutoSwitchTo = true
SWEP.AutoSwitchFrom = true

SWEP.Spawnable = true
SWEP.Slot		= 4
SWEP.SlotPos	= 4

SWEP.WorldModel = 'models/weapons/w_firehose.mdl'
SWEP.HoldType = 'shotgun'

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = ''

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ''

SWEP.effectScale = 20
SWEP.pushForce = 190

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
end

function SWEP:DoEffect()
	local effectData = EffectData()
	effectData:SetAttachment(1)
	effectData:SetEntity(self.Owner)
	effectData:SetOrigin(self.Owner:GetShootPos())
	effectData:SetNormal(self.Owner:GetAimVector())
	effectData:SetScale(self.effectScale)
	util.Effect('fire_hose_effect', effectData)
end

function SWEP:DoExtinguish()
	local tr = self.Owner:GetEyeTrace()
	local pos = tr.HitPos

	for id, prop in pairs(ents.FindInSphere(pos, 100)) do
		if not IsValid(prop) or prop:GetPos():Distance(self:GetPos()) > 256 then continue end
		if self.pushForce > 0 then
			local physobj = prop:GetPhysicsObject()
			if IsValid(physobj) then
				physobj:ApplyForceOffset(self.Owner:GetAimVector() * self.pushForce, pos)
			end
		end
		if SERVER and math.random(1, 100) <= 2 then
			local ok = hook.Call('DoExtinguish', nil, prop)
			if ok == true then continue end
			if prop:IsOnFire() then 
				prop:Extinguish()
				if math.random(1, 100) <= 10 then
					timer.Simple(math.random(1,7), function()
						prop:Ignite(math.random(300, 1200), 0)
					end)
				end
			end
		end
	end

	self:DoEffect()
end

function SWEP:PrimaryAttack()
	if self:GetNextPrimaryFire() > CurTime() then return end
	self:DoExtinguish()
	self:SetNextPrimaryFire(CurTime() + 0.01)
end

function SWEP:Think()
	if self.Owner:KeyPressed(IN_ATTACK) then
		self.Sound = CreateSound(self.Owner, Sound('weapons/extinguisher/fire1.wav'))
		self.Sound:Play()
	end

	if (self.Owner:KeyReleased(IN_ATTACK) or not self.Owner:KeyDown(IN_ATTACK)) and self.Sound then
		self.Sound:Stop()
		self.Sound = nil
	end
end


function SWEP:Deploy()
	return true
end

function SWEP:Holster()
	self:SetHoldType(self.HoldType)
	if self.Sound then
		self.Sound:Stop()
		self.Sound = nil
	end
	return true
end

function SWEP:OnDrop()
	if self.Sound then
		self.Sound:Stop()
		self.Sound = nil
	end
end

function SWEP:SecondaryAttack()
	-- snip
end

function SWEP:Reload()
	-- snip 
end
