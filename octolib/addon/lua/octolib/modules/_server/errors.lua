if CFG.disabledModules.errors then return end

require 'luaerror'

luaerror.EnableRuntimeDetour(true)
luaerror.EnableCompiletimeDetour(true)
luaerror.EnableClientDetour(true)

local function formatError(fullerror, stack)
	return table.concat({ fullerror, unpack(octolib.table.mapSequential(stack, function(e, i)
		return ('%s. %s:%s'):format(i, e.short_src, e.currentline)
	end)) }, '\n    ')
end

hook.Add('LuaError', 'octolib.errors', function(isruntime, fullerror, sourcefile, sourceline, errorstr, stack)
	hook.Run('octolib.error', formatError(fullerror, stack))
end)

hook.Add('ClientLuaError', 'octolib.errors', function(player, fullerror, sourcefile, sourceline, errorstr, stack)
	hook.Run('octolib.error', formatError(fullerror, stack), player)
end)

-- local errors = {}
-- if errors[msg] then
-- 	errors[msg].count = errors[msg].count + 1
-- 	errors[msg].last = os.time()
-- else
-- 	local txt, cl = msg:sub(2), false
-- 	if lastmsg:find('|STEAM_') then
-- 		txt = lastmsg .. txt
-- 		cl = true
-- 		for path in string.gmatch(txt, '%-%s.-%.lua') do
-- 			if not file.Exists(path:sub(3), 'GAME') then return end
-- 		end
-- 	end

-- 	errors[msg] = {
-- 		txt = txt,
-- 		client = cl,
-- 		count = 1,
-- 		last = os.time(),
-- 	}
-- end

-- timer.Create('octolib-errors', 60, 0, function()

-- 	local date = os.date('*t', os.time())
-- 	if date.hour == 4 and date.min == 55 then
-- 		local i = 0
-- 		for k, v in pairs(errors) do
-- 			timer.Simple(i * 2, function()
-- 				octoservices:post('/discord/webhook/' .. CFG.webhooks.error, {
-- 						content = '<@153885767230291968>',
-- 						embeds = {{
-- 							title = v.client and 'Клиентсайд ошибка' or 'Серверсайд ошибка',
-- 							description = v.txt,
-- 							fields = {
-- 								{name = 'Сервер', value = string.format('%s (%s)', GetHostName(), game.GetIPAddress())},
-- 								{name = 'Раз за день', value = tostring(v.count), inline = true},
-- 								{name = 'Последняя', value = os.date('%d/%m/%Y в %H:%M', v.last), inline = true},
-- 							},
-- 						}},
-- 				})
-- 			end)
-- 			i = i + 1
-- 		end

-- 		errors = {}
-- 	end

-- end)
