dbgJobs.registered = dbgJobs.registered or {}
dbgJobs.available = dbgJobs.available or {}
dbgJobs.active = dbgJobs.active or {}
dbgJobs.subscribers = dbgJobs.subscribers or {}

file.CreateDir('dbg-jobs')
dbgJobs.mapConfig = util.JSONToTable(file.Read('dbg-jobs/' .. game.GetMap() .. '.json') or '{}') or {}

local maxJobs = 10
local addJobChance = 1
local addJobInterval = octolib.time.toSeconds(2, 'minutes')
local jobLifeTime = octolib.time.toSeconds(30, 'minutes')

function dbgJobs.registerType(id, jobData)
	if not isfunction(jobData.publish) then error('publish is required to register a job') end
	if not isfunction(jobData.start) then error('start is required to register a job') end
	if not isfunction(jobData.finish) then error('finish is required to register a job') end

	dbgJobs.registered[id] = jobData
end

function dbgJobs.syncAvailable(receivers)
	netstream.Start(receivers, 'dbg-jobs.syncAvailable', dbgJobs.available)
end

function dbgJobs.syncActive(ply)
	netstream.Start(ply, 'dbg-jobs.syncActive', ply.activeJobs)
end

function dbgJobs.getSubscribers()
	return table.GetKeys(dbgJobs.subscribers)
end

function dbgJobs.addAvailable(publishData)
	if not publishData.jobType then error('jobType is required to add a job') end

	local id = octolib.string.uuid()
	publishData.id = id
	dbgJobs.available[id] = publishData

	netstream.Start(dbgJobs.getSubscribers(), 'dbg-jobs.addAvailable', publishData)

	timer.Create('dbg-jobs.cancel:' .. id, jobLifeTime, 1, function()
		dbgJobs.removeAvailable(id, true)
	end)
end

function dbgJobs.addRandom()
	local pool = octolib.table.mapSequential(dbgJobs.registered, function(job, jobType) return { job.chance or 1, jobType } end)
	local jobType = octolib.array.randomWeighted(pool)
	if not jobType then return end

	local jobJdata = dbgJobs.registered[jobType]
	local publishData = jobJdata.publish()
	if not publishData then return end

	publishData.jobType = jobType

	dbgJobs.addAvailable(publishData)
end

function dbgJobs.removeAvailable(id, cancel)
	timer.Remove('dbg-jobs.timeout:' .. id)

	local publishData = dbgJobs.available[id]
	if not publishData then return end

	local jobData = dbgJobs.registered[publishData.jobType]
	if not jobData then return end

	if cancel and jobData.cancel then jobData.cancel(publishData) end
	dbgJobs.available[id] = nil

	netstream.Start(dbgJobs.getSubscribers(), 'dbg-jobs.removeAvailable', id)
end

function dbgJobs.assignJob(id, ply)
	local publishData = dbgJobs.available[id]
	if not publishData then return end

	local jobData = dbgJobs.registered[publishData.jobType]
	if not jobData then return end

	local startData = jobData.start(ply, publishData)
	if not startData then return end

	startData.id = id
	startData.ply = ply
	startData.jobType = publishData.jobType
	startData.startedAt = CurTime()
	startData.publishData = publishData

	ply.activeJobs = ply.activeJobs or {}
	ply.activeJobs[id] = startData
	dbgJobs.active[id] = startData
	dbgJobs.removeAvailable(id)
	dbgJobs.syncActive(ply)

	local timeout = startData.timeout or publishData.timeout
	if timeout then
		timer.Create('dbg-jobs.timeout:' .. id, timeout, 1, function()
			dbgJobs.finishJob(id, false)
		end)
	end

	ply:Notify(publishData.desc)

	return startData
end

function dbgJobs.finishJob(id, isSuccessful)
	timer.Remove('dbg-jobs.timeout:' .. id)

	local startData = dbgJobs.active[id]
	if not startData then return end

	local jobData = dbgJobs.registered[startData.jobType]
	if not jobData then return end

	local ply = startData.ply
	jobData.finish(startData, isSuccessful)
	dbgJobs.active[id] = nil

	if IsValid(ply) then
		startData.ply.activeJobs[id] = nil
		dbgJobs.syncActive(ply)
	end
end

function dbgJobs.saveMapConfig(data)
	if data then dbgJobs.mapConfig = data end
	file.Write('dbg-jobs/' .. game.GetMap() .. '.json', util.TableToJSON(dbgJobs.mapConfig))
end

timer.Create('dbg-jobs.tryAddAvailable', addJobInterval, 0, function()
	if table.Count(dbgJobs.available) >= maxJobs or math.random() > addJobChance then return end
	dbgJobs.addRandom()
end)

local files = file.Find('dbg-jobs/jobs/*.lua', 'LUA')
for _, v in ipairs(files) do
	octolib.server('dbg-jobs/jobs/' .. string.StripExtension(v))
end