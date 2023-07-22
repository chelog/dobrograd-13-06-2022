--[[
	© 2017 Thriving Ventures Limited do not share, re-distribute or modify
	
	without permission of its author (gustaf@thrivingventures.com).
]]

local plugin = plugin;

plugin:IncludeFile("shared.lua", SERVERGUARD.STATE.CLIENT);

surface.CreateFont("serverguard.scoreboard.header", 	{font = "Roboto", size = 32, weight = 500})
surface.CreateFont("serverguard.scoreboard.gamemode", 	{font = "Roboto", size = 18, weight = 500})
surface.CreateFont("serverguard.scoreboard.player", 	{font = "Roboto", size = 18, weight = 500})
surface.CreateFont("serverguard.scoreboard.counts", 	{font = "Roboto Bt", size = 11, weight = 500})
surface.CreateFont("serverguard.scoreboard.button", 	{font = "Arial", size = 12, weight = 500})

local scoreboard = nil

local counts = {
	"Props",
	"Ragdolls",
	"Effects",
	"Sents",
	"Npcs",
	"Vehicles",
	"Balloons",
	"Buttons",
	"Dynamite",
	"Effects",
	"Emitters",
	"Hoverballs",
	"Lamps",
	"Lights",
	"Thrusters",
	"Wheels",
}

plugin:Hook("ScoreboardShow", "scoreboard.ScoreboardShow", function()
	if (!IsValid(scoreboard)) then
		scoreboard = vgui.Create("serverguard.scoreboard")
	end
	
	scoreboard:Toggle(true)
	
	return true
end)

plugin:Hook("ScoreboardHide", "scoreboard.ScoreboardHide", function()
	if (IsValid(scoreboard)) then
		scoreboard:Toggle(false)
	end
	
	return true
end)

local panel = {}

function panel:Init()
	self:SetSize(650, 600)
	self:Center()
	self:DockPadding(8, 76, 8, 10)
	
	self.list = self:Add("DScrollPanel")
	self.list:Dock(FILL)

	self:InvalidateLayout(true)
end

function panel:AddPlayer(pPlayer)
	local base = self
	
	local panel = self.list:Add("Panel")
	panel:SetTall(32)
	panel:DockMargin(3, 3, 3, 1)
	panel:Dock(TOP)
	
	panel.player = pPlayer
	
	panel.buttonBase = panel:Add("Panel")
	panel.buttonBase:SetTall(16)
	
	function panel.buttonBase:Paint(w, h)
		--local theme = serverguard:GetTheme(serverguard.theme:GetString())
		
		--draw.RoundedBox(4, 0, 0, w, h, theme.color_menu_top)
		--draw.RoundedBox(4, 1, 1, w -2, h -2, theme.color_menu_background)
		--draw.SimpleRect(w /2 +1, 0, 1, h, theme.color_menu_top)
		
		local theme = serverguard.themes.GetCurrent()
	
		draw.RoundedBox(4, 0, 0, w, h, theme.tiger_base_outline)
		draw.RoundedBox(2, 1, 1, w -2, h -2, theme.tiger_base_footer_bg)
	end
	
	function panel.Think(_self)
		if (!IsValid(_self.player)) then
			self:Rebuild()
		else
			if (serverguard.player:HasPermission(LocalPlayer(), "Kick")) then
				if (!IsValid(panel.buttonBase.kick)) then
					panel.buttonBase.kick = panel.buttonBase:Add("DLabel")
					panel.buttonBase.kick:Dock(LEFT)
					panel.buttonBase.kick:SetFont("serverguard.scoreboard.button")
					panel.buttonBase.kick:SetText("KICK")
					panel.buttonBase.kick:SizeToContents()
					panel.buttonBase.kick:DockMargin(4, 5, 4, 4)
					
					util.InstallHandHover(panel.buttonBase.kick)
					
					function panel.buttonBase.kick:OnMousePressed()
						local command = serverguard.command:FindByID("kick")
						local rankData = serverguard.ranks:GetRank(serverguard.player:GetRank(LocalPlayer()))
						
						local menu = DermaMenu()
							menu:SetSkin("serverguard");
							command:ContextMenu(panel.player, menu, rankData)
						menu:Open()
					end
					
					serverguard.themes.AddPanel(panel.buttonBase.kick, "tiger_base_section_label")
				end
				
				if (!panel.buttonBase:IsVisible()) then
					panel.buttonBase:SetVisible(true)
				end
			else
				if (panel.buttonBase:IsVisible()) then
					panel.buttonBase:SetVisible(false)
				end
			end
			
			if (serverguard.player:HasPermission(LocalPlayer(), "Ban")) then
				if (!IsValid(panel.buttonBase.ban)) then
					panel.buttonBase.ban = panel.buttonBase:Add("DLabel")
					panel.buttonBase.ban:Dock(LEFT)
					panel.buttonBase.ban:SetFont("serverguard.scoreboard.button")
					panel.buttonBase.ban:SetText("BAN")
					panel.buttonBase.ban:SizeToContents()
					panel.buttonBase.ban:DockMargin(4, 5, 4, 4)
					
					util.InstallHandHover(panel.buttonBase.ban)
					
					function panel.buttonBase.ban:OnMousePressed()
						local command = serverguard.command:FindByID("ban")
						local rankData = serverguard.ranks:GetRank(serverguard.player:GetRank(LocalPlayer()))
						
						local menu = DermaMenu()
							menu:SetSkin("serverguard");
							command:ContextMenu(panel.player, menu, rankData)
						menu:Open()
					end
					
					serverguard.themes.AddPanel(panel.buttonBase.ban, "tiger_base_section_label")
				end
			else
				if (IsValid(panel.buttonBase.ban)) then
					panel.buttonBase.ban:Remove()
					panel.buttonBase:InvalidateLayout()
				end
			end
		end
	end
	
	function panel:PerformLayout()
		local w, h = self:GetSize()

		panel.buttonBase:SizeToChildren(true, false)
		panel.buttonBase:SetWide(panel.buttonBase:GetWide() +4)
		panel.buttonBase:SetPos(w -(75 +panel.buttonBase:GetWide()), 8)
	end
	
	function panel:Paint(w, h)
		if (IsValid(self.player)) then
			local theme = serverguard.themes.GetCurrent()
	
			draw.RoundedBox(4, 0, 0, w, 32, theme.tiger_base_outline)
			draw.RoundedBox(2, 1, 1, w -2, 32 -2, theme.tiger_list_panel_list_bg_dark)
			
			--draw.SimpleRect(1, 1, w -2, 31, theme.tiger_list_panel_list_bg_dark)
			
			if (IsValid(pPlayer)) then
				draw.SimpleText(serverguard.player:GetName(pPlayer), "serverguard.scoreboard.player", 62, 16, theme.tiger_base_section_label, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				draw.SimpleText(pPlayer:Ping(), "serverguard.scoreboard.player", w -18, 16, theme.tiger_base_section_label, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
			end
		end
	end
	
	function panel:OnMousePressed()
		if (IsValid(self.infoPanel) and self.infoPanel:IsVisible()) then
			self:SizeTo(self:GetWide(), 32, 0.2, 0, 0.2, function() self.infoPanel:SetVisible(false) end)
		else
			self:SizeTo(self:GetWide(), 32 +18, 0.2, 0, 0.2)
			
			surface.PlaySound("garrysmod/ui_click.wav")
			
			if (!IsValid(self.infoPanel)) then
				self.infoPanel = self:Add("Panel")
				self.infoPanel:SetPos(32, 31)
				self.infoPanel:SetSize(self:GetWide() -32, 19)
				
				function self.infoPanel:Paint(w, h)
					local theme = serverguard.themes.GetCurrent()
					
					draw.RoundedBoxEx(8, 0, 0, w, h, theme.tiger_base_outline, false, false, true, true)
					draw.RoundedBoxEx(8, 1, 1, w -2, h -2, theme.tiger_list_panel_list_bg_dark, false, false, true, true)
					--draw.SimpleRect(0, 0, w, 1, theme.tiger_base_outline)
				end
				
				for k, text in pairs(counts) do
					local label = self.infoPanel:Add("DLabel")
					label:SetFont("serverguard.scoreboard.counts")
					label:Dock(LEFT)
					label:DockMargin(10, 1, 0, 0)

					label.value = panel.player:GetCount(string.lower(text))
					label:SetText(text .. ": " .. label.value)
					label:SizeToContents()
					
					serverguard.themes.AddPanel(label, "tiger_base_section_label")
					
					function label:Think()
						local value = panel.player:GetCount(string.lower(text))
						
						if (value != self.value) then
							self:SetText(text .. ": " .. value)
							self:SizeToContents()
							
							self.value = value
						end
					end
				end
			else
				self.infoPanel:SetVisible(true)
			end
		end
	end
	
	function panel:OnCursorEntered()
		self:SetCursor("hand")
		
		surface.PlaySound("garrysmod/ui_hover.wav")
	end
	
	function panel:OnCursorExited()
		self:SetCursor("arrow")
	end
	
	panel.avatar = panel:Add("AvatarImage")
	panel.avatar:SetSize(32, 32)
	panel.avatar:SetPlayer(pPlayer, 32)
	panel.avatar:SetCursor("hand")

	function panel.avatar:OnMouseReleased(keyCode)
		if (IsValid(pPlayer) and keyCode == MOUSE_LEFT) then
			pPlayer:ShowProfile()
		end
	end
	
	panel.rankImage = panel:Add("DImage")
	panel.rankImage:SetSize(16, 16)
	panel.rankImage:SetPos(38, 8)
	panel.rankImage:SetMouseInputEnabled(true)
	
	function panel.rankImage:Think()
		if (IsValid(panel.player)) then
			local rank = serverguard.ranks:GetRank(serverguard.player:GetRank(panel.player))
			
			if (type(rank) == "table" and self:GetImage() != rank.texture) then
				self:SetImage((rank.texture != "" and rank.texture or "icon16/user.png"))
				self:SetToolTip(rank.name)
				
				panel:SetZPos(rank.immunity *-1)
				
				base.list:InvalidateLayout()
			end
		end
	end
	
	self.list:InvalidateLayout(true)
	
	pPlayer.sg_scoreboard = true
end

function panel:Rebuild()
	self.list:Clear()
	
	for k, pPlayer in ipairs(player.GetAll()) do
		pPlayer.sg_scoreboard = nil
	end
end

function panel:Think()
	for k, pPlayer in ipairs(player.GetAll()) do
		if (IsValid(pPlayer) and !pPlayer.sg_scoreboard) then
			self:AddPlayer(pPlayer)
		end
	end
end

function panel:Toggle(show)
	gui.EnableScreenClicker(show)
	
	if (show) then
		self:SetVisible(true)
		self:SetAlpha(0)
		self:AlphaTo(255, 0.15, 0)
	
		RestoreCursorPosition()
		
		self.show = true
	else
		self.show = nil
		
		RememberCursorPosition()
		
		self:AlphaTo(0, 0.15, 0, function() if (!self.show) then self:SetVisible(false) self.show = nil end end)
	end
end

function panel:Paint(w, h)
	local theme = serverguard.themes.GetCurrent()
	
	draw.RoundedBox(4, 0, 0, w, h, theme.tiger_base_outline)
	draw.RoundedBox(2, 1, 1, w -2, h -2, theme.tiger_base_bg)
	
	draw.SimpleText(GetHostName(), "serverguard.scoreboard.header", w /2, 26, theme.tiger_base_section_label, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	draw.SimpleText(GAMEMODE.Name, "serverguard.scoreboard.gamemode", w /2, 56, theme.tiger_base_section_label, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	
	DisableClipping(true)
		for i = 1, 2 do
			local color = Color(0, 0, 0, (255 /i) *0.2)
		
			surface.SetDrawColor(color)
		
			-- Right shadow.
			surface.DrawRect(w -1 +i, 1, 1, h -1)
		
			-- Top shadow.
			surface.DrawRect(1, -i, w -1, 1)
		
			-- Left shadow.
			surface.DrawRect(-i, 0, 1, h)
		
			-- Bottom shadow.
			surface.DrawRect(1, h, w -1, i)
		end
	DisableClipping(false)
	
	-- List background.
	local x, y = self.list:GetPos()
	local w, h = self.list:GetSize()
	
	draw.SimpleRect(x, y, w, h +3, theme.tiger_base_footer_bg)
end

vgui.Register("serverguard.scoreboard", panel, "Panel")