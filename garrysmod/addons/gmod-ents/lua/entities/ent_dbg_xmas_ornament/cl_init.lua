include "shared.lua"

netstream.Hook('ornament.sparkles', function(pos, color)

	local emitter = ParticleEmitter(pos)
	for i = 1, 20 do
		local dir = VectorRand()
		local particle = emitter:Add("particle/fire", pos + dir * 1)
		if particle then
			particle:SetColor(color.r, color.g, color.b)

			particle:SetVelocity(dir * (50 + math.random(0, 30)))
			particle:SetDieTime(math.random(5,10) / 2)
			particle:SetLifeTime(0)

			particle:SetAngles(AngleRand())
			particle:SetStartSize(5)
			particle:SetEndSize(0)

			particle:SetStartAlpha(255)
			particle:SetEndAlpha(0)

			particle:SetAirResistance(100)
			particle:SetCollide(true)
		end
	end

	timer.Simple(6, function() emitter:Finish() end)

end)
