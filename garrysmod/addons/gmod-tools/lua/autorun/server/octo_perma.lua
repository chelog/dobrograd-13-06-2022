permaprops = permaprops or {}

local toClearCons = octolib.array.toKeys({'BuildDupeInfo','Constraint','FPPOwner','FPPOwnerID','Identity','OnDieFunctions'})
local noClearEnts = octolib.array.toKeys({'PhysicsObjects', 'EntityMods', 'Class', 'Pos', 'Angle', 'Skin', 'Material', 'Model'})

function permaprops.clearData(data)

	-- clean up unnecessary data
	for id, entData in pairs(data.Entities) do
		local ent = Entity(id)
		if IsValid(ent) then
			local baseClass = scripted_ents.GetStored(entData.Class)
			for k, v in pairs(entData) do
				if baseClass and v == baseClass[k] then
					entData[k] = nil
				end
			end

			local noClearClass = {}
			local dupeInfo = duplicator.FindEntityClass(entData.Class)
			if dupeInfo and dupeInfo.Args then
				for i = 2, #dupeInfo.Args do
					noClearClass[dupeInfo.Args[i]] = true
				end
			end

			for k, v in pairs(ent:GetTable()) do
				if not noClearEnts[k] and not noClearClass[k] then
					entData[k] = nil
				end
			end
		end
	end

	for id, conData in pairs(data.Constraints) do
		for k, v in pairs(conData) do
			if toClearCons[k] then conData[k] = nil end
		end

		for i = 1, 2 do
			local data = conData.Entity[i]
			data.Entity = nil
			conData['Ent' .. i] = nil
		end
	end

	return data

end

function permaprops.markPerma(entities)

	for id, ent in pairs(entities) do
		ent.perma = true
	end

	timer.Simple(0.15, function()
		for id, ent in pairs(entities) do
			if ent.APG_Ghosted then APG.entUnGhost(ent) end
		end
	end)

end

function permaprops.spawn(data)

	local entities, consts = duplicator.Paste(nil, data.Entities or {}, data.Constraints or {})
	permaprops.markPerma(entities)
	for _, ent in pairs(entities) do
		if ent:GetClass():find('prop_dynamic', 1, false) then
			ent:PhysicsInitStatic(SOLID_VPHYSICS)
			ent:Activate()
			ent:SetNotSolid(false) -- fix this damn duplicator bug
		end

		timer.Simple(1, function()
			for _, ent in pairs(entities) do
				if IsValid(ent) and ent:GetClass() == 'prop_effect' then
					local ph = ent:GetPhysicsObject()
					if IsValid(ph) then ph:EnableMotion(false) end
				end
			end
		end)
	end
	hook.Run('octoperma.spawned', entities, consts)

end

function permaprops.save()

	local saveData = { Entities = {}, Constraints = {} }
	for k, ent in pairs(ents.GetAll()) do
		if ent.perma then
			duplicator.Copy(ent, saveData)
		end
	end

	permaprops.clearData(saveData)

	local fname = 'octo_perma/' .. game.GetMap() .. '.dat'
	file.CreateDir('octo_perma')
	file.Write(fname, util.Compress(pon.encode(saveData)))

end

function permaprops.clear()

	for k, ent in pairs(ents.GetAll()) do
		if ent.perma then
			ent:Remove()
		end
	end

end

function permaprops.load()

	local fname = 'octo_perma/' .. game.GetMap() .. '.dat'
	local raw = file.Read(fname, 'DATA')
	if not raw then return end

	local data = pon.decode(util.Decompress(raw))
	permaprops.spawn(data)

end

concommand.Add('octo_perma_save', function(ply)

	if not ply:query(L.permissions_permaprops) then return end

	ply:ChatPrint(L.octo_perma_save)
	permaprops.save()
	ply:ChatPrint(L.octo_perma_save_ready)

end)

concommand.Add('octo_perma_clear', function(ply)

	if not ply:query(L.permissions_permaprops) then return end

	permaprops.clear()
	ply:ChatPrint(L.octo_perma_clear)

end)

concommand.Add('octo_perma_load', function(ply)

	if not ply:query(L.permissions_permaprops) then return end

	ply:ChatPrint(L.octo_perma_load)
	permaprops.clear()
	permaprops.load()
	ply:ChatPrint(L.octo_perma_load_ready)

end)

hook.Add('InitPostEntity', 'octo_perma', permaprops.load)
hook.Add('PostCleanupMap', 'octo_perma', permaprops.load)
