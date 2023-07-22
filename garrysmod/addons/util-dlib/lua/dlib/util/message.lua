
-- Copyright (C) 2017-2020 DBotThePony

-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
-- of the Software, and to permit persons to whom the Software is furnished to do so,
-- subject to the following conditions:

-- The above copyright notice and this permission notice shall be included in all copies
-- or substantial portions of the Software.

-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
-- INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
-- PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
-- FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
-- OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
-- DEALINGS IN THE SOFTWARE.


local table = table
local DLib = DLib

-- this WILL break EPOE
-- local MsgC = MsgC
-- local Msg = Msg

local type = type
local net = net

local function RepackMessage(strIn)
	local output = {}

	for line in string.gmatch(strIn, '([^ ]+)') do
		if #output ~= 0 then
			table.insert(output, ' ')
		end

		table.insert(output, line)
	end

	return output
end

local DEFAULT_TEXT_COLOR = Color(200, 200, 200)
local WARNING_COLOR = Color(239, 215, 52)
local ERROR_COLOR = Color(239, 78, 52)
local BOOLEAN_COLOR = Color(69, 112, 235)
local NUMBER_COLOR = Color(245, 199, 64)
local STEAMID_COLOR = Color(255, 255, 255)
local ENTITY_COLOR = Color(180, 232, 180)
local NPC_COLOR = Color(116, 193, 209)
local NEXTBOT_COLOR = Color(84, 196, 121)
local WEAPON_COLOR = Color(189, 82, 122)
local VEHICLE_COLOR = Color(189, 82, 170)
local FUNCTION_COLOR = Color(102, 133, 237)
local TABLE_COLOR = Color(107, 200, 224)
local URL_COLOR = Color(174, 124, 192)
local NIL_COLOR = Color(89, 93, 251)
local COMMENTARY_COLOR = Color(143, 165, 46)

DLib.DEFAULT_TEXT_COLOR = DEFAULT_TEXT_COLOR
DLib.WARNING_COLOR = WARNING_COLOR
DLib.ERROR_COLOR = ERROR_COLOR
DLib.BOOLEAN_COLOR = BOOLEAN_COLOR
DLib.NUMBER_COLOR = NUMBER_COLOR
DLib.STEAMID_COLOR = STEAMID_COLOR
DLib.ENTITY_COLOR = ENTITY_COLOR
DLib.FUNCTION_COLOR = FUNCTION_COLOR
DLib.TABLE_COLOR = TABLE_COLOR
DLib.URL_COLOR = URL_COLOR
DLib.NPC_COLOR = NPC_COLOR
DLib.NEXTBOT_COLOR = NEXTBOT_COLOR
DLib.WEAPON_COLOR = WEAPON_COLOR
DLib.VEHICLE_COLOR = VEHICLE_COLOR
DLib.NIL_COLOR = NIL_COLOR
DLib.COMMENTARY_COLOR = COMMENTARY_COLOR

function DLib.PrettyPrint(val, newline, valType)
	MsgC(DLib.GetPrettyPrint(val, valType))

	if newline == true or newline == nil then
		MsgC('\n')
	end
end

function DLib.GetPrettyPrint(val, valType)
	valType = valType or type(val)

	if valType == 'nil' then
		return BOOLEAN_COLOR, 'nil'
	elseif valType == 'number' then
		return NUMBER_COLOR, tostring(val)
	elseif valType == 'string' then
		if val:find('^https?://') then
			return URL_COLOR, val
		else
			return DEFAULT_TEXT_COLOR, val
		end
	elseif valType == 'Player' then
		local nick = val:Nick()

		if val.SteamName and val:SteamName() ~= val:Nick() then
			nick = nick .. ' (' .. val:SteamName() .. ')'
		end

		return team and team.GetColor(val:Team()) or ENTITY_COLOR, nick, STEAMID_COLOR, '<' .. val:SteamID() .. '>'
	elseif valType == 'Entity' then
		return ENTITY_COLOR, tostring(val)
	elseif valType == 'NPC' then
		return NPC_COLOR, tostring(val)
	elseif valType == 'Vehicle' then
		return VEHICLE_COLOR, tostring(val)
	elseif valType == 'NextBot' then
		return NEXTBOT_COLOR, tostring(val)
	elseif valType == 'Weapon' then
		return WEAPON_COLOR, tostring(val)
	elseif IsColor(val) then
		return FUNCTION_COLOR, tostring(val), val, ' ███'
	elseif valType == 'table' then
		return TABLE_COLOR, string.format('table - %p (%s)', val, tostring(val))
	elseif valType == 'function' then
		local info = debug.getinfo(val)
		return FUNCTION_COLOR, string.format('function - %p', val), COMMENTARY_COLOR, ' --[[ ' .. info.short_src .. ': ' .. (info.lastlinedefined ~= info.linedefined and (info.linedefined .. '-' .. info.lastlinedefined) or info.lastlinedefined) .. ' ]]'
	elseif valType == 'boolean' then
		return BOOLEAN_COLOR, tostring(val)
	elseif valType == 'Vector' then
		return FUNCTION_COLOR, 'Vector', DEFAULT_TEXT_COLOR, '(', NUMBER_COLOR, val.x, DEFAULT_TEXT_COLOR, ', ', NUMBER_COLOR, val.y, DEFAULT_TEXT_COLOR, ', ', NUMBER_COLOR, val.z, DEFAULT_TEXT_COLOR, ')'
	elseif valType == 'Angle' then
		return FUNCTION_COLOR, 'Angle', DEFAULT_TEXT_COLOR, '(', NUMBER_COLOR, val.p, DEFAULT_TEXT_COLOR, ', ', NUMBER_COLOR, val.y, DEFAULT_TEXT_COLOR, ', ', NUMBER_COLOR, val.r, DEFAULT_TEXT_COLOR, ')'
	end

	return DEFAULT_TEXT_COLOR, tostring(val)
end

local function __Format(tabIn, prevColor, output)
	local max = 0

	for k, v in pairs(tabIn) do max = max:max(k) end

	for i = 1, max do
		local val = tabIn[i]
		local valType = type(val)

		if valType == 'nil' then
			table.insert(output, NIL_COLOR:Copy())
			table.insert(output, 'nil')
			table.insert(output, prevColor:Copy())
		elseif valType == 'number' then
			table.insert(output, NUMBER_COLOR:Copy())
			table.insert(output, tostring(val))
			table.insert(output, prevColor:Copy())
		elseif valType == 'string' then
			if val:find('^https?://') then
				table.insert(output, URL_COLOR:Copy())
				table.insert(output, val)
				table.insert(output, prevColor:Copy())
			else
				table.insert(output, val)
			end
		elseif valType == 'Player' then
			table.insert(output, team and team.GetColor(val:Team()) or ENTITY_COLOR:Copy())
			table.insert(output, val:Nick())

			if val.SteamName and val:SteamName() ~= val:Nick() then
				table.insert(output, ' (' .. val:SteamName() .. ')')
			end

			table.insert(output, STEAMID_COLOR:Copy())
			table.insert(output, '<' .. val:SteamID() .. '>')
			table.insert(output, prevColor:Copy())
		elseif valType == 'Entity' then
			table.insert(output, ENTITY_COLOR:Copy())
			table.insert(output, tostring(val))
			table.insert(output, prevColor:Copy())
		elseif valType == 'NPC' then
			table.insert(output, NPC_COLOR:Copy())
			table.insert(output, tostring(val))
			table.insert(output, prevColor:Copy())
		elseif valType == 'Vehicle' then
			table.insert(output, VEHICLE_COLOR:Copy())
			table.insert(output, tostring(val))
			table.insert(output, prevColor:Copy())
		elseif valType == 'NextBot' then
			table.insert(output, NEXTBOT_COLOR:Copy())
			table.insert(output, tostring(val))
			table.insert(output, prevColor:Copy())
		elseif valType == 'Weapon' then
			table.insert(output, WEAPON_COLOR:Copy())
			table.insert(output, tostring(val))
			table.insert(output, prevColor:Copy())
		elseif IsColor(val) then
			table.insert(output, val)
			prevColor = val
		elseif valType == 'table' then
			table.insert(output, TABLE_COLOR:Copy())
			table.insert(output, tostring(val))
			table.insert(output, prevColor:Copy())
		elseif valType == 'function' then
			table.insert(output, FUNCTION_COLOR:Copy())
			table.insert(output, string.format('function - %p', val))
			table.insert(output, COMMENTARY_COLOR:Copy())
			local info = debug.getinfo(val)
			table.insert(output, ' --[[ ' .. info.short_src .. ': ' .. (info.lastlinedefined ~= info.linedefined and (info.linedefined .. '-' .. info.lastlinedefined) or info.lastlinedefined) .. ' ]]')
			table.insert(output, prevColor:Copy())
		elseif valType == 'boolean' then
			table.insert(output, BOOLEAN_COLOR:Copy())
			table.insert(output, tostring(val))
			table.insert(output, prevColor:Copy())
		elseif valType == 'Vector' then
			table.insert(output, FUNCTION_COLOR:Copy())
			table.insert(output, 'Vector')
			table.insert(output, DEFAULT_TEXT_COLOR:Copy())
			table.insert(output, '(')

			table.insert(output, NUMBER_COLOR:Copy())
			table.insert(output, tostring(val.x))
			table.insert(output, DEFAULT_TEXT_COLOR:Copy())
			table.insert(output, ', ')

			table.insert(output, NUMBER_COLOR:Copy())
			table.insert(output, tostring(val.y))
			table.insert(output, DEFAULT_TEXT_COLOR:Copy())
			table.insert(output, ', ')

			table.insert(output, NUMBER_COLOR:Copy())
			table.insert(output, tostring(val.z))

			table.insert(output, DEFAULT_TEXT_COLOR:Copy())
			table.insert(output, ')')
		elseif valType == 'Angle' then
			table.insert(output, FUNCTION_COLOR:Copy())
			table.insert(output, 'Angle')
			table.insert(output, DEFAULT_TEXT_COLOR:Copy())
			table.insert(output, '(')

			table.insert(output, NUMBER_COLOR:Copy())
			table.insert(output, tostring(val.p))
			table.insert(output, DEFAULT_TEXT_COLOR:Copy())
			table.insert(output, ', ')

			table.insert(output, NUMBER_COLOR:Copy())
			table.insert(output, tostring(val.y))
			table.insert(output, DEFAULT_TEXT_COLOR:Copy())
			table.insert(output, ', ')

			table.insert(output, NUMBER_COLOR:Copy())
			table.insert(output, tostring(val.r))

			table.insert(output, DEFAULT_TEXT_COLOR:Copy())
			table.insert(output, ')')
		else
			table.insert(output, tostring(val))
		end
	end
end

local function FormatMessageRegular(tabIn)
	local prevColor = DEFAULT_TEXT_COLOR
	local output = {prevColor}

	__Format(tabIn, prevColor, output)

	return output
end

local function FormatMessageWarning(tabIn)
	local prevColor = WARNING_COLOR
	local output = {prevColor}

	__Format(tabIn, prevColor, output)

	return output
end

local function FormatMessageError(tabIn)
	local prevColor = ERROR_COLOR
	local output = {prevColor}

	__Format(tabIn, prevColor, output)

	return output
end

local LocalPlayer = LocalPlayer

--[[
	@doc
	@fname DLib.CMessage
	@args table target, string addonName, Color prefixColor = Color(0, 200, 0)

	@desc
	Defines messaging function
	function list it provide (defines) in `target` table is available
	under `CMessage` library (pseudo library, it doesn't actually exist on runtime)
	@enddesc

	@returns
	table: target
]]

--[[
	@doc
	@fname CMessage.Message
	@args vargarg values

	@desc
	formats and prints a console message
	@enddesc

	@returns
	table: formatted table of arguments printed to console
]]

--[[
	@doc
	@fname CMessage.MessageWarning
	@args vargarg values

	@desc
	differs from `CMessage.Message` only by default text color (yellow)
	@enddesc

	@returns
	table: formatted table of arguments printed to console
]]

--[[
	@doc
	@fname CMessage.MessageError
	@args vargarg values

	@desc
	differs from `CMessage.Message` only by default text color (red)
	@enddesc

	@returns
	table: formatted table of arguments printed to console
]]

--[[
	@doc
	@fname CMessage.LMessage
	@args vargarg values

	@desc
	formats and prints a console message
	differs from `Message` by formatting string values with i18n library
	`LocalizedMessage`
	@enddesc

	@returns
	table: formatted table of arguments printed to console
]]

--[[
	@doc
	@fname CMessage.LMessageWarning
	@args vargarg values

	@desc
	differs from `CMessage.LMessage` only by default text color (yellow)
	@enddesc

	@returns
	table: formatted table of arguments printed to console
]]

--[[
	@doc
	@fname CMessage.LMessageError
	@args vargarg values

	@desc
	differs from `CMessage.LMessage` only by default text color (red)
	@enddesc

	@returns
	table: formatted table of arguments printed to console
]]

--[[
	@doc
	@fname CMessage.MessagePlayer
	@args Player ply, vargarg values

	@desc
	same as it's corresponding part but sends message to player's console.
	player can be a NULL entity. if so, prints to server console.
	calling clientside always prints to local console.
	@enddesc

	@returns
	table: formatted table of arguments printed to console
]]

--[[
	@doc
	@fname CMessage.MessageWarningPlayer
	@args vargarg values

	@desc
	same as it's corresponding part but sends message to player's console.
	player can be a NULL entity. if so, prints to server console.
	calling clientside always prints to local console.
	@enddesc

	@returns
	table: formatted table of arguments printed to console
]]

--[[
	@doc
	@fname CMessage.MessageErrorPlayer
	@args vargarg values

	@desc
	same as it's corresponding part but sends message to player's console.
	player can be a NULL entity. if so, prints to server console.
	calling clientside always prints to local console.
	@enddesc


	@returns
	table: formatted table of arguments printed to console
]]

--[[
	@doc
	@fname CMessage.LMessagePlayer
	@args vargarg values

	@desc
	same as it's corresponding part but sends message to player's console.
	player can be a NULL entity. if so, prints to server console.
	calling clientside always prints to local console.
	@enddesc

	@returns
	table: formatted table of arguments printed to console
]]

--[[
	@doc
	@fname CMessage.LMessageWarningPlayer
	@args vargarg values

	@desc
	same as it's corresponding part but sends message to player's console.
	player can be a NULL entity. if so, prints to server console.
	calling clientside always prints to local console.
	@enddesc

	@returns
	table: formatted table of arguments printed to console
]]

--[[
	@doc
	@fname CMessage.LMessageErrorPlayer
	@args vargarg values

	@desc
	same as it's corresponding part but sends message to player's console.
	player can be a NULL entity. if so, prints to server console.
	calling clientside always prints to local console.
	@enddesc

	@returns
	table: formatted table of arguments printed to console
]]

--[[
	@doc
	@fname CMessage.MessageAll
	@args vargarg values

	@server

	@returns
	table: formatted table of arguments printed to console
]]

--[[
	@doc
	@fname CMessage.MessageWarningAll
	@args vargarg values

	@server

	@returns
	table: formatted table of arguments printed to console
]]

--[[
	@doc
	@fname CMessage.MessageErrorAll
	@args vargarg values

	@server

	@returns
	table: formatted table of arguments printed to console
]]

--[[
	@doc
	@fname CMessage.LMessageAll
	@args vargarg values

	@server

	@returns
	table: formatted table of arguments printed to console
]]

--[[
	@doc
	@fname CMessage.LMessageWarningAll
	@args vargarg values

	@server

	@returns
	table: formatted table of arguments printed to console
]]

--[[
	@doc
	@fname CMessage.LMessageErrorAll
	@args vargarg values

	@server

	@returns
	table: formatted table of arguments printed to console
]]

--[[
	@doc
	@fname CMessage.Chat
	@args vargarg values

	@client

	@desc
	same as it's `Message` counterpart but for printing in chat
	@enddesc

	@returns
	table: formatted table of arguments printed to chat
]]

--[[
	@doc
	@fname CMessage.ChatWarning
	@args vargarg values

	@client

	@desc
	same as it's `MessageWarning` counterpart but for printing in chat
	@enddesc

	@returns
	table: formatted table of arguments printed to chat
]]

--[[
	@doc
	@fname CMessage.ChatError
	@args vargarg values

	@client

	@desc
	same as it's `MessageError` counterpart but for printing in chat
	@enddesc

	@returns
	table: formatted table of arguments printed to chat
]]

--[[
	@doc
	@fname CMessage.LChat
	@args vargarg values

	@client

	@desc
	same as it's `LMessage` counterpart but for printing in chat
	@enddesc

	@returns
	table: formatted table of arguments printed to chat
]]

--[[
	@doc
	@fname CMessage.LChatWarning
	@args vargarg values

	@client

	@desc
	same as it's `LMessageWarning` counterpart but for printing in chat
	@enddesc

	@returns
	table: formatted table of arguments printed to chat
]]

--[[
	@doc
	@fname CMessage.LChatError
	@args vargarg values

	@client

	@desc
	same as it's `LMessageError` counterpart but for printing in chat
	@enddesc

	@returns
	table: formatted table of arguments printed to chat
]]
return function(tableTarget, moduleName, moduleColor)
	local nwname = 'DLib.Message.' .. util.CRC(moduleName)
	local nwnameL = 'DLib.Message.' .. util.CRC(moduleName) .. '.L'
	local nwnameW = 'DLib.MessageW.' .. util.CRC(moduleName)
	local nwnameWL = 'DLib.MessageW.' .. util.CRC(moduleName) .. '.L'
	local nwnameE = 'DLib.MessageE.' .. util.CRC(moduleName)
	local nwnameEL = 'DLib.MessageE.' .. util.CRC(moduleName) .. '.L'

	if SERVER then
		net.pool(nwname)
		net.pool(nwnameW)
		net.pool(nwnameE)
		net.pool(nwnameL)
		net.pool(nwnameWL)
		net.pool(nwnameEL)
	end

	local PREFIX = '[' .. moduleName .. '] '
	local PREFIX_COLOR = moduleColor or Color(0, 200, 0)

	local function Message(...)
		local formatted = FormatMessageRegular({...})
		MsgC(PREFIX_COLOR, PREFIX, unpack(formatted))
		MsgC('\n')
		return formatted
	end

	local function LMessage(...)
		local formatted = FormatMessageRegular(DLib.i18n.rebuildTable({...}, DEFAULT_TEXT_COLOR))
		MsgC(PREFIX_COLOR, PREFIX, unpack(formatted))
		MsgC('\n')
		return formatted
	end

	local function Warning(...)
		local formatted = FormatMessageWarning({...})
		MsgC(PREFIX_COLOR, PREFIX, unpack(formatted))
		MsgC('\n')
		return formatted
	end

	local function LWarning(...)
		local formatted = FormatMessageWarning(DLib.i18n.rebuildTable({...}, WARNING_COLOR))
		MsgC(PREFIX_COLOR, PREFIX, unpack(formatted))
		MsgC('\n')
		return formatted
	end

	local function PrintError(...)
		local formatted = FormatMessageError({...})
		MsgC(PREFIX_COLOR, PREFIX, unpack(formatted))
		MsgC('\n')
		return formatted
	end

	local function LPrintError(...)
		local formatted = FormatMessageError(DLib.i18n.rebuildTable({...}, ERROR_COLOR))
		MsgC(PREFIX_COLOR, PREFIX, unpack(formatted))
		MsgC('\n')
		return formatted
	end

	local function Chat(...)
		local formatted = FormatMessageRegular({...})
		chat.AddText(PREFIX_COLOR, PREFIX, DEFAULT_TEXT_COLOR, unpack(formatted))
		return formatted
	end

	local function LChat(...)
		local formatted = FormatMessageRegular(DLib.i18n.rebuildTable({...}, DEFAULT_TEXT_COLOR))
		chat.AddText(PREFIX_COLOR, PREFIX, DEFAULT_TEXT_COLOR, unpack(formatted))
		return formatted
	end

	local function ChatError(...)
		local formatted = FormatMessageError({...})
		chat.AddText(PREFIX_COLOR, PREFIX, ERROR_COLOR, unpack(formatted))
		return formatted
	end

	local function LChatError(...)
		local formatted = FormatMessageError(DLib.i18n.rebuildTable({...}, ERROR_COLOR))
		chat.AddText(PREFIX_COLOR, PREFIX, ERROR_COLOR, unpack(formatted))
		return formatted
	end

	local function ChatWarn(...)
		local formatted = FormatMessageWarning({...})
		chat.AddText(PREFIX_COLOR, PREFIX, WARNING_COLOR, unpack(formatted))
		return formatted
	end

	local function LChatWarn(...)
		local formatted = FormatMessageWarning(DLib.i18n.rebuildTable({...}, WARNING_COLOR))
		chat.AddText(PREFIX_COLOR, PREFIX, WARNING_COLOR, unpack(formatted))
		return formatted
	end

	local function FormatMessage(...)
		return FormatMessageRegular({PREFIX_COLOR, PREFIX, DEFAULT_TEXT_COLOR, ...})
	end

	local function LFormatMessage(...)
		return FormatMessageRegular(DLib.i18n.rebuildTable({PREFIX_COLOR, PREFIX, DEFAULT_TEXT_COLOR, ...}, DEFAULT_TEXT_COLOR))
	end

	local function FormatMessageWarn(...)
		return FormatMessageWarning({PREFIX_COLOR, PREFIX, WARNING_COLOR, ...})
	end

	local function LFormatMessageWarn(...)
		return FormatMessageWarning(DLib.i18n.rebuildTable({PREFIX_COLOR, PREFIX, WARNING_COLOR, ...}, DEFAULT_TEXT_COLOR))
	end

	local function FormatMessageErr(...)
		return FormatMessageError({PREFIX_COLOR, PREFIX, ERROR_COLOR, ...})
	end

	local function LFormatMessageErr(...)
		return FormatMessageError(DLib.i18n.rebuildTable({PREFIX_COLOR, PREFIX, ERROR_COLOR, ...}, DEFAULT_TEXT_COLOR))
	end

	local function FormatMessageRaw(...)
		return FormatMessageRegular({...})
	end

	local function LFormatMessageRaw(...)
		return FormatMessageRegular(DLib.i18n.rebuildTable({...}, DEFAULT_TEXT_COLOR))
	end

	local function FormatMessageWarnRaw(...)
		return FormatMessageWarning({...})
	end

	local function LFormatMessageWarnRaw(...)
		return FormatMessageWarning(DLib.i18n.rebuildTable({...}, DEFAULT_TEXT_COLOR))
	end

	local function FormatMessageErrRaw(...)
		return FormatMessageError({...})
	end

	local function LFormatMessageErrRaw(...)
		return FormatMessageError(DLib.i18n.rebuildTable({...}, DEFAULT_TEXT_COLOR))
	end

	local function MessagePlayer(ply, ...)
		if CLIENT and ply == LocalPlayer() then return Message(...) end
		if CLIENT then return {} end

		if type(ply) == 'table' or type(ply) == 'Player' then
			net.Start(nwname, true)
			net.WriteArray({...})
			net.Send(ply)
		else
			return Message(...)
		end
	end

	local function LMessagePlayer(ply, ...)
		if CLIENT and ply == LocalPlayer() then return LMessage(...) end
		if CLIENT then return {} end

		if type(ply) == 'table' or type(ply) == 'Player' then
			net.Start(nwnameL, true)
			net.WriteArray({...})
			net.Send(ply)
		else
			return LMessage(...)
		end
	end

	local function MessageAll(...)
		if CLIENT then return Message(...) end

		net.Start(nwname, true)
		net.WriteArray({...})
		net.Broadcast()

		return Message(...)
	end

	local function LMessageAll(...)
		if CLIENT then return LMessage(...) end

		net.Start(nwnameL, true)
		net.WriteArray({...})
		net.Broadcast()

		return LMessage(...)
	end

	local function PrintErrorPlayer(ply, ...)
		if CLIENT and ply == LocalPlayer() then return PrintError(...) end
		if CLIENT then return {} end

		if type(ply) == 'table' or type(ply) == 'Player' then
			net.Start(nwnameE, true)
			net.WriteArray({...})
			net.Send(ply)
		else
			return PrintError(...)
		end
	end

	local function LPrintErrorPlayer(ply, ...)
		if CLIENT and ply == LocalPlayer() then return LPrintError(...) end
		if CLIENT then return {} end

		if type(ply) == 'table' or type(ply) == 'Player' then
			net.Start(nwnameEL, true)
			net.WriteArray({...})
			net.Send(ply)
		else
			return LPrintError(...)
		end
	end

	local function PrintErrorAll(...)
		if CLIENT then return PrintError(...) end

		net.Start(nwnameE, true)
		net.WriteArray({...})
		net.Broadcast()

		return PrintError(...)
	end

	local function LPrintErrorAll(...)
		if CLIENT then return LPrintError(...) end

		net.Start(nwnameEL, true)
		net.WriteArray({...})
		net.Broadcast()

		return LPrintError(...)
	end

	local function WarningPlayer(ply, ...)
		if CLIENT and ply == LocalPlayer() then return Warning(...) end
		if CLIENT then return {} end

		if type(ply) == 'table' or type(ply) == 'Player' then
			net.Start(nwnameW, true)
			net.WriteArray({...})
			net.Send(ply)
		else
			return Warning(...)
		end
	end

	local function LWarningPlayer(ply, ...)
		if CLIENT and ply == LocalPlayer() then return LWarning(...) end
		if CLIENT then return {} end

		if type(ply) == 'table' or type(ply) == 'Player' then
			net.Start(nwnameWL, true)
			net.WriteArray({...})
			net.Send(ply)
		else
			return LWarning(...)
		end
	end

	local function WarningAll(...)
		if CLIENT then return Warning(...) end

		net.Start(nwnameW, true)
		net.WriteArray({...})
		net.Broadcast()

		return Warning(...)
	end

	local function LWarningAll(...)
		if CLIENT then return LWarning(...) end

		net.Start(nwnameWL, true)
		net.WriteArray({...})
		net.Broadcast()

		return LWarning(...)
	end

	if CLIENT then
		net.receive(nwname, function()
			local array = net.ReadArray()
			Message(unpack(array))
		end)

		net.receive(nwnameL, function()
			local array = net.ReadArray()
			LMessage(unpack(array))
		end)

		net.receive(nwnameW, function()
			local array = net.ReadArray()
			Warning(unpack(array))
		end)

		net.receive(nwnameWL, function()
			local array = net.ReadArray()
			LWarning(unpack(array))
		end)

		net.receive(nwnameE, function()
			local array = net.ReadArray()
			PrintError(unpack(array))
		end)

		net.receive(nwnameEL, function()
			local array = net.ReadArray()
			LPrintError(unpack(array))
		end)
	end

	local function export(tableTo)
		tableTo.Message = Message
		tableTo.LMessage = LMessage
		tableTo.Warning = Warning
		tableTo.LWarning = LWarning
		tableTo.MessageWarning = Warning
		tableTo.LMessageWarning = LWarning
		tableTo.PrintError = PrintError
		tableTo.LPrintError = LPrintError
		tableTo.MessageError = PrintError
		tableTo.LMessageError = LPrintError

		tableTo.textcolor = Color(DEFAULT_TEXT_COLOR)
		tableTo.textcolorWarn = Color(WARNING_COLOR)
		tableTo.textcolorErr = Color(ERROR_COLOR)
		tableTo.textcolorError = Color(ERROR_COLOR)

		tableTo.RepackMessage = RepackMessage
		tableTo.FormatMessage = FormatMessage
		tableTo.FormatMessageWarning = FormatMessageWarn
		tableTo.FormatMessageWarn = FormatMessageWarn
		tableTo.FormatMessageError = FormatMessageErr
		tableTo.FormatMessageErr = FormatMessageErr

		tableTo.LFormatMessage = LFormatMessage
		tableTo.LFormatMessageWarning = LFormatMessageWarn
		tableTo.LFormatMessageWarn = LFormatMessageWarn
		tableTo.LFormatMessageError = LFormatMessageErr
		tableTo.LFormatMessageErr = LFormatMessageErr

		tableTo.FormatMessageRaw = FormatMessageRaw
		tableTo.FormatMessageWarningRaw = FormatMessageWarnRaw
		tableTo.FormatMessageWarnRaw = FormatMessageWarnRaw
		tableTo.FormatMessageErrorRaw = FormatMessageErrRaw
		tableTo.FormatMessageErrRaw = FormatMessageErrRaw

		tableTo.LFormatMessageRaw = LFormatMessageRaw
		tableTo.LFormatMessageWarningRaw = LFormatMessageWarnRaw
		tableTo.LFormatMessageWarnRaw = LFormatMessageWarnRaw
		tableTo.LFormatMessageErrorRaw = LFormatMessageErrRaw
		tableTo.LFormatMessageErrRaw = LFormatMessageErrRaw

		tableTo.lformatMessage = LFormatMessage
		tableTo.message = Message
		tableTo.lmessage = LMessage
		tableTo.repackMessage = RepackMessage
		tableTo.formatMessage = FormatMessage

		if CLIENT then
			tableTo.Chat = Chat
			tableTo.ChatWarn = ChatWarn
			tableTo.ChatError = ChatError
			tableTo.ChatMessage = Chat
			tableTo.ChatPrint = Chat
			tableTo.ChatPrintWarn = ChatWarn
			tableTo.ChatPrintWarning = ChatWarn
			tableTo.ChatPrintError = ChatError
			tableTo.AddChat = Chat
			tableTo.chatMessage = Chat

			tableTo.LChat = LChat
			tableTo.LChatError = LChatError
			tableTo.LChatWarn = LChatWarn
			tableTo.LChatMessage = LChat
			tableTo.LChatPrint = LChat
			tableTo.LChatPrintWarn = LChatWarn
			tableTo.LChatPrintWarning = LChatWarn
			tableTo.LChatPrintError = LChatError
			tableTo.LAddChat = LChat
			tableTo.lchatMessage = LChat
		else
			tableTo.MessageAll = MessageAll
			tableTo.MessageErrorAll = PrintErrorAll
			tableTo.LMessageErrorAll = LPrintErrorAll
			tableTo.PrintErrorAll = PrintErrorAll
			tableTo.LPrintErrorAll = LPrintErrorAll
			tableTo.MessageWarningAll = WarningAll
			tableTo.WarningAll = WarningAll
			tableTo.MessageWarningAll = WarningAll
			tableTo.LWarningAll = LWarningAll
			tableTo.LMessageWarningAll = LWarningAll
			tableTo.LMessageAll = LMessageAll
		end

		tableTo.MessagePlayer = MessagePlayer
		tableTo.MessageErrorPlayer = PrintErrorPlayer
		tableTo.PrintErrorPlayer = PrintErrorPlayer
		tableTo.WarningPlayer = WarningPlayer
		tableTo.MessageWarningPlayer = WarningPlayer

		tableTo.messagePlayer = MessagePlayer
		tableTo.messageP = MessagePlayer

		tableTo.LMessagePlayer = LMessagePlayer
		tableTo.LPrintErrorPlayer = LPrintErrorPlayer
		tableTo.LWarningPlayer = LWarningPlayer

		tableTo.LMessageErrorPlayer = LPrintErrorPlayer
		tableTo.LMessageWarningPlayer = LWarningPlayer

		tableTo.lmessagePlayer = LMessagePlayer
		tableTo.lmessageP = LMessagePlayer
	end

	tableTarget = tableTarget or {}
	export(tableTarget)
	return export, tableTarget
end
