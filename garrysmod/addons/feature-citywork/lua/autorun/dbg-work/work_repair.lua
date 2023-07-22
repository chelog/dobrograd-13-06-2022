local work = {}
work.priority = 10

function work.start(ply, time, maxDist)

	local problem, box
	for i, v in RandomPairs(ents.FindByClass('ent_dbg_workproblem')) do
		if not v.pendingWorker and v:GetPos():DistToSqr(ply:GetPos()) < maxDist then problem = v break end
	end
	if not IsValid(problem) then return end

	for i, v in RandomPairs(ents.FindByClass('ent_dbg_workerbox')) do
		if v:GetPos():DistToSqr(problem:GetPos()) < maxDist then box = v break end
	end
	if not IsValid(box) then return end

	ply:AddMarker {
		id = 'work1',
		txt = L.take_details,
		pos = box:GetPos() + Vector(0,0,40),
		col = Color(255,92,38),
		des = {'time', {time}},
		icon = 'octoteam/icons-16/setting_tools.png',
	}

	ply:AddMarker {
		id = 'work2',
		txt = L.repair,
		pos = problem:GetPos(),
		col = Color(255,92,38),
		des = {'time', {time}},
		icon = 'octoteam/icons-16/wrench_orange.png',
	}

	local items = {}
	if math.random(3) == 1 then table.insert(items, {'tool_wrench', 1}) end
	if math.random(3) == 1 then table.insert(items, {'tool_solder', 1}) end
	if math.random(3) == 1 then table.insert(items, {'tool_screwer', 1}) end
	if #items < 1 then table.insert(items, {'tool_screwer', 1}) end
	if math.random(3) == 1 then table.insert(items, {'craft_screwnut', 5}) end
	if math.random(3) == 1 then table.insert(items, {'craft_screw2', 5}) end
	if math.random(3) == 1 then table.insert(items, {'craft_resistor', 3}) end
	if math.random(3) == 1 then table.insert(items, {'craft_relay', 2}) end
	if math.random(3) == 1 then table.insert(items, {'craft_scotch', 1}) end
	if math.random(3) == 1 then table.insert(items, {'craft_glue', 1}) end
	if math.random(3) == 1 then table.insert(items, {'craft_bulb', 2}) end

	if box.inv.conts[ply:SteamID()] then box.inv.conts[ply:SteamID()]:Remove() end
	local cont = box.inv.conts[ply:SteamID()] or box.inv:AddContainer(ply:SteamID(), {name = L.city_warehouse, volume = 250, icon = octolib.icons.color('box1')})
	for i, v in ipairs(items) do cont:AddItem(v[1], v[2]) end

	problem:SetWork(ply, {
		items = items,
		time = math.random(10, 40),
		finish = dbgWork.finishWork,
	})

	return {
		cancelOnFinish = true,
		msg = L.worker_msg,
		problem = problem,
	}

end

function work.finish(work)

	dbgWork.giveReward(work, 50, 125)

end

function work.cancel(work)

	work.problem:UnsetWork()
	if work.cont then work.cont:Remove() end

end

dbgWork.registerWork('repair', work)
