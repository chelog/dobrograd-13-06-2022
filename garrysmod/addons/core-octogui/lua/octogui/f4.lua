surface.CreateFont('f4.small', {
	font = 'Calibri',
	extended = true,
	size = 14,
	weight = 350,
})
surface.CreateFont('f4.small-sh', {
	font = 'Calibri',
	extended = true,
	size = 14,
	blursize = 3,
	weight = 350,
})

surface.CreateFont('f4.counter', {
	font = 'Arial',
	extended = true,
	size = 14,
	weight = 600,
})

surface.CreateFont('f4.normal', {
	font = 'Calibri',
	extended = true,
	size = 27,
	weight = 350,
})
surface.CreateFont('f4.normal-sh', {
	font = 'Calibri',
	extended = true,
	size = 27,
	blursize = 5,
	weight = 350,
})

surface.CreateFont('f4.medium', {
	font = 'Calibri',
	extended = true,
	size = 42,
	weight = 350,
})
surface.CreateFont('f4.medium-sh', {
	font = 'Calibri',
	extended = true,
	size = 42,
	blursize = 8,
	weight = 350,
})

local function ease(t, b, c, d)

	t = t / d;
	return -c * t * (t - 2) + b

end

local function playTime(time)

	local h, m, s
	h = math.floor(time / 60 / 60)
	m = math.floor(time / 60) % 60
	s = math.floor(time) % 60

	return string.format('%02i:%02i:%02i', h, m, s)

end

local function drawText(text, font, x, y, xal, yal, col, shCol)

	draw.Text {
		text = text,
		font = font .. '-sh',
		pos = {x, y+2},
		xalign = xal,
		yalign = yal,
		color = shCol,
	}

	draw.Text {
		text = text,
		font = font,
		pos = {x, y},
		xalign = xal,
		yalign = yal,
		color = col,
	}

end

local cols = {
	txt = Color(238,238,238, 255),
	txtSh = Color(0,0,0, 255),
	indicator = Color(255,255,255, 200),
}

local options = {}
local function insertAndSort(data)

	if not data.id then
		error('Cannot add option without "id" field')
		return
	end

	local new = true
	for i, option in ipairs(data) do
		if option.id == data.id then
			options[i] = data
			new = false
			break
		end
	end

	if new then
		table.insert(options, data)
	end

	table.SortByMember(options, 'order', true)

end

local colRed = CFG.skinColors.r
local function paintBut(self, w, h)

	surface.SetAlphaMultiplier(F4.al)

	local open = IsValid(self.window) and self.window:IsVisible()
	surface.SetDrawColor(255,255,255, (open or self.Hovered) and 255 or 150)
	surface.SetMaterial(self.icon)
	surface.DrawTexturedRect(w/2 - 32, h/2 - 32, 64, 64)

	if open then
		draw.RoundedBox(4, w / 2 - 16, -5, 32, 8, cols.indicator)
	end

	if self.counter > 0 then
		surface.DisableClipping(true)
		surface.SetFont('f4.counter')
		local tw = math.max(surface.GetTextSize(self.counter), 8) -- math.max to keep round shape
		local x, y = w / 2 + 30, h / 2 - 30
		draw.RoundedBox(8, x - 4 - tw / 2, y - 8, tw + 8, 16, colRed)
		draw.SimpleText(self.counter, 'f4.counter', tostring(self.counter):len() <= 1 and (x + 1) or x, y, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		surface.DisableClipping(false)
	end

	surface.SetAlphaMultiplier(1)

end

local function showWindow(w)
	w:SetVisible(true)
	if w.showFunc then w:showFunc(true) end

	if not w.oldPos then
		w.oldPos = { w:GetPos() }
		w.oldPos[2] = w.oldPos[2] - 20
	end

	w:MoveToFront()
	w:MoveTo(w.oldPos[1], w.oldPos[2], 0.2, 0, 0.5)
	w:AlphaTo(255, 0.2, 0)
	timer.Simple(0.2, function()
		w:SetVisible(true)
		w:SetAlpha(255)
		w:SetPos(w.oldPos[1], w.oldPos[2])
	end)
end

local function hideWindow(w)
	w.oldPos = { w:GetPos() }
	w:MoveTo(w.oldPos[1], w.oldPos[2] + 20, 0.2, 0, 2)
	w:AlphaTo(0, 0.2, 0)
	timer.Simple(0.2, function()
		if w.showFunc then w:showFunc(false) end
		w:SetPos(w.oldPos[1], w.oldPos[2] + 20)
		w:SetAlpha(0)
		w:SetVisible(false)
	end)
end

local function teamName(ply)
	local name = team.GetName(ply:Team())
	local customJob = ply:GetNetVar('customJob')
	if customJob then name = customJob[1] end
	return name
end

function octogui.reloadF4()

	local ply = LocalPlayer()
	if not IsValid(ply) then return end
	if IsValid(F4) then F4:Remove() end
	table.Empty(options)

	local f = vgui.Create 'DFrame'
	f:SetSize(ScrW(), ScrH())
	f:SetTitle('')
	f:MakePopup()
	f:SetVisible(false)
	f:SetDraggable(false)
	f.btnClose:SetVisible(false)
	f.btnMinim:SetVisible(false)
	f.btnMaxim:SetVisible(false)
	f.openTime = 0
	f.windows = {}
	f.buttons = {}
	f.counters = f.counters or {}
	F4 = f

	hook.Add('VGUIMousePressed', 'f4', function(pnl, but)

		if not F4:IsVisible() then return end
		for i, v in pairs(f.windows) do
			if pnl == v or v:IsOurChild(pnl) then v:MoveToFront() end
		end

	end)

	local bClose = f:Add 'DButton'
	bClose:SetSize(64,64)
	bClose:AlignRight(15)
	bClose:AlignTop(15)
	bClose:SetText('')
	bClose:SetToolTip(L.close)
	bClose.icon = Material('octoteam/icons/cross.png')
	function bClose:DoClick() f:Hide() end
	function bClose:Paint(w, h)
		if self.Hovered then
			surface.SetDrawColor(255,255,255, 255)
		else
			surface.SetDrawColor(0,0,0, 100 * F4.al)
		end
		surface.SetMaterial(self.icon)
		surface.DrawTexturedRect(w/2 - 32, h/2 - 32, 64, 64)
	end

	local blur, skinCols = Material('pp/blurscreen'), CFG.skinColors
	function f:Paint(w, h)
		local a = ease(self.isClosing and (math.max(self.isClosing - CurTime(), 0) / 0.3) or (1 - math.max(self.openTime + 0.3 - CurTime(), 0) / 0.3), 0, 1, 1)
		self.al = a

		local colMod ={
			['$pp_colour_addr'] = 0,
			['$pp_colour_addg'] = 0,
			['$pp_colour_addb'] = 0,
			['$pp_colour_mulr'] = 0,
			['$pp_colour_mulg'] = 0,
			['$pp_colour_mulb'] = 0,
			['$pp_colour_brightness'] = -0.2 * a,
			['$pp_colour_contrast'] = 1 + 0.5 * a,
			['$pp_colour_colour'] = 1 - a,
		}

		if GetConVar('octolib_blur'):GetBool() then
			DrawColorModify(colMod)

			surface.SetDrawColor(255, 255, 255, 255 * a)
			surface.SetMaterial(blur)

			for i = 1, 3 do
				blur:SetFloat('$blur', a * i * 2)
				blur:Recompute()

				render.UpdateScreenEffectTexture()
				surface.DrawTexturedRect(-1, -1, w + 2, h + 2)
			end
		else
			colMod['$pp_colour_brightness'] = -0.4 * a
			colMod['$pp_colour_contrast'] = 1 + 0.2 * a
			DrawColorModify(colMod)
		end

		draw.NoTexture()
		surface.SetDrawColor(skinCols.bg.r, skinCols.bg.g, skinCols.bg.b, 100 * a)
		surface.DrawRect(-1, -1, w + 2, h + 2)

		surface.SetFont('f4.medium')
		local ply = LocalPlayer()
		local hvrPnl = vgui.GetHoveredPanel()

		surface.SetAlphaMultiplier(a)
		drawText(
			teamName(ply) .. ' ' .. ply:Name(), 'f4.medium', w / 2, 15,
			TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, cols.txt, cols.txtSh
		)

		-- center
		if IsValid(hvrPnl) and hvrPnl.barTxt then
			drawText(
				hvrPnl.barTxt, 'f4.medium', w / 2, h - 80,
				TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, cols.txt, cols.txtSh
			)
		end

		-- bottom left
		drawText(
			L.purse_hint .. DarkRP.formatMoney(ply:GetNetVar('money')), 'f4.normal', 10, h - 8,
			TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, cols.txt, cols.txtSh
		) drawText(
			L.salary_hint .. DarkRP.formatMoney(ply:Salary()), 'f4.normal', 10, h - 32,
			TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, cols.txt, cols.txtSh
		)
		local sweets = ply:GetNetVar('sweets')
		if sweets then
			drawText(
				'Конфет: ' .. octolib.string.separateDigits(sweets), 'f4.normal', 10, h - 56,
				TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, cols.txt, cols.txtSh
			)
		end

		-- bottom left
		drawText(
			L.players_hint .. player.GetCount(), 'f4.normal', w - 10, h - 56,
			TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM, cols.txt, cols.txtSh
		) drawText(
			'Полицейских: ' .. #player.GetPolice(), 'f4.normal', w - 10, h - 32,
			TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM, cols.txt, cols.txtSh
		) drawText(
			L.play_time_hint .. playTime(LocalPlayer():GetTimeTotal()), 'f4.normal', w - 10, h - 8,
			TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM, cols.txt, cols.txtSh
		)
		surface.SetAlphaMultiplier(1)

	end

	local p = f:Add 'DPanel'
	p:SetPos(0, ScrH() - 75)
	p:SetTall(70)
	function p:Paint(w, h)

		draw.RoundedBox(4, 0, 0, w, h, Color(0,0,0, 100 * F4.al))

	end

	f.openWindow = {}
	function p:Update()

		self:Clear()
		f.openWindow = {}

		local butsNum = 0
		for i, v in ipairs(options) do
			if not v.check or v.check() then
				local b = p:Add 'DButton'
				b:SetSize(75,70)
				b:SetPos(3 + (i-1) * 75, 0)
				b:SetText('')
				-- b:SetToolTip(v.name)
				b.barTxt = v.name
				b.icon = v.icon
				b.Paint = paintBut
				b.window = f.windows[i]
				b.counter = F4.counters[v.id] or 0
				function b:DoClick(onlyOpen)
					local w = f.windows[i]
					if IsValid(w) then
						local st = not w:IsVisible()
						if st then
							showWindow(w)
						elseif not onlyOpen then
							hideWindow(w)
						end
						self.window = w
						return
					end

					local w = f:Add 'DFrame'
					w:SetTitle(v.name)
					w.btnMaxim:SetVisible(false)
					w.btnMinim:SetVisible(false)
					v.build(w)
					w.showFunc = v.show
					w:SetPos(self:LocalToScreen(32, 32) - w:GetWide() / 2, 0)
					w:CenterVertical()
					w:SetDeleteOnClose(false)
					showWindow(w)
					function w.btnClose:DoClick() hideWindow(w) end

					f.windows[i] = w
					self.window = f.windows[i]
				end
				f.openWindow[v.id] = function() b:DoClick(true) end
				f.buttons[v.id] = b
				butsNum = butsNum + 1

				if IsValid(f.windows[i]) then
					local w = f.windows[i]
					if w.wasVisible then
						showWindow(w)
					end
				end
			else
				if IsValid(f.windows[i]) then
					f.windows[i]:Remove()
					f.windows[i] = nil
				end
			end
		end

		self:SetWide(butsNum * 75 + 6)
		self:CenterHorizontal()

	end

	function F4:Update()
		p:Update()
	end

	function F4:Think()
		if self:IsVisible() and gui.IsGameUIVisible() then
			self:Hide()
		end
	end

	function F4:SetCounter(id, amount)

		F4.counters[id] = amount

		local but = f.buttons[id]
		if IsValid(but) then
			but.counter = amount
		end

	end

	local lastCursorPos = { ScrW() / 2, ScrH() / 2 }
	function F4:Show()

		if self.isClosing then return end

		self.openTime = CurTime()
		self:SetVisible(true)
		self:SetMouseInputEnabled(true)
		self:SetKeyboardInputEnabled(true)
		self:Update()

		gui.SetMousePos(lastCursorPos[1], lastCursorPos[2])

	end

	function F4:Hide()

		if self.isClosing then return end

		for i, w in pairs(f.windows) do
			w.wasVisible = w:IsVisible()
			if w.wasVisible then hideWindow(w) end
		end

		gui.HideGameUI()
		lastCursorPos[1], lastCursorPos[2] = gui.MousePos()

		self:SetMouseInputEnabled(false)
		self:SetKeyboardInputEnabled(false)
		self.isClosing = CurTime() + 0.3
		timer.Simple(0.5, function()
			self.isClosing = nil
			self:SetVisible(false)
		end)

	end

	function F4:Toggle()

		if self:IsVisible() then
			self:Hide()
		else
			self:Show()
		end

	end

	function F4:OpenWindow(id)

		if self.openWindow[id] then
			if not self:IsVisible() then self:Show() end
			self.openWindow[id]()
		end

	end

	hook.Add('ShowSpare2', 'f4', function()

		if IsValid(F4) then
			F4:Toggle()
		else
			octolib.notify.show('warning', L.f4_failure)
		end

	end)

	function F4:OnKeyCodeReleased(key)

		if input.LookupKeyBinding(key) == 'gm_showspare2' then
			F4:Hide()
		end

	end

	function octogui.addToF4(data)
		insertAndSort(data)
		F4:Update()
	end

	hook.Run('octogui.f4-tabs')

end

concommand.Add('octogui_reloadf4', octogui.reloadF4)

hook.Add('Think', 'f4.init', function()
	hook.Remove('Think', 'f4.init')
	octogui.reloadF4()
end)
