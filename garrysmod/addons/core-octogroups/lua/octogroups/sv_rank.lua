--[[ API: edit the rank in group, pass nil to data to remove rank ]]
function og.editRank(gID, rank, data)

	local g = og.groups[gID]
	if not g then return end

	if rank == 'owner' or rank == 'member' then return end

	g.ranks[rank] = data

	-- unrank members if we're deleting the rank
	if not data then
		for sID, m in pairs(g.members) do
			if m.rank == rank then
				og.setMember(gID, sID, 'member')
			end
		end
	end

	og.save(gID)

	hook.Run('og.editRank', gID, rank, data)

end

--[[ API: returns whether player has perm in group ]]
function og.hasPerm(gID, sID, perm)

	local override = hook.Run('og.hasPerm', gID, sID, perm)
	if override ~= nil then return override end

	local g = og.groups[gID]
	if not g then return false end

	local m = g.members[sID]
	if not m then return false end

	if m.rank == 'owner' then return true end

	local r = g.ranks[m.rank]
	if not r or not r.perms then return false end

	if table.HasValue(r.perms, perm) then return true end

	return false

end

--[[ API: returns user order by rank ]]
function og.getOrder(gID, sID)

	local g = og.groups[gID]
	if not g then return -1 end

	local m = g.members[sID]
	if not m then return -1 end

	if m.rank == 'member' then return 0 end
	if m.rank == 'owner' then return 101 end

	local r = g.ranks[m.rank]
	return r and r.order or 0

end
