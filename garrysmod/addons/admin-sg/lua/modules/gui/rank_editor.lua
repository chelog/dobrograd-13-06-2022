--[[
	© 2017 Thriving Ventures Limited do not share, re-distribute or modify

	without permission of its author (gustaf@thrivingventures.com).
]]

local category = {}

category.name = "Rank editor"
category.material = "serverguard/menuicons/icon_editranks.png"
category.permissions = "Edit Ranks"

function category:Create(base)
	base.panel = base:Add("tiger.panel")
	base.panel:SetTitle("Edit or create ranks")
	base.panel:Dock(FILL)

	hook.Add("serverguard.ranks.RankUpdate", "serverguard.gui.ranks.RankUpdate", function()
		if (IsValid(base.panel)) then
			category:Update(base)
		end
	end)

	base.panel.list = base.panel:Add("tiger.list")
	base.panel.list:Dock(FILL)
	base.panel.list:DockMargin(0, 54, 0, 0)

	base.panel.list:AddColumn("UNIQUE", 150)
	base.panel.list:AddColumn("NAME", 150)
	base.panel.list:AddColumn("IMMUNITY", 90)
	base.panel.list:AddColumn("TARGETABLE", 90)
	base.panel.list:AddColumn("BANLIMIT", 110)

	hook.Call("serverguard.panel.RankEditorList", nil, base.panel.list);

	local column = base.panel.list:AddColumn("IMAGE", 35)
	column:SetDisabled(true)

	local ranks = serverguard.ranks:GetTable()

	local button = base.panel:Add("tiger.button")
	button:SetPos(24, 74)
	button:SetText("Create new rank")
	button:SizeToContents()

	local combo = base.panel:Add("tiger.combobox")
	combo:SetPos(160, 70)
	combo:SetSize(150, 30)
	combo:SetLabelText("Copy from")
	combo:AddChoice("<none>", nil, true)
	for k, v in SortedPairsByMemberValue(ranks, "immunity", true) do
		combo:AddChoice(v.name, v)
	end

	function button:DoClick()
		local menu = vgui.Create("tiger.panel")
		menu:SetTitle("Rank options")
		menu:SetSize(650, ScrH() * 0.9)
		menu:Center()
		menu:MakePopup()

		local list = menu:Add("tiger.list")
		list:Dock(FILL)
		list:GetCanvas():DockPadding(14, 14, 14, 14)

		local _, copyFrom = combo:GetSelected()

		local uniqueEntry = vgui.Create("tiger.textentry");
			uniqueEntry:SetLabelText("Unique name");
			uniqueEntry:Dock(TOP);
		list:AddPanel(uniqueEntry);

		local nameEntry = vgui.Create("tiger.textentry");
			nameEntry:SetLabelText("Fancy name");
			nameEntry:Dock(TOP);
			if copyFrom then nameEntry:SetValue(copyFrom.name) end
		list:AddPanel(nameEntry);

		local immunityEntry = vgui.Create("tiger.textentry");
			immunityEntry:SetLabelText("Immunity level");
			immunityEntry:Dock(TOP);
			immunityEntry:SetNumeric(true);
			if copyFrom then immunityEntry:SetValue(copyFrom.immunity) end
		list:AddPanel(immunityEntry);

		local targetableEntry = vgui.Create("tiger.textentry");
			targetableEntry:SetLabelText("Targetable rank");
			targetableEntry:Dock(TOP);
			targetableEntry:SetNumeric(true);
			if copyFrom then targetableEntry:SetValue(copyFrom.targetable) end
		list:AddPanel(targetableEntry);

		local banlimitEntry = vgui.Create("tiger.textentry");
			banlimitEntry:SetLabelText("Maximum Ban Length (Example: 1y2w2d)");
			banlimitEntry:Dock(TOP);
			if copyFrom then banlimitEntry:SetValue(copyFrom.banlimit) end
		list:AddPanel(banlimitEntry);

		local label = vgui.Create("DLabel")
		label:SetText("Rank color:")
		label:SizeToContents()
		label:Dock(TOP)
		label:DockMargin(0, 18, 0, 0)
		label:SetSkin("serverguard")

		list:AddPanel(label)

		local colorSlider = vgui.Create("DColorMixer")
		colorSlider:Dock(TOP)
		colorSlider:DockMargin(0, 14, 0, 14)
		if copyFrom then colorSlider:SetColor(copyFrom.color) end

		list:AddPanel(colorSlider)

		local label = vgui.Create("DLabel")
		label:SetText("Physgun color:")
		label:SizeToContents()
		label:Dock(TOP)
		label:DockMargin(0, 18, 0, 0)
		label:SetSkin("serverguard")

		list:AddPanel(label)

		local colorSliderPhys = vgui.Create("DColorMixer")
		colorSliderPhys:Dock(TOP)
		colorSliderPhys:DockMargin(0, 14, 0, 14)
		if copyFrom then colorSliderPhys:SetColor(copyFrom.data.phys_color) end

		list:AddPanel(colorSliderPhys)

		local label = vgui.Create("DLabel")
		label:SetText("Rank image:")
		label:SizeToContents()
		label:Dock(TOP)
		label:DockMargin(0, 8, 0, 0)
		label:SetSkin("serverguard")

		list:AddPanel(label)

		local image = ""
		local textureList = vgui.Create("tiger.list")
		textureList:Dock(TOP)
		textureList:DockMargin(0, 14, 0, 14)
		textureList:GetCanvas():DockPadding(4, 4, 4, 4)
		textureList:SetTall(16 *12)

		local images = file.Find("materials/octoteam/icons-16/*.png", "GAME")
		local width = 0

		local basea = vgui.Create("Panel")
		basea:SetTall(16)
		basea:Dock(TOP)
		basea:DockMargin(0, 0, 0, 8)

		textureList:AddPanel(basea)

		local lastSelected

		for k, v in pairs(images) do
			local icon = basea:Add("DImageButton")
			icon:Dock(LEFT)
			icon:DockMargin(2, 0, 2, 0)
			icon:SetImage("materials/octoteam/icons-16/" .. v)
			icon:SetSize(16, 16)

			function icon:DoClick()
				image = "materials/octoteam/icons-16/" .. v

				if (IsValid(lastSelected)) then
					lastSelected.selected = nil
				end

				lastSelected = self
			end

			if copyFrom and copyFrom.texture:sub(18) == v then
				icon:DoClick()
				image = "materials/octoteam/icons-16/" .. v
			end

			function icon:PaintOver(w, h)
				if (lastSelected == self) then
					draw.SimpleOutlined(0, 0, w, h, color_red)
				end
			end

			width = width +16

			if (width > 16 *27) then
				basea = vgui.Create("Panel")
				basea:SetTall(16)
				basea:Dock(TOP)
				basea:DockMargin(0, 0, 0, 8)

				textureList:AddPanel(basea)

				width = 0
			end
		end

		list:AddPanel(textureList)

		local label = vgui.Create("DLabel");
		label:SetText("Rank permissions:");
		label:SizeToContents();
		label:Dock(TOP);
		label:DockMargin(0, 8, 0, 0);
		label:SetSkin("serverguard");

		list:AddPanel(label)

		local permissionList = vgui.Create("tiger.list");
		permissionList:Dock(TOP);
		permissionList:DockMargin(0, 14, 0, 14);
		permissionList:SetTall(16 * 16);

		list:AddPanel(permissionList);

		local appliedPermissions = {};

		for k, v in SortedPairs(serverguard.permission:GetAll()) do
			local entry = vgui.Create("tiger.checkbox");
			permissionList:AddPanel(entry);
			entry:Dock(TOP);
			entry:SetText(k);

			function entry:OnChange(value)
				appliedPermissions[k] = value;
			end;

			if copyFrom then
				local val = copyFrom.data.Permissions and copyFrom.data.Permissions[k]
				entry:SetChecked(val)
				appliedPermissions[k] = val
			end
		end;

		hook.Call("serverguard.panel.RankEditorCreationMenu", nil, list, copyFrom);

		local comleteBase = vgui.Create("Panel")
		comleteBase:Dock(TOP)
		comleteBase:DockMargin(0, 0, 0, 14)
		comleteBase:SetTall(20)

		local complete = comleteBase:Add("tiger.button")
		complete:Dock(RIGHT)
		complete:SetText("Complete")
		complete:SizeToContents()

		function complete:DoClick()
			local color = colorSlider:GetColor()
			local phys_color = colorSliderPhys:GetColor()

			local dataTable = copyFrom and copyFrom.data or {};
			dataTable["phys_color"] = phys_color;
			hook.Call("serverguard.panel.RankEditorCreationPopulate", nil, dataTable);

			serverguard.netstream.Start("sgNewRank", {
				uniqueEntry:GetValue(),
				nameEntry:GetValue(),
				tonumber(immunityEntry:GetValue()),
				color,
				image,
				appliedPermissions,
				dataTable,
				tonumber(targetableEntry:GetValue()),
				util.ParseDuration(banlimitEntry:GetValue()),
			});

			menu:Remove()
		end

		local cancel = comleteBase:Add("tiger.button")
		cancel:Dock(RIGHT)
		cancel:DockMargin(0, 0, 8, 0)
		cancel:SetText("Cancel")
		cancel:SizeToContents()

		function cancel:DoClick()
			menu:Remove()
		end

		list:AddPanel(comleteBase)
	end
end

function category:Update(base)
	base.panel.list:Clear()

	local ranks = serverguard.ranks:GetTable()


	for unique, data in pairs(ranks) do

		local limit, limitText = util.ParseDuration(data.banlimit)
		local panel = base.panel.list:AddItem(unique, data.name, data.immunity, data.targetable, limitText)

		function panel:OnMousePressed()
			local menu = DermaMenu()
				menu:SetSkin("serverguard");

				local option = menu:AddOption("Change name", function()
					Derma_StringRequest("Rank options",  "Change rank name", data.name,
						function(text)
							serverguard.netstream.Start("sgChangeRankInfo", {
								unique, "name", SERVERGUARD.NETWORK.STRING, text
							});
						end,

						function(text) end,
						"Accept",
						"Cancel"
					)
				end)

				option:SetImage("icon16/book_edit.png")

				local option = menu:AddOption("Change immunity", function()
					Derma_StringRequest("Rank options",  "Change rank immunity", data.immunity,
						function(text)
							serverguard.netstream.Start("sgChangeRankInfo", {
								unique, "immunity", SERVERGUARD.NETWORK.NUMBER, tonumber(text)
							});
						end,

						function(text) end,
						"Accept",
						"Cancel"
					)
				end)

				option:SetImage("icon16/shield.png")


				local option = menu:AddOption("Change targetable rank", function()
					Derma_StringRequest("Rank options",  "Change rank's targetable rank", data.targetable,
						function(text)
							serverguard.netstream.Start("sgChangeRankInfo", {
								unique, "targetable", SERVERGUARD.NETWORK.NUMBER, tonumber(text)
							});
						end,

						function(text) end,
						"Accept",
						"Cancel"
					)
				end)

				option:SetImage("icon16/shield.png")

				local option = menu:AddOption("Change maximum ban length", function()
					Derma_StringRequest("Rank options",  "Change maximum ban length (Example: 1y2w2d) ", data.banlimit,
						function(text)
							serverguard.netstream.Start("sgChangeRankInfo", {
								unique, "banlimit", SERVERGUARD.NETWORK.NUMBER, util.ParseDuration(text)
							});
						end,

						function(text) end,
						"Accept",
						"Cancel"
					)
				end)

				option:SetImage("icon16/shield.png")


				local option = menu:AddOption("Change permissions", function()
					if (unique == "founder") then
						serverguard.Notify(nil, SERVERGUARD.NOTIFY.RED, "You cannot change the permissions of the founder rank - it's already granted all permissions!");
						return;
					end;

					local permissionPanel = vgui.Create("tiger.panel");
					permissionPanel:SetTitle("Change rank permissions");
					permissionPanel:SetSize(500, 640);
					permissionPanel:Center();
					permissionPanel:MakePopup();
					permissionPanel:DockPadding(24, 24, 24, 48);

					local permissionList = permissionPanel:Add("tiger.list");
					permissionList:Dock(FILL);
					permissionList:DockMargin(0, 0, 0, 14);

					local rankPermissions = serverguard.ranks:GetData(unique, "Permissions", {});
					local permissions = serverguard.permission:GetAll();

					for k, v in SortedPairs(permissions) do
						local entry = vgui.Create("tiger.checkbox");
						permissionList:AddPanel(entry);
						entry:Dock(TOP);
						entry:SetText(k);
						entry:SetChecked(rankPermissions[k] or false);

						function entry:OnChange(value)
							permissions[k] = value;
						end;

						permissions[k] = rankPermissions[k] or false;
					end;

					local complete = permissionPanel:Add("tiger.button");
					complete:SetPos(4, 4);
					complete:SetText("Complete");
					complete:SizeToContents();

					function complete:DoClick()
						serverguard.netstream.Start("sgChangeRankData", {
							unique, "Permissions", permissions
						});

						permissionPanel:Remove();
					end

					local cancel = permissionPanel:Add("tiger.button")
					cancel:SetPos(4, 4)
					cancel:SetText("Cancel")
					cancel:SizeToContents()

					function cancel:DoClick()
						permissionPanel:Remove()
					end

					function permissionPanel:PerformLayout()
						local w, h = self:GetSize();

						complete:SetPos(w - (complete:GetWide() + 24), h - (complete:GetTall() + 14));

						cancel:SetPos(0, h - (cancel:GetTall() + 14));
						cancel:MoveLeftOf(complete, 14);
					end;
				end);

				option:SetImage("icon16/lock.png");

				local option = menu:AddOption("Change color", function()
				local baseb = vgui.Create("tiger.panel")
					baseb:SetTitle("Select rank color")
					baseb:SetSize(500, 500)
					baseb:Center()
					baseb:MakePopup()
					baseb:DockPadding(24, 24, 24, 48)

					local label = baseb:Add("DLabel")
					label:SetText(data.name)
					label:SetColor(data.color)
					label:SetFont("tiger.list.text")
					label:Dock(TOP)
					label:DockMargin(0, 0, 0, 14)

					local colorMixer = baseb:Add("DColorMixer")
					colorMixer:Dock(FILL)
					colorMixer:SetColor(data.color)

					function colorMixer:ValueChanged(color)
						label:SetColor(color)
					end

					local complete = baseb:Add("tiger.button")
					complete:SetPos(4, 4)
					complete:SetText("Complete")
					complete:SizeToContents()

					function complete:DoClick()
						local color = colorMixer:GetColor();

						serverguard.netstream.Start("sgChangeRankInfo", {
							unique, "color", SERVERGUARD.NETWORK.COLOR, color
						});

						baseb:Remove()
					end

					local cancel = baseb:Add("tiger.button")
					cancel:SetPos(4, 4)
					cancel:SetText("Cancel")
					cancel:SizeToContents()

					function cancel:DoClick()
						baseb:Remove()
					end

					function baseb:PerformLayout()
						local w, h = self:GetSize()

						complete:SetPos(w -(complete:GetWide() +24), h -(complete:GetTall() +14))

						cancel:SetPos(0, h -(cancel:GetTall() +14))
						cancel:MoveLeftOf(complete, 14)
					end
				end)

				option:SetImage("icon16/color_wheel.png")

				local option = menu:AddOption("Change physgun color", function()
				local baseb = vgui.Create("tiger.panel")
					baseb:SetTitle("Select physgun color")
					baseb:SetSize(500, 500)
					baseb:Center()
					baseb:MakePopup()
					baseb:DockPadding(24, 24, 24, 48)

					local colorMixer = baseb:Add("DColorMixer")
					colorMixer:Dock(FILL)
					colorMixer:SetColor(data.data.phys_color or Color(77, 255, 255))

					local complete = baseb:Add("tiger.button")
					complete:SetPos(4, 4)
					complete:SetText("Complete")
					complete:SizeToContents()

					function complete:DoClick()
						local color = colorMixer:GetColor();

						serverguard.netstream.Start("sgChangeRankData", {
							unique, "phys_color", color
						});

						baseb:Remove()
					end

					local cancel = baseb:Add("tiger.button")
					cancel:SetPos(4, 4)
					cancel:SetText("Cancel")
					cancel:SizeToContents()

					function cancel:DoClick()
						baseb:Remove()
					end

					function baseb:PerformLayout()
						local w, h = self:GetSize()

						complete:SetPos(w -(complete:GetWide() +24), h -(complete:GetTall() +14))

						cancel:SetPos(0, h -(cancel:GetTall() +14))
						cancel:MoveLeftOf(complete, 14)
					end
				end)

				option:SetImage("icon16/color_wheel.png")

				local option = menu:AddOption("Change image", function()
					local baseb = vgui.Create("tiger.panel")
					baseb:SetTitle("Select rank image")
					baseb:SetSize(500, 500)
					baseb:Center()
					baseb:MakePopup()
					baseb:DockPadding(24, 24, 24, 48)

					local textureList = baseb:Add("tiger.list")
					textureList:Dock(FILL)
					textureList:DockMargin(0, 14, 0, 14)
					textureList:GetCanvas():DockPadding(4, 4, 4, 4)

					local width = 0
					local image = "materials/octoteam/icons-16/user.png"
					local images = file.Find("materials/octoteam/icons-16/*.png", "GAME")
					local basea = vgui.Create("Panel")
					basea:SetTall(16)
					basea:Dock(TOP)
					basea:DockMargin(0, 0, 0, 8)

					textureList:AddPanel(basea)

					local lastSelected

					for k, v in pairs(images) do
						local icon = basea:Add("DImageButton");
						icon:Dock(LEFT);
						icon:DockMargin(2, 0, 2, 0);
						icon:SetImage("octoteam/icons-16/"..v);
						icon:SetSize(16, 16);

						if (data.texture == icon:GetImage()) then
							lastSelected = icon;
						end;

						function icon:DoClick()
							image = "octoteam/icons-16/"..v;

							if (IsValid(lastSelected)) then
								lastSelected.selected = nil;
							end;

							lastSelected = self;
						end;

						function icon:PaintOver(w, h)
							if (lastSelected == self) then
								draw.SimpleOutlined(0, 0, w, h, color_red);
							end;
						end;

						width = width +16

						if (width > 16 *22) then
							basea = vgui.Create("Panel")
							basea:SetTall(16)
							basea:Dock(TOP)
							basea:DockMargin(0, 0, 0, 8)

							textureList:AddPanel(basea)

							width = 0
						end;
					end;

					local complete = baseb:Add("tiger.button")
					complete:SetPos(4, 4)
					complete:SetText("Complete")
					complete:SizeToContents()

					function complete:DoClick()
						if (image != "") then
							serverguard.netstream.Start("sgChangeRankInfo", {
								unique, "texture", SERVERGUARD.NETWORK.STRING, image
							});
						end

						baseb:Remove()
					end

					local cancel = baseb:Add("tiger.button")
					cancel:SetPos(4, 4)
					cancel:SetText("Cancel")
					cancel:SizeToContents()

					function cancel:DoClick()
						baseb:Remove()
					end

					function baseb:PerformLayout()
						local w, h = self:GetSize()

						complete:SetPos(w -(complete:GetWide() +24), h -(complete:GetTall() +14))

						cancel:SetPos(0, h -(cancel:GetTall() +14))
						cancel:MoveLeftOf(complete, 14)
					end
				end)

				option:SetImage("icon16/image_edit.png")

				hook.Call("serverguard.panel.RankEditorContext", nil, menu, unique, data, category, base);

				local option = menu:AddOption("Remove rank", function()
					util.CreateDialog("Notice", "Are you sure you want to delete this rank?",
						function()
							serverguard.netstream.Start("sgRemoveRank", unique);
						end, "&Yes",
						function()
						end, "No"
					)
				end)

				option:SetImage("icon16/delete.png")
			menu:Open()
		end

		local rankLabel = panel:GetLabel(2);
		rankLabel:SetColor(data.color);
		rankLabel.oldColor = data.color;

		panel.icon = vgui.Create("DImageButton");
		panel.icon:SetImage((data.texture != "" and data.texture or "icon16/user.png"));
		panel.icon:SetSize(16, 16);

		function panel.icon:PerformLayout()
			DImageButton.PerformLayout(self)

			local column = panel:GetThing(6).column;
			local x = column:GetPos()

			self:SetPos(x +column:GetWide() /2 -8, column:GetTall() /2 -8)
		end

		panel:AddItem(panel.icon);

	end
end

serverguard.menu.AddCategory(category)