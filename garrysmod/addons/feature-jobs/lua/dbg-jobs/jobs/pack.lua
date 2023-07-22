local packages = {
	{
		text = 'коробку',
		money = 1000,
		variants = {
			{ model = 'models/physrbox/cardboard_taped.mdl', mass = 15 },
			{ model = 'models/physrbox/taped_big.mdl', mass = 15 },
			{ model = 'models/physrbox/taped_medium.mdl', mass = 10 },
			{ model = 'models/physrbox/taped_white.mdl', mass = 10 },
		},
	}, {
		text = 'мешок',
		money = 2500,
		variants = {
			{ model = 'models/props_shops/prop_bakery_floursack_01_a.mdl', mass = 40 },
			{ model = 'models/props_shops/prop_bakery_floursack_02_a.mdl', mass = 40 },
			{ model = 'models/props_shops/prop_bakery_floursack_02_b.mdl', mass = 35 },
			{ model = 'models/props_shops/prop_bakery_floursack_02_c.mdl', mass = 30 },
		},
	}, {
		text = 'телевизор',
		money = 2500,
		variants = {
			{ model = 'models/gmod_tower/suitetv.mdl', mass = 50 },
			{ model = 'models/mark2580/gtav/mp_apa_low/lobby/tv_03.mdl', mass = 40 },
			{ model = 'models/sal/ammunation/tv2.mdl', mass = 40 },
			{ model = 'models/sal/ammunation/tv.mdl', mass = 35 },
		},
	}, {
		text = 'кресло',
		money = 3500,
		variants = {
			{ model = 'models/mark2580/gtav/mp_apa_mid/hall/v_res_mp_stripchair_high.mdl', mass = 80 },
			{ model = 'models/mark2580/gtav/mp_apa_06/lobby/apa_mp_h_stn_chairarm_23_high.mdl', mass = 75 },
			{ model = 'models/props_interiors/sofa_chair02.mdl', mass = 75 },
			{ model = 'models/Highrise/lobby_chair_01.mdl', mass = 100 },
		},
	}, {
		text = 'шкаф',
		money = 5000,
		variants = {
			{ model = 'models/mark2580/gtav/mp_apa_mid/bedroom/v_res_tre_storageunit_high.mdl', mass = 125 },
			{ model = 'models/mark2580/gtav/mp_apa_low/bedroom/brm_cabinet.mdl', mass = 120 },
			{ model = 'models/mark2580/gtav/mp_apa_06/lobby/apa_mpa6_sideboardm02_high.mdl', mass = 140 },
			{ model = 'models/props_c17/furnituredresser001a.mdl', mass = 155 },
			{ model = 'models/props/interior/dresser_wardrobe01.mdl', mass = 170 },
		},
	}, {
		text = 'диван',
		money = 6000,
		variants = {
			{ model = 'models/mark2580/gtav/tequilala_map/basement/club_officesofa.mdl', mass = 150 },
			{ model = 'models/mark2580/gtav/mp_apa_low/lobby/sofa1.mdl', mass = 160 },
			{ model = 'models/props_interiors/sofa01.mdl', mass = 175 },
			{ model = 'models/props_interiors/sofa02.mdl', mass = 170 },
			{ model = 'models/props_c17/furniturecouch002a.mdl', mass = 140 },
			{ model = 'models/sims/gm_sofa.mdl', mass = 135 },
		},
	},
}

local job = {}

function job.publish()
	local packageData = table.Random(packages)
	if not packageData then return end

	local modelData = table.Random(packageData.variants)
	if not modelData then return end

	local mapConfig = dbgJobs.mapConfig and dbgJobs.mapConfig.pack
	if not mapConfig then return end

	local existingPackagesPositions = octolib.table.mapSequential(ents.FindByClass('dbg_jobs_package'), function(ent)
		return ent:GetPos()
	end)

	local spawnData, targetPos
	for _, place in RandomPairs(mapConfig) do
		if not targetPos then
			targetPos = place[1]
			continue
		end

		-- we don't want any other packages near spawn
		local pos = unpack(place)
		local ok = true
		for _, theirPos in ipairs(existingPackagesPositions) do
			if theirPos:DistToSqr(pos) < 90000 then
				ok = false
				break
			end
		end

		if ok then
			spawnData = place
			break
		end
	end
	if not spawnData then return end

	targetPos = util.TraceLine({
		start = targetPos,
		endpos = targetPos + Vector(0, 0, -300),
		collisiongroup = COLLISION_GROUP_WORLD,
	}).HitPos or targetPos

	local prop = ents.Create 'dbg_jobs_package'
	prop:SetModel(modelData.model)
	prop:SetSkin(modelData.skin or 0)
	prop:SetBodyGroups(modelData.bodygroups or '')
	prop:Spawn()
	prop:Activate()
	prop:SetPos(spawnData[1] + Vector(0, 0, -prop:OBBMins().z))
	prop:SetAngles(spawnData[2])

	local phys = prop:GetPhysicsObject()
	if IsValid(phys) then
		phys:SetMass(modelData.mass * 3)
		phys:Wake()
	end

	local estateFrom = dbgEstates.getNearest(spawnData[1])
	local addressFrom = estateFrom and estateFrom.name or '???'
	local estateTo = dbgEstates.getNearest(targetPos)
	local addressTo = estateTo and estateTo.name or '???'

	local desc = ('Требуется доставить %s массой %d кг\n%s → %s'):format(packageData.text, modelData.mass, addressFrom, addressTo)
	desc = desc .. ('\nОбъем груза: %dл'):format(prop:GetVolumeLiters())
	if modelData.mass > 100 then
		desc = desc .. '\nРекомендуется использовать грузовой автомобиль'
	end

	local money = packageData.money
		-- from -25% to +25% based on distance
		+ math.Round(packageData.money / 40 * (math.Clamp(spawnData[1]:Distance(targetPos), 0, 10000) / 10000 - 0.5)) * 10
		-- from -10% to +10% as a random bonus
		+ math.floor(packageData.money / 100) * math.random(-10, 10)

	return {
		name = ('Перевозка груза (%s кг)'):format(modelData.mass),
		icon = octolib.icons.silk32('lorry_go'),
		desc = desc,
		reward = DarkRP.formatMoney(money),
		deposit = math.floor(money / 40) * 10,
		timeout = octolib.time.toSeconds(10, 'minutes'),

		money = money,
		prop = prop,
		targetPos = targetPos,
	}
end

function job.cancel(publishData)
	local prop = publishData.prop
	if IsValid(prop) then prop:Remove() end
end

function job.start(ply, publishData)
	if not IsValid(publishData.prop) then
		ply:Notify('Что-то случилось с грузом, задание отменено')
		dbgJobs.removeAvailable(publishData.id, true)
		return
	end

	local markerID = 'job:' .. publishData.id
	local prop = publishData.prop
	ply:AddMarker({
		id = markerID .. '.1',
		txt = 'Груз',
		pos = prop:WorldSpaceCenter(),
		col = Color(255,92,38),
		des = {'dist', { 100 }},
		icon = octolib.icons.silk16('box_closed'),
	})

	local targetPos = publishData.targetPos
	ply:AddMarker({
		id = markerID .. '.2',
		txt = 'Получатель',
		pos = targetPos,
		col = Color(255,92,38),
		des = {'time', { octolib.time.toSeconds(2, 'hours') }},
		icon = octolib.icons.silk16('arrow_down'),
	})
	prop:SetDeliveryData(publishData.id, ply, targetPos)

	return {}
end

function job.finish(startData, isSuccessful)
	local prop = startData.publishData.prop
	if IsValid(prop) then prop:Remove() end

	local ply = startData.ply
	if not IsValid(ply) then return end

	ply:ClearMarkers('job:' .. startData.publishData.id .. '.1')
	ply:ClearMarkers('job:' .. startData.publishData.id .. '.2')

	if isSuccessful then
		local totalReward = startData.publishData.money + startData.publishData.deposit

		ply:Notify(('Задание "%s" выполнено! На твой счет перечислено %s'):format(
			startData.publishData.name,
			DarkRP.formatMoney(totalReward)
		))
		ply:BankAdd(totalReward)
	else
		ply:Notify('warning', ('Задание "%s" провалено'):format(startData.publishData.name))
	end
end

dbgJobs.registerType('pack', job)
