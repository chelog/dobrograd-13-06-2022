--[[
	© 2017 Thriving Ventures Limited do not share, re-distribute or modify
	
	without permission of its author (gustaf@thrivingventures.com).
]]

--- ## Shared
-- Library to store and retrieve what permissions are available.
-- @module serverguard.permission

include "modules/sh_cami.lua"

serverguard.permission = serverguard.permission or {};
serverguard.permission.stored = serverguard.permission.stored or {};

--- Check whether or not a permission exists.
-- @string identifier The name of the permission.
-- @treturn boolean Whether or not the permission exists.
function serverguard.permission:Exists(identifier)
	if (type(identifier) == "string") then
		return self.stored[identifier];
	end;
end;

--- Adds a permission.
-- @string identifier The name of the permission.
function serverguard.permission:Add(identifier)
	if (type(identifier) == "string") then
		if (!self.stored[identifier]) then
			self.stored[identifier] = true;
			CAMI.RegisterPrivilege({
				Name = identifier,
				MinAccess = "invalid"
			})
		end;
	elseif (type(identifier) == "table") then
		for k, v in pairs(identifier) do
			if (type(v) == "string") then
				self:Add(v);
			end;
		end;
	end;
end;

--- Removes a permission.
-- @string identifier The name of the permission.
function serverguard.permission:Remove(identifier)
	if (type(identifier) == "string") then
		if (self.stored[identifier]) then
			CAMI.UnregisterPrivilege(identifier)
			self.stored[identifier] = nil;
		end;
	end;
end;

--- Gets a table of all permissions.
-- @treturn table Table of all permissions.
function serverguard.permission:GetAll()
	return self.stored;
end;

serverguard.permission:Add("Quick Menu");
serverguard.permission:Add("Manage Players");
serverguard.permission:Add("Manage Plugins");
serverguard.permission:Add("Admin");
serverguard.permission:Add("Superadmin");
serverguard.permission:Add("Physgun Player");
serverguard.permission:Add("See Help Requests");
serverguard.permission:Add("Unban");
serverguard.permission:Add("Edit Ban");

hook.Add("PhysgunPickup", "serverguard.PhysgunPickup", function(pPlayer, pEntity)
	if (pEntity:IsPlayer() and serverguard.player:HasPermission(pPlayer, "Physgun Player") and serverguard.player:CanTarget(pPlayer, pEntity)) then
		pPlayer.sg_physgunPlayer = pEntity;
		pEntity.sg_playerPhysgunned = true;

		pEntity:SetLocalVelocity(Vector(0, 0, 0));
		pEntity:SetMoveType(MOVETYPE_NONE);
		pEntity:SetCollisionGroup(COLLISION_GROUP_WORLD);

		return true;
	end;
end);

hook.Add("PhysgunDrop", "serverguard.PhysgunDrop", function(pPlayer, pEntity)
	if (pEntity:IsPlayer() and pEntity.sg_playerPhysgunned) then
		pPlayer.sg_physgunPlayer = nil;

		pEntity:SetMoveType(MOVETYPE_WALK);
		pEntity:SetCollisionGroup(COLLISION_GROUP_PLAYER);
		
		pEntity.sg_playerPhysgunned = false;
	end;
end);

hook.Add("KeyPress", "serverguard.KeyPress", function(pPlayer, nKey)
	if (nKey == IN_ATTACK2) then
		local pActiveWeapon = pPlayer:GetActiveWeapon()
		
		if (pActiveWeapon ~= NULL and pActiveWeapon:GetClass() == "weapon_physgun") then
			local pEntity = pPlayer.sg_physgunPlayer;

			if (IsValid(pEntity)) then
				if (serverguard.player:HasPermission(pPlayer, "Physgun Player") and serverguard.player:CanTarget(pPlayer, pEntity)) then
					pPlayer.sg_physgunPlayer = nil;
					pEntity.sg_playerPhysgunned = false;

					pEntity:SetLocalVelocity(Vector(0, 0, 0));
					pEntity:SetMoveType(MOVETYPE_NONE);
					pEntity:SetCollisionGroup(COLLISION_GROUP_PLAYER);
				end;
			end;
		end;
	end;
end);

if (SERVER) then	
	hook.Add("CanPlayerSuicide", "serverguard.CanPlayerSuicide", function(pPlayer)
		if (pPlayer.sg_playerPhysgunned) then
			return false;
		end;
	end);
	
	hook.Add("PostGamemodeLoaded", "serverguard.permissions.PostGamemodeLoaded", function()
		hook.Remove("PhysgunDrop", "FAdmin_PickUpPlayers");
	end);
end;