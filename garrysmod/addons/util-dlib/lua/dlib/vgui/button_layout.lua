
-- Copyright (C) 2017-2020 DBotThePony

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

--[[
	@doc
	@panel DLib_ButtonLayout
	@parent DScrollPanel

	@desc
	A grid of panels which must expose `:Populate(parent)` method
	Can be useful with !p:DLib_PlayerButton
	@enddesc
]]
local PANEL = {}
DLib.VGUI.ButtonLayout = PANEL

local function AccessorFunc(PANEL, varName, getset)
	PANEL['Get' .. getset] = function(self)
		return self[varName]
	end

	PANEL['Set' .. getset] = function(self, newVal)
		local old = self[varName]
		self[varName] = newVal
		self['On' .. getset .. 'Changes'](self, old, newVal)
	end
end

--[[
	@docpreprocess
	const names = [
		'SpacingX',
		'SpacingY',
		'LayoutSizeX',
		'LayoutSizeY'
	]

	const reply = []

	for (const name of names) {
		let output = []

		output.push(`@fname DLib_ButtonLayout:Get${name}`)
		output.push(`@returns`)
		output.push(`number`)

		reply.push(output)

		output = []

		output.push(`@fname DLib_ButtonLayout:Set${name}`)
		output.push(`@args number value`)

		reply.push(output)

		output = []

		output.push(`@fname DLib_ButtonLayout:On${name}Changes`)
		output.push(`@args number oldvalue, number newvalue`)

		reply.push(output)
	}

	return reply
]]
AccessorFunc(PANEL, 'spacingX', 'SpacingX')
AccessorFunc(PANEL, 'spacingY', 'SpacingY')
AccessorFunc(PANEL, 'layoutSizeX', 'LayoutSizeX')
AccessorFunc(PANEL, 'layoutSizeY', 'LayoutSizeY')

function PANEL:Init()
	self.layoutSizeX = 128
	self.layoutSizeY = 96
	self.buttons = {}
	self.buttonsPositions = {}
	self.spacingX = 4
	self.spacingY = 4
	self:SetSkin('DLib_Black')
end

function PANEL:SetLayoutSize(x, y)
	self.layoutSizeX, self.layoutSizeY = x, y
	self:InvalidateLayout()
end

function PANEL:OnSpacingXChanges()
	self:InvalidateLayout()
end

function PANEL:OnSpacingYChanges()
	self:InvalidateLayout()
end

function PANEL:OnLayoutSizeXChanges()
	self:InvalidateLayout()
end

function PANEL:OnLayoutSizeYChanges()
	self:InvalidateLayout()
end

--[[
	@doc
	@fname DLib_ButtonLayout:AddButton
	@args Panel button
]]
function PANEL:AddButton(button)
	table.insert(self.buttons, button)
	button:SetParent(self:GetCanvas())
	button:SetSize(self.layoutSizeX, self.layoutSizeY)
	button.__dlibIsPopulated = false
	self:InvalidateLayout()
end

--[[
	@doc
	@fname DLib_ButtonLayout:GetVisibleArea
	@returns
	number: top y
	number: bottom y
]]
function PANEL:GetVisibleArea()
	local scroll = self:GetVBar():GetScroll()
	return scroll - self.layoutSizeY, scroll + self:GetTall()
end

--[[
	@doc
	@fname DLib_ButtonLayout:GetVisibleButtons
	@returns
	table: array of Panels
]]
function PANEL:GetVisibleButtons()
	local topx, bottomx = self:GetVisibleArea()
	local reply = {}

	for i, button in ipairs(self.buttonsPositions) do
		local x, y = button.x, button.y

		if y > topx and y < bottomx then
			table.insert(reply, button.button)
		end
	end

	return reply
end

--[[
	@doc
	@fname DLib_ButtonLayout:Clear

	@desc
	removes all buttons
	@enddesc
]]
function PANEL:Clear()
	for i, button in ipairs(self.buttons) do
		button:Remove()
	end

	self.buttons = {}
	self.__lastW, self.__lastH = nil, nil
	self:InvalidateLayout()
end

--[[
	@doc
	@fname DLib_ButtonLayout:RebuildButtonsPositions
	@args number width, number height
	@internal
]]
function PANEL:RebuildButtonsPositions(w, h)
	if not w or not h then return end
	self.buttonsPositions = {}
	local xm, ym = self.layoutSizeX + self.spacingX, self.layoutSizeY + self.spacingY

	local line = 0
	local row = 0
	local limitX = math.max(math.floor(w / xm) - 1, 1)

	for i, button in ipairs(self.buttons) do
		if row > limitX then
			row = 0
			line = line + 1
		end

		local newx, newy = row * xm, line * ym
		button:SetPos(newx, newy)

		self.buttonsPositions[i] = {
			button = button,
			x = newx,
			y = newy
		}

		row = row + 1
	end

	self:GetCanvas():SetSize(w, (line + 1) * ym)

	return self.buttonsPositions
end

function PANEL:PerformLayout(width, height)
	if width == self.__lastW and height == self.__lastH then return end
	self.__lastW, self.__lastH = width, height
	DScrollPanel.PerformLayout(self, width, height)
	self:RebuildButtonsPositions(self:GetSize())

	for i, button in ipairs(self:GetVisibleButtons()) do
		if not button.__dlibIsPopulated then
			button:Populate(self)
			button.__dlibIsPopulated = true
		end
	end
end

vgui.Register('DLib_ButtonLayout', PANEL, 'DScrollPanel')

return PANEL
