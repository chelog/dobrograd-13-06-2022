--[[ API: link group member data to player instance ]]
function og.setupPlayer(ply, gID, m)

	ply.og = ply.og or {}
	ply.og[gID] = {og.groups[gID], m}

end

--[[ API: search groups in cache and link all data to player instance ]]
function og.reloadPlayer(ply)

	ply.og = {}

	local sID = ply:SteamID()
	for gID, g in pairs(og.groups) do
		local m = g.members[sID]
		if m then og.setupPlayer(ply, gID, m) end
	end

	local toSend = {}
	for gID, gData in pairs(ply.og) do
		toSend[gID] = gData[1]
	end
	netstream.Start(ply, 'og.syncOwn', toSend)

	hook.Run('og.reloadedPlayer', ply)

end
hook.Add('PlayerFinishedLoading', 'octogroups', og.reloadPlayer)

--[[ API: get player's cached groups ]]
function og.getPlayerGroups(ply)

	ply.og = ply.og or {}

	local gs = {}
	for gID, m in pairs(ply.og) do
		gs[#gs + 1] = og.groups[gID]
	end

	return gs

end

--[[ API: set member as an owner of a group ]]
function og.setOwner(gID, sID)

	local g = og.groups[gID]
	if not g then return end

	local rank = 'owner'
	g.members[sID] = g.members[sID] or {
		joined = os.time(),
	}

	local m = g.members[sID]
	if m.rank == rank then return end

	m.rank = rank
	m.ranked = os.time()
	og.save(gID)

	local ply = player.GetBySteamID(sID)
	if IsValid(ply) then
		og.reloadPlayer(ply)
	end

	hook.Run('og.setOwner', gID, sID)

end

--[[ API: add a member to a group, pass nil as rank to kick ]]
function og.setMember(gID, sID, rank)

	local g = og.groups[gID]
	if not g then return end

	if rank then
		rank = g.ranks[rank] and rank or 'member'

		g.members[sID] = g.members[sID] or {
			joined = os.time(),
		}

		local m = g.members[sID]
		if m.rank == rank then return end

		m.rank = rank
		m.ranked = os.time()
	else
		g.members[sID] = nil
	end

	og.save(gID)

	local ply = player.GetBySteamID(sID)
	if IsValid(ply) then
		og.reloadPlayer(ply)
	end

	hook.Run('og.setMember', gID, sID, rank)

end
