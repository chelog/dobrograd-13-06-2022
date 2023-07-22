include 'shared.lua'

local lposes = {
	{ Vector(30, 0, 330), true },
	{ Vector(-30, 0, 330), true },
	{ Vector(0, 0, 100), false },
}

function ENT:Think()

	local pos = self:GetPos()
	if pos:DistToSqr(EyePos()) > 1500000 then return end

	for i, v in ipairs(lposes) do
		local dlight = DynamicLight(self:EntIndex() + i - 1, v[2])
		if dlight then
			dlight.pos = self:GetPos() + v[1]
			dlight.r = 255
			dlight.g = 200
			dlight.b = 150
			dlight.brightness = 0.5
			dlight.Decay = 1000
			dlight.Size = 1024
			dlight.DieTime = CurTime() + 1
		end
	end

end
