concommand.Add('dbg_jobs_editor', function()
	netstream.Start('dbg-jobs.editMap')
end)

local icon = octolib.icons.silk16('location_pin', 'smooth mips')
local pointTypes = {
	pack = {
		name = 'Точки доставки груза',
		model = 'models/props_junk/wood_crate002a.mdl',
		serialize = function(data) return { data.pos, data.ang } end,
		deserialize = function(data) return { pos = data[1], ang = data[2] } end,
	},
	home = {
		name = 'Точки доставки на дом',
		model = 'models/hunter/blocks/cube075x075x075.mdl',
		serialize = function(data) return data.pos end,
		deserialize = function(data) return { pos = data } end,
	},
}

netstream.Hook('dbg-jobs.editMap', function(data)
	local showIcons = {}
	hook.Add('HUDPaint', 'dbg-jobs.editMap', function()
		if not octolib.flyEditor.active then
			return hook.Remove('HUDPaint', 'dbg-jobs.editMap')
		end

		for _, movable in pairs(octolib.flyEditor.movables) do
			local parentCsEnt = movable.csent:GetParent()
			local parent = parentCsEnt and parentCsEnt.movable and parentCsEnt.movable.id
			if parent and showIcons[parent] then
				local pos = movable.csent:GetPos():ToScreen()
				surface.SetMaterial(icon)
				surface.SetDrawColor(255,255,255, 255)
				surface.DrawTexturedRect(pos.x - 8, pos.y - 8, 16, 16)
			end
		end
	end)

	local props = octolib.table.map(pointTypes, function(v)
		return {
			name = v.name,
			model = v.model,
		}
	end)

	octolib.flyEditor.start({
		props = props,
		noclip = true,
		maxDist = 0,
		buttons = {
			{'Отображать сквозь карту', octolib.icons.silk32('eye'), function()
				octolib.menu(
					octolib.table.mapSequential(pointTypes, function(v, k)
						return {v.name, showIcons[k] and octolib.icons.silk16('tick') or octolib.icons.silk16('cross'), function()
							showIcons[k] = not showIcons[k]
						end}
					end)
				):Open()
			end}
		},
		canCreate = octolib.table.mapSequential(pointTypes, function(v, k)
			return {v.name, {
				model = v.model,
				parent = k,
				name = 'Новая точка',
			}}
		end),
	}, function(movables)
		local toSend = {}
		for _, movable in pairs(movables) do
			local typeID = movable.parent
			local typeData = pointTypes[typeID]
			if typeData then
				local t = toSend[typeID] or {}
				t[#t + 1] = typeData.serialize(movable)
				toSend[typeID] = t
			end
		end

		netstream.Heavy('dbg-jobs.editMap', toSend)
	end)

	timer.Simple(0, function()
		for key, typeData in pairs(pointTypes) do
			for _, item in ipairs(data[key] or {}) do
				octolib.flyEditor.addMovable(table.Merge({
					parent = key,
					name = 'Точка',
					model = typeData.model,
				}, typeData.deserialize(item)))
			end
		end
	end)
end)
