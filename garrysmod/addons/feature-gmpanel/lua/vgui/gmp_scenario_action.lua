local function findInTable(tbl, target)
	for i, v in ipairs(tbl) do
		if v == target then return i end
	end
	return -1
end

local function automaticResize(self)
	self:SizeToChildren(false, true)
	self.w, self.h = self:GetSize()
end

local function addButton(pnl, name, icon, doClick)
	local btn = pnl:Add('DImageButton')
	btn:Dock(RIGHT)
	btn:DockMargin(0,4,5,4)
	btn:SetWide(16)
	btn:SetImage(octolib.icons.silk16(icon))
	btn:SetTooltip(name)
	btn.DoClick = doClick
	return btn
end

local function doRemove(self)
	local editor = self:GetParent():GetParent().editor
	self:GetParent():GetParent():Remove()
	timer.Simple(0, function() if IsValid(editor) then editor:UpdateNumbers() end end)
end

local function doCopy(self)

	local el = self:GetParent():GetParent()
	local editor = el.editor
	local dnd, btmPan = editor.dnd, editor.btmPan
	dnd:SetParent()
	btmPan:SetParent()

	local act = gmpanel.actions.available[el.data.id]
	local curData
	if isfunction(act.getData) then
		curData = act.getData(el.panel)
	else curData = {} end

	if curData == nil then
		return octolib.notify.show('warning', 'Кажется, не все поля заполнены верно')
	end

	curData = istable(curData) and curData or {value = curData}
	curData.id = el.data.id
	curData._delay = el.time:GetValue()

	editor:AddAction(curData)
	dnd:SetParent(editor)
	btmPan:SetParent(editor)

end

local function doMoveUp(self)
	local act = self:GetParent():GetParent()
	local actions = act.editor.actions
	local num = findInTable(actions, act)
	if IsValid(actions[num - 1]) then
		actions[num], actions[num - 1] = actions[num - 1], actions[num]
		act.editor:UpdateOrder()
		timer.Simple(0, function()
			act.editor:ScrollToChild(act)
		end)
	end
end

local function doMoveDown(self)
	local act = self:GetParent():GetParent()
	local actions = act.editor.actions
	local num = findInTable(actions, act)
	if IsValid(actions[num + 1]) then
		actions[num], actions[num + 1] = actions[num + 1], actions[num]
		act.editor:UpdateOrder()
		timer.Simple(0, function()
			act.editor:ScrollToChild(act)
		end)
	end
end

local function doRename(self)
	local lbl, act = self:GetParent(), self:GetParent():GetParent()
	Derma_StringRequest('Переименовать', 'Укажи новое название', lbl.action, function(newName)
		newName = string.Trim(newName)
		if newName == '' then return end
		lbl.action = newName
		act.data._actName = newName
		act:UpdateNumber()
	end)
end

local function doResize(self)
	local act = self:GetParent():GetParent()
	act:SizeTo(act.w, act.minimized and act.h or 32, 0.5, 0, -1, function()
		if not act.minimized then
			act.PerformLayout = automaticResize
		end
	end)
	act.minimized = not act.minimized
	if act.minimized then act.PerformLayout = octolib.func.zero end
	self:SetImage(octolib.icons.silk16(act.minimized and 'arrow_out' or 'arrow_in'))
	self:SetTooltip(act.minimized and 'Развернуть' or 'Свернуть')
end

local function doMove(self)
	local act = self:GetParent():GetParent()
	local editor = act.editor
	local num = findInTable(editor.actions, act)
	if not IsValid(editor.actions[num]) then return end
	Derma_StringRequest('Перемещение', 'Укажи текущий номер действия, после которого будет стоять это действие (от 0 до ' .. #editor.actions .. ')', num-1, function(sNewPos)
		local newPos = tonumber(sNewPos)
		if not newPos or newPos < 0 or newPos > #editor.actions then return end
		if num == newPos then return end
		table.remove(editor.actions, num)
		table.insert(editor.actions, newPos + (num >= newPos and 1 or 0), act)
		editor:UpdateOrder()
		timer.Simple(0, function()
			act.editor:ScrollToChild(act)
		end)
	end)
end


---------------------------


local PANEL = {}

function PANEL:Init()

	self:DockPadding(5,5,5,5)

	local lbl = octolib.label(self, '')
	lbl:SetFont('f4.normal')
	lbl:SetContentAlignment(4)
	lbl:SetTall(24)
	self.lbl = lbl

	addButton(lbl, 'Удалить', 'cross', doRemove)
	addButton(lbl, 'Дублировать', 'page_copy', doCopy)
	addButton(lbl, 'Переместить', 'transform_move', doMove)
	self.btnUp = addButton(lbl, 'Вверх', 'arrow_up', doMoveUp)
	self.btnDown = addButton(lbl, 'Вниз', 'arrow_down', doMoveDown)
	addButton(lbl, 'Переименовать', 'pencil', doRename)
	addButton(lbl, 'Свернуть', 'arrow_in', doResize)

	local pnl = self:Add('DPanel')
	pnl:Dock(TOP)
	pnl:SetPaintBackground(false)
	pnl.PerformLayout = automaticResize
	self.panel = pnl

	local time = octolib.label(self, 'Через сколько секунд после выполнения предыдущего действия выполнить это:')
	time:DockMargin(0, 10, 0, 0)
	time:SetMultiline(true)
	time:SetWrap(true)
	time:SetTall(30)
	time = octolib.numberWang(self, nil, 0, 0, 1200)
	time:SetDecimals(1)
	time:DockMargin(0, 0, 0, 0)
	self.time = time

end

function PANEL:UpdateNumber(num)
	self.num = num or self.num
	self.lbl:SetText(self.num .. '. ' .. self.lbl.action)
	self.btnUp:SetVisible(self.num > 1)
	self.btnDown:SetVisible(true)
end

function PANEL:SetAction(action, data)
	self.lbl.action = data._actName or action.name
	self.data = data
	self.id = data.id
	action.openSettings(self.panel, data)
	self.time:SetValue(data._delay or 0)
end

PANEL.PerformLayout = automaticResize

function PANEL:OnRemove()
	table.RemoveByValue(self.editor.actions, self)
end

vgui.Register('gmp_scenario_action', PANEL, 'DPanel')
