AddCSLuaFile('shared.lua')
AddCSLuaFile('cl_init.lua')
include('shared.lua')

function ENT:Initialize()
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
end

function ENT:AttachToCar(car, cont)
	car.package, self.car = self, car
	cont.volume = cont.volume - self:GetVolumeLiters()
	cont:ResetSpaceMass()
	cont:QueueSync()
	self.oldPos = car:WorldToLocal(self:GetPos())
	self:SetCollisionGroup(COLLISION_GROUP_WORLD)
	self:SetPos(car:GetPos())
	self.trunkWeld = constraint.Weld(self, car, 0, 0, 0, true, false)
	self:SetNoDraw(true)
	self:DrawShadow(false)
end

function ENT:DetachFromCar()
	local car = self.car
	if not IsValid(car) then return false end
	if not car.inv then return false end
	local cont = car.inv:GetContainer('trunk')
	if not cont then return false end
	if IsValid(self.trunkWeld) then self.trunkWeld:Remove() end
	self:SetCollisionGroup(COLLISION_GROUP_NONE)
	self:SetPos(car:LocalToWorld(self.oldPos) + Vector(0,0,1))
	car.package, self.car, self.oldPos = nil
	self:SetNoDraw(false)
	self:DrawShadow(true)
	cont.volume = cont.volume + self:GetVolumeLiters()
	cont:ResetSpaceMass()
	cont:QueueSync()
	return true
end

-- 0.0018868524251996 is a shitty coefficient to convert source volume units to liters
-- calced manually, using cola cans, assuming its' volume is 0.33l
function ENT:GetVolumeLiters()
	return math.ceil(self:GetPhysicsObject():GetVolume() * 0.0018868524251996)
end

function ENT:Think()
	if not self.jobID then return end

	if self:GetPos():DistToSqr(self.targetPos) <= self.targetDist then
		dbgJobs.finishJob(self.jobID, true)
		return
	end

	self:NextThink(CurTime() + 2)
	return true
end

function ENT:Use(ply)
	if self.ply ~= ply then return ply:Notify('Этот груз ожидает курьера') end

	if IsValid(self.weld) then
		self.weld:Remove()
		ply:Notify('Предмет откреплен')
		return
	end

	local bottom = self:NearestPoint(self:GetPos() - Vector(0, 0, 300))
	local traceData = {
		start = bottom,
		endpos = bottom - Vector(0,0,4),
		filter = self,
	}
	local car = util.TraceLine(traceData).Entity
	if not IsValid(car) or not car.IsSimfphyscar then return ply:Notify('Предмет можно закрепить, если положить его на автомобиль') end
	if not list.Get('simfphys_vehicles')[car.VehicleName].Members.CanAttachPackages then
		return ply:Notify('warning', 'Не получается закрепить предмет на этом автомобиле')
	end

	self.weld = constraint.Weld(self, car, 0, 0, 5000, true, false)
	ply:Notify('Предмет закреплен на автомобиле')
end

function ENT:SetDeliveryData(jobID, ply, targetPos)
	self.jobID = jobID
	self.ply = ply
	self.targetPos = targetPos
	self.targetDist = (self:GetModelRadius() * 1.2) ^ 2
end

hook.Add('dbg-hands.canDrag', 'dbg_jobs_package', function(ply, ent, trace)
	local ent = trace.Entity
	if ent:GetClass() ~= 'dbg_jobs_package' then return end

	local owner = ent.ply
	if owner == ply or IsValid(owner) and owner.Buddies and owner.Buddies[ply] and table.HasValue(owner.Buddies[ply], true) then return end

	return false, 'Этот груз ожидает курьера'
end)

hook.Add('EntityRemoved', 'dbg-jobs.detach', function(ent)
	if ent:GetClass() == 'gmod_sent_vehicle_fphysics_base' and ent.package then
		ent.package:DetachFromCar()
	end
end)