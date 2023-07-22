local pointTypes = {
	-- collect
	{
		insertCanCreate = function(canCreate)
			for collectableID, collectable in pairs(octoinv.collectables) do
				for i, mdl in ipairs(collectable.models) do
					local data = {
						parent = 'collect_' .. collectableID,
						name = collectable.name  .. ' *',
					}

					if istable(mdl) then
						data.model = mdl[1]
						data.skin = mdl.skin
						data.scale = mdl.scale
						data.col = mdl.color
					else
						data.model = mdl
					end

					canCreate[#canCreate + 1] = {collectable.name .. ' ' .. i, data}
				end
			end
		end,
		insertProps = function(props)
			for collectableID, collectable in pairs(octoinv.collectables) do
				props['collect_' .. collectableID] = {
					name = collectable.name,
					icon = octolib.icons.silk16('folder'),
					model = 'models/hunter/blocks/cube025x025x025.mdl',
					static = true,
				}

				for _, point in ipairs(octoinv.mapConfig.collect[collectableID] or {}) do
					local model, pos, ang = unpack(point)
					local modelData = octolib.table.find(collectable.models, function(md) return md == model or md[1] == model end)
					if not modelData then continue end

					props[#props + 1] = {
						name = collectable.name,
						parent = 'collect_' .. collectableID,
						model = model,
						pos = pos,
						ang = ang,
						scale = modelData.scale,
						col = modelData.color,
					}
				end
			end
		end,
		saveMovables = function(config, movables)
			config.collect = {}
			for _, movable in pairs(movables) do
				local parent = movable.parent
				if not parent then continue end

				local collectableID = parent:gsub('collect_', '')
				if not octoinv.collectables[collectableID] then continue end

				config.collect[collectableID] = config.collect[collectableID] or {}
				local saved = config.collect[collectableID]
				saved[#saved + 1] = { movable.model, movable.pos, movable.ang }
			end
		end,
	},
}

netstream.Hook('octoinv.editMap', function(ply, data)
	if not ply:IsSuperAdmin() then return end

	if data then
		local config = octoinv.mapConfig
		for _, pointType in ipairs(pointTypes) do
			pointType.saveMovables(config, data)
		end

		return octoinv.saveMapConfig(config)
	end

	local props, canCreate = {}, {}
	for _, pointType in ipairs(pointTypes) do
		pointType.insertProps(props)
		pointType.insertCanCreate(canCreate)
	end

	netstream.Heavy(ply, 'octoinv.editMap', props, canCreate)
end)
