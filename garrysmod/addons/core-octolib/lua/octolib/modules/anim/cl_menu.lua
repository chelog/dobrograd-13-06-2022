function octolib.createAnimSelectMenu()

	local hasDonate = LocalPlayer():GetNetVar('os_dobro')

	local menu = DermaMenu()

	for catID, cat in SortedPairsByMemberValue(octolib.animations, 'order') do
		local catOpt = menu:AddSubMenu(cat.name)

		for i, anim in pairs(cat.anims) do
			local opt = catOpt:AddOption(anim[1], function() netstream.Start('player-anim', catID, i) end)
			if cat.donate and not hasDonate then opt:SetAlpha(75) end
		end
	end

	local rows = octolib.vars.get('faceposes') or {}
	local catOpt = menu:AddSubMenu('Эмоции')
	catOpt:AddOption('Нейтральность', function() netstream.Start('player-flex', {}) end)
	for _, row in pairs(rows) do
		catOpt:AddOption(row.name, function() netstream.Start('player-flex', row.flexes) end)
	end
	if #rows > 0 then catOpt:AddSpacer() end
	catOpt:AddOption('Редактор эмоций...', function()
		octolib.dataEditor.open('faceposes')
	end):SetIcon('icon16/pencil.png')

	return menu

end

hook.Add('CreateMove', 'player-anim', function()

	if input.WasKeyPressed(KEY_F2) and not vgui.CursorVisible() then
		gui.EnableScreenClicker(true)

		local menu = octolib.createAnimSelectMenu()
		menu:Open()
		menu:Center()

		gui.EnableScreenClicker(false)
	end

end)
