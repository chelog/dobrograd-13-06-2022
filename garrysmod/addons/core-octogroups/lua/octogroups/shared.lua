--[[
	OCTOGROUPS
	by chelog

	code notes:
	sID = SteamID, gID = GroupID
]]

og = og or {}
og.groups = og.groups or {}

octolib.server('sv_data')
octolib.server('sv_group')
octolib.server('sv_rank')
octolib.server('sv_member')
octolib.server('sv_controls')
octolib.server('sv_player')

octolib.client('cl_main')
octolib.client('cl_panel')

local tab, _ = file.Find('octogroups/tabs/*.lua', 'LUA')
for i, t in ipairs(tab) do
	octolib.client('octogroups/tabs/' .. t:sub(1, -5))
end

local _, groups = file.Find('octogroups/groups/*', 'LUA')
for i, g in ipairs(groups) do
	octolib.shared('octogroups/groups/' .. g .. '/group')
end
