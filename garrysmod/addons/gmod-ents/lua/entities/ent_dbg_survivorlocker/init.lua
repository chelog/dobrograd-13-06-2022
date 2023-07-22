AddCSLuaFile "cl_init.lua"
AddCSLuaFile "shared.lua"

include "shared.lua"

function ENT:Initialize()

	self:SetModel('models/props_wasteland/controlroom_storagecloset001a.mdl')
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then phys:Wake() end

end

function ENT:Use(ply)

	EventMakeRefugee(ply, nil, function() return IsValid(self) and octolib.use.check(ply, self) end)

end
