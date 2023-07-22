AddCSLuaFile 'cl_init.lua'
AddCSLuaFile 'shared.lua'

include 'shared.lua'

local thinkTime = 3
local tryPeriod = 5 -- 5 * 3 = 15 seconds
local tryChance = 0.2 -- 20% of tries are successful (average success every 15 * 5 = 75 seconds)

function ENT:Initialize()

	if not self.rod or not self.owner then
		return self:Remove()
	end

	self:SetModel('models/holograms/sphere.mdl')
	self:SetColor(Color(215,44,57))

	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetModelScale(0.5)
	self.tryAfter = tryPeriod

	timer.Simple(0, function()
		local phys = self:GetPhysicsObject()
		if IsValid(phys) then
			phys:SetBuoyancyRatio(0.05)
			phys:Wake()
		end
	end)

end

function ENT:Think()
	if not IsValid(self.rod) or not IsValid(self.owner) then
		self:Remove()
		return
	end

	if self:GetNetVar('baiting') or self:GetPos():DistToSqr(self.owner:GetPos()) > 1000000 then
		self:Remove()
		self.rod.bait = nil
		return
	end

	if self:WaterLevel() < 1 then
		local time = (self.notInWaterTime or 0) + 1
		if time >= thinkTime then
			self:Remove()
			return
		end
		self.notInWaterTime = time

		self:NextThink(CurTime() + 1)
		return true
	else
		self.notInWaterTime = nil
	end

	self.tryAfter = self.tryAfter - 1
	if self.tryAfter <= 0 then
		self:SetNetVar('baiting', self:TryBait() or nil)
		self.tryAfter = tryPeriod
	end

	self:NextThink(CurTime() + thinkTime)
	return true
end

function ENT:NoPlayersAround()

	return #octolib.array.filter(ents.FindInSphere(self:GetPos(), 100), function(ent) return ent:IsPlayer() end) == 0

end

function ENT:DeepEnough()

	local t = {}
	t.start = self:GetPos()
	t.endpos = t.start - Vector(0, 0, 50)
	t.filter = self
	t = util.TraceLine(t)
	return not t.Hit

end

function ENT:TryBait()

	return math.random(1 / tryChance) == 1 and self:NoPlayersAround() and self:DeepEnough()

end

hook.Add('EntityRemoved', 'dbg-fishing.fixHook', function(ent)
	if ent:GetClass() == 'ent_dbg_fish_float' then
		local rod = ent.rod
		if IsValid(rod) then rod:SetNetVar('hook', nil) end
	end
end)
