local work = {}
work.priority = 50

function work.start(ply, time, maxDist)

	local vend, box
	for i, v in RandomPairs(ents.FindByClass('ent_dbg_vend')) do
		if v.bottlesLeft < 6 and not v.pendingWorker and v:GetPos():DistToSqr(ply:GetPos()) < maxDist then vend = v break end
	end
	if not IsValid(vend) then return end

	for i, v in RandomPairs(ents.FindByClass('ent_dbg_workerbox')) do
		if v:GetPos():DistToSqr(vend:GetPos()) < maxDist then box = v break end
	end
	if not IsValid(box) then return end

	ply:AddMarker {
		id = 'work1',
		txt = L.take_soda,
		pos = box:GetPos() + Vector(0,0,40),
		col = Color(255,92,38),
		des = {'time', {time}},
		icon = 'octoteam/icons-16/box.png',
	}

	ply:AddMarker {
		id = 'work2',
		txt = L.load_in_soda_machine,
		pos = vend:GetPos() + Vector(0,0,40),
		col = Color(255,92,38),
		des = {'time', {time}},
		icon = 'octoteam/icons-16/basket_put.png',
	}

	local cont = box.inv.conts[ply:SteamID()] or box.inv:AddContainer(ply:SteamID(), {name = L.city_warehouse, volume = 250, icon = octolib.icons.color('box1')})
	cont:AddItem('souvenir', {
		name = L.block_soda,
		icon = 'octoteam/icons/box3.png',
		model = 'models/Items/BoxMRounds.mdl',
		volume = 15,
		mass = 20,
	})

	vend.pendingWorker = ply
	vend.finish = dbgWork.finishWork

	return {
		msg = L.take_soda_hint,
		cancelOnFinish = true,
		vend = vend,
		cont = cont,
		oldUse = oldUse,
	}

end

function work.finish(work)

	dbgWork.giveReward(work, 150, 250)

end

function work.cancel(work)

	if work.cont then work.cont:Remove() end
	if IsValid(work.vend) then
		work.vend.pendingWorker = nil
		work.vend.finish = nil
	end

end

dbgWork.registerWork('vend', work)
