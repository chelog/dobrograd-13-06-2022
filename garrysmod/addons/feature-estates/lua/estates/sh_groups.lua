dbgDoorGroups = dbgDoorGroups or {}
dbgDoorGroups.groups = dbgDoorGroups.groups or {}

function dbgDoorGroups.registerGroup(id, name)
	if not isstring(id) then return end
	name = tostring(name)
	id = string.lower(id)
	dbgDoorGroups.groups[id] = name
end

-- DEFAULT
hook.Add('Think', 'dbg-groups', function()
	hook.Remove('Think', 'dbg-groups')
	dbgDoorGroups.registerGroup('police', 'Полиция')
end)
