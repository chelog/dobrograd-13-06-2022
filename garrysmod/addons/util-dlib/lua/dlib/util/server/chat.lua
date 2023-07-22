
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

net.pool('DLib.AddChatText')

local chat = setmetatable(DLib.chat or {}, {__index = chat})
DLib.chat = chat

function chat.generate(name, targetTable)
	local nw = 'DLib.AddChatText.' .. name
	local nwL = 'DLib.AddChatTextL.' .. name
	net.pool(nw)
	net.pool(nwL)

	local newModule = targetTable or {}

	function newModule.chatPlayer(ply, ...)
		net.Start(nw, true)
		net.WriteArray({...})
		net.Send(ply)
	end

	function newModule.lchatPlayer(ply, ...)
		net.Start(nwL, true)
		net.WriteArray({...})
		net.Send(ply)
	end

	function newModule.chatPlayer2(ply, ...)
		if IsValid(ply) and not ply:IsBot() then
			net.Start(nw, true)
			net.WriteArray({...})
			net.Send(ply)
		elseif newModule.Message then
			newModule.Message(ply, ' -> ', ...)
		end
	end

	function newModule.lchatPlayer2(ply, ...)
		if IsValid(ply) and not ply:IsBot() then
			net.Start(nwL, true)
			net.WriteArray({...})
			net.Send(ply)
		elseif newModule.Message then
			newModule.Message(ply, ' -> ', ...)
		end
	end

	function newModule.chatAll(...)
		net.Start(nw, true)
		net.WriteArray({...})
		net.Broadcast()
	end

	function newModule.lchatAll(...)
		net.Start(nwL, true)
		net.WriteArray({...})
		net.Broadcast()
	end

	newModule.ChatPlayer = newModule.chatPlayer
	newModule.ChatPlayer2 = newModule.chatPlayer2
	newModule.LChatPlayer = newModule.lchatPlayer
	newModule.LChatPlayer2 = newModule.lchatPlayer2
	newModule.ChatAll = newModule.chatAll
	newModule.LChatAll = newModule.lchatAll

	return newModule
end

function chat.generateWithMessages(targetTable, name, ...)
	targetTable = targetTable or {}

	DLib.CMessage(targetTable, name, ...)
	chat.generate(name, targetTable, ...)

	targetTable.chatPlayerMessage = targetTable.chatPlayer

	function targetTable.chatPlayer(ply, ...)
		if not IsValid(ply) then
			targetTable.Message(...)
			return
		end

		return targetTable.chatPlayerMessage(ply, ...)
	end

	return targetTable
end

chat.registerWithMessages = chat.generateWithMessages
chat.RegisterWithMessages = chat.generateWithMessages
DLib.CMessageChat = chat.generateWithMessages
chat.RegisterChat = chat.generate

chat.generate('default', chat)

chat.player = chat.chatPlayer
chat.all = chat.chatAll

return chat
