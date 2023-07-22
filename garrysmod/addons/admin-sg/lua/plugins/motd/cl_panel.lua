--[[
	© 2017 Thriving Ventures Limited do not share, re-distribute or modify
	
	without permission of its author (gustaf@thrivingventures.com).
]]

local plugin = plugin;
local category = {};

local delay = 0;

category.name = "MOTD";
category.material = "serverguard/menuicons/icon_motd.png";
category.permissions = "Manage MOTD";

function category:Create(base)
	base.panel = base:Add("tiger.panel");
	base.panel:SetTitle("MOTD management");
	base.panel:Dock(FILL);

	base.panel.config = base.panel:Add("tiger.panel");
	base.panel.config:SetTall(68);
	base.panel.config:Dock(BOTTOM);
	base.panel.config:DockPadding(8, 8, 8, 8);

	base.panel.configTop = base.panel.config:Add("Panel");
	base.panel.configTop:SetTall(22);
	base.panel.configTop:Dock(TOP);

	base.panel.configSpacer = base.panel.config:Add("Panel"); -- docking is wonky, so we need spacer panels
	base.panel.configSpacer:SetTall(8);
	base.panel.configSpacer:Dock(TOP);

	base.panel.configBottom = base.panel.config:Add("Panel");
	base.panel.configBottom:SetTall(22);
	base.panel.configBottom:Dock(FILL);

	base.panel.spacer = base.panel:Add("Panel");
	base.panel.spacer:SetTall(24);
	base.panel.spacer:Dock(BOTTOM);

	category.html = base.panel:Add("DHTML");
	category.html:SetHTML(plugin.defaultHTML);
	category.html:Dock(FILL);

	base.panel.unlockType = base.panel.configTop:Add("DComboBox");
	base.panel.unlockType:SetWide(150);
	base.panel.unlockType:Dock(LEFT);
	base.panel.unlockType:SetText("Unlock Type");
	base.panel.unlockType:SetFont("tiger.button");
	base.panel.unlockType:SetSkin("serverguard");
	base.panel.unlockType:AddChoice("Slider");
	base.panel.unlockType:AddChoice("Button");
	base.panel.unlockType:SetToolTipSG("Changes how the MOTD closes.");

	function base.panel.unlockType:OpenMenu(pControlOpener)
		DComboBox.OpenMenu(self, pControlOpener);
		self.Menu:SetSkin("serverguard");
	end;

	function base.panel.unlockType:OnSelect(index, value, data)
		local unlockType = "slider";

		if (value == "Button") then
			unlockType = "button";
		end;

		serverguard.netstream.Start("sgUpdateMOTDConfig", {
			uniqueID = "Unlock Type",
			value = unlockType
		});
	end;

	base.panel.spacer = base.panel.configTop:Add("Panel");
	base.panel.spacer:SetWide(8);
	base.panel.spacer:Dock(LEFT);

	category.url = base.panel.configTop:Add("DTextEntry");
	category.url:Dock(FILL);
	category.url:SetSkin("serverguard");
	category.url:SetToolTipSG("The website to load when opened.");

	function category.url:OnEnter()
		serverguard.netstream.Start("sgUpdateMOTDConfig", {
			uniqueID = "URL",
			value = category.url:GetValue()
		});
	end;

	base.panel.delayLabel = base.panel.configBottom:Add("DLabel");
	base.panel.delayLabel:SetMouseInputEnabled(true);
	base.panel.delayLabel:SetFont("tiger.button");
	base.panel.delayLabel:SetText("Delay  ");
	base.panel.delayLabel:SetSkin("serverguard");
	base.panel.delayLabel:SizeToContents();
	base.panel.delayLabel:Dock(LEFT);
	base.panel.delayLabel:SetToolTipSG("How long you need to wait before you can close the MOTD.");

	category.delayPanel = base.panel.configBottom:Add("Slider");
	category.delayPanel:SetTall(22);
	category.delayPanel:SetSkin("serverguard");
	category.delayPanel:Dock(FILL);
	category.delayPanel:SetDecimals(0);
	category.delayPanel:SetMin(0);
	category.delayPanel:SetMax(10);
	category.delayPanel:SetValue(0);
	category.delayPanel.amount = delay;

	function category.delayPanel:OnValueChanged(value)
		value = math.Round(value);

		if (value != category.delayPanel.amount) then
			serverguard.netstream.Start("sgUpdateMOTDConfig", {
				uniqueID = "Delay",
				value = value
			});

			category.delayPanel.amount = value;
		end;
	end;
end;

function category:Update()
	serverguard.netstream.Start("sgRequestMOTDConfig", 1);
end;

plugin:AddSubCategory("Server settings", category);

serverguard.netstream.Hook("sgReceiveMOTDConfig", function(data)
	local config = data[1];

	for k, v in pairs(config) do
		if (k == "Delay") then
			delay = tonumber(v);

			if (IsValid(category.delayPanel)) then
				category.delayPanel.amount = tonumber(v);
				category.delayPanel:SetValue(tonumber(v));
			end;
		elseif (k == "URL") then
			if (IsValid(category.url)) then
				local url = tostring(v);

				category.url:SetValue(url);

				if (url == "") then
					category.html:SetHTML(plugin.defaultHTML);
				else
					category.html:OpenURL(url);
				end;
			end;
		end;
	end;
end);