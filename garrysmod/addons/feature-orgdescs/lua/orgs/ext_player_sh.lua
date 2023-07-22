local plyMeta = FindMetaTable 'Player'

function plyMeta:GetActiveRank(orgID)
	if not orgID then return unpack(self:GetNetVar('activeRank', {})) end
	if self:GetNetVar('activeRank', {})[1] == orgID then
		return self:GetNetVar('activeRank')[2]
	end
end

function plyMeta:GetActiveOrg()
	return self:GetNetVar('activeRank', {})[1]
end
