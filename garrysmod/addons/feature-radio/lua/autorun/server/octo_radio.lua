octoradio = octoradio or {}

local api = octolib.api({
	url = 'http://radio.garden/api/ara/content',
	headers = {},
})

local updater, q = {}, {}
local refreshPeriod = 24 * 60 * 60

hook.Add('octolib.db.init', 'octoradio', function()
	octolib.db:RunQuery([[
		CREATE TABLE IF NOT EXISTS `dbg_radio` (
			`id` VARCHAR(10) NOT NULL,
			`title` TINYTEXT NOT NULL,
			`placeId` VARCHAR(10) NOT NULL,
			`placeName` TINYTEXT NOT NULL,
			`country` TINYTEXT NOT NULL,
			`playbackUrl` TINYTEXT NOT NULL,
			PRIMARY KEY (`id`)
		)
	]], updater.loadAll)
end)

function updater.loadAll()
	octolib.getDBVar('octoradio', 'updData', {}):Then(function(updData)

		timer.Simple(3, updater.checkUpdating)
		local start = os.time()
		if start - (updData.last or 0) <= refreshPeriod then return end
		octolib.msg('Radio: Begin updating stations')
		updData.last, updData.updating = start, true
		octolib.setDBVar('octoradio', 'updData', updData)

		api:get('/places'):Then(function(res)

			if res and res.data and res.data.data and res.data.data.list then
				local places = res.data.data.list
				local nxt, sz, nextPercent = 1, #places, 0

				octolib.func.loop(function(again)
					if not places[nxt] then
						octolib.msg('Radio: Saving...')
						updater.save():Then(function()
							octolib.msg('Radio: Done! (%ss)', os.time() - start)
							updData.updating = false
							octolib.setDBVar('octoradio', 'updData', updData)
						end):Catch(print)
						return
					end
					nxt = nxt + 1

					local percent = nxt / sz
					if percent >= nextPercent then
						octolib.msg('Radio: Updating stations progress %s%%', math.floor(percent * 100))
						nextPercent = math.floor(percent * 10 + 1) / 10
					end

					updater.loadPlace(places[nxt-1].id, places[nxt-1].title, places[nxt-1].country):Then(again):Catch(print)
				end)

			else
				octolib.msg('Radio: Couldn\'t load radio stations!')
			end

		end)

	end)
end

function updater.checkUpdating()
	octolib.func.loop(function(again)
		octolib.getDBVar('octoradio', 'updData', {}):Then(function(data)
			if data.updating then timer.Simple(3, again)
			else hook.Run('octoradio.updated') end
		end)
	end)
end

function updater.loadPlace(placeId, placeName, country)
	return util.Promise(function(resolve)
		api:get('/page/' .. placeId .. '/channels'):Then(function(res)
			if res and res.data and res.data.data and res.data.data.content and res.data.data.content[1] and res.data.data.content[1].items then
				local stations = res.data.data.content[1].items
				local nxt = 1
				octolib.func.loop(function(again)
					if not stations[nxt] then resolve() return end
					local st = stations[nxt]
					local id = st.href:gsub('.+%/', '')
					if id ~= '' then
						updater.queueStation(id, st.title, placeId, placeName, country, 'http://radio.garden/api/ara/content/listen/' .. id .. '/channel.mp3')
					end
					nxt = nxt + 1
					again()
				end)
			else
				octolib.msg('Radio: No stations found for %s, %s', placeName, country)
				resolve()
			end
		end):Catch(resolve)
	end)
end

function updater.queueStation(...)
	local data = octolib.table.map({...}, function(v)
		return octolib.db:escape(v)
	end)
	q[#q + 1] = ('(\'%s\',\'%s\',\'%s\',\'%s\',\'%s\',\'%s\')'):format(unpack(data))
end

function updater.save()
	return util.Promise(function(resolve, rej)
		octolib.db:RunQuery([[DELETE FROM `dbg_radio` WHERE `id` NOT LIKE '##%']], function()
			local qSize = #q
			local iMax = math.ceil(qSize / 10000)
			for i = 1, iMax do
				local values = table.concat(q, ',', (i-1) * 10000 + 1, math.min(i * 10000, qSize))
				local query = [[REPLACE INTO `dbg_radio` (`id`, `title`, `placeId`, `placeName`, `country`, `playbackUrl`) VALUES ]] .. values
				if i == iMax then
					octolib.db:RunQuery(query, function() resolve() end)
				else
					octolib.db:RunQuery(query)
				end
			end
		end)
	end)
end

octoradio.countries = octoradio.countries or {}
octoradio.places = octoradio.places or {}

hook.Add('octoradio.updated', 'octoradio.getStats', function()
	octolib.db:RunQuery([[SELECT `placeName` AS `place`, country, COUNT(`id`) AS `cnt` FROM `dbg_radio` GROUP BY `placeId`, `placeName`, `country`]], function(q, st, res)
		if not istable(res) then return end
		octoradio.countries, octoradio.places = {}, {}
		for _,v in ipairs(res) do
			local country = v.country
			octoradio.countries[country] = (octoradio.countries[country] or 0) + v.cnt
			local data = octoradio.places[country] or {}
			data[#data + 1] = {place = v.place, cnt = v.cnt}
			octoradio.places[country] = data
		end
		for _,v in pairs(octoradio.places) do
			table.SortByMember(v, 'cnt', false)
		end
		netvars.SetNetVar('octoradio.countries', octoradio.countries)
	end)
end)

-- methods
function octoradio.getById(ids, done)
	if #ids == 0 then return done(ids) end
	local limit = math.min(25, #ids)
	local str = '\'' .. octolib.db:escape(ids[1])
	for i = 2, limit do
		str = str .. '\',\'' .. octolib.db:escape(ids[i])
	end
	str = str .. '\''
	octolib.db:RunQuery([[
		SELECT * FROM `dbg_radio` WHERE `id` IN (]] .. str .. [[) LIMIT ]] .. limit
	, function(q, st, res)
		done(res or {})
	end)
end

function octoradio.search(query, place, country, offset, done)
	offset = math.max(tonumber(offset) or 0, 0)
	query = octolib.db:escape(utf8.sub(string.Trim(query), 1, 128))
	local q = [[SELECT * FROM `dbg_radio` WHERE (`id`='%s' OR `title` LIKE '%%%s%%')]]
	if country then
		q = q .. [[ AND `country`=']] .. octolib.db:escape(country) .. '\''
	end
	if place then
		q = q .. [[ AND `placeName`=']] .. octolib.db:escape(place) .. '\''
	end
	q = q .. [[ LIMIT 25 OFFSET ]] .. offset
	octolib.db:PrepareQuery(string.format(q, query, query), {offset or 0}, function(q, st, res)
		done(res)
	end)
end

function octoradio.getByCountry(country, offset, done)
	local ans, limit = {}, 25
	offset = tonumber(offset) or 0
	if octoradio.places[country] and octoradio.places[country][1 + offset] then -- include places into search results
		local to = math.min(offset + limit, #octoradio.places[country])
		for i = 1 + offset, to do
			offset, limit = offset - 1, limit - 1
			local v = octoradio.places[country][i]
			ans[#ans + 1] = {
				type = 'place',
				name = v.place,
				country = country,
				cnt = v.cnt,
			}
		end
	end
	if limit <= 0 then return done(ans) end
	offset = math.max(offset, 0)
	octolib.db:PrepareQuery([[
		SELECT * FROM `dbg_radio` WHERE `country`=? LIMIT ]] .. limit .. [[ OFFSET ]] .. offset
	, {country}, function(q, st, res)
		if istable(res) then
			for _,v in ipairs(res) do
				ans[#ans + 1] = {
					type = 'station',
					id = v.id,
					name = v.title,
					place = v.placeName,
					country = v.country,
				}
			end
		end
		done(ans)
	end)
end

function octoradio.getByPlace(place, country, offset, done)
	offset = math.max(tonumber(offset) or 0, 0)
	octolib.db:PrepareQuery([[
		SELECT * FROM `dbg_radio` WHERE `placeName`=? AND `country`=? LIMIT 25 OFFSET ]] .. offset, {place, country}, function(q, st, res)
		local ans = {}
		res = istable(res) and res
		if not istable(res) then return done({}) end
		for _,v in ipairs(res) do
			ans[#ans + 1] = {
				type = 'station',
				id = v.id,
				name = v.title,
				place = v.placeName,
				country = v.country,
			}
		end
		done(ans)
	end)
end

function octoradio.top10()
	local count, data = {}, {}
	for _,v in ipairs(ents.FindByClass('ent_dbg_radio')) do
		if not v.curID then continue end
		count[v.curID] = (count[v.curID] or 0) + 1
		data[v.curID] = data[v.curID] or {
			id = v.curID,
			title = v.curTitle,
			place = v.curPlace,
			country = v.curCountry,
		}
	end
	local ans = {}
	for k,v in SortedPairsByValue(count, true) do
		data[k].score = v
		ans[#ans + 1] = data[k]
		if #ans >= 10 then break end
	end
	return ans
end

netstream.Listen('octoradio.getById', function(reply, _, ids)
	if istable(ids) then octoradio.getById(ids, reply) end
end)

netstream.Listen('octoradio.getByCountry', function(reply, _, data)
	if not istable(data) or not isstring(data[1]) or (data[2] and not isnumber(data[2])) then return end
	octoradio.getByCountry(data[1], data[2], reply)
end)

netstream.Listen('octoradio.top10', function(reply)
	reply(octoradio.top10())
end)

netstream.Listen('octoradio.getByPlace', function(reply, _, data)
	if not istable(data) or not isstring(data[1]) or not isstring(data[2]) or (data[3] and not isnumber(data[3])) then return end
	octoradio.getByPlace(data[1], data[2], data[3], reply)
end)

netstream.Listen('octoradio.search', function(reply, _, data)
	if not istable(data)
		or not isstring(data[1])
		or (data[2] and not isstring(data[2]))
		or (data[3] and not isstring(data[3]))
		or (data[4] and not isnumber(data[4]))
	then return end
	octoradio.search(data[1], data[2], data[3], data[4], reply)
end)

netstream.Listen('octoradio.getStations', function(reply, _, ent, page)

	if not (IsValid(ent) and ent:GetClass() == 'ent_dbg_radio' and ent.whitelisted) then return end
	if not (isnumber(page) and octolib.math.inRange(page, 1, math.ceil(#ent.stationsWhitelist / 25))) then return end
	print(ent, page)

	octoradio.getById(octolib.array.page(ent.stationsWhitelist, 25, page), function(stations)
		reply(octolib.table.mapSequential(stations, function(st)
			local allowed, mods = ent:GetStationModifies(st.id)
			if not allowed then return nil end
			if istable(mods) then return table.Merge(st, mods) end
			return st
		end))
	end)

end)

--
-- GAME STUFF
--

local function updateCloseLook(ent, name, desc)
	ent:SetNetVar('dbgLook', {
		name = name or '',
		desc = desc or '',
		time = 1,
	})
end

local function updateRadio(ent)
	netstream.Start(nil, 'dbg-radio.curStUpdate', ent, ent.curID, ent.curTitle, ent.curPlace, ent.curCountry)
end

netstream.Hook('dbg-radio.toggle', function(ply, ent)
	if not IsValid(ent) or ent:GetClass() ~= 'ent_dbg_radio' then return end
	local plyPos = ply:GetShootPos()
	local eee = IsValid(ent:GetParent()) and ent:GetParent() or ent
	if plyPos:DistToSqr(eee:NearestPoint(plyPos)) > CFG.useDistSqr then return end
	if not ent.curURL then return end

	if not ent:GetNetVar('playing') then
		updateCloseLook(ent, ent.curTitle, ent.curID)
		ent:SetStreamURL(ent.curURL)
	else
		updateCloseLook(ent)
		ent:SetStreamURL()
	end
	ent:SetNetVar('playing', not ent:GetNetVar('playing') or nil)
	updateRadio(ent)
end)

netstream.Hook('dbg-radio.soundControl', function(ply, ent, dist, vol)
	if not IsValid(ent) or ent:GetClass() ~= 'ent_dbg_radio' then return end
	local plyPos = ply:GetShootPos()
	local eee = IsValid(ent:GetParent()) and ent:GetParent() or ent
	if plyPos:DistToSqr(eee:NearestPoint(plyPos)) > CFG.useDistSqr then return end

	ent:SetVolume(vol)
	ent:SetDistance(ent.carRadio and 600 or dist)

	updateRadio(ent)
end)

netstream.Hook('dbg-radio.control', function(ply, ent, id)
	if not IsValid(ent) or ent:GetClass() ~= 'ent_dbg_radio' then return end
	local plyPos = ply:GetShootPos()
	local eee = IsValid(ent:GetParent()) and ent:GetParent() or ent
	if plyPos:DistToSqr(eee:NearestPoint(plyPos)) > CFG.useDistSqr then return end
	local allowed, mods = ent:GetStationModifies(id)
	if not allowed then return end

	updateCloseLook(ent)
	if not id or string.Trim(id) == '' then
		ent:SetStreamURL()
		ent:SetNetVar('playing', false)
		updateRadio(ent)
		return
	end

	octoradio.getById({id}, function(ans)
		ans = istable(ans) and ans[1]
		if not istable(ans) or not IsValid(ent) then return end
		if mods then ans = table.Merge(ans, mods) end
		ent:SetStreamURL(ans.playbackUrl)
		ent.curURL = ans.playbackUrl
		ent.curID = ans.id
		ent.curTitle, ent.curPlace, ent.curCountry = ans.title, ans.placeName, ans.country
		updateCloseLook(ent, ans.title or '', ans.id or '')
		ent:SetNetVar('playing', true)
		updateRadio(ent)
	end)
end)

netstream.Hook('dbg-radio.openCar', function(ply)

	local seat = ply:GetVehicle()
	local car = IsValid(seat) and seat:GetParent()
	if not IsValid(car) or not car.GetDriverSeat then return end
	if car:GetDriverSeat() ~= seat and not simfphys.GetSeatProperty(seat, 'hasRadio') then return end

	local r = car.Radio
	if IsValid(r) then
		netstream.Start(ply, 'dbg-radio.control', r, r.whitelisted, r.curID, r.curTitle, r.curPlace, r.curCountry)
	end

end)
