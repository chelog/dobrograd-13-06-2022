octolib.server('talkie/channels/meta_channel')
local channels = file.Find('talkie/channels/ch_*.lua', 'LUA')
for _, ch in ipairs(channels) do
	octolib.server('talkie/channels/' .. ch:gsub('.lua', ''))
end

local relations = {}
timer.Create('dbg-talkie.flushRelations', 1, 0, function()
	relations = {}
end)

--[[-------------------------------------------------------------------------
---------------------------------------------------------------------------]]
local meta = FindMetaTable 'Player'

function meta:GetFrequency()
	return self:GetLocalVar('TalkieFreq', '111.1')
end

function meta:CanListenToChannel(freq, instant)
	local hr = hook.Run('dbg-talkie.canListen', self, freq)
	if hr == false then return hr end
	local chan = talkie.channels[freq]
	if not chan then return true end -- civil frequency, no limits
	if instant then
		chan.canListen[self] = chan:IsListeningAllowed(self) or nil
	else chan:_updateListening(self) end
	chan.canSpeak[self] = chan.canListen[self] -- you can't speak if you can't listen
	return chan.canListen[self] == true
end

function meta:CanSpeakToChannel(freq, instant)
	local hr = hook.Run('dbg-talkie.canSpeak', self, freq)
	if hr == false then return hr end

	local chan = talkie.channels[freq]
	if not chan then return true end -- civil frequency, no limits

	if instant then
		chan.canSpeak[self] = chan:IsSpeakingAllowed(self) or nil
	else chan:_updateSpeaking(self) end
	return chan.canSpeak[self] == true
end

function meta:ConnectTalkie(freq)

	if not self:CanListenToChannel(freq, true) then return false, 'Твоя рация не поддерживает такую частоту' end

	local old = self:GetFrequency()
	if talkie.channels[old] then
		talkie.channels[old].canListen[self], talkie.channels[old].canSpeak[self] = nil
	end
	self.previousFrequency = old

	self:SetLocalVar('TalkieFreq', freq)
	if IsValid(self) then self:Notify('Рация переведена на частоту ' .. freq) end

	return true

end

function meta:DisconnectTalkie()
	local could = self:ConnectTalkie(self.previousFrequency or '111.1')
	if not could then self:ConnectTalkie('111.1') end
end

local function _hasTalkie(ply)
	if not IsValid(ply) then return end
	ply.hasTalkie = RPExtraTeams[ply:Team()].hasTalkie or tobool(ply:HasItem('radio'))
end
function meta:HasTalkie()
	if not self._updateHavingTalkie then
		self._updateHavingTalkie = octolib.func.debounceStart(_hasTalkie, 0.5)
	end
	self:_updateHavingTalkie()
	return self.hasTalkie
end

function meta:SyncTalkieChannels()
	local channels = {}
	for k, v in pairs(talkie.channels) do
		if v:IsListeningAllowed(self) then
			channels[#channels + 1] = {k, v.name}
		end
	end
	netstream.Start(self, 'dbg-talkie.sync', channels)
end
hook.Add('dbg-char.spawn', 'dbg-talkie', meta.SyncTalkieChannels)

--[[-------------------------------------------------------------------------
---------------------------------------------------------------------------]]
local hasTalkie = meta.HasTalkie
local isUsingTalkie = meta.IsUsingTalkie
local isTalkieDisabled = meta.IsTalkieDisabled

local function updateCache(listener, speaker)

	local sCache = relations[speaker]
	if sCache == false then return false end
	sCache = sCache or {}
	if sCache[listener] ~= nil then return sCache[listener] end
	relations[speaker] = sCache

	if not (isUsingTalkie(speaker) and hasTalkie(speaker)) then
		relations[speaker] = false
		return false
	end
	if isTalkieDisabled(listener) or not hasTalkie(listener) then
		sCache[listener] = false
		return false
	end

	local freqL, freqS = listener:GetFrequency(), speaker:GetFrequency()
	if freqL ~= freqS then
		if listener:GetNetVar('NoTalkieParenting') then
			sCache[listener] = false
			-- VoiceBox.FX.IsRadioComm(listener:EntIndex(), speaker:EntIndex(), false)
			return false
		end
		local chan = talkie.channels[freqL]
		if not chan or not chan.parent or chan.parent ~= freqS then
			sCache[listener] = false
			-- VoiceBox.FX.IsRadioComm(listener:EntIndex(), speaker:EntIndex(), false)
			return false
		end
	end

	if speaker:CanSpeakToChannel(freqS) and listener:CanListenToChannel(freqL) then
		sCache[listener] = true
		-- if speaker:GetInfoNum('dbg_disablevoicefx', 0) == 1 then
		-- 	-- VoiceBox.FX.IsRadioComm(listener:EntIndex(), speaker:EntIndex(), false)
		-- else
		-- 	-- VoiceBox.FX.IsRadioComm(listener:EntIndex(), speaker:EntIndex(), not VoiceBox.FX.__PlayerCanHearPlayersVoice(listener, speaker))
		-- end
		return true
	end

	sCache[listener] = false
	return false
	-- VoiceBox.FX.IsRadioComm(listener:EntIndex(), speaker:EntIndex(), false)


end
hook.Add('PlayerCanHearPlayersVoice', 'dbg-talkie.updateCache', function(listener, speaker)
	local status = updateCache(listener, speaker)
	if status then return true end
end)

hook.Add('PlayerDisconnected', 'dbg-talkie', function(ply)
	for _, v in pairs(talkie.channels) do
		v.canListen[ply], v.canSpeak[ply] = nil
	end
end)


hook.Add('OnPlayerChangedTeam', 'dbg-talkie', function(ply)
	ply:SyncTalkieChannels()
	if ply:HasTalkie() and not ply:CanListenToChannel(ply:GetFrequency(), true) then
		ply:DisconnectTalkie()
	end
end)

--[[-------------------------------------------------------------------------
---------------------------------------------------------------------------]]
local radio_sounds = {

	on = {
		'npc/combine_soldier/vo/on1.wav',
		'npc/combine_soldier/vo/on2.wav'
	},

	off = {
		'npc/combine_soldier/vo/off1.wav',
		'npc/combine_soldier/vo/off2.wav'
	}

}

local on = radio_sounds.on
local off = radio_sounds.off

local function updateSpeakStatus(ply, state, sounds)

	if not ply:Alive() or ply:IsGhost() or not ply:HasTalkie() then return end
	if ply:IsTalkieDisabled() then return end
	if ply:GetNetVar('sgGagged') then return end

	if state then

		local weapon = ply:GetActiveWeapon()

		if IsValid(weapon) and weapon:GetHoldType() ~= 'passive' and not ply:Crouching() and not ply:InVehicle() then
			ply.last_wep = {wep = weapon:GetClass(), hold = weapon:GetHoldType()}
			weapon:SetHoldType('passive')
		end

		ply:SetNetVar('UsingTalkie', true)
		if sounds then ply:EmitSound(on[math.random(1, #on)], 45) end
	else

		ply:SetNetVar('UsingTalkie', false)

		if ply:Alive() then
			local weapon = ply:GetActiveWeapon()
			local last_wep = ply.last_wep
			if last_wep then
				local wep, hold = ply.last_wep.wep, ply.last_wep.hold

				if IsValid(weapon) and wep and hold and weapon:GetClass() == wep then
					weapon:SetHoldType(hold or 'normal')
				end
			end
		end
		ply.last_wep = {}
		if sounds then ply:EmitSound(off[math.random(1, #off)], 45) end
	end
end

concommand.Add('+talkie', function(ply)
	updateSpeakStatus(ply, true, true)
end)

concommand.Add('-talkie', function(ply)
	updateSpeakStatus(ply, false, true)
end)

netstream.Hook('dbg-talkie.updateSpeakStatus', function(ply, state)
	updateSpeakStatus(ply, state)
end)


concommand.Add('set_talkie_channel', function(ply, cmd, args)

	if (ply.nextChannelChange or 0) > CurTime() then return ply:Notify('warning', 'Подожди немного') end
	local freq = args[1]
	if not freq then return ply:PrintMessage(HUD_PRINTCONSOLE, 'Usage: set_talkie_channel [frequency]') end
	if not isstring(freq) then return end
	if not talkie.channels[freq] and not tostring(freq):find('^(%d%d%d%.%d)$') then
		return ply:Notify('warning', 'Твоя рация не может переключиться на эту частоту')
	end

	local result, msg = ply:ConnectTalkie(freq)
	if result == false then
		return ply:Notify('warning', msg or 'Твоя рация не может переключиться на эту частоту')
	end
	ply.nextChannelChange = CurTime() + 1.5

end)

concommand.Add('toggle_talkie', function(ply)
	if ply:HasTalkie() and ply:Alive() then
		if ply:IsTalkieDisabled() then
			ply:SetLocalVar('TalkieDisabled', nil)
			ply:Notify('hint', L.enable_radio)
		else
			ply:SetLocalVar('TalkieDisabled', true)
			ply:Notify('hint', L.disable_radio)
		end
	else
		ply:Notify('warning', L.you_dont_have_radio)
	end
end)

netstream.Hook('dbg-talkie.toggleParenting', function(ply)
	ply:SetLocalVar('NoTalkieParenting', not ply:GetNetVar('NoTalkieParenting') or nil)
end)

--[[-------------------------------------------------------------------------
---------------------------------------------------------------------------]]

octolib.func.loop(function(done)
	octolib.func.throttle(player.GetAll(), 10, 0.2, function(ply)

		if not IsValid(ply) then return end
		if not ply:HasTalkie() or ply:IsTalkieDisabled() or not ply:GetNetVar('UsingTalkie') then return end

		local weapon = ply:GetActiveWeapon()
		if not IsValid(weapon) then return end

		if weapon:GetHoldType() ~= 'passive' and not ply:Crouching() and not ply:InVehicle() then
			ply.last_wep = {wep = weapon:GetClass(), hold = weapon:GetHoldType()}
			weapon:SetHoldType('passive')
		end

	end):Then(done)
end)
