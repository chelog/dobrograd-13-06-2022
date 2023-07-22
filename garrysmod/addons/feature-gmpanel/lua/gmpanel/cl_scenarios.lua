gmpanel.scenarios = gmpanel.scenarios or {}
gmpanel.scenarios.list = gmpanel.scenarios.list or {}
gmpanel.scenarios.active = gmpanel.scenarios.active or {}

pcall(function()
	local f = file.Read('gmpanel_scenarios.dat')
	if f then gmpanel.scenarios.list = pon.decode(f) or {} end
end)

gmpanel.scenarios.save = octolib.func.debounce(function()
	file.Write('gmpanel_scenarios.dat', pon.encode(gmpanel.scenarios.list))
end, 1)

local pan, left, editor, scenarios, actionsPan, actions

local function defaultLinePaint(self, w, h, off)
	off = off or 0
	if self.id % 2 == 1 then
		draw.RoundedBox(4, off, off, w - off, h - off, Color(0,0,0, 35))
	end
end

local colors = CFG.skinColors
local function scenarioPaint(self, w, h)
	local off, off2 = 0, 0
	if IsValid(editor) and editor.editUid == self.uid then
		draw.RoundedBox(4, 0, 0, w, h, colors.g)
		off, off2 = 1, 2
	end
	if self.sel then
		draw.RoundedBox(4, off, off, w - off2, h - off2, Color(170,119,102))
	else defaultLinePaint(self, w, h, off2) end
end

local function addedLineSelect(self)
	for _,v in ipairs(scenarios:GetChildren()) do
		v.sel = nil
	end
	self.sel = true
end

local function onModified(self)
	local byUid = {}
	for _,v in ipairs(gmpanel.scenarios.list) do
		byUid[v.uid] = v
	end
	gmpanel.scenarios.list = {}
	for _,v in ipairs(self:GetChildren()) do
		gmpanel.scenarios.list[#gmpanel.scenarios.list + 1] = byUid[v.uid]
		v.sel = v.uid == editor.editUid or nil
	end
	gmpanel.scenarios.save()
end

local function addedLineClick(self, mcode)

	if isfunction(self.oldMP) then self:oldMP(mcode) end
	if mcode ~= MOUSE_RIGHT then return end

	self:Select()

	local saved = gmpanel.scenarios.list[self.id]
	if not saved then return end

	local menu = DermaMenu()

	menu:AddOption('Экспортировать', function()
		local data = table.Copy(saved)
		data.uid = nil
		SetClipboardText(pon.encode(data))
		octolib.notify.show('Код сценария скопирован в буфер обмена')
	end):SetIcon(octolib.icons.silk16('page_go'))

	menu:AddOption('Редактировать', function()
		if IsValid(editor) then
			editor:OpenEditor(saved)
		end
	end):SetIcon(octolib.icons.silk16('pencil'))

	menu:AddOption('Удалить', function()
		gmpanel.scenarios.edit(self.uid)
	end):SetIcon(octolib.icons.silk16('cross'))
	menu:Open()

end

local function rebuildScenarios()

	if not IsValid(left) then return end
	if IsValid(scenarios) then scenarios:Remove() end

	scenarios = left:Add('DScrollPanel')
	scenarios:Dock(FILL)
	scenarios = scenarios:Add('DListLayout')
	scenarios:Dock(FILL)
	scenarios:MakeDroppable('gmpanel.scenarios')

	function scenarios:AddPanel(i, data)
		local cont = self:Add('DPanel')
		cont:SetTall(20)
		cont.Paint = scenarioPaint
		cont:SetMouseInputEnabled(true)
		cont.id = i
		cont.uid = data.uid
		cont.oldMP, cont.OnMouseReleased, cont.Select = cont.OnMouseReleased, addedLineClick, addedLineSelect

		local icon = cont:Add('DImage')
		icon:Dock(LEFT)
		icon:SetWide(16)
		icon:DockMargin(0, 2, 5, 2)
		icon:SetImage(data._icon)

		local name = cont:Add('DLabel')
		name:Dock(FILL)
		name:SetText(data._name)

		return cont
	end

	for i,v in ipairs(gmpanel.scenarios.list) do
		scenarios:AddPanel(i, v)
	end
	scenarios.OnModified = onModified

end

function gmpanel.scenarios.execute(scenData, players)
	local uid = table.Count(gmpanel.scenarios.active) + 1

	local actions, size = {}, #scenData.actions
	for num, action in ipairs(scenData.actions) do
		local predefined = gmpanel.actions.available[action.id]
		if predefined then
			actions[#actions + 1] = function(nxt)
				netstream.Request('dbg-event.mapPlayerNames', players):Then(function(names)
					gmpanel.scenarios.active[uid] = { num .. ' / ' .. size, predefined.name, table.concat(names, ', ') }
					timer.Create('gmpanel.scenario.' .. uid, action._delay or 0, 1, function()
						local func = predefined.execute or gmpanel.actions.defaultExecute
						func(action, players)
						nxt()
					end)
				end)
			end
		end
	end
	actions[#actions + 1] = function(nxt)
		gmpanel.scenarios.active[uid] = nil
	end

	octolib.func.chain(actions)
end

function gmpanel.scenarios.add(scenData)
	scenData.uid = octolib.string.uuid():sub(1, 8)
	gmpanel.scenarios.list[#gmpanel.scenarios.list + 1] = scenData
	gmpanel.scenarios.save()
	rebuildScenarios()
	return true
end

function gmpanel.scenarios.edit(uid, scenData)

	if not uid then return end
	local idx
	for i,v in ipairs(gmpanel.scenarios.list) do
		if v.uid == uid then
			idx = i
			break
		end
	end
	if not idx then return end

	if not scenData then

		table.remove(gmpanel.scenarios.list, idx)
		if IsValid(editor) and editor.editUid == uid then editor.editUid = nil end
		rebuildScenarios()

	else
		gmpanel.scenarios.list[idx] = scenData
		if IsValid(scenarios) then
			local cont = scenarios:GetChildren()[idx]
			cont:GetChildren()[1]:SetImage(scenData._icon)
			cont:GetChildren()[2]:SetText(scenData._name)
		end
	end

	gmpanel.scenarios.save()

end

hook.Add('gmpanel.populateActionsMenu', 'gmpanel.scenarios', function(menu, players)
	for _,v in ipairs(gmpanel.scenarios.list) do
		menu:AddOption(v._name, function()
			gmpanel.scenarios.execute(v, players)
		end):SetIcon(v._icon)
	end
	menu:AddSpacer()
end)

function gmpanel.scenarios.close()
	if IsValid(pan) then
		pan:Close()
	end
end

function gmpanel.scenarios.updateActions()

	if IsValid(actions) then actions:Remove() end
	if not IsValid(actionsPan) then return end

	actions = actionsPan:Add('DListLayout')
	actions:Dock(FILL)
	actions:MakeDroppable('gmpanel.actions.added')

	-- timer.Simple(0, function()
		for i,data in ipairs(gmpanel.actions.added) do

			local cont = actions:Add('DPanel')
			cont:Dock(TOP)
			cont:SetTall(20)
			cont.Paint = defaultLinePaint
			cont:SetMouseInputEnabled(true)
			cont.data = data
			cont.id = i

			local icon = cont:Add('DImage')
			icon:Dock(LEFT)
			icon:SetWide(16)
			icon:DockMargin(0, 2, 5, 2)
			icon:SetImage(data._icon)

			local name = cont:Add('DLabel')
			name:Dock(FILL)
			name:SetText(data._name)

		end
	-- end)

end

local function build()
	gmpanel.groups.close()

	pan = vgui.Create('DFrame')
	pan:SetSize(700, 500)
	pan:SetTitle('Сценарии')
	pan:Center()
	pan:MakePopup()
	pan:SetDeleteOnClose(true)
	pan:SetSizable(true)
	pan:SetMinWidth(700)
	pan:SetMinHeight(500)

	left = pan:Add('DPanel')
	left:Dock(LEFT)
	left:SetWide(150)

	rebuildScenarios()

	local btnImport = left:Add('DButton')
	btnImport:Dock(BOTTOM)
	btnImport:SetTall(20)
	btnImport:DockMargin(0, 5, 0, 0)
	btnImport:SetText('Импорт сценария')
	btnImport:SetIcon(octolib.icons.silk16('page_code'))
	function btnImport:DoClick()
		Derma_StringRequest('Импорт сценария', 'Вставь код сценария, полученный при экспорте', '', function(inp)
			local succ, data = pcall(pon.decode, inp)
			if not succ or not istable(data) then
				return octolib.notify.show('warning', 'Кажется, код сценария поврежден')
			end
			gmpanel.scenarios.add(data)
		end)
	end

	local btnCreate = left:Add('DButton')
	btnCreate:Dock(BOTTOM)
	btnCreate:SetTall(20)
	btnCreate:DockMargin(0, 5, 0, 0)
	btnCreate:SetText('Создать сценарий')
	btnCreate:SetIcon('octoteam/icons-16/page_white_put.png')
	function btnCreate:DoClick()
		editor:OpenEditor({})
		for _,v in ipairs(scenarios:GetChildren()) do
			v.sel = nil
		end
	end

	editor = pan:Add('gmp_scenario_editor')
	editor:Dock(FILL)

	actionsPan = pan:Add('DPanel')
	actionsPan:Dock(RIGHT)
	actionsPan:SetWide(150)
	actionsPan:SetPaintBackground(false)
	actionsPan = actionsPan:Add('DScrollPanel')
	actionsPan:Dock(FILL)
	actionsPan:DockMargin(5, 0, 0, 0)
	local lbl = octolib.label(actionsPan, 'Заготовленные действия')
	lbl:DockMargin(0, 0, 0, 5)
	lbl:SetContentAlignment(5)
	gmpanel.scenarios.updateActions()

end

function gmpanel.scenarios.open()
	build()
end
