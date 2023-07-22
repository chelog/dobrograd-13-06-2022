local icon = octolib.icons.silk16('location_pin', 'smooth mips')

concommand.Add('octoinv_map_editor', function(ply, data)
	netstream.Start('octoinv.editMap')
end)

netstream.Hook('octoinv.editMap', function(props, canCreate)
	local categoryProps = octolib.table.filter(props, function(p) return not p.parent end)

	local showIcons = octolib.array.toKeys(table.GetKeys(categoryProps), false)
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

	octolib.flyEditor.start({
		props = categoryProps, -- load categories first
		canCreate = canCreate,
		maxDist = 0,
		noclip = true,
		buttons = {
			{'Отображать сквозь карту', octolib.icons.silk32('eye'), function()
				octolib.menu(
					octolib.table.mapSequential(categoryProps, function(v, k)
						return {v.name, showIcons[k] and octolib.icons.silk16('tick') or octolib.icons.silk16('cross'), function()
							showIcons[k] = not showIcons[k]
						end}
					end)
				):Open()
			end}
		},
	}, function(movables)
		netstream.Heavy('octoinv.editMap', octolib.table.map(movables, function(movable)
			return {
				model = movable.model,
				pos = movable.pos,
				ang = movable.ang,
				parent = movable.parent,
			}
		end))
	end)

	timer.Simple(0, function()
		-- add child props later
		for id, prop in pairs(octolib.table.filter(props, function(p) return isstring(p.parent) end)) do
			octolib.flyEditor.addMovable(prop, id)
		end
	end)
end)
