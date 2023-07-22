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

local panel = {};

serverguard.themes.CreateDefault("tiger_list_scrollbar", Color(120, 120, 120, 200), "tiger.list");

AccessorFunc(panel, "m_bDrawBorder", "DrawBorder", FORCE_BOOL);
AccessorFunc(panel, "m_bUseSizeLimit", "UseSizeLimit", FORCE_BOOL);

function panel:Init()
	self:SetDrawBorder(false);
	self:SetUseSizeLimit(true);

	self.VBar:SetWide(6)
	self.VBar.btnUp:Remove()
	self.VBar.btnDown:Remove()

	self.VBar.targetScroll = 0;
	self.VBar.scrollSpeed = 4;

	self.VBar.SetUp = function(bar, barSize, canvasSize)
		bar.BarSize = barSize;
		bar.CanvasSize = math.max(canvasSize - barSize, 1);

		if (self:GetUseSizeLimit()) then
			bar:SetEnabled(canvasSize > barSize);
		else
			bar:SetEnabled(true);
		end;

		bar:InvalidateLayout()
	end;

	function self.VBar:Paint(w, h)
	end;
	
	function self.VBar.btnGrip:Paint(w, h)
		local parent = self:GetParent():GetParent();
		local x, y = parent:ScreenToLocal(gui.MousePos());
		local x2, y2 = parent:GetPos();
		local w2, h2 = parent:GetSize();
		
		if (x >= 0 and x <= w2 and y >= 0 and y <= h2) then
			local theme = serverguard.themes.GetCurrent();
			
			draw.SimpleRect(0, 0, w, h, theme.tiger_list_scrollbar);
		end;
	end;
	
	function self.VBar:OnMouseWheeled(delta)
		self.scrollSpeed = self.scrollSpeed + 50 * FrameTime();
		self:AddScroll(delta * -self.scrollSpeed);
	end;

	function self.VBar:OnCursorMoved(x, y)
		if (!self.Enabled) then
			return;
		end;

		if (!self.Dragging) then
			return;
		end;
	
		local x = 0;
		local y = gui.MouseY();
		local x, y = self:ScreenToLocal(x, y);
		
		y = y - self.HoldPos;
		
		local TrackSize = self:GetTall() -self:GetWide() * 2 - self.btnGrip:GetTall();
		
		y = y / TrackSize;
		
		self.targetScroll = y * self.CanvasSize;
	end;

	function self.VBar:PerformLayout()
		local Scroll = self:GetScroll() / self.CanvasSize;
		local BarSize = math.max(self:BarScale() *self:GetTall(), 0);
		local Track = self:GetTall() - BarSize;
		
		Track = Track + 1;
		Scroll = Scroll * Track;
		
		self.btnGrip:SetPos(0, Scroll);
		self.btnGrip:SetSize(self:GetWide(), BarSize);
	end;

	function self.VBar:Think()
		self.scrollSpeed = math.Approach(self.scrollSpeed, 4, math.abs(4 - self.scrollSpeed) * FrameTime());
		self.Scroll = math.Approach(self.Scroll, self.targetScroll, 10 * math.abs(self.targetScroll - self.Scroll) * FrameTime());

		if (!self.Dragging) then
			if (self.targetScroll < 0) then
				self.targetScroll = math.Approach(self.targetScroll, 0, 10 * math.abs(0 - self.Scroll) * FrameTime());
			elseif (self.targetScroll > self.CanvasSize) then
				self.targetScroll = math.Approach(self.targetScroll, self.CanvasSize, 10 * math.abs(self.CanvasSize - self.Scroll) * FrameTime());
			end;
		end;
	end;

	function self.VBar:SetScroll(amount)
		self.targetScroll = amount;
		self:InvalidateLayout();
		
		local func = self:GetParent().OnVScroll;

		if (func) then
			func(self:GetParent(), self:GetOffset());
		else
			self:GetParent():InvalidateLayout();
		end;
	end;
end;

function panel:Think()
	self.pnlCanvas:SetPos(0, -self.VBar.Scroll);
end;

function panel:PerformLayout()
	local width, height = self:GetSize();

	self:Rebuild();
	self.VBar:SetUp(height, self.pnlCanvas:GetTall());

	if (self.VBar.Enabled) then
		self.pnlCanvas:SetWide(width);
	else
		self.pnlCanvas:SetWide(width);
		self.pnlCanvas:SetPos(0, 0);
	end;

	self:Rebuild();
end;

function panel:Paint(width, height)
	if (self:GetDrawBorder()) then
		local theme = serverguard.themes.GetCurrent();
	
		draw.RoundedBox(4, 0, 0, width, height, theme.tiger_list_outline);
		draw.RoundedBox(2, 1, 1, width - 2, height - 2, theme.tiger_list_bg);
	end;
end;

vgui.Register("tiger.scrollpanel", panel, "DScrollPanel");