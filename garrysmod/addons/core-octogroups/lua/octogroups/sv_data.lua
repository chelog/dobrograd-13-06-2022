-- initialize function
function og.init()

	octolib.db:RunQuery([[
		CREATE TABLE IF NOT EXISTS octogroups (
			id VARCHAR(32) NOT NULL,
			data TEXT,
				PRIMARY KEY (id)
		) ENGINE=INNODB CHARACTER SET utf8 COLLATE utf8_general_ci
	]], og.reloadFromDB)

end
hook.Add('octolib.db.init', 'octogroups', og.init)

--
-- DATA
--

local function save(gID)

	local g = og.groups[gID]
	if not g then return end

	local data = table.Copy(g)
	data.id = nil

	-- save to DB
	octolib.db:PrepareQuery('update octogroups set data = ? where id = ?', { pon.encode(data), gID })

	-- send to clients
	netstream.Start(nil, 'og.sync', gID, og.publicData(g))

	for sID, m in pairs(g.members) do
		local ply = player.GetBySteamID(sID)
		if IsValid(ply) then
			og.reloadPlayer(ply)
		end
	end

end

-- save in think so we debounce it to only once per frame
local toSave = {}
hook.Add('Think', 'octogroups-save', function()

	for gID, _ in pairs(toSave) do
		save(gID)
		toSave[gID] = nil	
	end

end)

--[[ API: save group data to database ]]
function og.save(gID)

	toSave[gID] = true

end

local loaded = false
--[[ API: force groups to reload cache from database ]]
function og.reloadFromDB(callback)

	octolib.db:RunQuery('select * from octogroups', function(q, st, res)
		table.Empty(og.groups)
		
		for i, row in ipairs(res) do
			local g = pon.decode(row.data)
			g.id = row.id
			og.importGroup(g)
		end
		
		for i, ply in ipairs(player.GetAll()) do
			og.reloadPlayer(ply)
		end

		if not loaded then
			loaded = true
			hook.Run('og.init')
		end

		if isfunction(callback) then callback() end
	end)

end

--
-- HOOKS
--

hook.Add('PlayerFinishedLoading', 'og.syncInitial', function(ply)

	local toSend = {}
	for gID, g in pairs(og.groups) do
		toSend[gID] = og.publicData(g)
	end

	netstream.Start(ply, 'og.sync', nil, toSend)

end)
