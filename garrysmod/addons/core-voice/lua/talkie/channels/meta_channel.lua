talkie.channelMeta = talkie.channelMeta or {}
talkie.channels = talkie.channels or {}

local Channel = talkie.channelMeta
Channel.__index = Channel

function talkie.createChannel(freq)

	if not freq then return ErrorNoHalt('Attempted to create channel without frequency') end
	talkie.channels[freq] = talkie.channels[freq] or {}

	local chan = talkie.channels[freq]
	chan.frequency = freq
	chan.canListen, chan.canSpeak = {}, {}
	setmetatable(chan, Channel)

	chan._updateSpeaking = octolib.func.debounceStart(Channel._updateSpeaking, 1)
	chan._updateListening = octolib.func.debounceStart(Channel._updateListening, 1)

	return chan

end

function Channel:IsListeningAllowed(ply)
	return true -- to be overriden
end
function Channel:IsSpeakingAllowed(ply)
	return true -- to be overriden
end

Channel._updateSpeaking = function(self, ply)

	if not IsValid(ply) then return end

	local previous = self.canSpeak[ply]
	local new = self:IsSpeakingAllowed(ply) or nil
	self.canSpeak[ply] = new
	if previous ~= new then
		ply:SyncTalkieChannels()
	end

end

Channel._updateListening = function(self, ply)
	if not IsValid(ply) then return end

	local previous = self.canListen[ply]
	local new = self:IsListeningAllowed(ply) or nil
	self.canListen[ply] = new
	if previous ~= new then
		ply:SyncTalkieChannels()
	end

	if not new and ply:GetFrequency() == self.frequency then
		ply:DisconnectTalkie()
	end

end
