octoinv.collectables = octoinv.collectables or {}
octoinv.collectors = octoinv.collectors or {}

local function createTimer(collectableID)
	local collectableData = octoinv.collectables[collectableID]
	local delay = math.random(unpack(collectableData.period))

	timer.Create('octoinv.spawnCollectable:' .. collectableID, delay, 1, function()
		createTimer(collectableID)

		local existing = octolib.table.mapSequential(ents.FindByClass('octoinv_collectable'), function(e)
			return e.collectableID == collectableID and e or nil
		end)

		if #existing < collectableData.max then
			octoinv.spawnCollectable(collectableID)
		end
	end)
end

function octoinv.registerCollectable(id, data)
	data.id = id
	octoinv.collectables[id] = data

	createTimer(id)
end

function octoinv.registerCollector(id, data)
	data.id = id
	octoinv.collectors[id] = data
end

function octoinv.spawnCollectable(id)
	for _, point in RandomPairs(octoinv.mapConfig.collect[id] or {}) do
		local model, pos, ang = unpack(point)
		if #octolib.table.mapSequential(ents.FindInSphere(pos, 4), function(e) return e:GetClass() == 'octoinv_collectable' and e or nil end) > 0 then continue end

		local ent = ents.Create('octoinv_collectable')
		ent:SetPos(pos)
		ent:SetAngles(ang)
		ent:SetCollectableID(id, model)
		ent:Spawn()

		return ent
	end
end
