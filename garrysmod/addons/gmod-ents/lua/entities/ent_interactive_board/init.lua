AddCSLuaFile 'cl_init.lua'
AddCSLuaFile 'shared.lua'
include 'shared.lua'

function ENT:Initialize()

	self:SetModel('models/hunter/plates/plate2x2.mdl')
	self:SetMaterial('models/debug/debugwhite')
	self:SetColor(Color(0,0,0))
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)

end
