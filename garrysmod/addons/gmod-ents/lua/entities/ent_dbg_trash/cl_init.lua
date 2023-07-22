include 'shared.lua'

ENT.Spawnable			= true
ENT.AdminSpawnable		= true
ENT.RenderGroup 		= RENDERGROUP_BOTH

function ENT:Draw()
	self:DrawModel()
	local bubble = self.TrashData[self:GetModel()] or {}
	render.DrawBubble(self, bubble[1] or Vector(20, 0, 10), bubble[2] or Angle(0, 90, 90), 'Мусорка', 100, 50)
end
