local stationIdSymbols = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'

local function id(station)
	return station.id
end
local function escape(str)
	return octolib.db:escape(str)
end

octochat.registerCommand('!radio', {
	aliases = {'~radio', '/radio'},
	check = DarkRP.isSuperAdmin,
	log = true,
	execute = function(ply)
		if ply.radioCollecting then return 'Команда еще в работе' end

		ply.radioCollecting = true

		octolib.func.chain({

			function(nxt)
				local response, offset, first = {}, 0, true
				octolib.func.loop(function(again, stations)
					if not IsValid(ply) then return end

					if istable(stations) then
						for _, v in ipairs(stations) do
							response[#response + 1] = v
						end
						offset = offset + #stations
						if #stations < 25 then return nxt(response) end
					elseif not first then
						return nxt(response)
					end
					first = false

					octoradio.getByPlace('Dobrograd MI', 'United States', offset, again)
				end)
			end,

			function(nxt, stations)
				local response, page = {}, 1
				octolib.func.loop(function(again, ans)
					if not IsValid(ply) then return end

					if ans then
						if not istable(ans) then return nxt(response) end
						for _, v in ipairs(ans) do
							response[#response + 1] = v
						end
						if #ans < 25 then return nxt(response) end
					end

					octoradio.getById(octolib.table.mapSequential(octolib.array.page(stations, 25, page), id), again)
				end)
			end,

			function(nxt, stations)
				ply.radioCollecting = nil
				for _, v in ipairs(stations) do
					v.placeId, v.placeName, v.country = nil
					v.id = v.id:sub(3)
				end
				octolib.entries.gui(ply, 'Радиостанции', {
					fields = {
						id = {
							name = 'Идентификатор',
							desc = '6 латинских символов и цифр. Должен быть уникальным',
							type = 'strShort',
							len = 6,
							required = true,
						},
						title = {
							name = 'Название',
							type = 'strShort',
							len = 50,
							required = true,
						},
						playbackUrl = {
							name = 'Ссылка',
							desc = 'Прямая ссылка на онлайн-стрим. Если сомневаешься, обратись к разработчикам',
							type = 'strShort',
							len = 255,
							required = true,
						},
					},
					labelIndex = 'title',
					entries = stations,
					maxEntries = 1000,
				}, function(res)

					if not istable(res) then return end
					local stations = {}
					local ids = {}

					for i, v in ipairs(res) do

						local title = v.title
						if not (title and octolib.math.inRange(utf8.len(title), 4, 50)) then
							ply:Notify('warning', ('Запись #%i: неправильное название (%s)'):format(i, tostring(title)))
							return
						end

						local id = v.id
						if not (id and utf8.len(id) == 6) then
							ply:Notify('warning', ('Запись #%i (%s): длина идентификатора не равна 6'):format(i, tostring(title)))
							return
						end
						if id:find('[^' .. stationIdSymbols .. ']') then
							ply:Notify('warning', ('Запись #%i: (%s): в идентификаторе есть неподходящие символы'):format(i, tostring(title)))
							return
						end
						if ids[id] then
							ply:Notify('warning', ('Запись #%i: (%s): идентификатор уже использовался в записи #%i (%s)')
								:format(i, tostring(title), ids[i][1], tostring(ids[i][2]))
							)
							return
						end
						ids[id] = { #stations, name }

						local playbackUrl = v.playbackUrl
						if not (playbackUrl and playbackUrl:len() <= 255 and octolib.string.isUrl(playbackUrl)) then
							ply:Notify('warning', ('Запись #%i: (%s): неверная ссылка'):format(i, tostring(title)))
						end

						stations[#stations + 1] = ('(\'%s\',\'%s\',\'%s\',\'%s\',\'%s\',\'%s\')'):format(unpack(octolib.table.mapSequential({
							'##' .. id, title, '########', 'Dobrograd MI', 'United States', playbackUrl
						}, escape)))
					end

					nxt(stations)
				end)
			end,

			function(nxt, q)
				octolib.db:RunQuery([[DELETE FROM `dbg_radio` WHERE `id` LIKE '##%']], function()
					nxt(q)
				end)
			end,

			function(nxt, q)
				local qSize = #q
				local iMax = math.ceil(qSize / 10)
				for i = 1, iMax do
					local values = table.concat(q, ',', (i-1) * 10 + 1, math.min(i * 10, qSize))
					local query = [[REPLACE INTO `dbg_radio` (`id`, `title`, `placeId`, `placeName`, `country`, `playbackUrl`) VALUES ]] .. values
					if i == iMax then
						octolib.db:RunQuery(query, nxt)
					else
						octolib.db:RunQuery(query)
					end
				end
			end,

			function()
				hook.Run('octoradio.updated')
				if IsValid(ply) then
					ply:Notify('hint', 'Радиостанции сохранены')
				end
			end,
		})

	end,
})
