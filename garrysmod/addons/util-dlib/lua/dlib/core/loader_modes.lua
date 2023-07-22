
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

local Loader = DLib.Loader

--[[
local function include2(fileIn)
	local status = {xpcall(Loader.include, function(err) print(debug.traceback('[DLIB STARTUP ERROR] ' .. err)) end, fileIn)}
	local bool = table.remove(status, 1)

	if bool then
		return unpack(status)
	end
end
]]

local function include2(fileIn)
	return Loader.include(fileIn)
end

function Loader.load(targetDir)
	local output = {}
	local files = file.FindRecursiveVisible(targetDir)

	local sh, cl, sv = Loader.filter(files)

	if SERVER then
		for i, fil in ipairs(sh) do
			AddCSLuaFile(fil)
			table.insert(output, {fil, include2(fil)})
		end

		for i, fil in ipairs(cl) do
			AddCSLuaFile(fil)
		end

		for i, fil in ipairs(sv) do
			table.insert(output, {fil, include2(fil)})
		end
	else
		for i, fil in ipairs(sh) do
			table.insert(output, {fil, include2(fil)})
		end

		for i, fil in ipairs(cl) do
			table.insert(output, {fil, include2(fil)})
		end
	end

	return output
end

function Loader.loadTop(targetDir)
	local output = {}
	local files = file.Find(targetDir .. '/*', 'LUA')

	local sh, cl, sv = Loader.filter(files)

	if SERVER then
		for i, fil in ipairs(sh) do
			AddCSLuaFile(fil)
			table.insert(output, {fil, include2(fil)})
		end

		for i, fil in ipairs(cl) do
			AddCSLuaFile(fil)
		end

		for i, fil in ipairs(sv) do
			table.insert(output, {fil, include2(fil)})
		end
	else
		for i, fil in ipairs(sh) do
			table.insert(output, {fil, include2(fil)})
		end

		for i, fil in ipairs(cl) do
			table.insert(output, {fil, include2(fil)})
		end
	end

	return output
end

function Loader.loadCS(targetDir)
	local output = {}
	local files = file.FindRecursiveVisible(targetDir)

	local sh, cl = Loader.filter(files)

	if SERVER then
		for i, fil in ipairs(sh) do
			AddCSLuaFile(fil)
		end

		for i, fil in ipairs(cl) do
			AddCSLuaFile(fil)
		end
	else
		for i, fil in ipairs(sh) do
			table.insert(output, {fil, include2(fil)})
		end

		for i, fil in ipairs(cl) do
			table.insert(output, {fil, include2(fil)})
		end
	end

	return output
end

function Loader.loadPureCS(targetDir)
	local output = {}
	local files = file.FindRecursiveVisible(targetDir)

	if SERVER then
		for i, fil in ipairs(files) do
			AddCSLuaFile(fil)
		end
	else
		for i, fil in ipairs(files) do
			table.insert(output, {fil, include2(fil)})
		end
	end

	return output
end

function Loader.loadPureSV(targetDir)
	if CLIENT then return end
	local output = {}
	local files = file.FindRecursiveVisible(targetDir)

	for i, fil in ipairs(files) do
		table.insert(output, {fil, include2(fil)})
	end

	return output
end

function Loader.loadPureSH(targetDir)
	local output = {}
	local files = file.FindRecursiveVisible(targetDir)

	if SERVER then
		for i, fil in ipairs(files) do
			AddCSLuaFile(fil)
			table.insert(output, {fil, include2(fil)})
		end
	else
		for i, fil in ipairs(files) do
			table.insert(output, {fil, include2(fil)})
		end
	end

	return output
end

function Loader.loadPureCSTop(targetDir)
	local output = {}
	local files = file.FindVisiblePrepend(targetDir, 'LUA')

	if SERVER then
		for i, fil in ipairs(files) do
			AddCSLuaFile(fil)
		end
	else
		for i, fil in ipairs(files) do
			table.insert(output, {fil, include2(fil)})
		end
	end

	return output
end

Loader.loadPureCLTop = Loader.loadPureCSTop

function Loader.loadPureSVTop(targetDir)
	if CLIENT then return end
	local output = {}
	local files = file.FindVisiblePrepend(targetDir, 'LUA')

	for i, fil in ipairs(files) do
		table.insert(output, {fil, include2(fil)})
	end

	return output
end

function Loader.loadPureSHTop(targetDir)
	local output = {}
	local files = file.FindVisiblePrepend(targetDir, 'LUA')

	if SERVER then
		for i, fil in ipairs(files) do
			AddCSLuaFile(fil)
			table.insert(output, {fil, include2(fil)})
		end
	else
		for i, fil in ipairs(files) do
			table.insert(output, {fil, include2(fil)})
		end
	end

	return output
end

function Loader.csModule(targetDir)
	if CLIENT then return {} end

	local output = {}
	local files = file.FindRecursiveVisible(targetDir)

	if #files == 0 then error('Empty module ' .. targetDir) end

	for i, fil in ipairs(files) do
		AddCSLuaFile(fil)
	end

	return output
end

return Loader
