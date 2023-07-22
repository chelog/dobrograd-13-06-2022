local PANEL = {}

function PANEL:Init()
	self:GetCanvas():DockPadding(5,10,5,5)
	self.actions = {}

	local act0 = self:Add('DPanel')
	act0:Dock(TOP)
	act0:DockPadding(5,5,5,5)
	act0:DockMargin(0,0,0,10)
	function act0:PerformLayout()
		self:SizeToChildren(false, true)
	end
	local lbl = octolib.label(act0, '0. Сценарий активирован')
	lbl:SetFont('f4.normal')
	lbl:SetTall(30)
	act0:SetVisible(false)
	self.act0 = act0

	local dnd = self:Add('DPanel')
	dnd:Dock(TOP)
	dnd:SetTall(60)
	dnd:SetMouseInputEnabled(true)
	dnd:SetCursor('hand')
	dnd:SetVisible(false)
	self.dnd = dnd

	local function openNewActionSelector()
		local o = octolib.overlay(self:GetParent(), 'DPanel')
		o:SetSize(175, 0)
		local lst = o:Add('DListView')
		lst:Dock(FILL)
		lst:SetHideHeaders(true)
		lst:AddColumn(''):SetFixedWidth(32)
		lst:AddColumn(L.title)
		lst:SetDataHeight(32)
		lst:SetMultiSelect(false)

		for k,v in pairs(gmpanel.actions.available) do
			local icon = vgui.Create('DImage')
			icon:SetImage(v.icon)
			lst:AddLine(icon, v.name).id = k
			o:SetTall(math.min(400, o:GetTall() + 32))
		end
		o:SetTall(math.min(400, o:GetTall() + 16))

		lst.OnRowSelected = function(_, _, row)
			if IsValid(self) then
				self:AddAction({id = row.id})
			end
			o:Remove()
		end
	end

	dnd.OnMouseReleased = function(_, mcode)
		if mcode == MOUSE_LEFT then openNewActionSelector() end
	end

	local lbl = octolib.label(dnd, 'Перетащи сюда действие')
	lbl:SetFont('f4.normal')
	lbl:SetTall(20)
	lbl:SetTextColor(Color(100, 100, 100))
	lbl:SetContentAlignment(5)
	lbl:DockMargin(0,5,0,0)
	lbl:SetMouseInputEnabled(true)
	lbl:SetCursor('hand')
	lbl.DoClick = openNewActionSelector

	lbl = octolib.label(dnd, 'Или нажми, чтобы создать новое')
	lbl:SetFont('f4.normal')
	lbl:SetTall(20)
	lbl:SetTextColor(Color(100, 100, 100))
	lbl:SetContentAlignment(5)
	lbl:DockMargin(0,5,0,0)
	lbl:SetMouseInputEnabled(true)
	lbl:SetCursor('hand')
	lbl.DoClick = openNewActionSelector

	dnd:Receiver('gmpanel.actions.added', function(_, pnl, dropped)
		if not dropped then return end
		pnl = istable(pnl) and pnl[1]
		if IsValid(pnl) then self:AddAction(gmpanel.actions.added[pnl.id]) end
	end)

	local btmPan = self:Add('DPanel')
	btmPan:Dock(TOP)
	btmPan:SetTall(48)
	btmPan:SetPaintBackground(false)
	btmPan:SetVisible(false)
	self.btmPan = btmPan

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
	function icon:DoClick()
		octolib.icons.picker(function(val)
			self:SetImage(val)
		end, 'materials/' .. self:GetImage(), 'materials/icon16/')
	end
	self.icon = icon

	local name = wrapper:Add('DTextEntry')
	name:Dock(FILL)
	name:SetPaintBackground(false)
	name:SetTextColor(color_white)
	self.name = name

	local b = btmPan:Add('DPanel')
	b:Dock(RIGHT)
	b:DockMargin(0,0,0,5)
	b:SetPaintBackground(false)
	b:SetWide(100)
	b = b:Add('DButton')
	b:Dock(BOTTOM)
	b:SetTall(30)
	b:SetText('Сохранить')
	b:SetIcon('icon16/folder.png')
	b.DoClick = function()

		if string.Trim(name:GetValue()) == '' then
			octolib.notify.show('Пожалуйста, добавь название сценария. Тебе так будет проще')
			return
		end

		local actions = {}

		for _,v in ipairs(self.actions) do
			if not (v.panel and v.id and gmpanel.actions.available[v.id]) then continue end

			local act = gmpanel.actions.available[v.id]
			local resp
			if isfunction(act.getData) then
				resp = act.getData(v.panel)
			else resp = {} end

			if resp == nil then
				return octolib.notify.show('warning', 'Кажется, не все поля заполнены верно')
			end

			resp = istable(resp) and resp or {value = resp}
			resp.id = v.id
			resp._delay = v.time:GetValue()
			actions[#actions + 1] = resp

		end
		local data = {
			_name = name:GetValue(),
			_icon = icon:GetImage(),
			actions = actions,
			uid = self.editUid,
		}

		if self.editUid then
			data.uid = self.editUid
			gmpanel.scenarios.edit(self.editUid, data)
		else gmpanel.scenarios.add(data) end

	end

end

function PANEL:AddAction(data)
	if not data.id then return end
	local action = gmpanel.actions.available[data.id]
	if not action or not isfunction(action.openSettings) then return end

	data = table.Copy(data)
	data._name, data._icon, data.uid = nil

	self.dnd:SetParent()
	self.btmPan:SetParent()
	local act = self:Add('gmp_scenario_action')
	act.editor = self
	act:Dock(TOP)
	act:DockMargin(0,0,0,10)
	act:SetAction(action, data)
	act:UpdateNumber(#self.actions + 1)
	self.dnd:SetParent(self)
	self.btmPan:SetParent(self)

	local lastAct = self.actions[#self.actions]
	if IsValid(lastAct) then lastAct.btnDown:SetVisible(true) end
	act.btnDown:SetVisible(false)

	self.actions[#self.actions + 1] = act
end

function PANEL:OpenEditor(data)
	for _, v in ipairs(self.actions) do
		v:SetParent()
		v:Remove()
	end
	self.actions = {}
	self.editUid = data.uid

	self.dnd:SetParent()
	self.btmPan:SetParent()
	self.dnd:SetParent(self)
	self.btmPan:SetParent(self)

	self.act0:SetVisible(true)
	for _,v in ipairs(data.actions or {}) do
		self:AddAction(v)
	end

	self.dnd:SetVisible(true)
	self.btmPan:SetVisible(true)
	self.icon:SetIcon(data._icon or 'icon16/page_white_text.png')
	self.name:SetValue(data._name or '')

end

function PANEL:UpdateNumbers()
	for i, v in ipairs(self.actions) do
		v:UpdateNumber(i)
	end
	if self.actions[1] then
		self.actions[#self.actions].btnDown:SetVisible(false)
	end
end

function PANEL:UpdateOrder()
	local canvas = self:GetCanvas()
	local dnd, btmPan = self.dnd, self.btmPan
	dnd:SetParent()
	btmPan:SetParent()
	for _, v in ipairs(self.actions) do
		v:SetParent()
		v:SetParent(canvas)
	end
	dnd:SetParent(self)
	btmPan:SetParent(self)
	self:UpdateNumbers()
end

vgui.Register('gmp_scenario_editor', PANEL, 'DScrollPanel')
