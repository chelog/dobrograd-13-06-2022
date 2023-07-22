--[[
	� 2017 Thriving Ventures Ltd do not share, re-distribute or modify
	without permission of its author (gustaf@thrivingventures.com).
]]

--- ## Shared
-- The registration and handling of chat commands.
-- @module serverguard.command

local string = string;

serverguard.command = serverguard.command or {};
serverguard.command.stored = serverguard.command.stored or {};

--- Gets a table of all the registered commands.
-- @treturn table Command data.
function serverguard.command:GetTable()
	return self.stored;
end;

serverguard.command.GetStored = serverguard.command.GetTable;

--- Registers a new command.
-- @table data The command table to extract info from.
function serverguard.command:Add(data)
	self.stored[data.command] = data;

	if (data.permissions) then
		serverguard.permission:Add(data.permissions);
	end;

	if (SERVER) then
		self.stored[data.command].ContextMenu = nil;
	end;
end;

--- Removes a command.
-- @string uniqueID The unique ID of the command.
function serverguard.command:Remove(uniqueID)
	self.stored[uniqueID] = nil;
end;

--- Gets a command by its unique ID.
-- @string uniqueID The unique ID of the command.
-- @treturn table Command data.
function serverguard.command:FindByID(uniqueID)
	local command = self.stored[uniqueID];

	if (command) then
		return command;
	else
		for k, v in pairs(self.stored) do
			if (v.aliases and table.HasValue(v.aliases, uniqueID)) then
				return v;
			end;
		end;
	end;
end;

--- Gets the formatted argument string from a command table.
-- @table commandTable The command table.
-- @treturn string Formatted string.
function serverguard.command:GetArgumentsString(commandTable)
	local result = "";
	local first = true;

	if (commandTable.arguments) then
		for k, v in pairs(commandTable.arguments) do
			if (first) then
				first = false;
			else
				result = result .. " ";
			end;

			result = result .. "<" .. v .. ">";
		end;
	end;

	if (commandTable.optionalArguments) then
		for k, v in pairs(commandTable.optionalArguments) do
			if (first) then
				first = false;
			else
				result = result .. " ";
			end;

			result = result .. "[" .. v .. "]";
		end;
	end;

	return result;
end;

serverguard.command.Get = serverguard.command.FindByID;

local function GetPlayerSteamID32(player)
	local stid_32 = string.format("%.0f", string.sub(player:SteamID64(), 3) - "561197960265728")

	return stid_32
end


if (SERVER) then
	local notifyCommands = octolib.array.toKeys{ 'ban', 'unban', 'kick', 'rank' }

	--[[ Internal function run a command. --]]
	local function RUN_COMMAND(commandTable, player, bIsSilent, arguments)
		if (!commandTable) then
			return;
		end;

		bIsSilent = bIsSilent or not notifyCommands[commandTable.command or '']

		-- Legacy command style.
		if (commandTable.Execute) then
			local bStatus, value = pcall(commandTable.Execute, commandTable, player, bIsSilent, arguments);

			if (!commandTable.bNoLog) then
				serverguard.PrintConsole(string.format(
					"%s ran command \"%s %s\"\n", serverguard.player:GetName(player), commandTable.command, table.concat(arguments, " ")
				));
			end;

			if (bStatus) then
				hook.Call("serverguard.RanCommand", nil, player, commandTable, bIsSilent, arguments);
			else
				ErrorNoHalt(string.format("The \"%s\" command has failed to run.\n%s\n", commandTable.command, value));
				return;
			end;
		else
			if (commandTable.OnExecute) then
				commandTable:OnExecute(player, arguments);
			end;

			local targets = {};

			if (commandTable.bSingleTarget) then
				local target = util.FindPlayer(arguments[1], player);

				if (target and IsValid(target)) then
					if (!util.PlayerMatchesImmunity(commandTable.immunity, player, target)) then
						serverguard.Notify(player, SERVERGUARD.NOTIFY.RED, "This player has a higher immunity than you.");
					else
						if (commandTable:OnPlayerExecute(player, target, arguments)) then
							targets = {target};
						end;
					end;
				end;
			else
				targets = util.ExecuteOnPlayers(arguments[1], player, commandTable.immunity or SERVERGUARD.IMMUNITY.LESSOREQUAL, function(target)
					return commandTable:OnPlayerExecute(player, target, arguments);
				end);
			end;

			if (!bIsSilent and commandTable.OnNotify and targets and #targets > 0 and !hook.Call("serverguard.CommandNotify", nil, player, targets, arguments)) then
				local arguments = {commandTable:OnNotify(player, targets, arguments)};

				serverguard.Notify(nil, unpack(arguments));
			end;

			if (commandTable.OnExecuted) then
				commandTable:OnExecuted(player, targets, arguments);
			end;

			if (!commandTable.bNoLog) then
				serverguard.PrintConsole(string.format(
					"%s ran command \"%s %s\"\n", serverguard.player:GetName(player), commandTable.command, table.concat(arguments, " ")
				));
			end;

			hook.Call("serverguard.RanCommand", nil, player, commandTable, bIsSilent, arguments);
		end;
	end;

	--- Makes a player run a command.
	-- @player player The player running the command. You should **not** pass this argument clientside.
	-- @string command The unique ID of the command to run.
	-- @bool bIsSilent Whether or not to display a notification.
	-- @param ... Any arguments to pass to the command.
	-- @treturn bool Whether or not the command exists.
	function serverguard.command.Run(player, command, bIsSilent, ...)
		local arguments = {...};
		local commandTable = serverguard.command:FindByID(command);

		if (commandTable) then
			if (commandTable.bDisallowConsole and util.IsConsole(player)) then
				serverguard.PrintConsole("You cannot run the \"" .. commandTable.command .. "\" command as the server.\n");
				return true;
			end;

			if (hook.Call("serverguard.PlayerCanUseCommand", nil, player, commandTable, bIsSilent, arguments) != false) then
				if (util.IsConsole(player)) then
					RUN_COMMAND(commandTable, player, bIsSilent, arguments);
					return true;
				end;

				if (commandTable.permissions and #commandTable.permissions > 0) then
					if (!serverguard.player:HasPermission(player, commandTable.permissions)) then
						serverguard.Notify(player, SERVERGUARD.NOTIFY.RED, string.format("You do not have access to this command, %s.", player:Nick()));
						return true;
					end;
				end;

				if (!commandTable.arguments or #arguments >= #commandTable.arguments) then
					RUN_COMMAND(commandTable, player, bIsSilent, arguments);
				elseif (!util.IsConsole(player) and #arguments == 0 and commandTable.arguments and #commandTable.arguments == 1 and commandTable.arguments[1] == "player") then
					RUN_COMMAND(commandTable, player, bIsSilent, {player:Name()});
				else
					serverguard.Notify(player, SERVERGUARD.NOTIFY.RED, "The syntax for this command is incorrect:");
					serverguard.Notify(player, SERVERGUARD.NOTIFY.WHITE, string.format("!%s %s", commandTable.command, serverguard.command:GetArgumentsString(commandTable)));
				end;
			end;

			return true;
		end;

		return false;
	end;

	hook.Add("PlayerSay", "serverguard.command.PlayerSay", function(pPlayer, text, m_bToAll, m_bDead)
		if (text == "") then
			return;
		end;

		local prefix = string.lower(string.sub(text, 1, 1));
		local cmd = string.lower(string.Explode(' ', text)[1])

		if (prefix == "!" or prefix == "~") then
			local arguments = util.ExplodeByTags(text, " ", "\"", "\"", true);
			local commandName = string.lower(string.sub(arguments[1], #prefix + 1));

			table.remove(arguments, 1);

			if (pPlayer:GetDBVar('sgMuted') and commandName != "unmute") then
				return "";
			end;

			local commandExists = serverguard.command.Run(pPlayer, commandName, false, unpack(arguments));

			if (commandExists) then
				return "";
			end;
		elseif (pPlayer:GetDBVar('sgMuted')) then
			return "";
		end
	end);

	serverguard.netstream.Hook("sgRunCommand", function(pPlayer, data)
		serverguard.command.Run(pPlayer, data.command, data.silent, unpack(data.arguments));
	end);

	concommand.Add("sg", function(pPlayer, command, arguments)
		if (arguments and arguments[1]) then
			local commandName = string.lower(arguments[1]);
			local commandTable = serverguard.command:FindByID(commandName);

			table.remove(arguments, 1);

			if (commandTable) then
				serverguard.command.Run(pPlayer, commandTable.command, false, unpack(arguments));
			end;
		end;
	end);
elseif (CLIENT) then
	local autoComplete = {}
	local autoCompleteWidth = 0
	local autoCompleteHeight = 0
	local autoCompleteActive = 0
	local autoCompletePrefix = {}

	autoCompletePrefix["!"] = true
	autoCompletePrefix["~"] = true

	function serverguard.command.Run(command, bIsSilent, ...)
		serverguard.netstream.Start("sgRunCommand", {
			command = command, silent = bIsSilent, arguments = {...}
		});
	end;

	concommand.Add("sg", function(_, command, arguments)
		if (arguments and arguments[1]) then
			local commandName = string.lower(arguments[1]);
			local commandTable = serverguard.command:FindByID(commandName);

			table.remove(arguments, 1);

			if (commandTable) then
				serverguard.command.Run(commandTable.command, false, unpack(arguments));
			end;
		end;
	end, function(command, arguments)
		local results = {};
		local commands = serverguard.command:GetTable();

		arguments = util.ExplodeByTags(string.Trim(arguments), " ", "\"", "\"", true);

		if (arguments[1]) then
			local command = serverguard.command:FindByID(arguments[1]);

			if (command and serverguard.player:HasPermission(LocalPlayer(), command.permissions)) then
				local sg_cmdabout = "sg " .. command.command .. " " .. serverguard.command:GetArgumentsString(command)

				table.insert(results, sg_cmdabout);

				if (command.arguments and #command.arguments > 0) then
					for k, v in pairs(command.arguments) do
						if (v == "player") then
							for k, target in ipairs(player.GetAll()) do
								if (arguments[2]) then
									for _, result in pairs(results) do
										if (result == sg_cmdabout) then
											results[_] = nil
										end
									end

									if !(target:IsBot()) then
										if (target:Name():lower():find(arguments[2]) or target:SteamID():find(arguments[2]) or target:SteamID():lower():find(arguments[2]) or target:SteamID64():find(arguments[2]) or GetPlayerSteamID32(target):find(arguments[2])) then
											table.insert(results, "sg " .. command.command .. " \"" .. target:Name() .. "\"")
										end
									else
										if (target:Name():lower():find(arguments[2]) or target:SteamID():find(arguments[2])) then
											table.insert(results, "sg " .. command.command .. " \"" .. target:Name() .. "\"");
										end
									end
								else
									table.insert(results, "sg " .. command.command .. " \"" .. target:Name() .. "\"")
								end
							end;
						end;
					end;
				end;
			elseif (!arguments[2]) then
				for k, commandTable in util.SortedPairsByMemberValue(commands, "command") do
					if (string.sub(commandTable.command, 1, string.len(arguments[1])) == arguments[1] and serverguard.player:HasPermission(LocalPlayer(), commandTable.permissions)) then
						table.insert(results, "sg " .. commandTable.command .. " ");
					end;
				end;
			end;
		else
			for k, commandTable in util.SortedPairsByMemberValue(commands, "command") do
				if (serverguard.player:HasPermission(LocalPlayer(), commandTable.permissions)) then
					table.insert(results, "sg " .. commandTable.command .. " ");
				end;
			end;
		end;

		hook.Call("serverguard.ConsoleAutoComplete", nil, arguments, results);

		return results;
	end);

	local function serverGuard_AddAutoCompletePrefixes()
		hook.Call("serverguard.AddPrefixes", nil, autoCompletePrefix)
	end

	timer.Simple(4, serverGuard_AddAutoCompletePrefixes)

	local function serverGuard_PaintAutoComplete()
		if (#autoComplete > 0) then
			local x, y = chat.GetChatBoxPos()

			if (Clockwork) then
				x, y = Clockwork.chatBox:GetPosition()
			end

			draw.RoundedBox(2, x, y -(6 +autoCompleteHeight), autoCompleteWidth +10, autoCompleteHeight, Color(0, 0, 0, 200))

			for k, v in pairs(autoComplete) do
				if (k == autoCompleteActive) then
					draw.SimpleText(v, "serverGuard_ownerFont", x +4, y -16 *k, Color(20, 193, 20, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				else
					draw.SimpleText(v, "serverGuard_ownerFont", x +4, y -16 *k, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				end
			end
		end
	end

	hook.Add("HUDPaint", "serverguard_chatcommands.HUDPaint", serverGuard_PaintAutoComplete)

	local table = table
	local isTabbing = false

	local function serverGuard_CheckChatText(text)
		if (!isTabbing) then
			autoComplete = {}

			-- Check the prefix.
			if (autoCompletePrefix[string.sub(text, 0, 1)]) then
				autoCompleteWidth = 0
				autoCompleteHeight = 0

				-- IS THIS A GOOD IDEA? LOL
				local commands = table.Copy(serverguard.command.stored)

				hook.Call("serverguard.AddAutoComplete", nil, commands)

				for command, data in pairs(commands) do
					if (string.find(command, text)) then
						local aText = command
						local width, height = util.GetTextSize("serverGuard_ownerFont", aText)

						if (data.arguments) then
							local args = ""

							for k, v in pairs(data.arguments) do
								args = args .. v .. " "
							end

							aText = command .. " " .. args

							width, height = util.GetTextSize("serverGuard_ownerFont", aText)
						end

						if (width > autoCompleteWidth) then
							autoCompleteWidth = width
						end

						autoCompleteHeight = autoCompleteHeight +height

						table.insert(autoComplete, aText)
					end
				end

				if (#autoComplete == 1) then
					autoCompleteActive = 1
				end

				autoCompleteHeight = autoCompleteHeight +3
			end
		end
	end

	hook.Add("ChatTextChanged", "serverguard_chatcommands.ChatTextChanged", serverGuard_CheckChatText)

	local function serverGuard_ChatboxClosed()
		autoComplete = {}
		autoCompleteWidth = 0
		autoCompleteHeight = 0
		autoCompleteActive = 0

		isTabbing = false
	end

	hook.Add("FinishChat", "serverguard_chatcommands.FinishChat", serverGuard_ChatboxClosed)

	timer.Create("serverguard.autocomplete.timer", FrameTime() *8, 0, function() timer.Stop("serverguard.autocomplete.timer") end)

	local function serverGuard_ChatboxTabbed(text)
		isTabbing = true

		autoCompleteActive = autoCompleteActive +1

		if (autoCompleteActive > #autoComplete) then
			autoCompleteActive = 1
		end

		if (autoComplete[autoCompleteActive]) then
			local start = string.find(autoComplete[autoCompleteActive], "<")

			if (start) then
				timer.Adjust("serverguard.autocomplete.timer", FrameTime() *8, 1, function()
					isTabbing = false

					timer.Stop("serverguard.autocomplete.timer")
				end)

				timer.Start("serverguard.autocomplete.timer")

				return string.sub(autoComplete[autoCompleteActive], 0, start -2)
			else
				timer.Adjust("serverguard.autocomplete.timer", FrameTime() *8, 1, function()
					isTabbing = false

					timer.Stop("serverguard.autocomplete.timer")
				end)

				timer.Start("serverguard.autocomplete.timer")

				return autoComplete[autoCompleteActive]
			end
		end

		isTabbing = false
	end

	hook.Add("OnChatTab", "serverguard_chatcommands.OnChatTab", serverGuard_ChatboxTabbed)
end
