surface.CreateFont('octoinv-help.heading', {
	font = 'Calibri',
	extended = true,
	size = 42,
	weight = 350,
})

surface.CreateFont('octoinv-help.subheading', {
	font = 'Calibri',
	extended = true,
	size = 27,
	weight = 350,
})

local defaultData = {
	amount = 1,
	volume = 0,
	mass = 0,
	name = L.unknown,
	desc = L.not_desc,
	icon = 'octoteam/icons/error.png',
	model = 'models/props_junk/garbage_bag001a.mdl',
}

local function classData(class, field)
	local data = octoinv.items[class]
	return data and data[field] or defaultData[field]
end

local function itemData(item, field)

	local data = octoinv.items[item.class or item[1]]
	return istable(item[2]) and item[2][field] or item[field] or (data and data[field]) or defaultData[field]

end

local function iconPath(icon, class)

	if not icon then
		return class and classData(class, 'icon') or defaultData.icon
	elseif isstring(icon) then
		return icon
	else
		return icon:GetName() .. '.png'
	end

end

--
-- ADMIN THINGIES
--

local editorWindows = {}
local f
concommand.Add('octoinv_editor', function()

	if not LocalPlayer():query(L.permissions_edit_inventory)  then
		notification.AddLegacy(L.not_have_access, NOTIFY_ERROR, 5)
		return
	end

	if IsValid(f) then f:Remove() end
	f = vgui.Create 'DFrame'
	f:SetSize(400, 500)
	f:SetTitle(L.octoinv_editor)
	f:Center()
	f:MakePopup()

	local bp = f:Add 'DPanel'
	bp:DockPadding(5, 5, 5, 5)
	bp:Dock(TOP)
	bp:SetTall(40)

	local e1 = bp:Add 'DTextEntry'
	e1:DockMargin(0, 0, 5, 0)
	e1:Dock(LEFT)
	e1:SetWide(190)
	e1:SetPlaceholderText(L.search_steamid)
	function e1:OnEnter()
		local val = self:GetText()
		if string.Trim(val) ~= '' then
			netstream.Start('octoinv.search', { steamID = val })
		end
	end

	local e2 = bp:Add 'DTextEntry'
	e2:DockMargin(0, 0, 0, 0)
	e2:Dock(RIGHT)
	e2:SetWide(190)
	e2:SetPlaceholderText(L.search_content)
	function e2:OnEnter()
		local val = self:GetText()
		if string.Trim(val) ~= '' then
			netstream.Start('octoinv.search', { query = val })
		end
	end

	local lp = f:Add 'DPanel'
	lp:DockMargin(0, 5, 0, 0)
	lp:DockPadding(5, 5, 5, 5)
	lp:Dock(FILL)

	local l = lp:Add 'DListView'
	l:Dock(FILL)
	l:AddColumn('SteamID')
	l:AddColumn(L.name_octoinv)
	l:SetMultiSelect(false)
	f.l = l

	function l:OnRowRightClick(id, line)
		local sID = line.steamID
		local m = DermaMenu()
		if not IsValid(editorWindows[line.steamID]) then
			m:AddOption(L.edit, function() netstream.Start('octoinv.editor.open', line.steamID, line:GetColumnText(2)) end):SetIcon('icon16/pencil.png')
		end
		m:AddOption(L.copy_steamid, function() SetClipboardText(sID) end):SetIcon('icon16/page_copy.png')
		m:AddOption(L.open_profile, function() octoesc.OpenURL('https://steamcommunity.com/profiles/' .. util.SteamIDTo64(sID)) end):SetIcon('icon16/report_user.png')
		m:Open()
	end
	function l:DoDoubleClick(id, line)
		if not IsValid(editorWindows[line.steamID]) then
			netstream.Start('octoinv.editor.open', line.steamID, line:GetColumnText(2))
		end
	end

end)

local removers = {
	toilet = 'Смой предметы, которые нужно удалить, в унитаз.',
	denture = 'Скорми предметы, которые нужно удалить, Ненасытному Жоре.',
	explosion = 'Брось предметы, которые нужно удалить, в эпицентр взрыва.',
	explosion2 = 'Выкинь предметы, которые нужно удалить, в эпицентр термоядерного взрыва.',
	zip_file = 'Собери предметы, которые нужно удалить, в ZIP-пакет.',
	robber = 'Отдай предметы, которые нужно удалить, беспощадному краймеру.',
	group3 = 'Пожертвуй предметы, которые нужно удалить, в Фонд Нуждающихся Игроков.',
	chem_plant = 'Отправь предметы, которые нужно удалить, на мусороперерабатывающую фабрику.',
	gift_octo_pride = 'Преподнеси предметы, которые нужно удалить, в жертву Челогу.',
	clothes_backpack2 = 'Запихни предметы, которые нужно удалить, в старый рюкзак.',
	bottle_vodka = 'Окуни предметы, которые нужно удалить, в пузырь растворителя.',
	heart = 'Предай предметы, которые нужно удалить, бесконечной любви.',
	inbox = 'Отложи предметы, которые нужно удалить, в долгий ящик.',
	potion3 = 'Приготовь зелье из предметов, которые нужно удалить, в странной колбе.',
	shop2 = 'Сдай предметы, которые нужно удалить, в секонд-хенд.',
	truck = 'Вывези предметы, которые нужно удалить, на грузовике "".',
	hand = 'Положи предметы, которые нужно удалить, в руку попрошайки.',
	slot_machine = 'Проиграй предметы, которые нужно удалить, в игровом автомате.',
	food_chips = 'Подкинь предметы, которые нужно удалить, в пакет чипсов твоего друга.',
	camera = 'Помести предметы, которые нужно удалить, в камеру.',
	spy = 'Сообщи о предметах, которые нужно удалить, иностранному агенту.',
	cross = 'Удали предметы, которые нужно удалить, через соответствующий контейнер.',
	chip1 = 'Загрузи предметы, которые нужно удалить, на ненадёжный файлообменник.',
}

netstream.Hook('octoinv.editor.open', function(data)

	if IsValid(editorWindows[data.steamID]) then editorWindows[data.steamID]:Remove() end

	local w = vgui.Create 'DFrame'
	editorWindows[data.steamID] = w

	w:SetWide(375)
	w:SetTall(data.noEdit and 205 or 240)
	w:AlignBottom(20)
	w:AlignLeft(20)
	w:SetTitle(data.steamID .. L.steamid_edit)
	w:MakePopup()
	w.saved = true

	steamworks.RequestPlayerInfo(util.SteamIDTo64(data.steamID), function(n)
		if IsValid(w) then
			w:SetTitle(data.steamID .. ' (' .. n .. ')' .. L.steamid_edit)
		end
	end)
	if data.noEdit then
		octolib.label(w, data.noEdit)
	end
	local lbl = octolib.label(w, 'В твой инвентарь добавлены контейнеры Куртки, Брюк и Хранилища.')
	local wide = math.max(375, surface.GetTextSize(lbl:GetText()) + 10)

	local bank = octolib.numberWang(w, 'Банковский счет:', data.bank or 0, -2147483647, 2147483647)
	bank:SetEnabled(not data.noEdit)
	bank.savedVal = data.bank or 0
	function bank:OnValueChanged(val)
		if val ~= self.savedVal then
			w.saved = false
		end
	end

	local karma = octolib.numberWang(w, 'Карма:', data.karma or 0, -2147483647, 2147483647)
	karma:SetEnabled(not data.noEdit)
	karma.savedVal = data.karma or 0
	karma.OnValueChanged = bank.OnValueChanged

	local btmPan = w:Add('DPanel')
	btmPan:Dock(BOTTOM)
	btmPan:SetTall(25)
	btmPan:SetPaintBackground(false)

	if not data.noEdit then
		lbl = octolib.label(w, removers[data.remover])
		wide = math.max(wide, surface.GetTextSize(lbl:GetText()) + 10)
		lbl = octolib.label(w, 'Чтобы сохранить изменения, нажми на кнопку "Сохранить" ниже.')
		wide = math.max(wide, surface.GetTextSize(lbl:GetText()) + 10)
		octolib.label(w, 'Чтобы завершить редактирование, закрой это окно.')
		wide = math.max(wide, surface.GetTextSize(lbl:GetText()) + 10)
		surface.SetFont('DermaDefault')
		w:SetWide(math.max(375, surface.GetTextSize(removers[data.remover]) + 10))

		local saveBtn = octolib.button(btmPan, 'Сохранить', function()
			netstream.Start('octoinv.editor.save', data.steamID, bank:GetValue(), karma:GetValue())
			w.saved = true
			bank.savedVal, karma.savedVal = bank:GetValue(), karma:GetValue()
		end)
		saveBtn:Dock(RIGHT)
		saveBtn:SetWide(100)
	end

	local invBtn = octolib.button(btmPan, 'Инвентарь', function() RunConsoleCommand('+menu') end)
	invBtn:Dock(RIGHT)
	invBtn:DockMargin(0, 0, 5, 0)
	invBtn:SetWide(100)

	w.oClose = w.Close
	function w:Close()
		if not self.saved then
			octolib.confirmDialog(self, 'Сохранить изменения?', function(ans)
				if ans then
					netstream.Start('octoinv.editor.save', data.steamID, bank:GetValue(), karma:GetValue())
				end
				self:oClose()
			end)
		else self:oClose() end
	end
	function w:OnRemove()
		netstream.Start('octoinv.editor.close', data.steamID)
	end

	octoinv.notifyChange()

end)

netstream.Hook('octoinv.editor.change', function(steamID)
	if IsValid(editorWindows[steamID]) then
		editorWindows[steamID].saved = false
	else
		netstream.Start('octoinv.editor.close', steamID)
	end
end)

netstream.Hook('octoinv.search', function(data)

	if not IsValid(f) then return end

	f.l:Clear()
	if isstring(data) then
		notification.AddLegacy(L.error_search .. data, NOTIFY_ERROR, 5)
		return
	end

	for i, v in ipairs(data) do
		local line = f.l:AddLine(v.steamID, '')
		steamworks.RequestPlayerInfo(util.SteamIDTo64(v.steamID), function(n) line:SetColumnText(2, n) end)
		line.steamID = v.steamID
	end

end)

--
-- ADD ITEM WINDOW
--
local function setupLabel(parent, text)

	local l = parent:Add 'DLabel'
	l:Dock(TOP)
	l:DockMargin(5, 0, 5, 0)
	l:SetTall(16)
	l:SetText(text)

	return l

end

local function setupEntry(parent, text, val, onUpdate)

	setupLabel(parent, text)

	local e = parent:Add 'DTextEntry'
	e:Dock(TOP)
	e:DockMargin(0,0,0,5)
	e:SetTall(25)
	e:SetUpdateOnType(true)
	e:SetPlaceholderText(text)
	e:SetValue(val)
	e.OnValueChange = onUpdate

	return e

end

local function setupSlider(parent, text, data, onUpdate)

	local e = parent:Add 'DNumSlider'
	e:Dock(TOP)
	e:DockMargin(0,0,0,5)
	e:SetTall(25)
	e:SetText(text)
	e:SetMin(data[1] or 0)
	e:SetMax(data[2] or 100)
	e:SetDecimals(data[3] or 1)
	e:SetValue(data[1] or 0)
	e.OnValueChanged = onUpdate

	return e

end

local function setupCombo(parent, text, opts, onUpdate)

	setupLabel(parent, text)

	local e = parent:Add 'DComboBox'
	e:Dock(TOP)
	e:DockMargin(0,0,0,5)
	e:SetTall(25)
	for i, v in ipairs(opts) do e:AddChoice(unpack(v)) end
	e:ChooseOptionID(1)
	e.OnSelect = onUpdate

	return e

end

local function setupCheckBox(parent, text, bool, onUpdate)

	local e = parent:Add 'DCheckBoxLabel'
	e:Dock(TOP)
	e:DockMargin(0,0,0,5)
	e:SetTall(25)
	e:SetText(text)
	e:SetValue(bool or false)
	e.OnChange = onUpdate

	return e
end

octoinv.itemCreateFields = octoinv.itemCreateFields or {}

octoinv.itemCreateFields['food'] = {
	{'slider', L.energy, {0, 100, 0}, function(item, val) item.energy = math.Round(val) end, function(item) return item.energy end},
	{'slider', L.max_energy, {0, 100, 0}, function(item, val) item.maxenergy = math.Round(val) end, function(item) return item.maxenergy end},
	{'checkbox', 'Напиток', false, function(item, val) item.drink = val or nil end, function(item) return item.drink end},
	{'checkbox', 'Оставляет мусор', false, function(item, val) item.trash = val or nil end, function(item) return item.trash end},
}

octoinv.itemCreateFields['lock_cont'] = {
	{'slider', L.lock_cont, {1, 20, 0}, function(item, val)
		val = math.Round(val)
		item.name = val .. L.item_lock
		item.num = val
	end, function(item) return item.num end},
	{'entry', 'Пароль', '', function(item, val)
		item.password = string.Trim(val) ~= '' and val or nil
	end, function(item) return item.password end},
}

octoinv.itemCreateFields['cont'] = {
	{'slider', L.slider, {1, 1000, 0}, function(item, val)
		val = math.Round(val)
		item.contdata = item.contdata or {}
		if item.model then item.contdata.model = item.model end
		item.contdata.conts = { box = { name = item.name, volume = val }}
	end, function(item)
		return item.contdata and item.contdata.conts and item.contdata.conts.box and item.contdata.conts.box.volume or 1
	end},
}

octoinv.itemCreateFields['key'] = {
	{'entry', 'Пароль', '', function(item, val)
		item.password = string.Trim(val) ~= '' and val or nil
	end, function(item)
		return item.password
	end},
}

octoinv.itemCreateFields['door'] = {
	{'slider', 'Скин двери', {0, 13, 0}, function(item, val)
		item.name = L['item_door' .. math.Round(val)]
		item.skin = val
	end, function(item)
		return item.skin
	end},
}

octoinv.itemCreateFields['door_handle'] = {
	{'slider', 'Вид ручки', {1, 2, 0}, function(item, val)
		val = math.Round(val)
		item.name = L['item_door_handle' .. val]
		item.handle = val
	end, function(item)
		return item.handle
	end},
}

octoinv.itemCreateFields['fish_line'] = {
	{'combo', 'Вид', {
		{'Тонкая', {true, 'thin'}},
		{'Крепкая', {false, 'thick'}},
	}, function(item, name, data)
		item.name = name .. ' леска'
		item.thin = data[1]
		item.icon = 'octoteam/icons/fishing_line_' .. data[2] .. '.png'
	end, function(item)
		return item.name
	end},
}

octoinv.itemCreateFields['fish_bait'] = {
	{'combo', 'Содержимое', {
		{'Бекон', {'Наживка из бекона', 'bacon'}},
		{'Сыр', {'Насадка из сыра', 'cheese'}},
		{'Черви', {'Черви', 'classic', 'worm'}},
		{'Живцы', {'Живцы', 'fish'}},
		{'Креветки', {'Наживка из креветок', 'prawn', 'shrimp'}},
		{'Светящиеся окуни', {'Светящиеся окуни', 'synthetic', 'glowing_perch'}},
	}, function(item, name, data)
		item.name = data[1]
		item.bait = data[2]
		item.icon = 'octoteam/icons/bait_' .. (data[3] or data[2]) .. '.png'
	end, function(item)
		return item.name
	end},
}

octoinv.itemCreateFields['throwable'] = {
	{'combo', 'Вид', {
		{'Светошумовые гранаты', {'ent_dbg_grenade_stun', 'Оглушают и ослепляют на короткое время', 'weapon_grenade_flash'}},
		{'Шоковые гранаты', {'ent_dbg_grenade_shock', 'Оглушают и ослепляют на короткое время. Заставляют выкинуть оружие и испускают немного слезоточивого газа', 'weapon_grenade_shock'}},
		{'Дымовые гранаты', {'ent_dbg_grenade_smoke', 'Заполняют непроглядным дымом все помещение', 'weapon_grenade_smoke'}},
		{'Газовые гранаты', {'ent_dbg_grenade_gas', 'При разрыве испускают слезоточивый газ. Не действует при надетом противогазе', 'weapon_grenade_gas'}},
		{'Страйкбольные гранаты', {'ent_dbg_grenade_air', 'Выбивают пневматическое оружие из рук. Может также немного поранить осколками', 'gun_grenade'}},
		{'Осколочные гранаты', {'ent_dbg_grenade_frag', 'Когда оставить в живых уже далеко не главная задача...', 'weapon_grenade_frag'}},
		{'Петарды', {'ent_dbg_petard', 'Это еще что за шутки?!', 'dynamite'}},
		{'Метательные яблоки', {'ent_dbg_apple', 'Яблочки, которые можно метать', 'food_apple'}},
	}, function(item, name, data)
		item.name = name
		item.usesLeft = item.usesLeft or 5
		item.gc = data[1]
		item.desc = data[2]
		item.icon = 'octoteam/icons/' .. data[3] .. '.png'
	end, function(item)
		return item.name
	end},
	{'slider', 'Количество', {1, 10, 0}, function(item, val)
		val = math.Round(val)
		if val == 5 then
			item.usesLeft = nil
		else
			item.usesLeft = val
		end
		item.mass = 0.5
		item.volume = 0.4
	end, function(item)
		return item.usesLeft or 5
	end},
}

octoinv.itemCreateFields['ammo'] = {
	{'combo', L.type_ammo, {
		{L.small_ammo, {'pistol', 24}},
		{L.large_ammo, {'smg1', 30}},
		{L.buckshot, {'buckshot', 8}},
		{L.sniper_ammo, {'sniper', 12}},
		{L.air_ammo, {'air', 30}},
	}, function(item, name, data)
		item.name = name
		item.ammotype = data[1]
		item.ammocount = data[2]
	end, function(item)
		return item.name
	end},
}

octoinv.itemCreateFields['idcard'] = {
	{'entry', 'Удостоверение', 'сотрудника корпорации "Wani4ka, Inc."', function(item, val)
			val = string.Trim(val or '')
			if val == '' or val == '-' then item.cn = nil return end
			item.cn = utf8.sub(val, 1, 64)
		end, function(item)
			return item.cn
		end
	}, {'entry', 'Доп. поле', 'Отдел исследований в области оптики', function(item, val)
			val = string.Trim(val or '')
			if val == '' or val == '-' then item.add = nil return end
			item.add = utf8.sub(val, 1, 192)
		end, function(item)
			return item.add
		end
	}, {'entry', 'Выдано', 'Ивану Березкину', function(item, val)
			val = string.Trim(val or '')
			if val == '' or val == '-' then item.em = nil return end
			item.em = utf8.sub(val, 1, 128)
		end, function(item)
			return item.em
		end
	}, {'entry', 'На должности', 'Разработчик', function(item, val)
			val = string.Trim(val or '')
			if val == '' or val == '-' then item.pos = nil return end
			item.pos = utf8.sub(val, 1, 128)
		end, function(item)
			return item.pos
		end
	}, {'entry', 'Дата выдачи', '24.01.2016', function(item, val)
			val = string.Trim(val or '')
			if val == '' then val = '-' end
			item.iss = val
		end, function(item)
			return item.iss
		end
	}, {'entry', 'Действ. до', '-', function(item, val)
			val = string.Trim(val or '-')
			if val == '' or val == '-' then item.vthru = nil return end
			item.vthru = val
		end, function(item)
			return item.vthru
		end
	}
}

octoinv.itemCreateFields['armor'] = {
	{'combo', L.class_armor, {
		{L.armor_s, 16},
		{L.armor, 28},
		{L.armor_l, 40},
	}, function(item, name, armor)
		item.name = name
		item.armor = armor
	end, function(item)
		return item.name
	end},
}

octoinv.itemCreateFields['car_rims'] = {
	{'combo', L.discs, {
		{'Ferrari 250 GTO', 'models/diggercars/250gto/250gto_wheel.mdl'},
		{'Porsche 356', 'models/diggercars/356/porsche_550356_wheel.mdl'},
		{'Porsche 914', 'models/diggercars/914_6/porsche_914_wheel.mdl'},
		{'Acura NSX 1997', 'models/diggercars/a_nsx97/wheel.mdl'},
		{'Alfa Romeo Montreal', 'models/diggercars/alfa_romeo_montreal/wheel.mdl'},
		{'BMW M5 E28', 'models/diggercars/bmw_m5e28/wheel.mdl'},
		{'BMW M5 E39', 'models/diggercars/bmw_m5e39/wheel.mdl'},
		{'BMW X5 M', 'models/diggercars/bmw_x5m/wheel.mdl'},
		{'BMW M1', 'models/diggercars/bmwm1/bmwm1_wheel.mdl'},
		{'Porsche Boxster 2003', 'models/diggercars/boxster03/wheel.mdl'},
		{'Honda Civic 1994', 'models/diggercars/civic94/wheel.mdl'},
		{'Lancia Fulvia', 'models/diggercars/fulvia/wheel.mdl'},
		{'Porsche GT3', 'models/diggercars/gt3 2004/wheel.mdl'},
		{'Honda NSX-R GT', 'models/diggercars/h_nsxrgt/wheel.mdl'},
		{'Legacy', 'models/diggercars/legacy/wheel.mdl'},
		{'Packard', 'models/diggercars/packcard/wheel.mdl'},
		{'Porsche 930', 'models/diggercars/porsche_930/wheel.mdl'},
		{'Porsche 930-2', 'models/diggercars/porsche_930/wheelr.mdl'},
		{'Porsche 991 Carrera S', 'models/diggercars/991_carrera_s/wheel2.mdl'},
		{'Porsche 930 Targa', 'models/diggercars/porsche_930targa/wheel.mdl'},
		{'Porsche 944', 'models/diggercars/porsche_944/wheel.mdl'},
		{'Shelby Daytona', 'models/diggercars/shelbydaytonacoupe/wheel.mdl'},
		{'Audi Sport Quattro', 'models/diggercars/sportquattro/wheel.mdl'},
		{'Lancia Stratos', 'models/diggercars/stratos/wheel.mdl'},
		{'Firebird Transam3', 'models/diggercars/transam3/wheel.mdl'},
		{'Acura NSX 1997-2', 'models/diggercars/a_nsx97/wheel2.mdl'},
		{'Acura NSX 2005', 'models/diggercars/a_nsx05/wheel.mdl'},
		{'Acura RSXS', 'models/diggercars/acura_rsxs/wheel.mdl'},
		{'Alfa Romeo', 'models/diggercars/alfa/wheel.mdl'},
		{'Ariel Atom', 'models/diggercars/ariel_atom/wheel.mdl'},
		{'BMW M5 E34', 'models/diggercars/bmw_m5e34/wheel.mdl'},
		{'BMW M5 E60', 'models/diggercars/bmw_m5e60/wheel.mdl'},
		{'BMW X5 2009', 'models/diggercars/bmw_x5_09/wheel.mdl'},
		{'BMW X6 M', 'models/diggercars/bmw_x6m/wheel.mdl'},
		{'Fiat 500', 'models/diggercars/fiat500/wheel.mdl'},
		{'Ford Cortina', 'models/diggercars/cortina/wheel.mdl'},
		{'Honda Civic 1991', 'models/diggercars/civic91/wheel.mdl'},
		{'Honda Civic 1999', 'models/diggercars/civic99/wheel.mdl'},
		{'Honda Integra 2000', 'models/diggercars/h_integra2000/wheel.mdl'},
		{'Honda Integra', 'models/diggercars/h_integra/wheel.mdl'},
		{'Honda NSX-R', 'models/diggercars/h_nsxr/wheel.mdl'},
		{'Lamborghini Aventador', 'models/diggercars/aventador/wheel.mdl'},
		{'Lamborghini Jalpa', 'models/diggercars/jalpa/wh1.mdl'},
		{'Mercedes-Benz 300 SL', 'models/diggercars/300sl/wheel.mdl'},
		{'Mercedes-Benz CLK GTR', 'models/diggercars/clkgtr/wheel.mdl'},
		{'Mercedes-Benz W123', 'models/diggercars/w123/mb_w123_wheel.mdl'},
		{'Opel Speedster', 'models/diggercars/opelspeedster/wheel.mdl'},
		{'Porsche 914-2', 'models/diggercars/porsche_914/wheel.mdl'},
		{'Porsche 959', 'models/diggercars/959/porsche_959_wheel.mdl'},
		{'Porsche 964', 'models/diggercars/964speedster/porsche_964_wheel.mdl'},
		{'Porsche 997', 'models/diggercars/997 turbo/wheel.mdl'},
		{'Porsche Carrera GT', 'models/diggercars/carrera gt/wheel.mdl'},
		{'Porsche GT1', 'models/diggercars/gt1sv/porsche_gt1_wheel.mdl'},
		{'Saab 99', 'models/diggercars/saab99turbo/wheel.mdl'},
		{'Toyota GT-One', 'models/diggercars/toyotagtone/wheel.mdl'},
		{L.item_disc, 'models/diggercars/vaz1111/oka_wheel.mdl'},
		{L.item_disc2, 'models/hl2prewar/hatch/hatch_v2_wheel.mdl'},
		{L.item_disc3, 'models/hl2prewar/van/van_wheel.mdl'},
		{L.item_disc4, 'models/salza/trabant/trabant_wheel.mdl'},
		{L.item_disc5, 'models/salza/volga/volga_wheel.mdl'},
		{L.item_disc6, 'models/salza/zaz/zaz_wheel.mdl'},
		{L.item_disc7, 'models/salza/hatchback/hatchback_wheel.mdl'},
		{L.item_disc8, 'models/salza/avia/avia_wheel.mdl'},
		{L.item_disc9, 'models/salza/skoda_liaz/skoda_liaz_fwheel.mdl'},
		{L.item_disc10, 'models/props_phx/wheels/trucktire.mdl'},
		{L.item_disc11, 'models/props_phx/wheels/trucktire2.mdl'},
	}, function(item, name, mdl)
		item.name = L.discs .. ' ' .. name
		item.model = mdl
	end, function(item)
		return item.name:gsub(L.discs .. ' ', '')
	end}
}

octoinv.itemCreateFields['clothes_custom'] = {
	{'entry', 'Материал', '', function(item, val)
		item.mat = string.Trim(val) ~= '' and val or nil
	end, function(item)
		return item.mat
	end},
	{'combo', 'Тип одежды', {
		{'Универсальная', nil},
		{'Мужская', 'male'},
		{'Женская', 'female'},
	}, function(item, _, gender)
		item.gender = gender
	end, function(item)
		return not item.gender and 'Универсальная'
			or item.gender == 'male' and 'Мужская'
			or item.gender == 'female' and 'Женская'
	end},
	{'checkbox', 'Теплая', false, function(item, val) item.warm = val or nil end, function(item) return item.warm end},
}

octoinv.itemCreateFields['collector'] = {
	{'combo', 'Тип', {
		{'Кирка', 'pickaxe'},
	}, function(item, name, collectorID)
		item.name = name
		item.collector = collectorID
	end, function(item)
		return item.name
	end},
}

hook.Add('Initialize', 'octoinv.give', function()

	octoinv.itemCreateFields['car_att'] = {
		{'combo', L.accessory, octolib.table.mapSequential(simfphys.attachments, function(att, id) return { att.name or id, att } end), function(item, name, att)
			item.name = att.name
			item.desc = att.desc
			item.model = att.mdl
			item.attmdl = att.mdl
			item.skin = att.skin
			item.scale = att.scale
			item.colorable = not att.noPaint or nil
			item.col = att.col or nil
			item.mass = att.mass
			item.volume = att.volume
		end, function(item)
			return item.name
		end},
		{'checkbox', 'Красится в цвет авто', false, function(item, val)
			item.colorable = val
		end, function(item)
			return item.colorable
		end},
	}

	-- local opts = {}
	-- for vehID, parts in pairs(simfphys.carBGs) do
	-- 	for _, part in ipairs(parts) do
	-- 		local spData = list.Get('simfphys_vehicles')[vehID]
	-- 		if spData then
	-- 			opts[#opts + 1] = { spData.Name .. ' – ' .. part[1], { vehID, part[3], part[4], part[5], part[6] }}
	-- 		end
	-- 	end
	-- end

	-- octoinv.itemCreateFields['car_part'] = {{'combo', L.detail, opts, function(item, name, data)
	-- 	item.name = name
	-- 	item.car = data[1]
	-- 	item.bgnum = data[2]
	-- 	item.bgval = data[3]
	-- 	item.mass = data[4]
	-- 	item.volume = data[5]
	-- end}}

	octoinv.itemCreateFields['h_mask'] = {
		{'combo', L.mask, octolib.table.mapSequential(CFG.masks, function(mask, id) return {mask.name or id, id} end), function(item, name, mask)
			item.name = name
			item.mask = mask
			item.icon = CFG.masks[mask].icon
			item.desc = CFG.masks[mask].desc
		end, function(item)
			return item.name or item.mask
		end},
	}

	local wepsData = {}
	for id, wep in SortedPairsByMemberValue(weapons.GetList(), 'PrintName') do
		if wep.PrintName then
			wepsData[#wepsData + 1] = { ('%s (%s)'):format(wep.PrintName, wep.ClassName), wep.ClassName }
		end
	end

	octoinv.itemCreateFields['weapon'] = {
		{'combo', L.weapons, wepsData, function(item, name, class)
			item.name = name:gsub('%(.+%)', '') item.wepclass = class
		end, function(item)
			return item.name
		end},
	}

end)

local function importItem(code)
	return pon.decode(string.Trim(code)) or {}
end

local function openSystemItems(callback)

	local f = vgui.Create 'DFrame'
	f:SetSize(300, 600)
	if IsValid(octoinv.pnlGive) then
		local x, y = octoinv.pnlGive:GetPos()
		f:SetPos(x - 305, y)
	else
		f:Center()
	end
	f:MakePopup()
	f:SetTitle('Системные предметы')

	local tree = f:Add 'DTree'
	tree:Dock(FILL)
	function tree:OnNodeSelected(node)
		if not node.item then return end
		callback(node.item)
	end

	local function rebuildTree(query)
		query = query and query:Trim() ~= '' and utf8.lower(query) or nil
		tree:Clear()

		local created = {}

		local shopItems, craftItems, processItems = {}, {}, {}
		for id, shopItem in pairs(octoinv.shopItems) do
			local item = shopItem.data and table.Copy(shopItem.data) or {}
			item.class = shopItem.item or id

			local creationID = item.class .. ':' .. octoinv.getItemData(item, 'name')
			if not created[creationID] then
				shopItems[#shopItems + 1] = item
				created[creationID] = true
			end
		end

		for id, craft in pairs(octoinv.crafts) do
			local finish = istable(craft.finish) and craft.finish[1]
			if istable(finish) then
				local item = { class = finish[1] }
				if istable(finish[2]) then
					table.Merge(item, finish[2])
				elseif isnumber(finish[2]) then
					item.amount = finish[2]
				end

				local creationID = item.class .. ':' .. octoinv.getItemData(item, 'name')
				if not created[creationID] then
					craftItems[#craftItems + 1] = item
					created[creationID] = true
				end
			end
		end

		for id, prod in pairs(octoinv.prods) do
			for _, process in ipairs(prod.prod) do
				for contID, items in pairs(process.out) do
					for _, finish in ipairs(items) do
						local chance, class, data = unpack(finish)
						if isstring(chance) then
							class, data = chance, class
						end

						local item = { class = class }
						if istable(data) then
							table.Merge(item, data)
						elseif isnumber(data) then
							item.amount = data
						end

						local creationID = item.class .. ':' .. octoinv.getItemData(item, 'name')
						if not created[creationID] then
							processItems[#processItems + 1] = item
							created[creationID] = true
						end
					end
				end
			end
		end

		local function addNode(parent, item)
			if query and not utf8.lower(octoinv.getItemData(item, 'name')):find(query) and not utf8.lower(item.class):find(query) then return end

			local node = parent:AddNode(octoinv.getItemData(item, 'name'), iconPath(octoinv.getItemData(item, 'icon')))
			node.item = item
		end

		local function sorter(a, b)
			return octoinv.getItemData(a, 'name') < octoinv.getItemData(b, 'name')
		end
		table.sort(shopItems, sorter)
		table.sort(craftItems, sorter)
		table.sort(processItems, sorter)

		local shopNode = tree:AddNode('Магазин', octolib.icons.silk16('basket_shopping'))
		for _, item in ipairs(shopItems) do addNode(shopNode, item) end

		local craftNode = tree:AddNode('Крафты', octolib.icons.silk16('hammer'))
		for _, item in ipairs(craftItems) do addNode(craftNode, item) end

		local processNode = tree:AddNode('Процессы', octolib.icons.silk16('time'))
		for _, item in ipairs(processItems) do addNode(processNode, item) end

		if query then
			shopNode:SetExpanded(true, true)
			craftNode:SetExpanded(true, true)
			processNode:SetExpanded(true, true)
		end
	end
	rebuildTree()

	local search = f:Add 'DTextEntry'
	search:Dock(TOP)
	search:DockMargin(5,5,5,10)
	search:SetTall(15)
	search:SetTooltip(L.search_or_filter)
	search:SetUpdateOnType(true)
	search.PaintOffset = 5
	search:SetPlaceholderText(L.search_hint)
	search.OnValueChange = octolib.func.debounce(function(self, val)
		rebuildTree(val)
	end, 0.5)

end

local resultText = (L.resultText):gsub('||', string.char(10))
concommand.Add('octoinv_give', function()

	if not LocalPlayer():query(L.permissions_edit_inventory)  then
		octolib.notify.show('warning', L.not_have_access)
		return
	end

	if IsValid(octoinv.pnlGive) then
		octoinv.pnlGive:SetVisible(true)
		return
	end

	local f = vgui.Create 'DFrame'
	f:SetSize(700, 600)
	f:SetTitle(L.give_item)
	f:Center()
	f:MakePopup()
	f:SetDeleteOnClose(false)
	octoinv.pnlGive = f

	local presetsPan = f:Add('DScrollPanel')
	presetsPan:Dock(RIGHT)
	presetsPan:DockMargin(5, 0, 0, 0)
	presetsPan.oldPerformLayout = presetsPan.PerformLayout
	function presetsPan:PerformLayout(w, h)
		self:oldPerformLayout(w, h)
		self:SetWide(self:GetVBar():IsVisible() and 79 or 64)
	end

	local presetsButtons = presetsPan:Add('DPanel')
	presetsButtons:Dock(TOP)
	presetsButtons:SetTall(22)
	presetsButtons:SetPaintBackground(false)

	local butAdd = presetsButtons:Add('DImageButton')
	butAdd:Dock(LEFT)
	butAdd:SetWide(32)
	butAdd:SetStretchToFit(false)
	butAdd:SetIcon('icon16/disk.png')
	butAdd:AddHint('Сохранить в шаблон')

	local butImport = presetsButtons:Add('DImageButton')
	butImport:Dock(RIGHT)
	butImport:SetWide(32)
	butImport:SetStretchToFit(false)
	butImport:SetIcon('icon16/page_go.png')
	butImport:AddHint('Импортировать шаблон')

	local presets = presetsPan:Add('DListLayout')
	presets:Dock(FILL)
	presets:MakeDroppable('octoinv_presets')

	local lCont = f:Add 'DPanel'
	lCont:Dock(LEFT)
	lCont:DockMargin(0,0,5,0)
	lCont:SetWide(250)
	lCont:SetPaintBackground(false)

	local lv = lCont:Add 'DListView'
	lv:Dock(FILL)
	lv:AddColumn('ID'):SetFixedWidth(100)
	lv:AddColumn(L.title):SetFixedWidth(150)

	local bp = f:Add 'DPanel'
	bp:Dock(BOTTOM)
	bp:DockMargin(0,5,0,0)
	bp:SetTall(25)
	bp:SetPaintBackground(false)

	local b1 = bp:Add 'DButton'
	b1:Dock(RIGHT)
	b1:SetText(L.my_inventory)
	b1:SizeToContentsX(20)
	function b1:DoClick() octoinv.show(not (IsValid(octoinv.mainPnl) and octoinv.mainPnl:IsVisible())) end

	local b2 = bp:Add 'DButton'
	b2:Dock(RIGHT)
	b2:SetText(L.octoinv_editor)
	b2:SizeToContentsX(20)
	b2:DockMargin(0, 0, 5, 0)
	function b2:DoClick() RunConsoleCommand('octoinv_editor') end

	local itemToGive, amount = {}, 1

	local function getItemData()
		local item = { class = itemToGive[1], amount = amount }
		for k, v in pairs(itemToGive[2]) do
			local data = octoinv.items[item.class]
			local default = (data and data[k]) or defaultData[k]
			if v ~= default then
				item[k] = v
			end
		end
		item._mo = nil -- delete cached markup object
		return item
	end

	local pr = f:Add 'DPanel'
	pr:Dock(BOTTOM)
	pr:DockMargin(0,5,0,0)
	pr:DockPadding(8,5,5,5)
	pr:SetTall(74)
	function pr:Update()
		self:Clear()

		local item = getItemData()
		local b = octoinv.createItemPanel(self, item, true)
		b:Dock(RIGHT)
		b:SetWide(64)
		b:Droppable('octoinv_give')
		b.item = item
		b:SetTooltip(util.TableToJSON(item, true))

		local l1 = self:Add 'DLabel'
		l1:Dock(TOP)
		l1:SetContentAlignment(1)
		l1:SetTall(23)
		l1:SetFont('octoinv-help.subheading')
		l1:SetText(L.result)

		local l2 = self:Add 'DLabel'
		l2:Dock(FILL)
		l2:SetContentAlignment(4)
		l2:SetText(resultText:format(itemData(item, 'volume') * amount, itemData(item, 'mass') * amount))
	end

	function butAdd:DoClick()
		local item = getItemData()
		if item.icon and not isstring(item.icon) then item.icon = item.icon:GetName() .. '.png' end
		local items = octolib.vars.get('octoinv.presets') or {}
		items[#items + 1] = item
		octolib.vars.set('octoinv.presets', items)
		presets:Update()
		presetsPan:GetVBar():AnimateTo(presets:GetTall(), 0.5, 0)
	end

	local setup = f:Add 'DScrollPanel'
	setup:Dock(FILL)
	setup:SetPaintBackground(true)
	setup.pnlCanvas:DockPadding(10,5,10,5)
	function setup:Update(itemID, data)
		self:Clear()

		local class = octoinv.items[itemID]
		if not class then return end

		data = data or {}
		itemToGive = {itemID, table.Copy(data)}

		setupEntry(self, L.quantity, tostring(data.amount or 1), function(self, val)
			local val = tonumber(val)
			if val then
				amount = val
			else
				self:SetValue(1)
			end

			pr:Update()
		end)

		if class.nostack then
			setupEntry(self, L.title, itemData(itemToGive, 'name'), function(self, val)
				itemToGive[2].name = tostring(val)
				pr:Update()
			end)

			setupEntry(self, L.octoinv_desc, itemData(itemToGive, 'desc'), function(self, val)
				itemToGive[2].desc = tostring(val)
				pr:Update()
			end)

			local icon = setupEntry(self, L.icon, iconPath(itemData(itemToGive, 'icon')), function(self, val)
				itemToGive[2].icon = Material(tostring(val))
				pr:Update()
			end)
			local b = icon:Add 'DButton'
			b:Dock(RIGHT)
			b:SetWide(25)
			b:SetText('')
			b:SetIcon('icon16/color_swatch.png')
			b:SetPaintBackground(false)
			function b:DoClick()
				if IsValid(self.picker) then return end
				self.picker = octolib.icons.picker(function(val) icon:SetValue(val) end)
			end

			setupEntry(self, L.model, itemData(itemToGive, 'model'), function(self, val)
				itemToGive[2].model = tostring(val)
				pr:Update()
			end)

			setupEntry(self, L.item_val, tostring(itemData(itemToGive, 'volume') or 1), function(self, val)
				local val = tonumber(val)
				if not val then return end

				itemToGive[2].volume = val
				pr:Update()
			end)

			setupEntry(self, L.item_massa, tostring(itemData(itemToGive, 'mass') or 1), function(self, val)
				local val = tonumber(val)
				if not val then return end

				itemToGive[2].mass = val
				pr:Update()
			end)

			setupEntry(self, 'Срок действия (сек)', tostring(itemData(itemToGive, 'expire') or 0), function(self, val)
				local expire = tonumber(val)
				if expire <= 0 then expire = nil end
				itemToGive[2].expire = expire
				pr:Update()
			end)

			local specific = octoinv.itemCreateFields[itemID]
			if specific then
				for i, v in ipairs(specific) do
					local type, name, settings, set, get = unpack(v)
					local spData = {type}
					if type == 'entry' then
						spData[2] = setupEntry(self, name, settings, function(self, val)
							set(itemToGive[2], val)
							pr:Update()
						end)

						local val = get(itemToGive[2])
						if val then
							spData[2]:SetValue(val)
						end
					elseif type == 'combo' then
						spData[2] = setupCombo(self, name, settings, function(self, i, val, data)
							set(itemToGive[2], val, data)
							pr:Update()
						end)

						local val = get(itemToGive[2])
						if val then
							spData[2]:SetValue(val)
						else
							spData[2]:ChooseOptionID(1)
						end
					elseif type == 'slider' then
						spData[2] = setupSlider(self, name, settings, function(self, val)
							set(itemToGive[2], val)
							pr:Update()
						end)
						spData[2]:SetValue(get(itemToGive[2]) or settings[1] or 0)
					elseif type == 'checkbox' then
						spData[2] = setupCheckBox(self, name, settings, function(self, val)
							set(itemToGive[2], val)
							pr:Update()
						end)

						local val = get(itemToGive[2])
						if val then
							spData[2]:SetChecked(val)
						end
					end
				end
			end
		end

		pr:Update()
	end

	local function rebuildList(query)
		lv:Clear()
		if query then query = utf8.lower(query) end

		for id, item in pairs(octoinv.items) do
			local itemName = itemData(item, 'name')
			if not query or string.Trim(query) == ''
			or utf8.lower(id):find(query, 1, true) or utf8.lower(itemName):find(query, 1, true) then
				local l = lv:AddLine(id, itemName)
				l.itemID = id
			end
		end
		lv:SortByColumn(1)
	end
	rebuildList()

	local search = lCont:Add 'DTextEntry'
	search:Dock(TOP)
	search:DockMargin(5,5,5,10)
	search:SetTall(15)
	search:SetTooltip(L.search_or_filter)
	search:SetUpdateOnType(true)
	search.PaintOffset = 5
	search:SetPlaceholderText(L.search_hint)
	function search:OnValueChange(val)
		rebuildList(val)
	end

	function lv:OnRowSelected(i, l)
		setup:Update(l.itemID)
	end
	lv:SelectFirstItem()

	local function silentSelect(class)
		for i,v in ipairs(lv.Sorted) do
			if v:GetValue(1) == class then
				lv:ClearSelection()
				v:SetSelected(true)
				lv.VBar:AnimateTo(i * lv:GetDataHeight() - 2 * lv:GetHeaderHeight(), 0.5, 0)
			end
		end
	end

	local function doRightClick(self)
		local menu = DermaMenu()
		menu:AddOption('Открыть', function()
			silentSelect(self.item.class)
			setup:Update(self.item.class, table.Copy(self.item))
		end):SetIcon('octoteam/icons-16/arrow_right.png')
		menu:AddOption('Экспортировать', function()
			SetClipboardText(pon.encode(self.item))
			octolib.notify.show('Шаблон скопирован, можно отправить его кому-нибудь для импорта')
		end):SetIcon('icon16/page_go.png')
		menu:AddOption('Удалить', function()
			local items = octolib.vars.get('octoinv.presets') or {}
			table.remove(items, self.index)
			octolib.vars.set('octoinv.presets', items)
			self:Remove()
			for i,v in ipairs(presets:GetChildren()) do
				v.index = i
			end
			timer.Simple(0, function() presetsPan:InvalidateLayout() end)
		end):SetIcon('octoteam/icons-16/cancel.png')
		menu:Open()
	end
	local function doClick(self)
		silentSelect(self.item.class)
		setup:Update(self.item.class, table.Copy(self.item))
	end

	function presets:AddPreset(index, item, noInvalidates)
		local b = octoinv.createItemPanel(self, item, true)
		b:DockMargin(0, 5, 0, 0)
		b:SetTall(64)
		b.item = item
		b.index = index
		b:SetTooltip(util.TableToJSON(item, true))
		b.DoRightClick = doRightClick
		b.DoClick = doClick
		if not noInvalidates then
			timer.Simple(0, function()
				presetsPan:InvalidateLayout()
			end)
		end
	end
	function presets:Update()
		self:Clear()
		local savedItems = octolib.vars.get('octoinv.presets') or {}
		for index, item in ipairs(savedItems) do
			item._mo = nil -- delete cached markup object
			self:AddPreset(index, item, true)
		end
		timer.Simple(0, function()
			presetsPan:InvalidateLayout()
		end)
	end
	presets:Update()

	function presets:OnModified()
		local newVar = {}
		for i,data in ipairs(self:GetChildren()) do
			newVar[i] = data.item
		end
		octolib.vars.set('octoinv.presets', newVar)
		self:Update()
	end

	function butImport:DoClick()
		octolib.request.open({
			{
				name = 'Код шаблона',
				desc = 'Вставь сюда код шаблона предмета, полученный при экспорте',
				type = 'strShort',
			}
		}, function(data)
			if not istable(data) or not isstring(data[1]) then return end

			local succ, item = pcall(importItem, data[1])
			if not succ then
				return octolib.notify.show('warning', 'Не удалось импортировать шаблон. Проверь код предмета')
			end
			if not item.class or not octoinv.items[item.class] then
				return octolib.notify.show('warning', 'Предмет с таким классом не найден')
			end

			local items = octolib.vars.get('octoinv.presets') or {}
			items[#items + 1] = item
			octolib.vars.set('octoinv.presets', items)
			presets:Update()
			octolib.notify.show('Шаблон предмета успешно импортирован')
		end)
	end

	local butSystem = bp:Add('DButton')
	butSystem:Dock(LEFT)
	butSystem:DockMargin(0, 0, 5, 0)
	butSystem:SetText('Системные')
	butSystem:SizeToContentsX(20)
	function butSystem:DoClick()
		openSystemItems(function(item)
			silentSelect(item.class)
			setup:Update(item.class, table.Copy(item))
		end)
	end

end)

if IsValid(octoinv.pnlGive) then octoinv.pnlGive:Remove() end
