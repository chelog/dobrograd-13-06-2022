------------------------------------------
--
-- OCTOSHOP by Octothorp Team
--
-- Designed to be used in my own projects.
-- Do not offer me to sell this addon.
--
-- Developed and maintained by chelog,
-- telegram: t.me/chelog
-- discord: chelog#8888
-- mail: chelog@octothorp.team
--
------------------------------------------

octoshop = octoshop or {}
octoshop.debug = true

function octoshop.msg(txt)
	print('[# SHOP] ' .. os.date('%H:%M:%S - ', os.time()) .. txt)
end

function octoshop.debugmsg(txt)
	if not octoshop.debug then return end
	print('[# SHOP] ' .. os.date('%H:%M:%S - ', os.time()) .. txt)
end

-- load dependencies
if SERVER then
	require('mysqloo')

	if not mysqloo then
		local divider = ('='):rep(20)
		octoshop.msg(divider)
		octoshop.msg('ERROR: Could not detect mysqloo module! Aborting.')
		octoshop.msg(divider)
		return
	end

	if not mysqloo.CreateDatabase then include('lib/mysqloolib.lua') end
	if not mysqloo.CreateDatabase then
		local divider = ('='):rep(20)
		octoshop.msg(divider)
		octoshop.msg('ERROR: Could not detect mysqloolib! Aborting.')
		octoshop.msg(divider)
		return
	end
end

-- load files
if SERVER then
	include('config/octoshop_sv.lua')
end

local shConfig = 'config/octoshop_sh.lua'
if file.Exists(shConfig, 'LUA') then
	if SERVER then AddCSLuaFile(shConfig) end
	include(shConfig)
end

local fs, _ = file.Find('octoshop/*.lua', 'LUA')
for _, f in pairs(fs) do
	fname = 'octoshop/' .. f
	if SERVER and f:sub(1,3) == 'sv_' then
		include(fname)
	elseif f:sub(1,3) == 'cl_' then
		if SERVER then AddCSLuaFile(fname) end
		if CLIENT then include(fname) end
	elseif f:sub(1,3) == 'sh_' then
		if SERVER then AddCSLuaFile(fname) end
		include(fname)
	else
		octoshop.msg('Unknown file type: ' .. fname .. ', ignoring.')
	end
end

-- initialize
octoshop.init()
