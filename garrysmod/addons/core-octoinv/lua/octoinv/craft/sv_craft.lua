octoinv.blueprints = octoinv.blueprints or {}
local blueprints = octoinv.blueprints

function octoinv.registerCraft(id, data)

	if istable(data) then
		if isstring(id) then
			id = id
		end

		if istable(data.jobs) then
			data.jobs = octolib.array.toKeys(data.jobs)
		end

		if istable(data.conts) then
			data.conts = octolib.array.toKeys(data.conts)
		end

		blueprints[id] = data
		blueprints[id].id = id
	end

end

function octoinv.getBlueprint(id)

	if id and isstring(id) and blueprints[id] then
		return blueprints[id] or false
	end

end

local function canCraft(ply, ent, bpID, cont)

	local ok, why = hook.Run('octoinv.canCraft', ply, ent, bpID, cont)
	if ok ~= nil then return ok, why end

	local bp = octoinv.getBlueprint(bpID)
	if not istable(bp) then return false, 'Craft id is invalid' end

	if istable(bp.jobs) and not bp.jobs[ply:getJobTable().command] then
		return false, 'Your job doesn\'t have access to craft '.. bp.name
	end

	if istable(bp.conts) and not bp.conts[cont.id] then
		return false, 'Your container doesn\'t have access to craft '.. bp.name
	end

	if istable(bp.tools) then
		for k, v in ipairs(bp.tools) do
			if cont:HasItem(v[1]) < v[2] then
				return false, 'You don\'t have items to craft '.. bp.name
			end
		end
	end

	if isfunction(bp.check) then
		local ok, why = bp.check(ply, cont, ent)
		if ok ~= nil then return ok, why end
	end

	if istable(bp.ings) then
		for k, v in ipairs(bp.ings) do
			if cont:HasItem(v[1]) < v[2] then
				return false, 'You don\'t have materials to craft '.. bp.name
			end
		end
	end

	return true

end

local function craft(ply, ent, bpID, cont)

	local done = hook.Run('octoinv.craft', ply, ent, bpID, cont)
	if done then return hook.Run('octoinv.crafted', ply, ent, bpID, cont) end

	local bp = octoinv.getBlueprint(bpID)
	if bp and IsValid(ply) then
		local can, data = canCraft(ply, ent, bpID, cont)
		if not can then return end

		local name = bp.name
		if istable(data) and data.name then name = data.name end
		if istable(bp.finish) and not name then
			local item = bp.finish[1]
			name = octoinv.getItemData('name', unpack(item))
		end

		if isstring(bp.previewModel) then
			netstream.Start(ply, 'octoinv.craftPreview', bp.previewModel, bp.previewRotation)
		end

		local sndTemp = 0
		ply:DelayedAction('craft', L.create_in_progress:format(name), {
			time = bp.time or 5,
			check = function()
				if not IsValid(ply) or ply:KeyDown(IN_SPEED) or not ply:Alive() then
					ply:Notify('warning', L.create_failed:format(name))
					return false
				end

				if not canCraft(ply, ent, bpID, cont) then
					return false
				end

				local contAccess = ply:HasAccessToContainer(ent, cont.id)
				if not contAccess then
					ply:Notify('warning', L.create_failed:format(name))
					return false
				end

				return true
			end,
			succ = function()
				netstream.Start(ply, 'octoinv.craftPreview')
				if not canCraft(ply, ent, bpID, cont) then return end

				if isfunction(bp.finish) then
					local ok, why = bp.finish(ply, cont)
					if ok then
						if bp.ings then
							for i, v in ipairs(bp.ings) do
								cont:TakeItem(v[1], v[2])
							end
						end
						ply:Notify(L.create_success:format(name))
					else
						ply:Notify(why or L.create_failed:format(name))
					end
				elseif istable(bp.finish) then
					for i, v in ipairs(bp.ings) do
						cont:TakeItem(v[1], v[2])
					end

					for i, v in ipairs(bp.finish) do
						local amount, item = cont:AddItem(v[1], v[2])
						if not tobool(amount) then
							cont:DropNewItem(v[1], v[2])
						end
					end

					ply:Notify(L.create_success:format(name))
				end

				hook.Run('octoinv.crafted', ply, ent, bpID, cont)
			end,
			fail = function()
				netstream.Start(ply, 'octoinv.craftPreview')
			end,
		}, {
			time = 1.5,
			inst = true,
			action = function()
				ply:DoAnimation(ACT_GMOD_GESTURE_ITEM_DROP + math.random(0,1))
				sndTemp = sndTemp + 1
				if sndTemp >= (bp.soundTime or 1) then
					local sound = bp.sound and table.Random(bp.sound) or 'weapons/357/357_reload'.. math.random(1, 4) ..'.wav'
					ply:EmitSound(sound, 50)
					sndTemp = 0
				end
			end,
		})

		return true
	end

	return false, 'Craft '..bpID..' is invalid'

end

netstream.Hook('octoinv.craftlist', function(ply, ent, contID)

	ent = Entity(ent)
	local contAccess, cont = ply:HasAccessToContainer(ent, contID)

	if not contAccess then return end
	if not cont:CanCraft() then return end

	local available = {}
	for id, v in pairs(blueprints) do
		local can, data = canCraft(ply, ent, id, cont)
		if can then
			local opt = {
				name = v.name,
				desc = v.desc,
				icon = v.icon,
			}

			if istable(data) then
				if data.name then opt.name = data.name end
				if data.desc then opt.desc = data.desc end
				if data.icon then opt.icon = data.icon end
			end

			if isfunction(v.finish) then
				available[id] = opt
			elseif istable(v.finish) then
				local itemData = octoinv.items[v.finish[1][1]]
				if istable(itemData) then
					if itemData.name then opt.name = opt.name or itemData.name end
					if itemData.desc then opt.desc = opt.desc or itemData.desc end
					if itemData.icon then opt.icon = opt.icon or itemData.icon end
				end

				available[id] = opt
			end
		end
	end

	netstream.Start(ply, 'octoinv.craftlist', available)

end)

netstream.Hook('octoinv.craft', function(ply, ent, contID, bpID)

	if not ent then return end
	ent = Entity(ent)
	local contAccess, cont = ply:HasAccessToContainer(ent, contID)

	if not contAccess then return end
	if not cont:CanCraft() then return end

	local bp = octoinv.getBlueprint(bpID)
	if bp then
		local can, data = canCraft(ply, ent, bp.id, cont)
		if can then
			craft(ply, ent, bp.id, cont)
		elseif data then
			ply:Notify(data)
		end
	end

end)
