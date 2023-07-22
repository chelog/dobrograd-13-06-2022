-- hook.Add("Think", "InitMyOverride", function()
-- 	hook.Remove("Think", "InitMyOverride")

-- 	local PLAYER, ENTITY = FindMetaTable 'Player', FindMetaTable 'Entity'
-- 	local GetTable = ENTITY.GetTable
-- 	local GetOwner = ENTITY.GetOwner

-- 	function PLAYER:__index(key)
-- 		return PLAYER[key] or ENTITY[key] or GetTable(self)[key]
-- 	end

-- 	function ENTITY:__index(key)
-- 		if not key then return end

-- 		local res = (key == "Owner" and GetOwner(self)) or ENTITY[key]
-- 		if res ~= nil then return res end

-- 		local t = GetTable(self)
-- 		if t then return t[key] end
-- 	end

-- 	local cachedValid = {}

-- 	function IsValid(obj)
-- 		if not obj or cachedValid[obj] ~= nil then return obj and cachedValid[obj] end
-- 		local isvalid = obj.IsValid
-- 		cachedValid[obj] = isvalid and isvalid(obj) or false

-- 		return cachedValid[obj]
-- 	end

-- 	hook.Add('Think', 'flushIsValid', function()
-- 		table.Empty(cachedValid)
-- 	end)

-- end)