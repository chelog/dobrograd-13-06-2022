
-- Copyright (C) 2020 DBotThePony

-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
-- of the Software, and to permit persons to whom the Software is furnished to do so,
-- subject to the following conditions:

-- The above copyright notice and this permission notice shall be included in all copies
-- or substantial portions of the Software.

-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
-- INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
-- PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
-- FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
-- OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
-- DEALINGS IN THE SOFTWARE.

local ENABLE_GMOD_ALPHA_WANG = CreateConVar('cl_dlib_colormixer_oldalpha', '0', {FCVAR_ARCHIVE}, 'Enable gmod styled alpha bar in color mixers')
local ENABLE_GMOD_HUE_WANG = CreateConVar('cl_dlib_colormixer_oldhue', '0', {FCVAR_ARCHIVE}, 'Enable gmod styled hue bar in color mixers')
local ENABLE_WANG_BARS = CreateConVar('cl_dlib_colormixer_wangbars', '1', {FCVAR_ARCHIVE}, 'Enable color wang bars')

cvars.AddChangeCallback('cl_dlib_colormixer_oldalpha', function(cvar, old, new)
	hook.Run('DLib_ColorMixerAlphaUpdate', tobool(new))
end, 'DLib')

cvars.AddChangeCallback('cl_dlib_colormixer_wangbars', function(cvar, old, new)
	hook.Run('DLib_ColorMixerWangBarsUpdate', tobool(new))
end, 'DLib')

cvars.AddChangeCallback('cl_dlib_colormixer_oldhue', function(cvar, old, new)
	hook.Run('DLib_ColorMixerWangHueUpdate', tobool(new))
end, 'DLib')

local gradient_r = Material('vgui/gradient-r')
local alpha_grid = Material('gui/alpha_grid.png', 'nocull')
local hue_picker = Material('gui/colors.png')

local PANEL = {}

AccessorFunc(PANEL, 'wang_position', 'WangPosition')

function PANEL:Init()
	self.wang_position = 0.5
	self:SetSize(200, 20)
end

function PANEL:OnCursorMoved(x, y)
	if not input.IsMouseDown(MOUSE_LEFT) then return end
	local wang_position = math.clamp(x / self:GetWide(), 0, 1)

	if wang_position ~= self.wang_position then
		self:ValueChanged(self.wang_position, wang_position)
		self.wang_position = wang_position
	end
end

function PANEL:OnMousePressed(mcode)
	if mcode == MOUSE_LEFT then
		self:MouseCapture(true)
		self:OnCursorMoved(self:CursorPos())
	end
end

function PANEL:OnMouseReleased(mcode)
	if mcode == MOUSE_LEFT then
		self:MouseCapture(false)
		self:OnCursorMoved(self:CursorPos())
	end
end

function PANEL:ValueChanged(old, new)

end

function PANEL:PaintWangControls(w, h)
	draw.NoTexture()
	surface.SetDrawColor(0, 0, 0, 255)

	local wpos = math.round(self.wang_position * w)

	surface.DrawPoly({
		{x = wpos - 4, y = 0},
		{x = wpos + 4, y = 0},
		{x = wpos, y = 4},
	})

	surface.SetDrawColor(255, 255, 255, 255)

	surface.DrawPoly({
		{x = wpos - 4, y = h},
		{x = wpos, y = h - 4},
		{x = wpos + 4, y = h},
	})

	surface.SetDrawColor(0, 0, 0, 255)
	surface.DrawLine(0, 0, w, 0)
	surface.DrawLine(0, 0, 0, h)
	surface.DrawLine(w - 1, 0, w - 1, h)
	surface.DrawLine(0, h - 1, w, h - 1)
end

vgui.Register('DLibColorMixer_WangBase', PANEL, 'EditablePanel')

local PANEL = {}

AccessorFunc(PANEL, 'left_color', 'LeftColor')
AccessorFunc(PANEL, 'right_color', 'RightColor')

function PANEL:Init()
	self.left_color = Color(0, 0, 0)
	self.right_color = Color()
end

function PANEL:Paint(w, h)
	surface.SetMaterial(gradient_r)

	surface.SetDrawColor(self.right_color)
	surface.DrawTexturedRect(0, 0, w, h)

	surface.SetDrawColor(self.left_color)
	surface.DrawTexturedRectUV(0, 0, w, h, 1, 1, 0, 0)

	self:PaintWangControls(w, h)
end

vgui.Register('DLibColorMixer_RGBWang', PANEL, 'DLibColorMixer_WangBase')

local PANEL = {}

function PANEL:Paint(w, h)
	surface.SetMaterial(hue_picker)

	surface.SetDrawColor(255, 255, 255)
	surface.DrawTexturedRectRotated(w / 2, h / 2, h, w, -90)

	self:PaintWangControls(w, h)
end

vgui.Register('DLibColorMixer_HueWang', PANEL, 'DLibColorMixer_WangBase')

local PANEL = {}

AccessorFunc(PANEL, 'base_color', 'BaseColor')

function PANEL:Init()
	self.base_color = Color()
end

local ALPHA_GRID_SIZE = 128

function PANEL:Paint(w, h)
	surface.SetDrawColor(255, 255, 255, 255)
	surface.SetMaterial(alpha_grid)

	for i = 0, math.ceil(w / ALPHA_GRID_SIZE) do
		surface.DrawTexturedRect(i * ALPHA_GRID_SIZE, 0, ALPHA_GRID_SIZE, ALPHA_GRID_SIZE)
	end

	surface.SetMaterial(gradient_r)

	surface.SetDrawColor(self.base_color)
	surface.DrawTexturedRect(0, 0, w, h)

	self:PaintWangControls(w, h)
end

vgui.Register('DLibColorMixer_AlphaWang', PANEL, 'DLibColorMixer_WangBase')

local PANEL = {}

local rgba = {
	'red', 'green', 'blue', 'alpha'
}

local hsv = {
	'hue', 'saturation', 'value'
}

local wang_panels = table.qcopy(rgba)
table.append(wang_panels, hsv)

function PANEL:Init()
	self.wang_canvas = vgui.Create('EditablePanel', self)
	self.wang_canvas:Dock(RIGHT)
	-- self.wang_canvas:SetWide(200)

	self.rgb_canvas = vgui.Create('EditablePanel', self.wang_canvas)
	self.rgb_canvas:Dock(TOP)
	self.rgb_canvas:SetZPos(0)
	self.rgb_canvas:DockPadding(5, 0, 5, 0)

	self.wang_label_rgb = vgui.Create('DLabel', self.rgb_canvas)
	self.wang_label_rgb:SetText('RGB')
	self.wang_label_rgb:Dock(LEFT)
	-- self.wang_label_rgb:DockMargin(0, 0, 0, 5)
	self.wang_label_rgb:SizeToContents()

	self.palette_button = vgui.Create('DButton', self.rgb_canvas)
	self.palette_button:Dock(RIGHT)
	self.palette_button:SetText('...')
	self.palette_button:SizeToContents()
	self.palette_button:SetWide(self.palette_button:GetWide() + 6)
	self.palette_button:SetZPos(-1)

	function self.palette_button.DoClick()
		self:OpenPaletteWindow()
	end

	local add = 1

	for i, panelname in ipairs(wang_panels) do
		if panelname == 'hue' then
			self.wang_label_hsv = vgui.Create('DLabel', self.wang_canvas)
			self.wang_label_hsv:SetText('   HSV')
			self.wang_label_hsv:Dock(TOP)
			self.wang_label_hsv:DockMargin(0, 5, 0, 5)
			self.wang_label_hsv:SetZPos(i + add)
			add = add + 1
		end

		self['wang_canvas_' .. panelname] = vgui.Create('EditablePanel', self.wang_canvas)
		self['wang_canvas_' .. panelname]:Dock(TOP)
		self['wang_canvas_' .. panelname]:DockMargin(1, 1, 1, 1)
		self['wang_canvas_' .. panelname]:SetZPos(i + add)
	end

	for i, panelname in ipairs(rgba) do
		self['wang_' .. panelname] = vgui.Create('DNumberWang', self['wang_canvas_' .. panelname])
		self['wang_' .. panelname]:Dock(RIGHT)
		self['wang_' .. panelname]:SetDecimals(0)
		self['wang_' .. panelname]:SetMinMax(0, 255)
		self['wang_' .. panelname]:SetWide(40)

		self['wang_' .. panelname .. '_bar'] = vgui.Create(panelname == 'alpha' and 'DLibColorMixer_AlphaWang' or 'DLibColorMixer_RGBWang', self['wang_canvas_' .. panelname])
		self['wang_' .. panelname .. '_bar']:Dock(FILL)
		self['wang_' .. panelname .. '_bar']:DockMargin(2, 2, 2, 2)
	end

	for i, panelname in ipairs(hsv) do
		self['wang_' .. panelname] = vgui.Create('DNumberWang', self['wang_canvas_' .. panelname])
		self['wang_' .. panelname]:Dock(RIGHT)
		self['wang_' .. panelname]:SetDecimals(0)
		self['wang_' .. panelname]:SetMinMax(0, 100)
		self['wang_' .. panelname]:SetWide(40)
	end

	self.wang_hue_bar = vgui.Create('DLibColorMixer_HueWang', self.wang_canvas_hue)
	self.wang_hue_bar:Dock(FILL)
	self.wang_hue_bar:DockMargin(2, 2, 2, 2)

	function self.wang_hue_bar.ValueChanged(wang_hue_bar, oldvalue, newvalue)
		self.update = true
		self.wang_hue:SetValue(math.round(newvalue * 360))
		self.update = false

		self:UpdateFromHSVWangs('hue', 'bar')
	end

	self.wang_saturation_bar = vgui.Create('DLibColorMixer_RGBWang', self.wang_canvas_saturation)
	self.wang_saturation_bar:Dock(FILL)
	self.wang_saturation_bar:DockMargin(2, 2, 2, 2)

	function self.wang_saturation_bar.ValueChanged(wang_saturation_bar, oldvalue, newvalue)
		self.update = true
		self.wang_saturation:SetValue(math.round(newvalue * 100))
		self.update = false

		self:UpdateFromHSVWangs('saturation', 'bar')
	end

	self.wang_value_bar = vgui.Create('DLibColorMixer_RGBWang', self.wang_canvas_value)
	self.wang_value_bar:Dock(FILL)
	self.wang_value_bar:DockMargin(2, 2, 2, 2)

	function self.wang_value_bar.ValueChanged(wang_value_bar, oldvalue, newvalue)
		self.update = true
		self.wang_value:SetValue(math.round(newvalue * 100))
		self.update = false

		self:UpdateFromHSVWangs('value', 'bar')
	end

	self.hex_canvas = vgui.Create('EditablePanel', self.wang_canvas)
	self.hex_canvas:Dock(TOP)
	self.hex_canvas:SetZPos(50)

	self.hex_label = vgui.Create('DLabel', self.hex_canvas)
	self.hex_label:Dock(LEFT)
	self.hex_label:SetText('HEX:')
	self.hex_label:DockMargin(5, 0, 0, 0)
	self.hex_label:SetZPos(1)

	self.hex_input = vgui.Create('DTextEntry', self.hex_canvas)
	self.hex_input:Dock(FILL)
	self.hex_input:SetText('fff')
	self.hex_input:SetUpdateOnType(true)
	self.hex_input:SetZPos(2)

	function self.hex_input.OnValueChange(hex_input, newvalue)
		if self.update then return end
		self:ParseHexInput(newvalue, true)
	end

	self.wang_hue:SetMinMax(0, 360)

	self:BindRegularWang(self.wang_red, '_r')
	self:BindRegularWang(self.wang_green, '_g')
	self:BindRegularWang(self.wang_blue, '_b')
	self:BindRegularWang(self.wang_alpha, '_a')

	self:BindRegularWangBar(self.wang_red_bar, '_r')
	self:BindRegularWangBar(self.wang_green_bar, '_g')
	self:BindRegularWangBar(self.wang_blue_bar, '_b')
	self:BindRegularWangBar(self.wang_alpha_bar, '_a')

	self:BindHSVWang(self.wang_hue, 'hue')
	self:BindHSVWang(self.wang_saturation, 'saturation')
	self:BindHSVWang(self.wang_value, 'value')

	self.wang_value_bar:SetLeftColor(Color(0, 0, 0))
	self.wang_saturation_bar:SetLeftColor(Color(0, 0, 0))

	self.color_cube = vgui.Create('DColorCube', self)
	self.color_cube:Dock(FILL)

	function self.color_cube.OnUserChanged(color_cube, newvalue)
		newvalue:SetAlpha(self._a)
		self:_SetColor(newvalue)
		self:UpdateData('color_cube')
	end

	self.color_wang = vgui.Create('DRGBPicker', self)
	self.color_wang:Dock(RIGHT)
	self.color_wang:SetWide(26)

	self.alpha_wang = vgui.Create('DAlphaBar', self)
	self.alpha_wang:Dock(RIGHT)
	self.alpha_wang:SetWide(26)

	function self.color_wang.OnChange(color_wang, newvalue)
		if self.update then return end

		local h, s, v = ColorToHSV(self:GetColor())
		local h2, s2, v2 = ColorToHSV(newvalue)
		self:_SetColor(HSVToColor(h2, s, v):SetAlpha(self._a))
		self:UpdateData('hue_wang_old')
	end

	function self.alpha_wang.OnChange(color_wang, newvalue)
		self._a = math.round(newvalue * 255)
		self:UpdateData('alpha_wang_old')
	end

	self._r = 255
	self._g = 255
	self._b = 255
	self._a = 255
	self.update = false

	self.allow_alpha = true
	self.tall_layout = false

	hook.Add('DLib_ColorMixerAlphaUpdate', self, self.DLib_ColorMixerAlphaUpdate)
	hook.Add('DLib_ColorMixerWangBarsUpdate', self, self.DLib_ColorMixerWangBarsUpdate)
	hook.Add('DLib_ColorMixerWangHueUpdate', self, self.DLib_ColorMixerWangHueUpdate)

	if not ENABLE_GMOD_ALPHA_WANG:GetBool() then
		self.alpha_wang:SetVisible(false)
	end

	if not ENABLE_WANG_BARS:GetBool() then
		self.wang_red_bar:SetVisible(false)
		self.wang_green_bar:SetVisible(false)
		self.wang_blue_bar:SetVisible(false)
		self.wang_alpha_bar:SetVisible(false)

		self.wang_hue_bar:SetVisible(false)
		self.wang_saturation_bar:SetVisible(false)
		self.wang_value_bar:SetVisible(false)
	end

	if not ENABLE_GMOD_HUE_WANG:GetBool() then
		self.color_wang:SetVisible(false)
	end

	self:UpdateData()
	self:SetTall(260)
end

do
	local function paletteStuff(self, palette)
		function palette.DoClick(_, color_chosen, button)
			local copy = Color(color_chosen)
			if not self:GetAllowAlpha() then copy:SetAlpha(255) end
			self:_SetColor(copy)
			self:UpdateData()
		end

		function palette.OnRightClickButton(_, button)
			local menu = DermaMenu()

			menu:AddOption('gui.dlib.colormixer.save_color', function()
				palette:SaveColor(button, self:GetColor())
			end)

			menu:AddOption('gui.dlib.colormixer.copy_color', function()
				local color = button:GetColor()

				if self:GetAllowAlpha() then
					SetClipboardText(string.format('%d, %d, %d, %d', color.r, color.g, color.b, color.a))
				else
					SetClipboardText(string.format('%d, %d, %d', color.r, color.g, color.b))
				end
			end)

			menu:AddOption('gui.dlib.colormixer.copy_hex_color', function()
				local color = button:GetColor()

				if self:GetAllowAlpha() then
					SetClipboardText(string.format('%.2x%.2x%.2x%.2x', color.r, color.g, color.b, color.a))
				else
					SetClipboardText(string.format('%.2x%.2x%.2x', color.r, color.g, color.b))
				end
			end)

			local submenu, button_child = menu:AddSubMenu('gui.dlib.colormixer.reset_palette')

			submenu:AddOption('gui.dlib.colormixer.reset_palette_confirm', function()
				palette:ResetSavedColors()
			end)

			menu:Open()
		end
	end

	function PANEL:OpenPaletteWindow()
		local posX, posY = self:LocalToScreen(self:GetWide(), 0)
		posX = posX + 14

		if IsValid(self.palette_frame) then
			self.palette_frame:SetPos(posX, posY)
			self.palette_frame:MakePopup()

			return
		end

		local original_color = self:GetColor()

		local frame = vgui.Create('DLib_Window')
		frame:SetSize(420, 450)
		frame:SetTitle('gui.dlib.colormixer.palette_window')
		frame:SetPos(posX, posY)
		frame:MakePopup()

		self.palette_frame = frame

		local label = vgui.Create('DLabel', frame)
		label:Dock(TOP)
		label:SetText('gui.dlib.colormixer.palette_regular')
		label:DockMargin(10, 0, 0, 0)

		self.palette = vgui.Create('DColorPalette', frame)
		self.palette:Dock(TOP)
		self.palette:SetButtonSize(16)
		self.palette:SetCookieName('dlib_palette_def')
		self.palette:Reset()
		self.palette:DockMargin(5, 5, 5, 5)

		label = vgui.Create('DLabel', frame)
		label:Dock(TOP)
		label:SetText('gui.dlib.colormixer.palette_extended')
		label:DockMargin(10, 0, 0, 0)

		self.palette_extended = vgui.Create('DColorPalette', frame)
		self.palette_extended:Dock(FILL)
		self.palette_extended:SetButtonSize(16)
		self.palette_extended:SetNumRows(50)
		self.palette_extended:SetCookieName('dlib_palette_ext')
		self.palette_extended:Reset()
		self.palette_extended:DockMargin(5, 5, 5, 5)

		paletteStuff(self, self.palette)
		paletteStuff(self, self.palette_extended)

		local color_button = vgui.Create('DButton', frame)
		color_button:Dock(BOTTOM)
		color_button:SetText('coolors.co')
		color_button:DockMargin(5, 5, 5, 5)
		color_button:SetZPos(1)

		function color_button.DoClick()
			gui.OpenURL('https://coolors.co/palettes/trending')
		end

		color_button = vgui.Create('DButton', frame)
		color_button:Dock(BOTTOM)
		color_button:SetText('mycolor.space')
		color_button:DockMargin(5, 5, 5, 5)
		color_button:SetZPos(0)

		function color_button.DoClick()
			gui.OpenURL('https://mycolor.space/')
		end
	end
end

function PANEL:SetPalette()
	-- NO OP
end

function PANEL:GetPalette()
	return true
end

function PANEL:ParseHexInput(input, fromForm)
	if input[1] == '#' then
		input = input:sub(2)
	end

	if input:startsWith('0x') then
		input = input:sub(3)
	end

	local r, g, b, a

	if #input == 3 then
		r, g, b = input[1]:tonumber(16), input[2]:tonumber(16), input[3]:tonumber(16)
	elseif #input == 4 then
		r, g, b, a = input[1]:tonumber(16), input[2]:tonumber(16), input[3]:tonumber(16), input[4]:tonumber(16)
	elseif #input == 6 then
		r, g, b = input:sub(1, 2):tonumber(16), input:sub(3, 4):tonumber(16), input:sub(5, 6):tonumber(16)
	elseif #input == 8 then
		r, g, b, a = input:sub(1, 2):tonumber(16), input:sub(3, 4):tonumber(16), input:sub(5, 6):tonumber(16), input:sub(7, 8):tonumber(16)
	end

	if not r or not g or not b then return end

	if #input < 6 then
		r, g, b = r * 0x10, g * 0x10, b * 0x10

		if a then
			a = a * 0x10
		end
	end

	if not self.allow_alpha then a = 255 end

	self:_SetColor(Color(r, g, b, a))
	self:UpdateData('hex')
end

function PANEL:DisableTallLayout()
	self.color_cube:Dock(FILL)
	self.color_cube:DockMargin(0, 0, 0, 0)

	self.wang_canvas:Dock(RIGHT)

	for i, panelname in ipairs(rgba) do
		self['wang_canvas_' .. panelname]:SetParent(self.wang_canvas)
		self['wang_' .. panelname]:Dock(RIGHT)
	end

	for i, panelname in ipairs(hsv) do
		self['wang_canvas_' .. panelname]:SetParent(self.wang_canvas)
	end

	self.hex_canvas:SetParent(self.wang_canvas)

	if IsValid(self.wang_canvas_left) then
		self.wang_canvas_left:Remove()
	end

	if IsValid(self.wang_canvas_right) then
		self.wang_canvas_right:Remove()
	end

	self.palette_button:SetParent(self.rgb_canvas)
	self.palette_button:Dock(RIGHT)

	self:SetTall(260)
	self:InvalidateLayout()
end

function PANEL:EnableTallLayout()
	self.color_cube:Dock(TOP)
	self.color_cube:SetTall(200)
	self.color_cube:DockMargin(4, 4, 4, 4)

	self.wang_canvas:Dock(FILL)

	self.wang_canvas_left = vgui.Create('EditablePanel', self)
	self.wang_canvas_left:Dock(LEFT)

	self.wang_canvas_right = vgui.Create('EditablePanel', self)
	self.wang_canvas_right:Dock(RIGHT)

	for i, panelname in ipairs(rgba) do
		self['wang_canvas_' .. panelname]:SetParent(self.wang_canvas_left)
		self['wang_' .. panelname]:Dock(LEFT)
	end

	for i, panelname in ipairs(hsv) do
		self['wang_canvas_' .. panelname]:SetParent(self.wang_canvas_right)
	end

	self.hex_canvas:SetParent(self.wang_canvas_right)

	self.palette_button:SetParent(self.hex_canvas)
	self.palette_button:Dock(LEFT)

	self:SetTall(320)
	self:InvalidateLayout()
end

function PANEL:SetTallLayout(shoulddo)
	if self.tall_layout == shoulddo then return end

	self.tall_layout = shoulddo

	if shoulddo then
		self:EnableTallLayout()
	else
		self:DisableTallLayout()
	end
end

function PANEL:PerformLayout()
	if self.tall_layout and IsValid(self.wang_canvas_left) then
		local wide = self:GetWide()
		self.wang_canvas_left:SetWide(wide / 2)
		self.wang_canvas_right:SetWide(wide / 2)
	else
		self.wang_canvas:SetWide(ENABLE_WANG_BARS:GetBool() and math.clamp(self:GetWide() * 0.4, 80, 170) or 60)
	end
end

function PANEL:DLib_ColorMixerAlphaUpdate(newvalue)
	if newvalue and self.allow_alpha then
		if IsValid(self.alpha_wang) then
			self.alpha_wang:SetVisible(true)
			self:InvalidateLayout()
		end
	else
		if IsValid(self.alpha_wang) then
			self.alpha_wang:SetVisible(false)
			self:InvalidateLayout()
		end
	end
end

function PANEL:DLib_ColorMixerWangHueUpdate(newvalue)
	self.color_wang:SetVisible(newvalue)
	self:InvalidateLayout()
end

function PANEL:DLib_ColorMixerWangBarsUpdate(newvalue)
	self.wang_red_bar:SetVisible(newvalue)
	self.wang_green_bar:SetVisible(newvalue)
	self.wang_blue_bar:SetVisible(newvalue)

	self.wang_hue_bar:SetVisible(newvalue)
	self.wang_saturation_bar:SetVisible(newvalue)
	self.wang_value_bar:SetVisible(newvalue)

	if newvalue and self.allow_alpha then
		self.wang_alpha_bar:SetVisible(true)
	else
		self.wang_alpha_bar:SetVisible(false)
	end

	self:InvalidateLayout()
end

function PANEL:BindRegularWang(wang, index)
	function wang.OnValueChanged(wang, newvalue)
		if self.update then return end

		self[index] = newvalue
		self:UpdateData(index, 'wang')

		self:ValueChanged(self:GetColor())
		self:UpdateConVars()
	end
end

function PANEL:BindRegularWangBar(wang, index)
	function wang.ValueChanged(wang, oldvalue, newvalue)
		if self.update then return end

		self[index] = newvalue * 255
		self:UpdateData(index, 'bar')

		self:ValueChanged(self:GetColor())
		self:UpdateConVars()
	end
end

function PANEL:BindHSVWang(wang, wang_type)
	function wang.OnValueChanged(wang, newvalue)
		if self.update then return end
		self:UpdateFromHSVWangs(wang_type, 'wang')
	end
end

function PANEL:UpdateHexInput()
	self.update = true

	if self.allow_alpha then
		self.hex_input:SetValue(string.format('%.2x%.2x%.2x%.2x', self._r, self._g, self._b, self._a))
	else
		self.hex_input:SetValue(string.format('%.2x%.2x%.2x', self._r, self._g, self._b))
	end

	self.update = false
end

function PANEL:UpdateData(update_type, update_subtype, ...)
	self:UpdateWangs(update_type, update_subtype, ...)
	self:UpdateWangBars(update_type, update_subtype, ...)
	self:UpdateHSVWangs(update_type, update_subtype, ...)
	self:UpdateHSVWangBars(update_type, update_subtype, ...)

	if update_type ~= 'color_cube' then
		self:UpdateColorCube()
	end

	if update_type ~= 'alpha_wang_old' then
		self:UpdateAlphaBar()
	end

	if update_type ~= 'hue_wang_old' then
		self:UpdateHueBar()
	end

	if update_type ~= 'hex' then
		self:UpdateHexInput()
	end
end

function PANEL:UpdateColorCube()
	self.update = true
	self.color_cube:SetColor(self:GetColor())
	self.update = false
end

function PANEL:UpdateHueBar()
	self.update = true

	local w, h = self.color_wang:GetSize()
	local hue = ColorToHSV(self:GetColor())

	self.color_wang.LastX = w / 2
	self.color_wang.LastY = h - hue / 360 * h

	self.update = false
end

function PANEL:UpdateAlphaBar()
	if not IsValid(self.alpha_wang) then return end

	self.update = true

	self.alpha_wang:SetBarColor(self:GetColor():SetAlpha(255))
	local w, h = self.color_wang:GetSize()

	self.alpha_wang:SetValue(self._a / 255)

	self.update = false
end

function PANEL:UpdateWangBars(update_type, update_subtype)
	self.update = true

	if update_type ~= '_r' or update_subtype ~= 'bar' then
		self.wang_red_bar:SetWangPosition(self._r / 255)
		self.wang_red_bar:SetLeftColor(Color(0, self._g, self._b))
		self.wang_red_bar:SetRightColor(Color(255, self._g, self._b))
	end

	if update_type ~= '_g' or update_subtype ~= 'bar' then
		self.wang_green_bar:SetWangPosition(self._g / 255)
		self.wang_green_bar:SetLeftColor(Color(self._r, 0, self._b))
		self.wang_green_bar:SetRightColor(Color(self._r, 255, self._b))
	end

	if update_type ~= '_b' or update_subtype ~= 'bar' then
		self.wang_blue_bar:SetWangPosition(self._b / 255)
		self.wang_blue_bar:SetLeftColor(Color(self._r, self._g, 0))
		self.wang_blue_bar:SetRightColor(Color(self._r, self._g, 255))
	end

	if (update_type ~= '_a' or update_subtype ~= 'bar') and self.allow_alpha then
		self.wang_alpha_bar:SetWangPosition(self._a / 255)
		self.wang_alpha_bar:SetBaseColor(self:GetColor():SetAlpha(255))
	end

	self.update = false
end

function PANEL:UpdateWangs(update_type, update_subtype)
	self.update = true

	if update_type ~= '_r' or update_subtype ~= 'wang' then
		self.wang_red:SetValue(self._r)
	end

	if update_type ~= '_g' or update_subtype ~= 'wang' then
		self.wang_green:SetValue(self._g)
	end

	if update_type ~= '_b' or update_subtype ~= 'wang' then
		self.wang_blue:SetValue(self._b)
	end

	if update_type ~= '_a' or update_subtype ~= 'wang' then
		self.wang_alpha:SetValue(self._a)
	end

	self.update = false
end

function PANEL:UpdateHSVWangs(update_type, update_subtype)
	self.update = true
	local hue, saturation, value = ColorToHSV(self:GetColor())

	if update_type ~= 'hue' or update_subtype ~= 'wang' then
		self.wang_hue:SetValue(hue)
	end

	if update_type ~= 'saturation' or update_subtype ~= 'wang' then
		self.wang_saturation:SetValue(math.round(saturation * 100))
	end

	if update_type ~= 'value' or update_subtype ~= 'wang' then
		self.wang_value:SetValue(math.round(value * 100))
	end

	self.update = false
end

function PANEL:UpdateHSVWangBars(update_type, update_subtype)
	self.update = true

	local scol = self:GetColor()
	local hue, saturation, value = ColorToHSV(scol)

	if update_type ~= 'hue' or update_subtype ~= 'bar' then
		self.wang_hue_bar:SetWangPosition(hue / 360)
	end

	if update_type ~= 'saturation' or update_subtype ~= 'bar' then
		self.wang_saturation_bar:SetWangPosition(saturation)
		-- self.wang_saturation_bar:SetLeftColor(HSVToColorLua(hue, 0, value))
		self.wang_saturation_bar:SetRightColor(HSVToColorLua(hue, 1, value))
	end

	if update_type ~= 'value' or update_subtype ~= 'bar' then
		self.wang_value_bar:SetWangPosition(value)
		-- self.wang_value_bar:SetLeftColor(HSVToColorLua(hue, saturation, 0))
		self.wang_value_bar:SetRightColor(HSVToColorLua(hue, saturation, 1))
	end

	self.update = false
end

function PANEL:UpdateFromHSVWangs(...)
	local col = HSVToColorLua(self.wang_hue:GetValue(), self.wang_saturation:GetValue() / 100, self.wang_value:GetValue() / 100)
	col:SetAlpha(self._a)
	self:_SetColor(col)
	self:UpdateData(...)
end

function PANEL:_SetColor(r, g, b, a)
	if IsColor(r) then
		r, g, b, a = r.r, r.g, r.b, r.a
	end

	self._r = r
	self._g = g
	self._b = b
	self._a = a

	self:ValueChanged(self:GetColor())
	self:UpdateConVars()
end

function PANEL:SetColor(r, g, b, a)
	if IsColor(r) then
		r, g, b, a = r.r, r.g, r.b, r.a
	end

	self._r = r
	self._g = g
	self._b = b
	self._a = a

	self:UpdateData()
end

function PANEL:ValueChanged(newvalue)

end

function PANEL:GetColor()
	return Color(self._r, self._g, self._b, self._a)
end

function PANEL:GetVector()
	return Vector(self._r / 255, self._g / 255, self._b / 255)
end

function PANEL:Think()
	self:CheckConVars()
end

function PANEL:GetAllowAlpha()
	return self.allow_alpha
end

PANEL.GetAlphaBar = PANEL.GetAllowAlpha

function PANEL:SetAllowAlpha(allow)
	assert(isbool(allow), 'allow should be a boolean')

	if self.allow_alpha == allow then return end
	self.allow_alpha = allow

	if allow then
		self:CheckConVar(self.con_var_alpha, '_a')

		if IsValid(self.alpha_wang) then
			self.alpha_wang:SetVisible(true)
		end

		self.wang_canvas_alpha:SetVisible(true)
	else
		self._a = 255

		if IsValid(self.alpha_wang) then
			self.alpha_wang:SetVisible(false)
		end

		self.wang_canvas_alpha:SetVisible(false)
	end

	self:UpdateHexInput()
	self:InvalidateLayout()
end

PANEL.SetAlphaBar = PANEL.SetAllowAlpha

AccessorFunc(PANEL, 'con_var_red', 'ConVarR')
AccessorFunc(PANEL, 'con_var_green', 'ConVarG')
AccessorFunc(PANEL, 'con_var_blue', 'ConVarB')
AccessorFunc(PANEL, 'con_var_alpha', 'ConVarA')
-- AccessorFunc(PANEL, 'con_var_combined', 'ConVarCombined')

function PANEL:SetConVarR(con_var)
	if not con_var then
		self.con_var_red = nil
		return
	end

	self.con_var_red = type(con_var) == 'ConVar' and con_var or assert(ConVar(con_var), 'no such ConVar: ' .. con_var)
	self:CheckConVar(self.con_var_red, '_r')
end

function PANEL:SetConVarG(con_var)
	if not con_var then
		self.con_var_green = nil
		return
	end

	self.con_var_green = type(con_var) == 'ConVar' and con_var or assert(ConVar(con_var), 'no such ConVar: ' .. con_var)
	self:CheckConVar(self.con_var_green, '_g')
end

function PANEL:SetConVarB(con_var)
	if not con_var then
		self.con_var_blue = nil
		return
	end

	self.con_var_blue = type(con_var) == 'ConVar' and con_var or assert(ConVar(con_var), 'no such ConVar: ' .. con_var)
	self:CheckConVar(self.con_var_blue, '_b')
end

function PANEL:SetConVarA(con_var)
	if not con_var then
		self.con_var_alpha = nil
		return
	end

	self.con_var_alpha = type(con_var) == 'ConVar' and con_var or assert(ConVar(con_var), 'no such ConVar: ' .. con_var)

	if self.allow_alpha then
		self:CheckConVar(self.con_var_alpha, '_a')
	end
end

--[[function PANEL:SetConVarCombined(con_var)
	if not con_var then
		self.con_var_combined = nil
		return
	end

	self.con_var_combined = type(con_var) == 'ConVar' and con_var or assert(ConVar(con_var), 'no such ConVar: ' .. con_var)
end]]

function PANEL:SetConVarAll(prefix)
	self.con_var_red = prefix .. '_r'
	self.con_var_green = prefix .. '_g'
	self.con_var_blue = prefix .. '_b'
	self.con_var_alpha = prefix .. '_a'

	self:CheckConVars(true)
end

PANEL.next_con_var_check = 0

function PANEL:CheckConVars(force)
	if not force and input.IsMouseDown(MOUSE_LEFT) then return end
	if not force and self.next_con_var_check > RealTime() then return end

	local change = self:CheckConVar(self.con_var_red, '_r', false) or
		self:CheckConVar(self.con_var_green, '_g', false) or
		self:CheckConVar(self.con_var_blue, '_b', false) or
		self.allow_alpha and self:CheckConVar(self.con_var_alpha, '_a', false)

	if change then
		self:UpdateData()
	end
end

function PANEL:UpdateConVars()
	self.next_con_var_check = RealTime() + 0.3

	if self.con_var_red then
		local value = self.con_var_red:GetInt(255)

		if value ~= self._r then
			RunConsoleCommand(self.con_var_red:GetName(), self._r:tostring())
		end
	end

	if self.con_var_green then
		local value = self.con_var_green:GetInt(255)

		if value ~= self._r then
			RunConsoleCommand(self.con_var_green:GetName(), self._g:tostring())
		end
	end

	if self.con_var_blue then
		local value = self.con_var_blue:GetInt(255)

		if value ~= self._r then
			RunConsoleCommand(self.con_var_blue:GetName(), self._b:tostring())
		end
	end

	if self.allow_alpha and self.con_var_alpha then
		local value = self.con_var_alpha:GetInt(255)

		if value ~= self._a then
			RunConsoleCommand(self.con_var_alpha:GetName(), self._a:tostring())
		end
	end
end

function PANEL:CheckConVar(con_var, index, update_now)
	if not con_var then return false end

	local value = con_var:GetInt(255)

	if value ~= self[index] then
		self[index] = value

		if update_now or update_now == nil then
			self:UpdateData()
		end

		return true
	end

	return false
end

vgui.Register('DLibColorMixer', PANEL, 'EditablePanel')
