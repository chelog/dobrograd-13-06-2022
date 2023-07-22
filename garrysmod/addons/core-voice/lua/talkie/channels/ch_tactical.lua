local function policeOnly(self, ply)
	return (ply:isCP() and not ply:GetActiveRank('gov')) or ply:Team() == TEAM_ADMIN
end

for i = 1, 3 do
	local chan = talkie.createChannel('tac' .. i)
	chan.name = 'Тактический ' .. i
	chan.parent = 'ems'
	chan.IsListeningAllowed, chan.IsSpeakingAllowed = policeOnly, policeOnly
end
