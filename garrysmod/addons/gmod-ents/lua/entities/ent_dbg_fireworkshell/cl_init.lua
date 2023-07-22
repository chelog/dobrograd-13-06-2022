include 'shared.lua'

function ENT:Initialize()

	self.em = ParticleEmitter(Vector())

end

function ENT:Think()

	local e = self.em
	if IsValid(e) then
		local p = e:Add('effects/spark', self:GetPos())
		p:SetDieTime(0.1)
		p:SetStartAlpha(255)
		p:SetEndAlpha(0)
		p:SetStartSize(2)
		p:SetEndSize(0)
		p:SetVelocity((VectorRand() - self:GetForward()) * 40)
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

function ENT:Draw()

	-- nothing

end

local function getGlowAmp(finish, time)
	local st = (finish - CurTime()) / time
	if st > 0.9 then
		return 0.27 + (st - 0.9) * 9
	else
		return st * 0.3
	end
end

local types = {
	{3, function(e, pos) -- default
		local col = HSVToColor(math.random(0, 359), 0.75, 1)
		local size = math.random(500, 1000)
		local time = 2
		local g = e:Add('sprites/light_glow02_add', pos)
		g:SetDieTime(time)
		g:SetStartAlpha(255)
		g:SetEndAlpha(0)
		g:SetStartSize(size)
		g:SetEndSize(size)
		g:SetGravity(Vector(0,0,0))
		g:SetColor(col.r * 0.3, col.g * 0.3, col.b * 0.3)

		local dieTime = CurTime() + time
		g:SetNextThink(CurTime())
		g:SetThinkFunction(function(self)
			if not IsValid(e) then return end

			local c = getGlowAmp(dieTime, time)
			self:SetColor(col.r * c, col.g * c, col.b * c)
			self:SetNextThink(CurTime())
		end)

		for i = 1, 20 do
			local p = e:Add('sprites/light_glow02_add', pos)
			p:SetDieTime(3 + math.Rand(0, 2))
			p:SetStartAlpha(255)
			p:SetEndAlpha(0)
			p:SetStartSize(8)
			p:SetStartLength(20)
			p:SetEndSize(3)
			p:SetEndLength(2)
			p:SetGravity(Vector(0,0,-100))
			p:SetAirResistance(100)
			p:SetVelocity(VectorRand() * 500)
			p:SetColor(col.r, col.g, col.b)
		end
	end},
	{2, function(e, pos) -- sparkled
		local g = e:Add('sprites/light_glow02_add', pos)
		g:SetDieTime(1)
		g:SetStartAlpha(255)
		g:SetEndAlpha(0)
		g:SetStartSize(math.random(750, 1250))
		g:SetEndSize(0)
		g:SetGravity(Vector(0,0,0))
		g:SetColor(30, 30, 20)

		for i = 1, 20 do
			local lifeTime = math.Rand(1, 1.5)
			local p = e:Add('sprites/light_glow02_add', pos)
			p:SetDieTime(lifeTime)
			p:SetStartAlpha(255)
			p:SetEndAlpha(0)
			p:SetStartSize(5)
			p:SetEndSize(3)
			p:SetGravity(Vector(0,0,-100))
			p:SetAirResistance(100)
			p:SetVelocity(VectorRand() * 500)
			p:SetColor(255, 255, 220)

			local sparkleEnd = CurTime() + lifeTime
			p:SetNextThink(CurTime() + 0.03)
			p:SetThinkFunction(function(self)
				if not IsValid(e) then return end

				local st = (sparkleEnd - CurTime()) / lifeTime
				local p = e:Add('effects/spark', self:GetPos())
				p:SetDieTime(0.3 + 0.1*st)
				p:SetStartAlpha(255 * st)
				p:SetEndAlpha(0)
				p:SetStartSize(2 + 1*st)
				p:SetEndSize(0)
				p:SetVelocity(VectorRand() * (60 + 40*st) - self:GetVelocity() * 0.5)

				self:SetNextThink(CurTime() + 0.03)
			end)
		end
	end},
}

netstream.Hook('dbg-fireworks.explode', function(pos)

	local e = ParticleEmitter(Vector())
	if IsValid(e) then
		local func = octolib.array.randomWeighted(types)
		if func then func(e, pos) end
	end

	timer.Simple(5, function()
		if IsValid(e) then e:Finish() end
	end)

end)
