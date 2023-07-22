octochat.commands = octochat.commands or {}
octochat.permissions = octochat.permissions or {}

local function addPermission(perm)
	if not serverguard then octochat.permissions[#octochat.permissions + 1] = perm
	else serverguard.permission:Add(perm) end
end
hook.Add('Think', 'octochat.loadPerms', function()
hook.Remove('Think', 'octochat.loadPerms')
for _, v in ipairs(octochat.permissions) do
	serverguard.permission:Add(v)
end
octochat.permissions = {}
end)

function octochat.defineCommand(name, data)
	octochat.commands[name] = data
	if istable(data) then data.name = name end
	for _, v in ipairs(istable(data) and data.aliases or {}) do
		octochat.commands[v] = data
	end
	if not istable(data) then return end
	if data.permission then addPermission(data.permission) end
	if data.cooldownBypass then addPermission(data.cooldownBypass) end
end
hook.Run('octochat.registerCommands')
