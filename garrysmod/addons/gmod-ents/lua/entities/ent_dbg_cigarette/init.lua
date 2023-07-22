AddCSLuaFile "cl_init.lua"
AddCSLuaFile "shared.lua"

include "shared.lua"

function ENT:Initialize()

	self:SetModel('models/boxopencigshib.mdl')
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then phys:Wake() end

	self.amount = self.amount or 10

end

function ENT:Use(ply)

	if ply:HasWeapon('dbg_cigarette') then
		ply:Notify('warning', L.you_already_have_a_cigarette)
		return
	end

	ply:Give('dbg_cigarette')
	self.amount = self.amount - 1
	if self.amount <= 0 then self:Remove() return end

end
