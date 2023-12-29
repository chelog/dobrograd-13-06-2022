-- Namespace: octolib

--[[
	Group: dbvars
		Save data between sessions and server restarts

		It is stored in database according to CFG.db.name, so dbvars will
		be synced across servers using same database
]]

hook.Add('octolib.db.init', 'octolib.dbvars', function()

	octolib.db:RunQuery([[
		CREATE TABLE IF NOT EXISTS octolib_vars (
			steamID VARCHAR(30) NOT NULL,
			data TEXT,
				PRIMARY KEY (steamID)
		) ENGINE=INNODB CHARACTER SET utf8 COLLATE utf8_general_ci
	]])

end)

local function save(id, tbl)

	return util.Promise(function(resolve)
		local data = pon.encode(tbl)
		if data then
			octolib.db:PrepareQuery([[
				REPLACE INTO octolib_vars(steamID, data)
				VALUES(?, ?)
			]], { id, data }, resolve)
		end
	end)

end

local asyncSetQueue = octolib.queue.create(function(data, done)
	octolib.db:PrepareQuery([[
		SELECT * FROM octolib_vars
		WHERE steamID = ?
	]], { data.id }, function(q, st, res)
		local res = st and res and res[1]
		local stored = pon.decode(res and res.data or '[}') or {}
		if data.name then
			stored[data.name] = data.val
		else
			stored = data.val
		end

		save(data.id, stored)
			:Finally(function()
				done()
				data.resolve()
			end)
	end)
end)

hook.Add('PlayerInitialSpawn', 'octolib.dbvars', function(ply)

	local steamID = ply:SteamID()
	octolib.db:PrepareQuery([[
		SELECT * FROM octolib_vars
		WHERE steamID = ?
	]], { steamID }, function(q, st, res)
		if not IsValid(ply) then return end
		local res = st and res and res[1]
		if res and res.data then
			local data = pon.decode(res.data) or {}
			ply.dbvars = data
		else
			ply.dbvars = {}
			save(steamID, {})

			-- TODO: put in a hook
			if CFG.webhooks.cheats then
				octoservices:post('/discord/webhook/' .. CFG.webhooks.cheats, {
					username = GetHostName(),
					embeds = {{
						title = 'Первый вход на сервер',
						fields = {{
							name = L.player,
							value = ply:Name() .. '\n[' .. ply:SteamID() .. '](' .. 'https://steamcommunity.com/profiles/' .. ply:SteamID64() .. ')',
						}},
					}},
				})
			end
		end
		hook.Run('octolib.dbvars-loaded', ply)
	end)

end)

--[[
	Function: setDBVar
		Sets DBVar and saves it to database

	Arguments:
		<string> id - Unique object ID to store data under
		<string> name - Property id
		<any> val - value to store in the property
]]
function octolib.setDBVar(id, name, val)

	return util.Promise(function(resolve)
		local ply = player.GetBySteamID(id)
		if IsValid(ply) then
			if name then
				ply:SetDBVar(name, val)
			else
				ply.dbvars = val
				save(ply:SteamID(), ply.dbvars)
			end
			return resolve()
		end

		asyncSetQueue:Add({
			id = id,
			name = name,
			val = val,
			resolve = resolve,
		})
	end)

end

--[[
	Function: getDBVar
		Gets DBVar from database

	Arguments:
		<string> id - Unique object ID
		<string> name = nil - Property id, leave nil if you want to get whole object
		<any> default = nil - Value that will be returned if there's no such entry in database.
										Rejection will not be called if this argument provided.
		<bool> suppressOnline = nil - Update dbvars from database if player is online

	Returns:
		<Promise> (<any>) - Property value or whole data object
]]
function octolib.getDBVar(id, name, default, suppressOnline)

	return util.Promise(function(resolve, reject)
		local ply = player.GetBySteamID(id)
		if IsValid(ply) and not suppressOnline then
			resolve((name and ply:GetDBVar(name)) or (not name and ply.dbvars) or default ~= nil and default or nil)
			return
		end

		octolib.db:PrepareQuery([[
			SELECT * FROM octolib_vars
			WHERE steamID = ?
		]], { id }, function(q, st, res)
			local res = st and res and res[1]
			if res and res.data then
				local data = pon.decode(res.data) or {}
				if suppressOnline and IsValid(ply) then ply.dbvars = data end
				if not name then
					resolve(data)
				elseif data[name] then
					resolve(data[name], data)
				elseif default then
					resolve(default ~= nil and default or nil, data)
				else
					reject('Could not find data under supplied key for this ID')
				end
			elseif default then
				resolve(default)
			else
				reject('Data with this ID not found')
			end
		end)
	end)

end

local Player = FindMetaTable 'Player'

-- Class: Player

--[[
	Function: SetDBVar
		Alias of <octolib.setDBVar> where id is player's SteamID
]]
function Player:SetDBVar(name, val)

	if not name or isfunction(val) then return end

	self.dbvars = self.dbvars or {}

	if self.dbvars[name] == val and not istable(val) then return end
	self.dbvars[name] = val

	save(self:SteamID(), self.dbvars)

end

--[[
	Function: GetDBVar
		Alias of <octolib.getDBVar> where id is player's SteamID, unlike
		original this is syncronous and uses cached data making it preferable
		for player's data retrieval

	Returns:
		<any> - Property value or whole object
]]
function Player:GetDBVar(name, backup)

	return self.dbvars and self.dbvars[name] or backup

end
