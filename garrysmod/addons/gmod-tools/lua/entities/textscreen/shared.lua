ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Textscreen"
ENT.Author = ""
ENT.Spawnable = true
ENT.AdminSpawnable = false

ENT.Tool = 'textscreen'

function ENT:SetupDataTables()
	self:NetworkVar("Bool", 0, "IsPersisted")
end