local divisions = {
    dec = {
        name = 'Детективы',
        access = {'dec','sdec','ins','ddep', 'dcom'},
    },
    swat = {
        name = 'S.W.A.T',
        access = {'swat'},
    },
}

for freq, division in pairs(divisions) do
    local chan = talkie.createChannel(freq)
    chan.name, chan.parent = division.name, 'ems'
    function chan:IsListeningAllowed(ply)
        if ply:Team() == TEAM_FBI then return true end
        if ply:GetActiveRank('dpd') == 'chi' then return true end
        if ply:Team() == TEAM_ADMIN then return true end
        if table.HasValue(division.access, ply:GetActiveRank('dpd') or '') then
            return true
        end
        return false
    end
    chan.IsSpeakingAllowed = chan.IsListeningAllowed
end
