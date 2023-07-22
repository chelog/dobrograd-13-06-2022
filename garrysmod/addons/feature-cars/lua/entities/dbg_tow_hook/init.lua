include 'shared.lua'
AddCSLuaFile 'shared.lua'
AddCSLuaFile 'cl_init.lua'

function ENT:Initialize()

	self:SetModel('models/octoteam/vehicles/bobcat_towtruck_crane.mdl')
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)

	self.DoNotDuplicate = true
	self.nextWeld = 0

	local ph = self:GetPhysicsObject()
	ph:SetMass(15)
	ph:SetDamping(2, 2)
	self:Activate()

	self.controller = ents.Create('gmod_winch_controller')
	local controller = self.controller
	controller:Spawn()
	controller.min_length = 40
	controller.max_length = 80
	self:DeleteOnRemove(controller)

end

function ENT:SetTruck(veh)

	self:SetPos(veh:LocalToWorld(self.WinchPosTow - Vector(0,0,53)))
	self:SetAngles(veh:GetAngles())

	local controller = self.controller
	veh:DeleteOnRemove(controller)
	veh:DeleteOnRemove(self)

	self.controller = controller
	veh.TowController = controller
	veh.HasSpecial = true

	self:SetNetVar('truck', veh)
	veh.TowHook = self
	self:SetupWinch()

end

local function CalcElasticConsts(Phys1, Phys2, Ent1, Ent2, iFixed)
	local minMass = 0

	if Ent1:IsWorld() then
		minMass = Phys2:GetMass()
	elseif Ent2:IsWorld() then
		minMass = Phys1:GetMass()
	else
		minMass = math.min(Phys1:GetMass(), Phys2:GetMass())
	end

	local const = minMass * 100
	local damp = const * 0.2

	if iFixed == 0 then
		const = minMass * 50
		damp = const * 0.1
	end

	return const, damp
end

function ENT:SetupWinch(ent)

	local old = self.controller.constraint
	if IsValid(old) then old:Remove() end

	local tow = self:GetNetVar('truck')
	local tgt = IsValid(ent) and ent ~= tow and ent or self

	local winchPosTgt = tgt == self and self.WinchPosHook or tgt:WorldToLocal(self:LocalToWorld(self.WinchPosHook))
	local strenght, damp = CalcElasticConsts(tow:GetPhysicsObject(), tgt:GetPhysicsObject(), tow, tgt, false)
	local const, rope = constraint.Elastic(tow, tgt, 0, 0, self.WinchPosTow, winchPosTgt, strenght, damp, 0, '', 0, true)

	const:SetTable({
		Type = 'Winch',
		Ent1 = tow,
		Ent2 = tgt,
		Bone1 = vehPh,
		Bone2 = vehHk,
		LPos1 = self.WinchPosTow,
		LPos2 = winchPosTgt,
		width = 1.5,
		fwd_speed = 5,
		bwd_speed = 5,
		material = 'cable/cable',
		toggle = false,
	})

	self.controller:SetConstraint(const)
	self.controller:SetRope(rope)
	self.hookedEnt = tgt

end

function ENT:Think()

	if not IsValid(self.hookedEnt) then
		self:SetupWinch()
	end

end

function ENT:PhysicsCollide(data, ph)

	if IsValid(self.weld) or self.nextWeld > CurTime() then return end

	local veh = data.HitEntity
	if not IsValid(veh) or veh:GetClass() ~= 'gmod_sent_vehicle_fphysics_base' then return end

	self.nextWeld = CurTime() + 1
	timer.Simple(0, function()
		self:Attach(veh)
	end)

end

function ENT:Attach(veh)

	local weld = constraint.Weld(self, veh, 0, 0, 0, true, false)
	self.weld = weld

	self:SetupWinch(veh)

end

function ENT:OnHandsPickup(ply, hands)

	if IsValid(self.weld) then
		self.weld:Remove()
		self.nextWeld = CurTime() + 1

		self:SetupWinch()
	end

end
