--[[
	© 2017 Thriving Ventures Limited do not share, re-distribute or modify
	
	without permission of its author (gustaf@thrivingventures.com).
]]

local plugin = plugin;

plugin:IncludeFile("shared.lua", SERVERGUARD.STATE.CLIENT);
plugin:IncludeFile("sh_commands.lua", SERVERGUARD.STATE.CLIENT);
plugin:IncludeFile("cl_panel.lua", SERVERGUARD.STATE.CLIENT);

surface.CreateFont("serverguard.motd.slider", {
	font = "Roboto",
	size = 16,
	weight = 300
});

surface.CreateFont("serverguard.motd.delay", {
	font = "Roboto",
	size = 20,
	weight = 300
});

plugin.defaultHTML = [[
<!DOCTYPE html>
<html>
	<head>
		<style type="text/css">
			body {
				background: rgb(254, 254, 254);
				font-family: "Segoe UI", "Arial", sans-serif;
			}

			h1 {
				font-weight: 100;
			}

			strong {
				font-weight: 600;
			}

			.wrapper {
				height: 100%;
			}

			.contentBox {
				width: 800px;
				padding: 8px;
				
				background: rgb(255, 255, 255);
				box-shadow: 0 0 1px 0 rgb(180, 180, 180);
				border: 1px solid rgb(180, 180, 180);
				
				margin: auto;
				margin-top: 24px;
			}
		</style>
	</head>

	<body>
		<center>
			<h1>Welcome to ]] .. GetHostName() .. [[!</h1>
		</center>

		<div class="contentBox">
			Now that you've enabled the MOTD plugin, you're going to have to set the URL that the MOTD will load whenever it's opened. Suitable web pages can include your community's homepage/forums, a page to describe your server's rules, etc. This will be the first thing that players will see, so make it eye-catching! You can open the MOTD at any time by using the <strong>!motd</strong> command.
		</div>

		<div class="contentBox">
			To change the settings for the MOTD, make sure you have the <strong>Founder</strong> rank or have the <strong>Manage MOTD</strong> permission. Open up the ServerGuard menu and navigate to the <strong>MOTD</strong> category on the left. Here you will find a preview of what the MOTD will look like, along with the various settings underneath it. You can change the <strong>URL</strong>, <strong>Unlock Type</strong>, and <strong>Delay</strong>. Changing the URL to a blank box will make the MOTD open this page.<br />
			<br />
			The <strong>Unlock Type</strong> will change how the player will have to close the MOTD. Changing this setting to <strong>Button</strong> will require users to click a simple button to close the MOTD. Changing it to <strong>Slider</strong> will require players to drag a button to the end of a line to close the MOTD.<br />
			<br />
			The <strong>Delay</strong> setting will make it so that players will have to wait a certain amount of time before they can close the MOTD. You can set it to any time between 0 and 10 seconds. Setting the delay to 0 seconds will remove the delay entirely.
		</div>
	</body>
</html>
]];

local firstRun = true;

local motd;
local url = "";
local delay = 0;
local unlockType = "slider";
local unlockTypes = {
	["button"] = true,
	["slider"] = true
};

local PANEL = {};

function PANEL:Init()
	self:SetSize(ScrW() * 0.9, ScrH() * 0.9);
	self:DockPadding(24, 24, 24, 24);
	self:SetAlpha(0);
	self:Center();

	self.html = vgui.Create("DHTML", self);

	if (url == "") then
		self.html:SetHTML(plugin.defaultHTML);
	else
		self.html:OpenURL(url);
	end;

	self.html:SetTall(self:GetTall() - (64 + 36));
	self.html:Dock(TOP);

	if (!unlockTypes[unlockType]) then
		unlockType = "button";
	end;

	if (delay and math.Round(delay) > 0) then
		self.delayStart = CurTime();
		self.delayTarget = CurTime() + math.Round(delay);
		self.delayCurrent = CurTime();
	end;

	self.unlockParent = vgui.Create("Panel", self);
	self.unlockParent:SetSize(self:GetWide() - 48, 32);
	self.unlockParent:Dock(BOTTOM);
	self.unlockParent.Paint = function(_self, width, height)
		if (self.delayStart and (self.delayCurrent < self.delayTarget)) then
			local theme = serverguard.themes.GetCurrent();
			draw.SimpleText("You can close this MOTD in " .. math.ceil(self.delayTarget - self.delayCurrent) .. " second(s).", "serverguard.motd.delay", width / 2, height / 2, theme.tiger_base_section_label, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);
		end;
	end;

	self.unlock = vgui.Create("serverguard.motd." .. unlockType, self.unlockParent);
	self.unlock:SetCallback(function()
		self:FadeOut(function()
			self:Remove();
			delay = 0;
			motd = nil;
		end);
	end);

	if (self.delayStart) then
		self.unlock:SetVisible(false);
	end;
end;

function PANEL:OnDelayFinished()
	delay = 0;
	self.unlock:FadeIn();
end;

function PANEL:Think()
	if (self.delayStart) then
		if (self.delayCurrent < self.delayTarget) then
			self.delayCurrent = CurTime();
		else
			self:OnDelayFinished();
			self.delayStart = nil;
		end;
	end;
end;

function PANEL:FadeIn(callback)
	self:SetVisible(true);
	self:SetAlpha(0);
	self:AlphaTo(255, 0.15, 0, callback);
end;

function PANEL:FadeOut(callback)
	self:SetVisible(true);
	self:SetAlpha(255);
	self:AlphaTo(0, 0.15, 0, callback);
end;

vgui.Register("serverguard.motd", PANEL, "tiger.panel");

local PANEL = {};

function PANEL:Init()
	self.backgroundMaterial = Material("gui/gradient_down");
	self.buttonMaterial = Material("icon16/arrow_right.png");

	self:SetSize(64, self:GetParent():GetTall() - 2);
	self:SetMouseInputEnabled(true);
end;

function PANEL:OnMousePressed(mouseCode)
	self.pressed = (mouseCode == MOUSE_LEFT);
end;

function PANEL:OnMouseReleased(mouseCode)
	self.pressed = false;
end;

function PANEL:Paint(width, height)
	local theme = serverguard.themes.GetCurrent();
	draw.RoundedBox(4, 0, 0, width, height, theme.tiger_base_outline);

	surface.SetMaterial(self.backgroundMaterial);
	surface.SetDrawColor(theme.tiger_base_bg);
	surface.DrawTexturedRect(0, 0, width, height);

	surface.SetMaterial(self.buttonMaterial);
	surface.SetDrawColor(Color(255, 255, 255, 255));
	surface.DrawTexturedRect(width / 2 - 8, height / 2 - 8, 16, 16);
end;

function PANEL:Think()
	if (!self.pressed) then
		return;
	end;

	if (!input.IsMouseDown(MOUSE_LEFT)) then
		self.pressed = false;
	end;
end;

vgui.Register("serverguard.motd.slider.button", PANEL, "Panel");

local PANEL = {};

function PANEL:Init()
	self:SetSize(math.Clamp(self:GetParent():GetWide() / 2, 250, 400), 32);
	self:SetPos(self:GetParent():GetWide() / 2 - self:GetWide() / 2, 0);

	self.button = vgui.Create("serverguard.motd.slider.button", self);
	self.button:SetPos(1, 1);
end;

function PANEL:FadeIn(callback)
	self:SetVisible(true);
	self:SetAlpha(0);
	self:AlphaTo(255, 0.15, 0, callback);
end;

function PANEL:FadeOut(callback)
	self:SetVisible(true);
	self:SetAlpha(255);
	self:AlphaTo(0, 0.15, 0, callback);
end;

function PANEL:Paint(width, height)
	local theme = serverguard.themes.GetCurrent();

	draw.RoundedBox(4, 0, 0, width, height, theme.tiger_base_outline);
	draw.RoundedBox(2, 1, 1, width - 2, height - 2, theme.tiger_base_bg);

	draw.SimpleText("Drag to close", "serverguard.motd.slider", width / 2, height / 2, theme.tiger_base_section_label, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);
end;

function PANEL:Think()
	if (self.unlocked) then
		return;
	end;

	if (!self.button.pressed) then
		local buttonX, buttonY = self.button:GetPos();

		if (buttonX > 1) then
			local animateSpeed = buttonX * 4;

			self.button:SetPos(math.Approach(buttonX, 1, animateSpeed * FrameTime()), 1);
		end;

		return;
	end;

	local x, y = self:CursorPos();
		self.button:SetPos(math.Clamp(x + 1, 1, self:GetWide() - self.button:GetWide() - 1), 1);
	local newX, newY = self.button:GetPos();

	if (newX == self:GetWide() - self.button:GetWide() - 1) then
		if (self.callback) then
			self.callback();
		end;

		self.unlocked = true;
	end;
end;

function PANEL:SetCallback(callback)
	self.callback = callback;
end;

vgui.Register("serverguard.motd.slider", PANEL, "Panel");

local PANEL = {};

function PANEL:Init()
	self:SetText("Close");
	self:SetSize(self:GetParent():GetWide() / 4, 32);
	self:SetPos(self:GetParent():GetWide() / 2 - self:GetWide() / 2, 0);
end;

function PANEL:FadeIn(callback)
	self:SetVisible(true);
	self:SetAlpha(0);
	self:AlphaTo(255, 0.15, 0, callback);
end;

function PANEL:FadeOut(callback)
	self:SetVisible(true);
	self:SetAlpha(255);
	self:AlphaTo(0, 0.15, 0, callback);
end;

function PANEL:SetCallback(callback)
	self.callback = callback;
end;

function PANEL:DoClick()
	if (self.callback) then
		self.callback();
	end;
end;

vgui.Register("serverguard.motd.button", PANEL, "tiger.button");

local function MAKE_MOTD()
	motd = vgui.Create("serverguard.motd");
	motd:MakePopup();
	motd:FadeIn();

	if (firstRun) then
		firstRun = nil;
	end;
end;

serverguard.netstream.Hook("sgOpenMOTD", function(data)
	if (motd) then
		if (motd:IsVisible()) then
			motd:FadeOut(function()
				motd:Remove();

				MAKE_MOTD();
			end);
		else
			motd:Remove();
			
			MAKE_MOTD();
		end;

		return;
	end;

	MAKE_MOTD();
end);

serverguard.netstream.Hook("sgReceiveMOTDConfig", function(data)
	local config = data[1];
	local bInitial = data[2];

	for k, v in pairs(config) do
		if (k == "Unlock Type") then
			unlockType = tostring(v);
		elseif (k == "URL") then
			url = tostring(v);
		elseif (k == "Delay") then
			if (firstRun) then
				delay = tonumber(v);
			end;
		end;
	end;

	if (firstRun and bInitial) then
		MAKE_MOTD();
	end;
end);