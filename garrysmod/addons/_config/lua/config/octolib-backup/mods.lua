-- position
octolib.registerBackupMod('l', function(ply)
	return { ply:GetPos(), ply:GetAngles() }
end, function(ply, data)
	local pos, ang = unpack(data)
	ply:SetPos(pos)
	ply:SetAngles(ang)
end)

-- health
octolib.registerBackupMod('h', function(ply)
	return { ply:Health(), ply:Armor() }
end, function(ply, data)
	local hp, armor = unpack(data)
	ply:SetHealth(hp)
	ply:SetArmor(armor)
end)

-- movetype
-- octolib.registerBackupMod('mt', function(ply)
-- 	return ply:GetMoveType() == MOVETYPE_NOCLIP
-- end, function(ply, data)
-- 	if data then ply:SetMoveType(MOVETYPE_NOCLIP) end
-- end)

-- model
octolib.registerBackupMod('m', function(ply)
	local out = {}
	out.m = ply:GetModel()
	out.s = ply:GetSkin()
	out.b = {}
	for _, bg in ipairs(ply:GetBodyGroups()) do
		out.b[bg.id] = ply:GetBodygroup(bg.id)
	end

	return out
end, function(ply, data)
	if ply:GetModel() ~= data.m then
		ply:SetModel(data.m)
	end
	if ply:GetSkin() ~= data.s then
		ply:SetSkin(data.s)
	end
	for k,v in pairs(data.b or {}) do
		ply:SetBodygroup(k, v)
	end
end)

------------------------------------------------------------
-- OCTOINV
------------------------------------------------------------

-- inventory
octolib.registerBackupMod('i', function(ply)
	return ply:ExportInventory()
end, function(ply, data)
	ply:ImportInventory(data)
end)

------------------------------------------------------------
-- DOBROGRAD
------------------------------------------------------------

-- job
octolib.registerBackupMod('j', function(ply)
	return ply:getJobTable().command
end, function(ply, data)
	local _, jobID = DarkRP.getJobByCommand(data)
	if jobID then ply:changeTeam(jobID, true, true) end
end)

-- admin data
octolib.registerBackupMod('aj', function(ply)
	return ply.dbgAdmin_data
end, function(ply, data)
	ply.dbgAdmin_data = data
end)

-- police job
octolib.registerBackupMod('pj', function(ply)
	return ply:GetNetVar('dbg-police.job')
end, function(ply, data)
	ply:SetNetVar('dbg-police.job', data)
end)

-- citizen data (for police jobs)
octolib.registerBackupMod('cj', function(ply)
	return ply.dbgPolice_citizenData
end, function(ply, data)
	ply.dbgPolice_citizenData = data
end)

-- vehicle deposit
octolib.registerBackupMod('dp', function(ply)
	local veh = carDealer.getCurVeh(ply)
	if IsValid(veh) and veh.deposit then
		return veh.deposit
	end
end, function(ply, data)
	carDealer.addMoney(ply, data)
end)
