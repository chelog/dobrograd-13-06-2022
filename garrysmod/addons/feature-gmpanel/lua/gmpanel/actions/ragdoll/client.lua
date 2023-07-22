gmpanel.actions.registerAction('ragdoll', {
	name = 'Ragdoll',
	icon = 'octoteam/icons/drug2.png',
	openSettings = function(panel, data)

		octolib.label(panel, 'Выполняет "~ragdoll" на игроках'):DockMargin(5, 5, 5, 5)
		local onoff = octolib.checkBox(panel, 'Включить')
		if data.value ~= nil then
			onoff:SetChecked(tobool(data.value))
		else onoff:SetChecked(true) end
		panel.status = onoff

	end,
	getData = function(panel)
		return panel.status:GetChecked()
	end,
})
