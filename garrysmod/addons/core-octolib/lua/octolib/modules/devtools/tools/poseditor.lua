function octolib.devtools.positions(pos, ang, scale)
	pos = pos or Vector(0, 0, 0)
	ang = ang or Angle(0, 0, 0)

	local toReturn = {
		pos = pos,
		ang = ang,
		scale = scale or 1,
	}

	local w = vgui.Create 'DFrame'
	w:SetSize(300, 300)
	w:AlignBottom(10)
	w:AlignLeft(10)
	toReturn.panel = w

	local prop = w:Add 'DProperties'
	prop:Dock(FILL)

	local rowLabelW = 25
	local function rowLayout(self)

		self:SetTall(20)
		self.Label:SetWide(rowLabelW)

	end

	local function setupRow(cat, name, change, decimals)
		local r = prop:CreateRow(cat, name)
		r:Setup('Float', { min = -1000, max = 1000 })
		r:SetValue(0)
		r.PerformLayout = rowLayout
		r.Paint = nil

		local l = r:GetChild(1):GetChild(0)
		l.Paint = function() end
		l:GetChild(0):SetDecimals(decimals or 1)
		function r:DataChanged(v) change(v) end

		return r
	end

	local function rowCatPaint(self, w, h) end

	local function updatePos(pos)
		if not toReturn.updatePos then return end
		toReturn.updatePos(pos)
	end

	local function updateAng(ang)
		if not toReturn.updateAng then return end
		toReturn.updateAng(ang)
	end

	local function updateScale(scale)
		if not toReturn.updateScale then return end
		toReturn.updateScale(scale)
	end

	setupRow(L.position, 'X', function(v) pos.x = math.Round(v, 1) updatePos(pos) end):SetValue(pos.x)
	setupRow(L.position, 'Y', function(v) pos.y = math.Round(v, 1) updatePos(pos) end):SetValue(pos.y)
	setupRow(L.position, 'Z', function(v) pos.z = math.Round(v, 1) updatePos(pos) end):SetValue(pos.z)
	setupRow(L.angle, 'P', function(v) ang.p = math.Round(v, 1) updateAng(ang) end):SetValue(ang.p)
	setupRow(L.angle, 'Y', function(v) ang.y = math.Round(v, 1) updateAng(ang) end):SetValue(ang.y)
	setupRow(L.angle, 'R', function(v) ang.r = math.Round(v, 1) updateAng(ang) end):SetValue(ang.r)
	setupRow(L.size, 'S', function(v) toReturn.scale = math.Round(v, 2) updateScale(toReturn.scale) end, 2):SetValue(toReturn.scale)

	for name, pnl in pairs(prop.Categories) do
		pnl.Container.Paint = rowCatPaint
	end

	local b = w:Add 'DButton'
	b:Dock(BOTTOM)
	b:SetTall(20)
	b:SetText(L.copy)
	function b:DoClick()
		SetClipboardText(('Vector(%.1f, %.1f, %.1f), Angle(%.1f, %.1f, %.1f), %.1f'):format(pos.x, pos.y, pos.z, ang.p, ang.y, ang.r, toReturn.scale))
	end

	function w:OnClose()
		if not toReturn.onClose then return end
		toReturn.onClose(self)
	end

	return toReturn
end