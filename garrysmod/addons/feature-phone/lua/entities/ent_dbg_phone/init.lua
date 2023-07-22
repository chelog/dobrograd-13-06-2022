AddCSLuaFile 'cl_init.lua'
AddCSLuaFile 'shared.lua'

include 'shared.lua'

function ENT:Initialize()

	self:SetModel(self.Model)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetUseType(SIMPLE_USE)

end

function ENT:GetNick()
	if not IsValid(self.owner) then return '(стационарный)' end
	return self.owner:Nick()
end

function ENT:Use(ply)

	if not self.off then
		netstream.Start(ply, 'dbg-phone.open', true, self)
	end

end