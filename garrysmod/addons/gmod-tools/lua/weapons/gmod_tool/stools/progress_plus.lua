TOOL.Category = 'Dobrograd'
TOOL.Name = 'Прогресс (расширенный)'
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
	action = {},
	bind = 0,
	requirements = {},
	passwordMsg = '',
	passwordMsgKey = '',
}

if CLIENT then
	for k, v in pairs(vars) do
		octolib.vars.init('tools.progress+.' .. k, v)
	end
end

local function doEffect(ent)

	local e = EffectData()
	e:SetEntity(ent)
	e:SetScale(1)
	util.Effect('sparkling_ent', e)

end

local varList = octolib.table.map(table.GetKeys(vars), function(v) return 'tools.progress+.' .. v end)

if SERVER then
	netstream.Listen('tools.progress+.delayedActionData', function(reply, _, ent)
		reply(IsValid(ent) and ent.delayedActionData or {})
	end)
end

function TOOL:LeftClick(tr)

	local ent = tr.Entity
	if not IsValid(ent) then return false end
	local ply = self:GetOwner()
	if not ply:query('DBG: Панель ивентов') then return false end

	if SERVER then
		if ent:IsPlayer() and not self:GetOwner():IsSuperAdmin() then
			return false
		end

		local ply = self:GetOwner()
		local owner = ent:CPPIGetOwner()
		if owner ~= ply then
			return ply:Notify('warning', 'Этот инструмент можно применять только на своих пропах')
		end

		ply:GetClientVar(varList, function(vars)
			local data = {
				name = utf8.sub(vars['tools.progress+.name'] or '', 1, 255),
				time = tonumber(vars['tools.progress+.time']) or 1,
				mode = tonumber(vars['tools.progress+.mode']) or 0,
				duration = math.Clamp(tonumber(vars['tools.progress+.duration']) or 10, 1, 300),
				action = istable(vars['tools.progress+.action']) and vars['tools.progress+.action'] or {},
				bind = tonumber(vars['tools.progress+.bind']) or nil,
				animTime = tonumber(vars['tools.progress+.animTime']) or 1,
				animSound = vars['tools.progress+.animSound'],
				animAction = vars['tools.progress+.animAction'],
				requirements = vars['tools.progress+.requirements'] or {},
				passwordMsg = string.Trim(vars['tools.progress+.passwordMsg'] or ''),
				passwordMsgKey = string.Trim(vars['tools.progress+.passwordMsgKey'] or ''),
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
	if not IsFirstTimePredicted() then return false end
	local ent = tr.Entity
	if not IsValid(ent) then return false end
	local ply = self:GetOwner()
	if not ply:query('DBG: Панель ивентов') then return false end

	netstream.Request('tools.progress+.delayedActionData', ent):Then(function(data)
		if table.IsEmpty(data) then return octolib.notify.show('warning', 'На этом энтити не настроено отложенное действие') end
		for k, v in pairs(data) do
			octolib.vars.set('tools.progress+.' .. k, v)
		end
		octolib.notify.show('hint', 'Настройки отложенного действия скопированы')
	end)

	return true

end

function TOOL:Reload(tr)

	if not IsFirstTimePredicted() then return false end
	local ply = self:GetOwner()
	if not ply:query('DBG: Панель ивентов') then return false end

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
		Description = 'Привет! Это версия инструмента "Прогресс", в которой предусмотрено больше возможностей для срабатывания. Доступен этот инструмент только членам нашей команды'
	}):DockMargin(0, 10, 0, 10)

	local ply = LocalPlayer()
	if IsValid(ply) and not ply:query('DBG: Панель ивентов') then return end

	octolib.vars.presetManager(self, 'tools.progress+', varList)

	octolib.vars.slider(self, 'tools.progress+.time', L.time, 0.1, 60, 0):DockMargin(0, 10, 0, 0)
	octolib.vars.textEntry(self, 'tools.progress+.name', L.title)
	octolib.vars.comboBox(self, 'tools.progress+.mode', 'Режим повторения', {
		{'Сколько угодно раз', 0,},
		{'По одному разу на игрока', 1,},
		{'Всего один раз', 2,},
	})

	octolib.button(self, 'Редактировать требования', function()
		local editor = octolib.dataEditor.open('tool.progress+.requirements')
		editor.frame:SetWide(700)
		editor.frame:Center()
	end):DockMargin(0, 10, 0, 10)

	octolib.vars.textEntry(self, 'tools.progress+.passwordMsg', 'Уведомление при отсутствии пароля')
	octolib.vars.textEntry(self, 'tools.progress+.passwordMsgKey', 'Уведомление при отсутствии ключа')

	self:Help('')

	self:Help('Каждый период во время выполнения отложенного действия будет воспроизводиться анимация')
	octolib.vars.slider(self, 'tools.progress+.animTime', L.time, 0.1, 10, 2):DockMargin(0, 10, 0, 0)
	octolib.vars.comboBox(self, 'tools.progress+.animAction', L.action, {
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

	octolib.vars.textEntry(self, 'tools.progress+.animSound', L.game_sound)
	self:Button(L.browser_sound, 'wire_sound_browser_open'):DockMargin(0, 10, 0, 0)

	self:Help('')

	self:Help('После выполнения отложенного действия может быть выполнено действие или сценарий из панели игровых мастеров')
	local actionBtn = octolib.button(self, 'Выбери действие или сценарий', function()
		local menu = DermaMenu()
			-- scenarios
			for _,v in ipairs(gmpanel.scenarios.list) do
				menu:AddOption(v._name, function()
					octolib.vars.set('tools.progress+.action', {
						type = 'scenario',
						obj = v,
					})
				end):SetIcon(v._icon)
			end
			menu:AddSpacer()
			-- actions
			for _, v in ipairs(gmpanel.actions.added) do
				menu:AddOption(v._name, function()
					octolib.vars.set('tools.progress+.action', {
						type = 'action',
						obj = v,
					})
				end):SetIcon(v._icon)
			end
		menu:Open()
	end)
	self:ControlHelp('Выбранное действие или сценарий не синхронизируется с существующим! После изменений сценария или действия в панели игрового мастера нужно заново выбрать этот сценарий или действие здесь')
	self:Help('В связи с особенностями архитектуры игровой панели, действия будут выполняться от имени владельца пропа, на котором установлен прогресс. Им должен быть онлайн игрок')

	hook.Add('octolib.setVar', 'tools.trigger+.action', function(var, val)
		if not (var == 'tools.progress+.action' and IsValid(actionBtn)) then return end
		actionBtn:SetText(val.obj._name)
		actionBtn:SetImage(val.obj._icon)
	end)

	self:Help('')
	octolib.vars.binder(self, 'tools.progress+.bind', L.binder, 0):DockMargin(0, 10, 0, 0)

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

	octolib.dataEditor.register('tool.progress+.requirements', {
		name = 'Прогресс - Требования',
		columns = {
			{ field = 'class', name = 'Предмет' },
			{ field = 'password', name = 'Пароль' },
			{ field = 'amount', name = 'Количество' },
			{ field = 'take', name = 'Забирать?' },
		},
		load = function(load)
			load(octolib.vars.get('tools.progress+.requirements') or {})
		end,
		save = function(rows)
			octolib.vars.set('tools.progress+.requirements', rows)
		end,
		new = function(save)
			openEditor(save)
		end,
		edit = function(row, save)
			openEditor(save, row)
		end,
	})

	language.Add('Tool.progress_plus.name', 'Прогресс+')
	language.Add('Tool.progress_plus.desc', 'Добавь задержку на взаимодействие с любым предметом, версия для администраторов и игровых мастеров')
	language.Add('Tool.progress_plus.left', L.assign)
	language.Add('Tool.progress_plus.right', L.tool_copy)
	language.Add('Tool.progress_plus.reload', L.remove)
end
