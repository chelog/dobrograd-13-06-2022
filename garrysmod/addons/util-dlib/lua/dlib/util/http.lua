
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

local http = http
local DLib = DLib
local HTTP = HTTP
local assert = assert
local type = type
local istable = istable
local isstring = isstring
local pairs = pairs
local table = table
local error = error
local string = string

local month_map = table.flipIntoHash({
	'jan',
	'feb',
	'mar',
	'apr',
	'may',
	'jun',
	'jul',
	'aug',
	'sep',
	'oct',
	'nov',
	'dec'
})

--[[
	@doc
	@fname http.ParseDate
	@args string input

	@desc
	Parses date in next format `Tue, 26 Nov 2019 01:18:04 GMT`
	@enddesc

	@returns
	number: timestamp
]]
function http.ParseDate(input)
	local day_of_week, day, month_str, year, hour, minute, second = input:lower():match('([a-z]+),%s+([0-9]+)%s+([a-z]+)%s+([0-9]+)%s+([0-9]+):([0-9]+):([0-9]+)%s+gmt')

	if not day_of_week then
		day_of_week, day, month_str, year, hour, minute, second = input:lower():match('([a-z]+),%s+([0-9]+)-([a-z]+)-([0-9]+)%s+([0-9]+):([0-9]+):([0-9]+)%s+gmt')
	end

	return math.dateToTimestamp(year:tonumber(), month_map[month_str] or 1, day:tonumber(), hour:tonumber(), minute:tonumber(), second:tonumber())
end

local sequences = {}

do
	for i = 1, 100 do
		table.insert(sequences, CompileString([[
		local math_random = math.random
		local char = string.char

		local function random()
			local rand = math_random(1, 3)

			if rand == 1 then
				return math_random(48, 57)
			elseif rand == 2 then
				return math_random(65, 90)
			else
				return math_random(97, 122)
			end
		end

		return function(len)
			return '--' .. char(]] .. string.rep('random(), ', i + 10):sub(1, -3) .. [[)
		end]], 'http.lua:random')())
	end
end

local function figureoutSeparator(struct, len)
	local separator = assert(sequences[len], 'Unable to construct random separator for multipart form! Uh-oh!')()

	for _, value in pairs(struct) do
		if istable(value) then
			if assert(isstring(value.body) and value.body, 'Body is missing from table inside struct'):find(separator, 1, true) then
				return figureoutSeparator(struct, len + 1)
			end
		else
			if isnumber(value) then
				value = tostring(value)
				struct[_] = tostring(value)
			end

			if value:find(separator, 1, true) then
				return figureoutSeparator(struct, len + 1)
			end
		end
	end

	return separator
end

local function whut(name)
	assert(isstring(name) and not name:find('"', 1, true) and not name:find('\n', 1, true), 'Names should be ONLY strings and they should not contain special characters')
	return name
end

--[[
	@doc
	@fname http.EncodeMultipart
	@args table struct

	@desc
	Encodes input as `multipart/form-data`
	`struct` is a table consist of string `key`s
	and `value`s either of string or table, containing
	`filename`, `mimetype` and `body` values
	@enddesc

	@returns
	string: encoded string
	string: header value for Content-Type
]]
function http.EncodeMultipart(struct)
	assert(istable(struct), 'Structure must be a table!')
	local separator = figureoutSeparator(struct, 1)
	local build = {}

	table.insert(build, separator)

	for key, value in pairs(struct) do
		if istable(value) then
			local key = value.key or value.name or key
			local str = 'Content-Disposition: form-data; name="' .. whut(key) .. '"'

			if value.filename then
				str = str .. '; filename="' .. whut(value.filename) .. '"'
			end

			table.insert(build, str)

			if value.mimetype then
				assert(not value.mimetype:find(' ', 1, true), 'mime type should not contain spaces')
				table.insert(build, 'Content-Type: ' .. whut(value.mimetype) .. '\n')
			elseif not value.nomime then
				table.insert(build, 'Content-Type: application/octet-stream\n')
			else
				table.insert(build, '')
			end

			table.insert(build, tostring(value.body))
			table.insert(build, separator)
		else
			table.insert(build, 'Content-Disposition: form-data; name="' .. whut(key) .. '"\n')
			table.insert(build, tostring(value))
			table.insert(build, separator)
		end
	end

	return table.concat(build, '\n'), 'multipart/form-data; boundary=' .. separator:sub(3)
end

--[[
	@doc
	@fname http.EncodeQuery
	@args table struct

	@desc
	struct is a table of `key -> value`
	Both key and value should be strings
	@enddesc

	@returns
	string: encoded string
]]
function http.EncodeQuery(params)
	assert(istable(params), 'Params input must be a table!')

	local build = {}

	for key, value in pairs(params) do
		table.insert(build, http.EncodeComponent(key) .. '=' .. http.EncodeComponent(value))
	end

	return table.concat(build, '&')
end

local function escapeUnicode(input)
	if #input == 1 then return input end

	local buf = ''

	for char in input:gmatch('.') do
		buf = buf .. '%' .. string.format('%X', string.byte(char))
	end

	return buf
end

local function escape(input)
	return '%' .. string.format('%X', string.byte(input))
end

--[[
	@doc
	@fname http.EncodeComponent
	@args string input

	@desc
	See [Mozilla Developer Network](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/encodeURIComponent) for details
	@enddesc

	@returns
	string: encoded string
]]
function http.EncodeComponent(component)
	assert(isstring(component), 'Input must be a string!')
	return component:gsub("[\x01-\x26]", escape)
		:gsub("[\x2b-\x2f]", escape)
		:gsub("[\x3a-\x40]", escape)
		:gsub("[\x5b-\x5e]", escape)
		:gsub("\x60", escape)
		:gsub("[\x7b-\x7d]", escape)
		:gsub(utf8.charpattern, escapeUnicode)
end

--[[
	@doc
	@fname http.Head
	@args string url, function onsuccess, function onfailure, table headers = {}

	@desc
	Executes a HTTP HEAD request
	onsuccess is a function with `table headers, number code` parameters
	@enddesc
]]
function http.Head(url, onsuccess, onfailure, headers)
	local request = {
		url = url,
		method = 'HEAD',
		headers = headers or {},
	}

	if onsuccess then
		function request.success(code, _, headers)
			return onsuccess(headers, code)
		end
	end

	if onfailure then
		function request.failed(err)
			return onfailure(err)
		end
	end

	return HTTP(request)
end

--[[
	@doc
	@fname http.Put
	@args string url, string body, function onsuccess, function onfailure, table headers = {}

	@desc
	Executes a HTTP PUT request
	onsuccess is a function with `string body, number size, table headers, number code` parameters
	@enddesc
]]
function http.Put(url, body, onsuccess, onfailure, headers)
	local request = {
		url = url,
		body = body,
		method = 'PUT',
		headers = headers or {},
	}

	-- как же рубат заебал
	-- говорит что не будет добавлять альсы (чтоб избавится от тупых имен функций) и править устаревший код и так далее
	-- но такие костыли вставлять - вставляет
	if headers['Content-Type'] or headers['content-type'] then
		request.type = headers['Content-Type'] or headers['content-type']
		headers['Content-Type'] = nil
		headers['content-type'] = nil
	end

	if onsuccess then
		function request.success(code, body, headers)
			return onsuccess(body, #body, headers, code)
		end
	end

	if onfailure then
		function request.failed(err)
			return onfailure(err)
		end
	end

	return HTTP(request)
end

--[[
	@doc
	@fname http.PostBody
	@args string url, string body, function onsuccess, function onfailure, table headers = {}

	@desc
	Executes a HTTP POST request
	onsuccess is a function with `string body, number size, table headers, number code` parameters
	@enddesc
]]
function http.PostBody(url, body, onsuccess, onfailure, headers)
	local request = {
		url = url,
		body = body,
		method = 'POST',
		headers = headers or {},
	}

	-- как же рубат заебал
	-- говорит что не будет добавлять альсы (чтоб избавится от тупых имен функций) и править устаревший код и так далее
	-- но такие костыли вставлять - вставляет
	if headers['Content-Type'] or headers['content-type'] then
		request.type = headers['Content-Type'] or headers['content-type']
		headers['Content-Type'] = nil
		headers['content-type'] = nil
	end

	if onsuccess then
		function request.success(code, body, headers)
			return onsuccess(body, #body, headers, code)
		end
	end

	if onfailure then
		function request.failed(err)
			return onfailure(err)
		end
	end

	return HTTP(request)
end
