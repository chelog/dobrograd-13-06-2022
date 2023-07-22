--[[
	Functions imported from ULib.

	https://github.com/TeamUlysses/ulib/blob/master/lua/ulib/shared/misc.lua
--]]

plugin.ulx = {};
plugin.ulib = plugin.ulx; -- Alias.

local function explode( separator, str, limit )
	local t = {}
	local curpos = 1
	while true do -- We have a break in the loop
		local newpos, endpos = str:find( separator, curpos ) -- find the next separator in the string
		if newpos ~= nil then -- if found then..
			table.insert( t, str:sub( curpos, newpos - 1 ) ) -- Save it in our table.
			curpos = endpos + 1 -- save just after where we found it for searching next time.
		else
			if limit and table.getn( t ) > limit then
				return t -- Reached limit
			end
			table.insert( t, str:sub( curpos ) ) -- Save what's left in our array.
			break
		end
	end

	return t
end

local function unescapeBackslash( s )
	return s:gsub( "\\\\", "\\" )
end

local function splitArgs( args, start_token, end_token )
	args = args:Trim()
	local argv = {}
	local curpos = 1 -- Our current position within the string
	local in_quote = false -- Is the text we're currently processing in a quote?
	start_token = start_token or "\""
	end_token = end_token or "\""
	local args_len = args:len()

	while in_quote or curpos <= args_len do
		local quotepos = args:find( in_quote and end_token or start_token, curpos, true )

		-- The string up to the quote, the whole string if no quote was found
		local prefix = args:sub( curpos, (quotepos or 0) - 1 )
		if not in_quote then
			local trimmed = prefix:Trim()
			if trimmed ~= "" then -- Something to be had from this...
				local t = explode( "%s+", trimmed )
				table.Add( argv, t )
			end
		else
			table.insert( argv, prefix )
		end

		-- If a quote was found, reduce our position and note our state
		if quotepos ~= nil then
			curpos = quotepos + 1
			in_quote = not in_quote
		else -- Otherwise we've processed the whole string now
			break
		end
	end

	return argv, in_quote
end

local function parseKeyValues( str, convert )
	local lines = explode( "\r?\n", str )
	local parent_tables = {} -- Traces our way to root
	local current_table = {}
	local is_insert_last_op = false

	for i, line in ipairs( lines ) do
		local tmp_string = string.char( 01, 02, 03 ) -- Replacement
		local tokens = splitArgs( (line:gsub( "\\\"", tmp_string )) )
		for i, token in ipairs( tokens ) do
			tokens[ i ] = unescapeBackslash( token ):gsub( tmp_string, "\"" )
		end

		local num_tokens = #tokens

		if num_tokens == 1 then
			local token = tokens[ 1 ]
			if token == "{" then
				local new_table = {}
				if is_insert_last_op then
					current_table[ table.remove( current_table ) ] = new_table
				else
					table.insert( current_table, new_table )
				end
				is_insert_last_op = false
				table.insert( parent_tables, current_table )
				current_table = new_table

			elseif token == "}" then
				is_insert_last_op = false
				current_table = table.remove( parent_tables )
				if current_table == nil then
					return nil, "Mismatched recursive tables on line " .. i
				end

			else
				is_insert_last_op = true
				table.insert( current_table, tokens[ 1 ] )
			end

		elseif num_tokens == 2 then
			is_insert_last_op = false
			if convert and tonumber( tokens[ 1 ] ) then
				tokens[ 1 ] = tonumber( tokens[ 1 ] )
			end

			current_table[ tokens[ 1 ] ] = tokens[ 2 ]

		elseif num_tokens > 2 then
			return nil, "Bad input on line " .. i
		end
	end

	if #parent_tables ~= 0 then
		return nil, "Mismatched recursive tables"
	end

	if convert and table.Count( current_table ) == 1 and
		type( current_table.Out ) == "table" then -- If we caught a stupid garry-wrapper

		current_table = current_table.Out
	end

	return current_table
end

function plugin.ulx:bans()
	local bans = file.Read("ulib/bans.txt");

	if (!bans) then
		return false, "no ban data found";
	end;

	local bSuccess, bans = xpcall(parseKeyValues, function() end, bans);

	if (bSuccess) then
		local currentTime = os.time();

		for k, v in pairs(bans) do
			local unbanTime = v.unban;
			local translatedTime = math.ceil((unbanTime - currentTime) / 60);

			if (translatedTime >= 0) then
				serverguard:BanPlayer(nil, k, translatedTime, v.reason, nil, true, string.match(v.admin, "(.+)%("));
			end;
		end;

		return true;
	else
		return false, "can't parse key values";
	end;
end;