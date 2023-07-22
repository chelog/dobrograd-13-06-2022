--[[
	© 2017 Thriving Ventures Limited do not share, re-distribute or modify
	
	without permission of its author (gustaf@thrivingventures.com).
]]

local category = {};

category.name = "Themes";
category.material = "serverguard/menuicons/icon_themes.png";

function category:Create(base)
	local themes = serverguard.themes.GetStored();

	base.panel = base:Add("tiger.panel");
	base.panel:SetTitle("Modify theme preferences");
	base.panel:Dock(FILL);
	
	base.panel.list = base.panel:Add("tiger.list");
	base.panel.list:Dock(FILL);
	base.panel.list:DockMargin(0, 54, 0, 0);
	base.panel.list:AddColumn("Theme name", 375);
	base.panel.list:AddColumn("Selected");

	hook.Call("serverguard.panel.ThemeList", nil, base.panel.list);

	local controls = {
		"tiger.base",
		"tiger.list",
		"tiger.panel",
		"tiger.divider",
		"tiger.button",
		"tiger.tooltip",
		"tiger.news"
	};
	
	local function CreateControls()
		base.panel.editFrame = vgui.Create("tiger.base");
		base.panel.editFrame:SetSize(ScrW() / 2 - 50, ScrH() - 50);
		base.panel.editFrame:SetPos(25, 25);

		base.panel.colorBase = vgui.Create("tiger.panel");
		base.panel.colorBase:SetSize(ScrW() / 2 - 50, ScrH() - 25);
		base.panel.colorBase:SetTitle("Section colors");
		base.panel.colorBase:Center();
		base.panel.colorBase:MoveRightOf(base.panel.editFrame, 25);
		base.panel.colorBase:MakePopup();
		
		local saveButton = base.panel.colorBase:Add("tiger.button");
		saveButton:Dock(TOP);
		saveButton:DockMargin(0, 0, 0, 14);
		saveButton:SetText("Save & Close");
		saveButton:SizeToContents();
		
		function saveButton:DoClick()
			base.panel.colorBase:Remove();
			base.panel.editFrame:Remove();
			
			serverguard.themes.Save();
		end;
	
		local colorList = base.panel.colorBase:Add("tiger.list");
		colorList:Dock(FILL);
		colorList:GetCanvas():DockPadding(14, 14, 14, 14);
		
		for k, v in ipairs(controls) do
			base.panel.editFrame:AddSection(v, category.material, function(base)
				if (!base.created) then
					base.type = v;
					
					if (v != "tiger.base") then
						local panel = base:Add(v);
						panel:Dock(FILL);
						panel:SetTall(100);
						
						if (v == "tiger.list") then
							panel:AddColumn("This is a test column", 160);
							panel:AddColumn("This is a test column", 160);
							panel:AddColumn("This is a test column", 160);
							
							for i = 1, 20 do
								panel:AddItem("This is a test item", "This is a test item", "This is a test item");
								panel:AddItem("This is a test item", "This is a test item", "This is a test item");
							end;
						end;
						
						if (v == "tiger.panel") then
							panel:SetTitle("Test title");
						end;
						
						if (v == "tiger.divider") then
							for i = 1, 20 do
								panel:AddRow("Test row", "Test row");
							end;
						end;
						
						if (v == "tiger.button") then
							panel:SetText("Test button");
						end;
						
						if (v == "tiger.tooltip") then
							panel:SetText("Test tooltip");
							panel:SetDrawOnTop(false);
						end;

						if (v == "tiger.news") then
							panel:DockPadding(1, 1, 1, 1);
							panel:PopulateArticle("Test Article", os.date("%B %d, %Y"), "<p>This is a test article.</p>", "<p>Even more content!</p>");
						end;
					end;
					
					base.created = true;
				else
					colorList:Clear();
					
					local colors = serverguard.themes.GetColorNames(base.type);
				
					for k2, v2 in pairs(colors) do
						local current = serverguard.themes.GetCurrent();
						
						for k3, v3 in pairs(current) do
							if (v2 == k3) then
								local panel = vgui.Create("DColorMixer");
								panel:SetTall(124);
								panel:SetLabel(k3);
								panel:SetColor(v3);
								panel:Dock(TOP);
								panel:SetPalette(false);
				
								function panel:ValueChanged(color)
									serverguard.themes.Set(k3, color);
								end;
								
								colorList:AddPanel(panel);
							end;
						end;
					end;
				end;
			end);
		end;

		serverguard.menu.Close(true);
	end;
	
	local function populateThemeList()
		themes = serverguard.themes.GetStored();

		base.panel.list:Clear();
		base.panel.selectTheme:Clear();

		-- Theme list.
		for name, data in pairs(themes) do
			local panel = base.panel.list:AddItem(name, "");
			
			function panel:OnMousePressed(keyCode)
				if (keyCode == MOUSE_LEFT) then
					RunConsoleCommand("serverguard_theme", name);
				elseif (keyCode == MOUSE_RIGHT) then
					local menu = DermaMenu()
						menu:SetSkin("serverguard");
						
						local option = menu:AddOption("Select theme", function()
							RunConsoleCommand("serverguard_theme", name);
						end);

						option:SetImage("icon16/accept.png");

						if (!serverguard.themes.IsDefaultTheme(name)) then
							option = menu:AddOption("Remove theme", function()
								local currentTheme, currentName = serverguard.themes.GetCurrent();

								if (name == currentName) then
									RunConsoleCommand("serverguard_theme", "default");
								end;

								serverguard.themes.Remove(name);
									panel:Clear();
									panel:Remove();
									panel = nil;
								populateThemeList();
							end);

							option:SetImage("icon16/delete.png");
						end;
					menu:Open();
				end;
			end;
			
			local label = panel:GetLabel(2);
			
			label:SetUpdate(function(self)
				if (serverguard.theme:GetString() == name) then
					self:SetText("Yes");
				else
					self:SetText("");
				end;
			end);
		end;

		-- Theme dropdown.
		base.panel.selectTheme:AddChoice("Create new");
		
		for name, data in pairs(themes) do
			base.panel.selectTheme:AddChoice(name);
		end;
	end;

	base.panel.selectTheme = base.panel:Add("DComboBox");
	base.panel.selectTheme:SetSize(150, 22);
	base.panel.selectTheme:SetPos(24, 74);
	base.panel.selectTheme:SetText("Edit theme");
	base.panel.selectTheme:SetFont("tiger.button");
	base.panel.selectTheme:SetSkin("serverguard");
	base.panel.selectTheme:AddChoice("Create new");
	
	function base.panel.selectTheme:OpenMenu(pControlOpener)
		DComboBox.OpenMenu(self, pControlOpener);

		self.Menu:SetSkin("serverguard");
	end;
	
	function base.panel.selectTheme:OnSelect(index, value, data)
		if (IsValid(base.panel.editFrame)) then
			base.panel.editFrame:Remove();
			base.panel.colorBase:Remove();
		end;
		
		if (value == "Create new") then
			base.panel.themeName = base.panel:Add("DTextEntry");
			base.panel.themeName:SetPos(14 + base.panel.selectTheme:GetWide() + 28, 74);
			base.panel.themeName:SetSize(200, base.panel.selectTheme:GetTall());
			base.panel.themeName:SetSkin("serverguard");
			
			function base.panel.themeName:OnEnter()
				local value = self:GetValue();
				
				serverguard.themes.New(value, serverguard.themes.GetCurrent());
				serverguard.themes.Save();
				populateThemeList();
	
				RunConsoleCommand("serverguard_theme", value);
				CreateControls();

				self:Remove();
			end;
		else
			if (IsValid(base.panel.themeName)) then
				base.panel.themeName:Remove();
			end;
			
			RunConsoleCommand("serverguard_theme", value);
			
			CreateControls();
		end;
	end;

	populateThemeList();
end;

serverguard.menu.AddCategory(category);