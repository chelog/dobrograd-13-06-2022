gmpanel.global = gmpanel.global or {}

local fetch = {command = 'fetch',}

local pan = pan or nil

function gmpanel.global.close()
	if IsValid(pan) then
		pan:Close()
	end
end

local function cbox(base, var, txt, def)
	local b = octolib.vars.checkBox(base, var, txt)
	if octolib.vars.get(var) == nil then b:SetValue(def) end
	return b
end

local function spacer(base)
	local p = base:Add('Panel')
	p:Dock(TOP)
	function p:Paint(w)
		draw.RoundedBox(0, 0, 0, w, 1, Color(127, 127, 127))
	end
end

local function var(k)
	return 'gmpanel.global.'..k
end

local function getVar(k, def)
	local v = octolib.vars.get(var(k))
	if v ~= nil then return v else return def end
end

local function category(cont, name)
	local cat = cont:Add('DCollapsibleCategory')
	cat:Dock(TOP)
	cat:SetTall(100)
	cat:SetExpanded(0)
	cat:SetLabel(name)
	local layout = vgui.Create('DListLayout')
	layout:SetSize(100, 100)
	layout:DockPadding(5, 5, 5, 5)
	layout:SetPaintBackground(true)
	cat:SetContents(layout)
	return cat, layout
end

local cback

netstream.Hook('dbg-event.global.fetch', function(data)
	octolib.vars.set(var'karma', data.karma)
	if data.respawn ~= nil then
		octolib.vars.set(var'respawn', data.respawn)
	end
	octolib.vars.set(var'inventories', data.inventories)
	octolib.vars.set(var'storages', data.storages)
	octolib.vars.set(var'fog.def', data.fogdef)
	if not data.fogdef then
		octolib.vars.set(var'fog.color', data.fogcolor:ToColor())
		octolib.vars.set(var'fog.dist', data.fogdst)
	end
	octolib.vars.set(var'ooc', data.ooc)
	octolib.vars.set(var'radio', data.radio)
	octolib.vars.set(var'ems', data.ems)
	octolib.vars.set(var'calls', data.calls)
	octolib.vars.set(var'sms', data.sms)
	octolib.vars.set(var'advert', data.advert)
	if cback then cback() end
end)

local function build()
	gmpanel.global.close()

	pan = vgui.Create('DFrame')
	pan:SetSize(500, 500)
	pan:SetTitle('Настройки')
	pan:Center()
	pan:MakePopup()
	pan:SetDeleteOnClose(true)

	local btns = pan:Add('DPanel')
	btns:Dock(BOTTOM)
	btns:DockMargin(5, 5, 5, 5)
	btns:SetTall(30)

	local fetchBtn = btns:Add('DButton')
	fetchBtn:Dock(RIGHT)
	fetchBtn:DockMargin(1, 0, 0, 0)
	fetchBtn:SetText('Текущие значения')
	fetchBtn:SetIcon('icon16/report.png')
	fetchBtn:SizeToContentsX(45)
	function fetchBtn:DoClick()
		self:SetEnabled(false)
		cback = function()
			self:SetEnabled(true)
			cback = nil
		end

		netstream.Start('dbg-event.execute', 'global', fetch)
	end
	local applyBtn = btns:Add('DButton')
	applyBtn:Dock(FILL)
	applyBtn:DockMargin(0, 0, 1, 0)
	applyBtn:SetTall(30)
	applyBtn:SetText('Применить')
	applyBtn:SetIcon('icon16/tick.png')

	local cont = pan:Add('DScrollPanel')
	cont:Dock(FILL)
	cont:DockMargin(5, 5, 5, 5)

	local krc, krcl = category(cont, 'Карма и возрождение')
	local karma = cbox(krcl, var'karma', 'Изменение кармы', true)
	karma:DockMargin(0, 0, 0, 0)
	local respawn = octolib.vars.slider(krcl, var'respawn', 'Время возрождения (сек)', 0, 3600, 0)
	respawn:DockMargin(0, 0, 0, 0)
	respawn:SetVisible(not karma:GetChecked())
	local kvc = karma.OnChange
	function karma:OnChange(val)
		respawn:SetVisible(not val)
		krc:Toggle() krc:Toggle()
		kvc(self, val)
	end

	local ic, icl = category(cont, 'Инвентарь')
	cbox(icl, var'inventories', 'Синхронизация инвентарей', true):DockMargin(0, 0, 0, 0)
	cbox(icl, var'storages', 'Хранилища', true):DockMargin(0, 0, 0, 0)

	local fc, fcl = category(cont, 'Туман')
	local def = cbox(fcl, var'fog.def', 'По умолчанию', true)
	def:DockMargin(0, 0, 0, 0)
	local col, lbl = octolib.vars.colorPicker(fcl, var'fog.color', 'Цвет тумана', false)
	col:DockMargin(0, 0, 0, 0)
	col:SetVisible(not def:GetChecked())
	lbl:SetVisible(not def:GetChecked())
	local map = game.GetMap()
	local dist = 3000 - math.Clamp(player.GetCount() - 10, 0, 40) * 38
	if map:find('evocity') then dist = dist + 1000 end
	if map:find('riverden') then dist = dist + 3000 end
	if map:find('truenorth') then dist = dist + 4000 end
	local dst = octolib.vars.slider(fcl, var'fog.dist', 'Дальность тумана', 50, dist, 0)
	dst:DockMargin(0, 0, 0, 0)
	dst:SetVisible(not def:GetChecked())
	local cvc = def.OnChange
	function def:OnChange(val)
		col:SetVisible(not val)
		lbl:SetVisible(not val)
		dst:SetVisible(not val)
		fc:Toggle() fc:Toggle()
		cvc(self, val)
	end

	local oocc, ooccl = category(cont, 'Глобальный OOC')
	cbox(ooccl, var'ooc', 'Глобальный OOC', true):DockMargin(0, 0, 0, 0)

	local netc, netcl = category(cont, 'Связь')
	cbox(netcl, var'radio', 'Возможность говорить в рацию', true):DockMargin(0, 0, 0, 0)
	cbox(netcl, var'ems', 'Вызовы экстренных служб', true):DockMargin(0, 0, 0, 0)
	cbox(netcl, var'calls', 'Вызовы врача, механика, таксиста и т.д.', true):DockMargin(0, 0, 0, 0)
	cbox(netcl, var'sms', 'SMS', true):DockMargin(0, 0, 0, 0)
	cbox(netcl, var'advert', 'Рекламные объявления', true):DockMargin(0, 0, 0, 0)

	function applyBtn:DoClick()
		self:SetEnabled(false)
		local data = {command = 'save'}
		if krc:GetExpanded() then
			data.karma = getVar('karma', true)
			if not getVar('karma') then data.respawn = getVar('respawn', 0) end
		end
		if ic:GetExpanded() then
			data.inventories = getVar('inventories', true)
			data.storages = getVar('storages', true)
		end
		if fc:GetExpanded() then
			data.fogdef = getVar('fog.def', true)
			if not data.fogdef then
				data.fogcolor = getVar('fog.color')
				data.fogdst = getVar('fog.dist')
			end
		end
		if oocc:GetExpanded() then data.ooc = getVar('ooc', true) end
		if netc:GetExpanded() then
			data.raio = getVar('radio', true)
			data.ems = getVar('ems', true)
			data.calls = getVar('calls', true)
			data.sms = getVar('sms', true)
			data.advert = getVar('advert', true)
		end
		netstream.Start('dbg-event.execute', 'global', data)
		self:SetEnabled(true)
	end
end

function gmpanel.global.open()
	build()
end
