-- save on string length and floor fields
function octologs.location(ent, arg2)

	local pos, ang
	if isvector(ent) then
		pos, ang = ent, arg2
	elseif ent:IsPlayer() then
		pos = ent:EyePos()
		ang = ent:EyeAngles()
	else
		pos = ent:GetPos()
		ang = ent:GetAngles()
	end

	pos.x = math.floor(pos.x)
	pos.y = math.floor(pos.y)
	pos.z = math.floor(pos.z)
	ang.p = math.floor(ang.p)
	ang.y = math.floor(ang.y)
	ang.r = math.floor(ang.r)

	return { pos, ang }

end

function octologs.exclude(tbl, fields)

	if fields then
		for i, v in ipairs(fields) do tbl[v] = nil end
	end
	return tbl

end

function octologs.plyData(ply, exclude)

	return octologs.exclude({
		ply = ply:SteamID(),
		hp = ply:Health() .. '%',
		ar = ply:Armor() .. '%',
		loc = octologs.location(ply),
		job = team.GetName(ply:Team()),
		wep = octologs.wepName(ply:GetActiveWeapon()),
	}, exclude)

end

function octologs.ply(ply, exclude)

	if not IsValid(ply) then return 'invalid player' end
	return { ply:Name(), octologs.plyData(ply, exclude) }

end

function octologs.entData(ent, exclude)

	return octologs.exclude({
		mdl = ent:GetModel(),
		loc = octologs.location(ent),
	}, exclude)

end

function octologs.ent(ent, exclude)

	if not IsValid(ent) then return 'invalid entity' end
	return { ent:GetClass(), octologs.entData(ent, exclude) }

end

local function percent(cur, max)
	return math.Round(cur / max * 100) .. '%'
end

function octologs.veh(ent, exclude)

	if not IsValid(ent) then return 'invalid vehicle' end

	local toReturn = {}

	local owner = ent:CPPIGetOwner()
	if IsValid(owner) then
		toReturn[#toReturn + 1] = octologs.ply(owner, {'job', 'loc', 'hp', 'wep'})
		toReturn[#toReturn + 1] = '\'s '
	end

	local cdData = ent.cdData
	toReturn[#toReturn + 1] = { cdData and (cdData.name or cdData.class) or ent:GetClass(), octologs.exclude({
		mdl = ent:GetModel(),
		loc = octologs.location(ent),
		fuel = ent.GetFuel and percent(ent:GetFuel(), ent:GetMaxFuel()) or nil,
		hp = ent.GetCurHealth and percent(ent:GetCurHealth(), ent:GetMaxHealth()) or nil,
	}, exclude) }

	return unpack(toReturn)

end

function octologs.wepName(wep)

	if not isentity(wep) or not IsValid(wep) then return 'None' end

	local class = wep:GetClass()
	local tbl = wep.GetTable and wep:GetTable()
	if istable(tbl) then
		return tbl.PrintName or tbl.Name or class
	end

	return class

end

function octologs.wep(wep)

	if not IsValid(wep) or not wep:IsWeapon() then return 'invalid weapon' end
	return octologs.wepName(wep)

end

function octologs.string(str)

	return str

end

function octologs.table(name, t, withKeys)

	if not istable(t) then return 'invalid table' end

	local data = {}
	if withKeys then
		for k, v in pairs(t) do
			data[#data + 1] = ('%s: %s'):format(k, v)
		end
	else
		for k, v in pairs(t) do
			data[#data + 1] = tostring(v)
		end
	end

	return { name, {
		tbl = data
	}}

end

netstream.Hook('octologs.goto', function(ply, pos, ang)

	if not ply:query('DBG: Телепорт по команде') then
		ply:Notify('warning', 'Нет доступа')
		return
	end

	ply.sg_LastPosition = ply:GetPos()
	ply.sg_LastAngles = ply:GetAngles()
	ply:SetPos(pos - Vector(0, 0, 64))
	ply:SetEyeAngles(ang)
	ply:Notify('Чтобы вернуться обратно, выполни команду "~return"')

end)
