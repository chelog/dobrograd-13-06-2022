
function EFFECT:Init(data)

	local ent = data:GetEntity()
	if not IsValid(ent) then return end

	local Low, High = ent:WorldSpaceAABB()
	local Mid = ent:WorldSpaceCenter()

	local NumParticles = ent:BoundingRadius()
	NumParticles = NumParticles * 4

	NumParticles = math.Clamp(NumParticles, 32, 256)

	local emitter = ParticleEmitter(Mid)
	for i = 0, NumParticles do
		local vPos = Vector(math.Rand(Low.x, High.x), math.Rand(Low.y, High.y), math.Rand(Low.z, High.z))
		local particle = emitter:Add('effects/spark', vPos)
		if (particle) then
			particle:SetVelocity((vPos - Mid) * 15)
			particle:SetLifeTime(0)
			particle:SetDieTime(math.Rand(0.5, 1.5))
			particle:SetStartAlpha(math.Rand(200, 255))
			particle:SetEndAlpha(0)
			particle:SetStartSize(math.Rand(2, 3))
			particle:SetEndSize(0)
			particle:SetRoll(math.Rand(0, 360))
			particle:SetRollDelta(math.Rand(-10,10))

			particle:SetAirResistance(1000)
			particle:SetGravity(Vector(0, 0, 0))
			particle:SetCollide(true)
			particle:SetBounce(0.3)
		end
	end

	emitter:Finish()

end

function EFFECT:Think()

	return false

end

function EFFECT:Render()

	-- ???

end
