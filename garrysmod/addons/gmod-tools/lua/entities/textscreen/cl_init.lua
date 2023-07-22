include("shared.lua")
ENT.RenderGroup = RENDERGROUP_BOTH

function ENT:Initialize()
	self:SetMaterial("models/effects/vol_light001")
	self:SetRenderMode(RENDERMODE_TRANSALPHA)
	self:SetColor(Color(255, 255, 255, 1))
end

local function drawIt(totheight, lines)
	render.PushFilterMin(TEXFILTER.ANISOTROPIC)
	local curheight = 0

	for k, v in pairs(lines) do
		local text, font, y =
			v.text, TS_GET_FONT(v.font,v.size), -(totheight / 2) + curheight

		draw.DrawText(text, font, 2, y + 2, Color(0,0,0, 200), TEXT_ALIGN_CENTER)
		draw.DrawText(text, font, 0, y, v.color, TEXT_ALIGN_CENTER)
		curheight = curheight + v.height
	end

	render.PopFilterMin()
end

local posOff, angOff = Vector(0, 0, 0.5), Angle(0, 0, 0)
local dist, distFade = 2000 * 2000, 500 * 500
function ENT:Draw()

	local al = math.Clamp(1 - (self:GetPos():DistToSqr(EyePos()) - distFade) / dist, 0, 1)
	if al <= 0 then return end

	local pos, ang = LocalToWorld(posOff, angOff, self:GetPos(), self:GetAngles())
	local camangle = Angle(ang.p, ang.y, ang.r)
	local lines = self:GetNetVar('lines')
	if not lines then return end

	self.totheight = self.totheight or 0
	self.maxwidth = self.maxwidth or 0

	if self.oldLines ~= lines then
		self.totheight, self.maxwidth = 0, 0
		for k, v in pairs(lines) do
			if string.Trim(v.text) == '' then
				lines[k] = nil
				continue
			end

			v.size = tonumber(v.size) > 100 and 100 or v.size
			surface.SetFont( TS_GET_FONT(v.font,v.size) )
			TextWidth, TextHeight = surface.GetTextSize(v.text)
			lines[k].width = TextWidth
			lines[k].height = TextHeight
			self.totheight = self.totheight + TextHeight
			self.maxwidth = math.max(self.maxwidth, TextWidth)
		end
		self.oldLines = lines

		if not self.rbMins or not self.rbMaxs then
			self.rbMins, self.rbMaxs = self:GetRenderBounds()
		end
		local expectedMaxs = Vector(self.maxwidth * .125, self.totheight * .125, 0.001)
		local expectedMins = -expectedMaxs
		if self.rbMins ~= expectedMins or self.rbMaxs ~= expectedMaxs then
			self:SetRenderBounds(expectedMins, expectedMaxs)
			self.rbMins, self.rbMaxs = expectedMins, expectedMaxs
		end
	end


	cam.Start3D2D(pos, camangle, .25)
		surface.SetAlphaMultiplier(al)
		drawIt(self.totheight, lines)
		surface.SetAlphaMultiplier(1)
	cam.End3D2D()

end
