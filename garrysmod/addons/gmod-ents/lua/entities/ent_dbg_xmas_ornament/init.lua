AddCSLuaFile "cl_init.lua"
AddCSLuaFile "shared.lua"

include "shared.lua"

function ENT:Initialize()

	if not self.ownerSID64 then return self:Remove() end

	if self.isStar then
		self:SetModel('models/wilderness/treestar.mdl')
	else
		self:SetModel('models/unconid/xmas/ornaments_u.mdl')
		self:SetSkin(math.random(0, 2))
		self:SetModelScale(2.5)
	end

	self:PhysicsInit(SOLID_VPHYSICS)
	--self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:SetUnFreezable(true)

end
