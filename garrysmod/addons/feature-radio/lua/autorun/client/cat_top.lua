octoradio = octoradio or {}

local api = octolib.api({
	url = 'http://radio.garden/api/ara/content',
	headers = {},
})

function octoradio.populateTop(pan)

	local lst = octoradio.createList(pan)
	netstream.Request('octoradio.top10'):Then(function(data)
		if not IsValid(lst) then return end
		local added = {}
		for _,v in ipairs(data) do
			lst:AddStation(v.title, v.place, v.country, v.id):SetColumnText(3, tostring(v.score))
			added[v.id] = true
		end
		api:get('/static-pages/our-favorites'):Then(function(res)
			if not IsValid(lst) or not res or not res.data or not res.data.data or not res.data.data.content then return end
			for _,resLst in ipairs(res.data.data.content) do
				if resLst.itemsType == 'channel' then
					for _,item in ipairs(resLst.items) do
						local id = item.href:gsub('.+%/', '')
						if not added[id] then
							lst:AddStation(item.title, item.subtitle:gsub(', .+', ''), item.subtitle:gsub('.+, ', ''), id)
							added[id] = true
						end
					end
				end
			end
		end)
	end):Catch(print)

end
