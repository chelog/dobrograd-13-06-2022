include('shared.lua')

function ENT:Initialize()

	self.em = ParticleEmitter(Vector())

end

function ENT:Think()

	if self.FlameEffect then
		local e = self.em
		if IsValid(e) then
			local p = e:Add(self.FlameEffect, self:LocalToWorld(self.FlamePos))
			p:SetDieTime(self.FlameDieTime)
			p:SetStartAlpha(self.FlameAlpha)
			p:SetEndAlpha(0)
			p:SetStartSize(self.FlameSize)
			p:SetEndSize(0)
			p:SetVelocity((VectorRand() - self:GetForward()) * 40)
		end
	end

	self:NextThink(CurTime() + 0.1)
	return true

end

function ENT:OnRemove()

	local e = self.em
	timer.Simple(1, function()
		if IsValid(e) then e:Finish() end
	end)

end

netstream.Hook('throwable.explode', function(ent, pos)
	if IsValid(ent) and ent.ExplodeEffect then
		ent:ExplodeEffect(pos or ent:GetPos())
	end
end)
