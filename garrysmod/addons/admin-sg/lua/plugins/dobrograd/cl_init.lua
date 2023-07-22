local plugin = plugin;

plugin:IncludeFile('shared.lua', SERVERGUARD.STATE.CLIENT);
plugin:IncludeFile('sh_commands.lua', SERVERGUARD.STATE.CLIENT);
plugin:IncludeFile('sh_drp_commands.lua', SERVERGUARD.STATE.CLIENT);

local custom = {}

local function clean()
	custom = {}
	for i = #L.warns_list, 1, -1 do
		local warn = L.warns_list[i]
		if warn[4] == 'custom' then
			L.warns_list[i] = nil
		else break end
	end

end

clean()

local data = file.Read('dbg_admintells.dat')
if data then data = pon.decode(data) end
if data then
	for i, warn in ipairs(data) do
		L.warns_list[#L.warns_list + 1] = warn
		custom[#custom + 1] = warn
	end
end

function serverguard.editAdminTell()

	octolib.entries.gui('Настройка уведомлений', {
		fields = {
			{
				name = 'Название',
				type = 'strShort',
				len = 32,
				default = 'Новое уведомление',
			},
			{
				name = 'Длительность (сек)',
				type = 'numSlider',
				min = 5,
				max = 90,
				dec = 0,
				default = 15,
			},
			{
				name = 'Текст сообщения',
				type = 'strLong',
				len = 512,
				tall = 215,
			},
		},
		labelIndex = 1,
		entries = custom,
		maxEntries = 25,
	}, function(res)
		clean()
		for _,v in ipairs(res) do
			v[4] = 'custom'
			L.warns_list[#L.warns_list + 1] = v
		end
		custom = res
		file.Write('dbg_admintells.dat', pon.encode(res))
	end)

end
