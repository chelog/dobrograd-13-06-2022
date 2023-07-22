-- id, name
local orgs = { {'gov', 'Правительство'}, {'dpd', 'DPD'}, {'fire', 'Пожарные'}, {'coroners', 'Коронеры'}, {'csd', 'Городская служба'}, {'fbi', 'ФБР'}, {'bank', 'Банк'}, {'prison', 'Тюрьма'}, {'elsec', 'Elegant Security'}, {'alpha', 'Alpha'}, {'taxi', 'Таксисты'} }

local function canUse(self, ply)
	if ply:Team() == TEAM_ADMIN then return true end
    if ply:Team() == TEAM_FBI then return true end
	return ply.currentOrg == self.frequency
end

for _, org in ipairs(orgs) do
	local chan = talkie.createChannel(org[1])
	chan.name, chan.parent = org[2], 'ems'
	chan.IsListeningAllowed, chan.IsSpeakingAllowed = canUse, canUse
end

local chan = talkie.createChannel('medic')
chan.name, chan.parent = 'Медики', 'ems'
local function medicOrCoroner(self, ply)
	if ply:Team() == TEAM_ADMIN then return true end
    if ply:Team() == TEAM_FBI then return true end
	return ply.currentOrg == 'medic' or ply.currentOrg == 'coroners'
end
chan.IsListeningAllowed, chan.IsSpeakingAllowed = medicOrCoroner, medicOrCoroner
