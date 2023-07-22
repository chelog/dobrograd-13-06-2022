
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


net.pool('DLib.friendstatus')
local IsValid = FindMetaTable('Entity').IsValid
local enums = DLib.Enum('none', 'friend', 'blocked', 'requested')

local table = table
local net = net
local DLib = DLib

DLib.getinfo.Replicate('cl_dlib_steamfriends')

local function friendstatus(len, ply)
	if not IsValid(ply) then return end
	local amount = net.ReadUInt(8)
	ply.DLibFriends = {}
	local status = ply.DLibFriends
	local reply = {}

	for i = 1, amount do
		local readPly = net.ReadPlayer()
		local readEnum = enums:read()

		if IsValid(readPly) then
			status[readPly] = readEnum
			table.insert(reply, {readPly, readEnum})
		end
	end

	if #reply ~= 0 then
		net.Start('DLib.friendstatus')

		net.WritePlayer(ply)
		net.WriteUInt(#reply, 8)

		for i, plyData in ipairs(reply) do
			net.WritePlayer(plyData[1])
			enums:write(plyData[2])
		end

		net.SendOmit(ply)
	end
end

net.receive('DLib.friendstatus', friendstatus)

local plyMeta = FindMetaTable('Player')

function plyMeta:GetFriendStatus(target)
	local status = self.DLibFriends
	return status and status[target] or 'none'
end

function plyMeta:IsFriend(target)
	local f = self:GetFriendStatus(target)
	return f == 'friend' or f == 'requested'
end

function plyMeta:IsFriend2(target)
	if not IsValid(self) or not IsValid(target) then return false end
	if not self:GetInfoBool('cl_dlib_steamfriends', true) then return false end
	if not target:GetInfoBool('cl_dlib_steamfriends', true) then return false end
	local f = self:GetFriendStatus(target)
	return f == 'friend' or f == 'requested'
end

function plyMeta:IsSteamFriend(target)
	local f = self:GetFriendStatus(target)
	return f == 'friend' or f == 'requested'
end

function plyMeta:IsSteamFriend2(target)
	if not IsValid(self) or not IsValid(target) then return false end
	if not self:GetInfoBool('cl_dlib_steamfriends', true) then return false end
	if not target:GetInfoBool('cl_dlib_steamfriends', true) then return false end
	local f = self:GetFriendStatus(target)
	return f == 'friend' or f == 'requested'
end

function plyMeta:IsSteamBlocked(target)
	local f = self:GetFriendStatus(target)
	return f == 'blocked'
end