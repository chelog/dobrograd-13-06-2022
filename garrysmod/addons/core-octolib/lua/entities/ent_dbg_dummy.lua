AddCSLuaFile()

ENT.Type = 'anim'
ENT.Base = 'base_anim'
ENT.PrintName = 'Болванка'
ENT.Category = L.dobrograd
ENT.Spawnable = false
ENT.AdminOnly = false

function ENT:Initialize()
	self:PhysicsInit(SOLID_NONE)
	self:SetMoveType(MOVETYPE_NONE)
end

if CLIENT then
	function octolib.createDummy(mdl, rendergroup)
		local ent = ents.CreateClientside('ent_dbg_dummy')
		ent.RenderGroup = rendergroup
		ent:SetModel(mdl)
		ent:Spawn()
		return ent
	end
end
