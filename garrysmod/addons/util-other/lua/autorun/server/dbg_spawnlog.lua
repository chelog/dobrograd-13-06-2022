hook.Add('octolib.db.init', 'dbg-spawnlog', function()
	octolib.db:RunQuery([[CREATE TABLE IF NOT EXISTS spawn_log (
		model VARCHAR(255) NOT NULL,
		spawned INT NOT NULL DEFAULT 1,
		PRIMARY KEY (model)
	)]])
end)

local cache = {}
timer.Create('dbg-spawnlog.flush', 5, 0, function()
	if not table.IsEmpty(cache) then
		local str = table.concat(octolib.table.mapSequential(cache, function(amount, mdl)
			return '(\'' .. octolib.db:escape(mdl) .. '\',' .. amount .. ')'
		end), ',')
		octolib.db:RunQuery([[INSERT INTO spawn_log (model, spawned) VALUES ]] .. str .. [[ ON DUPLICATE KEY UPDATE spawned = spawned + VALUES(spawned)]])
		table.Empty(cache)
	end
end)

local function updateCount(_, mdl)
	cache[mdl] = (cache[mdl] or 0) + 1
end

hook.Add('PlayerSpawnedProp', 'dbg-spawnlog', updateCount)
hook.Add('PlayerSpawnedEffect', 'dbg-spawnlog', updateCount)
hook.Add('PlayerSpawnedRagdoll', 'dbg-spawnlog', updateCount)
