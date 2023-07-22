include 'shared.lua'

ENT.Spawnable			= true
ENT.AdminSpawnable		= true
ENT.RenderGroup 		= RENDERGROUP_BOTH

function ENT:Draw()

	self:DrawModel()

	local job = LocalPlayer():getJobTable()
	if not job or not job.worker then return end
	render.DrawBubble(self, Vector(-28, 16.99, 50), Angle(0, 180, 90), L.city_warehouse, 200, 200)

end
