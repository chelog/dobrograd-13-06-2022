-------------------------------------------
--
-- OCTOINV by Octothorp Team
--
-- Designed to be used in our own projects.
-- Do not offer me to sell this addon.
--
-------------------------------------------

octoinv = octoinv or {}
octoinv.debug = true

function octoinv.msg(txt, ...)
	print('[# INV] ' .. os.date('%H:%M:%S - ', os.time()) .. string.format(txt, ...))
end

function octoinv.debugmsg(txt, ...)
	if not octoinv.debug then return end
	octoinv.msg(txt, ...)
end

file.CreateDir('octoinv')

-- core
octolib.server('octoinv/core/sv_octoinv')
octolib.server('octoinv/core/sv_map')
octolib.server('octoinv/core/sv_control')
octolib.server('octoinv/core/sv_hooks')
octolib.server('octoinv/core/sv_loot')
octolib.client('octoinv/core/cl_octoinv')
octolib.client('octoinv/core/cl_help')

-- craft
octolib.server('octoinv/craft/sv_craft')
octolib.server('octoinv/craft/sv_prod')
octolib.client('octoinv/craft/cl_preview')

-- shop
octolib.server('octoinv/shop/sv_shop')
octolib.server('octoinv/shop/sv_control')
octolib.client('octoinv/shop/cl_shop')

-- market
octolib.shared('octoinv/market/sh_market')
octolib.server('octoinv/market/sv_market')
octolib.server('octoinv/market/sv_orders_stack')
octolib.server('octoinv/market/sv_orders_nostack')
octolib.server('octoinv/market/sv_retain')
octolib.server('octoinv/market/sv_control')
octolib.client('octoinv/market/cl_market')

-- collect
octolib.server('octoinv/collect/sv_collect')

--admin
octolib.server('octoinv/admin/sv_give')
octolib.server('octoinv/admin/sv_control')
octolib.server('octoinv/admin/sv_stats')
octolib.client('octoinv/admin/cl_give')
octolib.client('octoinv/admin/cl_mapeditor')
octolib.client('octoinv/admin/cl_stats')

octolib.server('octoinv/sv_tests')

local function load(path)
	local fs, _ = file.Find(path .. '*.lua', 'LUA')
	for _, f in pairs(fs) do
		local fname = path .. f:sub(1, -5)
		octolib.server(fname)
	end
end

load('config/octoinv/items/')
load('config/octoinv/craft/')
load('config/octoinv/shop/')
load('config/octoinv/prod/')
load('config/octoinv/market/')
load('config/octoinv/collect/')
