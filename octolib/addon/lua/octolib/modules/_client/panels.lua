--[[
	Namespace: octolib

	Group: panels
]]

local function doMenu(m, entries)

	for i, entry in ipairs(entries) do
		if istable(entry) then
			local name, icon, more = unpack(entry)

			local sm, mo
			if isfunction(more) then
				mo = m:AddOption(name, more)
			elseif istable(more) then
				sm, mo = m:AddSubMenu(name)
				doMenu(sm, more)
			end

			if icon and mo then mo:SetIcon(icon) end
		elseif entry == 'spacer' then
			m:AddSpacer()
		end
	end

end

--[[
	Function: menu
		Builds interactive context menu

	Arguments:
		<table> entries - Sequential table of <ContextMenuItem>

	Returns:
		<Panel> - <DMenu: https://wiki.facepunch.com/gmod/DMenu>

	Example:
		--- Lua
		local m = octolib.menu({
			{ 'Hello', 'icon16/tick.png', function() print('Hello') end }, -- with icon
			{ 'I am', nil, function() print('There') end }, -- without icon
			{ 'Menu', nil, { -- with submenu
				{ 'Submenu item', nil, function() print('So sub') end },
			}},
		})

		m:Open()
		---
]]
function octolib.menu(entries)

	local m = DermaMenu()
	doMenu(m, entries)

	return m

end

function octolib.fQuery(...)

	local args = {...}
	return function() Derma_Query(unpack(args)) end

end

function octolib.fStringRequest(...)

	local args = {...}
	return function() Derma_StringRequest(unpack(args)) end

end

function octolib.overlay(pnl, clOrPnl, persist, col)

	local o = vgui.Create(persist and 'DPanel' or 'DButton')
	if IsValid(pnl) then pnl:Add(o) end

	local p
	if isstring(clOrPnl) then
		p = o:Add(clOrPnl)
	else
		clOrPnl:SetParent(o)
		p = clOrPnl
	end

	function o:Think()
		local parent = self:GetParent()
		if not IsValid(parent) then return end

		local newW, newH = parent:GetSize()
		if newW ~= self.overlay_oldW or self.overlay_oldH ~= newH then
			self:SetPos(0, 0)
			self:SetSize(newW, newH)
			if IsValid(p) then p:Center() end
		end
		self.overlay_oldW, self.overlay_oldH = newW, newH
	end

	o.bgCol = col or Color(0,0,0, 200)
	function o:Paint(w, h)
		draw.RoundedBox(4, 0, 0, w, h, self.bgCol)
	end

	if not persist then
		o:SetText('')
		function o:DoClick()
			self:Remove()
		end
	end

	function p:OnRemove() o:Remove() end

	return p, o

end

--
-- QUICK PANEL CREATION
--

function octolib.button(pnl, txt, click)

	local b = vgui.Create 'DButton'
	if pnl.AddItem then pnl:AddItem(b) else pnl:Add(b) end
	b:Dock(TOP)
	b:SetTall(25)
	b:SetText(txt)
	b.DoClick = click

	return b

end

function octolib.label(pnl, txt)

	local t = vgui.Create 'DLabel'
	if pnl.AddItem then pnl:AddItem(t) else pnl:Add(t) end
	t:Dock(TOP)
	t:SetTall(18)
	t:SetContentAlignment(4)
	t:SetText(txt)

	return t

end

function octolib.slider(pnl, txt, min, max, prc)

	local e = vgui.Create 'DNumSlider'
	if pnl.AddItem then pnl:AddItem(e) else pnl:Add(e) end
	e:Dock(TOP)
	e:SetTall(30)
	e:SetText(txt)
	e:SetMinMax(min, max)
	e:SetDecimals(prc)
	e.Slider.Knob:NoClipping(false)

	return e

end

function octolib.checkBox(pnl, txt)

	local e = vgui.Create 'DCheckBoxLabel'
	if pnl.AddItem then pnl:AddItem(e) else pnl:Add(e) end
	e:Dock(TOP)
	e:DockMargin(0, 5, 0, 5)
	e:SetText(txt)

	return e

end

function octolib.textEntry(pnl, txt)

	local t = txt and octolib.label(pnl, txt) or nil
	if t then
		t:DockMargin(3, 5, 0, 0)
	end

	local e = vgui.Create 'DTextEntry'
	if pnl.AddItem then pnl:AddItem(e) else pnl:Add(e) end
	e:Dock(TOP)
	e:SetTall(25)
	e:DockMargin(0, 0, 0, 5)

	return e, t

end

function octolib.numberWang(pnl, txt, val, min, max)

	local t = txt and octolib.label(pnl, txt) or nil
	if t then
		t:DockMargin(3, 5, 0, 0)
	end

	local e = vgui.Create 'DNumberWang'
	if pnl.AddItem then pnl:AddItem(e) else pnl:Add(e) end
	e:Dock(TOP)
	e:SetTall(25)
	e:DockMargin(0, 0, 0, 5)
	if min then e:SetMin(min) end
	if max then e:SetMax(max) end
	if val then e:SetValue(val) end

	function e.Up:DoClick()
		if e:IsEnabled() then
			e:SetValue(e:GetValue() + e:GetInterval())
		end
	end
	function e.Down:DoClick()
		if e:IsEnabled() then
			e:SetValue(e:GetValue() - e:GetInterval())
		end
	end
	function e:OnChange()
		local val = self:GetValue()
		local fixed = val
		if self:GetMin() then fixed = math.max(self:GetMin(), fixed) end
		if self:GetMax() then fixed = math.min(self:GetMax(), fixed) end
		fixed = math.Round(fixed, self:GetDecimals())
		if fixed ~= val then
			local cpos = self:GetCaretPos()
			self:SetText(fixed)
			self:SetCaretPos(math.min(cpos, utf8.len(tostring(fixed))))
		else
			self:OnValueChanged(val)
		end
	end

	return e, t

end

function octolib.colorPicker(pnl, txt, enableAlpha, enablePalette)

	local t = txt and octolib.label(pnl, txt) or nil
	if t then
		t:DockMargin(3, 5, 0, 0)
	end

	local e = vgui.Create 'DColorMixer'
	if pnl.AddItem then pnl:AddItem(e) else pnl:Add(e) end
	e:Dock(TOP)
	e:SetTall(150)
	e:DockMargin(0, 0, 0, 5)
	e:SetAlphaBar(enableAlpha == true)
	e:SetWangs(true)
	e:SetPalette(enablePalette == true)

	return e, t

end

function octolib.comboBox(pnl, txt, choices)

	local t = txt and octolib.label(pnl, txt) or nil
	if t then
		t:DockMargin(3, 5, 0, 0)
	end

	local e = vgui.Create 'DComboBox'
	if pnl.AddItem then pnl:AddItem(e) else pnl:Add(e) end
	e:Dock(TOP)
	e:SetTall(25)
	e:DockMargin(0, 0, 0, 5)
	e:SetSortItems(false)

	choices = choices or {}
	for i, v in ipairs(choices) do
		e:AddChoice(v[1], v[2], v[3])
	end

	return e, t

end

function octolib.textEntryIcon(pnl, txt, path)

	local t = txt and octolib.label(pnl, txt) or nil
	if t then
		t:DockMargin(3, 5, 0, 0)
	end

	local e = vgui.Create 'DTextEntry'
	if pnl.AddItem then pnl:AddItem(e) else pnl:Add(e) end
	e:Dock(TOP)
	e:SetTall(25)
	e:DockMargin(0, 0, 0, 5)

	local b = e:Add 'DButton'
	b:Dock(RIGHT)
	b:SetWide(25)
	b:SetText('')
	b:SetIcon('icon16/color_swatch.png')
	b:SetPaintBackground(false)
	function b:DoClick()
		if IsValid(self.picker) then return end
		self.picker = octolib.icons.picker(function(val) e:SetValue(val) end, e:GetValue(), path)
	end

	return e, t

end

function octolib.confirmDialog(pnl, question, callback, noCancel)
	local fr = octolib.overlay(pnl, 'DPanel')
	fr:SetSize(180, 60)
	octolib.label(fr, question):SetContentAlignment(5)
	local btmPan = fr:Add('DPanel')
	btmPan:Dock(FILL)
	btmPan:SetPaintBackground(false)
	local btn = octolib.button(btmPan, 'Да', function() callback(true) fr:Remove() end)
	btn:Dock(LEFT)
	btn:SetWide(50)
	btn:DockMargin(5, 0, 5, 5)
	local btn = octolib.button(btmPan, 'Нет', function() callback(false) fr:Remove() end)
	btn:Dock(LEFT)
	btn:SetWide(50)
	btn:DockMargin(5, 0, 5, 5)
	if not noCancel then
		local btn = octolib.button(btmPan, 'Отмена', function() fr:Remove() end)
		btn:Dock(FILL)
		btn:DockMargin(5, 0, 5, 5)
	end
end

function octolib.binder(pnl, txt, val)
	local t = txt and octolib.label(pnl, txt) or nil
	if t then
		t:DockMargin(3, 5, 0, 0)
	end

	local b = vgui.Create 'DBinder'
	if pnl.AddItem then pnl:AddItem(b) else pnl:Add(b) end
	b:Dock(TOP)
	b:SetTall(24)
	b:SetContentAlignment(5)

	return b
end

hook.Add('Think', 'octolib.panels', function()
	hook.Remove('Think', 'octolib.panels')

	local Panel = FindMetaTable 'Panel'
	surface.CreateFont('octolib.hint', {
		font = 'Calibri',
		extended = true,
		size = 18,
		weight = 350,
	})

	surface.CreateFont('octolib.hint-sh', {
		font = 'Calibri',
		extended = true,
		size = 40,
		weight = 350,
		blursize = 10,
	})

	local function paintHint(self, w, h)
		surface.DisableClipping(true)

		local al = self.anim
		surface.SetFont('octolib.hint')
		local tw, th = surface.GetTextSize(self.hint)
		local x, y = w / 2, -16*#self.lines

		self.shText = self.shText or ('|'):rep(math.floor((tw+30)/15))
		draw.SimpleText(self.shText, 'octolib.hint-sh', x, y, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

		draw.RoundedBox(4, (w-tw-14) / 2, y - 10, tw + 14, -y+6, Color(170,119,102, al*255))
		for i, line in ipairs(self.lines) do
			draw.SimpleText(line, 'octolib.hint', x, y+(i-1)*16, Color(255,255,255, al*255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
		draw.SimpleText('u', 'marlett', x, -10, Color(170,119,102, al*255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

		surface.DisableClipping(false)
	end

	local function thinkHint(self)
		self.anim = math.Approach( self.anim, self.Hovered and 1 or 0, FrameTime() / 0.1 )
	end

	-- Class: Panel

	--[[
		Function: AddHint
			Adds simple fading tooltop above the panel generally used to place usage hints

		Arguments:
			<string> text - Text to place into tooltip
	]]
	function Panel:AddHint(text)
		self.realPaint = self.realPaint or self.Paint or function() end
		self.realThink = self.realThink or self.Think or function() end
		self.realEnter = self.realEnter or self.OnCursorEntered or function() end
		self.realExit = self.realExit or self.OnCursorExited or function() end

		self.anim = 0
		self.hint = isfunction(text) and '' or text or 'Hint text'
		self.lines = self.hint:split('\n')

		self.Paint = function(self, w, h)
			if self.anim > 0 then paintHint(self, w, h) end
			self:realPaint(w, h)
		end

		self.Think = function(self)
			self:realThink()
			thinkHint(self)
			if self.anim > 0 and isfunction(text) then
				self.hint = text()
				self.lines = self.hint:split('\n')
			end
		end

		self.OnCursorEntered = function(self)
			self:realEnter()
			self:SetDrawOnTop(true)
		end

		self.OnCursorExited = function(self)
			self:realExit()
			self:SetDrawOnTop(false)
		end
	end
end)
