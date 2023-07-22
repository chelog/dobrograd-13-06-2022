dbgWork = dbgWork or {}

local workInterval = {2 * 60, 10 * 60}
local workDuration = 10 * 60
local maxDist = 10000

maxDist = maxDist * maxDist

dbgWork.works = dbgWork.works or {}
function dbgWork.registerWork(id, data)

	dbgWork.works[id] = data

end

function dbgWork.isWorker(ply)

	if not IsValid(ply) or not ply:Alive() or ply:IsGhost() then return false end

	local job = ply:getJobTable()
	return job and job.worker

end

function dbgWork.planWork(ply)

	if not dbgWork.isWorker(ply) then return end

	local time = math.random(unpack(workInterval))
	time = ply:Team() == TEAM_CSD and time * 0.5 or time

	timer.Remove('dbg-workers.cancel' .. ply:SteamID())
	timer.Create('dbg-workers.create' .. ply:SteamID(), time, 1, function() dbgWork.createWork(ply) end)

end

local activeWorks = {}
function dbgWork.createWork(ply)

	if not dbgWork.isWorker(ply) then return end

	local work, workID
	for id, data in SortedPairsByMemberValue(dbgWork.works, 'priority', true) do
		work = data.start(ply, workDuration, maxDist)
		if work then
			workID = id
			break
		end
	end

	if not workID then
		ply:Notify('warning', L.cant_find_job)
		dbgWork.planWork(ply)
		return
	end

	work.workID = workID
	work.worker = ply
	activeWorks[ply] = work

	ply:Notify(L.you_have_job)
	if work.msg then ply:Notify(work.msg) end
	timer.Remove('dbg-workers.create' .. ply:SteamID())
	timer.Create('dbg-workers.cancel' .. ply:SteamID(), workDuration, 1, function()
		if dbgWork.isWorker(ply) and activeWorks[ply] then
			-- stop the work after timeout
			ply:Notify('warning', L.late_for_job)
			dbgWork.works[workID].cancel(activeWorks[ply])
			activeWorks[ply] = nil

			dbgWork.planWork(ply)
		end
	end)

end

function dbgWork.giveReward(work, min, max)

	local addMoney = work.worker:Team() == TEAM_CSD and math.Round(math.Rand(0.4, 0.45), 2) or 0
	local amount = work.salary or (math.random(min, max) * 10)
	amount = math.Round(amount + amount * addMoney)

	work.worker:addMoney(amount)
	work.worker:Notify(L.work_completed_hint:format(DarkRP.formatMoney(amount)))

end

function dbgWork.finishWork(ply)

	if not dbgWork.isWorker(ply) or not activeWorks[ply] then return end

	local work = activeWorks[ply]
	if work.cancelOnFinish then dbgWork.works[work.workID].cancel(work) end
	dbgWork.works[work.workID].finish(work)
	activeWorks[ply] = nil

	dbgWork.planWork(ply)

end

hook.Add('dbg-char.spawn', 'dbg-workers', dbgWork.planWork)
hook.Add('simple-orgs.getEquip', 'dbg-workers', dbgWork.planWork)
hook.Add('simple-orgs.handOver', 'dbg-workers', dbgWork.planWork)