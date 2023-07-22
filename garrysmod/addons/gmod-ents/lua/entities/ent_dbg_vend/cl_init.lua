include('shared.lua')

ENT.Spawnable			= true
ENT.AdminSpawnable		= true
ENT.RenderGroup 		= RENDERGROUP_BOTH

function ENT:Initialize()

	-- something

end

function ENT:Draw()
	self:DrawModel()
	render.DrawBubble(self, Vector(0, -21.8, 70), Angle(0, 0, 90), L.soda, 200, 200)
end
