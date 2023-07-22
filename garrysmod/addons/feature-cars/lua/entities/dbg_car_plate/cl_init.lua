include 'shared.lua'

local offPos, offAng = Vector(0, 0, 0), Angle(0, 90, 90)
function ENT:Draw()

	self:DrawModel()

	surface.SetAlphaMultiplier(self.alpha or 1)

	local pos, ang = LocalToWorld(offPos, offAng, self:GetPos(), self:GetAngles())
	cam.Start3D2D(pos, ang, 0.065)
		draw.Text({
			text = self.text,
			font = 'car-dealer.plate',
			pos = { 0, 10 },
			color = self.color,
			xalign = TEXT_ALIGN_CENTER,
			yalign = TEXT_ALIGN_CENTER,
		})
	cam.End3D2D()

	surface.SetAlphaMultiplier(1)

end
