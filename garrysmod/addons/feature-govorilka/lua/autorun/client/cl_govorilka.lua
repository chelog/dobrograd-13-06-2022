CreateClientConVar('cl_govorilka_voice', 'zahar', true, true)
local useProxy = false
local link = {
	[false] = 'http://tts.voicetech.yandex.net/tts?speaker=%s&text=%s',
	[true] = 'https://octothorp.team/api/tts/y/%s/%s',
}

local function init()
	link[true] = CFG.octoservicesURL .. '/tts/y/%s/%s'

	local encode = link[false]:format('zahar', octolib.string.urlEncode('-'))
	sound.PlayURL(encode, 'noplay 3d', function(station)
		if IsValid(station) then
			station:SetPos(LocalPlayer():GetPos())
			station:SetVolume(2)
			station:Play()
			useProxy = false
		else
			useProxy = true
		end
	end)
end
if octoservices then
	init()
else
	hook.Add('octoservices.init', 'govorilka', init)
end

local meta = FindMetaTable 'Entity'
function meta:DoVoice(text, voice)

	if not IsValid(self) then return end

	local encode = (link[useProxy]):format(voice or self:GetVoice(), octolib.string.urlEncode(text))
	local flag = 'noplay 3D'
	sound.PlayURL(encode, flag, function(station)
		if IsValid(station) then
			if not IsValid(self) then return end

			station:SetPos(self:GetPos())
			station:SetVolume(2)
			station:Play()

			local timerName = 'govorilka_' .. self:EntIndex()
			timer.Create(timerName, 0.2, 0, function()
				if IsValid(station) and IsValid(self) then
					station:SetPos(self:GetPos())
				else
					timer.Remove(timerName)
				end
			end)
			timer.Create(timerName .. '_remove', 30, 1, function()
				timer.Remove(timerName)
			end)
		end
	end)

end

netstream.Hook('govorilka.play', function(ent, text, voice)

	if IsValid(ent) then
		ent:DoVoice(text, voice)
	end

end)
