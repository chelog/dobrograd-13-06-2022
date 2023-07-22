gmpanel.actions.registerAction('hunger', {
	name = 'Голод',
	icon = 'octoteam/icons/food_meat3.png',
	openSettings = function(panel, data)

		local lbl = octolib.label(panel, 'Отключает голод игрокам. НЕ ЗАБУДЬ ВКЛЮЧИТЬ ОБРАТНО ПОСЛЕ ИВЕНТА!')
		lbl:SetMultiline(true)
		lbl:SetWrap(true)
		lbl:SetTall(25)

		local onoff = octolib.checkBox(panel, 'Не снимать голод')
		if data.value == nil then
			onoff:SetChecked(true)
		else onoff:SetChecked(data.value) end
		panel.status = onoff

	end,
	getData = function(panel)
		return IsValid(panel.status) and panel.status:GetChecked()
	end,
})
