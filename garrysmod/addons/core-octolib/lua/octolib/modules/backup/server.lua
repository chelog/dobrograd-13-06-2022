if CFG.disabledModules.backup then return end

octolib.linkedCache = octolib.linkedCache or {}
local cache = octolib.linkedCache
local cleanupAfter = CFG.backupCleanupAfter
local period = CFG.backupPeriod
local pruneTime = CFG.backupPruneTime

function octolib.getLinkedEnts(sID, classes)

	local owned = {}
	if classes then
		local classesKeyed = octolib.array.toKeys(classes)
		for ent, steamID in pairs(cache) do
			if sID == steamID and IsValid(ent) and classesKeyed[ent:GetClass()] then
				table.insert(owned, ent)
			end
		end
	else
		for ent, steamID in pairs(cache) do
			if sID == steamID then
				table.insert(owned, ent)
			end
		end
	end

	return owned

end

local registeredClasses = {}
function octolib.registerBackupClass(class, save, load)

	if save and load then
		registeredClasses[class] = {save, load}
	else
		registeredClasses[class] = nil
	end

end

local registeredMods = {}
function octolib.registerBackupMod(mod, save, load)

	if save and load then
		registeredMods[mod] = {save, load}
	else
		registeredMods[mod] = nil
	end

end

local pendingBackup = {}
function octolib.restoreBackup(ply)

	local stored = pendingBackup[ply:SteamID()]
	if not stored then return end

	for id, data in pairs(stored) do
		local load = registeredMods[id] and registeredMods[id][2]
		if load then load(ply, data) end
	end

	if stored.e then
		for _, entData in ipairs(stored.e) do
			local handler = registeredClasses[entData.c]
			if handler then
				local ent = ents.Create(entData.c)
				ent:SetPos(entData.p)
				ent:SetAngles(entData.a)
				cache[ent] = steamID

				handler[2](ent, ply, entData.d)
				ent:Spawn()
				ent:LinkPlayer(ply)

				local phys = ent:GetPhysicsObject()
				if IsValid(phys) then
					phys:Wake()
				end

				octolib.msg('Restored %s for %s', entData.c, ply:SteamID())
			end
		end
	end

	ply:Notify('ooc', L.pendingbackup)
	pendingBackup[ply:SteamID()] = nil

end

function octolib.getPlayerOnline(steamID, callback)

	octolib.db:PrepareQuery('select * from octolib_players where steamID = ?', { steamID }, function(q, st, rows)
		local row = st and rows[1]
		if not istable(row) then return callback(false) end

		local data = pon.decode(row.data)
		callback(row.serverID, data)
	end)

end

---------------------------------------
-- TIMERS
---------------------------------------

local curPlayerID, curPlayer = 0
local function increaseCounter()

	curPlayerID = curPlayerID + 1
	if curPlayerID > game.MaxPlayers() then curPlayerID = 1 end
	curPlayer = Entity(curPlayerID)

end

timer.Create('octolib.backup.save', 10, 0, function()

	if player.GetCount() < 1 then return end

	while not IsValid(curPlayer) do
		increaseCounter()
	end

	if curPlayer.SaveInventory then curPlayer:SaveInventory(true) end
	increaseCounter()

end)

function octolib.backupNow()

	if player.GetCount() < 1 then return end

	local toUpdate = {}

	octolib.func.throttle(octolib.table.toKeyVal(cache), 10, 0.2, function(data)
		local ent, steamID = data[1], data[2]
		if not IsValid(ent) then
			cache[ent] = nil
			return
		end

		local class = ent:GetClass()
		if not registeredClasses[class] then return end

		local data = registeredClasses[class][1](ent)
		if not data then return end

		toUpdate[steamID] = toUpdate[steamID] or {e = {}}

		local pos = ent:GetPos()
		pos.x = math.floor(pos.x)
		pos.y = math.floor(pos.y)
		pos.z = math.floor(pos.z)

		local ang = ent:GetAngles()
		ang.p = math.floor(ang.p)
		ang.y = math.floor(ang.y)
		ang.r = math.floor(ang.r)

		local entities = toUpdate[steamID].e
		entities[#entities + 1] = { c = class, p = pos, a = ang, d = data }
	end):Then(function()
		return octolib.func.throttle(player.GetAll(), 10, 0.2, function(ply)
			local steamID = ply:SteamID()
			toUpdate[steamID] = toUpdate[steamID] or {}
			for id, handler in pairs(registeredMods) do
				toUpdate[steamID][id] = handler[1](ply)
			end
		end)
	end):Then(function()
		for steamID, data in pairs(toUpdate) do
			data = pon.encode(data)
			octolib.db:PrepareQuery([[
				insert into octolib_players(steamID, serverID, data) values (?, ?, ?)
				on duplicate key update serverID = values(serverID), data = values(data)
			]], {
				steamID, CFG.serverID, data
			})
		end

		octolib.msg('Entities backed up.')
	end)

end
timer.Create('octolib.backup.backup', period, 0, octolib.backupNow)

---------------------------------------
-- HOOKS
---------------------------------------

hook.Add('EntityRemoved', 'octolib.backup', function(ent)
	cache[ent] = nil
end)

hook.Add('PlayerDisconnected', 'octolib.backup', function(ply)

	local sID = ply:SteamID()
	local toRemove = octolib.getLinkedEnts(sID)

	octolib.db:PrepareQuery('delete from octolib_players where serverID = ? and steamID = ?', { CFG.serverID, sID })

	timer.Create('octolib.backup' .. sID, cleanupAfter, 1, function()
		for _, ent in ipairs(toRemove) do
			if IsValid(ent) and cache[ent] == sID then
				ent:Remove()
				cache[ent] = nil
			end
		end
		octolib.msg('Cleaned up entities of %s', sID)
	end)

end)

hook.Add('PlayerInitialSpawn', 'octolib.backup', function(ply)

	local sID = ply:SteamID()
	local tname = 'octolib.backup' .. sID
	if timer.Exists(tname) then
		timer.Remove(tname)
		octolib.msg('Player is back! Aborting removal for %s', sID)
		for ent, steamID in pairs(cache) do
			if IsValid(ent) and sID == steamID then
				ent:LinkPlayer(ply)
				if ent.owner then ent.owner = ply end
				if ent.SetPlayer then ent:SetPlayer(ply) end
			end
		end
	end

	octolib.db:PrepareQuery('replace into octolib_players(steamID, serverID, data) values(?, ?, \'[}\')', { ply:SteamID(), CFG.serverID })

end)

hook.Add('octolib.db.init', 'octolib.backup', function()

	octolib.func.chain({
		function(next)
			octolib.db:RunQuery([[
				CREATE TABLE IF NOT EXISTS octolib_players (
					steamID VARCHAR(30) NOT NULL,
					serverID VARCHAR(30) NOT NULL,
					data TEXT,
						PRIMARY KEY (steamID)
				) ENGINE=INNODB CHARACTER SET utf8 COLLATE utf8_general_ci
			]], next)
		end,
		function(next)
			octolib.db:PrepareQuery('select * from octolib_players where serverID = ?', { CFG.serverID }, next)
		end,
		function(next, _, _, data)
			for _, row in ipairs(data) do pendingBackup[row.steamID] = pon.decode(row.data) end
			octolib.db:PrepareQuery('delete from octolib_players where serverID = ?', { CFG.serverID })
			timer.Simple(pruneTime, next)
		end,
		function()
			table.Empty(pendingBackup)
		end,
	})

end)

gameevent.Listen('player_disconnect')
hook.Add('player_disconnect', 'octolib.backup', function(data)

	local sID
	if octolib.string.isSteamID(data.networkid) then
		sID = data.networkid
	elseif (data.networkid:find('^7656119%d+$')) then
		sID = util.SteamIDFrom64(data.networkid)
	else
		return
	end

	octolib.db:PrepareQuery('delete from octolib_players where serverID = ? and steamID = ?', { CFG.serverID, sID })
end)

---------------------------------------
-- META
---------------------------------------

local entMeta = FindMetaTable 'Entity'
function entMeta:LinkPlayer(ply)

	if not IsValid(ply) or not IsValid(self) then cache[self] = nil return end
	cache[self] = ply:SteamID()

end

local plyMeta = FindMetaTable 'Player'
function plyMeta:LinkEntity(ent)

	if not IsValid(ent) then cache[ent] = nil return end
	cache[ent] = self:SteamID()

end

---------------------------------------
-- CONFIG
---------------------------------------

local fs, _ = file.Find('config/octolib-backup/*.lua', 'LUA')
for _, f in pairs(fs) do
	fname = 'config/octolib-backup/' .. f
	include(fname)
end
