local origin
timer.Simple(0, function()
	origin = octolib.dataEditor.registered['tool.lookable.pages']
end)

gmpanel.actions.registerAction('lookable', {
	name = 'Осмотреть',
	icon = octolib.icons.color('search'),
	openSettings = function(panel, data)

		octolib.label(panel, 'Звук перелистывания страниц (локальный или по URL):')
		local tp = panel:Add('DPanel')
		tp:Dock(TOP)
		tp:SetTall(30)

		local snd = octolib.textEntry(tp)
		if data.sound then
			snd:SetValue(data.sound.url or data.sound.file)
		end
		snd:SetPlaceholderText('Без звука')
		snd:Dock(FILL)
		panel.snd = snd

		octolib.button(tp, 'браузер', function()
			RunConsoleCommand('wire_sound_browser_open')
		end):Dock(RIGHT)

		local vol = octolib.slider(panel, 'Громкость звука', 0, 1, 2)
		vol:SetValue(data.sound and data.sound.volume or 1)
		panel.vol = vol
		local dist = octolib.slider(panel, 'Дальность звука', 50, 5000, 0)
		dist:SetValue(data.sound and data.sound.dist or 200)
		panel.dist = dist

		local wrap = panel:Add('DPanel')
		wrap:Dock(TOP)
		wrap:SetTall(275)
		wrap:SetPaintBackground(false)
		local editorData = table.Copy(origin)
		editorData.load = function(load)
			load(editorData.pages or octolib.vars.get('tools.lookable.pages') or {})
		end
		editorData.save = octolib.func.zero
		local editor = octolib.dataEditor.open(editorData)
		local fr = editor.frame
		for _, v in ipairs(editor.frame:GetChildren()) do
			if v ~= fr.btnClose and v ~= fr.btnMaxim and v ~= fr.btnMinim and v ~= fr.lblTitle then
				v:SetParent(wrap)
			end
		end
		editor.frame:Remove()
		panel.getCache = editor.getCache

	end,
	getData = function(panel)
		local path = panel.snd:GetValue()
		local dist = panel.dist:GetValue()
		local isURL = path:sub(1, 4) == 'http'

		local data = { pages = panel.getCache() }
		if string.Trim(path) ~= '' then
			data.sound = {
				volume = tonumber(panel.vol:GetValue()) or 1,

				url = isURL and path or nil,
				dist = isURL and dist or nil,
				distInner = isURL and (dist * 0.1) or nil,

				file = not isURL and path or nil,
				level = not isURL and (dist / 4) or nil,
			}
		end

		return { data = data }
	end,
})
