
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


local PANEL = {}
DLib.VGUI.PlayerButton = PANEL

AccessorFunc(PANEL, 'm_DisplayGreen', 'GreenIfOnline')

--[[
	@doc
	@panel DLib_PlayerButton
	@parent DButton

	@desc
	Creates a new panel which display user's `DLib_Avatar`
	and some controls for end user.

	behaves like regular button.
	to set which player to display, use `:SetSteamID(steamid)`
	@enddesc
]]
function PANEL:Init()
	self.isAddingNew = false
	self:SetMouseInputEnabled(true)
	self:SetKeyboardInputEnabled(true)
	self:SetText('')
	self.label = vgui.Create('DLabel', self)
	self.label:SetText('usernaem:tm:\nstaimid:tm:')
	self.label:SetPos(0, 64)
	self.label:SetContentAlignment(CONTENT_ALIGMENT_MIDDLECENTER)
	self.nickname = 'unknown'
	self:SetSize(128, 96)
	self:SetSkin('DLib_Black')
	self.m_DisplayGreen = false
end

function PANEL:DoClick()

end

function PANEL:DoRightClick()
	local menu = vgui.Create('DLib_Menu')
	menu:AddCopyOption('Copy SteamID', self.steamid)
	menu:AddCopyOption('Copy Nickname', self.nickname)
	menu:AddURLOption('Open Steam profile', DLib.util.SteamLink(self.steamid))
	menu:Open()
end

local surface = surface
local derma = derma

function PANEL:Paint(w, h)
	derma.SkinHook('Paint', 'Button', self, w, h)

	if self.ply and self.m_DisplayGreen then
		surface.SetDrawColor(20, 180, 24, 100)
		surface.DrawRect(0, 0, w, h)
	end
end

function PANEL:PerformLayout(w, h)
	if not w or not h then return end
	self.label:SizeToContents()
	local W, H = self.label:GetSize()
	self.label:SetSize(w, H)

	if IsValid(self.avatar) then
		self.avatar:SetPos(w / 2 - self.avatar:GetWide() / 2)
	end
end

--[[
	@doc
	@fname DLib_PlayerButton:SetSteamID
	@args string steamid

	@desc
	regular steamid, not steamid64
	@enddesc
]]
function PANEL:SetSteamID(steamid)
	self.steamid = steamid
	self.ply = player.GetBySteamID(steamid)

	if IsValid(self.avatar) then
		self.avatar:SetSteamID(steamid, 64)
	end

	self.label:SetText(self.nickname .. '\n' .. steamid)
end

--[[
	@doc
	@fname DLib_PlayerButton:Populate

	@desc
	Actually populates the panel.
	**You must call this function after you did everything**
	This function is present due to speed of avatar panel.
	This can be useful when you got scrolling panel and created a lot
	of `DLib_PlayerButton`s
	@enddesc
]]
function PANEL:Populate()
	self.avatar = vgui.Create('DLib_Avatar', self)
	local avatar = self.avatar
	avatar:SetSize(48, 48)
	avatar:SetPos(self:GetWide() / 2 - 24, 0)
	avatar:SetSteamID(self.steamid, 64)
	self.nickname = DLib.LastNickFormatted(self.steamid)
	self.label:SetText(self.nickname .. '\n' .. self.steamid)
end

vgui.Register('DLib_PlayerButton', PANEL, 'DButton')

return PANEL
