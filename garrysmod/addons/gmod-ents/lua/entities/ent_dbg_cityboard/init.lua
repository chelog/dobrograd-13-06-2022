AddCSLuaFile 'cl_init.lua'
AddCSLuaFile 'shared.lua'

include 'shared.lua'

function ENT:Initialize()

	self:SetModel('models/nightreaper/softwood/5x75x50_panel_flat.mdl')
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)

	local lp = ents.Create 'prop_dynamic'
	lp:SetParent(self)
	lp:SetModel('models/nightreaper/softwood/5x5x75_beam_medium.mdl')
	lp:SetLocalPos(Vector(-5, 20, -30))
	lp:SetLocalAngles(Angle())

	local rp = ents.Create 'prop_dynamic'
	rp:SetParent(self)
	rp:SetModel('models/nightreaper/softwood/5x5x75_beam_medium.mdl')
	rp:SetLocalPos(Vector(-5, -20, -30))
	rp:SetLocalAngles(Angle())

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then phys:Wake() end

end

function ENT:Think()

	self:NextThink(CurTime() + 1)
	return true

end
