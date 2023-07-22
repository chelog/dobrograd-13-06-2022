--[[
	© 2017 Thriving Ventures Limited do not share, re-distribute or modify
	without permission of its author (gustaf@thrivingventures.com).
]]

local category = {}

category.name = "Rank list"
category.material = "serverguard/menuicons/icon_rank_list.png"
category.permissions = {"Set Rank", "Edit Ranks"}

function category:Create(base)
	base.panel = base:Add("tiger.panel")
	base.panel:SetTitle("Rank list")
	base.panel:Dock(FILL)
	base.panel:DockPadding(24, 24, 24, 48)

	base.panel.list = base.panel:Add("tiger.list")
	base.panel.list:Dock(FILL)
	base.panel.list.sortColumn = 3

	base.panel.list:AddColumn("PLAYER", 175)
	base.panel.list:AddColumn("STEAMID", 175)
	base.panel.list:AddColumn("RANK", 75)
	base.panel.list:AddColumn("EXPIRES IN", 75)
	base.panel.list:AddColumn("LAST PLAYED", 75)

	hook.Call("serverguard.panel.RankList", nil, base.panel.list);

	local refresh = base.panel:Add("tiger.button")
	refresh:SetPos(4, 4)
	refresh:SetText("Refresh")
	refresh:SizeToContents()

	function refresh:DoClick()
		base.panel.list:Clear()

		serverguard.netstream.Start("sgRequestPlayerRanks", true);
	end

	base.panel.list.nextUpdate = CurTime() + 1

	function base.panel.list:Think()
		if (self.nextUpdate and self.nextUpdate <= CurTime()) then
			refresh:DoClick()

			self.nextUpdate = nil
		end
	end

	function base.panel:PerformLayout()
		local w, h = self:GetSize()

		refresh:SetPos(w -(refresh:GetWide() +24), h -(refresh:GetTall() +14))
	end

	category.list = base.panel.list
end

function category:Update(base)
end

serverguard.menu.AddSubCategory("Lists", category)

serverguard.netstream.Hook("sgGetRankList", function(data)
	local steamid = data[1];
	local rank = data[2];
	local name = data[3];
	local expires_in = data[4];
	local last_played = data[5];

	if (rank and rank == "user") then return; end;

	local rankData = serverguard.ranks:GetRank(rank);

	local rankName = "";

	if (!rankData) then
		rankName = "Unknown rank (REMOVED)";
	else
		rankName = rankData.name;
	end;

	local function formatDate(time)
		local format_time = "never"

		if (isnumber(time)) and time > 0 then
			local time = {
				sec = time % 60,
				min = math.floor(time/60) % 60,
				hour = math.floor(time/3600) % 24,
				day = math.floor(time/86400) % 7,
				week = math.floor(time/604800) % 4,
				month = math.floor(time/2592000) % 12,
				year = math.floor(time/31536000),
			}

			format_time = (time.year > 0 and (time.year .. "y - " .. time.month .. "mo") or time.month > 0 and (time.month .. "mo - " .. time.day .. "d") or time.day > 0 and (time.day .. "d - " .. time.hour .. "h") or time.hour > 0 and (time.hour .. "h - " .. time.min .. "m") or time.min > 0 and (time.min .. "m - " .. time.sec .. "s") or (time.sec .. "s"));
		end

		return format_time
	end


	local panel = category.list:AddItem(name, steamid, rankName, ((isnumber(expires_in) and expires_in <= 0) and "expired") or formatDate(expires_in) or ((expires_in == "never") and "never") or "Unknown", player.GetBySteamID(steamid) and "online" or (formatDate(os.time(last_played)) .. " ago"));

	panel.steamid = steamid;

	function panel:OnMousePressed()
		local menu = DermaMenu();
			menu:SetSkin("serverguard");

			local rankMenu, menuOption = menu:AddSubMenu("Change Rank");

			rankMenu:SetSkin("serverguard");
			menuOption:SetImage("icon16/award_star_add.png");

			local sorted = {};

			for k, v in pairs(serverguard.ranks:GetTable()) do
				table.insert(sorted, v);
			end;

			table.sort(sorted, function(a, b)
				return a.immunity > b.immunity;
			end);

			for _, data in pairs(sorted) do
				local timeMenu, menuRank = rankMenu:AddSubMenu(data.name);
				local option = timeMenu:AddOption("Indefinitely", function()
					serverguard.netstream.Start("sgChangePlayerRank", {
						self.steamid, data.unique, 0
					});

					category.list.nextUpdate = CurTime() + 1;
				end);
				option:SetImage("icon16/clock.png");

				local option = timeMenu:AddOption("Custom", function()
					Derma_StringRequest("Rank Length", "Specify the time after which this rank will expire (in minutes).", "", function(length)
						serverguard.netstream.Start("sgChangePlayerRank", {
							self.steamid, data.unique, tonumber(length)
						});
					end, function(text) end, "Accept", "Cancel");
				end);
				option:SetImage("icon16/clock.png");

				if (data.texture and data.texture != "") then
					menuRank:SetImage(data.texture);
				end;
			end;
		menu:Open();
	end;

	if (rankData) then
		local rankLabel = panel:GetLabel(3);
			rankLabel:SetColor(rankData.color);
			rankLabel:SetSort(rankData.immunity);
		rankLabel.oldColor = rankData.color;
	end;
end);
