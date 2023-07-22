TOOL.Category = 'Dobrograd'
TOOL.Name = 'Прогресс'
TOOL.Command = nil

TOOL.Information = {
	{ name = 'left' },
	{ name = 'right' },
	{ name = 'reload' },
}

local vars = {
	time = 3,
	name = 'Работа',
	animTime = 2,
	mode = 0,
	animAction = 'drop',
	animSound = '',
	duration = 10,
	title = L.title2,
	text = L.trigger_text,
	method = 'chat',
	gamesound = '',
	urlsound = '',
	volume = 0.5,
	bind = 0,
	requirements = {},
	passwordMsg = '',
	passwordMsgKey = '',
}

if CLIENT then
	for k, v in pairs(vars) do
		octolib.vars.init('tools.progress.' .. k, v)
	end
end

local function doEffect(ent)

	local e = EffectData()
	e:SetEntity(ent)
	e:SetScale(1)
	util.Effect('sparkling_ent', e)

end

local varList = octolib.table.map(table.GetKeys(vars), function(v) return 'tools.progress.' .. v end)

function TOOL:LeftClick(tr)

	local ent = tr.Entity
	if not IsValid(ent) then return false end

	if SERVER then
		if ent:IsPlayer() and not self:GetOwner():IsSuperAdmin() then
			return false
		end

		local ply = self:GetOwner()
		ply:GetClientVar(varList, function(vars)
			local data = {
				name = utf8.sub(vars['tools.progress.name'] or '', 1, 255),
				time = tonumber(vars['tools.progress.time']) or 1,
				mode = tonumber(vars['tools.progress.mode']) or 0,
				duration = math.Clamp(tonumber(vars['tools.progress.duration']) or 10, 1, 300),
				title = utf8.sub(vars['tools.progress.title'], 1, 256),
				text = utf8.sub(vars['tools.progress.text'], 1, 2048),
				method = vars['tools.progress.method'],
				gamesound = utf8.sub(vars['tools.progress.gamesound'], 1, 2048),
				urlsound = ply:query(L.permissions_trigger_url) and utf8.sub(vars['tools.progress.urlsound'], 1, 2048) or nil,
				volume = math.Clamp(tonumber(vars['tools.progress.volume']) or 1, 0, 1),
				bind = tonumber(vars['tools.progress.bind']) or nil,
				animTime = tonumber(vars['tools.progress.animTime']) or 1,
				animSound = vars['tools.progress.animSound'],
				animAction = vars['tools.progress.animAction'],
				requirements = vars['tools.progress.requirements'] or {},
				passwordMsg = string.Trim(vars['tools.progress.passwordMsg'] or ''),
				passwordMsgKey = string.Trim(vars['tools.progress.passwordMsgKey'] or ''),
			}

			doEffect(ent)
			ent.ownerSID = ply:SteamID()
			ent.delayedActionData = data
			duplicator.StoreEntityModifier(ent, 'del_action', data)
		end)
	end

	return true

end

function TOOL:RightClick(tr)

	if SERVER then return false end

	local ent = tr.Entity
	local data = IsValid(ent) and ent.delayedActionData
	if not data then return false end

	for k,v in pairs(data) do
		octolib.vars.set('tools.progress.' .. k, v)
	end

	return true

end

function TOOL:Reload(tr)

	if not IsFirstTimePredicted() then return false end

	local ent = tr.Entity
	local data = IsValid(ent) and ent.delayedActionData
	if not data then return false end

	if SERVER then
		ent.delayedActionData = nil
		duplicator.ClearEntityModifier(ent, 'del_action')
	end

	doEffect(ent)

	return true

end

function TOOL:BuildCPanel()

	self:AddControl('Header', {
		Text = 'Прогресс',
		Description = 'Этот инструмент поможет создать задержку взаимодействия с предметами'
	}):DockMargin(0, 10, 0, 10)

	octolib.vars.slider(self, 'tools.progress.time', L.time, 0.1, 60, 0):DockMargin(0, 10, 0, 0)
	octolib.vars.textEntry(self, 'tools.progress.name', L.title)
	octolib.vars.comboBox(self, 'tools.progress.mode', 'Режим повторения', {
		{'Сколько угодно раз', 0,},
		{'По одному разу на игрока', 1,},
		{'Всего один раз', 2,},
	})

	octolib.button(self, 'Редактировать требования', function()
		local editor = octolib.dataEditor.open('tool.progress.requirements')
		editor.frame:SetWide(700)
		editor.frame:Center()
	end):DockMargin(0, 10, 0, 10)

	octolib.vars.textEntry(self, 'tools.progress.passwordMsg', 'Уведомление при отсутствии пароля')
	octolib.vars.textEntry(self, 'tools.progress.passwordMsgKey', 'Уведомление при отсутствии ключа')

	self:Help('')

	self:Help('Каждый период во время выполнения отложенного действия будет воспроизводиться анимация')
	octolib.vars.slider(self, 'tools.progress.animTime', L.time, 0.1, 10, 2):DockMargin(0, 10, 0, 0)
	octolib.vars.comboBox(self, 'tools.progress.animAction', L.action, {
		{'Нет', false,},
		{'Одобрять', 'agree',},
		{'Есть', 'eat'},
		{'Кланяться', 'bow',},
		{'Махать пальцем', 'disagree',},
		{'Махать рукой', 'wave',},
		{'Делать', 'drop',},
		{'Бросать предмет', 'throw',},
		{'Махать перед собой', 'shove',},
		{'Давать предмет', 'give',},
	})

	octolib.vars.textEntry(self, 'tools.progress.animSound', L.game_sound)
	self:Button(L.browser_sound, 'wire_sound_browser_open'):DockMargin(0, 10, 0, 0)

	self:Help('')

	self:Help('После выполнения отложенного действия может быть выполнен функционал триггера')
	octolib.vars.slider(self, 'tools.progress.duration', L.duration_sec, 1, 300, 0):DockMargin(0, 10, 0, 0)
	octolib.vars.textEntry(self, 'tools.progress.title', L.title2)

	local e = octolib.vars.textEntry(self, 'tools.progress.text', L.text)
	e:SetMultiline(true)
	e:SetTall(150)
	e:SetContentAlignment(7)

	octolib.vars.comboBox(self, 'tools.progress.method', L.trigger_type_notification, {
		{L.trigger_chat, 'chat'},
		{L.trigger_center, 'center'},
		{L.notification, 'notify'},
	})

	octolib.vars.textEntry(self, 'tools.progress.gamesound', L.game_sound)
	self:Button(L.browser_sound, 'wire_sound_browser_open'):DockMargin(0, 10, 0, 0)
	local eURL = octolib.vars.textEntry(self, 'tools.progress.urlsound', L.url_sound)
	if not LocalPlayer():query(L.permissions_trigger_url) then eURL:SetEnabled(false) end
	octolib.vars.slider(self, 'tools.progress.volume', L.volume, 0, 1, 2):DockMargin(0, 10, 0, 0)
	octolib.vars.binder(self, 'tools.progress.bind', L.binder, 0):DockMargin(0, 10, 0, 0)

	-- fuck DForm
	for _, pnl in ipairs(self:GetChildren()) do
		pnl:DockPadding(10, 0, 10, 0)
	end

end

if CLIENT then
	local function openEditor(save, row)
		local f = vgui.Create 'DFrame'
		f:SetSize(400, 600)
		f:SetTitle("Прогресс - Добавить требование")
		f:MakePopup()
		f:Center()

		local mode = octolib.comboBox(f, 'Пароль или ключ?', {
			{"Ключ", 0, true},
			{"Пароль", 1}
		})

		local class, tclass = octolib.textEntry(f, 'Класс предмета')
		local password, tpassword = octolib.textEntry(f, 'Пароль')
		password:Hide()
		tpassword:Hide()

		local amount, tamount = octolib.textEntry(f, 'Количество')
		amount:SetNumeric(true)

		local take = octolib.checkBox(f, 'Забирать после использования?')

		mode.OnSelect = function(self, index, text, data)
			if data == 0 then
				class:Show()
				tclass:Show()
				amount:Show()
				tamount:Show()
				password:Hide()
				tpassword:Hide()
			else
				class:Hide()
				tclass:Hide()
				amount:Hide()
				tamount:Hide()
				password:Show()
				tpassword:Show()
			end
		end

		octolib.button(f, 'Добавить', function()
			save({
				class = class:GetValue(),
				password = password:GetValue() or nil,
				amount = tonumber(amount:GetValue()) or 1,
				take = tobool(take:GetChecked()),
			})
			f:Remove()
		end)
	end

	octolib.dataEditor.register('tool.progress.requirements', {
		name = 'Прогресс - Требования',
		columns = {
			{ field = 'class', name = 'Предмет' },
			{ field = 'password', name = 'Пароль' },
			{ field = 'amount', name = 'Количество' },
			{ field = 'take', name = 'Забирать?' },
		},
		load = function(load)
			load(octolib.vars.get('tools.progress.requirements') or {})
		end,
		save = function(rows)
			octolib.vars.set('tools.progress.requirements', rows)
		end,
		new = function(save)
			openEditor(save)
		end,
		edit = function(row, save)
			openEditor(save, row)
		end,
	})

	language.Add('Tool.progress.name', 'Прогресс')
	language.Add('Tool.progress.desc', 'Добавь задержку на взаимодействие с любым предметом')
	language.Add('Tool.progress.left', L.assign)
	language.Add('Tool.progress.right', L.tool_copy)
	language.Add('Tool.progress.reload', L.remove)
end
