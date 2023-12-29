local cache = {}

local function getResults(tbl)
	return octolib.table.map(tbl, function(id) return cache[id] end)
end

function octolib.getSteamData(tbl, callback)

	local toFetch = octolib.array.filter(tbl, function(id) return not cache[id] end)
	if #toFetch < 1 then return callback(getResults(tbl)) end

	octoservices:get('/steam/user/' .. table.concat(toFetch, ',')):Then(function(res)
		if res.data then
			if toFetch[2] then
				for _, info in ipairs(res.data) do
					cache[info.steamid64] = info
				end
			else cache[res.data.steamid64] = res.data end
		end
		callback(getResults(tbl))
	end):Catch(function(err)
		octolib.msg('Error getting Steam data: %s', err)
	end)

end
