include 'shared.lua'

local titlePosAngByModels = {
	['models/props_equipment/phone_booth.mdl'] = {Vector(16.6, 0, 74), Angle(0, 90, 90)},
	-- ['models/props/cs_office/phone.mdl'] = {Vector(-5, 0, 5), Angle(0, 90, 90)},
}

function ENT:Draw()
	self:DrawModel()
	local posang = titlePosAngByModels[self:GetModel()]
	if posang then
		render.DrawBubble(self, posang[1], posang[2], L.phone, 200, 200)
	end
end