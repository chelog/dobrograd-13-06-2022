local function url(panel, data)
	local url = octolib.textEntry(panel)
	url:SetValue(data.url or ('https://www.soundhelix.com/examples/mp3/SoundHelix-Song-' .. math.random(1,16) .. '.mp3'))

	local volume = octolib.slider(panel, 'Громкость', 0, 300)
	volume:SetValue(data.volume or 100)

	return {url = url, volume = volume}
end

gmpanel.actions.registerAction('talkie', {
	name = 'Рация',
	icon = 'octoteam/icons/radio.png',
	openSettings = function(panel, data)
		panel.mode = data.mode or 'add'
		local b = octolib.comboBox(panel, nil, {{'Подключить'}, {'Отключить'}})

		local freq = octolib.textEntry(panel, 'Частота')
		local freqName, freqLabel = octolib.textEntry(panel, 'Название частоты (не сработает, если частота уже создана)')
		local canSpeak = octolib.checkBox(panel, 'Говорить')

		if data.speak == nil then
			data.speak = true
		end

		function b:OnSelect(i)
			panel.mode = i == 1 and 'add' or 'remove'
			if i == 1 then
				panel.mode = 'add'
				freqName:SetVisible(true)
				freqLabel:SetVisible(true)
				canSpeak:SetVisible(true)

				freqName:SetValue(data.name or '')
				canSpeak:SetChecked(data.speak or false)
			else
				panel.mode = 'remove'
				freqName:SetVisible(false)
				freqLabel:SetVisible(false)
				canSpeak:SetVisible(false)
			end

		end
		b:ChooseOptionID(panel.mode == 'add' and 1 or 2)

		panel.freq, panel.name, panel.speak = freq, freqName, canSpeak

	end,
	getData = function(panel)
		local result = {
			mode = panel.mode,
			freq = panel.freq:GetValue(),
		}
		if result.mode == 'add' then
			result.name = panel.name:GetValue()
			result.speak = panel.speak:GetChecked()
		end
		return result
	end,
})
