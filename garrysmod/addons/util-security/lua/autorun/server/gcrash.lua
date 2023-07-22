if not system.IsLinux() or CFG.disableGCrash then return end

require 'gcrash'

local enable_watchdog = true

--[[
  gcrash.dumpstate()
	Manually call the crash handler, creating the luadump file and calling the lua crash handler.

  gcrash.crash()
	Artificially create a segfault.

  gcrash.sethandler(function(write_func) handler)
	Set the (optional) handler called when a segfault occurs.
	This function is called without unwinding the stack, so you can extract informations such as locals out of it.

  gcrash.startwatchdog(int time = 30)
	Start (or resume) then watchdog thread.
	If the server hangs for <time> seconds, it will force a crash with SIGABRT, creating a luadump.

  gcrash.stopwatchdog()
	Pause the watchdog thread.
]]

gcrash.sethandler(function(write)
	local function printline(s, ...) write(string.format(tostring(s or '') .. '\n', ...)) end

	local i = 2 -- Only start at frame 2, we don't need the locals of this function
	local dbg = debug.getinfo(i)
	while dbg do
		printline('Frame #%d, %s:%s:', i - 2, dbg.source, dbg.currentline)

		for j = 1, 255 do
			local n, v = debug.getlocal(i, j)
			if not n then break end
			printline('  %s = %s', tostring(n), tostring(v))
		end

		printline('')
		i = i + 1
		dbg = debug.getinfo(i)
	end

end)

gcrash.crash = nil -- You can comment this out if you want to use it (to crash your server?)

if enable_watchdog then
	if GetConVar('sv_hibernate_think'):GetBool() then
		gcrash.startwatchdog()
		print('Starting gcrash watchdog.')

		hook.Add('ShutDown', 'gcrash_watchdogsleeper', function()
			gcrash.stopwatchdog()
			print('Pausing gcrash due to Lua shutdown.')
		end)
	else
		hook.Add('PlayerInitialSpawn', 'gcrash_watchdogsleeper', function()
			if player.GetCount() > 1 then return end

			gcrash.startwatchdog()
			print('Starting gcrash watchdog...')

			hook.Add('ShutDown', 'gcrash_watchdogsleeper', function()
				gcrash.stopwatchdog()
				print('Pausing gcrash due to Lua shutdown.')
			end)
		end)

		hook.Add('PlayerDisconnected', 'testtt', function()
			if player.GetCount() > 1 then return end
			gcrash.stopwatchdog()
			print('Pausing gcrash watchdog due to no players left.')
		end)
	end
end
