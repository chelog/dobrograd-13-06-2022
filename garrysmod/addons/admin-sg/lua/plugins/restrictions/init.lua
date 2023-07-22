--[[
	� 2017 Thriving Ventures Limited do not share, re-distribute or modify

	without permission of its author (gustaf@thrivingventures.com).
]]

local plugin = plugin;

plugin:IncludeFile("shared.lua", SERVERGUARD.STATE.SHARED);
plugin:IncludeFile("cl_panel.lua", SERVERGUARD.STATE.CLIENT);

local function ReachedLimit(player, limitType, message)
	if not IsValid(player) then
		return false, true
	end

	local uniqueID = serverguard.player:GetRank(player);

	if (uniqueID == "founder") then
		return false, true;
	end;

	local restrictions = serverguard.ranks:GetData(uniqueID, "Restrictions");
	local iLimit = nil;
	local amount = tonumber(
		player:GetCount(string.lower(limitType))
	);

	if (restrictions and restrictions[limitType]) then
		iLimit = tonumber(restrictions[limitType]) or 0;
	end;

	if limitType == 'Props' then
		local override = player:GetNetVar('propLimit')
		if override and iLimit and override > iLimit then
			if amount >= (tonumber(override) or 0) then
				serverguard.Notify(player, SERVERGUARD.NOTIFY.RED, message)
				return true
			end
			return false
		end
	end

	if (iLimit == -1) then
		return false, true;
	end;

	if (iLimit and amount >= iLimit) then
		serverguard.Notify(player, SERVERGUARD.NOTIFY.RED, message);
		return true;
	end;

	if (amount >= cvars.Number("sbox_max" .. string.lower(limitType))) then
		return false, false;
	end

	return false;
end;

plugin:Hook("PlayerSpawnEffect", "restrictions.PlayerSpawnEffect", function(player, model)
	local reachedLimit, bForce = ReachedLimit(player, "Effects", "Достигнут лимит эффектов.");

	if (reachedLimit) then
		return false;
	end;

	if (!reachedLimit and bForce) then
		return true;
	end;
end);

plugin:Hook("PlayerSpawnNPC", "restrictions.PlayerSpawnNPC", function(player, class, weapon)
	local reachedLimit, bForce = ReachedLimit(player, "NPCs", "Достигнут лимит NPC.");

	if (reachedLimit) then
		return false;
	end;

	if (!reachedLimit and bForce) then
		return true;
	end;
end);

plugin:Hook("PlayerSpawnProp", "restrictions.PlayerSpawnProp", function(player, model)
	local reachedLimit, bForce = ReachedLimit(player, "Props", "Достигнут лимит пропов.")

	if (reachedLimit) then
		return false;
	end;

	if (!reachedLimit and bForce) then
		return true;
	end;
end);

plugin:Hook("PlayerSpawnRagdoll", "restrictions.PlayerSpawnRagdoll", function(player, model)
	local reachedLimit, bForce = ReachedLimit(player, "Ragdolls", "Достигнут лимит рагдоллов.");

	if (reachedLimit) then
		return false;
	end;

	if (!reachedLimit and bForce) then
		return true;
	end;
end);

plugin:Hook("PlayerSpawnSENT", "restrictions.PlayerSpawnSENT", function(player, class)
	local reachedLimit, bForce = ReachedLimit(player, "Sents", "Достигнут лимит энтити.");

	if (reachedLimit) then
		return false;
	end;

	if (!reachedLimit and bForce) then
		return true;
	end;
end);

plugin:Hook("PlayerSpawnSWEP", "restrictions.PlayerSpawnSWEP", function(player, class, swepData)
	local reachedLimit, bForce = ReachedLimit(player, "Sents", "Достигнут лимит энтити.");

	if (reachedLimit) then
		return false;
	end;

	if (!reachedLimit and bForce) then
		return true;
	end;
end);

plugin:Hook("PlayerSpawnVehicle", "restrictions.PlayerSpawnVehicle", function(player, model, class, data)
	local reachedLimit, bForce = ReachedLimit(player, "Vehicles", "Достигнут лимит транспорта.");

	if (reachedLimit) then
		return false;
	end;

	if (!reachedLimit and bForce) then
		return true;
	end;
end);

plugin:Hook("PostGamemodeLoaded", "restrictions.PostGamemodeLoaded", function()
	local meta = FindMetaTable("Player");
	meta.oldCheckLimit = meta.oldCheckLimit or meta.CheckLimit;
	function meta:CheckLimit(str)
		local reachedLimit, bForce = ReachedLimit(self, str:sub(1,1):upper()..str:sub(2), "Достигнут лимит "..str..".");

		if (reachedLimit) then
			return false;
		end;

		if (!reachedLimit and bForce) then
			return true;
		end;

		return self:oldCheckLimit(str);
	end;
end);

hook.Add('CanTool', 'restrictions.CanTool', function(player, trace, tool)
	local uniqueID = serverguard.player:GetRank(player)

	if (not IsValid(player) or uniqueID == 'founder') then
		return true
	end

	local restrictionData = serverguard.ranks:GetData(uniqueID, 'Restrictions', {})
	local toolList = {}

	if (restrictionData.Tools) then
		toolList = restrictionData.Tools
	end

	if toolList[tool] == false and not hook.Run('sg.tool-override', player, trace, tool) then
		serverguard.Notify(player, SERVERGUARD.NOTIFY.RED, 'У тебя нет доступа к этому инструменту')
		return false
	end

	local ent = trace.Entity
	if IsValid(ent) then
		if ent:GetClass() == 'gmod_sent_vehicle_fphysics_base' and player:query('DBG: Изменять автомобили') then
			return true
		end

		if ent:IsPlayer() and player:query('DBG: Применять тулы на игроках') then
			return true
		end
	end
end, -10)

hook.Add('CanProperty', 'restrictions.CanTool', function(player, property, ent)
	local uniqueID = serverguard.player:GetRank(player)

	if (uniqueID == 'founder') then
		return true
	end

	if IsValid(ent) and ent:GetClass() == 'gmod_sent_vehicle_fphysics_base' and player:query('DBG: Изменять автомобили') then
		return true
	end
end, -10)
