TOOL.Category = 'Dobrograd'
TOOL.Name = L.trigger .. ' (расширенный)'
TOOL.Command = nil

TOOL.Information = {
	{ name = 'left' },
}

cleanup.Register('octo_triggers_plus')

if CLIENT then
	octolib.vars.init('tools.trigger+.sx', 100)
	octolib.vars.init('tools.trigger+.sy', 100)
	octolib.vars.init('tools.trigger+.sz', 100)
	octolib.vars.init('tools.trigger+.times', 1)
	octolib.vars.init('tools.trigger+.mode', 0)
	octolib.vars.init('tools.trigger+.action', {})
else
	CreateConVar('sbox_maxocto_triggers_plus', 10)
end

function TOOL:LeftClick(tr)
	local ply = self:GetOwner()
	if not ply:query('DBG: Панель ивентов') then return false end

	if CLIENT then return true end

	ply:GetClientVar({
		'tools.trigger+.sx',
		'tools.trigger+.sy',
		'tools.trigger+.sz',
		'tools.trigger+.times',
		'tools.trigger+.mode',
		'tools.trigger+.action',
	}, function(vars)
		if not (istable(vars['tools.trigger+.action']) and vars['tools.trigger+.action'].type) then
			return ply:Notify('warning', 'Укажи действие или сценарий из панели игрового мастера')
		end

		local v = Vector(
			math.Clamp(tonumber(vars['tools.trigger+.sx']) or 1, 1, 1000),
			math.Clamp(tonumber(vars['tools.trigger+.sy']) or 1, 1, 1000),
			math.Clamp(tonumber(vars['tools.trigger+.sz']) or 1, 1, 1000)
		)

		local ent = ents.Create('octo_trigger_plus')
		ent:SetPos(tr.HitPos + Vector(0, 0, v.z / 2))
		ent:SetAngles(Angle())
		ent.size = v
		ent.times = tonumber(vars['tools.trigger+.times'])
		ent.mode = tonumber(vars['tools.trigger+.mode'])
		ent.action = istable(vars['tools.trigger+.action']) and vars['tools.trigger+.action'] or {}
		ent:Spawn()
		ent:Activate()

		undo.Create('octo_trigger_plus')
		undo.AddEntity(ent)
		undo.SetPlayer(ply)
		undo.Finish()
		ply:AddCount('octo_triggers_plus', ent)
		ply:AddCleanup('octo_triggers_plus', ent)
	end)

	return true
end

function TOOL:DrawHUD()

	local tr = LocalPlayer():GetEyeTrace()
	if not tr.Hit then return end

	local ang = Angle()
	local v = Vector(
		(tonumber(octolib.vars.get('tools.trigger+.sx')) or 1) / 2,
		(tonumber(octolib.vars.get('tools.trigger+.sy')) or 1) / 2,
		(tonumber(octolib.vars.get('tools.trigger+.sz')) or 1) / 2
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
		Description = 'Привет! Это версия триггера, в котором предусмотрено больше возможностей для срабатывания. Доступен этот инструмент только членам нашей команды'
	})

	local ply = LocalPlayer()
	if IsValid(ply) and not ply:query('DBG: Панель ивентов') then return end

	octolib.vars.presetManager(self, 'tools.trigger+', {
		'tools.trigger+.sy',
		'tools.trigger+.sx',
		'tools.trigger+.sz',
		'tools.trigger+.times',
		'tools.trigger+.mode',
		'tools.trigger+.action',
	})

	octolib.vars.checkBox(self, 'tools.trigger+.draw', L.show_existing)

	octolib.vars.slider(self, 'tools.trigger+.sy', L.width, 1, 1000, 0)
	octolib.vars.slider(self, 'tools.trigger+.sx', L.depth, 1, 1000, 0)
	octolib.vars.slider(self, 'tools.trigger+.sz', L.height, 1, 1000, 0)

	self:Help('')

	octolib.vars.slider(self, 'tools.trigger+.times', L.trigger_times, 0, 10, 0)
	self:ControlHelp(L.trigger_times_hint)
	octolib.vars.comboBox(self, 'tools.trigger+.mode', 'Отсчет срабатываний', {
		{'Для каждого игрока отдельно', 0},
		{'Для всех игроков вместе', 1},
	})

	self:Help('')

	local actionBtn = octolib.button(self, 'Выбери действие или сценарий', function()
		local menu = DermaMenu()
			-- scenarios
			for _,v in ipairs(gmpanel.scenarios.list) do
				menu:AddOption(v._name, function()
					octolib.vars.set('tools.trigger+.action', {
						type = 'scenario',
						obj = v,
					})
				end):SetIcon(v._icon)
			end
			menu:AddSpacer()
			-- actions
			for _, v in ipairs(gmpanel.actions.added) do
				menu:AddOption(v._name, function()
					octolib.vars.set('tools.trigger+.action', {
						type = 'action',
						obj = v,
					})
				end):SetIcon(v._icon)
			end
		menu:Open()
	end)
	self:ControlHelp('Выбранное действие или сценарий не синхронизируется с существующим! После изменений сценария или действия в панели игрового мастера нужно заново выбрать этот сценарий или действие здесь')

	hook.Add('octolib.setVar', 'tools.trigger+.action', function(var, val)
		if var ~= 'tools.trigger+.action' then return end
		actionBtn:SetText(val.obj._name)
		actionBtn:SetImage(val.obj._icon)
	end)

	self:Help('')
	self:Help('В связи с особенностями архитектуры игровой панели и триггеров, действия будут выполняться только когда тот, кто его установил, на сервере')

	-- fuck DForm
	for _, pnl in ipairs(self:GetChildren()) do
		pnl:DockPadding(10, 0, 10, 0)
	end

end

if CLIENT then
	language.Add('Tool.octo_trigger_plus.name', 'OctoTriggers+')
	language.Add('Tool.octo_trigger_plus.desc', L.trigger_desc .. ', версия для администраторов и игровых мастеров')
	language.Add('Tool.octo_trigger_plus.left', L.trigger_left)
	language.Add('Undone_octo_trigger_plus', L.trigger_undone)
	language.Add('Cleanup_octo_triggers_plus', L.triggers_plus)
	language.Add('Cleaned_octo_triggers_plus', L.trigger_cleaned)
	language.Add('SBoxLimit.octo_trigger_plus', L.trigger_limit)
end
