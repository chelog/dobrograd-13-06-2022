og.groupsOwn = og.groupsOwn or {}

--[[ API: returns whether local player has perm in group ]]
function og.hasPerm(gID, perm)

	local g = og.groupsOwn[gID]
	if not g then return false end

	local m = g.members[LocalPlayer():SteamID()]
	if not m then return false end

	if m.rank == 'owner' then return true end

	local r = g.ranks[m.rank]
	if not r or not r.perms then return false end

	if table.HasValue(r.perms, perm) then return true end

	return false

end

--[[ API: returns user order by rank ]]
function og.getOrder(gID, sID)

	local g = og.groupsOwn[gID]
	if not g then return 0 end

	local m = g.members[sID]
	if not m or m.rank == 'member' then return 0 end
	if m.rank == 'owner' then return 101 end

	local r = g.ranks[m.rank]
	return r and r.order or 0

end

--[[ API: Add/withdraw money ]]
function og.addMoney(gID, val)

	netstream.Start('og.addedMoney', gID, val)

end

--[[ API: Edit rank, pass nil to data to delete ]]
function og.editRank(gID, rID, data)

	netstream.Start('og.editRank', gID, rID, data)

end

--
-- NET HOOKS
--

netstream.Hook('og.syncOwn', function(data)

	local sID = LocalPlayer():SteamID()
	for gID, g in pairs(data) do
		local m = g.members[sID]
		g.myRank = m.rank or 'member'
	end

	og.groupsOwn = data
	hook.Run('octogroups.syncedOwn')

end)

netstream.Hook('og.sync', function(gID, data)

	if gID then
		og.groups[gID] = data
	else
		og.groups = data
	end

	hook.Run('octogroups.synced', gID)

end)