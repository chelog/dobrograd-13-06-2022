
--
-- Copyright (C) 2016-2018 DBot

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
	@panel DLib_Avatar

	@desc
	!g:AvatarImage that doesn't suck
	use this panel as described on !g:AvatarImage
	@enddesc
]]
local PANEL = {}
DLib.VGUI.Avatar = PANEL

function PANEL:AvatarHide()
	self.havatar:SetVisible(false)
	self.havatar:KillFocus()
	self.havatar:SetMouseInputEnabled(false)
	self.havatar:SetKeyboardInputEnabled(false)
	self.havatar.hover = false
	self:SetSkin('DLib_Black')
end

function PANEL:OnMousePressed(key)
	self.hover = true
	self.havatar:SetVisible(true)
	self.havatar:MakePopup()
	self.havatar:SetMouseInputEnabled(false)
	self.havatar:SetKeyboardInputEnabled(false)

	if IsValid(self.ply) and self.ply:IsBot() then return end

	if key == MOUSE_LEFT then
		if IsValid(self.ply) then
			gui.OpenURL('https://steamcommunity.com/profiles/' .. self.ply:SteamID64() .. '/')
		elseif self.steamid64 and self.steamid64 ~= '0' then
			gui.OpenURL('https://steamcommunity.com/profiles/' .. self.steamid64 .. '/')
		end
	end
end

function PANEL:Init()
	self:SetCursor('hand')

	local avatar = self:Add('AvatarImage')
	self.avatar = avatar
	avatar:Dock(FILL)

	local havatar = vgui.Create('AvatarImage')
	self.havatar = havatar
	havatar:SetVisible(false)
	havatar:SetSize(184, 184)

	hook.Add('OnSpawnMenuClose', self, self.AvatarHide)

	self:SetMouseInputEnabled(true)
	avatar:SetMouseInputEnabled(false)
	avatar:SetKeyboardInputEnabled(false)
	havatar:SetMouseInputEnabled(false)
	havatar:SetKeyboardInputEnabled(false)
end

function PANEL:Think()
	if not IsValid(self.ply) and not self.steamid then return end
	local x, y = gui.MousePos()

	local hover = self:IsHovered()

	local w, h = ScrWL(), ScrHL()

	if x + 204 >= w then
		x = x - 214
	end

	if y + 204 >= h then
		y = y - 214
	end

	if hover then
		if not self.hover then
			self.hover = true
			self.havatar:SetVisible(true)
			self.havatar:MakePopup()
			self.havatar:SetMouseInputEnabled(false)
			self.havatar:SetKeyboardInputEnabled(false)
		end

		self.havatar:SetPos(x + 20, y + 10)
	else
		if self.hover then
			self.havatar:SetVisible(false)
			self.havatar:KillFocus()
			self.hover = false
		end
	end
end

function PANEL:SetPlayer(ply, size)
	self.ply = ply

	self.avatar:SetPlayer(ply, size)
	self.havatar:SetPlayer(ply, 184)
end

function PANEL:SetSteamID(steamid, size)
	local steamid64

	if DLib.util.ValidateSteamID(steamid) then
		steamid64 = util.SteamIDTo64(steamid)
	else
		steamid64 = steamid
	end

	self.steamid = steamid
	self.steamid64 = steamid64

	self.avatar:SetSteamID(steamid64, size)
	self.havatar:SetSteamID(steamid64, 184)
end

function PANEL:OnRemove()
	if IsValid(self.havatar) then
		self.havatar:Remove()
	end
end

vgui.Register('DLib_Avatar', PANEL, 'EditablePanel')

return PANEL
