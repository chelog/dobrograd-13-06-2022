local groups = { 'dpd', 'medic', 'fire', 'coroners', 'prison' }

local chan = talkie.createChannel('ems')
chan.name = 'Экстренные службы'
function chan:IsListeningAllowed(ply)
    if ply:Team() == TEAM_FBI then return true end
	if ply:Team() == TEAM_ADMIN then return true end
	if ply:GetNetVar('dbg-police.job', '') ~= '' then return true end
	for _, groupID in ipairs(groups) do
		if ply.currentOrg == groupID then
			return true
		end
	end
	return false
end
chan.IsSpeakingAllowed = chan.IsListeningAllowed
