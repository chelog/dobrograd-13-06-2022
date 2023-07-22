
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


local LocalPlayer = LocalPlayer
local net = net
local plyMeta = FindMetaTable('Player')
local cl_dlib_steamfriends = CreateClientConVar('cl_dlib_steamfriends', '1', true, true, 'Consider Steam friends as DLib friends')

DLib.getinfo.Replicate('cl_dlib_steamfriends')

plyMeta.GetFriendStatusDLib = plyMeta.GetFriendStatusDLib or plyMeta.GetFriendStatus

--[[
	@doc
	@replaces
	@fname Player:GetFriendStatus
	@args Player targetPly

	@desc
	without player argument is same as described in !g:Player:GetFriendStatus
	otherwise returns value based on whenever `self` player is a friend towards `targetPly`
	@enddesc

	@returns
	string
]]
function plyMeta:GetFriendStatus(targetPly)
	if not targetPly then
		return self:GetFriendStatusDLib()
	end

	if not IsValid(targetPly) then
		return 'none'
	end

	if self == LocalPlayer() then
		return targetPly:GetFriendStatusDLib()
	end

	local status = self.DLibFriends
	return status and status[targetPly] or 'none'
end

--[[
	@doc
	@fname Player:IsFriend
	@args Player targetPly

	@returns
	boolean
]]
function plyMeta:IsFriend(target)
	local f = self:GetFriendStatus(target)
	return f == 'friend'
end

local function checkFriendDisable(self)
	if self == LocalPlayer() then
		return cl_dlib_steamfriends:GetBool()
	elseif IsValid(self) then
		return self:GetInfoBool('cl_dlib_steamfriends', true)
	end

	return true
end

--[[
	@doc
	@fname Player:IsFriend2
	@args Player targetPly

	@desc
	behavior can be changed by either of involved players
	@enddesc

	@returns
	boolean
]]
function plyMeta:IsFriend2(target)
	if not checkFriendDisable(self) then return false end
	if not checkFriendDisable(target) then return false end

	local f = self:GetFriendStatus(target)
	return f == 'friend'
end

--[[
	@doc
	@fname Player:IsSteamFriend
	@args Player targetPly

	@returns
	boolean
]]

function plyMeta:IsSteamFriend(target)
	local f = self:GetFriendStatus(target)
	return f == 'friend'
end

--[[
	@doc
	@fname Player:IsSteamFriend2
	@args Player targetPly

	@desc
	behavior can be changed by either of involved players
	@enddesc

	@returns
	boolean
]]
function plyMeta:IsSteamFriend2(target)
	if not checkFriendDisable(self) then return false end
	if not checkFriendDisable(target) then return false end

	local f = self:GetFriendStatus(target)
	return f == 'friend'
end

--[[
	@doc
	@fname Player:IsSteamBlocked
	@args Player targetPly

	@returns
	boolean
]]
function plyMeta:IsSteamBlocked(target)
	local f = self:GetFriendStatus(target)
	return f == 'blocked'
end

local knownStatus = {}
local enums = DLib.Enum('none', 'friend', 'blocked', 'requested')
local IsValid = FindMetaTable('Entity').IsValid

local function update()
	local dirty = false

	for ply, status in pairs(knownStatus) do
		if not IsValid(ply) then
			dirty = true
			knownStatus[ply] = nil
		end
	end

	for i, ply in ipairs(player.GetAll()) do
		local newstatus = ply:GetFriendStatus()

		if knownStatus[ply] ~= newstatus then
			knownStatus[ply] = newstatus
			dirty = true
		end
	end

	if dirty then
		net.Start('DLib.friendstatus')

		net.WriteUInt(table.Count(knownStatus), 8)

		for ply, status in pairs(knownStatus) do
			net.WritePlayer(ply)
			enums:write(status)
		end

		net.SendToServer()
	end
end

timer.Create('DLib.FriendStatus', 5, 0, update)

local function friendstatus()
	local ply = net.ReadPlayer()
	if not IsValid(ply) then return end

	local amount = net.ReadUInt(8)
	ply.DLibFriends = {}
	local status = ply.DLibFriends

	for i = 1, amount do
		local readPly = net.ReadPlayer()
		local readEnum = enums:read()

		if IsValid(readPly) then
			status[readPly] = readEnum
		end
	end
end

net.receive('DLib.friendstatus', friendstatus)
