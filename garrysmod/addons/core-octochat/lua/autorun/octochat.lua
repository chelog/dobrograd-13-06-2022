octochat = octochat or {}

octolib.module('octochat')
octolib.client('octochat/cl_notifications')

octolib.module('octochat/commands')
local _, cmds = file.Find('config/octochat-commands/*', 'LUA')
for _, t in ipairs(cmds) do
	octolib.module('config/octochat-commands/' .. t)
end
