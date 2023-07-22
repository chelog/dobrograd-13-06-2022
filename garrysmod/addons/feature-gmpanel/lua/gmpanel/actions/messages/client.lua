gmpanel.actions.registerAction('messages', {
	name = 'Сообщения',
	icon = 'octoteam/icons/mail.png',
	openSettings = function(panel, data)

		local voices = {{'Нет', nil, true,}}
		for _,v in ipairs(govorilka.voices) do
			voices[#voices + 1] = {v.ru_name, v.en_name}
		end

		local name = octolib.textEntry(panel, 'Имя (первая часть)')
		name:SetValue(data.name or 'Иван Березкин')
		panel.name = name

		local action = octolib.textEntry(panel, 'Действие (вторая часть)')
		action:SetValue(data.action or 'говорит')
		panel.action = action

		local message = octolib.textEntry(panel, 'Текст')
		message:SetValue(data.message or 'Привет, гейм-мастер!')
		panel.message = message

		local voice = octolib.comboBox(panel, 'Озвучка', voices)
		for i = 1, #voice.Choices do
			if voice:GetOptionData(i) == data.voice then
				voice:ChooseOptionID(i)
			end
		end
		panel.voice = voice

	end,
	getData = function(panel)
		local _, v = panel.voice:GetSelected()
		return {
			name = string.Trim(panel.name:GetText()),
			action = string.Trim(panel.action:GetText()),
			message = string.Trim(panel.message:GetText()),
			voice = v,
		}
	end,
})
