dbgEstates  = dbgEstates or {}
dbgEstates.data = dbgEstates.data or {}
local empty = {}
local toRem = {}

local radius, limit = 5, 15
local sides = { Vector(1,0,0), Vector(-1,0,0), Vector(0,1,0), Vector(0,-1,0), Vector(0,0,1), Vector(0,0,-1) }
local function getDoorPos(ent)
	local entPos = ent:GetPos()
	if table.HasValue(ents.FindInSphere(entPos, radius), ent) then return entPos end

	for i = 0, limit do
		local delta = radius * 2 * i
		for _, side in ipairs(sides) do
			pos = entPos + side * delta
			if table.HasValue(ents.FindInSphere(pos, radius), ent) then return pos end
		end
	end
end

local function nextAvailable()
	local nxt, estIdx = 1
	while not estIdx do
		estIdx = not dbgEstates.data[nxt] and nxt or nil
		nxt = nxt + 1
	end
	return estIdx
end

local planDBUpdate = octolib.func.debounce(function()
	local all = {}
	for _,v in ipairs(toRem) do
		all[#all + 1] = v
	end
	table.Empty(toRem)
	for k,v in pairs(dbgEstates.data) do
		local tbl = table.Copy(v)
		tbl.owners = {}
		tbl.doors = {}
		for _,owner in ipairs(v.owners or {}) do
			if not octolib.string.isSteamID(owner) then
				tbl.owners[#tbl.owners + 1] = owner
			end
		end
		for _,door in ipairs(v.doors or {}) do
			tbl.doors[#tbl.doors + 1] = {
				getDoorPos(door) or door:MapCreationID(),
				door.title,
			}
		end
		all[#all + 1] = {k, tbl}
	end
	octolib.func.throttle(all, 5, 0.5, function(nxt)
		if isnumber(nxt) then
			octolib.db:PrepareQuery([[DELETE FROM `dbg_estates` WHERE `id`=?]], {nxt})
		else
			local k, v = unpack(nxt)
			local dat = pon.encode(v or {})
			octolib.db:PrepareQuery([[INSERT INTO `dbg_estates` (`id`, `map`, `data`) VALUES (?,?,?) ON DUPLICATE KEY UPDATE `data`=?]],
				{k, game.GetMap(), dat, dat})
		end
	end)
end, 0)

local updateNW = octolib.func.debounce(function()
	netvars.SetNetVar('dbg-estates', dbgEstates.data)
end, 0)

-- unlinks the door from estates
local function removeFromPreviousEstate(door)
	local curEst = door:GetNetVar('estate')
	if curEst and dbgEstates.data[curEst] and dbgEstates.data[curEst].doors then
		table.RemoveByValue(dbgEstates.data[curEst].doors, door)
		if not dbgEstates.data[curEst].doors[1] then
			dbgEstates.data[curEst] = nil
			toRem[#toRem + 1] = curEst
			updateNW()
			planDBUpdate()
		end
	end
	door:SetNetVar('estate')
end

--[[
	(void)
	Sets specified price for estate and saves it
]]
function dbgEstates.setEstatePrice(estIdx, price)
	if not isnumber(price) or price < 0 then return end
	if not dbgEstates.data[estIdx] then return end
	dbgEstates.data[estIdx].price = price
	updateNW()
	planDBUpdate()
end

--[[
	(void)
	Sets estate purpose of estate and saves it
	0 - both business and residency
	1 - business only
	2 - residency only
]]
function dbgEstates.setPurpose(estIdx, purpose)
	if not purpose then purpose = 0 end
	if not (isnumber(purpose) and octolib.math.inRange(purpose, 0, 2)) then return end
	if not dbgEstates.data[estIdx] then return end
	if purpose == 0 then
		dbgEstates.data[estIdx].purpose = nil
	else
		dbgEstates.data[estIdx].purpose = purpose
	end
	updateNW()
	planDBUpdate()
end

--[[
	(void)
	Sets marker position for estate and saves it
]]
function dbgEstates.updateMarker(estIdx, pos)
	if pos ~= nil and not istable(pos) then return end
	if not dbgEstates.data[estIdx] then return end
	dbgEstates.data[estIdx].marker = pos
	updateNW()
	planDBUpdate()
end

--[[
	(table)
	Returns estate's data,
	or empty table if doesn't exist.
	You should NOT modify this!
]]
function dbgEstates.getData(estIdx)
	return dbgEstates.data[estIdx] or empty
end

--[[
	(bool)
	Returns wether estate with this id exists
]]
function dbgEstates.exists(estIdx)
	return dbgEstates.data[estIdx] ~= nil
end

--[[
	(void)
	Forces something to own an estate.
	Can be:
	'STEAM_X:Y:Z' for player (removes any current SteamID owners)
	'g:command' for organization (e.g. police)
	'j:command' for job (e.g. mayor)
]]
function dbgEstates.addOwner(estIdx, owner)
	if not estIdx or not dbgEstates.data[estIdx] then return end
	dbgEstates.data[estIdx].owners = dbgEstates.data[estIdx].owners or {}

	local owners = dbgEstates.data[estIdx].owners
	if table.HasValue(owners, owner) then return false end

	local isPly = octolib.string.isSteamID(owner)
	if isPly then -- there can be only one player owner
		for i = #owners, 1, -1 do
			if octolib.string.isSteamID(owners[i]) then
				table.remove(owners, i)
			end
		end
	end

	owners[#owners + 1] = owner
	updateNW()
	if not isPly then planDBUpdate() end

	return true
end

--[[
	(bool)
	Forces something to unown an estate.
	Can be:
	'STEAM_X:Y:Z' for player (removes any current SteamID owners)
	'g:command' for organization (e.g. police)
	'j:command' for job (e.g. mayor)
]]
function dbgEstates.removeOwner(estIdx, owner)
	if not estIdx or not dbgEstates.data[estIdx] then return end
	dbgEstates.data[estIdx].owners = dbgEstates.data[estIdx].owners or {}

	local owns = dbgEstates.data[estIdx].owners
	local removed = table.RemoveByValue(owns, owner)
	if removed then
		if not octolib.string.isSteamID(owner) then
			planDBUpdate()
		else
			for _,v in ipairs(dbgEstates.data[estIdx].doors or empty) do
				v:SetNetVar('tempTitle', v.title)
				v:DoLock()
			end
		end
		updateNW()
	end

	return tobool(removed)
end

--[[
	(void)
	Changes owners of an estate.
	Please use it only if you know what you do!
]]
function dbgEstates.updateOwners(estIdx, owners)
	if (owners ~= nil and not istable(owners)) or not estIdx or not dbgEstates.data[estIdx] then return end
	dbgEstates.data[estIdx].owners = owners or {}
	planDBUpdate()
	updateNW()
end

--[[
	(void)
	Saves everything to database
]]
function dbgEstates.planDBUpdate()
	planDBUpdate()
end

--[[
	(bool)
	Links door to a new estate
]]
function dbgEstates.linkDoor(door, estIdx)
	if not IsEntity(door) or not door:IsDoor() then return end
	if not dbgEstates.exists(estIdx) then return end
	dbgEstates.data[estIdx].doors = dbgEstates.data[estIdx].doors or {}
	dbgEstates.data[estIdx].doors[#dbgEstates.data[estIdx].doors + 1] = door
	door:SetNetVar('estate', estIdx)
	if not dbgEstates.data[estIdx].owners[1] then
		door:DoLock()
	end
	updateNW()
	planDBUpdate()
	return true
end

--[[
	(void)
	Removes a door from any estates so that
	it can't be owned by anyone.
]]
function dbgEstates.unlinkDoor(door)
	if not IsEntity(door) or not door:IsDoor() then return end
	removeFromPreviousEstate(door)
	door:DoUnlock()
	if door.title then -- we want to save title so we move it to a zero estate
		dbgEstates.data[0] = dbgEstates.data[0] or {
			doors = {},
			price = 0,
			owners = {},
			name = 'Заблокированные',
		}
		dbgEstates.linkDoor(door, 0)
	else
		updateNW()
		planDBUpdate()
	end
end

--[[
	(int)
	Moves door to a new estate with only this door
	and returns ID of the new estate.
]]
function dbgEstates.createEstate(door, name)
	if not IsEntity(door) or not door:IsDoor() then return end
	removeFromPreviousEstate(door)
	local estIdx = nextAvailable()
	dbgEstates.data[estIdx] = {
		doors = {door},
		price = GAMEMODE.Config.doorcost or 50,
		owners = {},
		name = tostring(name),
	}
	door:SetNetVar('estate', estIdx)
	door:DoLock()
	updateNW()
	planDBUpdate()
	return estIdx
end

function dbgEstates.getNearest(pos)
	local nearest = math.huge
	local nearestid = 0

	for i, est in pairs(dbgEstates.data) do
		for id, ent in pairs(est.doors) do
			if not IsValid(ent) then continue end
			local dis = ent:GetPos():DistToSqr(pos)
			if dis < nearest then
				nearest = dis
				nearestid = i
			end
		end
	end
	return dbgEstates.data[nearestid]
end

hook.Add('octolib.db.init', 'dbg-premises.init', function()

	octolib.db:RunQuery([[CREATE TABLE IF NOT EXISTS `dbg_estates` (
		`id` INT UNSIGNED NOT NULL,
		`map` VARCHAR(50) NOT NULL,
		`data` TEXT NULL,
		PRIMARY KEY (`id`, `map`)
	)]])

	dbgEstates.data = {}
	octolib.db:PrepareQuery([[SELECT * FROM `dbg_estates` WHERE `map`=?]], {game.GetMap()}, function(q, st, res)
		if not istable(res) or not res[1] then return end
		for _,v in ipairs(res) do
			local dat = pon.decode(v.data or '[}') or {}
			if dat.doors then
				for i = 1, #dat.doors do
					local ent
					local posOrID = dat.doors[i][1]
					if isnumber(posOrID) then
						-- ent = ents.GetMapCreatedEntity(posOrID)
					else
						for _, e in ipairs(ents.FindInSphere(dat.doors[i][1], radius)) do
							if IsValid(e) and e:IsDoor() then ent = e break end
						end
					end

					local title = dat.doors[i][2]
					dat.doors[i] = ent
					if not ent then continue end

					ent:SetNetVar('estate', v.id)
					ent.title = title
					ent:SetNetVar('tempTitle', title)
					ent:DoLock()
				end
			end
			dbgEstates.data[v.id] = dat
		end
		updateNW()
	end)

end)
