gmpanel.actions.registerAction('karma', {
	name = 'Карма',
	icon = 'octoteam/icons/star.png',
	openSettings = function(panel, data)

		octolib.label(panel, 'Отключает изменение кармы для игроков')
		octolib.label(panel, 'Сбрасывается, если игрок перезайдет')
		octolib.label(panel, 'ПОЖАЛУЙСТА, НЕ ЗАБУДЬ ВЕРНУТЬ ОБРАТНО ПОСЛЕ ИВЕНТА!'):SetFont('DermaDefaultBold')

		local onoff = octolib.checkBox(panel, 'Не снимать карму')
		if data.value == nil then
			onoff:SetChecked(true)
		else onoff:SetChecked(data.value) end
		panel.status = onoff

	end,
	getData = function(panel)
		return IsValid(panel.status) and panel.status:GetChecked()
	end,
})
