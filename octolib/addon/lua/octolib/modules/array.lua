octolib.array = octolib.array or {}

function octolib.array.toKeys(array, value)
	if value == nil then
		value = true
	end

	local out = {}
	for _, v in ipairs(array) do
		out[v] = value
	end

	return out
end

function octolib.array.toStack(array, reversed)
	local stack = util.Stack()
	if reversed then array = table.Reverse(array) end

	for i = 1, #array do
		stack:Push(array[i])
	end

	return stack
end

function octolib.array.random(t)
	local i = math.random(#t)
	return t[i], i
end

function octolib.array.randomWeighted(items, flattenBy)
	flattenBy = flattenBy or 0

	local total, ids = 0, {}
	for i, v in ipairs(items) do total = total + v[1] + flattenBy end
	for i, v in ipairs(items) do ids[v[2]] = (v[1] + flattenBy) / total end

	local case = math.random()
	for i, v in pairs(ids) do
		case = case - v
		if case <= 0 then return i end
	end

	return items[#items][2] -- just in case, should never happen
end

function octolib.array.count(array, func)
	local count = 0
	for i, v in ipairs(array) do
		if func(v, i) then count = count + 1 end
	end

	return count
end

function octolib.array.shuffle(array)
	local count = #array
	for i = 1, count do
		local i2 = math.random(count)
		array[i], array[i2] = array[i2], array[i]
	end

	return array
end

function octolib.array.series(value, amount)
	local out = {}
	for _ = 1, amount or 1 do
		out[#out + 1] = value
	end

	return out
end

function octolib.array.page(array, pageSize, pageNum)
	pageNum = pageNum or 1
	return { unpack(array, (pageNum - 1) * pageSize + 1, pageNum * pageSize) }
end

function octolib.array.map(array, func)
	local out = {}
	for i, v in ipairs(array) do
		out[i] = func(v, i, array)
	end

	return out
end

function octolib.array.reduce(array, func, initVal)
	local out = initVal or array[1]
	for i, v in ipairs(array) do
		out = func(out, v, i, array)
	end

	return out
end

function octolib.array.some(array, func)
	for i, v in ipairs(array) do
		if func(v, i) then return true end
	end

	return false
end

function octolib.array.every(array, func)
	for i, v in ipairs(array) do
		if not func(v, i) then return false end
	end

	return true
end

function octolib.array.find(array, func)
	for i, v in ipairs(array) do
		if func(v, i) then return v, i end
	end
end

function octolib.array.filter(array, func, limit)
	local out = {}
	local foundAmount = 0
	for i, v in ipairs(array) do
		if func(v, i) then
			foundAmount = foundAmount + 1
			out[foundAmount] = v
			if limit and foundAmount >= limit then break end
		end
	end

	return out
end

function octolib.array.filterMultiple(array, funcs, limit)
	local out = {}
	local foundAmount = 0
	for i, v in ipairs(array) do
		if octolib.array.every(funcs, function(func)
			return func(v, i)
		end) then
			foundAmount = foundAmount + 1
			out[foundAmount] = v
			if limit and foundAmount >= limit then break end
		end
	end

	return out
end

function octolib.array.filterQuery(tbl, query, limit)
	return octolib.array.filterMultiple(tbl, octolib.table.precacheFilterFunctions(query), limit)
end
