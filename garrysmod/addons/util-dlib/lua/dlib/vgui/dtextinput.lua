
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


local vgui = vgui
local IsValid = IsValid

local numberEntry = {
	'GetNumber'
}

do
	local getset = {
		'DefaultNumber',
		'IsFloatAllowed',
		'IsNegativeValueAllowed',
		'LengthLimit',
		'TooltipTime',
		'TooltipShown',
		'IsWhitelistMode',
		'DisallowedHashSet',
		'AllowedHashSet',
		'DefaultReason',
	}

	for i, get in ipairs(getset) do
		table.insert(numberEntry, 'Get' .. get)
		table.insert(numberEntry, 'Set' .. get)
	end
end

--[[
	@doc
	@panel DLib_NumberInput

	@desc
	!p:DLib_TextEntry_Number wrapped in with apply button and `:OnEnter(value)` callback
	this expose almost all methods of DLib_NumberInput
	however, it does not inherit it!
	@enddesc
]]

--[[
	@doc
	@panel DLib_NumberInputLabeled

	@desc
	!p:DLib_NumberInput with label which can be accessed using `.label` property
	and text can be set using `:SetLabel(string)`
	@enddesc
]]

--[[
	@doc
	@panel DLib_NumberInputLabeledBare

	@desc
	!p:DLib_NumberInput with label which can be accessed using `.label` property
	@enddesc
]]

--[[
	@doc
	@panel DLib_TextInput

	@desc
	!p:DLib_TextEntry wrapped in with apply button and `:OnEnter(value)` callback
	@enddesc
]]

--[[
	@doc
	@panel DLib_TextInputLabeled

	@desc
	!p:DLib_TextInput with label which can be accessed using `.label` property
	and text can be set using `:SetLabel(string)`
	@enddesc
]]

--[[
	@doc
	@panel DLib_TextInputLabeledBare

	@desc
	!p:DLib_TextInput with label which can be accessed using `.label` property
	@enddesc
]]
local panels = {
	{'DLib_TextEntry_Number', 'Number', numberEntry},
	{'DLib_TextEntry', 'Text'},
}

for i, pnlData in ipairs(panels) do
	local NAME = pnlData[2] .. 'Input'
	local PANEL_ID = pnlData[1]

	local PANEL = {}
	DLib.VGUI[NAME] = PANEL

	local function Init(self)
		self:SetSize(140, 20)

		self.textInput = vgui.Create(PANEL_ID, self)
		self.apply = vgui.Create('DButton', self)
		self.apply:SetText('Apply')
		self.apply:Dock(RIGHT)
		self.apply:DockMargin(4, 0, 4, 0)
		self.textInput:Dock(FILL)
		self.apply:SizeToContents()
		self.apply:SetWide(self.apply:GetWide() + 6)

		function self.apply.DoClick()
			return self:OnEnter(self:GetValue())
		end

		function self.textInput.OnEnter(_, ...)
			return self:OnEnter(...)
		end
	end

	PANEL.Init = Init

	function PANEL:RemoveApply()
		if IsValid(self.apply) then
			self.apply:Remove()
		end
	end

	function PANEL:GetValue(...)
		return self.textInput:GetText(...)
	end

	function PANEL:GetText(...)
		return self.textInput:GetText(...)
	end

	function PANEL:SetValue(...)
		return self.textInput:SetText(...)
	end

	function PANEL:SetText(...)
		return self.textInput:SetText(...)
	end

	function PANEL:SetTitle(...)
		return self.apply:SetText(...)
	end

	function PANEL:GetTitle(...)
		return self.apply:GetText(...)
	end

	function PANEL:GetInput()
		return self.textInput
	end

	function PANEL:GetButton()
		return self.apply
	end

	function PANEL:OnEnter(value)

	end

	if pnlData[3] then
		for i2, func in ipairs(pnlData[3]) do
			PANEL[func] = function(self, ...)
				return self.textInput[func](self.textInput, ...)
			end
		end
	end

	vgui.Register('DLib_' .. NAME, PANEL, 'EditablePanel')

	PANEL = table.Copy(PANEL)

	function PANEL:Init()
		self.label = vgui.Create('DLabel', self)
		self.label:Dock(TOP)
		self.label:SetText('Field Input')

		Init(self)

		self:SetSize(140, 40)
	end

	function PANEL:SetTitle(...)
		return self.label:SetText(...)
	end

	function PANEL:SetLabel(...)
		return self.label:SetText(...)
	end

	vgui.Register('DLib_' .. NAME .. 'Labeled', PANEL, 'EditablePanel')

	PANEL = table.Copy(PANEL)

	function PANEL:Init()
		self.label = vgui.Create('DLabel', self)
		self.label:Dock(TOP)
		self.label:SetText('Field Input')

		Init(self)

		self:SetSize(140, 40)
		self.apply:Remove()
	end

	vgui.Register('DLib_' .. NAME .. 'LabeledBare', PANEL, 'EditablePanel')
end
