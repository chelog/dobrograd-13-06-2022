local entMeta = FindMetaTable('Entity')
local phyMeta = FindMetaTable('PhysObj')

entMeta.SetRealPos = entMeta.SetRealPos or entMeta.SetPos
phyMeta.SetRealPos = phyMeta.SetRealPos or phyMeta.SetPos

local abs = math.abs
local function setPos(obj, pos)

	if abs(pos.x) > 50000 or abs(pos.y) > 50000 or abs(pos.z) > 50000 then
		pos = Vector()
	end

	obj:SetRealPos(pos)

end

entMeta.SetPos = setPos
phyMeta.SetPos = setPos
