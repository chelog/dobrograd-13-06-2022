include 'shared.lua'

ENT.Spawnable			= true
ENT.AdminSpawnable		= true
ENT.RenderGroup 		= RENDERGROUP_BOTH

function ENT:Draw()

	self:DrawModel()

end
