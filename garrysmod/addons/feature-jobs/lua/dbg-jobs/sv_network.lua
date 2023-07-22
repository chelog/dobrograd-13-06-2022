netstream.Hook('dbg-jobs.subscribe', function(ply, subscribe)
	dbgJobs.subscribers[ply] = subscribe and true or nil

	if subscribe then
		dbgJobs.syncAvailable(ply)
		dbgJobs.syncActive(ply)
	end
end)

netstream.Listen('dbg-jobs.take', function(reply, ply, jobID)
	local publishData = dbgJobs.available[jobID or '']
	if not publishData then return reply('Заказ не существует. Возможно, его уже взяли') end

	if publishData.deposit and not ply:BankHas(publishData.deposit) then
		return reply('У тебя не хватает денег для принятия этого заказа')
	end

	local can, why = hook.Run('dbg-jobs.canTake', ply, publishData)
	if can == false then
		return reply(why or 'Ты не можешь принять этот заказ')
	end

	local startData = dbgJobs.assignJob(jobID, ply)
	if not startData then
		return reply('Не получилось принять заказ')
	end

	if publishData.deposit then
		ply:BankAdd(-publishData.deposit)
	end

	reply()
end)

netstream.Hook('dbg-jobs.cancel', function(ply, jobID)
	local startData = dbgJobs.active[jobID or '']
	if not startData or startData.ply ~= ply then return end

	dbgJobs.finishJob(jobID, false)
	ply:Notify('Заказ отменен')
end)

netstream.Hook('dbg-jobs.editMap', function(ply, data)
	if not ply:IsSuperAdmin() then return end

	if data then
		dbgJobs.saveMapConfig(data)
	else
		netstream.Heavy(ply, 'dbg-jobs.editMap', dbgJobs.mapConfig)
	end
end)
