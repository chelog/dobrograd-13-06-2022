
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

local ipairs = ipairs
local pairs = pairs
local table = table
local select = select
local remove = table.remove
local insert = function(self, val)
	local newIndex = #self + 1
	self[newIndex] = val
	return newIndex
end

table.unpack = unpack
table.pairs = pairs
table.ipairs = ipairs

--[[
	@doc
	@fname table.append
	@args table destination, table source

	@desc
	Appends values from source table to destination table. Works only with nurmerical indexed tables
]]
function table.append(destination, source)
	if #source == 0 then return destination end

	local i, nextelement = 1, source[1]

	::append::

	destination[#destination + 1] = source[i]
	i = i + 1
	nextelement = source[i]

	if nextelement ~= nil then
		goto append
	end

	return destination
end

--[[
	@doc
	@fname table.prependString
	@args table destination, string prepend

	@desc
	Iterates over destination and prepends string to all values (assuming array contains only strings)
]]
function table.prependString(destination, prepend)
	for i, value in ipairs(destination) do
		destination[i] = prepend .. value
	end

	return destination
end

--[[
	@doc
	@fname table.appendString
	@args table destination, string append

	@desc
	Iterates over destination and appends string to all values (assuming array contains only strings)
]]
function table.appendString(destination, append)
	for i, value in ipairs(destination) do
		destination[i] = value .. append
	end

	return destination
end

--[[
	@doc
	@fname table.filter
	@args table target, function filterFunc

	@desc
	Filters table passed
	Second argument is a function(key, value, target)
	@enddesc

	@returns
	table: deleted elements
]]
function table.filter(target, filterFunc)
	if not filterFunc then error('table.filter - missing filter function') end

	local toRemove = {}

	for key, value in pairs(target) do
		local status = filterFunc(key, value, target)
		if not status then
			if type(key) == 'number' then
				insert(filtered, value)
				insert(toRemove, key)
			else
				filtered[key] = value
				target[key] = nil
			end
		end
	end

	for v, i in ipairs(toRemove) do
		remove(target, i - v + 1)
	end

	return filtered
end

--[[
	@doc
	@fname table.qfilter
	@args table target, function filterFunc

	@desc
	Filters table passed using goto
	Second argument is a function(key, value, target)
	@enddesc

	@returns
	table: deleted elements
]]
function table.qfilter(target, filterFunc)
	if not filterFunc then error('table.qfilter - missing filter function') end
	if #target == 0 then return {} end

	local filtered = {}
	local toRemove = {}

	local i = 1
	local nextelement = target[i]

	::filter::

	local status = filterFunc(i, nextelement, target)

	if not status then
		filtered[#filtered + 1] = nextelement
		toRemove[#toRemove + 1] = i
	end

	i = i + 1
	nextelement = target[i]

	if nextelement ~= nil then
		goto filter
	end

	if #toRemove ~= 0 then
		i = 1
		nextelement = toRemove[i]

		::rem::
		remove(target, toRemove[i] - i + 1)

		i = i + 1
		nextelement = toRemove[i]

		if nextelement ~= nil then
			goto rem
		end
	end

	return filtered
end

--[[
	@doc
	@fname table.filterNew
	@args table target, function filterFunc

	@desc
	Filters table passed
	Second argument is a function(key, value, target) which should return boolean whenever element pass check
	@enddesc

	@returns
	table: passed elements
]]
function table.filterNew(target, filterFunc)
	if not filterFunc then error('table.filterNew - missing filter function') end

	local filtered = {}

	for key, value in pairs(target) do
		local status = filterFunc(key, value, target)
		if status then
			insert(filtered, value)
		end
	end

	return filtered
end

--[[
	@doc
	@fname table.qfilterNew
	@args table target, function filterFunc

	@desc
	Filters table passed using ipairs
	Second argument is a function(key, value, target) which should return boolean whenever element pass check
	@enddesc

	@returns
	table: passed elements
]]
function table.qfilterNew(target, filterFunc)
	if not filterFunc then error('table.qfilterNew - missing filter function') end

	local filtered = {}

	for key, value in ipairs(target) do
		local status = filterFunc(key, value, target)
		if status then
			insert(filtered, value)
		end
	end

	return filtered
end

--[[
	@doc
	@fname table.qmerge
	@args table into, table from

	@desc
	Filters table passed using ipairs
	Second argument is a function(key, value, target) which should return boolean whenever element pass check
	@enddesc

	@returns
	table: into
]]
function table.qmerge(into, inv)
	for i, val in ipairs(inv) do
		into[i] = val
	end

	return into
end

--[[
	@doc
	@fname table.gcopy
	@args table input
	@Alias table.qcopy

	@desc
	Fastly copies a table assuming it is numeric indexed array
	does not copy subtables or values
	@enddesc

	@returns
	table: copied input
]]
function table.gcopy(input)
	if #input == 0 then return {} end

	local reply = {}

	local nextValue, i = input[1], 1

	::loop::

	reply[i] = nextValue

	i = i + 1
	nextValue = input[i]

	if nextValue ~= nil then
		goto loop
	end

	return reply
end

table.qcopy = table.gcopy

--[[
	@doc
	@fname table.gcopyRange
	@args table input, number start, number endPos

	@desc
	Copies array in specified range
	@enddesc

	@returns
	table: copied input
]]
function table.gcopyRange(input, start, endPos)
	if #input < start then return {} end
	endPos = endPos or #input
	local endPos2 = endPos + 1

	local reply = {}

	local nextValue, i = input[start], start
	local i2 = 0

	::loop::
	i2 = i2 + 1
	reply[i2] = nextValue

	i = i + 1
	if i == endPos2 then return reply end
	nextValue = input[i]

	if nextValue ~= nil then
		goto loop
	end

	return reply
end

--[[
	@doc
	@fname table.unshift
	@args table input, vararg values

	@desc
	Inserts values in the start of an array
	@enddesc

	@returns
	table: input
]]
function table.unshift(tableIn, ...)
	local values = {...}
	local count = #values

	if count == 0 then return tableIn end

	for i = #tableIn + count, count, -1 do
		tableIn[i] = tableIn[i - count]
	end

	local i, nextelement = 1, values[1]

	::unshift::

	tableIn[i] = nextelement
	i = i + 1
	nextelement = values[i]

	if nextelement ~= nil then
		goto unshift
	end

	return tableIn
end

--[[
	@doc
	@fname table.construct
	@args table input, function callback, number times, vararg prependArgs

	@desc
	Calls callback with prependArgs specified times to construct a new array or append values to existing array
	@enddesc

	@returns
	table: input or newly created array
]]
function table.construct(input, funcToCall, times, ...)
	input = input or {}

	for i = 1, times do
		input[#input + 1] = funcToCall(...)
	end

	return input
end

--[[
	@doc
	@fname table.frandom
	@args table input

	@desc
	Returns random value from passed array
	@enddesc

	@returns
	any: returned value from array
]]
function table.frandom(tableIn)
	return tableIn[math.random(1, #tableIn)]
end


--[[
	@doc
	@fname table.qhasValue
	@args table input, any value

	@desc
	Checks for value present in specified array quickly using ipairs
	@enddesc

	@returns
	boolean: whenever value is present in input
]]
function table.qhasValue(findIn, value)
	for i, val in ipairs(findIn) do
		if val == value then return true end
	end

	return false
end

function table.construct2(funcToCall, times, ...)
	local output = {}

	for i = 1, times do
		output[#output + 1] = funcToCall(i, ...)
	end

	return output
end

--[[
	@doc
	@fname table.flipIntoHash
	@args table input

	@desc
	Iterates array over and creates new table {[value] = index}
	@enddesc

	@returns
	table: flipped hash table
]]
function table.flipIntoHash(tableIn)
	local output = {}

	for i, value in ipairs(tableIn) do
		output[value] = i
	end

	return output
end

--[[
	@doc
	@fname table.flip
	@args table input

	@desc
	Returns new flipped array
	@enddesc

	@returns
	table: flipped array
]]
function table.flip(tableIn)
	local values = {}

	for i = #tableIn, 1, -1 do
		values[#values + 1] = tableIn[i]
	end

	return values
end

--[[
	@doc
	@fname table.sortedFind
	@args table findIn, table findWhat, any ifNone

	@desc
	Gets hash table (flipIntoHash) of passed table and attempts to search for ANY value specified in findWhat
	@enddesc

	@returns
	any: found value
]]
function table.sortedFind(findIn, findWhat, ifNone)
	local hash = table.flipIntoHash(findIn)

	for i, valueFind in ipairs(findWhat) do
		if hash[valueFind] then
			return valueFind
		end
	end

	return ifNone
end

--[[
	@doc
	@fname table.removeValues
	@args table findIn, vargarg values

	@desc
	Removes values at specified indexes. **INDEX LIST MUST BE SORTED!** (from the smallest index to biggest).
	Can also accept array of values as second argument.
	@enddesc

	@returns
	table: removed values
]]
function table.removeValues(tableIn, ...)
	local first = select(1, ...)
	local args

	if type(first) == 'table' then
		args = first
	else
		args = {...}
	end

	local removed = {}

	for i = #args, 1, -1 do
		insert(removed, tableIn[args[i]])
		remove(tableIn, args[i])
	end

	return removed
end

--[[
	@doc
	@fname table.removeByMember
	@args table findIn, any memberID, any memberValue

	@desc
	Iterates over array and looks for tables with memberID index present and removes it when it is equal to memberValue
	@enddesc

	@returns
	any: removed value. *nil if value is not found*
]]
function table.removeByMember(tableIn, memberID, memberValue)
	local removed

	for i = 1, #tableIn do
		local v = tableIn[i]
		if type(v) == 'table' and v[memberID] == memberValue then
			table.remove(tableIn, i)
			removed = v
			break
		end
	end

	return removed
end

--[[
	@doc
	@fname table.deduplicate
	@args table tableIn

	@desc
	Iterates over array and removed duplicated values
	@enddesc

	@returns
	table: passed table
	table: array contain removed values
]]
function table.deduplicate(tableIn)
	local values = {}
	local toremove = {}

	for i, v in ipairs(tableIn) do
		if values[v] then
			insert(toremove, i)
		else
			values[v] = true
		end
	end

	table.removeValues(tableIn, toremove)
	return tableIn
end

--[[
	@doc
	@fname table.splice
	@args table tableIn, number start, number deleteCount, vararg insertValues

	@desc
	https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/splice
	@enddesc

	@returns
	table: removed elements
]]
function table.splice(tableIn, start, deleteCount, ...)
	if not deleteCount then
		deleteCount = #tableIn - start + 1
	end

	local removed = {}
	local inserts = select('#', ...)
	local actuallyMove = inserts - deleteCount

	-- inserting more elements than deleting
	if actuallyMove > 0 then
		-- moving old values to right
		for i = #tableIn, start + actuallyMove - 2, -1 do
			tableIn[i + actuallyMove] = tableIn[i]
		end

		for i = start, start + inserts - 1 do
			if i < start + deleteCount and tableIn[i] ~= nil then
				table.insert(removed, tableIn[i])
			end

			tableIn[i] = select(i - start + 1, ...)
		end
	-- inserting same amount of elements as deleting
	elseif actuallyMove == 0 then
		for i = start, start + deleteCount - 1 do
			if tableIn[i] ~= nil then
				table.insert(removed, tableIn[i])
			end

			tableIn[i] = select(i - start + 1, ...)
		end
	-- inserting lesser elements than deleting
	else
		local sizeof = #tableIn
		for i = start, start + inserts do
			if tableIn[i] ~= nil then
				table.insert(removed, tableIn[i])
			end

			tableIn[i] = select(i - start + 1, ...)
		end

		for i = start + inserts, sizeof do
			if i - (start + inserts) < -actuallyMove and tableIn[i] ~= nil then
				table.insert(removed, tableIn[i])
			end

			tableIn[i] = tableIn[i - actuallyMove]
		end
	end

	return removed
end
