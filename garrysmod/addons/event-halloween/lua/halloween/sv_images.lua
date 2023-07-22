local reward = 1000 -- sweets

octolib.notify.registerType('addSweets', {
	function()
		return 'Получить', function(ply, data)
			if not ply.halloweenTheme then
				return ply:Notify('warning', 'А как же хэллоуинское настроение? Активируй его во вкладке "Хэллоуин" в F4-меню!')
			end
			ply:AddSweets(data.v)
			return true
		end
	end,
})

local windowsCount = {
	12, -- Йорк 3
	10, -- Йорк 9
	9, -- Йорк 13
	11, -- Ирвин 1
	6, -- Ирвин 3
	8, -- Ирвин 4
	7, -- Ирвин 8
	6, -- Ирвин 9
	8, -- Ирвин 10
	5, -- Ирвин 13
	10, -- Рурк 1
	28, -- Рурк 8
	11, -- Джойс 3
	12, -- Джойс 5
	6, -- Джойс 6
	8, -- Джойс 8
	11, -- Джойс 10
	6, -- Джойс 13
	9, -- Джойс 15
	9, -- Стефан 2
}
local images = {1, 2, 3, 4, 5, 6, 7, 8} -- for definitions, see cl_config

local function randomImages()

	-- generate images
	octolib.array.shuffle(images)

	-- generate positions
	local response = {}
	for i, v in RandomPairs(windowsCount) do
		response[#response + 1] = {i, math.random(v), images[#response + 1]} -- house id, window id, image id
		if #response == 4 then break end
	end

	return response
end

local function generatePlayerImages(sid64, callback)
	local images = randomImages()
	octolib.db:PrepareQuery([[INSERT INTO ]] .. CFG.db.main .. [[.halloween_images (steamid64, data) VALUES (?, ?)]], {sid64, util.TableToJSON(images):replace('.0', '')}, function()
		callback(images)
	end)
end

function halloween.getPlayerImages(ply, callback)
	local sid64 = ply:SteamID64()
	octolib.db:PrepareQuery([[SELECT data FROM ]] .. CFG.db.main .. [[.halloween_images WHERE steamid64=?]], {sid64}, function(q, st, res)
		if not istable(res) or not res[1] then
			generatePlayerImages(sid64, callback)
		else callback(util.JSONToTable(res[1].data)) end
	end)
end

hook.Add('dbg-char.firstSpawn', 'dbg-halloween.images', function(ply)
	if game.GetMap() ~= 'rp_eastcoast_v4c' then return end
	halloween.getPlayerImages(ply, function(imgs)
		if IsValid(ply) then netstream.Start(ply, 'dbg-halloween.images', imgs) end
	end)
end)

hook.Add('octolib.event:halloween.done', 'dbg-halloween.images', function(data)
	octolib.notify.send(util.SteamIDFrom64(data.user), 'addSweets', 'Тебе прислали конфеты. Забери их в F4', {
		text = ('Тебе прислали %s %s'):format(reward, octolib.string.formatCount(reward, 'конфету', 'конфеты', 'конфет')),
		v = reward,
	})
end)

hook.Add('PlayerCanOOC', 'dbg-halloween.images', function(_, txt)
	if txt:find('spooky.wani4ka.ru', 1, true) then
		return false, 'Пожалуйста, не распространяй эту ссылку в общих чатах. Лучше отправь ее в личные сообщения тому, кто ее попросил, или в локальный OOC-чат своим друзьям'
	end
end)
