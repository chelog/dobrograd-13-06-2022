local sessions = {}

local function switchEditor(ply, on)

	if on then
		ply:Freeze(true)
		ply:GodEnable()
		ply.inFlyEditor = true
	else
		ply:Freeze(false)
		ply:GodDisable()
		ply.inFlyEditor = nil
	end

end

local curID = 0
function octolib.flyEdit(ply, options, funcOk, funcCancel)

	curID = curID + 1

	switchEditor(ply, true)
	sessions[ply] = { curID, options, funcOk, funcCancel }
	netstream.Start(ply, 'octolib.fly-editor', curID, options)

	timer.Create('fly-editor.' .. ply:SteamID(), 30 * 60, 1, function()
		octolib.flyEditCancel(ply)
	end)

end

function octolib.flyEditCancel(ply)

	local session = sessions[ply]
	if not session then return end

	local funcCancel = session[3]
	if funcCancel then funcCancel({}) end

	sessions[ply] = nil
	switchEditor(ply, false)
	timer.Remove('fly-editor.' .. ply:SteamID())

end

netstream.Hook('octolib.fly-editor', function(ply, id, ok, changed)

	local session = sessions[ply]
	if not session then return end
	if session[1] ~= id then
		ply:Notify('warning', 'Что-то пошло не так при синхронизации данных, попробуй еще раз')
		octolib.flyEditCancel(ply)
		return
	end

	local options, funcOk, funcCancel = unpack(session, 2)

	changed = changed or {}
	for ent in pairs(changed) do
		if isentity(ent) and not table.HasValue(options.props, ent) then
			changed[ent] = nil
		end
	end

	if ok and funcOk then funcOk(changed, options) end
	if not ok and funcCancel then funcCancel(changed, options) end
	session[id] = nil

	switchEditor(ply, false)
	timer.Remove('fly-editor.' .. ply:SteamID())

end)

hook.Add('PlayerDisconnected', 'octolib.fly-editor', function(ply)
	octolib.flyEditCancel(ply)
end)

netstream.Hook('gm_spawn', function(ply, args)
	CCSpawn(ply, 'gm_spawn', args)
end)

concommand.Add('octolib_flyeditor', function(ply)
	if not ply:query('octolib.flyEditor') or ply.inFlyEditor then return end

	ply:SelectWeapon('weapon_physgun')

	local existing = octolib.array.filter(ents.GetAll(), function(ent) return ent:CPPIGetOwner() == ply and ent:GetClass():find('prop_') end)
	octolib.flyEdit(ply, {
		maxDist = 0,
		noclip = true,
		canCreate = true,
		props = existing,
	}, function(changed, options)
		if table.Count(changed) < 1 or not ply:query('octolib.flyEditor') then return end

		local parentQueue = {}

		undo.Create('octolib.flyEditor')
			undo.SetPlayer(ply)

		for id, data in pairs(changed) do
			local mdl = data.model

			local ent = existing[id]
			if not IsValid(ent) then
				if util.IsValidProp(mdl) then
					ent = DoPlayerEntitySpawn(ply, 'prop_physics', mdl, 0)
					FixInvalidPhysicsObject(ent)
					DoPropSpawnedEffect(ent)
				else
					ent = DoPlayerEntitySpawn(ply, 'prop_effect', mdl, 0)
					if IsValid(ent.AttachedEntity) then
						DoPropSpawnedEffect(ent.AttachedEntity)
					end
				end
			end
			data._ent = ent

			if data.deleted then
				ent:Remove()
				continue
			end

			if data.parent then
				parentQueue[ent] = {
					parent = data.parent,
					pos = data.pos,
					ang = data.ang,
				}

				data.parent = nil
				data.pos = nil
				data.ang = nil
			end

			octolib.applyEntData(ent, data)
			local ph = ent:GetPhysicsObject()
			if IsValid(ph) then ph:EnableMotion(false) end
			ent:Activate() -- to fix scale physics
			ent:CPPISetOwner(ply)

			undo.AddEntity(ent)
			ply:AddCleanup('props', ent)
		end
		undo.Finish('octolib.flyEditor (' .. os.date('%X', os.time()) .. ')')

		for ent, data in pairs(parentQueue) do
			if isnumber(data.parent) then data.parent = changed[data.parent]._ent end
			octolib.applyEntData(ent, data)
		end
	end)
end)
