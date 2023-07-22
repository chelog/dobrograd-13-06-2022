AddCSLuaFile 'cl_init.lua'
AddCSLuaFile 'shared.lua'

include 'shared.lua'
include 'commands.lua'

function ENT:Initialize()

	self:SetModel('models/props_lab/clipboard.mdl')
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)

	self:SetCollisionGroup(COLLISION_GROUP_INTERACTIVE_DEBRIS)
	local phys = self:GetPhysicsObject()

	phys:Wake()
	hook.Add('PlayerDisconnected', self, self.onPlayerDisconnected)

end

function ENT:OnTakeDamage(dmg)

	self:TakePhysicsDamage(dmg)
	if dmg:IsDamageType(DMG_BULLET) or dmg:IsDamageType(DMG_BLAST) then
		self:Destroy()
	end

end

function ENT:Destroy()

	local d = ents.Create('prop_physics')
	d:SetModel('models/props/cs_office/trash_can_p1.mdl')
	d:SetPos(self:GetPos())
	d:SetAngles(self:GetAngles())
	d:Spawn()
	d:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	d:Fire('Kill', '', 15)

	self:Remove()

end

function ENT:Use(ply)

	if self:GetNetVar('Owner') == ply then
		netstream.Start(ply, 'dbg-write', self, 'use', { self:GetPhysicsObject():IsMotionEnabled() })
	else
		if self:GetNetVar('IsFor') == ply then
			if ply:GetLetterCount() >= 3 then
				ply:Notify('warning', L.too_much_documents)
				return
			end

			self:SetNetVar('Owner', ply)
			self:SetNetVar('IsFor', nil)
			ply:Notify(L.your_document)
		end

		netstream.Start(ply, 'dbg-write', self, 'read', { self.text, false })
	end

end

function ENT:SignLetter(ply)

	self:SetNetVar('Signed', ply)

end

function ENT:onPlayerDisconnected(ply)

	if self:GetNetVar('Owner') == ply then
		self:Destroy()
	end

end

netstream.Hook('dbg-write', function(ply, ent, action, data)

	if not IsValid(ent) or ent:GetClass() ~= 'letter'
	or ent:GetPos():DistToSqr(ply:GetPos()) > 900000 then return end

	-- public access
	if action == 'read' then
		netstream.Start(ply, 'dbg-write', ent, 'read', { ent.text, data[1] })
	end

	-- for owner
	if ent:GetNetVar('Owner') ~= ply then return end
	if action == 'destroy' then
		netstream.StartPVS(ent:GetPos(), 'dbg-write', ent, 'close')
		ent:Destroy()
	elseif action == 'edit' then
		netstream.StartPVS(ent:GetPos(), 'dbg-write', ent, 'close')
		ent.text = data[1]
		ent:SetNetVar('Signed', nil)
	elseif action == 'sign' then
		ent:SetNetVar('Signed', data[1] and ply or nil)
	elseif action == 'give' then
		local isFor = data[1]
		if not IsValid(isFor) or not isFor:IsPlayer() then return end

		ent:SetNetVar('IsFor', isFor)
		ply:Notify(isFor and (L.giving_document .. isFor:Name()) or L.giving_document_cancel)
	elseif action == 'freeze' then
		if data[1] then
			local phys = ent:GetPhysicsObject()
			phys:EnableMotion(true)
			phys:Wake()
		else
			local pos = ent:GetPos()
			timer.Simple(1, function()
				if not IsValid(ent) then return end
				if ent:GetPos():DistToSqr(pos) < 1 then
					ent:GetPhysicsObject():EnableMotion(false)
					ply:Notify(L.document_freeze)
				else
					ply:Notify(L.dont_move_document)
				end
			end)
		end
	end

end)
