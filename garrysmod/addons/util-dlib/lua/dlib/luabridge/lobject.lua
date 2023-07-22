
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

local DLib = DLib
local FindMetaTable = FindMetaTable
local debug = debug
local type = type
local error = error
local setmetatable = setmetatable
local rawget = rawget

DLib.METADATA = DLib.METADATA or {}

--[[
	@doc
	@fname DLib.CreateLuaObject
	@args string objectName, boolean registerGlobalMeta

	@returns
	table: meta
]]
function DLib.CreateLuaObject(objectName, registerMetadata)
	local meta

	if registerMetadata then
		meta = FindMetaTable(objectName) or {}
		debug.getregistry()[objectName] = meta
	else
		meta = DLib.METADATA[objectName] or {}
		DLib.METADATA[objectName] = meta
	end

	meta.__getters = meta.__getters or {}

	if not meta.__index then
		function meta:__index(key)
			local getter = meta.__getters[key]

			if getter then
				return getter(self, key)
			end

			local value = rawget(self, key)

			if value ~= nil then
				return value
			end

			return meta[key]
		end
	end

	if not meta.GetClass then
		local lower = objectName:lower()

		function meta:GetClass()
			return lower
		end
	end

	if not meta.Create then
		function meta.Create(self, ...)
			if type(self) == 'table' then
				if not self.Copy then
					error(objectName .. ':Copy() - method is not implemented')
				end

				return self:Copy(...)
			end

			local newObject = setmetatable({}, meta)

			if meta.Initialize then
				meta.Initialize(newObject, self, ...)
			elseif meta.__construct then
				meta.__construct(newObject, self, ...)
			end

			return newObject
		end
	end

	return meta
end

--[[
	@doc
	@fname DLib.FindMetaTable
	@args string classIn

	@returns
	table: meta or nil
]]
function DLib.FindMetaTable(classIn)
	return DLib.METADATA[classIn] or FindMetaTable(classIn) or nil
end

--[[
	@doc
	@fname DLib.ConsturctClass
	@args string classIn, vararg constructorArgs

	@returns
	table: object
]]
function DLib.ConsturctClass(classIn, ...)
	local classGet = DLib.FindMetaTable(classIn)
	if not classGet then return false end
	return classGet.Create(...)
end
