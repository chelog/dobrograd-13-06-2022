AddCSLuaFile('cl_init.lua')
AddCSLuaFile('shared.lua')
include('shared.lua')

function ENT:Initialize()

	local half = Vector(1.5, 0.5, 0.5)
	self:SetModel(self.Model)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_INTERACTIVE)

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		if self.Mass then phys:SetMass(self.Mass) end
		phys:Wake()
	end

	local sd = self.SoundFlame
	if sd and sd[1] then
		local s = CreateSound(self, sd[1])
		s:SetSoundLevel(sd[2])
		s:PlayEx(sd[4], sd[3])
		self.sndFlame = s
	end

	if not self.ExplodeAfterCollision then
		timer.Simple(self.LifeTime, function()
			if IsValid(self) then self:Explode() end
		end)
	end

end

function ENT:Throw(ply, forceMul)

	if not IsValid(ply) then return end

	local force = self.ThrowForce * forceMul
	local pos, ang, vel = ply:GetBonePosition(ply:LookupBone('ValveBiped.Bip01_L_Hand') or 16)
	local tr = util.TraceLine { start = ply:GetShootPos(), endpos = pos, filter = ply }
	if tr.Hit then
		pos = tr.HitPos + tr.HitNormal * 5
		vel = tr.HitNormal * force * 0.4
	else
		vel = ply:GetAimVector()
		-- vel.z = 0
		vel = (vel + VectorRand() * math.random() * 0.1) * force
	end

	self:SetPos(pos)
	self:SetAngles(ang)
	self.LifeTime = self.LifeTime * math.Rand(0.8, 1.2)

	self:Spawn()
	self:Activate()
	self.owner = ply
	ply:LinkEntity(self)

	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:Wake()
		phys:SetVelocity(vel)
	end

end

function ENT:PhysicsCollide(data, phys)

	if data.Speed > 50 and self.SoundHit then self:EmitSound(unpack(self.SoundHit)) end -- play hit sound

	if data.Speed > self.BreakSensitivity and IsValid(data.HitEntity) and data.HitEntity:GetClass():find('breakable') then -- break surface if enough speed
		data.HitEntity:Fire('Break')
		phys:SetVelocity(data.OurOldVelocity)
	end

	if self.ExplodeAfterCollision and not self.activated then -- make projectile explode
		self.activated = true

		local pos = data.HitPos or self:GetPos()
		if self.LifeTime > 0 then
			timer.Simple(self.LifeTime, function()
				if IsValid(self) then self:Explode(pos) end
			end)
		else
			self:Explode(pos)
		end
	end

end

function ENT:Explode(pos)

	netstream.Start(nil, 'throwable.explode', self, pos)

	local sd = self.SoundExplode
	if sd and sd[1] then
		self:EmitSound(sd[1], sd[2], sd[3] + math.random(-10, 10), sd[4])
	end

	if self:OnExplode() ~= true then
		self:Remove()
	end

end

function ENT:OnRemove()

	if self.sndFlame then
		self.sndFlame:Stop()
	end

end

function ENT:OnExplode()
	-- to be overridden
end
