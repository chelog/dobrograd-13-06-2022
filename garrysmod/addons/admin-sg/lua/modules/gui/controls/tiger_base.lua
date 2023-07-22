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

surface.CreateFont("tiger.base.search", {font = "Arial", size = 12, weight = 400});
surface.CreateFont("tiger.base.footer", {font = "Arial", size = 14, weight = 400})
surface.CreateFont("tiger.base.section", {font = "Helvetica", size = 14, weight = 400})

serverguard.themes.CreateDefault("tiger_base_bg", Color(232, 231, 239), "tiger.base")
serverguard.themes.CreateDefault("tiger_base_outline", Color(190, 190, 190), "tiger.base")
serverguard.themes.CreateDefault("tiger_base_footer_bg", Color(255, 255, 255), "tiger.base")
serverguard.themes.CreateDefault("tiger_base_footer_label", Color(31, 153, 228), "tiger.base")
serverguard.themes.CreateDefault("tiger_base_footer_hint", Color(141, 142, 134), "tiger.base")

-- Section.
serverguard.themes.CreateDefault("tiger_base_section_icon",  Color(141, 142, 134), "tiger.base")
serverguard.themes.CreateDefault("tiger_base_section_icon_selected",  Color(31, 153, 228), "tiger.base")
serverguard.themes.CreateDefault("tiger_base_section_label",  Color(141, 142, 134), "tiger.base")
serverguard.themes.CreateDefault("tiger_base_section_label_selected",  Color(31, 153, 228), "tiger.base")
serverguard.themes.CreateDefault("tiger_base_section_outline", Color(190, 190, 190), "tiger.base")
serverguard.themes.CreateDefault("tiger_base_section_selected", Color(232, 231, 239), "tiger.base")

function panel:Init()
	local theme = serverguard.themes.GetCurrent()

	self.sections = {}
	self.searchString = "";
	self.lastSection = nil
	
	self:DockPadding(162, 22, 22, 46);
	
	self.sectionList = self:Add("tiger.list")
	self.sectionList:DockPadding(0, 0, 0, 0)
	self.sectionList.list:SetUseSizeLimit(false);
	
	function self.sectionList:Paint(w, h)
		local theme = serverguard.themes.GetCurrent()
		
		draw.SimpleRect(0, 0, w, h, theme.tiger_list_bg)
		draw.SimpleRect(w -1, 0, 1, h, theme.tiger_list_outline)
	end

	self.bFooterEnabled = true;
	self.bUseSmallPanels = false;

	self.updatePanel = self:Add("Panel");
	self.updatePanel:SetMouseInputEnabled(true);
	self.updatePanel.OnMousePressed = function(_self, keyCode)
		if (self.updateNotify) then
			self.updateNotify = false;

			self.updatePanel:SetCursor("none");
			self.updatePanel:SetToolTipSG();

			timer.Simple(3, function()
				self.updateNotify = nil;
			end);
		end;
	end;

	self.copyright = self:Add("DLabel")
	self.copyright:SetMouseInputEnabled(true)
	self.copyright:SetText("Thriving Ventures Ltd (modded by Octothorp Team)")
	self.copyright:SetCursor("hand")
	self.copyright:SetToolTipSG("Click here to visit the ServerGuard website!")
	self.copyright:SetFont("tiger.base.footer")
	self.copyright:SetTextColor(theme.tiger_base_footer_label)

	function self.copyright:DoClick()
		gui.OpenURL("http://gmodserverguard.com/?utm_source=serverguard&utm_medium=organic&utm_content=footerlink&utm_campaign=serverguard")
	end

	self:SetupSearchPanel();
end

function panel:SetupSearchPanel()
	self.searchPanel = vgui.Create("Panel", self);
	self.searchPanel:SetSize(128, 22);
	self.searchPanel:Dock(TOP);
	self.searchPanel:SetVisible(false);

	function self.searchPanel:Paint(width, height)
		local theme = serverguard.themes.GetCurrent();
		local color = theme.tiger_list_panel_list_hover;

		draw.SimpleRect(0, 0, width - 1, height, color);
	end;

	self.searchPanel.label = self.searchPanel:Add("DLabel");
	self.searchPanel.label:SetTextColor(Color(0, 0, 0));
	self.searchPanel.label:SetSize(self.searchPanel:GetWide(), self.searchPanel:GetTall());
	self.searchPanel.label:SetContentAlignment(5);
	self.searchPanel.label:SetFont("tiger.base.search");
	self.searchPanel.label:SetText("");
	
	serverguard.themes.AddPanel(self.searchPanel.label, "tiger_list_panel_label_hover");
end;

function panel:OnKeyCodePressed(keyCode)
	local key = input.GetKeyName(keyCode);

	if (!key) then return; end;
	
	local matches = self:GetSearchMatches(self.searchString)
	local matchAmount = #matches;
	local bUseSmallPanels = self:GetUseSmallPanels();
	local nextMatchAmount = #self:GetSearchMatches(self.searchString..key);

	if (key == "BACKSPACE") then
		self.searchString = string.sub(self.searchString, 1, #self.searchString - 1);
	elseif (key == "ENTER" and matchAmount == 1) then
		-- HACK because docking is awfully implemented.
		local id = 0;
		local y = 0;

		for k, v in SortedPairs(self.sections) do
			if (k == matches[1].name) then
				y = id * 120;
				break;
			end;

			id = id + 1;
		end;

		self:ResetSearch();

		if (id == 0) then
			self.sectionList.list.VBar:SetScroll(-100);
		else
			self.sectionList.list.VBar:SetScroll(id * 120);
		end;

		matches[1].icon:DoClick();

		return;
	elseif (key == "SPACE" or string.match(key, "[a-z]")) then
		if (key == "SPACE") then
			key = " ";
		end;

		self.searchString = self.searchString..key;
	end;

	self.searchPanel.label:SetText(self.searchString);

	if (string.len(self.searchString) > 0 and !self.lastSearch) then
		self.searchPanel:SetVisible(true);
		self.sectionList.list.VBar:SetScroll(-100);

		self.lastSearch = true;
	elseif (string.len(self.searchString) < 1) then
		self.searchPanel:SetVisible(false);

		if (self.lastSearch) then
			self.sectionList.list.VBar:SetScroll(-100);
		end;

		self.lastSearch = nil;
	end;

	for k, v in pairs(self.sections) do
		if (IsValid(v)) then
			if (!string.StartWith(string.lower(k), self.searchString)) then
				v:SetSize(0, 0);
			else
				if (!bUseSmallPanels) then
					v:SetSize(128, 120);
				else
					v:SetSize(64, 80);
				end;
			end;
		end;
	end;
end;

function panel:ResetSearch()
	local bUseSmallPanels = self:GetUseSmallPanels();

	for k, v in pairs(self.sections) do
		if (IsValid(v)) then
			if (!bUseSmallPanels) then
				v:SetSize(128, 120);
			else
				v:SetSize(64, 80);
			end;
		end;
	end;

	self.searchString = "";
	self.lastSearch = nil;

	self.searchPanel:SetVisible(false);
	self.searchPanel.label:SetText("");
end;

function panel:GetSearchMatches(searchString)
	local matches = {};

	for k, v in pairs(self.sections) do
		if (string.StartWith(string.lower(k), searchString)) then
			table.insert(matches, v);
		end;
	end;

	return matches;
end;

function panel:GetFooterEnabled()
	return self.bFooterEnabled;
end;

function panel:SetFooterEnabled(bValue)
	local bRealValue = tobool(bValue);
	self.updatePanel:SetVisible(bValue);
	self.copyright:SetVisible(bValue);

	self:DockPadding(162, 22, 22, ((bRealValue and 46) or 22));

	self.bFooterEnabled = bRealValue;
end;

function panel:GetUseSmallPanels()
	return self.bUseSmallPanels;
end;

function panel:UseSmallPanels(bValue) -- should only ever be called immediately after creation
	local bRealValue = tobool(bValue);

	self.bUseSmallPanels = bRealValue;
	self:DockPadding(76, 12, 12, ((self:GetFooterEnabled() and 36) or 12));
end;

function panel:SetUpdateNotification(bToggled)
	local theme = serverguard.themes.GetCurrent();
	local themeCopy = table.Copy(theme);

	self.updateNotify = tobool(bToggled);
	self.updateTarget = Color(255, 210, 0);
	self.updateCurrent = themeCopy.tiger_base_footer_bg;

	if (bToggled) then
		self.updatePanel:SetCursor("hand");
		self.updatePanel:SetToolTipSG("Version " .. serverguard.GetLatestVersion() .. " of ServerGuard is now available!\nIt is recommended to update this server's version of ServerGuard.");
	else
		self.updatePanel:SetCursor("none");
		self.updatePanel:SetToolTipSG();
	end;
end;

function panel:AddSection(name, material, callback, flag)
	local base = vgui.Create("Panel")
	
	if (self:GetUseSmallPanels()) then
		base:SetSize(64, 80);
	else
		base:SetSize(128, 120);
	end;

	base:Dock(TOP)
	
	base.flag = flag;
	base.name = name;
	
	local function ShortenText(text, font, max_w)
		local split = string.ToTable(text)
		local res = ""
		for k,v in pairs(split) do
			if (util.GetTextSize(font, res .. v .. "...") > max_w) then
				return res .. "..."
			else
				res = res .. v
			end
		end
		return res
	end
	
	local function DrawWrappedText(text, font, w, h, color, align_h, align_v, max_w)
		local explode = string.Explode(" ", text)
		local currentText = ""
		local line = 0
		local y = select(2, util.GetTextSize(font, " "))
		for k,v in pairs(explode) do
			if (util.GetTextSize(font, currentText .. " " .. v) > max_w) then
				if (currentText != "") then
					draw.SimpleText(currentText, font, w, h + y * line, color, align_h, align_v)
					currentText = ""
					line = line + 1
				elseif (currentText == "" and k == #explode) then
					draw.SimpleText(ShortenText(v, font, max_w), font, w, h + y * line, color, align_h, align_v)
					break
				end
			end
			currentText = currentText .. " " .. v
			if (k == #explode and currentText != "") then
				draw.SimpleText(currentText, font, w, h + y * line, color, align_h, align_v)
			end
		end
	end
	
	function base:Paint(w, h)
		local theme = serverguard.themes.GetCurrent()
	
		if (self.selected) then
			draw.SimpleRect(0, 0, w, h, theme.tiger_base_section_selected)
			
			draw.SimpleRect(0, 0, w, 1, theme.tiger_base_section_outline)
			draw.SimpleRect(0, h -1, w, 1, theme.tiger_base_section_outline)
			
			DrawWrappedText(name, "tiger.base.section", w / 2, h - 24, theme.tiger_base_section_label_selected, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, w)
			
			if (self.icon:GetColor() != theme.tiger_base_section_icon_selected) then
				self.icon:SetColor(theme.tiger_base_section_icon_selected)
			end
		else
			DrawWrappedText(name, "tiger.base.section", w / 2, h - 24, theme.tiger_base_section_label, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, w)
			
			if (self.icon:GetColor() != theme.tiger_base_section_icon) then
				self.icon:SetColor(theme.tiger_base_section_icon)
			end
		end
	end
	
	if (base.flag) then
		function base:Think()
			local hasPermission = false;

			if (type(self.permissions) == "table") then
				for k, v in pairs(self.permissions) do
					if (serverguard.player:HasPermission(LocalPlayer(), v)) then
						hasPermission = true;
						break;
					end;
				end;
			else
				hasPermission = serverguard.player:HasPermission(LocalPlayer(), self.permissions);
			end;

			if (!hasPermission) then
				if (!self.icon:GetDisabled()) then
					local theme = serverguard.themes.GetCurrent()
					
					self.icon:SetDisabled(true)
					self.icon:SetColor(theme.tiger_base_section_icon)
					self.icon:SetToolTipSG("You do not have permission to view this!")
					
					self.section:SetVisible(false)
				end
			else
				if (self.icon:GetDisabled()) then
					self.icon:SetDisabled(false)
					self.icon:SetToolTipSG(nil)
				end
			end
		end
	end
	
	base.icon = base:Add("DImageButton")
	
	if (self:GetUseSmallPanels()) then
		base.icon:SetPos(16, 14);
	else
		base.icon:SetPos(32, 20);
	end;

	base.icon:SetImage(material)
	
	if (self:GetUseSmallPanels()) then
		base.icon:SetSize(32, 32);
	else
		base.icon:SetSize(64, 64);
	end;
	
	function base.icon.DoClick()
		if (IsValid(self.lastSection)) then
			self.lastSection.selected = false
			self.lastSection.section:SetVisible(false)
		end
		
		base.selected = true
		base.section:SetVisible(true)
		base.section:callback()
		
		self.lastSection = base
	end

	base.icon.OnMousePressed = base.icon.DoClick;
	
	self.sectionList:AddPanel(base)

	local section = self:Add("Panel")
	section:Dock(FILL)
	section:SetVisible(false)
	
	section.callback = callback
	base.section = section
	
	section:callback()
	
	self.sections[name] = base;
end

function panel:GetSections()
	return self.sections
end

function panel:SetSectionSelected(uniqueID)
	if (!self.sections[uniqueID]) then
		return;
	end;

	self.sections[uniqueID].icon.DoClick();
end;

function panel:PerformLayout()
	local w, h = self:GetSize()
	
	self.sectionList:SetPos(1, 1)
	self.sectionList:SetSize(((self:GetUseSmallPanels() and 64) or 128), h - ((self:GetFooterEnabled() and 27) or 2))

	self.copyright:SizeToContents()
	self.copyright:SetPos(8, self:GetTall() - (self.copyright:GetTall() + self.copyright:GetTall() / 2))

	self.updatePanel:SetSize(self:GetWide(), 26);
	self.updatePanel:SetPos(0, self:GetTall() - 26);
end

function panel:Rebuild()
	local lastSection;

	if (IsValid(self.lastSection)) then
		lastSection = self.lastSection.name;

		self.lastSection.selected = false
		self.lastSection.section:SetVisible(false)
		self.lastSection.section:Remove();
	end;

	for k, v in pairs(self.sections) do
		if (IsValid(v)) then
			if (IsValid(v.section)) then
				v.section:SetVisible(false);
				v.section:Remove();
			end;

			v:SetVisible(false);
			v:Remove();
		end;
	end;

	self.sectionList:Clear();
	self:SetupSearchPanel();

	self.sectionList:AddPanel(self.searchPanel);

	for k, data in util.SortedPairsByMemberValue(serverguard.menu:GetStored(), "name") do
		if (data.permissions != nil) then
			if (serverguard.player:HasPermission(LocalPlayer(), data.permissions)) then
				self:AddSection(data.name, data.material, function(base)
					if (base.created) then
						data:Update(base);
					else
						data:Create(base);
						data:Update(base);
						for v, data_s in util.SortedPairsByMemberValue(serverguard.menu:GetStored()[data.name].submenus, "name") do
							base.base:AddSection(data_s.name, data_s.material, function(categoryBase)
								if (categoryBase.created) then
									data_s:Update(categoryBase);
								else
									data_s:Create(categoryBase);
									data_s:Update(categoryBase);
									categoryBase.created = true;
								end
							end);
						end;
						base.created = true;
					end
				end, data.flag);
			end;
		else
			self:AddSection(data.name, data.material, function(base)
				if (base.created) then
					data:Update(base);
				else
					data:Create(base);
					data:Update(base);
					for v, data_s in util.SortedPairsByMemberValue(serverguard.menu:GetStored()[data.name].submenus, "name") do
						if (data_s.permissions == nil or serverguard.player:HasPermission(LocalPlayer(), data_s.permissions)) then
							base.base:AddSection(data_s.name, data_s.material, function(categoryBase)
								if (categoryBase.created) then
									data_s:Update(categoryBase);
								else
									data_s:Create(categoryBase);
									data_s:Update(categoryBase);
									categoryBase.created = true;
								end
							end);
						end
					end;
					base.created = true;
				end;
			end, data.flag);
		end;
	end;

	self:InvalidateLayout(true);
	self:ResetSearch();

	if (lastSection) then
		self:SetSectionSelected(lastSection);
	end;
end;

function panel:Think()
	local mousex = math.Clamp( gui.MouseX(), 1, ScrW()-1 )
	local mousey = math.Clamp( gui.MouseY(), 1, ScrH()-1 )
	
	if (self.Dragging) then
		local x = mousex -self.Dragging[1]
		local y = mousey -self.Dragging[2]
		
		x = math.Clamp(x, 0, ScrW() -self:GetWide())
		y = math.Clamp(y, 0, ScrH() -self:GetTall())
		
		self:SetPos(x, y)
	end
	
	if (self.Hovered) then
		if (gui.MouseY() < self.y +20) then
			self:SetCursor("sizeall")
			
			return
		end
	end
	
	self:SetCursor("arrow")

	if (self:IsVisible()) then
		for k, data in pairs(serverguard.menu:GetStored()) do
			if (data.permissions == nil or serverguard.player:HasPermission(LocalPlayer(), data.permissions)) then
				if (isfunction(data.Think)) then
					data:Think();
				end;
			end;
			for v, data_s in pairs(serverguard.menu:GetStored()[data.name].submenus) do
				if (data_s.permissions == nil or serverguard.player:HasPermission(LocalPlayer(), data_s.permissions)) then
					if (isfunction(data_s.Think)) then
						data_s:Think();
					end;
				end;
			end;
		end;
	end;
end

function panel:OnMousePressed()
	if (gui.MouseY() < self.y +20) then
		self.Dragging = {gui.MouseX() -self.x, gui.MouseY() -self.y}
		
		self:MouseCapture(true)
		
		return
	end
end

function panel:OnMouseReleased()
	self.Dragging = nil
	
	self:MouseCapture(false)
end

function panel:OnCursorEntered()
	self.Hovered = true
end

function panel:OnCursorExited()
	self.Hovered = false
end

function panel:Paint(width, height)
	local theme = serverguard.themes.GetCurrent();

	draw.RoundedBox(4, 0, 0, width, height, theme.tiger_base_outline);
	draw.RoundedBox(2, 1, 1, width - 2, height - 2, theme.tiger_base_bg);

	if (self:GetFooterEnabled()) then
		local footerBG = theme.tiger_base_footer_bg;

		if (self.updateNotify == true) then
			if (self.updateCurrent != self.updateTarget) then
				for k, v in pairs(self.updateCurrent) do
					local animateSpeed = math.abs(self.updateTarget[k] - self.updateCurrent[k]) * FrameTime() + 1;
					self.updateCurrent[k] = math.Approach(self.updateCurrent[k], self.updateTarget[k], animateSpeed);
				end;
			end;

			footerBG = self.updateCurrent;
		elseif (self.updateNotify == false) then
			if (self.updateCurrent != theme.tiger_base_footer_bg[k]) then
				for k, v in pairs(self.updateCurrent) do
					local animateSpeed = math.abs(theme.tiger_base_footer_bg[k] - self.updateCurrent[k]) * FrameTime() + 1;
					self.updateCurrent[k] = math.Approach(self.updateCurrent[k], theme.tiger_base_footer_bg[k], animateSpeed);
				end;
			end;

			footerBG = self.updateCurrent;
		end;

		draw.SimpleRect(2, height - 26, width - 4, 24, footerBG);
		draw.SimpleRect(1, height - 26, width - 2, 1, theme.tiger_base_outline);
	else
		draw.SimpleRect(1, height - 1, width - 2, 1, theme.tiger_base_outline);
	end;
	
	DisableClipping(true);
		for i = 1, 2 do
			local color = Color(0, 0, 0, (255 /i) *0.2);
		
			surface.SetDrawColor(color);
		
			-- Right shadow.
			surface.DrawRect(width - 1 + i, 1, 1, height - 1);
		
			-- Top shadow.
			surface.DrawRect(1, - i, width - 1, 1);
		
			-- Left shadow.
			surface.DrawRect(-i, 0, 1, height);
		
			-- Bottom shadow.
			surface.DrawRect(1, height, width - 1, i);
		end;
	DisableClipping(false);
end;

vgui.Register("tiger.base", panel, "EditablePanel");