TOOL.Category = 'Dobrograd'
TOOL.Name = L.trigger
TOOL.Command = nil

TOOL.Information = {
	{ name = 'left' },
}

cleanup.Register('octo_triggers')

if CLIENT then
	octolib.vars.init('tools.trigger.sx', 100)
	octolib.vars.init('tools.trigger.sy', 100)
	octolib.vars.init('tools.trigger.sz', 100)
	octolib.vars.init('tools.trigger.uname', 'Триггер')
	octolib.vars.init('tools.trigger.times', 1)
	octolib.vars.init('tools.trigger.duration', 10)
	octolib.vars.init('tools.trigger.title', L.title2)
	octolib.vars.init('tools.trigger.text', L.trigger_text)
	octolib.vars.init('tools.trigger.method', 'chat')
	octolib.vars.init('tools.trigger.gamesound', '')
	octolib.vars.init('tools.trigger.urlsound', '')
	octolib.vars.init('tools.trigger.volume', 0.5)
	octolib.vars.init('tools.trigger.mode', 0)
	octolib.vars.init('tools.trigger.3d', false)
	octolib.vars.init('tools.trigger.bind', 0)
else
	CreateConVar('sbox_maxocto_triggers', 10)
end

local function getSpawnedTriggers(ply)
	local tbl, ans = undo.GetTable(), {}
	if SERVER then tbl = tbl[ply:UniqueID()] end

	for _,v in ipairs(undo.GetTable()[ply:UniqueID()] or {}) do
		if v.Entities and IsValid(v.Entities[1]) and v.Entities[1]:GetClass() == 'octo_trigger' then
			ans[#ans + 1] = v.Entities[1]
		end
	end

	return ans
end

function TOOL:LeftClick(tr)

	if CLIENT then return true end

	local ply = self:GetOwner()

	ply:GetClientVar({
		'tools.trigger.sx',
		'tools.trigger.sy',
		'tools.trigger.sz',
		'tools.trigger.uname',
		'tools.trigger.times',
		'tools.trigger.mode',
		'tools.trigger.duration',
		'tools.trigger.title',
		'tools.trigger.text',
		'tools.trigger.method',
		'tools.trigger.gamesound',
		'tools.trigger.urlsound',
		'tools.trigger.volume',
		'tools.trigger.3d',
		'tools.trigger.bind',
		'tools.trigger.stopsound',
	}, function(vars)
		local v = Vector(
			math.Clamp(tonumber(vars['tools.trigger.sx']) or 1, 1, 1000),
			math.Clamp(tonumber(vars['tools.trigger.sy']) or 1, 1, 1000),
			math.Clamp(tonumber(vars['tools.trigger.sz']) or 1, 1, 1000)
		)
		local name = utf8.sub(string.Trim(vars['tools.trigger.uname'] or 'Триггер'), 1, 128)
		if not name or name == '' then
			return ply:Notify('warning', 'Укажи уникальное название твоего триггера')
		end

		local triggers = getSpawnedTriggers(ply)
		for _,v in ipairs(triggers) do
			if v.uName == name then
				return ply:Notify('warning', 'Триггер с таким названием уже существует')
			end
		end

		local ent = ents.Create('octo_trigger')
		ent:SetPos(tr.HitPos + Vector(0, 0, v.z / 2))
		ent:SetAngles(Angle())
		ent.size = v
		ent.times = tonumber(vars['tools.trigger.times'])
		ent.mode = tonumber(vars['tools.trigger.mode'])
		ent.duration = math.Clamp(tonumber(vars['tools.trigger.duration']) or 10, 1, 300)
		ent.title = utf8.sub(vars['tools.trigger.title'], 1, 256)
		ent.text = utf8.sub(vars['tools.trigger.text'], 1, 2048)
		ent.method = vars['tools.trigger.method']
		ent.gamesound = utf8.sub(vars['tools.trigger.gamesound'], 1, 2048)
		ent.sound3d = tobool(vars['tools.trigger.3d'])
		ent.bind = vars['tools.trigger.bind']
		ent.uName = name
		if ply:query(L.permissions_trigger_url) then ent.urlsound = utf8.sub(vars['tools.trigger.urlsound'], 1, 2048) end
		ent.volume = math.Clamp(tonumber(vars['tools.trigger.volume']) or 1, 0, 1)
		ent:SetPlayer(ply)
		ent:Spawn()
		ent:Activate()

		if ent.sound3d then
			ply.pending3d = ent
			if not vars['tools.trigger.stopsound'] then
				ply:Notify('Теперь укажи точку, откуда будет идти звук (ПКМ, чтобы установить на позиции головы)')
			end
		end

		if vars['tools.trigger.stopsound'] then
			ply:Notify('Теперь выбери ранее созданные триггеры, звук которых нужно остановить')
			netstream.Start(ply, 'trigger_stopsound_sel', ent:EntIndex(), octolib.table.mapSequential(triggers, function(v) return v.uName end))
		end

		undo.Create('octo_trigger')
		undo.AddEntity(ent)
		undo.SetPlayer(ply)
		undo.Finish()
		ply:AddCount('octo_triggers', ent)
		ply:AddCleanup('octo_triggers', ent)
	end)

	return true
end

if CLIENT then
	netstream.Hook('trigger_stopsound_sel', function(ent, available)

		local fr = vgui.Create 'DFrame'
		fr:SetTitle('Выбор Stopsound-триггеров')
		fr:SetSize(200, 24)
		fr:Center()
		fr:MakePopup()

		local tall = 24
		local lst = fr:Add 'DScrollPanel'
		lst:Dock(FILL)
		local sels = {}
		for _,v in ipairs(available) do
			local pan = lst:Add('DPanel')
			pan:Dock(TOP)
			pan:DockMargin(0, 0, 0, 5)
			pan:SetTall(30)
			local cbox = octolib.checkBox(pan, v)
			cbox.uid = v
			cbox:DockMargin(5, 5, 5, 5)
			tall = tall + 40
			sels[#sels + 1] = cbox
		end

		local btn = octolib.button(fr, 'Сохранить', function()
			local ans = {}
			for _,v in ipairs(sels) do
				if v:GetChecked() then
					ans[#ans + 1] = v.uid
				end
			end
			netstream.Start('trigger_stopsound_sel', ent, ans)
			fr:Close()
		end)

		if not available[1] then
			local lbl = octolib.label(lst, 'Ранее триггеры не создавались')
			lbl:DockMargin(0, 5, 0, 5)
			lbl:SetContentAlignment(5)
			tall = tall + 40
		end

		btn:Dock(BOTTOM)
		tall = tall + 25

		fr:SetTall(tall)

	end)

else

	netstream.Hook('trigger_stopsound_sel', function(ply, ent, sel)
		if not istable(sel) then return end
		ent = Entity(ent)
		if not IsValid(ent) or ent:GetClass() ~= 'octo_trigger' or ent:CPPIGetOwner() ~= ply then return end
		local triggers = getSpawnedTriggers(ply)
		local byName = {}
		for _,v in ipairs(triggers) do
			byName[v.uName] = v.uid
		end
		ent.stopsounds = octolib.table.mapSequential(sel, function(v) return byName[v] end)
		ply:Notify('Stopsound\'ы сохранены')
		if ply.pending3d then
			ply:Notify('Теперь укажи точку, откуда будет идти звук (ПКМ, чтобы установить на позиции головы)')
		end
	end)

end

function TOOL:RightClick(tr)

	if CLIENT then return false end

	local ply = self:GetOwner()
	if IsValid(ply.pending3d) then
		if not tr.Hit then return end
		ply.pending3d:SetNetVar('sound3dpos', {ply:GetShootPos(), ply:EyeAngles()})
		ply:Notify('Точка установлена')
		ply.pending3d = nil
		return true
	end

	return false

end

function TOOL:DrawHUD()

	local tr = LocalPlayer():GetEyeTrace()
	if not tr.Hit then return end

	local ang = Angle()
	local v = Vector(
		(tonumber(octolib.vars.get('tools.trigger.sx')) or 1) / 2,
		(tonumber(octolib.vars.get('tools.trigger.sy')) or 1) / 2,
		(tonumber(octolib.vars.get('tools.trigger.sz')) or 1) / 2
	)
	local pos = tr.HitPos
	pos.z = pos.z + v.z

	cam.Start3D()
	render.DrawWireframeBox(pos, ang, -v, v, color_white, false)
	cam.End3D()

end

function TOOL:BuildCPanel()

	self:AddControl('Header', {
		Text = 'OctoTriggers',
		Description = L.trigger_description
	})

	octolib.vars.presetManager(self, 'tools.trigger', {
		'tools.trigger.sy',
		'tools.trigger.sx',
		'tools.trigger.sz',
		'tools.trigger.uname',
		'tools.trigger.method',
		'tools.trigger.title',
		'tools.trigger.text',
		'tools.trigger.duration',
		'tools.trigger.times',
		'tools.trigger.mode',
		'tools.trigger.stopsound',
		'tools.trigger.gamesound',
		'tools.trigger.urlsound',
		'tools.trigger.volume',
		'tools.trigger.3d',
		'tools.trigger.bind',
	})

	octolib.vars.checkBox(self, 'tools.trigger.draw', L.show_existing)

	octolib.vars.slider(self, 'tools.trigger.sy', L.width, 1, 1000, 0)
	octolib.vars.slider(self, 'tools.trigger.sx', L.depth, 1, 1000, 0)
	octolib.vars.slider(self, 'tools.trigger.sz', L.height, 1, 1000, 0)

	self:Help('')

	octolib.vars.textEntry(self, 'tools.trigger.uname', 'Уникальное название триггера')

	octolib.vars.comboBox(self, 'tools.trigger.method', L.trigger_type_notification, {
		{L.trigger_chat, 'chat'},
		{L.trigger_center, 'center'},
		{L.notification, 'notify'},
	})
	octolib.vars.textEntry(self, 'tools.trigger.title', L.title2)
	local e = octolib.vars.textEntry(self, 'tools.trigger.text', L.text )
	e:SetMultiline(true)
	e:SetTall(150)
	e:SetContentAlignment(7)

	octolib.vars.slider(self, 'tools.trigger.duration', L.duration_sec, 1, 300, 0)
	self:ControlHelp(L.trigger_duration_hint)

	self:Help('')

	octolib.vars.slider(self, 'tools.trigger.times', L.trigger_times, 0, 10, 0)
	self:ControlHelp(L.trigger_times_hint)
	octolib.vars.comboBox(self, 'tools.trigger.mode', 'Отсчет срабатываний', {
		{'Для каждого игрока отдельно', 0},
		{'Для всех игроков вместе', 1},
	})

	self:Help('')

	octolib.label(self, 'Звук')
	octolib.vars.checkBox(self, 'tools.trigger.stopsound', 'Останавливать звук другого триггера')

	octolib.vars.textEntry(self, 'tools.trigger.gamesound', L.game_sound)
	self:Button(L.browser_sound, 'wire_sound_browser_open')
	local eURL = octolib.vars.textEntry(self, 'tools.trigger.urlsound', L.url_sound)
	octolib.vars.slider(self, 'tools.trigger.volume', L.volume, 0, 1, 2)
	octolib.vars.checkBox(self, 'tools.trigger.3d', '3D-звук')
	octolib.vars.binder(self, 'tools.trigger.bind', L.binder)

	if not LocalPlayer():query(L.permissions_trigger_url) then eURL:SetEnabled(false) end

	-- fuck DForm
	for _, pnl in ipairs(self:GetChildren()) do
		pnl:DockPadding(10, 0, 10, 0)
	end

end

if CLIENT then
	language.Add('Tool.octo_trigger.name', 'OctoTriggers')
	language.Add('Tool.octo_trigger.desc', L.trigger_desc)
	language.Add('Tool.octo_trigger.left', L.trigger_left)
	language.Add('Undone_octo_trigger', L.trigger_undone)
	language.Add('Cleanup_octo_triggers', L.triggers)
	language.Add('Cleaned_octo_triggers', L.trigger_cleaned)
	language.Add('SBoxLimit.octo_trigger', L.trigger_limit)
end
