
-- Copyright (C) 2017-2020 DBotThePony

-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
-- of the Software, and to permit persons to whom the Software is furnished to do so,
-- subject to the following conditions:

-- The above copyright notice and this permission notice shall be included in all copies
-- or substantial portions of the Software.

-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
-- INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
-- PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
-- FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
-- OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
-- DEALINGS IN THE SOFTWARE.


local DLib = DLib

DLib.DEBUG_MODE = CreateConVar('dlib_debug', '0', {FCVAR_REPLICATED}, 'Enable debug mode. Setting this to 1 can help you solve weird bugs.')
DLib.STRICT_MODE = CreateConVar('dlib_strict', '0', {FCVAR_REPLICATED}, 'Enable strict mode. Enabling this turns all ErrorNoHalts into execution halting errors. The best way to fix bad code.')

function DLib.simpleInclude(fil)
	if SERVER then AddCSLuaFile('dlib/' .. fil) end
	return include('dlib/' .. fil)
end

local startupText = [[
	___  _    _ ___
	|  \ |    | |__]
	|__/ |___ | |__]

	____ ____ ___  ____ ____ _ _  _ _ _  _ ____
	|__/ |___ |  \ |___ |___ | |\ | | |\ | | __
	|  \ |___ |__/ |___ |    | | \| | | \| |__]

	____ _    _  _ ____
	| __ |    |  | |__|
	|__] |___ |__| |  |

]]

local startupText2 = [[
	___  _    _ ___
	|  \ |    | |__]
	|__/ |___ | |__]

	___  ____ ____ ____ _  _ _ _  _ ____
	|__] |__/ |___ |__| |_/  | |\ | | __
	|__] |  \ |___ |  | | \_ | | \| |__]

	_   _ ____ _  _ ____
	 \_/  |  | |  | |__/
	  |   |__| |__| |  \

	____ _  _ _ ___
	[__  |__| |  |
	___] |  | |  |

	___ _  _
	 |  |\/|
	 |  |  |

]]

MsgC('---------------------------------------------------------------\n')

if math.random() > 0.1 then
	for line in string.gmatch(startupText, '(.-)\r?\n') do
		MsgC(line .. '\n')
	end
else
	for line in string.gmatch(startupText2, '(.-)\r?\n') do
		MsgC(line .. '\n')
	end
end

local MsgC = MsgC
local SysTime = SysTime
local timeStart = SysTime()

MsgC('---------------------------------------------------------------\n')
MsgC('[DLib] Initializing DLib core ... ')

DLib.simpleInclude('core/core.lua')
DLib.simpleInclude('core/luaify.lua')
DLib.simpleInclude('core/funclib.lua')
DLib.simpleInclude('modules/color.lua')
DLib.MessageMaker = DLib.simpleInclude('util/message.lua')
DLib.MessageMaker(DLib, 'DLib')
DLib.simpleInclude('core/sandbox.lua')
DLib.simpleInclude('core/promise.lua')

if jit then
	if SERVER then
		AddCSLuaFile('dlib/core/vmdef.lua')
		AddCSLuaFile('dlib/core/vmdef_x64.lua')
	end

	if jit.arch == 'x86' then
		local vmdef = CompileFile('dlib/core/vmdef.lua')
		jit.vmdef = nil
		vmdef('jit_vmdef')
		jit.vmdef = jit_vmdef
	elseif jit.arch == 'x64' then
		jit.vmdef = include('dlib/core/vmdef_x64.lua')
	end
end

DLib.CMessage = DLib.MessageMaker
DLib.ConstructMessage = DLib.MessageMaker

DLib.simpleInclude('util/combathelper.lua')
DLib.simpleInclude('util/util.lua')
DLib.simpleInclude('util/vector.lua')

DLib.node = DLib.simpleInclude('util/node.lua')

if CLIENT then
	DLib.simpleInclude('util/client/localglobal.lua')
end

file.mkdir('dlib')

DLib.simpleInclude('core/tableutil.lua')
DLib.simpleInclude('core/fsutil.lua')
DLib.simpleInclude('core/loader.lua')
DLib.simpleInclude('core/loader_modes.lua')

MsgC(string.format('%.2f ms\n', (SysTime() - timeStart) * 1000))
timeStart = SysTime()
MsgC('[DLib] Initializing DLib GLua extensions ... ')

DLib.Loader.shmodule('bitworker.lua')

DLib.simpleInclude('luabridge/luaify.lua')

DLib.simpleInclude('extensions/extensions.lua')
DLib.simpleInclude('extensions/string.lua')
DLib.simpleInclude('extensions/ctakedmg.lua')
DLib.simpleInclude('extensions/cvar.lua')
DLib.simpleInclude('extensions/entity.lua')
DLib.simpleInclude('extensions/render.lua')
DLib.simpleInclude('extensions/player.lua')

DLib.Loader.shmodule('hook.lua')
DLib.simpleInclude('luabridge/luaify2.lua')
DLib.simpleInclude('luabridge/lobject.lua')

DLib.simpleInclude('util/http.lua')
DLib.simpleInclude('util/httpclient.lua')
DLib.simpleInclude('util/promisify.lua')

MsgC(string.format('%.2f ms\n', (SysTime() - timeStart) * 1000))
timeStart = SysTime()
MsgC('[DLib] Initializing DLib modules ... ')

DLib.Loader.shmodule('luavector.lua')
DLib.Loader.shmodule('net_ext.lua')
DLib.Loader.shmodule('bytesbuffer.lua')
DLib.Loader.shmodule('nbt.lua')
DLib.Loader.shmodule('gobjectnotation.lua')
DLib.Loader.shmodule('lerp.lua')
DLib.Loader.shmodule('sh_cami.lua')
DLib.Loader.shmodule('getinfo.lua')
DLib.Loader.shmodule('predictedvars.lua')

DLib.Loader.start('nw')
DLib.Loader.load('dlib/modules/nwvar')
DLib.Loader.finish()

DLib.simpleInclude('util/queue.lua')

DLib.Loader.loadPureSHTop('dlib/enums')

MsgC(string.format('%.2f ms\n', (SysTime() - timeStart) * 1000))
timeStart = SysTime()
MsgC('[DLib] Initializing DLib classes ... ')

DLib.Loader.shclass('astar.lua')
DLib.Loader.shclass('dmginfo.lua')
DLib.Loader.shclass('collector.lua')
DLib.Loader.shclass('set.lua')
DLib.Loader.shclass('freespace.lua')
DLib.Loader.shclass('cvars.lua')
DLib.Loader.shclass('rainbow.lua')
DLib.Loader.shclass('camiwatchdog.lua')
DLib.Loader.shclass('measure.lua')
DLib.Loader.shclass('bezier.lua')
DLib.Loader.shclass('predictedvars.lua')
DLib.Loader.clclass('keybinds.lua')

DLib.Loader.start('i18n')
DLib.Loader.load('dlib/modules/i18n')
DLib.Loader.finish()

DLib.Loader.start('friends', true)
DLib.Loader.load('dlib/modules/friendsystem')
DLib.Loader.finish()

if CLIENT then
	DLib.VGUI = DLib.VGUI or {}
end

MsgC(string.format('%.2f ms\n', (SysTime() - timeStart) * 1000))
timeStart = SysTime()
MsgC('[DLib] Initializing DLib LuaBridge ... ')

DLib.simpleInclude('luabridge/luabridge.lua')
DLib.simpleInclude('luabridge/physgunhandler.lua')
DLib.simpleInclude('luabridge/loading_stages.lua')
DLib.simpleInclude('luabridge/savetable.lua')
DLib.Loader.loadPureSHTop('dlib/modules/workarounds')

DLib.hl2wdata = DLib.simpleInclude('data/hl2sweps.lua')

MsgC(string.format('%.2f ms\n', (SysTime() - timeStart) * 1000))
