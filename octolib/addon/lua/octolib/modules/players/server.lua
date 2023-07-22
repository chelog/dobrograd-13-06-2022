octolib.players.count = octolib.players.count or 0

gameevent.Listen('player_connect')
gameevent.Listen('player_disconnect')

local Player = FindMetaTable 'Player'

function octolib.players.getCount()
	return player.GetCount()
end

function octolib.players.getAdmins()
	return octolib.array.filter(player.GetAll(), Player.IsAdmin)
end

hook.Add('player_connect', 'octolib.players', function(data)
	octolib.players.count = octolib.players.count + 1
end)

hook.Add('player_disconnect', 'octolib.players', function(data)
	octolib.players.count = octolib.players.count - 1
end)

hook.Add('CheckPassword', 'octolib.adminslots', function(sid, ip, sv, cl, name)
	if	game.MaxPlayers() - octolib.players.getCount() < CFG.adminSlots and
		not CFG.isAdminSteamID(util.SteamIDFrom64(sid))
	then
		return false, L.adminslots
	end
end)

hook.Add('onPlayerChangedName', 'octolib.rpNames', function(ply, old, new)
	ply:SetDBVar('lastRPName', new)
end)

local ipInfo = octolib.api({ url = 'http://ip-api.com/json' })
hook.Add('PlayerInitialSpawn', 'octolib.ipInfo', function(ply)
	if ply:IsBot() then return end

	ipInfo:get('/' .. ply:IPAddress():gsub(':.+', '')):Then(function(res)
		hook.Run('octolib.ipInfo', ply, res.data)
	end)
end)

--
-- BOTS
--

local botIDs = {}
for id = 1, 128 do botIDs[#botIDs + 1] = ('BOT%03d'):format(id) end

for _, ply in ipairs(player.GetAll()) do
	local botID = ply:GetNetVar('botID')
	if botID then
		table.RemoveByValue(botIDs, botID)
	end
end

hook.Add('PlayerInitialSpawn', 'octolib.players.id', function(ply)
	if ply:IsBot() then
		ply:SetNetVar('botID', table.remove(botIDs, 1))
	end
end, -1)

hook.Add('PlayerDisconnected', 'octolib.players.id', function(ply)
	local botID = ply:GetNetVar('botID')
	if botID and not table.HasValue(botIDs, botID) then
		botIDs[#botIDs + 1] = botID
		table.sort(botIDs)
	end
end)

netstream.Hook('PlayersEnteredPVS', function(ply, tgts)
	for _, tgt in ipairs(tgts) do
		-- tgt is the player who entered ply's PVS
		hook.Run('PlayerEnteredPVS', tgt, ply)
	end
end)

local Player = FindMetaTable 'Player'
local Entity = FindMetaTable 'Entity'

function Player:SetModel(mdl)
	return self.SetNetVar and self:SetNetVar('model', mdl) or Entity.SetModel(self, mdl)
end

local activeCooldowns = {}

function Player:GetCooldown(id)
	local sID = self:SteamID()

	return activeCooldowns[sID] and activeCooldowns[sID][id]
end

function Player:TriggerCooldown(id, time, force)
	if not force and self:GetCooldown(id) then
		return false
	end

	local sID = self:SteamID()
	activeCooldowns[sID] = activeCooldowns[sID] or {}
	activeCooldowns[sID][id] = CurTime() + time
	timer.Create(sID .. ':cooldown:' .. id, time, 1, function()
		activeCooldowns[sID][id] = nil
		if table.Count(activeCooldowns[sID]) < 1 then
			activeCooldowns[sID] = nil
		end
	end)

	return true
end
