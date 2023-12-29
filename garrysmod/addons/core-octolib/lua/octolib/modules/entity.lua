octolib.entity = octolib.entity or {}

function octolib.whenNotNull(ents, func, timeout)

	local tName = 'wnn' .. tostring(ents)

	local cache = {}
	for i = 1, #ents do cache[i] = i end

	for i = #cache, 1, -1 do
		local ent = ents[cache[i]]
		if IsValid(ent) then
			func(ent, cache[i])
			table.remove(cache, i)
		end
	end

	if #cache < 1 then
		hook.Remove('pon.entityCreated', tName)
	end

	hook.Add('pon.entityCreated', tName, function(ent, tbl, key)
		if tbl ~= ents then return end

		func(ent, key)
		table.RemoveByValue(cache, key)

		if #cache < 1 then
			cache = nil
			hook.Remove('pon.entityCreated', tName)
		end
	end)

	if timeout then
		timer.Create(tName, timeout, 1, function()
			cache = nil
			hook.Remove('pon.entityCreated', tName)
		end)
	end

end

function octolib.entity.dummyTrace(ent)
	local pos = ent:GetPos()
	return {
		FractionLeftSolid = 0,
		HitNonWorld       = true,
		Fraction          = 0,
		Entity            = ent,
		HitPos            = pos,
		HitNormal         = Vector(0,0,0),
		HitBox            = 0,
		Normal            = Vector(1,0,0),
		Hit               = true,
		HitGroup          = 0,
		MatType           = 0,
		StartPos          = pos,
		PhysicsBone       = 0,
		WorldToLocal      = Vector(0,0,0),
	}
end

local entityMeta = FindMetaTable 'Entity'

entityMeta.SetBodygroup = octolib.func.detour(
	entityMeta.SetBodygroup,
	'Entity:SetBodyGroup',
	function(original, ent, bgID, val)
		if hook.Run('EntityBodygroupChange', ent, bgID, val) == true then return end
		original(ent, bgID, val)
	end
)

entityMeta.SetSubMaterial = octolib.func.detour(
	entityMeta.SetSubMaterial,
	'Entity:SetSubMaterial',
	function(original, ent, index, material)
		if hook.Run('EntitySubMaterialChange', ent, index, material) == true then return end
		original(ent, index, material)
	end
)