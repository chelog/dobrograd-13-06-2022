if CFG.disabledModules.ptime then return end

local vars = {
	sessionStart = 'pt.sessionStart',
	here = {
		nv = 'pt.here',
		db = 'pt_' .. CFG.serverID,
	},
	total = {
		nv = 'pt.total',
		db = 'pt',
	},
}

local hasOldData = sql.TableExists('utime')
local function tryMigrate(ply)

	if not hasOldData or not IsValid(ply) then return end

	local sid = ply:SteamID()
	local row = sql.QueryRow('SELECT totaltime FROM utime WHERE steamid=\'' .. sid .. '\';')
	if not row then return end

	local old = tonumber(row.totaltime) or 0
	ply:SetNetVar(vars.here.nv, old)
	ply:SetDBVar(vars.here.db, old)

	local total = ply:GetNetVar(vars.total.nv)
	if old > total then
		ply:SetNetVar(vars.total.nv, old)
		ply:SetDBVar(vars.total.db, old)
	end

	sql.Query('DELETE FROM utime WHERE steamid=\'' .. sid .. '\';')

end

hook.Add('octolib.dbvars-loaded', 'play-time', function(ply)

	ply:SetNetVar(vars.total.nv, ply:GetDBVar(vars.total.db, 0))
	ply:SetNetVar(vars.here.nv, ply:GetDBVar(vars.here.db, 0))

	tryMigrate(ply)

	if not ply:IsAFK() then
		ply:SetNetVar(vars.sessionStart, CurTime())
	end

end)

hook.Add('PlayerDisconnected', 'play-time', function(ply)

	ply:SaveTime()

end)

hook.Add('octolib.afk.changed', 'play-time', function(ply, afk)

	if afk then
		ply:SaveTime()
		ply:SetNetVar(vars.sessionStart, nil)
	else
		ply:SetNetVar(vars.sessionStart, CurTime())
	end

end)

local pmeta = FindMetaTable('Player')

function pmeta:SaveTime()

	local ct = CurTime()
	local diff = ct - self:GetNetVar(vars.sessionStart, ct)
	if diff <= 0 then return end

	local time = self:GetNetVar(vars.total.nv, 0) + diff
	self:SetDBVar(vars.total.db, time)
	self:SetNetVar(vars.total.nv, time)

	time = self:GetNetVar(vars.here.nv, 0) + diff
	self:SetDBVar(vars.here.db, time)
	self:SetNetVar(vars.here.nv, time)

	self:SetNetVar(vars.sessionStart, ct)

end

function pmeta:SetTimeTotal(val)

	self:SetNetVar(vars.total.nv, val)
	self:SetDBVar(vars.total.db, val)

end

function pmeta:SetTimeHere(val)

	self:SetNetVar(vars.here.nv, val)
	self:SetDBVar(vars.here.db, val)

end

------------
-- PTIMER --
------------
octolib.ptime = octolib.ptime or {}
octolib.ptime.timers = octolib.ptime.timers or {}

-- unique timer id, delay in minutes (int), callback
function octolib.ptime.createTimer(identifier, delay, func)
	if not (identifier and isnumber(delay) and isfunction(func)) then
		return ErrorNoHalt('Incorrect arguments')
	end
	octolib.ptime.timers[identifier] = { math.floor(delay), func }
end

function octolib.ptime.removeTimer(identifier)
	if identifier then octolib.ptime.timers[identifier] = nil end
end

timer.Create('octolib.ptime.iterate', 60, 0, function()
	for _, ply in ipairs(player.GetAll()) do
		if ply:IsAFK() then continue end

		local minutesPlayed = math.floor(ply:GetTimeTotal() / 60)
		for _, v in pairs(octolib.ptime.timers) do
			if minutesPlayed % v[1] == 0 and ply.lastRewards ~= minutesPlayed then
				ply.lastRewards = minutesPlayed
				v[2](ply, minutesPlayed)
			end
		end

	end
end)
