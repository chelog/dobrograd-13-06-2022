octoradio = octoradio or {}

netstream.Hook('dbg-radio.control', function(ent, whitelisted, id, title, place, country)

	if not IsValid(ent) then return end
	local dist, vol = ent:GetDistance(), ent:GetVolume()

	if IsValid(octoradio.pnl) then
		octoradio.pnl:Close()
	end

	octoradio.ent, octoradio.whitelisted, octoradio.dist, octoradio.vol, octoradio.id = ent, whitelisted, dist, vol * 100, id
	octoradio.curTitle, octoradio.curPlace, octoradio.curCountry = title, place, country

	local f = vgui.Create 'DFrame'
	f:SetSize(350, 550)
	f:SetTitle(L.radio)
	f:Center()
	f:MakePopup()
	octoradio.pnl = f
	local panel = f:Add('DPanel')
	panel:Dock(FILL)
	panel:SetPaintBackground(false)

	local tabs = panel:Add('DPropertySheet')
	tabs:Dock(FILL)

	local search, top, dobrograd, favs, stations
	if not whitelisted then

		search = tabs:Add('DPanel')
		tabs:AddSheet('Поиск', search, octolib.icons.silk16('compass'))

		top = tabs:Add('DPanel')
		tabs:AddSheet('Популярно', top, octolib.icons.silk16('crown_gold'))

		dobrograd = tabs:Add('DPanel')
		tabs:AddSheet('Сообщество', dobrograd, octolib.icons.silk16('group'))

		favs = tabs:Add('DPanel')
		tabs:AddSheet('Избранное', favs, octolib.icons.silk16('star'))

	else

		stations = tabs:Add('DPanel')
		tabs:AddSheet('Станции', stations, octolib.icons.silk16('transmit'))

	end

	local btmPan = panel:Add('DPanel')
	btmPan:Dock(BOTTOM)
	btmPan:DockMargin(115, 0, 115, 0)
	btmPan:SetTall(32)
	btmPan:SetPaintBackground(false)

	local btnPrev = btmPan:Add('DImageButton')
	btnPrev:Dock(LEFT)
	btnPrev:DockMargin(0, 0, 5, 0)
	btnPrev:SetWide(32)
	btnPrev:SetImage(octolib.icons.silk32('control_rewind_blue'))
	octoradio.btnPrev = btnPrev

	local btnInfo = btmPan:Add('DImageButton')
	btnInfo:Dock(LEFT)
	btnInfo:DockMargin(0, 0, 5, 0)
	btnInfo:SetWide(32)
	btnInfo:SetImage(octolib.icons.silk32('information'))
	btnInfo:SetEnabled(octoradio.id)
	btnInfo.DoClick = octoradio.displayCurStation
	octoradio.btnInfo = btnInfo

	local btnNext = btmPan:Add('DImageButton')
	btnNext:Dock(LEFT)
	btnNext:SetWide(32)
	btnNext:SetImage(octolib.icons.silk32('control_fastforward_blue'))
	octoradio.btnNext = btnNext

	if not whitelisted then
		octoradio.populateSearch(search)
		octoradio.populateTop(top)
		octoradio.populateDobrograd(dobrograd)
		octoradio.populateFavorite(favs)
	else
		octoradio.populateStations(stations)
	end
end)

netstream.Hook('dbg-radio.curStUpdate', function(ent, id, title, place, country)
	if not IsValid(octoradio.pnl) then return end
	if octoradio.ent ~= ent then return end
	octoradio.ent, octoradio.dist, octoradio.vol, octoradio.id = ent, ent:GetDistance(), ent:GetVolume() * 100, id
	octoradio.curTitle, octoradio.curPlace, octoradio.curCountry = title, place, country

	octoradio.btnInfo:SetEnabled(octoradio.id)
	if IsValid(octoradio.curStFrame) then
		octoradio.curStFrame:Update()
	end
end)
