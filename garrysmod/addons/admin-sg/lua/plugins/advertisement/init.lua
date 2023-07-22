--[[
	© 2017 Thriving Ventures Limited do not share, re-distribute or modify
	
	without permission of its author (gustaf@thrivingventures.com).
]]

serverguard.AddFolder("advertisements");

local plugin = plugin;

plugin:IncludeFile("shared.lua", SERVERGUARD.STATE.SHARED);
plugin:IncludeFile("cl_panel.lua", SERVERGUARD.STATE.CLIENT);

local advertisements = {};

local function SAVE_ADVERTISEMENTS()
	file.Write("serverguard/advertisements/advertisements.txt", serverguard.von.serialize(advertisements), "DATA");
end;

plugin:Hook("InitPostEntity", "advertisement.InitPostEntity", function()
	local data = file.Read("serverguard/advertisements/advertisements.txt", "DATA")
	
	if (data) then
		local advertisementList = serverguard.von.deserialize(data)

		-- backwards compatibility with old advertisement format
		for k, v in pairs(advertisementList) do
			if (type(v) == "table") then
				advertisements[#advertisements + 1] = v
				continue;
			end

			advertisements[#advertisements + 1] = {
				text = v,
				interval = 120,
				color = Color(200, 30, 30, 255)
			}
		end
	else
		file.Write("serverguard/advertisements/advertisements.txt", serverguard.von.serialize(advertisements), "DATA")
	end
end)

plugin:Hook("Tick", "advertisement.Tick", function()
	for k, v in pairs(advertisements) do
		if (!v.nextTime or CurTime() >= v.nextTime) then
			if (hook.Call("serverguard.advertisement.Show", nil, v)) then continue; end;

			util.PrintAllColor(v.color, v.text)

			v.nextTime = CurTime() + v.interval
		end
	end
end)

--
-- Sends the advertisements to the player.
--

serverguard.netstream.Hook("sgRequestAdvertisements", function(player, data)
	if (serverguard.player:HasPermission(player, "Manage Advertisements")) then
		for k, v in ipairs(advertisements) do
			serverguard.netstream.Start(player, "sgGetAdvertisement", {
				v.text, v.interval, v.color
			});
		end;
	end;
end);

--
-- Creates an advertisement.
--

serverguard.netstream.Hook("sgCreateAdvertisement", function(player, data)
	if (serverguard.player:HasPermission(player, "Manage Advertisements")) then
		local text = string.sub(data[1], 1, 256)
		local interval = math.Clamp(data[2], 10, 86400)
		local color = data[3];

		table.insert(advertisements, {
			text = text,
			interval = interval,
			color = Color(color.r, color.g, color.b, 255)
		});

		serverguard.Notify(player, SERVERGUARD.NOTIFY.GREEN, "Added advertisement \"" .. text .. "\".");

		for k, v in ipairs(advertisements) do
			serverguard.netstream.Start(player, "sgGetAdvertisement", {
				v.text, v.interval, v.color
			});
		end;
		
		SAVE_ADVERTISEMENTS();
	end;
end);

--
-- Changes or creates an advertisement.
--

serverguard.netstream.Hook("sgChangeAdvertisement", function(player, data)
	if (serverguard.player:HasPermission(player, "Manage Advertisements")) then
		local id = data[1];
		local text = string.sub(data[2], 1, 256);
		local interval = math.Round(math.Clamp(data[3], 10, 86400));
		local color = data[4];
		
		if (id > 0) then
			advertisements[id] = {
				text = text,
				interval = interval,
				color = Color(color.r, color.g, color.b, 255)
			};
			
			serverguard.Notify(player, SERVERGUARD.NOTIFY.GREEN, "Changed advertisement to \"" .. text .. "\".");
		end;
		
		for k, v in ipairs(advertisements) do
			serverguard.netstream.Start(player, "sgGetAdvertisement", {
				v.text, v.interval, v.color
			});
		end
		
		SAVE_ADVERTISEMENTS();
	end;
end);

--
-- Removes an advertisement.
--

serverguard.netstream.Hook("sgRemoveAdvertisement", function(player, data)
	if (serverguard.player:HasPermission(player, "Manage Advertisements")) then
		local id = data;
		
		if (id) then
			local data = advertisements[id];
			
			if (data) then
				serverguard.Notify(player, SERVERGUARD.NOTIFY.RED, "Removed advertisement \"" .. data.text .. "\".");

				table.remove(advertisements, id);
				
				for k, v in ipairs(advertisements) do
					serverguard.netstream.Start(player, "sgGetAdvertisement", {
						v.text, v.interval, v.color
					});
				end;
				
				SAVE_ADVERTISEMENTS();
			end;
		end;
	end;
end);
