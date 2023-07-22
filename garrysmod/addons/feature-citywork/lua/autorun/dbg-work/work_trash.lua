local work = {}
work.priority = 25

function work.start(ply, time, maxDist)

	local maxVolume, trash, box = 0
	for _, v in ipairs(ents.FindByClass('ent_dbg_trash')) do
		local volume = -v.innerCont:FreeSpace()
		if not v.pendingWorker and volume > 75 and v:GetPos():DistToSqr(ply:GetPos()) < maxDist and volume > maxVolume then
			maxVolume, trash = volume, v
		end
	end
	if not IsValid(trash) then return end

	for _, v in RandomPairs(ents.FindByClass('ent_dbg_workerbox')) do
		if v:GetPos():DistToSqr(trash:GetPos()) < maxDist then box = v break end
	end
	if not IsValid(box) then return end

	ply:AddMarker {
		id = 'work1',
		txt = 'Собрать мусор',
		pos = trash:LocalToWorld(trash:OBBCenter()),
		col = Color(255,92,38),
		des = {'time', {time}},
		icon = octolib.icons.silk16('bin'),
	}

	ply:AddMarker {
		id = 'work2',
		txt = 'Отнести на утилизацию',
		pos = box:GetPos() + Vector(0,0,40),
		col = Color(255,92,38),
		des = {'time', {time}},
		icon = octolib.icons.silk16('recycle_bag'),
	}

	trash.pendingWorker = ply
	box.finishTrash = box.finishTrash or {}
	box.finishTrash[ply:SteamID()] = dbgWork.finishWork

	return {
		msg = 'Собери мусор в мусорке и отнеси его на утилизацию',
		cancelOnFinish = true,
		trash = trash,
		salary = math.ceil(math.abs(trash.innerCont:FreeSpace()) * 10),
	}

end

function work.finish(work)

	dbgWork.giveReward(work, 150, 250)

end

function work.cancel(work)

	if IsValid(work.trash) then
		work.trash.pendingWorker = nil
	end
	if IsValid(work.box) then
		work.box.finishTrash[work.worker:SteamID()] = nil
	end

end

dbgWork.registerWork('trash', work)
