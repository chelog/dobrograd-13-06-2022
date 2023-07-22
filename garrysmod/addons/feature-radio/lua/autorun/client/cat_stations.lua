octoradio = octoradio or {}

local function loadStations(lst, curPage, data)
	if not IsValid(lst) then return end

	for _,v in ipairs(data) do
		lst:AddStation(v.title, v.place, v.country, v.id)
	end

	if #data == 25 then
		octoradio.btnNext:SetEnabled(true)
		function octoradio.btnNext:DoClick()
			lst:Clear()
			netstream.Request('octoradio.getStations', octoradio.ent, curPage + 1):Then(function(data)
				loadStations(lst, curPage + 1, data)
			end):Catch(print)
		end
	else octoradio.btnNext:SetEnabled(false) end

	if curPage > 1 then
		octoradio.btnPrev:SetEnabled(true)
		function octoradio.btnPrev:DoClick()
			lst:Clear()
			netstream.Request('octoradio.getStations', octoradio.ent, curPage - 1):Then(function(data)
				loadStations(lst, curPage - 1, data)
			end):Catch(print)
		end
	else octoradio.btnPrev:SetEnabled(false) end

	lst:InvalidateChildren()
end

function octoradio.populateStations(pan)

	local lst = octoradio.createList(pan)
	netstream.Request('octoradio.getStations', octoradio.ent, 1):Then(function(data)
		loadStations(lst, 1, data)
	end)

end
