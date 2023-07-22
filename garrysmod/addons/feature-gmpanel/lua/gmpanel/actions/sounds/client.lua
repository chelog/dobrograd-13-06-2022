local playing = {}

netstream.Hook('dbg-event.action.sound', function(dat)

	if istable(dat.stopsounds) then
		for _,v in ipairs(dat.stopsounds) do
			if IsValid(playing[v]) then
				playing[v]:Stop()
				playing[v] = nil
			end
		end
	end

	if dat.url then

		sound.PlayURL(dat.url, 'noplay', function(st)
			if not IsValid(st) then return octolib.notify.show('warning', 'Не удалось загрузить звук. Возможно, ссылка неправильная') end
			st:SetVolume((dat.volume or 100) / 100)
			st:Play()
			local id = dat.soundId
			if id then
				if IsValid(playing[id]) then
					playing[id]:Stop()
				end
				playing[id] = st
			end
		end)

	elseif dat.file then
		local cs = CreateSound(LocalPlayer(), dat.file)
		cs:ChangeVolume((dat.volume or 100) / 100)
		cs:ChangePitch(dat.level)
		cs:Play()
		local id = dat.soundId
		if id then
			if IsValid(playing[id]) then
				playing[id]:Stop()
			end
			playing[id] = cs
		end
	end

end)

local function url(panel, data)
	local url = octolib.textEntry(panel)
	url:SetValue(data.url or ('https://www.soundhelix.com/examples/mp3/SoundHelix-Song-' .. math.random(1,16) .. '.mp3'))

	local volume = octolib.slider(panel, 'Громкость', 0, 300)
	volume:SetValue(data.volume or 100)

	return {url = url, volume = volume}
end

local function file(panel, data)
	local tp = panel:Add('DPanel')
	tp:Dock(TOP)
	tp:SetTall(30)

	local fl = octolib.textEntry(tp)
	fl:SetValue(data.file or 'physics/plastic/plastic_box_break1.wav')
	fl:Dock(FILL)

	octolib.button(tp, 'браузер', function()
		RunConsoleCommand('wire_sound_browser_open')
	end):Dock(RIGHT)

	local level = octolib.slider(panel, 'Дальность', 20, 179, 0)
	level:SetValue(data.level or 75)

	local pitch = octolib.slider(panel, 'Высота', 0, 255, 0)
	pitch:SetValue(data.pitch or 100)

	local volume = octolib.slider(panel, 'Громкость', 0, 100)
	volume:SetValue(data.volume or 100)

	return {file = fl, level = level, pitch = pitch, volume = volume}
end

gmpanel.actions.registerAction('sounds', {
	name = 'Звуки',
	icon = 'octoteam/icons/megaphone2.png',
	openSettings = function(panel, data)
		panel.src = {}
		local b = octolib.comboBox(panel, nil, {{'По URL', nil, true,}, {'Внутриигровой',},})

		local pan = panel:Add('DPanel')
		pan:Dock(TOP)
		pan:SetPaintBackground(false)
		pan:SetTall(64)

		local soundID = octolib.textEntry(panel, 'Короткое название звука. Можно оставить пустым')
		soundID:SetValue(data.soundId or '')
		soundID:SetUpdateOnType(true)
		function soundID:OnValueChange()
			local fixed = self:GetText():gsub(' ', '')
			if fixed ~= self:GetText() then
				local cpos = self:GetCaretPos()
				self:SetText(fixed)
				self:SetCaretPos(math.min(cpos, utf8.len(fixed)))
			end
		end
		panel.soundID = soundID

		function b:OnSelect(i)
			pan:Clear()
			panel.src = i == 1 and url(pan, data) or file(pan, data)
			st = i
		end
		b:ChooseOptionID(data.file and 2 or 1)

		local stopsounds = octolib.textEntry(panel, 'Названия останавливаемых звуков через пробел. Необязательно')
		stopsounds:SetValue(string.Implode(' ', data.stopsounds or {}))
		stopsounds:SetUpdateOnType(true)
		function stopsounds:OnValueChange()
			local fixed = string.TrimLeft(self:GetText():gsub('  +', ' '), ' ')
			if fixed ~= self:GetText() then
				local cpos = self:GetCaretPos()
				self:SetText(fixed)
				self:SetCaretPos(math.min(cpos, utf8.len(fixed)))
			elseif string.EndsWith(self:GetText(), ' ') then
				local entries, realEntries, was = fixed:split(' '), {}, {}
				for _,v in ipairs(entries) do
					if v ~= '' and not was[v] then
						realEntries[#realEntries + 1], was[v] = v, true
					end
				end
				fixed = string.Implode(' ', realEntries) .. ' '
				if fixed ~= self:GetText() then
					local cpos = self:GetCaretPos()
					self:SetText(fixed)
					self:SetCaretPos(math.min(cpos, utf8.len(fixed)))
				end
			end
		end
		panel.stopsounds = stopsounds

	end,
	getData = function(panel)

		local result = {}
		result.soundId = string.Trim(utf8.sub(panel.soundID:GetText(), 1, 48))
		if result.soundId == '' then result.soundId = nil end

		result.stopsounds = {}
		local was = {}
		for _,v in ipairs(panel.stopsounds:GetText():split(' ')) do
			v = utf8.sub(v, 1, 48)
			if v ~= '' and not was[v] then
				result.stopsounds[#result.stopsounds + 1], was[v] = v, true
			end
		end

		return table.Merge(result, octolib.table.map(panel.src, function(x) return x:GetValue() end))
	end,
})
