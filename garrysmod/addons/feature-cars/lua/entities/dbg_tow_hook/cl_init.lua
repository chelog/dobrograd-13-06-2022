include 'shared.lua'

function ENT:Initialize()

	local maxs = Vector(40, 40, 40)
	self:SetRenderBounds(-maxs, maxs)

end

local ropeMat = Material('cable/cable')

function ENT:Draw()

	self:DrawModel()

	local truck = self:GetNetVar('truck')
	if not IsValid(truck) then return end

	render.SetMaterial(ropeMat)
	render.StartBeam(2)
	render.AddBeam(self:LocalToWorld(self.WinchPosHook), 1.5, 0, color_white)
	render.AddBeam(truck:LocalToWorld(self.WinchPosTow), 1.5, 2, color_white)
	render.EndBeam()

end
