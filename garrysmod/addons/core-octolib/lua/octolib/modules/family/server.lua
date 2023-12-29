octolib.family = octolib.family or {}

hook.Add('octolib.db.init', 'octolib.family', function()
	octolib.db:RunQuery([[
		CREATE TABLE IF NOT EXISTS ]] .. CFG.db.shop .. [[.octolib_family (
			id INT NOT NULL AUTO_INCREMENT,
			steamids TEXT,
			hwids TEXT,
				PRIMARY KEY (id)
		)
	]])
end)

local function isValidHwid(hwid)
	local t, id = unpack(string.Split(hwid, ':'))
	return id and #id == 32
end

local function familyFromRow(row)
	if not row then return end
	return {
		id = row.id,
		hwids = row.hwids:Split(','),
		steamids = row.steamids:Split(','),
	}
end

local function saveFamily(family, callback)
	family.hwids = octolib.array.filter(family.hwids, isValidHwid)

	-- remove duplicates
	family.steamids = table.GetKeys(octolib.array.toKeys(family.steamids))
	family.hwids = table.GetKeys(octolib.array.toKeys(family.hwids))

	octolib.db:PrepareQuery('update ' .. CFG.db.shop .. '.octolib_family set steamids = ?, hwids = ? where id = ?', {
		table.concat(family.steamids, ','),
		table.concat(family.hwids, ','),
		family.id,
	}, function()
		callback(family)
	end)
end

function octolib.family.getBySteamID(steamID64, callback)
	if octolib.string.isSteamID(steamID64) then
		steamID64 = util.SteamIDTo64(steamID64)
	end

	octolib.db:RunQuery('select * from ' .. CFG.db.shop .. '.octolib_family where steamids like \'%' .. octolib.db:escape(steamID64) .. '%\'', function(q, st, rows)
		callback(familyFromRow(rows[1]))
	end)
end

function octolib.family.getByHwid(hwid, callback)
	octolib.db:RunQuery('select * from ' .. CFG.db.shop .. '.octolib_family where hwids like \'%' .. octolib.db:escape(hwid) .. '%\'', function(q, st, rows)
		callback(familyFromRow(rows[1]))
	end)
end

function octolib.family.merge(fID1, fID2, callback)
	if fID1 == fID2 then return callback() end

	octolib.func.chain({
		function(done)
			octolib.db:PrepareQuery('select * from ' .. CFG.db.shop .. '.octolib_family where id in (?, ?)', { fID1, fID2 }, done)
		end,
		function(done, q, st, rows)
			local family1 = familyFromRow(rows[1])
			local family2 = familyFromRow(rows[2])
			if not family1 or not family2 then return end

			-- indexes could be swapped during query and we want family 1 to persist
			if family1.id == fID2 then
				family1, family2 = family2, family1
			end

			table.Add(family1.hwids, family2.hwids)
			table.Add(family1.steamids, family2.steamids)

			octolib.db:PrepareQuery('delete from ' .. CFG.db.shop .. '.octolib_family where id = ?', { family2.id })
			saveFamily(family1, callback)
		end,
	})
end

function octolib.family.storeHwids(steamID64, hwids, callback)
	if octolib.string.isSteamID(steamID64) then
		steamID64 = util.SteamIDTo64(steamID64)
	end

	hwids = octolib.array.filter(hwids, isValidHwid)

	octolib.func.chain({
		function(done)
			octolib.family.getBySteamID(steamID64, function(family)
				if family then
					return done(family)
				end

				-- create new family if this steamid doesn't belong to any
				octolib.db:PrepareQuery('insert into ' .. CFG.db.shop .. '.octolib_family(steamids, hwids) values(?, ?)', {
					steamID64,
					table.concat(hwids, ','),
				}, function(q)
					local family = {
						id = q:lastInsert(),
						steamids = { steamID64 },
						hwids = hwids,
					}

					hook.Run('octolib.family.created', family)
					done(family)
				end)
			end)
		end,
		function(done, family)
			-- get all families with given hwids
			local where = table.concat(octolib.array.map(hwids, function(hwid)
				return 'hwids like \'%' .. octolib.db:escape(hwid) .. '%\''
			end), ' or ')

			octolib.db:RunQuery('select * from ' .. CFG.db.shop .. '.octolib_family where ' .. where, function(q, st, rows)
				local families = { family } -- first family is always the given steamid's one
				table.Add(families, octolib.array.map(rows, familyFromRow))

				done(families)
			end)
		end,
		function(done, families)
			local mainFamily = table.remove(families, 1)
			if not mainFamily then
				-- should be created in first step anyway but who knows
				error('error while storing hwids?!')
			end

			-- check if we have new hwids against main family
			local newHwids = {}
			for _, hwid in ipairs(hwids) do
				if not table.HasValue(mainFamily.hwids, hwid) then
					while #mainFamily.hwids >= 100 do
						table.remove(mainFamily.hwids, 1)
					end
					table.insert(newHwids, hwid)
				end
			end
			if #newHwids > 0 then
				hook.Run('octolib.family.newHwids', mainFamily, newHwids)
				table.Add(mainFamily.hwids, newHwids)
			end

			-- merge families one by one
			local funcs = octolib.array.map(families, function(family)
				return function(done)
					octolib.family.merge(mainFamily.id, family.id, done)
				end
			end)

			if #newHwids > 0 then
				-- save main family before merging others
				table.insert(funcs, 1, function(done)
					saveFamily(mainFamily, done)
				end)
			end

			local newFamilies = octolib.array.filter(families, function(family)
				return family.id ~= mainFamily.id
			end)
			if #newFamilies > 0 then
				hook.Run('octolib.family.mergedByHwid', table.Add({ mainFamily }, newFamilies))
			end

			table.insert(funcs, callback)
			octolib.func.chain(funcs)
		end,
	})
end
