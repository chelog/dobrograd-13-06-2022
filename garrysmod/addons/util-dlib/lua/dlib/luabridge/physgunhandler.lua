
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


if SERVER then
	net.pool('DLib.physgun.player')
	net.pool('DLib.physgun.playerAngles')
end

local ply, ent, holder, holderStatus

local function PhysgunPickup(Uply, Uent)
	if Uent:IsPlayer() and Uent:InVehicle() then
		return false
	end

	ply, ent = Uply, Uent
end

local function PhysgunDrop(Uply, Uent)
	local target = Uply.__dlibPhysgunHandler

	if SERVER and IsValid(target) then
		net.Start('DLib.physgun.player')
		net.WriteBool(false)
		net.Send(target)
	end

	Uply.__dlibPhysgunHandler = nil
	Uply.__dlibPhysgunHolder = nil
	Uply.__dlibUpcomingEyeAngles = nil

	Uent.__dlibPhysgunHandler = nil
	Uent.__dlibPhysgunHolder = nil
	Uent.__dlibUpcomingEyeAngles = nil
end

-- Lets handle this mess by ourself
-- as admin addons doesnt even care
local function PlayerNoClip(ply)
	if CLIENT and holderStatus and IsValid(holder) then
		return false
	elseif SERVER and IsValid(ply.__dlibPhysgunHolder) then
		return false
	end
end

local function PhysgunPickupPost(status)
	if not IsValid(ply) or not IsValid(ent) then return status end
	if not ent:IsPlayer() then return status end

	if status then
		ply.__dlibPhysgunHandler = ent
		ent.__dlibPhysgunHolder = ply

		if SERVER then
			net.Start('DLib.physgun.player')
			net.WriteBool(true)
			net.WritePlayer(ply)
			net.Send(ent)
		end
	end

	return status
end

local function StartCommand(ply, cmd)
	if CLIENT and holderStatus and IsValid(holder) then
		cmd:SetMouseX(0)
		cmd:SetMouseY(0)
	end

	if SERVER and IsValid(ply.__dlibPhysgunHolder) then
		cmd:SetMouseX(0)
		cmd:SetMouseY(0)
		local ang = ply.__dlibUpcomingEyeAngles or ply:EyeAngles()
		cmd:SetViewAngles(ang)

		net.Start('DLib.physgun.playerAngles', true)
		net.WriteAngle(ang)
		net.Send(ply)

		return
	end

	local target = ply.__dlibPhysgunHandler
	if not IsValid(target) then return end
	if not cmd:KeyDown(IN_USE) then return end
	local x, y = cmd:GetMouseX() / 4, cmd:GetMouseY() / 7

	if x ~= 0 or y ~= 0 then
		if SERVER then
			cmd:SetMouseX(0)
			cmd:SetMouseY(0)
		end

		local ang = target:EyeAngles()
		ang.p = ang.p + y
		ang.y = ang.y + x
		ang:Normalize()
		-- target:SetEyeAngles(ang)
		target.__dlibUpcomingEyeAngles = ang
	end
end

if CLIENT then
	net.receive('DLib.physgun.player', function()
		holderStatus = net.ReadBool()

		if holderStatus then
			holder = net.ReadPlayer()
		else
			holder = NULL
		end
	end)

	net.receive('DLib.physgun.playerAngles', function()
		LocalPlayer():SetEyeAngles(net.ReadAngle())
	end)
end

hook.Add('StartCommand', 'DLib.PhysgunModifier', StartCommand, -10)
hook.Add('PhysgunPickup', 'DLib.PhysgunModifier', PhysgunPickup, -10)
hook.Add('PhysgunDrop', 'DLib.PhysgunModifier', PhysgunDrop, -10)
hook.Add('PlayerNoClip', 'DLib.PhysgunModifier', PlayerNoClip, -10)
hook.Add('CanPlayerEnterVehicle', 'DLib.PhysgunModifier', PlayerNoClip, -10)
hook.AddPostModifier('PhysgunPickup', 'DLib.PhysgunModifier', PhysgunPickupPost)
