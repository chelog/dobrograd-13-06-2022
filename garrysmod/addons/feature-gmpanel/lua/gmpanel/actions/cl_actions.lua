gmpanel.actions = gmpanel.actions or {}
gmpanel.actions.available = gmpanel.actions.available or {}
gmpanel.actions.added = gmpanel.actions.added or {}

pcall(function()
	local f = file.Read('gmpanel_actions.dat')
	if f then gmpanel.actions.added = pon.decode(f) or {} end
end)

local pan, pAvailable, settings, active, right

local colors = CFG.skinColors
local function addedLinePaint(self, w, h)
	local off, off2 = 0, 0
	if IsValid(settings) and settings.editUid == self.uid then
		draw.RoundedBox(4, 0, 0, w, h, colors.g)
		off, off2 = 1, 2
	end
	if self.sel then
		draw.RoundedBox(4, off, off, w - off2, h - off2, Color(170,119,102))
	elseif self.id % 2 == 1 then
		draw.RoundedBox(4, off, off, w - off2, h - off2, Color(0,0,0, 35))
	end
end

local function addedLineSelect(self)
	for _,v in ipairs(active:GetChildren()) do
		v.sel = nil
	end
	self.sel = true
end

local function onModified(self)
	local byUid = {}
	for _,v in ipairs(gmpanel.actions.added) do
		byUid[v.uid] = v
	end
	gmpanel.actions.added = {}
	for _,v in ipairs(self:GetChildren()) do
		gmpanel.actions.added[#gmpanel.actions.added + 1] = byUid[v.uid]
		v.sel = v.uid == settings.editUid or nil
	end
	gmpanel.actions.save()
end

local function addedLineClick(self, mcode)

	if isfunction(self.oldMP) then self:oldMP(mcode) end
	if mcode ~= MOUSE_RIGHT then return end

	self:Select()

	local saved = gmpanel.actions.added[self.id]
	if not saved then return end

	local menu = DermaMenu()

	menu:AddOption('Экспортировать', function()
		local data = table.Copy(saved)
		data.uid = nil
		SetClipboardText(pon.encode(data))
		octolib.notify.show('Код действия скопирован в буфер обмена')
	end):SetIcon(octolib.icons.silk16('page_go'))

	menu:AddOption('Редактировать', function()

		if not IsValid(settings) then return end

		local action = gmpanel.actions.available[saved.id]
		if not action then return end

		pAvailable.dirty = true
		pAvailable:ClearSelection()
		for _,v in ipairs(pAvailable:GetLines()) do
			if v.id == saved.id then
				pAvailable:SelectItem(v)
				break
			end
		end
		pAvailable.dirty = nil

		settings:Clear()
		action.openSettings(settings, saved)
		settings.editUid = self.uid
		gmpanel.actions.insertButtons(saved.id, saved)

	end):SetIcon('octoteam/icons-16/pencil.png')

	menu:AddOption('Удалить', function()
		gmpanel.actions.editAction(self.uid)
	end):SetIcon('octoteam/icons-16/cross.png')
	menu:Open()

end

local function rebuildAdded()
	if not IsValid(pan) then return end
	if IsValid(right) then right:Remove() end
	right = pan:Add('DPanel')
	right:Dock(RIGHT)
	right:SetWide(150)
	right:SetPaintBackground(false)
	active = octolib.label(right, 'Заготовленные действия')
	active:DockMargin(0, 0, 0, 5)
	active:SetContentAlignment(5)

	active = right:Add('DScrollPanel')
	active:Dock(FILL)
	active:DockMargin(5, 0, 0, 0)
	active = active:Add('DListLayout')
	active:Dock(FILL)
	active:MakeDroppable('gmpanel.actions.added')

	function active:AddPanel(i, data)
		local cont = self:Add('DPanel')
		cont:SetTall(20)
		cont.Paint = addedLinePaint
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

	for i,v in ipairs(gmpanel.actions.added) do
		active:AddPanel(i, v)
	end
	active.OnModified = onModified

	local btnImport = right:Add('DButton')
	btnImport:Dock(BOTTOM)
	btnImport:SetTall(20)
	btnImport:DockMargin(0, 5, 0, 0)
	btnImport:SetText('Импорт действия')
	btnImport:SetIcon(octolib.icons.silk16('page_code'))
	function btnImport:DoClick()
		Derma_StringRequest('Импорт действия', 'Вставь код действия, полученный при экспорте', '', function(inp)
			local succ, data = pcall(pon.decode, inp)
			if not succ or not istable(data) then
				return octolib.notify.show('warning', 'Кажется, код действия поврежден')
			end
			gmpanel.actions.addAction(data.id, data)
		end)
	end
end

gmpanel.actions.save = octolib.func.debounce(function()
	file.Write('gmpanel_actions.dat', pon.encode(gmpanel.actions.added))
end, 1)

function gmpanel.actions.registerAction(id, action)
	gmpanel.actions.available[id] = action
end

function gmpanel.actions.addAction(id, actionData)
	if not id or not gmpanel.actions.available[id] then return end
	actionData.id = id
	actionData.uid = octolib.string.uuid():sub(1, 8)
	gmpanel.actions.added[#gmpanel.actions.added + 1] = actionData
	gmpanel.actions.save()
	rebuildAdded()
	gmpanel.scenarios.updateActions()
	return true
end

function gmpanel.actions.editAction(uid, actionData)

	if not uid then return end
	local idx
	for i,v in ipairs(gmpanel.actions.added) do
		if v.uid == uid then
			idx = i
			break
		end
	end
	if not idx then return end

	if not actionData then

		table.remove(gmpanel.actions.added, idx)
		rebuildAdded()

	else
		gmpanel.actions.added[idx] = actionData
		if IsValid(active) then
			local cont = active:GetChildren()[idx]
			cont:GetChildren()[1]:SetImage(actionData._icon)
			cont:GetChildren()[2]:SetText(actionData._name)
		end
	end

	gmpanel.scenarios.updateActions()
	gmpanel.actions.save()

end

function gmpanel.actions.close()
	if IsValid(pan) then
		pan:Remove()
	end
end

function gmpanel.actions.defaultExecute(dataPassed, players)
	dataPassed = table.Copy(dataPassed)
	local id = dataPassed.id
	dataPassed.id, dataPassed._name, dataPassed._icon = nil
	dataPassed.players = players
	netstream.Start('dbg-event.execute', id, dataPassed)
end

function gmpanel.actions.insertButtons(id, data)

	if not (id and gmpanel.actions.available[id]) then return end
	local action = gmpanel.actions.available[id]
	data = data or {}

	octolib.button(settings, 'Тест', function()

		local func = action.execute or gmpanel.actions.defaultExecute

		local data
		if isfunction(action.getData) then
			data = action.getData(settings)
		else data = {} end
		if data == nil then
			octolib.notify.show('warning', 'Кажется, не все поля заполнены верно')
			return
		end
		data = istable(data) and data or {value = data}
		data.id = id
		data.test = true

		func(data, {LocalPlayer():SteamID()})

	end)

	local btmPan = settings:Add('DPanel')
	btmPan:Dock(BOTTOM)
	btmPan:SetTall(48)
	btmPan:SetPaintBackground(false)

	local nameCont = btmPan:Add('DPanel')
	nameCont:Dock(LEFT)
	nameCont:SetWide(150)
	nameCont:SetPaintBackground(false)

	octolib.label(nameCont, 'Кнопка:')

	local wrapper = nameCont:Add('DPanel')
	wrapper:Dock(FILL)
	wrapper:DockMargin(0, 0, 0, 5)

	local icon = wrapper:Add('DImageButton')
	icon:Dock(LEFT)
	icon:DockMargin(2, 4, 2, 4)
	icon:SetSize(16, 16)
	icon:SetIcon(data._icon or 'icon16/control_play.png')
	function icon:DoClick()
		octolib.icons.picker(function(val)
			self:SetImage(val)
		end, 'materials/' .. self:GetImage(), 'materials/icon16/')
	end

	local name = wrapper:Add('DTextEntry')
	name:Dock(FILL)
	name:SetPaintBackground(false)
	name:SetTextColor(color_white)
	name:SetValue(data._name or '')

	local b = btmPan:Add('DPanel')
	b:Dock(RIGHT)
	b:DockMargin(0, 0, 0, 5)
	b:SetPaintBackground(false)
	b:SetWide(100)
	b = b:Add('DButton')
	b:Dock(BOTTOM)
	b:SetTall(30)
	b:SetText(settings.editUid and 'Сохранить' or 'Добавить')
	b:SetIcon('icon16/folder.png')
	function b:DoClick()

		if string.Trim(name:GetValue()) == '' then
			octolib.notify.show('Пожалуйста, добавь название действия. Тебе так будет проще')
			return
		end

		local data
		if isfunction(action.getData) then
			data = action.getData(settings)
		else data = {} end
		if data == nil then
			octolib.notify.show('warning', 'Кажется, не все поля заполнены верно')
			return
		end
		data = istable(data) and data or {value = data}
		data._name, data._icon = name:GetValue(), icon:GetImage()

		if settings.editUid then
			data.id = id
			data.uid = settings.editUid
			gmpanel.actions.editAction(settings.editUid, data)
		else gmpanel.actions.addAction(id, data) end
	end
end

hook.Add('gmpanel.populateActionsMenu', 'gmpanel.actions', function(menu, players)

	for _,v in ipairs(gmpanel.actions.added) do

		local action = gmpanel.actions.available[v.id]
		if action then
			menu:AddOption(v._name, function()
				local func = action.execute or gmpanel.actions.defaultExecute
				func(v, players)
			end):SetIcon(v._icon)
		end

	end

	menu:AddSpacer()

end)

local function build()
	gmpanel.actions.close()

	pan = vgui.Create('DFrame')
	pan:SetSize(700, 500)
	pan:SetTitle('Действия')
	pan:Center()
	pan:MakePopup()
	pan:SetDeleteOnClose(true)

	pAvailable = pan:Add('DListView')
	pAvailable:Dock(LEFT)
	pAvailable:SetWide(175)
	pAvailable:SetHideHeaders(true)
	pAvailable:DockMargin(0, 0, 5, 0)
	pAvailable:AddColumn(''):SetFixedWidth(32)
	pAvailable:AddColumn(L.title)
	pAvailable:SetDataHeight(32)
	pAvailable:SetMultiSelect(false)

	for k,v in pairs(gmpanel.actions.available) do
		local icon = vgui.Create('DImage')
		icon:SetImage(v.icon)
		pAvailable:AddLine(icon, v.name).id = k
	end

	settings = pan:Add('DPanel')
	settings:Dock(FILL)
	settings:DockPadding(5, 5, 5, 5)

	function pAvailable:OnRowSelected(_, row)
		if self.dirty then return end
		for _,v in ipairs(active:GetChildren()) do
			v.sel = nil
		end
		settings:Clear()
		gmpanel.actions.available[row.id].openSettings(settings, {})
		settings.editUid = nil
		gmpanel.actions.insertButtons(row.id, {})
	end

	rebuildAdded()

end

function gmpanel.actions.open()
	build()
end
