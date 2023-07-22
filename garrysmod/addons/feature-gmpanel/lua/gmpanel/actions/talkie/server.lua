local function canListen(chan, ply)
	return chan.allowedListen[ply:SteamID()] or false
end
local function canSpeak(chan, ply)
	return chan.allowedSpeak[ply:SteamID()] or false
end

local function add(freq, obj)

	local chan = talkie.channels[freq]
	if not chan then
		chan = talkie.createChannel(freq)
		chan.IsListeningAllowed = canListen
		chan.IsSpeakingAllowed = canSpeak
	end

	if string.Trim(obj.name or '') == '' then
		obj.name = 'Неизвестная частота'
	else obj.name = string.Trim(obj.name) end
	chan.name = chan.name or obj.name
	chan.allowedSpeak = chan.allowedSpeak or {}
	chan.allowedListen = chan.allowedListen or {}

	for _, v in ipairs(obj.players) do
		chan.allowedListen[v] = true
		chan.allowedSpeak[v] = tobool(obj.speak) or nil
		local ply = player.GetBySteamID(v)
		if IsValid(ply) then
			ply:ConnectTalkie(freq)
			ply:SyncTalkieChannels()
		end
	end

end

local function remove(freq, obj)

	local chan = talkie.channels[freq]
	if not chan then return end
	for _, v in ipairs(obj.players) do
		chan.allowedSpeak[v], chan.allowedListen[v] = nil
		local ply = player.GetBySteamID(v)
		if IsValid(ply) then
			ply:SyncTalkieChannels()
			if ply:GetNetVar('TalkieFreq') == freq then
				ply:DisconnectTalkie()
			end
		end
	end
	if table.Count(chan.allowedListen) == 0 then
		talkie.channels[freq] = nil
	end

end

gmpanel.registerAction('talkie', function(obj)
	local freq = obj.freq
	if not isstring(freq) then return false end
	freq = 'gmp_' .. freq
	if obj.mode == 'add' then
		add(freq, obj)
	else remove(freq, obj) end
end)

hook.Add('PlayerDisconnected', 'gmpanel.cleanTalkieFreqs', function(ply)
	local sid = ply:SteamID()
	for k, v in pairs(talkie.channels) do
		if string.StartWith(k, 'gmp_') and v.allowedListen[sid] then
			v.allowedListen[sid], v.allowedSpeak[sid] = nil
			if table.Count(v.allowedListen) == 0 then
				talkie.channels[k] = nil
			end
		end
	end
end)
