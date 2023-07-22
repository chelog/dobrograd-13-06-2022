local config = octomap.config

local PANEL = {}

function PANEL:Init()

	self:Dock(FILL)
	for k, v in pairs(config) do self[k] = v end

end

function PANEL:SetOptions(opts)

	for k, v in pairs(opts or {}) do self[k] = v end

end

function PANEL:Paint(w, h)

	self:UpdateAnimation()

	local scale = self.scale
	local centerOffX, centerOffY = math.Round(self.cx + self.offX * scale), math.Round(self.cy + self.offY * scale)

	local mw, mh = config.mapW * scale, config.mapH * scale
	local mx, my = centerOffX - math.Round(mw / 2), centerOffY - math.Round(mh / 2)
	draw.NoTexture()
	surface.SetDrawColor(config.bgCol)
	surface.DrawRect(0, 0, w, h)
	surface.SetMaterial(octomap.material)
	surface.SetDrawColor(255,255,255, 255)
	surface.DrawTexturedRect(mx, my, mw, mh)

	for id, marker in pairs(octomap.markers) do
		local x, y = centerOffX + math.Round(marker.x * scale), centerOffY + math.Round(marker.y * scale)
		marker:Paint(x, y, self)
	end

end

function PANEL:Think()

	if self.panning then
		if not self.allowPan then self.panning = nil end

		local newX, newY = gui.MousePos()
		local dx, dy = newX - self.lastMX, newY - self.lastMY
		if dx ~= 0 then
			self.offX = self.offX + math.Round(dx / self.scale)
			self.tgtOffX = self.offX
			self.lastMX = newX
			self:AlignToBounds()
		end
		if dy ~= 0 then
			self.offY = self.offY + math.Round(dy / self.scale)
			self.tgtOffY = self.offY
			self.lastMY = newY
			self:AlignToBounds()
		end
	end

	local ct = CurTime()
	for id, marker in pairs(octomap.markers) do
		if marker.Think and ct > marker.thinkAfter then
			marker.thinkAfter = marker:Think() or ct
		end
	end

end

function PANEL:UpdateAnimation()

	if self.tgtScale ~= self.scale then
		self.scale = octolib.math.lerp(self.scale, self.tgtScale, FrameTime() * self.tgtSpeed, 0.001)
	end

	if self.tgtOffX ~= self.offX or self.tgtOffY ~= self.offY then
		local pos = octolib.math.lerpVector(Vector(self.offX, self.offY, 0), Vector(self.tgtOffX, self.tgtOffY, 0), FrameTime() * self.tgtSpeed, 1)
		self.offX, self.offY = pos.x, pos.y
	end

end

function PANEL:AlignToBounds()

	local scale = self.tgtScale
	local bx = config.mapW * scale - (self.cx * 2 - self.paddingL - self.paddingR)
	local by = config.mapH * scale - (self.cy * 2 - self.paddingT - self.paddingB)

	if bx <= 0 then
		self.tgtOffX = (self.paddingL - self.paddingR) / 2 / scale
	else
		local half = bx / 2
		local hpl, hpr = self.paddingL / 2, self.paddingR / 2
		local bl, br = (half + hpl - hpr) / scale, -(half + hpr - hpl) / scale
		if self.tgtOffX < br then self.tgtOffX = br end
		if self.tgtOffX > bl then self.tgtOffX = bl end
	end

	if by <= 0 then
		self.tgtOffY = (self.paddingT - self.paddingB) / 2 / scale
	else
		local half = by / 2
		local hpt, hpb = self.paddingT / 2, self.paddingB / 2
		local bt, bb = (half + hpt - hpb) / scale, -(half + hpb - hpt) / scale
		if self.tgtOffY < bb then self.tgtOffY = bb end
		if self.tgtOffY > bt then self.tgtOffY = bt end
	end

end

function PANEL:OnMousePressed(key)

	local cx, cy = self:LocalCursorPos()
	local mx, my = self:FromPanelToMap(cx, cy)
	self.pressX, self.pressY = cx, cy

	if key == MOUSE_LEFT then
		if self.allowPan then
			self.panning = true
			self.lastMX, self.lastMY = gui.MousePos()

			hook.Add('PlayerButtonUp', 'mapPan', function(ply, but)
				if but == MOUSE_LEFT then
					if IsValid(self) then self.panning = false end
					hook.Remove('PlayerButtonUp', 'mapPan')
				end
			end)
		end
	end

	-- if key == MOUSE_RIGHT then
	-- 	local m = octomap.getMarker('customTarget')
	-- 	if m then
	-- 		local x, y = m:GetMapPos()
	-- 		if math.abs(x - mx) + math.abs(y - my) < 100 * self.scale then
	-- 			m:Remove()
	-- 			return
	-- 		end
	-- 	end

	-- 	local m = octomap.createMarker('customTarget')
	-- 		:SetMapPos(mx, my)
	-- 		:SetIcon('octoteam/icons-16/location_pin.png')
	-- 		:SetIconOffset(0, -7)
	-- 		:SetClickable(true)

	-- 	function m:LeftClick()
	-- 		self
	-- 			:SetIcon('octoteam/icons-16/tick.png')
	-- 			:SetIconOffset()
	-- 	end
	-- end

end

function PANEL:OnMouseReleased(key)

	local cx, cy = self:LocalCursorPos()
	if math.abs(cx - self.pressX) < 5 and math.abs(cy - self.pressY) < 5 then
		for i, marker in ipairs(octomap.clickableMarkers) do
			local x, y = self:FromMapToPanel(marker:GetMapPos())
			local radius = marker.iconHalfSize + 2
			if math.abs(cx - x) < radius and math.abs(cy - y) < radius then
				if key == MOUSE_LEFT then
					marker:LeftClick(self)
				elseif key == MOUSE_RIGHT then
					marker:RightClick(self)
				end
			end
		end
	end

	self.panning = false

end

function PANEL:OnMouseWheeled(d)

	if not self.allowPan then return end

	local x, y = self:FromPanelToMap(self:LocalCursorPos())
	self:Zoom(d, x, y)

end

function PANEL:PerformLayout()

	self.cx = self:GetWide() / 2
	self.cy = self:GetTall() / 2
	self:AlignToBounds()

end

function PANEL:Zoom(d, x, y)

	d = d or 1
	if not x or not y then
		x, y = self:FromPanelToMap(self:LocalCursorPos())
	end

	local scaleOld = self.tgtScale
	self.tgtScale = math.Clamp(self.tgtScale * (d > 0 and 1.25 or 0.8), self.scaleMin, self.scaleMax)

	local ch = math.abs(1 - scaleOld / self.tgtScale) * octolib.math.sign(d)
	self.tgtOffX = octolib.math.lerpUnclamped(self.tgtOffX, -x, ch)
	self.tgtOffY = octolib.math.lerpUnclamped(self.tgtOffY, -y, ch)

	self:AlignToBounds()

end

function PANEL:GoTo(x, y, scale)

	self.tgtSpeed = 10
	timer.Create('octomap.tgtSpeedReset', 1, 1, function()
		if not IsValid(self) then return end
		self.tgtSpeed = config.tgtSpeed
	end)

	self.tgtOffX = -x + (self.paddingL - self.paddingR) / 2
	self.tgtOffY = -y + (self.paddingT - self.paddingB) / 2
	self.tgtScale = scale or self.tgtScale
	self:AlignToBounds()

end

function PANEL:FromPanelToMap(x, y)

	x, y = x or 0, y or 0
	return (x - self.cx) / self.scale - self.offX, (y - self.cy) / self.scale - self.offY

end

function PANEL:FromMapToPanel(x, y)

	x, y = x or 0, y or 0
	return (x + self.offX) * self.scale + self.cx, (y + self.offY) * self.scale + self.cy

end

function PANEL:GetViewCenter()

	return self.cx + (self.paddingL - self.paddingR) / 2, self.cy + (self.paddingT - self.paddingB) / 2

end

vgui.Register('octomap', PANEL, 'DPanel')
