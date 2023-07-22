talkie = talkie or {}

local meta = FindMetaTable 'Player'

function meta:IsUsingTalkie()
	return self:GetNetVar('UsingTalkie', false)
end

function meta:IsTalkieDisabled()
	return self:GetNetVar('TalkieDisabled', false)
end

function meta:GetFrequency()
	return self:GetNetVar('TalkieFreq', '111.1')
end
