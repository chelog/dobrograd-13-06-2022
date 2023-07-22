
function EFFECT:Init(data )

	self.Entity = data:GetEntity()
	self.Origin = data:GetOrigin()
	self.Attachment = data:GetAttachment()
	self.Forward = data:GetNormal()
	self.Scale = data:GetScale()
	-- print('1')
	if (!IsValid(self.Entity ) ) then return end
	-- print('2')


	self.Angle = self.Forward:Angle()
	self.Position = self:GetTracerShootPos(self.Origin, self.Entity, self.Attachment )

	-- if (self.Position == self.Origin ) then
		-- local att = self.Player:GetAttachment(self.Player:LookupAttachment('anim_attachment_RH' ) )
		-- if (att ) then self.Position = att.Pos + att.Ang:Forward() * -2 end
	-- end

	local teh_effect = ParticleEmitter(self.Entity:GetPos(), true )
	if (!teh_effect ) then return end

	for i = 1, 2 * self.Scale do
		local particle = teh_effect:Add('effects/splash2', self.Position )
		if (particle ) then
			local Spread = 0.08
			particle:SetVelocity(self.Entity:GetVelocity() + (Vector(math.sin(math.Rand(0, 360 ) ) * math.Rand(-Spread, Spread ), math.cos(math.Rand(0, 360 ) ) * math.Rand(-Spread, Spread ), math.sin(math.random() ) * math.Rand(-Spread, Spread ) ) + self.Forward ) * 800 )

			local ang = self.Angle
			if (i / 2 == math.floor(i / 2 ) ) then ang = (self.Forward * -2 ):Angle() end
			particle:SetAngles(ang )
			particle:SetDieTime(4 )
			particle:SetGravity(Vector(0,0,-400) )
			particle:SetColor(230, 230, 230 )
			particle:SetStartAlpha(255 )
			particle:SetEndAlpha(0 )
			particle:SetStartSize(8 )
			particle:SetEndSize(0 )
			particle:SetCollide(1)
			particle:SetCollideCallback(function(particleC, HitPos, normal )

				particleC:SetAngleVelocity(Angle(0, 0, 0 ) )
				particleC:SetVelocity(Vector(0, 0, 0 ) )
				particleC:SetPos(HitPos + normal * 0.1 )
				particleC:SetGravity(Vector(0, 0, 0 ) )

				for id, prop in pairs(ents.FindInSphere(HitPos, 15 ) ) do
					net.Start('testwaterthiss' )
						net.WriteEntity(prop )
					net.SendToServer()
				end

				local angles = normal:Angle()
				angles:RotateAroundAxis(normal, particleC:GetAngles().y )
				particleC:SetAngles(angles )

				particleC:SetLifeTime(0 )
				particleC:SetDieTime(10 )
				particleC:SetStartSize(8 )
				particleC:SetEndSize(0 )
				particleC:SetStartAlpha(128 )
				particleC:SetEndAlpha(0 )
			end )
		end
	end

	teh_effect:Finish()
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end
