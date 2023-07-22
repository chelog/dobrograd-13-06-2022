--[[
	© 2017 Thriving Ventures Limited do not share, re-distribute or modify
	
	without permission of its author (gustaf@thrivingventures.com).
]]

surface.CreateFont("tiger.advertisement.background", {font = "Arial", size = 14, weight = 400, blursize = 2});

local plugin = plugin;

local category = {};

category.name = "Adverts";
category.material = "serverguard/menuicons/icon_advertisements.png";
category.permissions = "Manage Advertisements";

category.advertisements = {};

local function NewAdvertisementWindow(title, buttonText, callback)
	local basePanel = vgui.Create("tiger.panel");
	basePanel:SetTitle(title);
	basePanel:SetSize(580, 440);
	basePanel:Center();
	basePanel:MakePopup();
	basePanel:DockPadding(24, 24, 24, 48);

	local itemList = basePanel:Add("tiger.list");
	itemList:Dock(FILL);

	local textBox = vgui.Create("tiger.textentry");
		textBox:SetLabelText("Text to display");
		textBox:Dock(TOP);
	itemList:AddPanel(textBox);

	local interval = vgui.Create("tiger.numslider");
		interval:SetText("Interval in seconds");
		interval:Dock(TOP);
		interval:SetMinMax(10, 86400);
		interval:SetValue(512);
	itemList:AddPanel(interval);

	function interval:ValueChanged(value)
		intervalValue = value;
	end;

	local colorSlider = vgui.Create("DColorMixer");
		colorSlider:Dock(TOP);
		colorSlider:DockMargin(0, 14, 0, 14);
	itemList:AddPanel(colorSlider);

	local createButton = basePanel:Add("tiger.button");
	createButton:SetPos(4, 4);
	createButton:SetText(buttonText);
	createButton:SizeToContents();

	function createButton:DoClick()
		callback(textBox:GetValue(), (intervalValue or interval:GetValue()), colorSlider:GetColor());
		basePanel:Remove();
	end;

	local cancelButton = basePanel:Add("tiger.button");
	cancelButton:SetPos(4, 4);
	cancelButton:SetText("Cancel");
	cancelButton:SizeToContents();

	function cancelButton:DoClick()
		basePanel:Remove();
	end;

	function basePanel:PerformLayout()
		local width, height = self:GetSize();

		createButton:SetPos(width - (createButton:GetWide() + 24), height - (createButton:GetTall() + 14));
		cancelButton:SetPos(0, height - (cancelButton:GetTall() + 14));
		cancelButton:MoveLeftOf(createButton, 14);
	end;
end;

local function EditAdvertisementWindow(title, buttonText, data, callback)
	local basePanel = vgui.Create("tiger.panel");
	basePanel:SetTitle(title);
	basePanel:SetSize(580, 440);
	basePanel:Center();
	basePanel:MakePopup();
	basePanel:DockPadding(24, 24, 24, 48);

	local itemList = basePanel:Add("tiger.list");
	itemList:Dock(FILL);

	local textBox = vgui.Create("tiger.textentry");
		textBox:Dock(TOP);
		textBox:SetLabelText("Text to display");
		textBox:SetText(data.text or "");
	itemList:AddPanel(textBox);

	local interval = vgui.Create("tiger.numslider");
		interval:Dock(TOP);
		interval:SetText("Interval in seconds");
		interval:SetMinMax(10, 86400);
		interval:SetValue(data.interval or 512);
	itemList:AddPanel(interval);

	function interval:ValueChanged(value)
		intervalValue = value;
	end;

	local colorSlider = vgui.Create("DColorMixer");
		colorSlider:SetColor(data.color or Color(255, 0, 0, 255));
		colorSlider:Dock(TOP);
		colorSlider:DockMargin(0, 14, 0, 14);
	itemList:AddPanel(colorSlider);

	local createButton = basePanel:Add("tiger.button");
	createButton:SetPos(4, 4);
	createButton:SetText(buttonText);
	createButton:SizeToContents();

	function createButton:DoClick()
		callback(textBox:GetValue(), (intervalValue or interval:GetValue()), colorSlider:GetColor());
		basePanel:Remove();
	end;

	local cancelButton = basePanel:Add("tiger.button");
	cancelButton:SetPos(4, 4);
	cancelButton:SetText("Cancel");
	cancelButton:SizeToContents();

	function cancelButton:DoClick()
		basePanel:Remove();
	end;

	function basePanel:PerformLayout()
		local width, height = self:GetSize();

		createButton:SetPos(width - (createButton:GetWide() + 24), height - (createButton:GetTall() + 14));
		cancelButton:SetPos(0, height - (cancelButton:GetTall() + 14));
		cancelButton:MoveLeftOf(createButton, 14);
	end;
end;

function category:Create(base)
	base.panel = base:Add("tiger.panel");
	base.panel:SetTitle("Advertisements");
	base.panel:Dock(FILL);
	base.panel:DockPadding(24, 24, 24, 48);
  
	category.list = base.panel:Add("tiger.list");
	category.list:Dock(FILL);
	
	category.list:AddColumn("ADVERTISEMENT", 500);
	category.list:AddColumn("INTERVAL", 75);
	
	function category.list:Think()
		if (category.nextUpdate and category.nextUpdate < CurTime()) then
			category.list:Clear();
			
			serverguard.netstream.Start("sgRequestAdvertisements", true);
			
			category.nextUpdate = nil;
			category.advertisements = {};
		end;
	end;
	
	category.nextUpdate = CurTime() + 0.3;
	
	local newAdvertisement = base.panel:Add("tiger.button");
	newAdvertisement:SetPos(4, 4);
	newAdvertisement:SetText("Add new advertisement");
	newAdvertisement:SizeToContents();
	
	function newAdvertisement:DoClick()
		NewAdvertisementWindow("Add an advertisement", "Create", function(text, interval, color)
			serverguard.netstream.Start("sgCreateAdvertisement", {
				string.sub(text, 1, 256), math.Clamp(math.Round(tonumber(interval)), 10, 86400), color
			});

			category.list:Clear();
			category.advertisements = {};
		end);
	end;
	
	function base.panel:PerformLayout()
		local w, h = self:GetSize();
		
		newAdvertisement:SetPos(w - (newAdvertisement:GetWide() + 24), h - (newAdvertisement:GetTall() + 14));
	end;
end;

function category:Update(base)
	category.nextUpdate = CurTime() + 0.3;
end;

plugin:AddSubCategory("Server settings", category);

--
-- Receives the advertisement.
--

serverguard.netstream.Hook("sgGetAdvertisement", function(data)
	local text = data[1];
	local interval = data[2];
	local color = data[3];
	local data = {
		text = text,
		interval = interval,
		color = Color(color.r, color.g, color.b, 255)
	};
	
	local panel = category.list:AddItem(data.text, data.interval);
	panel.id = table.insert(category.advertisements, data);

	local label = panel.labels[1];

	function label:Paint(width, height)
		surface.SetFont(label:GetFont());
		local textWidth, textHeight = surface.GetTextSize(label:GetText());

		-- it's always going to be centered anyway
		for i = 1, 4, 1 do
			surface.SetDrawColor(0, 0, 0, 255);
			surface.SetFont("tiger.advertisement.background");
			surface.SetTextPos(width / 2 - textWidth / 2, height / 2 - textHeight / 2);
			surface.DrawText(self:GetText());
		end;
	end;

	local textLabel = panel:GetLabel(1);
	textLabel:SetColor(data.color);
	textLabel.oldColor = data.color;
	
	function panel:OnMousePressed()
		local menu = DermaMenu()
			menu:SetSkin("serverguard");

			menu:AddOption("Edit advertisement", function()
				EditAdvertisementWindow("Modify an advertisement", "Modify", {text = data.text, interval = data.interval, color = data.color}, function(text, interval, color)
					serverguard.netstream.Start("sgChangeAdvertisement", {
						self.id, string.sub(text, 1, 256), math.Clamp(tonumber(interval), 10, 86400), color
					});

					category.list:Clear();
					category.advertisements = {};
				end);
			end);
			
			menu:AddOption("Remove advertisement", function()
				serverguard.netstream.Start("sgRemoveAdvertisement", self.id);
				
				category.list:Clear()
				category.advertisements = {}
			end);
		menu:Open();
	end;
end);
