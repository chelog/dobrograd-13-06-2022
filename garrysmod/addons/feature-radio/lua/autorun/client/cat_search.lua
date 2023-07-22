octoradio = octoradio or {}
octoradio.search = octoradio.search or {}

local function loadSearch(lst, query, place, country, curOffset, data)
	if not IsValid(lst) then return end

	for _,v in ipairs(data) do
		lst:AddStation(v.title, v.placeName, v.country, v.id)
	end

	octoradio.search.returnBtn:SetVisible(true)
	octoradio.search.returnBtn.DoClick = octoradio.search.mainPage

	if #data == 25 then
		octoradio.btnNext:SetEnabled(true)
		function octoradio.btnNext:DoClick()
			lst:Clear()
			netstream.Request('octoradio.search', {query, place, country, curOffset + 25}):Then(function(data)
				loadSearch(lst, query, place, country, curOffset + 25, data)
			end):Catch(print)
		end
	else octoradio.btnNext:SetEnabled(false) end

	if curOffset > 0 then
		octoradio.btnPrev:SetEnabled(true)
		function octoradio.btnPrev:DoClick()
			lst:Clear()
			netstream.Request('octoradio.search', {query, place, country, math.max(curOffset - 25, 0)}):Then(function(data)
				loadSearch(lst, query, place, country, math.max(curOffset - 25, 0), data)
			end):Catch(print)
		end
	else octoradio.btnPrev:SetEnabled(false) end

	lst:InvalidateChildren()
end

function octoradio.populateSearch(pan)

	octoradio.search = {}
	octoradio.search.pan = pan
	local searchPan = pan:Add('DPanel')
	searchPan:Dock(TOP)
	searchPan:SetPaintBackground(false)
	searchPan:SetTall(32)
	local returnBtn = searchPan:Add('DImageButton')
	returnBtn:Dock(LEFT)
	returnBtn:DockMargin(4, 8, 4, 8)
	returnBtn:SetWide(16)
	returnBtn:SetImage('octoteam/icons-16/arrow_left.png')
	octoradio.search.returnBtn = returnBtn
	local searchEntry = octolib.textEntry(searchPan)
	searchEntry:Dock(FILL)
	searchEntry:SetPlaceholderText('Поиск радиостанций в мире')
	octoradio.search.entry = searchEntry
	local searchBtn = searchEntry:Add('DImageButton')
	searchBtn:Dock(RIGHT)
	searchBtn:DockMargin(0, 6, 8, 6)
	searchBtn:SetWide(16)
	searchBtn:SetImage('octoteam/icons-16/zoom.png')
	function searchBtn:DoClick()
		searchEntry:OnValueChange(searchEntry:GetValue())
	end

	function searchEntry:OnValueChange(val)
		octoradio.search.lst:Clear()
		netstream.Request('octoradio.search', {val, octoradio.search.place, octoradio.search.country, 0}):Then(function(data)
			loadSearch(octoradio.search.lst, val, octoradio.search.place, octoradio.search.country, 0, data)
		end):Catch(print)
	end

	local lst = octoradio.createList(pan)
	octoradio.search.lst = lst

	function octoradio.search.mainPage()
		lst:Clear()
		octoradio.search.place, octoradio.search.country = nil
		returnBtn:SetVisible(false)
		searchPan:InvalidateLayout()
		searchEntry:SetPlaceholderText('Поиск радиостанций в мире')
		local countries = netvars.GetNetVar('octoradio.countries', {})
		for k,v in SortedPairsByValue(countries, true) do
			lst:AddCountry(k, v)
		end
		lst:InvalidateChildren()
	end

	octoradio.btnPrev:SetEnabled(false)
	octoradio.btnNext:SetEnabled(false)
	octoradio.search.mainPage()

end
