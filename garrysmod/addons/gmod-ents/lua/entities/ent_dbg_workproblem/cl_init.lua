include 'shared.lua'

ENT.Spawnable			= true
ENT.AdminSpawnable		= true
ENT.RenderGroup 		= RENDERGROUP_OPAQUE

function ENT:Draw()

	if octolib.drawDebug then
		self:DrawModel()
	end

end
