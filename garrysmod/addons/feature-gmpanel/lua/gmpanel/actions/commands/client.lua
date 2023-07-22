gmpanel.actions.registerAction('commands', {
	name = 'Команды',
	icon = 'octoteam/icons/fingerprint.png',
	openSettings = function(panel, data)

		octolib.label(panel, 'Отправляет от имени гейм-мастера сообщение')
		local lbl = octolib.label(panel, '@p в сообщении заменяется на SteamID для каждого игрока в группе')
		lbl:SetMultiline(true)
		lbl:SetWrap(true)
		lbl:SetTall(25)
		local cmd = octolib.textEntry(panel, 'Команда:')
		cmd:SetValue(data.value or '~bring @p')
		panel.cmd = cmd

	end,
	getData = function(panel)
		return IsValid(panel.cmd) and panel.cmd:GetText() or nil
	end,
})
