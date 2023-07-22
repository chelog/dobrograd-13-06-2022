--[[
	© 2017 Thriving Ventures Limited do not share, re-distribute or modify
	
	without permission of its author (gustaf@thrivingventures.com).

   _______ _				   _	_ _____ 
 |__   __(_)				 | |  | |_   _|
	| |   _  __ _  ___ _ __  | |  | | | |  
	| |  | |/ _` |/ _ \ '__| | |  | | | |  
	| |  | | (_| |  __/ |	| |__| |_| |_ 
	|_|  |_|\__, |\___|_|	 \____/|_____|
			 __/ |						 
			|___/						  
]]

local panel = {}

surface.CreateFont("tiger.divider.leftLabel", {font = "Istok", size = 18, weight = 400})
surface.CreateFont("tiger.divider.rightLabel", {font = "Roboto", size = 18, weight = 800})

serverguard.themes.CreateDefault("tiger_divider_bg", Color(255, 255, 255), "tiger.divider")
serverguard.themes.CreateDefault("tiger_divider_outline", Color(190, 190, 190), "tiger.divider")
--serverguard.themes.CreateDefault("tiger_divider_label", Color(141, 127, 123), "tiger.divider")

-- The divider.
serverguard.themes.CreateDefault("tiger_divider_panel_outline", Color(190, 190, 190), "tiger.divider")
serverguard.themes.CreateDefault("tiger_divider_panel_hover", Color(31, 153, 228), "tiger.divider")

serverguard.themes.CreateDefault("tiger_divider_left_bg", Color(245, 245, 245), "tiger.divider")
serverguard.themes.CreateDefault("tiger_divider_left_label", Color(141, 142, 134), "tiger.divider")
serverguard.themes.CreateDefault("tiger_divider_left_label_hovered", Color(231, 232, 224), "tiger.divider")

serverguard.themes.CreateDefault("tiger_divider_right_label", Color(31, 153, 228), "tiger.divider")
serverguard.themes.CreateDefault("tiger_divider_right_label_hovered", Color(241, 242, 234), "tiger.divider")

function panel:Init()
	self.list = self:Add("tiger.list")
	self.list:Dock(FILL)
	self.list:DockPadding(1, 1, 1, 1)
	self.list:DisablePaint()
end

function panel:AddRow(leftText, rightText)
	local base = vgui.Create("Panel")
	base:SetTall(32)
	base:Dock(TOP)
	
	local columnWidth = self:GetWide() - (self:GetWide() * 0.4)
	local textFragments = string.Explode(" ", rightText)
	local cutText = ""

	for k, v in pairs(textFragments) do
		local fragment = cutText .. " " .. v
		local fragmentWidth = util.GetTextSize("tiger.divider.rightLabel", fragment .. " >")

		if (fragmentWidth < columnWidth) then
			cutText = fragment
		else
			cutText = string.sub(fragment, 1, string.len(fragment) - 5) .. "... >"
			break
		end
	end
	
	if (string.sub(cutText, string.len(cutText), string.len(cutText)) != ">") then
		cutText = cutText .. " >"
	end

	function base:Paint(w, h)
		local theme = serverguard.themes.GetCurrent()
		local width = util.GetTextSize("tiger.divider.leftLabel", leftText)

		draw.RoundedBox(2, 0, 0, w *0.35, h, theme.tiger_divider_left_bg)

		if (self.hovered) then
			draw.SimpleRect(0, 0, w, h, theme.tiger_divider_panel_hover)
			draw.SimpleText(leftText, "tiger.divider.leftLabel", (w *0.35 -width) /2, h /2, theme.tiger_divider_left_label_hovered, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			draw.SimpleText(cutText, "tiger.divider.rightLabel", w *0.365, h /2, theme.tiger_divider_right_label_hovered, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		else
			draw.SimpleText(leftText, "tiger.divider.leftLabel", (w *0.35 -width) /2, h /2, theme.tiger_divider_left_label, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			draw.SimpleText(cutText, "tiger.divider.rightLabel", w *0.365, h /2, theme.tiger_divider_right_label, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		end
		
		draw.SimpleRect(w *0.35, 0, 1, h, theme.tiger_divider_panel_outline)
		draw.SimpleRect(0, h -1, w, 1, theme.tiger_divider_panel_outline)
	end
	
	function base:OnCursorEntered()
		self:SetCursor("hand")

		self.hovered = true
	end
	
	function base:OnCursorExited()
		self:SetCursor("arrow")

		self.hovered = nil
	end
	
	function base:OnMousePressed()
		if (self.DoClick) then
			self:DoClick()
		end
	end

	self.list:AddPanel(base)
	return base
end

function panel:Clear()
	self.list:Clear()
end

function panel:Paint(w, h)
	local theme = serverguard.themes.GetCurrent()
	
	draw.RoundedBox(4, 0, 0, w, h, theme.tiger_divider_outline)
	draw.RoundedBox(2, 1, 1, w -2, h -2, theme.tiger_divider_bg)
end

vgui.Register("tiger.divider", panel, "Panel")