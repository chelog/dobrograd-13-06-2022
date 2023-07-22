--[[ API: add a member to a group, pass nil as rank to kick ]]
function og.getOnline(gID)

	local plys = {}

	local g = og.groups[gID]
	if not g then return plys end

	for i, ply in ipairs(player.GetAll()) do
		if g.members[ply:SteamID()] then
			plys[#plys + 1] = ply
		end
	end

	return plys

end

--
-- META FUNCTIONS
--

local ply = FindMetaTable 'Player'

function ply:GetMember(gID)

	local g = og.groups[gID]
	if not g then return end

	local m = g.members[self:SteamID()]
	return m

end

function ply:SetGroupRank(gID, rank)

	if rank == 'owner' then
		og.setOwner(gID, self:SteamID())
	else
		og.setMember(gID, self:SteamID(), rank)
	end

end
