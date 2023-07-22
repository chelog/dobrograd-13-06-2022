local function loadPlaces(lst, country, curOffset, data)
	if not IsValid(lst) then return end

	octoradio.search.entry:SetPlaceholderText('Поиск радиостанций в ' .. country)
	for _,v in ipairs(data) do
		if v.type == 'place' then
			lst:AddPlace(v.name, v.country, v.cnt)
		else
			lst:AddStation(v.name, v.place, v.country, v.id)
		end
	end

	octoradio.search.returnBtn:SetVisible(true)
	octoradio.search.returnBtn.DoClick = octoradio.search.mainPage

	if #data == 25 then
		octoradio.btnNext:SetEnabled(true)
		function octoradio.btnNext:DoClick()
			lst:Clear()
			netstream.Request('octoradio.getByCountry', {country, curOffset + 25}):Then(function(data)
				loadPlaces(lst, country, curOffset + 25, data)
			end):Catch(print)
		end
	else octoradio.btnNext:SetEnabled(false) end

	if curOffset > 0 then
		octoradio.btnPrev:SetEnabled(true)
		function octoradio.btnPrev:DoClick()
			lst:Clear()
			netstream.Request('octoradio.getByCountry', {country, math.max(curOffset - 25, 0)}):Then(function(data)
				loadPlaces(lst, country, math.max(curOffset - 25, 0), data)
			end):Catch(print)
		end
	else octoradio.btnPrev:SetEnabled(false) end

	lst:InvalidateChildren()
end

local function loadStations(lst, place, country, curOffset, data)
	if not IsValid(lst) then return end

	octoradio.search.entry:SetPlaceholderText('Поиск радиостанций в ' .. place .. ', ' .. country)
	for _,v in ipairs(data) do
		lst:AddStation(v.name, v.place, v.country, v.id)
	end

	octoradio.search.returnBtn:SetVisible(true)
	octoradio.search.returnBtn.DoClick = function()
		lst:Clear()
		netstream.Request('octoradio.getByCountry', {country, 0}):Then(function(data)
			loadPlaces(lst, country, 0, data)
		end):Catch(print)
	end

	if #data == 25 then
		octoradio.btnNext:SetEnabled(true)
		function octoradio.btnNext:DoClick()
			lst:Clear()
			netstream.Request('octoradio.getByPlace', {place, country, curOffset + 25}):Then(function(data)
				loadStations(lst, place, country, curOffset + 25, data)
			end):Catch(print)
		end
	else octoradio.btnNext:SetEnabled(false) end

	if curOffset > 0 then
		octoradio.btnPrev:SetEnabled(true)
		function octoradio.btnPrev:DoClick()
			lst:Clear()
			netstream.Request('octoradio.getByPlace', {place, country, math.max(curOffset - 25, 0)}):Then(function(data)
				loadStations(lst, place, country, math.max(curOffset - 25, 0), data)
			end):Catch(print)
		end
	else octoradio.btnPrev:SetEnabled(false) end

	lst:InvalidateChildren()
end

local function rebuildStFrame()
	local fr = octolib.overlay(octoradio.pnl, 'DPanel')
	fr:SetSize(300, 200)

	local titleCont = fr:Add('DPanel')
	titleCont:Dock(TOP)
	titleCont:DockMargin(5, 0, 5, 0)
	titleCont:SetTall(50)
	titleCont:SetPaintBackground(false)

	local playBtn = titleCont:Add('DImageButton')
	playBtn:Dock(RIGHT)
	playBtn:SetWide(32)
	playBtn:DockMargin(5, 9, 0, 9)

	local favBtn = titleCont:Add('DImageButton')
	favBtn:Dock(RIGHT)
	favBtn:SetWide(32)
	favBtn:DockMargin(10, 9, 0, 9)
	function favBtn:DoClick()
		if not octoradio.id then return end
		if not table.HasValue(octoradio.favs, octoradio.id) then
			octoradio.favAdd(octoradio.id)
		else octoradio.favRemove(octoradio.id) end
		self:SetImage('octoteam/icons-32/' .. (table.HasValue(octoradio.favs, octoradio.id) and '' or 'draw_') .. 'star.png')
	end

	local titleTextCont = titleCont:Add('DPanel')
	titleTextCont:Dock(FILL)
	titleTextCont:SetPaintBackground(false)

	local titleLabel = titleTextCont:Add('DLabel')
	titleLabel:Dock(TOP)
	titleLabel:SetTall(30)
	titleLabel:SetContentAlignment(1)
	titleLabel:SetFont('f4.normal')
	local subtitleCont = titleTextCont:Add('DPanel')
	subtitleCont:Dock(FILL)
	subtitleCont:SetPaintBackground(false)
	subtitleCont:SetContentAlignment(7)
	subtitleCont:SetTall(20)
	local icon = subtitleCont:Add('DImage')
	icon:Dock(LEFT)
	icon:SetWide(16)
	icon:DockMargin(0, 2, 5, 2)
	local subtitleLabel = subtitleCont:Add('DLabel')
	subtitleLabel:Dock(FILL)

	local idLbl = octolib.button(fr, 'ID: ######## (нажми, чтобы скопировать)', octolib.func.debounceStart(function(self)
		SetClipboardText(octoradio.id or '')
		local txt = self:GetText()
		self:SetText('Скопировано!')
		timer.Simple(2, function()
			if IsValid(self) then
				self:SetText(txt)
			end
		end)
	end, 2))
	idLbl:DockMargin(5, 5, 5, 5)

	local moreCountry, morePlace
	if not octoradio.whitelisted then

		moreCountry = octolib.button(fr, 'Другие радиостанции в стране ', function()
			local lst = octoradio.search.lst
			if not IsValid(lst) then return end
			lst:Clear()
			netstream.Request('octoradio.getByCountry', {octoradio.curCountry, 0}):Then(function(data)
				fr:Remove()
				loadPlaces(lst, octoradio.curCountry, 0, data)
			end):Catch(print)
		end)
		moreCountry:DockMargin(5, 5, 5, 0)
		morePlace = octolib.button(fr, 'Другие радиостанции в городе ', function()
			local lst = octoradio.search.lst
			if not IsValid(lst) then return end
			lst:Clear()
			netstream.Request('octoradio.getByPlace', {octoradio.curPlace, octoradio.curCountry, 0}):Then(function(data)
				fr:Remove()
				loadStations(lst, octoradio.curPlace, octoradio.curCountry, 0, data)
			end):Catch(print)
		end)
		morePlace:DockMargin(5, 0, 5, 0)

	else
		fr:SetTall(fr:GetTall() - 55)
	end

	local dist = octolib.slider(fr, 'Слышимость', 200, 1500, 0)
	dist:DockMargin(5, 0, 5, 0)
	dist:SetValue(octoradio.dist or 600)

	local parent = octoradio.ent:GetParent()
	if IsValid(parent) and parent:IsVehicle() then
		local val = dist:GetValue()
		dist:SetMinMax(val, val)
		dist:SetValue(val)
		dist:SetEnabled(false)
	else
		dist.OnValueChanged = octolib.func.debounce(function(self, val)
			val = math.Round(val)
			netstream.Start('dbg-radio.soundControl', octoradio.ent, val, octoradio.vol)
			octoradio.dist = val
		end, 1)
	end

	local vol = octolib.slider(fr, 'Громкость', 0, 100, 0)
	vol:DockMargin(5, 0, 5, 0)
	vol:SetValue(octoradio.vol or 20)
	vol.OnValueChanged = octolib.func.debounce(function(self, val)
		val = math.Round(val)
		netstream.Start('dbg-radio.soundControl', octoradio.ent, octoradio.dist, val)
		octoradio.vol = val
	end, 1)

	function playBtn:DoClick()
		netstream.Start('dbg-radio.toggle', octoradio.ent)
		self:SetEnabled(false)
	end

	function fr:Update()
		icon:SetImage(octoradio.getFlag(octoradio.curCountry))
		favBtn:SetImage('octoteam/icons-32/' .. (table.HasValue(octoradio.favs, octoradio.id) and '' or 'draw_') .. 'star.png')
		playBtn:SetImage('octoteam/icons-32/control_' .. (octoradio.ent:GetNetVar('playing') and 'stop' or 'play') .. '_blue.png')
		playBtn:SetEnabled(true)
		idLbl:SetText('ID: ' .. octoradio.id .. ' (нажми, чтобы скопировать)')
		titleLabel:SetText(octoradio.curTitle)
		subtitleLabel:SetText(octoradio.curPlace .. ', ' .. octoradio.curCountry)
		if moreCountry then
			moreCountry:SetText('Другие радиостанции в стране ' .. octoradio.curCountry)
		end
		if morePlace then
			morePlace:SetText('Другие радиостанции в городе ' .. octoradio.curPlace)
		end
	end
	octoradio.curStFrame = fr
end

local cols = {'yellow', 'red', 'purple', 'pink', 'orange', 'green', 'blue'}
local cMapping = {
	['Åland Islands'] = 'aland_islands',
	['Bailiwick of Guernsey'] = 'guernsey',
	['Bailiwick of Jersey'] = 'jersey',
	['Bosnia and Herzegovina'] = 'bosnia',
	['Cabo Verde'] = 'cape_verde',
	['Collectivity of Saint Martin'] = 'france',
	['Curaçao'] = 'curacao',
	['Czechia'] = 'czech_republic',
	['Côte d\'Ivoire'] = 'cote_divoire',
	['Democratic Republic of the Congo'] = 'congo_democratic_republic',
	['Ecuador'] = 'equador',
	['Federated States of Micronesia'] = 'micronesia',
	['French Guiana'] = 'france',
	['Guadeloupe'] = 'france',
	['Guiné-Bissau'] = 'guinea_bissau',
	['Maldives'] = 'maledives',
	['Mayotte'] = 'france',
	['Myanmar (Burma)'] = 'burma',
	['New Calédonia'] = 'france',
	['North Macedonia'] = 'macedonia',
	['Paraguay'] = 'paraquay',
	['Republic of North Macedonia'] = 'macedonia',
	['Republic of the Congo'] = 'congo_republic',
	['Réunion'] = 'france',
	['Saint Barthélemy'] = 'france',
	['Saint Vincent and the Grenadines'] = 'saint_vincent_and_grenadines',
	['Saint-Pierre et Miquelon'] = 'saint_pierre_and_miquelon',
	['Serbia'] = 'serbia_montenegro',
	['Tahiti'] = 'french_polynesia',
	['The Bahamas'] = 'bahamas',
	['The Gambia'] = 'gambia',
	['U.S. Virgin Islands'] = 'virgin_islands',
	['United Kingdom'] = 'great_britain',
	['United States'] = 'usa',
	['Uruguay'] = 'uruquay',
}
local flagFormat = '%sflag_%s.png'
function octoradio.getFlag(country, prefix)
	prefix = prefix or 'octoteam/icons-16/'
	local iconPath = flagFormat:format(prefix, string.lower(country):gsub(' ', '_'))
	if not file.Exists('materials/' .. iconPath, 'GAME') then
		return flagFormat:format(prefix, cMapping[country] or ('flyaway_' .. cols[math.random(#cols)]))
	else return iconPath end
end

function octoradio.createList(pan)
	local lst = pan:Add('DListView')
	lst:Dock(FILL)
	lst:SetDataHeight(16)
	lst:AddColumn('icon'):SetFixedWidth(16)
	lst:AddColumn('name')
	lst:AddColumn('cnt'):SetFixedWidth(40)
	lst:SetHideHeaders(true)
	lst:SetMultiSelect(false)

	local function addEntry(country, title, cnt, onopen)
		local icon = vgui.Create('DImage')
		icon:SetImage(octoradio.getFlag(country))
		local line = lst:AddLine(icon, title, cnt or '')
		line.onOpen = onopen
		return line
	end

	function lst:AddCountry(name, stCount)
		return addEntry(name, name, stCount, function()
			self:Clear()
			octoradio.search.country, octoradio.search.place = name
			netstream.Request('octoradio.getByCountry', {name, 0}):Then(function(data)
				loadPlaces(self, name, 0, data)
			end):Catch(print)
		end)
	end

	function lst:AddPlace(name, country, stCount)
		return addEntry(country, name .. ', ' .. country, stCount, function()
			self:Clear()
			octoradio.search.place, octoradio.search.country = name, country
			netstream.Request('octoradio.getByPlace', {name, country, 0}):Then(function(data)
				loadStations(self, name, country, 0, data)
			end)
		end)
	end

	function lst:AddStation(title, place, country, id)
		local line = addEntry(country, title, nil, function()
			netstream.Start('dbg-radio.control', octoradio.ent, id)
		end)
		line.id = id
		return line
	end

	function lst:DoDoubleClick(_, line)
		if line.onOpen then line.onOpen() end
	end

	function lst:OnRowRightClick(_, line)
		if not line.id then return end
		local menu = DermaMenu()
		local fav = table.HasValue(octoradio.favs, line.id)
		menu:AddOption(fav and 'Удалить из избранного' or 'Добавить в избранное', function()
			if fav then octoradio.favRemove(line.id) else octoradio.favAdd(line.id) end
		end):SetIcon('octoteam/icons-16/' .. (fav and 'draw_' or '') .. 'star.png')
		if octoradio.id ~= line.id then
			menu:AddOption('Переключиться', function()
				netstream.Start('dbg-radio.control', octoradio.ent, line.id)
			end):SetIcon('octoteam/icons-16/control_play_blue.png')
		end
		menu:AddOption('Скопировать ID', function()
			SetClipboardText(line.id)
		end):SetIcon('octoteam/icons-16/page_white_copy.png')
		menu:Open()
	end

	return lst
end

function octoradio.displayCurStation()
	if IsValid(octoradio.curStFrame) then
		octoradio.curStFrame:Remove()
	end
	rebuildStFrame()
	octoradio.curStFrame:Update()
end
