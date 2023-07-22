octoradio = octoradio or {}

-- load favs
octoradio.favs = {}
local f = file.Read('octoradio_favs2.dat')
if f then octoradio.favs = pon.decode(f) or {} end

function octoradio.findFavById(id)
	for i,v in ipairs(octoradio.favs) do
		if v == id then return i end
	end
end

function octoradio.favSave()
	file.Write('octoradio_favs2.dat', pon.encode(octoradio.favs))
end

local lst

local function loadStations(curOffset, data)
	if not IsValid(lst) then return end

	for _,v in ipairs(data) do
		lst:AddStation(v.title, v.placeName, v.country, v.id)
	end

	if #data == 25 then
		octoradio.btnNext:SetEnabled(true)
		function octoradio.btnNext:DoClick()
			lst:Clear()
			local nxt = {}
			for i = curOffset + 25, math.min(#octoradio.favs, curOffset + 50) do
				nxt[#nxt + 1] = octoradio.favs[i]
			end
			netstream.Request('octoradio.getById', nxt):Then(function(data)
				loadStations(curOffset + 25, data)
			end):Catch(print)
		end
	else octoradio.btnNext:SetEnabled(false) end
	if curOffset > 1 then
		octoradio.btnPrev:SetEnabled(true)
		function octoradio.btnPrev:DoClick()
			lst:Clear()
			local nxt = {}
			for i = math.max(curOffset - 25, 1), curOffset - 1 do
				nxt[#nxt + 1] = octoradio.favs[i]
			end
			netstream.Request('octoradio.getById', nxt):Then(function(data)
				loadStations(math.max(curOffset - 25, 1), data)
			end):Catch(print)
		end
	else octoradio.btnPrev:SetEnabled(false) end

	lst:InvalidateChildren()
end

local function updateTab()
	lst:Clear()
	local tbl = {}
	for i = 1, math.min(25, #octoradio.favs) do
		tbl[i] = octoradio.favs[i]
	end
	netstream.Request('octoradio.getById', tbl):Then(function(data)
		loadStations(1, data)
	end)
end
function octoradio.populateFavorite(pan)
	lst = octoradio.createList(pan)
	updateTab()
end

function octoradio.favAdd(id)
	if not table.HasValue(octoradio.favs, id) then
		octoradio.favs[#octoradio.favs + 1] = id
		updateTab()
		octoradio.favSave()
	end
end

function octoradio.favRemove(id)
	local favID = octoradio.findFavById(id)
	if favID then
		table.remove(octoradio.favs, favID)
		updateTab()
		octoradio.favSave()
	end
end

