
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
local hook = hook
local IsValid = IsValid
local DLib = DLib
local RealTimeL = RealTimeL
local color_white = color_white
local Color = Color
local color_dlib = color_dlib
local tonumber = tonumber
local surface = surface
local draw = draw

--[[
	@doc
	@panel DLib_TextEntry
	@parent DTextEntry

	@desc
	DTextEntry with `:OnEnter(value)` callback (which means it will be called after user press Enter)
	also contains autocomplete qol fixes
	@enddesc
]]
local PANEL = {}
DLib.VGUI.TextEntry = PANEL

surface.CreateFont('DLib_TextEntry', {
	font = 'Roboto',
	size = 16,
	weight = 500,
	extended = true
})

function PANEL:Init()
	self:SetText('')
	self:SetKeyboardInputEnabled(true)
	self:SetMouseInputEnabled(true)
	self:SetFont('DLib_TextEntry')
end

function PANEL:OnEnter(value)

end

function PANEL:OnGetFocus(...)
	if DTextEntry.OnGetFocus then
		DTextEntry.OnGetFocus(self, ...)
	end

	local autocomplete = self:GetAutoComplete(self:GetText())

	if autocomplete then
		self:OpenAutoComplete(autocomplete)
	end
end

function PANEL:OnMousePressed(mcode)
	if DTextEntry.OnMousePressed then
		DTextEntry.OnMousePressed(self, mcode)
	end

	if mcode == MOUSE_LEFT then
		local autocomplete = self:GetAutoComplete(self:GetText())

		if autocomplete then
			self:OpenAutoComplete(autocomplete)
		end
	end
end

function PANEL:Think()
	if not IsValid(self.Menu) then
		self:ConVarStringThink()
	end
end

function PANEL:OpenAutoComplete(tab)
	if not tab or #tab == 0 then return end

	if IsValid(self.Menu) then
		self.Menu:Remove()
	end

	self.Menu = DermaMenu()

	for k, line in ipairs(tab) do
		self.Menu:AddOption(line, function()
			self:SetText(line)
			self:SetCaretPos(#line)
			self:UpdateConvarValue()
			self:RequestFocus()
			self:OnValueChange(line)
		end)
	end

	local x, y = self:LocalToScreen(0, self:GetTall())
	self.Menu:SetMinimumWidth(self:GetWide())
	self.Menu:Open(x, y, true, self)
	self.Menu:SetPos(x, y)
	self.Menu:SetMaxHeight(ScrHL() - y - 10)
end

function PANEL:OnKeyCodeTyped(key)
	if key == KEY_FIRST or key == KEY_NONE or key == KEY_TAB then
		return true
	elseif key == KEY_ENTER then
		self:OnEnter((self:GetValue() or ''):Trim())
		self:KillFocus()

		if IsValid(self.Menu) then
			self.Menu:Remove()
		end

		return true
	end

	if DTextEntry.OnKeyCodeTyped then
		return DTextEntry.OnKeyCodeTyped(self, key)
	end

	return false
end

function PANEL:GetValueBeforeCaret()
	local value = self:GetValue() or ''
	return value:sub(1, self:GetCaretPos())
end

function PANEL:GetValueAfterCaret()
	local value = self:GetValue() or ''
	return value:sub(self:GetCaretPos() + 1)
end

vgui.Register('DLib_TextEntry', PANEL, 'DTextEntry')
local TEXTENTRY = PANEL

--[[
	@doc
	@panel DLib_TextEntry_Configurable
	@parent DTextEntry

	@desc
	base panel for creating configuration based text entries
	@enddesc
]]
PANEL = {}
DLib.VGUI.TextEntry_Configurable = PANEL

--[[
	@doc
	@fname DLib_TextEntry_Configurable:GetLengthLimit

	@returns
	number
]]

--[[
	@doc
	@fname DLib_TextEntry_Configurable:SetLengthLimit
	@args number value
]]

--[[
	@doc
	@fname DLib_TextEntry_Configurable:GetTooltipTime

	@returns
	number
]]

--[[
	@doc
	@fname DLib_TextEntry_Configurable:SetTooltipTime
	@args number value
]]

--[[
	@doc
	@fname DLib_TextEntry_Configurable:GetTooltipShown

	@returns
	boolean
]]

--[[
	@doc
	@fname DLib_TextEntry_Configurable:SetTooltipShown
	@internal
	@args boolean value
]]

--[[
	@doc
	@fname DLib_TextEntry_Configurable:GetIsWhitelistMode

	@returns
	boolean
]]

--[[
	@doc
	@fname DLib_TextEntry_Configurable:SetIsWhitelistMode
	@args boolean value
]]

--[[
	@doc
	@fname DLib_TextEntry_Configurable:GetDisallowedHashSet

	@returns
	DLib.HashSet: or nil
]]

--[[
	@doc
	@fname DLib_TextEntry_Configurable:SetDisallowedHashSet
	@internal
	@args table hashset
]]

--[[
	@doc
	@fname DLib_TextEntry_Configurable:GetAllowedHashSet

	@returns
	DLib.HashSet: or nil
]]

--[[
	@doc
	@fname DLib_TextEntry_Configurable:SetAllowedHashSet
	@internal
	@args table hashset
]]

--[[
	@doc
	@fname DLib_TextEntry_Configurable:GetDefaultReason

	@returns
	string
]]

--[[
	@doc
	@fname DLib_TextEntry_Configurable:SetDefaultReason
	@internal
	@args string value
]]
AccessorFunc(PANEL, 'lengthLimit', 'LengthLimit')
AccessorFunc(PANEL, 'tooltipTime', 'TooltipTime')
AccessorFunc(PANEL, 'tooltip', 'TooltipShown')
AccessorFunc(PANEL, 'whitelistMode', 'IsWhitelistMode')
AccessorFunc(PANEL, 'disallowed', 'DisallowedHashSet')
AccessorFunc(PANEL, 'allowed', 'AllowedHashSet')
AccessorFunc(PANEL, 'defaultReason', 'DefaultReason')

function PANEL:Init()
	self.allowed = DLib.HashSet()
	self.disallowed = DLib.HashSet()
	self.whitelistMode = false
	self.tooltipTime = 0
	self.tooltip = false
	self.lengthLimit = 0
	self.tooltipReason = 'gui.entry.invalidsymbol'
	self.defaultReason = 'gui.entry.invalidsymbol'

	hook.Add('PostRenderVGUI', self, self.PostRenderVGUI)
end

--[[
	@doc
	@fname DLib_TextEntry_Configurable:PredictValueChange
	@args string keycode

	@internal
	@returns
	string
]]
function PANEL:PredictValueChange(key)
	local value1 = self:GetValueBeforeCaret()
	local value2 = self:GetValueAfterCaret()
	local char = DLib.KeyMap.KEY[key]

	if char then
		return value1 .. char .. value2
	elseif key == KEY_BACKSPACE then
		return value1:sub(1, #value1 - 1) .. value2
	elseif key == KEY_DELETE then
		return value1 .. value2:sub(1, #value2 - 1)
	end

	return self:GetValue()
end

local function isTechincal(key)
	return key == KEY_BACKSPACE or
		key == KEY_DELETE or
		key == KEY_UP or
		key == KEY_DOWN or
		key == KEY_LEFT or
		key == KEY_RIGHT
end

local function isControl(key)
	return key == KEY_UP or
		key == KEY_DOWN or
		key == KEY_LEFT or
		key == KEY_RIGHT
end

function PANEL:OnKeyCodeTyped(key)
	local reply = TEXTENTRY.OnKeyCodeTyped(self, key)
	if reply == true then return reply end

	if not isTechincal then
		if self.whitelistMode then
			if not self.allowed:has(key) then
				self:Ding()
				--return true
			end
		else
			if self.disallowed:has(key) then
				self:Ding()
				--return true
			end
		end
	end

	if self.lengthLimit > 0 and #(self:GetValue() or '') + 1 > self.lengthLimit then
		self:Ding('gui.entry.limit')
		--return true
	end

	return false
end

--[[
	@doc
	@fname DLib_TextEntry_Configurable:AddToBlacklist
	@args string keycode
]]
function PANEL:AddToBlacklist(value)
	return self.disallowed:add(value)
end

--[[
	@doc
	@fname DLib_TextEntry_Configurable:AddToWhitelist
	@args string keycode
]]
function PANEL:AddToWhitelist(value)
	return self.allowed:add(value)
end

--[[
	@doc
	@fname DLib_TextEntry_Configurable:RemoveFromBlacklist
	@args string keycode
]]
function PANEL:RemoveFromBlacklist(value)
	return self.disallowed:remove(value)
end

--[[
	@doc
	@fname DLib_TextEntry_Configurable:RemoveFromWhitelist
	@args string keycode
]]
function PANEL:RemoveFromWhitelist(value)
	return self.allowed:remove(value)
end

--[[
	@doc
	@fname DLib_TextEntry_Configurable:InBlacklist
	@args string keycode
]]
function PANEL:InBlacklist(value)
	return self.disallowed:has(value)
end

--[[
	@doc
	@fname DLib_TextEntry_Configurable:InWhitelist
	@args string keycode
]]
function PANEL:InWhitelist(value)
	return self.allowed:add(value)
end

--[[
	@doc
	@fname DLib_TextEntry_Configurable:Ding
	@args string reason
]]
function PANEL:Ding(reason)
	reason = reason or self.defaultReason
	self.tooltipReason = DLib.i18n.localize(reason)

	if self.tooltipTime - 1.95 > RealTimeL() then
		self.tooltipTime = RealTimeL() + 1
		self.tooltip = true
		return
	end

	self.tooltipTime = RealTimeL() + 2
	--surface.PlaySound('resource/warning.wav')
	self.tooltip = true
end

surface.CreateFont('DLib_TextEntry_Warning', {
	font = 'Open Sans',
	size = 20,
	weight = 500
})

--[[
	@doc
	@fname DLib_TextEntry_Configurable:PostRenderVGUI
	@internal
]]
function PANEL:PostRenderVGUI()
	if not IsValid(self) then return end
	if not self.tooltip then return end
	local time = RealTimeL()

	if self.tooltipTime < time then
		self.tooltip = false
		return
	end

	local x, y = self:LocalToScreen(0, 0)
	local w, h = self:GetSize()

	y = y + h + 2
	local fade = math.min(1, (self.tooltipTime - time) * 1.25 + 0.4)

	local value = self:GetValueBeforeCaret()
	surface.SetFont(self:GetFont())
	local w = surface.GetTextSize(value)

	surface.SetDrawColor(0, 0, 0, fade * 255)
	draw.NoTexture()
	DLib.HUDCommons.DrawTriangle(x + 3 + w, y, 15, 20)
	DLib.HUDCommons.WordBox(self.tooltipReason, 'DLib_TextEntry_Warning', x + w, y + 20, Color(255, 255, 255, fade * 255))
end

vgui.Register('DLib_TextEntry_Configurable', PANEL, 'DLib_TextEntry')

--[[
	@doc
	@panel DLib_TextEntry_Number
	@parent DLib_TextEntry_Configurable

	@desc
	!p:DLib_TextEntry_Configurable which accept only numbers
	@enddesc
]]
local TEXTENTRY_CUSTOM = PANEL
PANEL = {}
DLib.VGUI.TextEntry_Number = PANEL

--[[
	@doc
	@fname DLib_TextEntry_Number:GetDefaultNumber

	@returns
	number
]]

--[[
	@doc
	@fname DLib_TextEntry_Number:SetDefaultNumber
	@args number value
]]

--[[
	@doc
	@fname DLib_TextEntry_Number:GetIsFloatAllowed

	@returns
	boolean
]]

--[[
	@doc
	@fname DLib_TextEntry_Number:SetIsFloatAllowed
	@args boolean value
]]

--[[
	@doc
	@fname DLib_TextEntry_Number:GetIsNegativeValueAllowed

	@returns
	boolean
]]

--[[
	@doc
	@fname DLib_TextEntry_Number:SetIsNegativeValueAllowed
	@args boolean value
]]
AccessorFunc(PANEL, 'defaultNumber', 'DefaultNumber')
AccessorFunc(PANEL, 'allowFloats', 'IsFloatAllowed')
AccessorFunc(PANEL, 'allowNegative', 'IsNegativeValueAllowed')

function PANEL:Init()
	self:SetIsWhitelistMode(true)
	self:SetDefaultReason('Only numbers are allowed.')
	self.defaultNumber = 0
	self.allowFloats = true
	self.allowNegative = true

	for i, number in ipairs(DLib.KeyMap.NUMBERS_LIST) do
		self:AddToWhitelist(number)
	end
end

--[[
	@doc
	@fname DLib_TextEntry_Number:GetNumber

	@returns
	number
]]
function PANEL:GetNumber()
	return tonumber(self:GetValue() or '') or self.defaultNumber
end

function PANEL:OnKeyCodeTyped(key)
	local reply = TEXTENTRY_CUSTOM.OnKeyCodeTyped(self, key)
	if reply then return true end

	if not self.allowNegative and (key == KEY_MINUS or key == KEY_PAD_MINUS) then
		self:Ding('Negative values are not allowed here')
		--return true
	end

	if not self.allowFloats and (key == KEY_PAD_DECIMAL) then
		self:Ding('Floating point values are not allowed here')
		--return true
	end

	if not isControl(key) then
		local newValue = self:PredictValueChange(key)

		if not tonumber(newValue) then
			self:Ding('Doing this here will mangle the current value')
			--return true
		end
	end

	return false
end

vgui.Register('DLib_TextEntry_Number', PANEL, 'DLib_TextEntry_Configurable')
