local chan = talkie.createChannel('wcso')
chan.name, chan.parent = 'WCSO', 'ems'
function chan:IsListeningAllowed(ply)
	return ply:Team() == TEAM_FBI or ply:Team() == TEAM_ADMIN or ply:GetActiveRank('wcso') ~= nil
end
chan.IsSpeakingAllowed = chan.IsListeningAllowed

local chan = talkie.createChannel('seb')
chan.name, chan.parent = 'S.E.B.', 'wcso'
function chan:IsListeningAllowed(ply)
	return ply:Team() == TEAM_FBI or ply:Team() == TEAM_ADMIN or ply:GetActiveRank('wcso') == 'seb'
end
chan.IsSpeakingAllowed = chan.IsListeningAllowed
