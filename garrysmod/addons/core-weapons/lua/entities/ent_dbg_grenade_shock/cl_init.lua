include('shared.lua')

function ENT:Think()

	if not IsValid(self.em) then return end
	if not self:GetNetVar('exploded') then
		return self.BaseClass.Think(self)
	end

	if LocalPlayer():EyePos():DistToSqr(self:GetPos()) <= 4000000 then
		self:SetNoDraw(true)
		local p = self.em:Add(string.format('particle/smokesprites_00%02d', math.random(1,10)), self:GetPos())
		if p then
			local dir = VectorRand() + Vector(0, 0, 0.4)
			p:SetVelocity(dir * 100)
			p:SetDieTime(math.Rand(6, 8))
			p:SetStartAlpha(math.Rand(100, 150))
			p:SetEndAlpha(0)
			p:SetStartSize(math.Rand(20, 50))
			p:SetEndSize(math.Rand(100, 150))
			p:SetRoll(math.Rand(0, 360))
			p:SetRollDelta(math.Rand(-0.5, 0.5))
			local col = math.Rand(135, 145)
			p:SetColor(col, col, col)
			p:SetAirResistance(200)
			p:SetGravity(dir * math.random(50, 75))
			p:SetCollide(true)
		end
	end

	self:SetNextClientThink(CurTime() + 0.2)
	return true

end