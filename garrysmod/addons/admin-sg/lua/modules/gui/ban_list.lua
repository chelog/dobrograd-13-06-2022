--[[
	© 2017 Thriving Ventures Limited do not share, re-distribute or modify
	
	without permission of its author (gustaf@thrivingventures.com).
]]

local loadingTexture = Material("icon16/arrow_rotate_anticlockwise.png");
local category = {};

category.name = "Ban list";
category.material = "serverguard/menuicons/icon_gavel.png";
category.permissions = {"Ban", "Unban"};
category.loading = {
	firstRun = true,
	inProgress = false,
	banTable = {},
	banList = {},
	currentIndex = 1,
	maxIndex = 0,
	reverseLookup = {},
	nextProcessTime = CurTime()
};

function category:Create(base)
	base.panel = base:Add("tiger.panel");
	base.panel:SetTitle("Ban list");
	base.panel:Dock(FILL);
	base.panel:DockPadding(24, 24, 24, 48);

	category.loadingPanel = base.panel:Add("tiger.panel");
	category.loadingPanel:Dock(FILL);
	category.loadingPanel:SetVisible(false);

	function category.loadingPanel:Paint(width, height)
		if (!self.rotation) then
			self.rotation = 0;
		end;

		self.rotation = self.rotation + 140 * FrameTime();

		if (self.rotation > 360) then
			self.rotation = 0;
		end;

		draw.MaterialRotated(width / 2 - 8, height / 2 - 8, 16, 16, color_white, loadingTexture, self.rotation);
	end;
	
	base.panel.list = base.panel:Add("tiger.list");
	base.panel.list:Dock(FILL);
	base.panel.list.sortColumn = 1;

	base.panel.list:AddColumn("PLAYER", 150);
	base.panel.list:AddColumn("STEAMID", 150);
	base.panel.list:AddColumn("LENGTH", 75);
	base.panel.list:AddColumn("ADMIN", 150);
	base.panel.list:AddColumn("REASON", 150);

	hook.Call("serverguard.panel.BanList", nil, base.panel.list);
	
	local refresh = base.panel:Add("tiger.button");
	refresh:SetPos(4, 4);
	refresh:SetText("Refresh");
	refresh:SizeToContents();
	
	function refresh:DoClick()
		RunConsoleCommand("serverguard_rfbans");
	end;
	
	local add_ban = base.panel:Add("tiger.button");
	add_ban:SetPos(4, 4);
	add_ban:SetText("Add ban");
	add_ban:SizeToContents();
	
	function add_ban:DoClick()
		local banLength = nil
		local baseb = vgui.Create("tiger.panel");
		baseb:SetTitle("Add a ban");
		baseb:SetSize(500, 250);
		baseb:Center();
		baseb:MakePopup();
		baseb:DockPadding(24, 24, 24, 48);

		local form = baseb:Add("tiger.list");
		form:Dock(FILL);

		local steamIDEntry = vgui.Create("tiger.textentry");
			steamIDEntry:SetLabelText("Steam ID");
			steamIDEntry:Dock(TOP);
		form:AddPanel(steamIDEntry);

		local banLengthChoice = vgui.Create("tiger.combobox");
		banLengthChoice:SetLabelText("Ban length")
		banLengthChoice:Dock(TOP);

		for k, v in pairs(serverguard.banLengths) do
			banLengthChoice:AddChoice(v[1], v[2]);
		end;

		banLengthChoice:AddChoice("Custom", -1);

		function banLengthChoice:OnSelect(index, value, data)
			if (value == "Custom" and data == -1) then
				util.CreateStringRequest("Ban Length",
					function(text)
						local length, lengthText, bClamped = util.ParseDuration(text);

						banLengthChoice:ChooseOption(lengthText, index);
						banLength = length;
					end, "Okay",
					function(text)
					end, "Cancel"
				);
			else
				banLength = data;
			end;
		end;

		form:AddPanel(banLengthChoice);

		local nameEntry = vgui.Create("tiger.textentry");
			nameEntry:SetLabelText("Name");
			nameEntry:Dock(TOP);
		form:AddPanel(nameEntry);

		local reasonEntry = vgui.Create("tiger.textentry");
			reasonEntry:SetLabelText("Reason");
			reasonEntry:Dock(TOP);
		form:AddPanel(reasonEntry);

		local completeButton = baseb:Add("tiger.button");
		completeButton:SetPos(4, 4);
		completeButton:SetText("Complete");
		completeButton:SizeToContents();

		function completeButton:DoClick()
			if (string.Trim(steamIDEntry:GetValue()) == "") then
				serverguard.Notify(nil, SERVERGUARD.NOTIFY.RED, "Please enter a Steam ID!");
				return;
			end;

			if (!banLength) then 
				serverguard.Notify(nil, SERVERGUARD.NOTIFY.RED, "Please select a valid ban length!");
				return;
			end;

			if (string.Trim(nameEntry:GetValue()) == "") then 
				serverguard.Notify(nil, SERVERGUARD.NOTIFY.RED, "Please enter a name!");
				return;
			end;

			if (string.Trim(reasonEntry:GetValue()) == "") then 
				serverguard.Notify(nil, SERVERGUARD.NOTIFY.RED, "Please enter a reason!");
				return;
			end;
			
			RunConsoleCommand("serverguard_addmban", steamIDEntry:GetValue(), banLength, nameEntry:GetValue(), reasonEntry:GetValue());
			
			baseb:Remove();
		end;

		local cancelButton = baseb:Add("tiger.button");
		cancelButton:SetPos(4, 4);
		cancelButton:SetText("Cancel");
		cancelButton:SizeToContents();
		
		function cancelButton:DoClick()
			baseb:Remove();
		end;
		
		function baseb:PerformLayout(w, h)
			completeButton:SetPos(w - (completeButton:GetWide() + 24), h - (completeButton:GetTall() + 14));
			
			cancelButton:SetPos(0, h - (cancelButton:GetTall() + 14));
			cancelButton:MoveLeftOf(completeButton, 14);
		end;
	end;

	if (serverguard.player:HasPermission(LocalPlayer(), "Unban")) then
		base.panel.unban = base.panel:Add("tiger.button");
		base.panel.unban:SetPos(4, 4);
		base.panel.unban:SetText("Unban Steam ID");
		base.panel.unban:SizeToContents();

		function base.panel.unban:DoClick()
			local unbanPanel = vgui.Create("tiger.panel");
			unbanPanel:SetTitle("Unban Steam ID");
			unbanPanel:SetSize(300, 150);
			unbanPanel:Center();
			unbanPanel:MakePopup();
			unbanPanel:DockPadding(24, 24, 24, 48);

			local steamIDEntry = unbanPanel:Add("DTextEntry");
			steamIDEntry:SetTall(20);
			steamIDEntry:SetSkin("serverguard");
			steamIDEntry:Dock(TOP);

			local unbanButton = unbanPanel:Add("tiger.button");
			unbanButton:SetPos(4, 4);
			unbanButton:SetText("Unban");
			unbanButton:SizeToContents();

			function unbanButton:DoClick()
				if (string.Trim(steamIDEntry:GetValue()) == "") then
					serverguard.Notify(nil, SERVERGUARD.NOTIFY.RED, "Please enter a Steam ID!");
					return;
				end;
				
				serverguard.command.Run("unban", false, steamIDEntry:GetValue());
				unbanPanel:Remove();
			end;

			local cancelButton = unbanPanel:Add("tiger.button");
			cancelButton:SetPos(4, 4);
			cancelButton:SetText("Cancel");
			cancelButton:SizeToContents();
			
			function cancelButton:DoClick()
				unbanPanel:Remove();
			end;
			
			function unbanPanel:PerformLayout(w, h)
				unbanButton:SetPos(w - (unbanButton:GetWide() + 24), h - (unbanButton:GetTall() + 14));
				
				cancelButton:SetPos(0, h - (cancelButton:GetTall() + 14));
				cancelButton:MoveLeftOf(unbanButton, 14);
			end;
		end;
	end;
	
	category.statusLabel = base.panel:Add("DLabel");
	category.statusLabel:SetFont("tiger.button");
	category.statusLabel:SetText("");
	category.statusLabel:SetSkin("serverguard");
	
	function base.panel:PerformLayout()
		local w, h = self:GetSize();
		
		refresh:SetPos(w - (refresh:GetWide() + 24), h - (refresh:GetTall() + 14));
		
		add_ban:SetPos(0, h - (add_ban:GetTall() + 14));
		add_ban:MoveLeftOf(refresh, 14);

		if (IsValid(base.panel.unban)) then
			base.panel.unban:SetPos(0, h - (base.panel.unban:GetTall() + 14));
			base.panel.unban:MoveLeftOf(add_ban, 14);
		end;
		
		category.statusLabel:SetPos(25, h - (category.statusLabel:GetTall() + 18));
	end;
	
	category.list = base.panel.list;
end;

function category:Update(base)
	if (self.loading.firstRun) then
		RunConsoleCommand("serverguard_rfbans");

		self.loading.firstRun = nil;
	end;
end;

function category:SetLoading(value)
	value = tobool(value);

	self.loadingPanel:SetVisible(value);
	self.list:SetVisible(!value);
end;

local expectedBans = 0;

function category:Think(base)
	if (!category.loading.inProgress or CurTime() < category.loading.nextProcessTime) then
		return;
	end;
	
	for i = category.loading.currentIndex, math.min(category.loading.maxIndex, category.loading.currentIndex + 4) do
		if (i == category.loading.maxIndex) then
			category.statusLabel:SetText("Total banned players: " .. expectedBans);
			category.statusLabel:SizeToContents();

			category.loading.inProgress = false;
			--category.loading.banList = {};

			category:SetLoading(false);
		else
			category.statusLabel:SetText("Processing ban data... (" .. math.Round((i / expectedBans) * 100) .. "%)");
			category.statusLabel:SizeToContents();

			category.loading.currentIndex = i + 1;
			category.loading.nextProcessTime = CurTime() + 0.01;
		end;
		if (!category.loading.banList[i]) then
			continue;
		end;

		local data = category.loading.banList[i];
		local steamID = data.steamID;
		local name = data.playerName;
		local length = tonumber(data.length);
		local reason = string.gsub(data.reason, "\n", " ");
		local admin = data.admin;
		
		category.loading.reverseLookup[steamID] = i

		if (!name or name == "") then
			name = "Unknown";
		end;

		local lengthText = "";

		if (length <= 0) then
			lengthText = "Forever";
		else
			local hours = math.Round(length / 3600);

			if (hours >= 1) then
				lengthText = hours .. " hour(s)";
			else
				lengthText = math.Round(length / 60) .. " minute(s)";
			end;
		end;

		if (IsValid(category.list)) then
			local panel = category.list:AddItem(name, steamID, lengthText, admin, reason);
			
			panel:SetToolTipSG(reason);
			
			function panel:OnMousePressed()
				if (serverguard.player:HasPermission(LocalPlayer(), "Unban")) then
					local menu = DermaMenu();
						menu:SetSkin("serverguard");
						
						menu:AddOption(string.format("Unban %s", name), function()
							serverguard.command.Run("unban", false, steamID);
						end);
						
						if (serverguard.player:HasPermission(LocalPlayer(), "Edit Ban")) then
							menu:AddOption(string.format("Edit Ban", name), function()
								local banLength = nil
								local baseb = vgui.Create("tiger.panel");
								baseb:SetTitle(string.format("Edit Ban", name));
								baseb:SetSize(500, 185);
								baseb:Center();
								baseb:MakePopup();
								baseb:DockPadding(24, 24, 24, 48);

								local form = baseb:Add("tiger.list");
								form:Dock(FILL);
								local banLengthChoice = vgui.Create("tiger.combobox");
								banLengthChoice:SetLabelText("New Ban length")
								banLengthChoice:Dock(TOP);

								for k, v in pairs(serverguard.banLengths) do
									banLengthChoice:AddChoice(v[1], v[2]);
								end;

								banLengthChoice:AddChoice("Custom", -1);

								function banLengthChoice:OnSelect(index, value, data)
									if (value == "Custom" and data == -1) then
										util.CreateStringRequest("Ban Length",
											function(text)
												local length, lengthText, bClamped = util.ParseDuration(text);

												banLengthChoice:ChooseOption(lengthText, index);
												banLength = length;
											end, "Okay",
											function(text)
											end, "Cancel"
										);
									else
										banLength = data;
									end;
								end;

								form:AddPanel(banLengthChoice);

								local reasonEntry = vgui.Create("tiger.textentry");
									reasonEntry:SetLabelText("Reason");
									reasonEntry:SetText(reason);
									reasonEntry:Dock(TOP);
								form:AddPanel(reasonEntry);

								local completeButton = baseb:Add("tiger.button");
								completeButton:SetPos(4, 4);
								completeButton:SetText("Complete");
								completeButton:SizeToContents();

								function completeButton:DoClick()
									if (!banLength) then 
										serverguard.Notify(nil, SERVERGUARD.NOTIFY.RED, "Please select a valid ban length!");
										return;
									end;

									if (string.Trim(reasonEntry:GetValue()) == "") then 
										serverguard.Notify(nil, SERVERGUARD.NOTIFY.RED, "Please enter a reason!");
										return;
									end;
									
									RunConsoleCommand("serverguard_editban", steamID, banLength, name, reasonEntry:GetValue());
									
									baseb:Remove();
								end;

								local cancelButton = baseb:Add("tiger.button");
								cancelButton:SetPos(4, 4);
								cancelButton:SetText("Cancel");
								cancelButton:SizeToContents();
								
								function cancelButton:DoClick()
									baseb:Remove();
								end;
								
								function baseb:PerformLayout(w, h)
									completeButton:SetPos(w - (completeButton:GetWide() + 24), h - (completeButton:GetTall() + 14));
									
									cancelButton:SetPos(0, h - (cancelButton:GetTall() + 14));
									cancelButton:MoveLeftOf(completeButton, 14);
								end;
							end);	
						end
						
						menu:AddOption("Copy Steam ID", function()
							SetClipboardText(steamID);
						end)

						hook.Call("serverguard.panel.PlayerUnbanContext", nil, menu, name, steamID, admin, reason);
					menu:Open();
				end;
			end;

		end;
	end;
end;

serverguard.menu.AddSubCategory("Lists", category);

serverguard.netstream.Hook("sgGetBanCount", function(data)
	expectedBans = data;

	if (IsValid(category.statusLabel)) then
		if (expectedBans == 0) then
			category.statusLabel:SetText("Total banned players: " .. expectedBans);
			category.statusLabel:SizeToContents();
		else
			category.statusLabel:SetText("Receiving ban data...");
			category.statusLabel:SizeToContents();
		end;
	end;
end);
serverguard.netstream.Hook("sgRemoveBan", function(data)
	expectedBans = expectedBans - 1
	category.loading.banList[category.loading.reverseLookup[data] or 0] = nil
	if (IsValid(category.list)) then
		category.list:SetVisible(false)
		category.list:Clear()
	end
	if (category.loading) then
		category.loading.inProgress = true;
		category.loading.currentIndex = 1;
		category.loading.nextProcessTime = CurTime();
	end
end)

serverguard.netstream.Hook("sgNewBan", function(data)
	expectedBans = expectedBans + 1
	category.loading.maxIndex = category.loading.maxIndex + 1;
	category.loading.banList[category.loading.maxIndex] = data;
	if (IsValid(category.list)) then
		category.list:SetVisible(false)
		category.list:Clear()
	end
	if (category.loading) then
		category.loading.inProgress = true;
		category.loading.currentIndex = 1;
		category.loading.nextProcessTime = CurTime();
	end
end)

serverguard.netstream.Hook("sgGetBanListChunk", function(banList)
	if (IsValid(category.list)) then
		category.list:SetVisible(false); -- doing this before removing plays nicer with tooltips
		category.list:Clear();
	end;

	if (category.loading) then
		category:SetLoading(true);

		category.loading.inProgress = true;
		category.loading.currentIndex = 1;
		category.loading.banList = banList
		category.loading.maxIndex = #category.loading.banList
		category.loading.nextProcessTime = CurTime();
		category.loading.reverseLookup = {}
	end;
end);

hook.Add("serverguard.menu.Close", "serverguard.BanList", function()
	if (IsValid(category.list)) then
		for k, v in ipairs(category.list:GetCanvas():GetChildren()) do
			if (IsValid(v.tooltip_sg)) then
				v:OnCursorExited();
			end;
		end;
	end;
end);