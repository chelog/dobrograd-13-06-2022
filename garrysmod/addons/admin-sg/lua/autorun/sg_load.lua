--[[
	© 2017 Thriving Ventures Limited do not share, re-distribute or modify
	
	without permission of its author (gustaf@thrivingventures.com).
]]

AddCSLuaFile()

if (SERVER) then
	include("sg_server.lua")
elseif (CLIENT) then
	include("sg_client.lua")
end

if (serverguard) then
	-- PLEASE don't set SG_DEV unless you know what you're doing!!!!
	-- This is VERY VERY HACKY and COULD BREAK EVERYTHING!!!!
	if (SG_DEV and !serverguard_dev) then
		if (!game.IsDedicated()) then
			if (SERVER) then
				util.AddNetworkString("sg_dev_reload");

				net.Receive("sg_dev_reload", function(length, player)
					if (!player:IsListenServerHost()) then
						return;
					end;

					serverguard_dev:PerformRefresh();
				end);
			end;
		end;

		serverguard_dev = {
			sgtable = {},
			buffer = {}
		};

		function serverguard_dev:Attach()
			self.sgtable = table.Copy(serverguard);
			local _serverguard_meta = {};

			serverguard = {};

			function _serverguard_meta:__index(key)
				return serverguard_dev.sgtable[key];
			end;

			function _serverguard_meta:__newindex(key, value)
				serverguard_dev:CheckAutoRefresh(3);

				serverguard_dev.sgtable[key] = value;
			end;

			setmetatable(serverguard, _serverguard_meta);
			print("[SG-DEV] Attached to serverguard table.");
		end;

		function serverguard_dev:Detatch()
			setmetatable(serverguard, {});

			-- Removing stuff that will linger
			if (CLIENT) then
				if (self.sgtable.GetMenuPanel()) then
					self.sgtable.GetMenuPanel():Remove();
				end;
			end;

			self.sgtable = nil;
			self.buffer = nil;
			serverguard = nil;

			collectgarbage("collect");

			self.sgtable = {};
			self.buffer = {};

			print("[SG-DEV] Detatched from serverguard table.");
		end;

		function serverguard_dev:PerformRefresh()
			--RunConsoleCommand("changelevel", game.GetMap());
			print("[SG-DEV] Change detected, starting reload...");
			self:Detatch();

			if (SERVER) then
				include("sg_server.lua");
				Msg("ServerGuard (SERVER) Loaded.\n")
			elseif (CLIENT) then
				include("sg_client.lua");
				Msg("ServerGuard (CLIENT) Loaded.\n")
			end;

			if (CLIENT) then
				net.Start("sg_dev_reload");
					net.WriteBit(1);
				net.SendToServer();
			end;

			if (SERVER) then
				hook.Add("serverguard.Initialize", "sg_dev.Initialize", function()
					self:Attach();
					print("[SG-DEV] Reload complete!");

					-- Doing a hook.Call here is BAD.
					hook.Call("InitPostEntity", nil);
					hook.Remove("serverguard.Initialize", "sg_dev.Initialize");
				end);

				serverguard.Initialize();

				local host = util.GetListenServerHost();

				if (host ~= NULL) then
					hook.Call("PlayerInitialSpawn", nil, host);
				end;
			else
				hook.Add("serverguard.LoadPlayerData", "sg_dev.LoadPlayerData", function()
					self:Attach();
					print("[SG-DEV] Reload complete!");

					hook.Remove("serverguard.LoadPlayerData", "sg_dev.LoadPlayerData");
				end);
			end;
		end;

		function serverguard_dev:CheckAutoRefresh(stackLevel)
			stackLevel = stackLevel or 2;
			local info = debug.getinfo(stackLevel, "S");

			if (!self.buffer[info.short_src]) then
				self.buffer[info.short_src] = true;
			else
				self:PerformRefresh();
			end;
		end;

		serverguard_dev:Attach();
	end;

	if (SERVER) then
		Msg("ServerGuard (SERVER) Loaded.\n")
	elseif (CLIENT) then
		Msg("ServerGuard (CLIENT) Loaded.\n")
	end
else
	Msg("!! URGENT !!\nServerGuard failed to load!\n")
end