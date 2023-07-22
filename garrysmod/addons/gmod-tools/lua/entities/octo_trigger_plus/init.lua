AddCSLuaFile 'cl_init.lua'
AddCSLuaFile 'shared.lua'
include 'shared.lua'

function ENT:UpdateTransmitState()

	return TRANSMIT_ALWAYS

end

function ENT:Initialize()

	self:SetModel('models/props_junk/popcan01a.mdl')
	self:DrawShadow(false)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_BBOX)
	self:UpdateSize()
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)

	self:AddEFlags(EFL_FORCE_CHECK_TRANSMIT)
	self:SetTrigger(true)

	self:UpdateNetworkVars()
	self.done = self.mode == 0 and {} or 0

end

function ENT:UpdateNetworkVars()

	self:SetNetVar('size', self.size)

end

function ENT:UpdateSize()

	local size = self.size or Vector(1,1,1)
	local side = Vector(size.x / 2, size.y / 2, size.z / 2)
	self:SetCollisionBounds(-side, side)

end

function ENT:StartTouch(ent)

	if ent:IsPlayer() then
		if self.times > 0 then
			local done = self.done
			if self.mode == 0 then
				done = self.done[ent] or 0
			end
			if done >= self.times then return end
			done = done + 1
			if self.mode == 0 then
				self.done[ent] = done
			else
				self.done = done
			end
		end
		self:DoTrigger(ent)
	end

end

function ENT:DoTrigger(ent)

	if not self.action then return end
	local owner = self:CPPIGetOwner()
	if not IsValid(owner) then return end

	netstream.Start(owner, 'gmpanel.executeObject', self.action, { ent:SteamID() })

end

local tosave = {'size', 'times', 'mode', 'action'}
duplicator.RegisterEntityClass('octo_trigger_plus', function(ply, data)
	if not IsValid(ply) then return end

	if not ply:query('DBG: Панель ивентов') then return false end
	if not ply:CheckLimit('octo_triggers_plus') then return false end

	local ent = duplicator.GenericDuplicatorFunction(ply, data)

	ent:UpdateSize()
	ent:UpdateNetworkVars()
	ent.done = ent.mode == 0 and {} or 0

	if IsValid(ply) then
		ply:AddCount('octo_triggers_plus', ent)
		ply:AddCleanup('octo_triggers_plus', ent)
	end

	return ent

end, 'Data', unpack(tosave))
