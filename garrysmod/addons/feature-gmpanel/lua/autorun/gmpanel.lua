octolib.client('gmpanel/cl_init')
octolib.server('gmpanel/sv_init')
octolib.client('gmpanel/cl_quick')
octolib.client('gmpanel/cl_groups')
octolib.client('gmpanel/cl_scenarios')
octolib.module('gmpanel/global')
octolib.client('gmpanel/actions/cl_actions')

local _, actions = file.Find('gmpanel/actions/*', 'LUA')
for _,act in ipairs(actions) do
	octolib.module('gmpanel/actions/' .. act)
end
