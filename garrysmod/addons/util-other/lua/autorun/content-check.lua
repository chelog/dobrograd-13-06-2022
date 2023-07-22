local unwantedAddons = octolib.array.toKeys({
	'2437373117', -- gta4 cars
	'2429099714', -- gta4 cars - shared
	'2468527592', -- gta4 cars - hq
	'757604550', -- wos
	'2143558752', -- xdreanims
})

if SERVER then

	local addonsText = {
		'Кажется, у тебя установлены аддоны, которые могут конфликтовать с нашими: вероятнее всего, некоторый контент будет отображаться неправильно',
		'Чтобы исправить эту проблему, отпишись от этих аддонов:',
	}

	hook.Add('dbg-char.spawn', 'dbg.contentCheck', function(ply)
		if ply.contentWarned then return end
		ply.contentWarned = true

		timer.Simple(5, function()
			if not IsValid(ply) then return end
			netstream.Request(ply, 'dbg.contentCheck'):Then(function(res)
				if not istable(res) then return end
				if res.addons[1] then
					for _, text in ipairs(addonsText) do
						octochat.talkTo(ply, color_red, text)
					end
					for _, addonName in ipairs(res.addons) do
						octochat.talkTo(ply, Color(250,250,200), '• ' .. addonName)
					end
				end
				if res.lowpoly ~= 0 then
					octochat.talkTo(ply, color_red, (res.addons[1] and 'Также, у' or 'У') .. 'станови качество моделей на "Высокое" в настройках графики игры, чтобы исправить отображение автомобилей. Эта настройка незначительно влияет на производительность')
				end
			end)
		end)
	end)

else
	netstream.Listen('dbg.contentCheck', function(reply)
		local addons = engine.GetAddons()
		local unwanted = {}
		for _, v in ipairs(addons) do
			if unwantedAddons[v.wsid] then
				unwanted[#unwanted + 1] = ('%s (%s)'):format(v.title, v.wsid)
			end
		end
		reply({
			addons = unwanted,
			lowpoly = GetConVar('r_rootlod'):GetInt(),
		})
	end)
end
