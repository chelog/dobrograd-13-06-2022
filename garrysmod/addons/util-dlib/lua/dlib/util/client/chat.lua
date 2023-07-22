
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

local chat = setmetatable(DLib.chat or {}, {__index = chat})
DLib.chat = chat

--[[
	@doc
	@fname DLib.CMessageChat
	@args table target, string addonName

	@desc
	calls `DLib.CMessage` and then adds networked chat messaging functions
	@enddesc

	@returns
	table: target
]]
function chat.registerChat(vname, ...)
	local nw = 'DLib.AddChatText.' .. vname
	local nwL = 'DLib.AddChatTextL.' .. vname
	local values = {...}
	local func = values[1]
	local func2 = values[2]

	if type(func) ~= 'function' then
		net.receive(nw, function()
			chat.AddText(unpack(table.unshift(net.ReadArray(), unpack(values))))
		end)

		net.receive(nwL, function()
			chat.AddTextLocalized(unpack(table.unshift(net.ReadArray(), unpack(values))))
		end)
	else
		net.receive(nw, function()
			chat.AddText(func(net.ReadArray()))
		end)

		if type(func2) ~= 'function' then
			net.receive(nwL, function()
				chat.AddTextLocalized(func(net.ReadArray()))
			end)
		else
			net.receive(nwL, function()
				local arr = net.ReadArray()
				chat.AddText(func2(arr))
			end)
		end
	end

	return nw
end

function chat.registerWithMessages(target, vname, ...)
	target = target or {}
	DLib.CMessage(target, vname)

	local function input(incomingTable)
		return unpack(target.FormatMessage(unpack(incomingTable)))
	end

	local function inputL(incomingTable)
		return unpack(target.LFormatMessage(unpack(incomingTable)))
	end

	chat.registerChat(vname, input, inputL, ...)
	return target
end

chat.RegisterWithMessages = chat.registerWithMessages
DLib.CMessageChat = chat.registerWithMessages
chat.RegisterChat = chat.registerChat

chat.registerChat('default')
