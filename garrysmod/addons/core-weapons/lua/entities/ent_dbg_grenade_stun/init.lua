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

end

function ENT:PhysicsCollide(data)

	if data.Speed > 50 and self.SoundHit then self:EmitSound(unpack(self.SoundHit)) end

	timer.Simple(self.LifeTime, function()
		if not IsValid(self) then return end
		self:Explode()
	end)

end

local function lookingAt(ply, ent)
	local aim = ply:EyeAngles():Forward()
	local entVector = ent:GetPos() - ply:GetShootPos()
	local dot = aim:Dot(entVector) / entVector:Length()
	return dot * 8 >= math.pi
end

function ENT:OnExplode()

	util.BlastDamage(self, self, self:GetPos(), 100, 35)

	for _,v in ipairs(ents.FindInSphere(self:GetPos(), 400)) do
		if not v:IsPlayer() then continue end
		if not self:CanDamage(v, 'eyes') then
			netstream.Start(v, 'dbg-grenades.flash', self)
			continue
		end
		local looking = lookingAt(v, self)
		if looking then
			netstream.Start(v, 'dbg-grenades.shock', 16, 255, 12)
			v:SetEyeAngles(v:EyeAngles() + Angle(math.random(-45, 45), math.random(-45, 45)))
			v:MoveModifier('shock', {
				norun = true,
				walkmul = 0.5,
			})
			v:SetDSP(38) -- distorted speaker
			timer.Simple(0.25, function()
				if IsValid(v) then
					v:SetDSP(36) -- shock muffle 2
				end
			end)
			timer.Simple(1.75, function()
				if IsValid(v) then
					v:SetDSP(33) -- explosion ring 2
				end
			end)
			timer.Simple(2, function()
				if IsValid(v) then
					v:SetDSP(16)
				end
			end)
			timer.Simple(16, function()
				if IsValid(v) then
					v:SetDSP(1)
					v:MoveModifier('shock', nil)
				end
			end)
		else
			netstream.Start(v, 'dbg-grenades.shock', 4, 100, 4)
			v:SetEyeAngles(v:EyeAngles() + Angle(math.random(-15, 15), math.random(-15, 15)))
			v:SetDSP(16)
			timer.Simple(4, function()
				if IsValid(v) then
					v:SetDSP(1)
				end
			end)
		end
	end

end
