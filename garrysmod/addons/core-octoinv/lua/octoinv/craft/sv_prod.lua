octoinv.prod = octoinv.prod or {}

function octoinv.registerProd(id, t)

	t.prod = {}
	octoinv.prod[id] = t

end

function octoinv.registerProcess(prodID, t, processID)

	if not octoinv.prod[prodID] then
		octoinv.msg('ERROR: Trying to register process for inexistant prod \'%s\'', prodID)
		return
	end

	if not t.time or not t.ins or not t.out then
		octoinv.msg('ERROR: Trying to register process with incomplete data for \'%s\'', prodID)
		return
	end

	local processes = octoinv.prod[prodID].prod
	processes[processID or (#processes + 1)] = t

end

function octoinv.spawnCont(mdl, conts, data)
	return function(ply, cont)
		local ent = ents.Create 'octoinv_cont'
		ent.dt = ent.dt or {}
		ent.dt.owning_ent = ply
		ent.Model = mdl
		ent.Containers = conts

		if istable(data) then
			ent.Mass = data.mass
			ent.DestructParts = data.destruct
			ent.DestroyParts = data.destroy
			ent.Explode = data.explode
			ent.Health = data.health
		end

		ent.SID = ply.SID
		ent:Spawn()

		ply:BringEntity(ent)
		ent:SetPlayer(ply)
		ent:SetLocked(false)
		timer.Simple(3, function()
			if IsValid(ent) and IsValid(ply) then
				APG.entUnGhost(ent, ply)
			end
		end)
		return true
	end
end

function octoinv.spawnProd(data)
	if not istable(data) then return octolib.func.zero end
	return function(ply, cont)
		if isfunction(data.check) then
			local ok, why = data.check(ply, cont)
			if ok == false then
				return false, why
			end
		end

		local ent = ents.Create 'octoinv_prod'
		ent.dt = ent.dt or {}
		ent.dt.owning_ent = ply
		ent.Model = data.mdl
		ent.Containers = data.conts

		if isstring(data.prod) then
			ent.prodClass = data.prod
			data.prod = octoinv.prod[data.prod]
		end
		ent:SetProdData(data.prod)

		if istable(data.other) then
			for k,v in pairs(data.other) do
				ent[k] = v
			end
		end

		ent.SID = ply.SID
		ent:Spawn()

		ply:BringEntity(ent, data.rotate)
		ent:SetPlayer(ply)
		ent:SetLocked(false)
		timer.Simple(3, function()
			if IsValid(ent) and IsValid(ply) then
				APG.entUnGhost(ent, ply)
			end
		end)
		return true
	end
end
