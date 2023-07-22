--[[
	© 2017 Thriving Ventures Limited do not share, re-distribute or modify

	without permission of its author (gustaf@thrivingventures.com).
]]

local plugin = plugin;
plugin.ui = plugin.ui or {};

-- Progress bar.
local PANEL = {};

function PANEL:Init()
	self:SetMouseInputEnabled(false);
	self:SetTall(16);
	self:SetProgress(0);
end;

function PANEL:SetProgress(amount)
	self.progress = math.Clamp(math.ceil(amount), 0, 100);
end;

function PANEL:GetProgress()
	return self.progress;
end;

function PANEL:Think()
	self:SetProgress( ( ( CurTime() - plugin.startTime ) / plugin.currentSongDuration ) * 100 )
end;

function PANEL:Paint(width, height)
	local theme = serverguard.themes.GetCurrent();
	local progressWidth = math.Clamp(math.ceil(self.progress / 100 * self:GetWide()), 0, width - 4);

	surface.SetDrawColor(theme.tiger_base_section_label);
	surface.DrawOutlinedRect(0, 0, width, height);

	surface.SetDrawColor(theme.tiger_base_section_icon_selected);
	surface.DrawRect(2, 2, progressWidth, height - 4);

	surface.SetFont("tiger.button");

	local textWidth, textHeight = surface.GetTextSize(string.FormattedTime(plugin.currentSongDuration, "%2i:%02i"));
		surface.SetTextColor(theme.tiger_base_section_label);
		surface.SetTextPos(width - textWidth - 2, 0);
	surface.DrawText(string.FormattedTime(plugin.currentSongDuration, "%2i:%02i"));

	currentTextWidth, currentTextHeight = surface.GetTextSize(string.FormattedTime(plugin.currentSongDuration, "%2i:%02i"));
		if (progressWidth >= currentTextWidth or progressWidth + currentTextWidth > width - textWidth - 2) then
			surface.SetTextColor(theme.tiger_list_panel_label_hover);
			surface.SetTextPos(0, 0);
		else
			surface.SetTextColor(theme.tiger_base_section_icon_selected);
			surface.SetTextPos(progressWidth, 0);
		end;
	surface.DrawText(string.FormattedTime( CurTime() - plugin.startTime, "%2i:%02i"));
end;

vgui.Register("serverguard.songplayer.bar", PANEL, "Panel");

-- Slider button.
local PANEL = {};

AccessorFunc(PANEL, "m_bDragging", "Dragging", FORCE_BOOL);

function PANEL:Init()
	self:SetMouseInputEnabled(true);
	self:SetSize(16, 16);

	self.circleRadius = 4;
	self.targetCircleRadius = 4;

	self:SetDragging(false);
end;

function PANEL:OnMousePressed(keyCode)
	if (keyCode != MOUSE_LEFT) then
		return;
	end;

	self:SetDragging(true);
end;

function PANEL:Think()
	if (self:GetDragging()) then
		self.targetCircleRadius = 6;

		if (!input.IsMouseDown(MOUSE_LEFT)) then
			self:SetDragging(false);
		end;
	else
		self.targetCircleRadius = 4;
	end;
end;

function PANEL:Paint(width, height)
	local theme = serverguard.themes.GetCurrent();

	if (self.circleRadius != self.targetCircleRadius) then
		self.circleRadius = math.Approach(self.circleRadius, self.targetCircleRadius, 30 * FrameTime());
	end;

	if (self:GetDragging()) then
		DisableClipping(true);
	end;

	surface.SetDrawColor(theme.tiger_base_section_icon_selected);
	draw.NoTexture();
	draw.Circle(self.circleRadius, self:GetTall() / 2, self.circleRadius, self.circleRadius * 2);

	DisableClipping(false);
end;

vgui.Register("serverguard.songplayer.sliderbutton", PANEL, "Panel");

-- Volume slider.
local PANEL = {}

function PANEL:Init()
	self:SetMouseInputEnabled(true)
	self:SetSize(116, 16)

	self.button = self:Add("serverguard.songplayer.sliderbutton")
	self.button:SetPos(0, 0)
end;

function PANEL:Think()
	if (self.button:GetDragging()) then
		local x, y = self.button:GetPos()
		local mouseX, mouseY = self:CursorPos()

		self.button:SetPos(math.Clamp(mouseX - 6, 0, self:GetWide() - 8), y)

		if (plugin.songVolume:GetInt() != self:GetAmount()) then
			plugin.songVolume:SetInt( self:GetAmount() )
			
			if IsValid( plugin.mediaclip ) then plugin.mediaclip:setVolume( plugin.songVolume:GetInt() / 100 ) end
		end
	end
end

function PANEL:Paint(width, height)
	local theme = serverguard.themes.GetCurrent()

	surface.SetDrawColor(theme.tiger_base_section_label)
	surface.DrawRect(0, 7, self:GetWide(), 2)
end;

function PANEL:SetAmount(amount)
	local x = math.Clamp(math.ceil(math.Clamp(amount, 0, 100) / 100 * self:GetWide()), 0, self:GetWide())
	self.button:SetPos(x, 0)
end;

function PANEL:GetAmount()
	local buttonX, buttonY = self.button:GetPos()

	return math.ceil(buttonX / self:GetWide() * 100)
end;

vgui.Register("serverguard.songplayer.slider", PANEL, "Panel")

-- Main panel.
local PANEL = {};

AccessorFunc(PANEL, "m_Title", "Title", FORCE_STRING);
AccessorFunc(PANEL, "m_bLoading", "Loading", FORCE_BOOL);
AccessorFunc(PANEL, "m_bAnimating", "Animating", FORCE_BOOL);

function PANEL:Init()
	local theme = serverguard.themes:GetCurrent();

	self:SetVisible(false);
	self:SetMouseInputEnabled(true);
	self:SetSize(180, 32);
	self:SetPos(ScrW() / 2, ScrH() / 2);
	self:SetPos(ScrW() / 2 - self:GetWide() / 2, 0);
	self:DockPadding(6, 4, 6, 4);

	self.label = self:Add("DLabel");
	self.label:SetMouseInputEnabled(true);
	self.label:Dock(TOP);
	self.label:SetFont("tiger.button");
	self.label:SetTextColor(theme.tiger_button_text);
	self.label:SetSkin("serverguard");
	self.label:SetText("None");
	self.label:SizeToContents();

	self.bar = self:Add("serverguard.songplayer.bar");
	self.bar:DockMargin(0, 6, 0, 0);
	self.bar:Dock(TOP);

	self.volume = self:Add("serverguard.songplayer.slider")
	self.volume:DockMargin(0, 2, 0, 0)
	self.volume:Dock(TOP)

	self:SetTitle("None");
	self:SetLoading(true);
	self:SetAnimating(false);

	self:SetTall(self.label:GetTall() + 10);

	self.lastInteractTime = CurTime();
	self.currentAlpha = 255;

	serverguard.themes.AddPanel(self.label, "tiger_button_text");
end;

function PANEL:Think()
	local width, height = self:GetSize();
	local x, y = self:GetPos();

	if (gui.MouseX() > x and gui.MouseX() < x + width and
		gui.MouseY() > y and gui.MouseY() < y + height) then
		if (!self:GetAnimating() and self.currentAlpha < 255) then
			self.currentAlpha = math.Approach(self.currentAlpha, 255, 600 * FrameTime());
			self:SetAlpha(self.currentAlpha);
		end;

		self.lastInteractTime = CurTime();

		if (!self:GetLoading()) then
			local totalHeight = self.label:GetTall() + self.bar:GetTall() + self.volume:GetTall() + 14;

			self:SetTall(math.Approach(height, totalHeight, 400 * FrameTime()));
		end;
	else
		self:SetTall(math.Approach(height, self.label:GetTall() + 10, 200 * FrameTime()));

		if (!self:GetAnimating() and CurTime() > self.lastInteractTime + 6) then
			self.currentAlpha = math.Approach(self.currentAlpha, 100, 50 * FrameTime());
			self:SetAlpha(self.currentAlpha);
		end;
	end;
end;

function PANEL:SetTitle(text)
	local x, y = self:GetPos();

	self.label:SetText(text);
	self.label:SizeToContents();

	self:SetWide(self.label:GetWide() + 12);
	self:SetPos(ScrW() / 2 - self:GetWide() / 2, y);

	self.bar:SetWide(self:GetWide());

	self.volume:SetWide(self:GetWide() - 16);
	self.volume:SetAmount(plugin.songVolume:GetInt());

	self.m_Title = text;
end;

function PANEL:FadeIn()
	self:SetAnimating(true);
	self:SetVisible(true);
	self:SetAlpha(0);

	self:AlphaTo(255, 0.5, 0, function()
		self:SetAnimating(false);
		self.lastInteractTime = CurTime();
	end);
end;

function PANEL:FadeOut(callback)
	self:SetAnimating(true);
	self:SetVisible(true);

	self:AlphaTo(0, 0.5, 0, function()
		self:SetVisible(false);
		self:SetAnimating(false);
	end);
end;

vgui.Register("serverguard.songplayer", PANEL, "tiger.panel");
