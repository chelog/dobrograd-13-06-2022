--[[
	© 2017 Thriving Ventures Limited do not share, re-distribute or modify
	
	without permission of its author (gustaf@thrivingventures.com).
]]

local plugin = plugin;

local panel = {};

function panel:Init()
	self.checkboxes = {};
	self:DockPadding(16, 16, 20, 32);
	self:SetPos(45, 0);
	self:SetAlpha(0);

	self.label = vgui.Create("DLabel", self);
	self.label:SetSkin("serverguard");
	self.label:SetFont("DefaultBold");
	self.label:DockMargin(8, 0, 0, 8);
	self.label:Dock(TOP);
	self.label:SetText(plugin.vote.title);
	self.label:SizeToContents();
	self.label:SetWrap(true);
	self.label:SetAutoStretchVertical(true);

	for k, v in ipairs(plugin.vote.options) do
		local checkbox = vgui.Create("tiger.checkbox", self);
			checkbox:SetText(tostring(k)..". "..v);
			checkbox:Dock(TOP);
		table.insert(self.checkboxes, checkbox);
	end;

	self:AlphaTo(255, 0.5, 0, function() end);
end;

function panel:FadeOut()
	self:AlphaTo(0, 0.5, 1, function()
		self:Remove();
	end);
end;

function panel:PerformLayout(width, height)
	self:SetSize(187, 40 + (#self.checkboxes * 30) + self.label:GetTall());
	self:CenterVertical(0.4);
end;

vgui.Register("tiger.panel.vote", panel, "tiger.panel");