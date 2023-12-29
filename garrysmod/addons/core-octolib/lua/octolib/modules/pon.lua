local pon = {}
_G.pon = pon

pon.pendingEnts = {}
function pon.queueEntsFlush() end

hook.Add('Think', 'octolib.pon.init', function()
	hook.Remove('Think', 'octolib.pon.init')

	pon.queueEntsFlush = octolib.func.debounce(function()
		table.Empty(pon.pendingEnts)
	end, 300)
end)

local type = type
local tonumber = tonumber
local format = string.format
local insert = table.insert

do
	local encode = {}

	local cacheSize = 0

	encode['table'] = function(tbl, output, cache)
		if cache[tbl] then
			insert(output, format('(%u)', cache[tbl]))
			return
		else
			cacheSize = cacheSize + 1
			cache[tbl] = cacheSize
		end

		local first = next(tbl)
		local predictedNumeric = 1

		-- starts with a sequential type
		if first == 1 then
			insert(output, '{')

			for k, v in next, tbl do
				if k == predictedNumeric then
					predictedNumeric = predictedNumeric + 1

					local tv = type(v)
					if tv == 'string' then
						local pid = cache[v]
						if pid then
							insert(output, format('(%u)', pid))
						else
							cacheSize = cacheSize + 1
							cache[v] = cacheSize
							encode.string(v, output)
						end
					elseif IsColor(v) then
						encode.Color(v, output, cache)
					else
						encode[tv](v, output, cache)
					end
				else
					break
				end
			end

			predictedNumeric = predictedNumeric - 1
		else
			predictedNumeric = nil
		end

		-- start with dictionary type
		if predictedNumeric == nil then
			insert(output, '[')
		else
			-- break sequential for dictionary
			local kv = next(tbl, predictedNumeric)
			if kv then
				insert(output, '~')
			end
		end

		for k, v in next, tbl, predictedNumeric do
			local tk, tv = type(k), type(v)

			-- WRITE KEY
			if tk == 'string' then
				local pid = cache[k]
				if pid then
					insert(output, format('(%u)', pid))
				else
					cacheSize = cacheSize + 1
					cache[k] = cacheSize

					encode.string(k, output)
				end
			elseif IsColor(k) then
				encode.Color(k, output, cache)
			else
				encode[tk](k, output, cache)
			end

			-- WRITE VALUE
			if tv == 'string' then
				local pid = cache[v]
				if pid then
					insert(output, format('(%u)', pid))
				else
					cacheSize = cacheSize + 1
					cache[v] = cacheSize

					encode.string(v, output)
				end
			elseif IsColor(v) then
				encode.Color(v, output, cache)
			else
				encode[tv](v, output, cache)
			end
		end

		insert(output, '}')
	end
	--	ENCODE STRING
	local gsub = string.gsub
	encode['string'] = function(str, output)
		local estr, count = gsub(str, ';', '\\;')
		if count == 0 then
			insert(output, '\'' .. str .. ';')
		else
			insert(output, '"' .. estr .. '";')
		end
	end
	local b62alphabet = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'
	local function b62encode(num)
		if num < 0 then num = -num end
		local str = ''
		while num > 0 do
			str = str .. b62alphabet[num % 62 + 1]
			num = math.floor(num / 62)
		end
		return string.reverse(str)
	end
	--	ENCODE NUMBER
	encode['number'] = function(num, output)
		if num % 1 == 0 then
			insert(output, (num < 0 and 'y' or 'Y') .. b62encode(num) .. ';')
		else
			insert(output, tonumber(num) .. ';')
		end
	end
	--	ENCODE BOOLEAN
	encode['boolean'] = function(val, output)
		insert(output, val and 't' or 'f')
	end
	--	ENCODE VECTOR
	encode['Vector'] = function(val, output)
		insert(output, 'v' .. val.x .. ',' .. val.y .. ',' .. val.z .. ';')
	end
	--	ENCODE COLOR
	encode['Color'] = function(val, output)
		insert(output, 'l' .. val.r .. ',' .. val.g .. ',' .. val.b .. ',' .. val.a .. ';')
	end
	--	ENCODE ANGLE
	encode['Angle'] = function(val, output)
		insert(output, 'a' .. val.p .. ',' .. val.y .. ',' .. val.r .. ';')
	end
	encode['Entity'] = function(val, output)
		insert(output, 'E' .. (IsValid(val) and (val:EntIndex() .. ';') or '#'))
	end
	encode['Player'] = encode['Entity']
	encode['Vehicle'] = encode['Entity']
	encode['Weapon'] = encode['Entity']
	encode['NPC'] = encode['Entity']
	encode['NextBot'] = encode['Entity']
	encode['PhysObj'] = encode['Entity']

	-- untransmittable values fix
	encode['function'] = function(val, output)
		insert(output, 'w')
	end
	encode['userdata'] = function(val, output)
		insert(output, 'u')
	end
	encode['thread'] = function(val, output)
		insert(output, 'h')
	end
	encode['CSoundPatch'] = function(val, output)
		insert(output, 'c')
	end

	do
		local concat = table.concat
		function pon.encode(tbl)
			assert(istable(tbl), 'Table excepted for encode.')

			local output = {}
			cacheSize = 0
			encode['table'](tbl, output, {})
			local res = concat(output)

			return res
		end
	end
end

do
	local tonumber, select = tonumber, select
	local find, sub, gsub, gmatch, Explode = string.find, string.sub, string.gsub, string.gmatch, string.Explode
	local Vector, Angle, Entity = Vector, Angle, Entity

	local decode = {}

	-- keep track of encoding table stack to restore null refs
	local curStack = {}

	-- sequential or mixed table
	decode['{'] = function(index, str, cache)
		local cur = {}
		insert(cache, cur)

		local k = 1
		local v, tv
		while true do
			tv = sub(str, index, index)
			if not tv or tv == '~' then
				index = index + 1
				break
			end
			if tv == '}' then
				return index + 1, cur
			end

			index = index + 1
			curStack[#curStack + 1] = {cur, k}
			index, v = decode[tv](index, str, cache)
			curStack[#curStack] = nil

			cur[k] = v

			k = k + 1
		end

		-- dictionary after sequential
		local tk
		while true do
			tk = sub(str, index, index)
			if not tk or tk == '}' then
				index = index + 1
				break
			end

			index = index + 1
			index, k = decode[tk](index, str, cache)

			tv = sub(str, index, index)
			index = index + 1
			index, v = decode[tv](index, str, cache)

			cur[k] = v
		end

		return index, cur
	end

	-- dictionary table
	decode['['] = function(index, str, cache)
		local cur = {}
		insert(cache, cur)

		local k, v, tk, tv
		while true do
			tk = sub(str, index, index)
			if not tk or tk == '}' then
				index = index + 1
				break
			end

			index = index + 1
			index, k = decode[tk](index, str, cache)

			tv = sub(str, index, index)
			index = index + 1
			index, v = decode[tv](index, str, cache)

			cur[k] = v
		end

		return index, cur
	end

	-- pointer
	decode['('] = function(index, str, cache)
		local finish = find(str, ')', index, true)
		local num = tonumber(sub(str, index, finish - 1))
		index = finish + 1
		return index, cache[num]
	end

	-- string
	decode['\''] = function(index, str, cache)
		local finish = find(str, ';', index, true)
		local res = sub(str, index, finish - 1)
		index = finish + 1

		insert(cache, res)
		return index, res
	end
	-- escaped string
	decode['"'] = function(index, str, cache)
		local finish = find(str, '";', index, true)
		local res = gsub(sub(str, index, finish - 1), '\\;', ';')
		index = finish + 2

		insert(cache, res)
		return index, res
	end

	-- number
	decode['n'] = function(index, str)
		index = index - 1
		local finish = find(str, ';', index, true)
		local num = tonumber(sub(str, index, finish - 1))
		index = finish + 1
		return index, num
	end
	decode['0'] = decode['n']
	decode['1'] = decode['n']
	decode['2'] = decode['n']
	decode['3'] = decode['n']
	decode['4'] = decode['n']
	decode['5'] = decode['n']
	decode['6'] = decode['n']
	decode['7'] = decode['n']
	decode['8'] = decode['n']
	decode['9'] = decode['n']
	decode['-'] = decode['n']
	-- positive hex
	decode['X'] = function(index, str)
		local finish = find(str, ';', index, true)
		local num = tonumber(sub(str, index, finish - 1), 16)
		index = finish + 1
		return index, num
	end
	-- negative hex
	decode['x'] = function(index, str)
		local finish = find(str, ';', index, true)
		local num = -tonumber(sub(str, index, finish - 1), 16)
		index = finish + 1
		return index, num
	end
	local b62alphabet = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'
	local function b62decode(str)
		local num = 0
		for letter in gmatch(str, '.') do
			num = num * 62 + (select(1, find(b62alphabet, letter, 1, true)) or 0) - 1
		end
		return num
	end
	-- positive base62
	decode['Y'] = function(index, str)
		local finish = find(str, ';', index, true)
		local num = b62decode(sub(str, index, finish - 1))
		index = finish + 1
		return index, num
	end
	-- negative base62
	decode['y'] = function(index, str)
		local index, num = decode['Y'](index, str)
		return index, -num
	end

	-- boolean
	decode['t'] = function(index)
		return index, true
	end
	decode['f'] = function(index)
		return index, false
	end

	-- Vector
	decode['v'] = function(index, str)
		local finish = find(str, ';', index, true)
		local vecStr = sub(str, index, finish - 1)
		index = finish + 1 -- update the index.
		local segs = Explode(',', vecStr, false)
		return index, Vector(tonumber(segs[1]), tonumber(segs[2]), tonumber(segs[3]))
	end
	-- Color
	decode['l'] = function(index, str)
		local finish = find(str, ';', index, true)
		local vecStr = sub(str, index, finish - 1)
		index = finish + 1 -- update the index.
		local segs = Explode(',', vecStr, false)
		return index, Color(tonumber(segs[1]), tonumber(segs[2]), tonumber(segs[3]), tonumber(segs[4]))
	end
	-- Angle
	decode['a'] = function(index, str)
		local finish = find(str, ';', index, true)
		local angStr = sub(str, index, finish - 1)
		index = finish + 1 -- update the index.
		local segs = Explode(',', angStr, false)
		return index, Angle(tonumber(segs[1]), tonumber(segs[2]), tonumber(segs[3]))
	end
	-- Entity
	decode['E'] = function(index, str)
		if str[index] == '#' then
			index = index + 1
			return index, NULL
		else
			local finish = find(str, ';', index, true)
			local num = tonumber(sub(str, index, finish - 1))
			index = finish + 1

			local ent = Entity(num)
			if not IsValid(ent) and curStack[#curStack] then
				pon.pendingEnts[num] = curStack[#curStack]
				pon.queueEntsFlush()
			end

			return index, ent
		end
	end

	-- untransmittable values fix
	decode['w'] = function(index)
		return index, 'function'
	end
	decode['u'] = function(index)
		return index, 'userdata'
	end
	decode['h'] = function(index)
		return index, 'thread'
	end
	decode['с'] = function(index)
		return index, 'sound'
	end

	function pon.decode(data)
		assert(isstring(data), 'String excepted for decode.')

		local _, res = decode[sub(data, 1, 1)](2, data, {})
		return res
	end
end

local function entCreated(ent)
	local id = ent:EntIndex()
	local link = pon.pendingEnts[id]
	if link then
		local tbl, key = unpack(link)
		tbl[key] = ent
		pon.pendingEnts[id] = nil
		hook.Run('pon.entityCreated', ent, tbl, key)
	end
end
hook.Add('OnEntityCreated', 'octolib.netVar', entCreated)
hook.Add('NetworkEntityCreated', 'octolib.netVar', entCreated)

hook.Add('EntityRemoved', 'octolib.netVar', function(ent)
	local id = ent:EntIndex()
	pon.pendingEnts[id] = nil
end)
