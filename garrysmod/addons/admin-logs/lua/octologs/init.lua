octolib.server('sv_octologs')
octolib.server('sv_helpers')
octolib.server('sv_log')

local fls, fds = file.Find('octologs/loggers/*.lua', 'LUA')
for i, name in ipairs(fls) do
	octolib.server('octologs/loggers/' .. name:gsub('.lua', ''))
end

octolib.client('cl_poslist')
