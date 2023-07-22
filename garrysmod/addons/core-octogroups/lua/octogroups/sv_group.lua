--[[ API: populate fields and create missing in group data table ]]
function og.prepareGroupData(g)

	g.name = g.name or 'New Group'
	g.members = g.members or {}
	g.ranks = g.ranks or {}
	g.settings = g.settings or {}
	g.inv = g.inv or {}
	g.bank = g.bank or 0

end

--[[ API: get public fields from group table to send to clients ]]
function og.publicData(g)

	return {
		id = g.id or -1,
		name = g.name or 'New Group',
	}

end

--[[ API: load group data to cache ]]
function og.importGroup(g)

	if not g.id then return end

	og.prepareGroupData(g)
	og.groups[g.id] = g

end

--[[ API: create a group ]]
function og.create(g)

	if not g.id then return error('Trying to create group with no ID') end
	if og.groups[g.id] then return error('Group already exists') end

	local data = table.Copy(g)
	og.prepareGroupData(data)
	data.id = nil

	octolib.db:PrepareQuery('insert into octogroups(id, data) values(?, ?)', { g.id, pon.encode(data) }, function()
		og.reloadFromDB(function()
			hook.Run('og.created', gID)
		end)
	end)

end

--[[ API: permanently delete group ]]
function og.delete(gID)

	local g = og.groups[gID]
	if not g or g.predefined then return end

	octolib.db:PrepareQuery('delete from octogroups where id = ?', { gID }, function()
		og.reloadFromDB(function()
			hook.Run('og.deleted', gID)
		end)
	end)

end

--[[ API: change setting of the group ]]
function og.setSetting(gID, name, val)

	local g = og.groups[gID]
	if not g then return end

	g.settings = g.settings or {}
	g.settings[name] = val

	og.save(gID)

	hook.Run('og.setSetting', gID, name, val)

end

--[[ API: add money to group's bank ]]
function og.addMoney(gID, val)

	local g = og.groups[gID]
	if not g then return end

	g.bank = (g.bank or 0) + val
	og.save(gID)

	hook.Run('og.addedMoney', gID, val)

end

--[[ API: check if group has enough money in bank ]]
function og.hasMoney(gID, val)

	local g = og.groups[gID]
	if not g then return end

	return (g.bank or 0) >= val

end

--[[ API: load group's inv into entity ]]
function og.loadInv(gID, ent)

	local g = og.groups[gID]
	if not g or not IsValid(ent) then return end

	if g.inv then
		ent:ImportInventory(g.inv)
	end

	hook.Run('og.loadedInv', gID, ent)

end

--[[ API: save group's inv from entity ]]
function og.saveInv(gID, ent)

	local g = og.groups[gID]
	if not g or not IsValid(ent) or not ent.inv then return end

	g.inv = ent:ExportInventory()
	og.save(gID)

end

-- -- force a group to reload its members and link to player instances
-- function og.setupGroupPlayers(gID)

-- 	local g = og.groups[gID]
-- 	if not g then return end

-- 	for sID, m in pairs(g.members) do
-- 		local ply = player.GetBySteamID(sID)
-- 		if IsValid(ply) then
-- 			og.setupPlayer(ply, gID, m)
-- 		end
-- 	end

-- end

local predefineCache = {}
--[[ API: predefine group to ensure it always exists ]]
function og.predefine(g)

	if not g.id then return end
	g.predefined = true
	predefineCache[g.id] = g

end

hook.Add('og.init', 'og.predefine', function()

	for gID, groupData in pairs(predefineCache) do
		local g = og.groups[gID]
		if not g then
			-- create a new group
			og.create(groupData)
		else
			-- update existing group with default values
			for k, v in pairs(groupData) do g[k] = v end
			og.save(gID)
		end
	end

end)
