hook.Add('octolib.db.init', 'octolib.config', function()
	octolib.db:RunQuery([[
		CREATE TABLE IF NOT EXISTS octolib_config (
			id VARCHAR(255) NOT NULL,
			value TEXT,
				PRIMARY KEY (id)
		) ENGINE=INNODB CHARACTER SET utf8 COLLATE utf8_general_ci
	]])
end)

function octolib.config.getDatabaseValue(id, callback)
	octolib.db:PrepareQuery('select from octolib_config where id = ?', { id }, function(q, st, rows)
		callback(rows[1] and rows[1].value or nil)
	end)
end

function octolib.config.setDatabaseValue(id, value, callback)
	octolib.db:PrepareQuery('update octolib_config set value = ? where id = ?', { value, id }, callback and function(q, st)
		callback(st and q:affectedRows() > 0)
	end)
end
