
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


local MsgC = MsgC
local SysTime = SysTime
local timeStart = SysTime()

MsgC('[DLib] Initializing DLib clientside ... ')

-- DLib.Loader.start('Notify', true)
-- DLib.Loader.include('dlib/modules/notify/client/cl_init.lua')
-- DLib.Loader.finish(false)

function DLib.GetSkin()
	return 'DLib_Black'
end

-- DLib.Loader.start('HUDCommons')
-- DLib.Loader.loadPureCSTop('dlib/modules/hudcommons')
-- DLib.simpleInclude('modules/hudcommons/base/init.lua')
-- DLib.Loader.finish()

DLib.Loader.loadPureCS('dlib/vgui')
DLib.simpleInclude('util/client/scrsize.lua')
DLib.simpleInclude('util/client/chat.lua')
DLib.simpleInclude('util/client/buystuff.lua')
DLib.simpleInclude('util/client/ttfreader.lua')
DLib.simpleInclude('util/client/matnotify.lua')
DLib.simpleInclude('util/client/blur.lua')

DLib.Loader.loadPureCSTop('dlib/modules/client')

MsgC(string.format('%.2f ms\n', (SysTime() - timeStart) * 1000))
timeStart = SysTime()
MsgC('[DLib] Running addons ... \n')

if not VLL_CURR_FILE and not VLL2_FILEDEF then
	DLib.Loader.loadPureSHTop('dlib/autorun')
	DLib.Loader.loadPureCSTop('dlib/autorun/client')
end

MsgC(string.format('[DLib] Addons were initialized in %.2f ms\n', (SysTime() - timeStart) * 1000))

timeStart = SysTime()
MsgC('[DLib] Loading translations for i18n ... ')

DLib.i18n.reload()

concommand.Add('dlib_reload_i18n_cl', function(ply)
	timeStart = SysTime()
	DLib.Message('Reloading translations for i18n ... ')
	DLib.i18n.reload()
	hook.Run('DLib.TranslationsReloaded')
	DLib.Message(string.format('i18n reload took %.2f ms', (SysTime() - timeStart) * 1000))
end)

hook.Run('DLib.TranslationsReloaded')

MsgC(string.format('%.2f ms\n', (SysTime() - timeStart) * 1000))

MsgC('---------------------------------------------------------------\n')
