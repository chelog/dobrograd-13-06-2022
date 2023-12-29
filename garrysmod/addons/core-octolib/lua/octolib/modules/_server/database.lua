require('mysqloo')

function octolib.reconnectDB()

	octolib.msg('DB: Connecting...')

	local config = CFG.db
	local db = mysqloo.CreateDatabase(config.host, config.user, config.pass, config.main, config.port, config.socket)
	function db:onConnected()
		octolib.msg('DB: Connected.')
		octolib.db = db
		-- octolib.db:RunQuery('SET NAMES utf8')

		timer.Create('octolib.db.heartbeat', 30, 0, function()
			local status = octolib.db:status()
			if status ~= mysqloo.DATABASE_CONNECTED and status ~= mysqloo.DATABASE_CONNECTED then
				octolib.reconnectDB()
				timer.Remove('octolib.db.heartbeat')
			end
		end)
		hook.Run('octolib.db.init', db)
	end

	function db:onConnectionFailed(data)
		octolib.msg('DB: Connection failed: ')
		print(data)

		octolib.msg('DB: Reconnecting in 30 seconds...')
		timer.Simple(30, octolib.reconnectDB)

		timer.Remove('octolib.db.heartbeat')
	end

end
octolib.reconnectDB()

hook.Add('octolib.db.init', 'octolib.db.tick', function()

	octolib.db:RunQuery([[
		CREATE TABLE IF NOT EXISTS ]] .. CFG.db.main .. [[.octolib_queue (
		serverID VARCHAR(30) NOT NULL,
		event VARCHAR(30) NOT NULL,
		data TEXT
	) ENGINE=INNODB CHARACTER SET utf8 COLLATE utf8_general_ci
	]])

end)

--
-- DB SOCKET (kinda)
--

function octolib.sendCmd(serverID, event, data)

	octolib.db:PrepareQuery('insert into ' .. CFG.db.main .. '.octolib_queue(serverID, event, data) values(?, ?, ?)', { serverID, event, util.TableToJSON(data or {}) })

end

local servers = CFG.serversList or {'dbg', 'dbg2'}
function octolib.sendCmdToOthers(event, data)
	for _,serverID in ipairs(servers) do
		if serverID ~= CFG.serverID then
			octolib.sendCmd(serverID, event, data)
		end
	end
end

if CFG.dbTick then
	timer.Create('octolib.db.tick', CFG.dbTickTime, 0, function()
		if not octolib.db or octolib.db:status() ~= mysqloo.DATABASE_CONNECTED then return end
		octolib.db:PrepareQuery('select event, data from ' .. CFG.db.main .. '.octolib_queue where serverID = ?', { CFG.serverID }, function(q, st, res)
			if st and istable(res) then
				if #res > 0 then
					for i, v in ipairs(res) do
						if v.event then
							hook.Run('octolib.event:' .. v.event, isstring(v.data) and util.JSONToTable(v.data) or {})
							if CFG.dev then
								octolib.dmsg('DB hook: ' .. v.event)
							end
						end
					end
					octolib.db:PrepareQuery('delete from ' .. CFG.db.main .. '.octolib_queue where serverID = ?', { CFG.serverID })
				end
			else
				ErrorNoHalt('DB ERROR: ' .. res)
			end
		end)
	end)
end
