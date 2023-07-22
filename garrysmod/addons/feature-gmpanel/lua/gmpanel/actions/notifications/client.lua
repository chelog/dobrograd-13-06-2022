gmpanel.actions.registerAction('notifications', {
	name = 'Уведомления',
	icon = 'octoteam/icons/error.png',
	openSettings = function(panel, data)
		local channel = octolib.comboBox(panel, 'Канал', {
			{'RP (Желтый цвет)', 'rp'},
			{'WARNING (Красный цвет)', 'warning'},
			{'OOC (Синий цвет)', 'ooc'},
			{'HINT (Зеленый цвет)', 'hint'},
		})
		channel:ChooseOptionID(1)
		for i = 1, #channel.Choices do
			if channel:GetOptionData(i) == data.channel then
				channel:ChooseOptionID(i)
			end
		end
		panel.channel = channel

		local text = octolib.textEntry(panel, 'Текст')
		text:SetValue(data.text or 'Случайное уведомление')
		panel.text = text

	end,
	getData = function(panel)
		local _, channel = panel.channel:GetSelected()
		return {
			text = panel.text:GetText(),
			channel = channel,
		}
	end,
})
