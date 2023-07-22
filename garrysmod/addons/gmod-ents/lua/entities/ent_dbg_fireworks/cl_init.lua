include 'shared.lua'

function ENT:Initialize()

	self.em = ParticleEmitter(Vector())

end

function ENT:Think()
	
	local e = self.em
	if self:GetNetVar('working') and IsValid(e) then
		local p = e:Add('effects/spark', self:LocalToWorld(Vector(0, 0, 8)))
		p:SetDieTime(0.1)
		p:SetStartAlpha(255)
		p:SetEndAlpha(0)
		p:SetStartSize(2)
		p:SetEndSize(0)
		p:SetVelocity((VectorRand() + self:GetUp()) * 40)
	end

	self:NextThink(CurTime() + 0.1)
	return true

end

function ENT:OnRemove()

	local e = self.em
	if IsValid(e) then e:Finish() end

end
