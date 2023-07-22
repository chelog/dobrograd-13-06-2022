--[[
	© 2017 Thriving Ventures Limited do not share, re-distribute or modify

	without permission of its author (gustaf@thrivingventures.com).
]]

--- ## Shared
--- Extension of util library to provide convenience functions.
-- @module util

color_white 		= Color(255, 255, 255, 255)
color_black 		= Color(0, 0, 0, 255)
color_red 			= Color(255, 0, 0, 255)
color_green			= Color(0, 255, 0, 255)
color_green_darker 	= Color(0, 200, 0, 255)
color_blue 			= Color(0, 0, 255, 255)
color_yellow		= Color(255, 255, 0, 255)
color_purple_light	= Color(106, 90, 205, 255)
color_orange 		= Color(255, 165, 0, 255)
color_brown			= Color(150, 75, 0, 255)

local temptbl = {}

local function MergeSortByName( tbl, iLow, iHigh, bReverse )
	if ( iLow < iHigh ) then
		local iMiddle = math.floor( iLow + (iHigh - iLow) / 2 )
		MergeSortByName( tbl, iLow, iMiddle, bReverse )
		MergeSortByName( tbl, iMiddle + 1, iHigh, bReverse )

		for i = iLow, iHigh do
			temptbl[i] = tbl[i]
		end

		local i = iLow
		local j = iMiddle + 1
		local k = iLow

		while ( i <= iMiddle and j <= iHigh ) do
			if ( temptbl[i]:Nick() <= temptbl[j]:Nick() ) then
				if ( bReverse ) then
					tbl[k] = temptbl[j]
					j = j + 1
				else
					tbl[k] = temptbl[i]
					i = i + 1
				end
			else
				if ( bReverse ) then
					tbl[k] = temptbl[i]
					i = i + 1
				else
					tbl[k] = temptbl[j]
					j = j + 1
				end
			end

			k = k + 1
		end

		while ( i <= iMiddle ) do
			tbl[k] = temptbl[i]
			k = k + 1
			i = i + 1
		end
	end
end

--- Gets a sorted list of players connected to the server.
-- @treturn table Player list.
function player.GetSortedPlayers(bReverse --[[= false]])
	local tbl = player.GetAll()

	MergeSortByName(tbl, 1, #tbl, bReverse)

	return tbl;
end;

-- Taken from the gmod table library. Necessary to restore the original
-- functionality broken due to the following commit:
-- https://github.com/garrynewman/garrysmod/commit/5e9d4fa05ea9cc69c56e5c0857d5247dcabdc192
local function fnPairsSorted(tab, index)
	if (index == nil) then
		index = 1;
	else
		for k, v in pairs(tab.__SortedIndex) do
			if (v == index) then
				index = k + 1;
				break;
			end;
		end;
	end;

	local key = tab.__SortedIndex[index];

	if (!key) then
		tab.__SortedIndex = nil;
		return;
	end;

	index = index + 1;

	return key, tab[key];
end

-- See fnPairsSorted
function util.SortedPairsByMemberValue(tab, valueName, descending)
	descending = descending or false;

	local sortedIndex = {};
	local sortedTable = table.ClearKeys(tab, true);

	table.SortByMember(sortedTable, valueName, !descending);

	for k, v in ipairs(sortedTable) do
		table.insert(sortedIndex, v.__key);
	end;

	tab.__SortedIndex = sortedIndex;

	return fnPairsSorted, tab, nil;
end;

--- Returns whether or not the player can be compared **EXACTLY** with a given identifier.
-- This is more strict, and will match exact names.
-- @player player The player to extract the information from.
-- @string identifier The string to compare with.
-- @treturn bool Whether the player matches the given identifier.
function util.PlayerMatchesIdentifier(player, identifier)
	local result = hook.Call("serverguard.PlayerMatchesIdentifier", nil, player, identifier);

	return (IsValid(player) and identifier and result or string.lower(identifier) == string.lower(player:Name()) or
		string.lower(identifier) == string.lower(player:Nick()) or
		player:SteamID() == identifier or
		player:UniqueID() == identifier or
		player:SteamID64() == identifier or
		(player:IPAddress():gsub(":%d+", "")) == identifier);
end;

--- Returns whether or not the player can be compared with a given identifier.
-- This will be more lenient with finding substrings in a player's name, for example.
-- @player player The player to extract the information from.
-- @string identifier The string to compare with.
-- @treturn bool Whether the player contains the given identifier.
function util.PlayerContainsIdentifier(player, identifier)
	local result = hook.Call("serverguard.PlayerContainsIdentifier", nil, player, identifier);

	return (IsValid(player) and identifier and result or (string.find(utf8.lower(player:Name()), utf8.lower(identifier), 0, true) or
		string.find(utf8.lower(player:Nick()), utf8.lower(identifier), 0, true) or
		player:SteamID() == identifier or
		player:UniqueID() == identifier or
		player:SteamID64() == identifier or
		(player:IPAddress():gsub(":%d+", "")) == identifier));
end;

--- Returns whether or not the target's immunity level fulfills the required immunity comparison with the player.
-- @number requiredImmunity The required immunity comparison.
-- @player player The player to be compared to.
-- @player target The player to be compared with.
-- @treturn bool Whether the immunity requirement has been fulfilled.
function util.PlayerMatchesImmunity(requiredImmunity, pPlayer, target, bNoTargetSelf)
	local result = hook.Call("serverguard.PlayerMatchesImmunity", nil, requiredImmunity, pPlayer, target, bNoTargetSelf);

	return 	result or
			(requiredImmunity == SERVERGUARD.IMMUNITY.EQUAL and serverguard.player:GetImmunity(target) == serverguard.player:GetImmunity(pPlayer)) or
			(requiredImmunity == SERVERGUARD.IMMUNITY.LESS and serverguard.player:GetImmunity(target) < serverguard.player:GetImmunity(pPlayer)) or
			(requiredImmunity == SERVERGUARD.IMMUNITY.LESSOREQUAL and serverguard.player:GetImmunity(target) <= serverguard.player:GetImmunity(pPlayer)) or
			(requiredImmunity == SERVERGUARD.IMMUNITY.ANY) or
			(!bNoTargetSelf and pPlayer == target);
end;

local identifierTags = {
	-- Immunity is automatically checked beforehand so we don't have to do it here.

	["^"] = {
		filter = function(callingPlayer, targetPlayer)
			return callingPlayer == targetPlayer
		end,
		negated = function(callingPlayer, targetPlayer)
			return callingPlayer != targetPlayer
		end
	},
	["\\*"] = {
		filter = function(callingPlayer, targetPlayer)
			return true
		end,
		negated = function(callingPlayer, targetPlayer)
			return false
		end
	},
	["#*"] = {
		filter = function(callingPlayer, targetPlayer, argument)
			return serverguard.player:GetRank(targetPlayer) == argument
		end,
		negated = function(callingPlayer, targetPlayer, argument)
			return serverguard.player:GetRank(targetPlayer) != argument
		end
	},
	["@"] = {
		filter = function(callingPlayer, targetPlayer, argument)
			return callingPlayer:GetEyeTraceNoCursor().Entity == targetPlayer
		end,
		negated = function(callingPlayer, targetPlayer, argument)
			return callingPlayer:GetEyeTraceNoCursor().Entity != targetPlayer
		end
	}
};

--- Attempts to find all connected players matching the given query, and runs a function with that player as an argument.
-- Valid identifiers include name, Steam ID, 64-bit Steam ID, IP address, a comma-separated list, or a special tag.
-- Tags include ^ for self, * for all, and #name for all players with the given rank. You can use ! to negate the action.
-- @string identifier String to try and match players with.
-- @player callingPlayer Player who initiated the query.
-- @number requiredImmunity The required immunity level between the calling player and any targets for the function to run.
-- @func func Function to run with all applicable targets.
-- @treturn table List of applicable players.
function util.ExecuteOnPlayers(identifier, callingPlayer, requiredImmunity, func)
	if (!identifier or !callingPlayer or !requiredImmunity or !func) then
		return;
	end;

	local tAllPlayers = player.GetAll()
	local players = {};

	for k, v in ipairs(tAllPlayers) do
		if (util.PlayerMatchesImmunity(requiredImmunity, callingPlayer, v)) then
			if (util.PlayerMatchesIdentifier(v, identifier)) then
				-- If we match exactly, we only execute on the one player.
				table.insert(players, v);

				break;
			elseif (util.PlayerContainsIdentifier(v, identifier)) then
				if (#players == 0) then
					table.insert(players, v);
				else
					serverguard.Notify(callingPlayer, SGPF("player_found_multiple", identifier));
					return {};
				end;
			end;
		end;
	end;

	-- Matching special tags.
	if (#players == 0) then
		local negate = (string.sub(identifier, 1, 1) == "!");

		for k, v in pairs(identifierTags) do
			local tag = k;
			local text = identifier;
			local argument = "";
			local func = "filter";

			if (negate) then
				text = string.sub(identifier, 2, string.len(identifier));
				func = "negated";
			end;

			local wildcardPosition = string.find(tag, "*", 0, true);

			if (wildcardPosition) then
				if (string.sub(tag, wildcardPosition - 1, wildcardPosition - 1) == "\\") then
					tag = string.sub(tag, wildcardPosition, wildcardPosition);
				else
					tag = string.gsub(tag, "*", "");
						argument = string.gsub(text, tag, "");
					tag = tag .. argument;
				end;
			end;

			for k, pPlayer in pairs(tAllPlayers) do
				if (tag == text and util.PlayerMatchesImmunity(requiredImmunity, callingPlayer, pPlayer) and v[func](callingPlayer, pPlayer, argument)) then
					table.insert(players, pPlayer);
				end;
			end;
		end;

		-- Matching name-separated list.
		if (#players == 0) then
			if (string.find(identifier, ",", 0, true)) then
				local identifiers = string.Explode(",", identifier);

				for k, v in pairs(identifiers) do
					local found = false;

					for k2, v2 in ipairs(tAllPlayers) do
						if (util.PlayerMatchesImmunity(requiredImmunity, callingPlayer, v2) and util.PlayerContainsIdentifier(v2, v)) then
							if (!found) then
								found = true;
								table.insert(players, v2);
							else
								serverguard.Notify(callingPlayer, SGPF("player_found_multiple", v));
								return {};
							end;
						end;
					end;
				end;
			end;

			-- Give up if we haven't found anyone.
			if (#players == 0) then
				serverguard.Notify(callingPlayer, SGPF("player_cant_find_suitable"));
				return {};
			end;
		end;
	end;

	local result = {};

	for k, v in pairs(players) do
		local status = func(v);

		if (status) then
			table.insert(result, v);
		end;
	end;

	-- Oops, everyone was filtered out.
	if (#result == 0) then
		serverguard.Notify(callingPlayer, SGPF("player_cant_find_suitable"));
		return {};
	end;

	return result;
end;

function util.GetListenServerHost()
	for k, v in ipairs(player.GetAll()) do
		if (v:IsListenServerHost()) then
			return v
		end
	end

	return NULL
end

local PLAYER = FindMetaTable("Player")

function isplayer(v)
	return getmetatable(v) == PLAYER
end

--- Obtains a list of elements suitable for `serverguard.Notify` for the given player list.
-- It is assumed that there is at least one target.
-- @table targets Player targets to output.
-- @bool bOwnership Whether or not to add an ownership suffix (such as "'s").
-- @number targetColor A SERVERGUARD.NOTIFY color to use.
-- @treturn table Notify components.
-- @see serverguard.Notify
function util.GetNotifyListForTargets(targets, bOwnership, targetColor)
	targetColor = targetColor or SERVERGUARD.NOTIFY.RED;

	if (#targets < 1) then
		return {};
	end;

	if (#targets == #player.GetAll() and #targets != 1) then
		if (bOwnership) then
			return {targetColor, "everyone's"};
		end;

		return {targetColor, "everyone"};
	end

	local result = {};

	table.insert(result, targetColor);
	table.insert(result, targets[1]:Name());

	for i = 2, #targets - 1 do
		table.insert(result, SERVERGUARD.NOTIFY.WHITE);
		table.insert(result, ", ");
		table.insert(result, targetColor);
		table.insert(result, targets[i]:Name());
	end;

	if (#targets > 1) then
		table.insert(result, SERVERGUARD.NOTIFY.WHITE);
		table.insert(result, " and ");
		table.insert(result, targetColor);
		table.insert(result, targets[#targets]:Name());
	end;

	if (bOwnership) then
		table.insert(result, string.Ownership(result[#result], true));
	end;

	hook.Call("serverguard.GetNotifyListForTargets", nil, targets, bOwnership, targetColor, result);

	return result;
end;

--- Attempts to find a connected player by a given identifier.
-- Valid identifiers include name, Steam ID, 64-bit Steam ID, and IP address.
-- @string identifier Identifier to search with.
-- @player user Player to provide notifies to.
-- @bool bNoMessage Whether or not to provide feedback to the player.
function util.FindPlayer(identifier, user, bNoMessage)
	if (!identifier) then
		return;
	end;

	local output = {};

	for k, v in ipairs(player.GetAll()) do
		local playerNick = string.lower(v:Nick());
		local playerName = string.lower(v:Name());

		if (v:SteamID() == identifier or v:UniqueID() == identifier
		or v:SteamID64() == identifier or (v:IPAddress():gsub(":%d+", "")) == identifier
		or playerNick == string.lower(identifier) or playerName == string.lower(identifier)) then
			return v;
		end;

		if (string.find(playerNick, string.lower(identifier), 0, true)
		or string.find(playerName, string.lower(identifier), 0, true)) then
			table.insert(output, v);
		end;
	end;

	if (#output == 1) then
		return output[1];
	elseif (#output > 1) then
		if (!bNoMessage) then
			if (IsValid(user)) then
				if (serverguard and serverguard.Notify) then
					serverguard.Notify(user, SERVERGUARD.NOTIFY.RED, "Found more than one player with that identifier.");
				else
					user:ChatPrint("Found more than one player with that identifier.");
				end;
			else
				if (SERVER) then
					Msg("Found more than one player with that identifier.\n");
				end;
			end;
		end;
	else
		if (!bNoMessage) then
			if (IsValid(user)) then
				if (serverguard and serverguard.Notify) then
					serverguard.Notify(user, SERVERGUARD.NOTIFY.RED, "Can't find any player with that identifier.");
				else
					user:ChatPrint("Can't find any player with that identifier.");
				end;
			else
				if (SERVER) then
					Msg("Can't find any player with that identifier.\n");
				end;
			end;
		end;
	end;
end;

--- Alternative tonumber function that always returns a number. Returns 0 if unable to convert to number.
-- @param value Any variable to attempt to a number.
-- @treturn number Converted number.
function util.ToNumber(value)
	if (type(value) == "string") then
		if (tonumber(value) == nil) then
			return 0;
		end;

		return tonumber(value);
	end;

	if (type(value) == "boolean") then
		if (value) then
			return 1;
		end;

		return 0;
	end;

	if (type(value) == "number") then
		return value;
	end;

	if (value == nil) then
		return 0;
	end;

	return 0;
end;

--- Formats a number to include commas.
-- @number number Number to format.
-- @treturn string Formatted number.
function util.FormatNumber(number)
	if (number >= 1e14) then
		return tostring(number)
	end

	number = tostring(number)

	local dp = string.find(number, "%.") or #number +1

	for i = dp -4, 1, -3 do
		number = string.sub(number, 1, i) .. "," .. string.sub(number, i +1)
	end

	return number
end

--- Capitalizes the first letter of a string.
-- @string text String to capitalize.
-- @treturn string Capitalized string.
function string.Capitalize(text)
	return string.upper(string.sub(text, 1, 1)) .. string.sub(text, 2)
end

--- Returns the ownership suffix of a string.
-- @string text String to find ownership for.
-- @bool bSuffixOnly Whether or not to return only the suffix.
-- @treturn string String with ownership.
function string.Ownership(text, bSuffixOnly)
	local suffix = "'s";

	if (text[string.len(text)] == "'" or text[string.len(text)] == "'s") then
		suffix = "";
	elseif (text[string.len(text)] == "s") then
		suffix = "'"
	end;

	if (bSuffixOnly) then
		return suffix;
	end;

	return text .. suffix;
end;

--- Returns a Steam ID from a string.
-- @string text String to check for a Steam ID.
-- @treturn text The matched Steam ID.
function string.SteamID(text)
	return string.match(text, "STEAM_%d:%d:%d+");
end;

--- Explodes a string by enclosed tabs.
-- @string text String to explode.
-- @string seperator String to separate tags by.
-- @string open String to use as the beginning of a tag.
-- @string close String to use as the end of a tag.
-- @bool bRemoveTag Whether or not to remove the tag characters from the result.
-- @treturn table Exploded string.
-- @usage util.ExplodeByTags("!this 'is a test'", " ", "'", "'", true);
function util.ExplodeByTags(text, seperator, open, close, bRemoveTag)
	local results = {};
	local current = "";
	local tag = nil;

	text = string.gsub(text, "%s+", " ");

	for i = 1, #text do
		local character = string.sub(text, i, i);

		if (!tag) then
			if (character == open) then
				if (!bRemoveTag) then
					current = current..character;
				end;

				tag = true;
			elseif (character == seperator) then
				results[#results + 1] = current; current = "";
			else
				current = current..character;
			end;
		else
			if (character == close) then
				if (!bRemoveTag) then
					current = current..character;
				end;

				tag = nil;
			else
				current = current..character;
			end;
		end;
	end;

	if (current != "") then
		results[#results + 1] = current;
	end;

	return results;
end;

--- Checks to see whether or not a variable is the console.
-- @param object Any variable.
-- @treturn bool Whether or not the variable is the console.
function util.IsConsole(object)
	if (type(object) == "Entity" and !IsValid(object) and (object.EntIndex and object:EntIndex() == 0)) then
		return true;
	end;

	return false;
end;

--- Converts an ISO 8601 duration timestamp used by YouTube to seconds.
-- Note: this is not entirely accurate to the ISO standard - it's only tested for use with YouTube's duration format.
-- @string iso The ISO duration.
-- @treturn number The ISO duration in seconds. Returns -1 for an invalid ISO duration.
function util.IsoDurationToSeconds(iso)
	local duration = 0;
	local number = "";

	if (string.sub(iso, 1, 1) != "P") then
		return -1;
	end;

	for i = 1, string.len(iso), 1 do
		local character = string.sub(iso, i, i);

		if (character == "P" or character == "T") then
			continue;
		end;

		if (tonumber(character)) then
			number = number .. character;
		end;

		if (!tonumber(number)) then
			return -1;
		end;

		if (character == "D") then
			duration = duration + tonumber(number) * 86400;
			number = "";
		end;

		if (character == "H") then
			duration = duration + tonumber(number) * 3600;
			number = "";
		end;

		if (character == "M") then
			duration = duration + tonumber(number) * 60;
			number = "";
		end;

		if (character == "S") then
			duration = duration + tonumber(number);
			number = "";
		end;
	end;

	return duration;
end;

local durationUnits = {
	["m"] = {1, "minute"},
	["h"] = {60, "hour"},
	["d"] = {1440, "day"},
	["w"] = {10080, "week"},
	["n"] = {43200, "month"},
	["y"] = {525600, "year"}
};

local orderedDurationUnits = {
	{525600, "year"},
	{43200, "month"},
	{10080, "week"},
	{1440, "day"},
	{60, "hour"},
	{1, "minute"},
};

--- Converts a duration (e.g 1d12h) to minutes. Clamps all numbers between 0 and 99.
-- @string input The input duration. This can be a number, but it will return that number.
-- @treturn number The duration in minutes.
-- @treturn text The duration in text form (1 year, 3 days, etc).
-- @treturn bool Whether or not any input values have been clamped.
function util.ParseDuration(input)
	if (tonumber(input)) then
		local output = {};
		local number = tonumber(input);

		if (number <= 0) then
			return 0, "Indefinitely", false;
		end;

		for k, v in ipairs(orderedDurationUnits) do
			if (number >= v[1]) then
				local count = math.floor(number / v[1]);

				if (count > 1) then
					output[#output + 1] = tostring(count).." "..v[2].."s";
				else
					output[#output + 1] = tostring(count).." "..v[2];
				end;

				number = number - (v[1] * count);
			end;
		end;

		return tonumber(input), table.concat(output, ", "), false;
	end;

	local bClamped = false;
	local duration = 0;

	local text = "";
	local number = "";

	for i = 1, string.len(input), 1 do
		local character = string.sub(input, i, i);

		if (tonumber(character)) then
			number = number .. character;
			continue;
		end

		if (!tonumber(number)) then
			number = "";
			continue;
		end;

		if (!durationUnits[character]) then
			number = "";
			continue;
		end;

		if (tonumber(number) < 0 || tonumber(number) > 99) then
			number = tostring(math.Clamp(tonumber(number), 0, 99));
			bClamped = true;
		end;

		duration = duration + (tonumber(number) * durationUnits[character][1]);

		if (tonumber(number) > 0) then
			if (string.len(text) > 0) then
				text = text .. ", ";
			end;

			text = text .. number .. " " .. durationUnits[character][2];

			if (tonumber(number) > 1) then
				text = text .. "s";
			end;
		end;

		number = "";
	end;

	if (text == "") then
		text = "Indefinitely";
	end;

	return duration, text, bClamped;
end;

if (SERVER) then
	--- (SERVER) Prints text to the chatbox of all connected players.
	-- @string text Text to print.
	function util.PrintAll(text)
		for k, v in ipairs(player.GetAll()) do
			v:ChatPrint(text)
		end
	end

	--- (SERVER) Prints coloured text to the chatbox of all connected players.
	-- @param ... Color and text to use.
	-- @usage util.PrintAllColor(Color(255, 255, 255), "Hello! ", Color(200, 30, 30), "This is a test.");
	function util.PrintAllColor(...)
		serverguard.netstream.Start(nil, "sgPrintAllColor", {...});
	end;

	--- (SERVER) Prints text to the console of connected admins.
	-- @string text Text to print.
	function util.PrintConsoleAdmins(text)
		for k, pPlayer in ipairs(player.GetAll()) do
			if (pPlayer:IsAdmin()) then
				serverguard.netstream.Start(pPlayer, "sgPrintConsole", text);
			end;
		end;
	end;
elseif (CLIENT) then
	serverguard.bLogEnabled = CreateClientConVar("serverguard_log", "1", true, false);

	serverguard.netstream.Hook("sgPrintAllColor", function(data)
		chat.AddText(unpack(data));
	end);

	serverguard.netstream.Hook("sgPrintConsole", function(data)
		if (serverguard.bLogEnabled:GetBool()) then
			Msg(data);
		end;
	end);

	-- Thanks capsadmin <3.
	--- (CLIENT) Draws a textured line.
	-- @number x1 Starting X coordinate.
	-- @number y1 Starting Y coordinate.
	-- @number x2 Ending X coordinate.
	-- @number y2 Ending Y coordinate.
	-- @number w With of the line.
	function surface.DrawLineEx(x1, y1, x2, y2, w)
		local dx, dy = x1 -x2, y1 -y2
		local rotation = math.deg(math.atan2(dx, dy))
		local distance = math.Distance(x1, y1, x2, y2)

		x1 = x1 -dx *0.5
		y1 = y1 -dy *0.5

		surface.DrawTexturedRectRotated(x1, y1, w, distance, rotation)
	end

	--- Makes a panel change the cursor to a hand when hovered.
	-- @panel panel Panel to install hover to.
	function util.InstallHandHover(panel)
		panel:SetMouseInputEnabled(true)

		function panel:OnCursorEntered()
			self:SetCursor("hand")
		end

		function panel:OnCursorExited()
			self:SetCursor("arrow")
		end
	end

	--- (CLIENT) Draws a box shadow.
	-- @number x X coordinate.
	-- @number y Y coordinate.
	-- @number w Width of box.
	-- @number h Height of box.
	-- @number passes The amount of passes when drawing the shadow.
	-- @number depth The depth of the shadow.
	function util.PaintShadow(x, y, w, h, passes, depth)
		passes = passes or 4
		depth = depth or 0.2

		for i = 1, passes do
			local color = Color(0, 0, 0, (255 /i) *depth)

			-- Top shadow.
			draw.SimpleRect(x, y +(-1 +i), w, 1, color)

			-- Left shadow.
			draw.SimpleRect(x +(-1 +i), y, 1, h, color)

			-- Bottom shadow.
			draw.SimpleRect(x, y +(h -i), w, 1, color)

			-- Right shadow.
			draw.SimpleRect(x +(w -i), y, 1, h, color)
		end
	end

	--- (CLIENT) Darkens a colour by a given amount. Does not include alpha.
	-- @color color Colour to dim.
	-- @number amount How much to dim.
	-- @treturn color Dimmed colour.
	function util.DimColor(color, amount)
		return Color(
			math.Clamp(color.r - amount, 0, 255),
			math.Clamp(color.g - amount, 0, 255),
			math.Clamp(color.b - amount, 0, 255),
			color.a
		);
	end;

	--- (CLIENT) Limits how dark a colour can be.
	-- @color color Colour to limit.
	-- @number r Minimum red value.
	-- @number g Minimum green value.
	-- @number b Minimum blue value.
	-- @number a Minimum alpha value.
	-- @treturn color Limited colour.
	function util.ColorLimit(color, r, g, b, a)
		return Color(
			math.min(color.r, r),
			math.min(color.g, g),
			math.min(color.b, b),
			math.min(color.a, a)
		)
	end

	--- (CLIENT) Gets the string version of a colour.
	-- @color color Colour to get string from.
	-- @bool bExcludeAlpha Whether or not to include the alpha in the string.
	-- @treturn string Colour string.
	function util.ColorString(color, bExcludeAlpha)
		return color.r .. "," .. color.g .. "," .. color.b .. (!bExcludeAlpha and "," .. color.a or "")
	end

	--- (CLIENT) Draws a coloured rectangle.
	-- @number x X coordinate.
	-- @number y Y coordinate.
	-- @number w Width of rectangle.
	-- @number h Height of rectangle.
	-- @color col Colour of rectangle.
	function draw.SimpleRect(x, y, w, h, col)
		surface.SetDrawColor(col)
		surface.DrawRect(x, y, w, h)
	end

	--- (CLIENT) Draws a coloured rectangle outline.
	-- @number x X coordinate.
	-- @number y Y coordinate.
	-- @number w Width of rectangle.
	-- @number h Height of rectangle.
	-- @color col Colour of rectangle.
	function draw.SimpleOutlined(x, y, w, h, col)
		surface.SetDrawColor(col)
		surface.DrawOutlinedRect(x, y, w, h)
	end

	--- (CLIENT) Draws two coloured rectangle outlines.
	-- @number x X coordinate.
	-- @number y Y coordinate.
	-- @number w Width of rectangle.
	-- @number h Height of rectangle.
	-- @color col Colour of rectangle.
	function draw.DoubleOutlined(x, y, w, h, col)
		surface.SetDrawColor(col)
		surface.DrawOutlinedRect(x, y, w, h)
		surface.DrawOutlinedRect(x +1, y +1, w -2, h -2)
	end

	--- (CLIENT) Draws a coloured rectangle with a material.
	-- @number x X coordinate.
	-- @number y Y coordinate.
	-- @number w Width of rectangle.
	-- @number h Height of rectangle.
	-- @color color Colour of rectangle.
	-- @material material Material to draw with.
	function draw.Material(x, y, w, h, color, material)
		surface.SetDrawColor(color)
		surface.SetMaterial(material)
		surface.DrawTexturedRect(x, y, w, h)
	end

	--- (CLIENT) Draws a coloured rotated rectangle with a material.
	-- @number x X coordinate.
	-- @number y Y coordinate.
	-- @number w Width of rectangle.
	-- @number h Height of rectangle.
	-- @color color Colour of rectangle.
	-- @material material Material to draw with.
	-- @number rotated Amount to rotate rectangle by.
	function draw.MaterialRotated(x, y, w, h, color, material, rotated)
		surface.SetDrawColor(color)
		surface.SetMaterial(material)
		surface.DrawTexturedRectRotated(x, y, w, h, rotated)
	end

	--- (CLIENT) Draws a coloured rectangle with a texture.
	-- @number x X coordinate.
	-- @number y Y coordinate.
	-- @number w Width of rectangle.
	-- @number h Height of rectangle.
	-- @color color Colour of rectangle.
	-- @texture texture Texture to draw with.
	function draw.Texture(x, y, w, h, color, texture)
		surface.SetDrawColor(color)
		surface.SetTexture(texture)
		surface.DrawTexturedRect(x, y, w, h)
	end

	--- (CLIENT) Draws a coloured rotated rectangle with a texture.
	-- @number x X coordinate.
	-- @number y Y coordinate.
	-- @number w Width of rectangle.
	-- @number h Height of rectangle.
	-- @color color Colour of rectangle.
	-- @texture texture Texture to draw with.
	-- @number rotated Amount to rotate rectangle by.
	function draw.TextureRotated(x, y, w, h, color, texture, rotated)
		surface.SetDrawColor(color)
		surface.SetTexture(texture)
		surface.DrawTexturedRectRotated(x, y, w, h, rotated)
	end

	--- (CLIENT) Draws text with an outline.
	-- @string text Text to draw.
	-- @string font Font to use.
	-- @number x X coordinate.
	-- @number y Y coordinate.
	-- @color col Colour of text.
	-- @color colOutline Colour of outline.
	-- @number xAlign Horizontal alignment.
	-- @number yAlign Vertical alignment.
	-- @number outline Outline width.
	function draw.SimpleTextOutline(text, font, x, y, col, colOutline, xAlign, yAlign, outline)
		draw.SimpleText(text, font, x +(outline or 1), y +(outline or 1), colOutline, xAlign, yAlign)
		draw.SimpleText(text, font, x, y, col, xAlign, yAlign)
	end

	--- (CLIENT) Gets the size of text with a given font.
	-- @string font Font to use.
	-- @string text Text to use.
	-- @treturn number Width of text.
	-- @treturn number Height of text.
	function util.GetTextSize(font, text)
		surface.SetFont(font)

		local w, h = surface.GetTextSize(text)

		return w, h
	end

	--- (CLIENT) Creates a parented label.
	-- @panel parent Panel to parent to.
	-- @string title Text for the label.
	-- @color col Colour of text.
	-- @string font Font to use.
	-- @number x X coordinate.
	-- @number y Y coordinate.
	-- @treturn panel Created label.
	function util.simpleLabel(parent, title, col, font, x, y)
		local DLabel = nil

		if (parent != nil) then
			DLabel = vgui.Create("DLabel", parent)
		else
			DLabel = vgui.Create("DLabel")
		end

		if (x and y) then
			DLabel:SetPos(x, y)
		end

		if (col) then
			DLabel:SetColor(col)
		end

		DLabel:SetText(title)
		DLabel:SetFont(font)
		DLabel:SizeToContents()

		return DLabel
	end;

	--- (CLIENT) Creates a parented button.
	-- @panel parent Panel to parent to.
	-- @number x X coordinate.
	-- @number y Y coordinate.
	-- @number w Width of button.
	-- @number h Height of button.
	-- @string text Text for the button.
	-- @bool bDisabled Whether or not the button is disabled.
	-- @func func Callback to use when button is clicked.
	-- @treturn panel Created button.
	function util.simpleButton(parent, x, y, w, h, text, bDisabled, func)
		local DButton = nil

		if (parent != nil) then
			DButton = vgui.Create("DButton", parent)
		else
			DButton = vgui.Create("DButton")
		end

		DButton:SetText(text)

		if (w and h) then
			DButton:SetSize(w, h)
		end

		if (x and y) then
			DButton:SetPos(x, y)
		end

		DButton:SetDisabled(bDisabled)
		DButton.DoClick = func

		return DButton
	end

	--- (CLIENT) Creates a visual request for an input string.
	-- @string title Title of request.
	-- @param ... Options to use.
	-- @usage util.CreateStringRequest("Please enter a string!", function(text) print(text) end, "Okay", function(text) end, "Cancel");
	function util.CreateStringRequest(title, ...)
		local arguments = {...}

		if (#arguments == 0) then
			return;
		end;

		local buttons = {};

		local dialog = vgui.Create("tiger.panel");
		dialog:SetTitle(title, false);
		dialog:SetSize(350, 150);
		dialog:Center();
		dialog:MakePopup();
		dialog:DockPadding(24, 24, 24, 48);

		local textEntry = dialog:Add("DTextEntry");
		textEntry:SetTall(20);
		textEntry:SetSkin("serverguard");
		textEntry:Dock(TOP);

		for k, v in ipairs(arguments) do
			if (isfunction(v)) then
				local arg = arguments[k + 1]

				if (!arg or not isstring(arg)) then
					continue;
				end;

				local button = dialog:Add("tiger.button");
				button:SetText(arg);
				button:SizeToContents();

				function button:DoClick()
					v(textEntry:GetValue());

					dialog:Remove();
				end;

				table.insert(buttons, button);
			end;
		end;

		function dialog:PerformLayout(width, height)
			local button = buttons[1]

			if (button) then
				button:SetPos(width - (button:GetWide() + 24), height - (button:GetTall() + 14));

				for i = 2, #buttons do
					buttons[i]:SetPos(0, height - (buttons[i]:GetTall() + 14));
					buttons[i]:MoveLeftOf(button, 14);
				end;
			end;
		end;
	end;

	--- (CLIENT) Creates a dialog. Prefix option strings with "&" to make the button text bold.
	-- @string title Title of dialog.
	-- @string text Text for dialog.
	-- @param ... Options to use.
	-- @usage util.CreateDialog("Test", "This is simply a test dialog.", function() print("Clicked okay!") end, "&Okay", function() end, "Cancel");
	function util.CreateDialog(title, text, ...)
		local arguments = {...}

		local dialog = vgui.Create("tiger.dialog")
		dialog:SetTitle(title)
		dialog:SetText(text)

		for k, v in ipairs(arguments) do
			if (isfunction(v)) then
				local arg = arguments[k + 1]

				if (!arg or not isstring(arg)) then
					continue;
				end;

				local buttonText = arguments[k + 1]

				dialog:AddButton(buttonText, function()
					v()
					dialog:FadeOut(0.5, function()
						dialog:Remove()
					end)
				end)
			end
		end

		dialog:SizeToContents()
		dialog:Center()
		dialog:MakePopup()
		dialog:FadeIn()

		return dialog
	end

	--- (CLIENT) Creates multiple derma controls.
	-- @param object[opt] parent The parent control.
	-- @param ... The controls to create.
	-- @usage local label, button = util.CreateControls(parent, "DLabel", "tiger.button");
	-- @usage local panel, label, button = util.CreateControls("tiger.panel", "DLabel", "tiger.button");
	function util.CreateControls(parent, ...)
		local controls = {};
		local bCreatedParent = false;

		if (isstring(parent)) then
			parent = vgui.Create(parent);
			bCreatedParent = true;
		end;

		for k, v in ipairs({...}) do
			table.insert(controls, vgui.Create(v, parent));
		end;

		if (bCreatedParent) then
			return parent, unpack(controls);
		else
			return unpack(controls);
		end;
	end;

	-- Author: Wizard of Ass
	-- http://www.facepunch.com/threads/1089200?p=32614030&viewfull=1#post32614030

	local DrawText = surface.DrawText
	local SetTextPos = surface.SetTextPos
	local PopModelMatrix = cam.PopModelMatrix
	local PushModelMatrix = cam.PushModelMatrix

	local matrix = Matrix()
	local matrixAngle = Angle(0, 0, 0)
	local matrixScale = Vector(0, 0, 0)
	local matrixTranslation = Vector(0, 0, 0)

	--- (CLIENT) Draws rotated text.
	-- @string text Text to draw.
	-- @number x X coordinate.
	-- @number y Y coordinate.
	-- @number xScale Horizontal scale of text.
	-- @number yScale Vertical scale of text.
	-- @number angle Angle to rotate text by.
	function draw.TextRotated(text, x, y, xScale, yScale, angle)
		matrixAngle.y = angle
		matrix:SetAngle(matrixAngle)

		matrixTranslation.x = x
		matrixTranslation.y = y
		matrix:SetTranslation(matrixTranslation)

		matrixScale.x = xScale
		matrixScale.y = yScale
		matrix:Scale(matrixScale)

		SetTextPos(0, 0)

		PushModelMatrix(matrix)
			DrawText(text)
		PopModelMatrix()
	end

	--- (CLIENT) Draws a circle.
	-- @number x X coordinate.
	-- @number y Y coordinate.
	-- @number radius Radius of circle.
	-- @number segments Number of line segments to use.
	function draw.Circle(x, y, radius, segments)
		local points = {};

		table.insert(points, {
			x = x,
			y = y,
			u = 0.5,
			v = 0.5
		});

		for i = 0, segments do
			local angle = math.rad((i / segments) * -360);

			table.insert(points, {
				x = x + math.sin(angle) * radius,
				y = y + math.cos(angle) * radius,
				u = math.sin(angle) / 2 + 0.5,
				v = math.cos(angle) / 2 + 0.5
			});
		end;

		local angle = math.rad(0);

		table.insert(points, {
			x = x + math.sin(angle) * radius,
			y = y + math.cos(angle) * radius,
			u = math.sin(angle) / 2 + 0.5,
			v = math.cos(angle) / 2 + 0.5
		});

		surface.DrawPoly(points);
	end;
end;
