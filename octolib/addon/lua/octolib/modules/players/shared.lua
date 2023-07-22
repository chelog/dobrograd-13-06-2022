octolib.players = octolib.players or {}

function octolib.players.resolve(value)
	if isstring(value) then
		return player.GetBySteamID(value), value
	else
		return value, value:SteamID()
	end
end

local Player = FindMetaTable('Player')

function Player:GetEyeTraceLimited(length)
	local aim = self:EyeAngles():Forward()
	local t = {}

	t.start = self:GetShootPos()
	t.endpos = t.start + aim * length
	t.filter = { self }

	hook.Run('octolib.eyeTraceFilter', self, t.filter)

	return util.TraceLine(t)
end

for _, name in ipairs({ 'AccountID', 'SteamID', 'SteamID64', 'UniqueID' }) do
	Player[name] = octolib.func.detour(Player[name], 'Player:' .. name, function(original, player)
		return player:GetNetVar('botID') or original(player)
	end)
end
