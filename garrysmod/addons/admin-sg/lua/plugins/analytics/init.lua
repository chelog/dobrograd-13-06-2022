--[[
	© 2017 Thriving Ventures Limited do not share, re-distribute or modify
	
	without permission of its author (gustaf@thrivingventures.com).
]]

local plugin = plugin;

plugin:IncludeFile("shared.lua", SERVERGUARD.STATE.SHARED);

local visits = {};

plugin:Hook("serverguard.mysql.CreateTables", "analytics.CreateTables", function()
	local ANALYTICS_TABLE_QUERY = serverguard.mysql:Create("serverguard_analytics");
		ANALYTICS_TABLE_QUERY:Create("id", "INTEGER NOT NULL AUTO_INCREMENT");
		ANALYTICS_TABLE_QUERY:Create("date", "VARCHAR(10) NOT NULL");
		ANALYTICS_TABLE_QUERY:Create("data", "TEXT NOT NULL");
		ANALYTICS_TABLE_QUERY:PrimaryKey("id");
	ANALYTICS_TABLE_QUERY:Execute();
end);


plugin:Hook("serverguard.mysql.OnConnected", "analytics.Initialize", function()
	local queryObj = serverguard.mysql:Select("serverguard_analytics");
		queryObj:Select("date");
		queryObj:Select("data");
		queryObj:Callback(function(result, status, lastID)
			if (type(result) == "table" and #result > 0) then
				for k, v in pairs(result) do
					local dateTable = string.Explode("-", v.date);
					local day = tonumber(dateTable[1]);
					local month = tonumber(dateTable[2]);
					local year = tonumber(dateTable[3]);

					if (year == util.ToNumber(os.date("%Y", os.time()))) then -- get only the analytics for this year
						visits[month] = visits[month] or {};
						visits[month][day] = util.JSONToTable(v.data);
					end;
				end;
			end;
		end);
	queryObj:Execute();
end);

plugin:Hook("PlayerInitialSpawn", "analytics.PlayerInitialSpawn", function(player)
	local day = tonumber(os.date("%d", os.time()));
	local month = tonumber(os.date("%m", os.time()));
	local year = tonumber(os.date("%Y", os.time()));
	local steamID = player:SteamID();

	visits[month] = visits[month] or {};
	visits[month][day] = visits[month][day] or {0, {}};
	visits[month][day][1] = visits[month][day][1] + 1;
	
	if (!table.HasValue(visits[month][day][2], steamID)) then
		table.insert(visits[month][day][2], steamID);
	end;

	local queryObj = serverguard.mysql:Select("serverguard_analytics");
		queryObj:Select("id");
		queryObj:Where("date", day.."-"..month.."-"..year);
		queryObj:Callback(function(result, status, lastID)
			if (type(result) == "table" and #result > 0) then
				local updateObj = serverguard.mysql:Update("serverguard_analytics");
					updateObj:Update("data", util.TableToJSON(visits[month][day]));
					updateObj:Where("date", day.."-"..month.."-"..year);
				updateObj:Execute();
			else
				local insertObj = serverguard.mysql:Insert("serverguard_analytics");
					insertObj:Insert("date", day.."-"..month.."-"..year);
					insertObj:Insert("data", util.TableToJSON(visits[month][day]));
				insertObj:Execute();
			end;
		end);
	queryObj:Execute();
end);

serverguard.netstream.Hook("sgRequestAnalytics", function(player, data)
	if (serverguard.player:HasPermission(player, "Analytics")) then
		local analyticData = {};

		for month, monthData in pairs(visits) do
			local total = 0;
			local uniques = 0;

			for day, dayData in pairs(monthData) do
				total = total + dayData[1];
				uniques = uniques + table.Count(dayData[2]);
			end;

			analyticData[month] = {
				total = total,
				uniques = uniques
			};
		end;

		serverguard.netstream.Start(player, "sgSendAnalytics", analyticData);
	end
end);