govorilka = govorilka or {}
govorilka.voices = {
	{ ru_name = L.zahar, en_name = 'zahar' },
	{ ru_name = L.ermil, en_name = 'ermil' },
	{ ru_name = L.oksana, en_name = 'oksana' },
	{ ru_name = L.alyss, en_name = 'alyss' },
	{ ru_name = L.omazh, en_name = 'omazh' },
	{ ru_name = L.jane, en_name = 'jane' },
}

local plyMeta = FindMetaTable 'Entity'
function plyMeta:GetVoiceName()

	local voice = self:GetVoice()
	for _, v in ipairs(govorilka.voices) do
		if voice == v.en_name then
			return v.ru_name
		end
	end

end

function plyMeta:GetVoice()
	return self:GetNetVar('govorilka_voice', 'zahar')
end

function plyMeta:IsGovorilkaMuted()
	return self:GetNetVar('govorilka_mute', false)
end
