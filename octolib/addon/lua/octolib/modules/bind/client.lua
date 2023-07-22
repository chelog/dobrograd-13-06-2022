octolib.bindHandlers = octolib.bindHandlers or {}

if CFG.serverGroupIDvars ~= CFG.serverGroupID and octolib.vars.get('binds_' .. CFG.serverGroupID) then
	octolib.vars.set('binds_' .. CFG.serverGroupIDvars, octolib.vars.get('binds_' .. CFG.serverGroupID))
	octolib.vars.set('binds_' .. CFG.serverGroupID, nil)
end

function octolib.registerBindHandler(id, data)
	octolib.bindHandlers[id] = data
end

octolib.bindCache = octolib.bindCache or {}

local mapDown, mapUp = {}, {}
local function rebuildMaps()

	table.Empty(mapDown)
	table.Empty(mapUp)

	for _, bind in ipairs(octolib.bindCache) do
		local tbl = bind.on == 'down' and mapDown or mapUp
		if not tbl[bind.button] then tbl[bind.button] = {} end
		table.insert(tbl[bind.button], function()
			octolib.bindHandlers[bind.action].run(bind.data)
		end)
	end

	octolib.bindsUpdate = CurTime()

end

function octolib.setBind(id, button, action, data, on)

	if button then
		octolib.bindCache[id or (#octolib.bindCache + 1)] = {
			button = button,
			action = action,
			data = data,
			on = on or 'down',
		}
	elseif id then
		table.remove(octolib.bindCache, id)
	else
		return
	end

	octolib.vars.set('binds_' .. (CFG.serverGroupIDvars or CFG.serverGroupID), octolib.bindCache)
	rebuildMaps()

end

hook.Add('PlayerButtonDown', 'octolib-bind', function(_, but)
	if not IsFirstTimePredicted() then return end

	local funcs = mapDown[but]
	if funcs then
		for _, func in ipairs(funcs) do func() end
	end
end)

hook.Add('PlayerButtonUp', 'octolib-bind', function(_, but)
	if not IsFirstTimePredicted() then return end

	local funcs = mapUp[but]
	if funcs then
		for _, func in ipairs(funcs) do func() end
	end
end)

hook.Add('octolib.configLoaded', 'octolib-bind', function()
	octolib.bindCache = octolib.vars.get('binds_' .. (CFG.serverGroupIDvars or CFG.serverGroupID)) or {}
	rebuildMaps()
end)

local PANEL = {}

function PANEL:Think()

	if self.lastUpdate == octolib.bindsUpdate then return end
	self.lastUpdate = octolib.bindsUpdate

	self:RebuildList()

end

function PANEL:RebuildList()

	self:Clear()

	for i = 1, #octolib.bindCache do
		local row = self:Add 'octolib_binds_row'
		row:SetBind(i)
	end

	octolib.button(self, 'Создать', function()
		octolib.setBind(nil, KEY_SPACE, 'chat', 'Привет!')
	end)

end

vgui.Register('octolib_binds', PANEL, 'DScrollPanel')

local PANEL = {}

function PANEL:Init()

	self:Dock(TOP)
	self:SetTall(31)
	self:DockMargin(0, 0, 0, 5)

	local top = self:Add 'DPanel'
	top:Dock(TOP)
	top:DockMargin(3, 3, 3, 3)
	top:SetTall(25)
	top:SetPaintBackground(false)

	local cb = octolib.comboBox(top, nil, {
		{'При нажатии', 'down', true},
		{'При отжатии', 'up'},
	})
	cb:Dock(LEFT)
	cb:DockMargin(0, 0, 3, 0)
	cb:SetWide(100)
	function cb:OnSelect() end
	self.on = cb

	local b = top:Add 'DBinder'
	b:Dock(LEFT)
	b:DockMargin(0, 0, 3, 0)
	b:SetWide(50)
	function b:SetSelectedNumber(but)
		self.m_iSelectedNumber = but
		self:UpdateText()
	end
	self.binder = b

	local del = top:Add 'DImageButton'
	del:Dock(RIGHT)
	del:SetWide(16)
	del:DockMargin(3, 4, 0, 5)
	del:SetImage('icon16/cross.png')
	del:SetTooltip('Удалить')
	self.del = del

	local opts = {}
	for id, data in pairs(octolib.bindHandlers) do
		opts[#opts + 1] = { data.name, id }
	end
	local cb = octolib.comboBox(top, nil, opts)
	cb:Dock(FILL)
	cb:DockMargin(0, 0, 0, 0)
	function cb:OnSelect() end
	self.action = cb

	local custom = self:Add 'DPanel'
	custom:Dock(TOP)
	custom:DockMargin(3, 0, 3, 3)
	custom:SetPaintBackground(false)
	custom:SetTall(0)
	self.custom = custom

end

function PANEL:SetBind(bindID)

	local bind = octolib.bindCache[bindID]
	local handler = octolib.bindHandlers[bind.action]

	function self.del:DoClick()
		octolib.setBind(bindID, nil)
	end

	self.on:ChooseOptionID(bind.on == 'down' and 1 or 2)
	function self.on:OnSelect(_, _, val)
		local bind = octolib.bindCache[bindID]
		octolib.setBind(bindID, bind.button, bind.action, bind.data, val)
	end

	self.binder:SetValue(bind.button)
	function self.binder:SetSelectedNumber(but)
		self.m_iSelectedNumber = but
		self:UpdateText()

		local bind = octolib.bindCache[bindID]
		octolib.setBind(bindID, but, bind.action, bind.data, bind.on)
	end

	self.action:SetValue(handler.name)
	function self.action:OnSelect(_, _, val)
		local bind = octolib.bindCache[bindID]
		octolib.setBind(bindID, bind.button, val, nil, bind.on)
	end

	if handler.buildBinder then
		handler.buildBinder(self.custom, bindID, bind)
		local h = self.custom:GetTall()
		if h > 0 then h = h + 3 end
		self:SetTall(31 + h)
	end

end

vgui.Register('octolib_binds_row', PANEL, 'DPanel')
