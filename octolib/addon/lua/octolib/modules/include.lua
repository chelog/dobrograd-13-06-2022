octolib.include = octolib.include or {}

octolib.include.modes = octolib.include.modes or {}

function octolib.include.modes.modules(path)
	local includeFuncs = {}

	local _, moduleFolders = file.Find(octolib.path.join(path, '*'), 'LUA')

	for _, moduleName in pairs(moduleFolders) do
		if moduleName == '.' or moduleName == '..' then
			continue
		end

		local path = octolib.path.join(path, moduleName)

		includeFuncs[moduleName] = function()
			if CLIENT then
				if file.Exists(path .. '/shared.lua', 'LUA') then
					include(path .. '/shared.lua')
				end

				if file.Exists(path .. '/client.lua', 'LUA') then
					include(path .. '/client.lua')
				end

				return
			end

			if file.Exists(path .. '/shared.lua', 'LUA') then
				include(path .. '/shared.lua')
				AddCSLuaFile(path .. '/shared.lua')
			end

			if file.Exists(path .. '/server.lua', 'LUA') then
				include(path .. '/server.lua')
			end

			if file.Exists(path .. '/client.lua', 'LUA') then
				AddCSLuaFile(path .. '/client.lua')
			end
		end
	end

	return includeFuncs
end

function octolib.include.modes.filesShared(path)
	local includes = {}

	local files = file.Find(octolib.path.join(path, '*.lua'), 'LUA')

	for _, fileName in pairs(files) do
		local path = octolib.path.join(path, fileName)

		includes[string.StripExtension(fileName)] = function()
			if SERVER then
				AddCSLuaFile(path)
			end

			include(path)
		end
	end

	return includes
end

function octolib.include.modes.filesServer(path)
	local includes = {}

	local files = file.Find(octolib.path.join(path, '*.lua'), 'LUA')
	for _, fileName in pairs(files) do
		local path = octolib.path.join(path, fileName)

		includes[string.StripExtension(fileName)] = function()
			include(path)
		end
	end

	return includes
end

function octolib.include.modes.filesClient(path)
	local includes = {}

	local files = file.Find(octolib.path.join(path, '*.lua'), 'LUA')

	for _, fileName in pairs(files) do
		local path = octolib.path.join(path, fileName)

		includes[string.StripExtension(fileName)] = function()
			if SERVER then
				AddCSLuaFile(path)

				return
			end

			include(path)
		end
	end

	return includes
end

function octolib.include.modes.files(path)
	local includes = octolib.include.modes.filesShared(path)

	table.Merge(includes, octolib.include.modes.filesServer(octolib.path.join(path, 'server')))
	table.Merge(includes, octolib.include.modes.filesClient(octolib.path.join(path, 'client')))

	return includes
end

function octolib.include.custom(path, modes, order)
	assert(isstring(path), 'path must be a string')
	assert(isfunction(modes) or istable(modes), 'modes must be a function or table')
	assert(istable(order) or order == nil, 'order must be a table or nil')

	path = octolib.path.trim(octolib.path.resolve(path))

	if isfunction(modes) then
		modes = { modes }
	end

	local includeFuncs = {}
	for _, mode in ipairs(modes) do
		table.Merge(includeFuncs, mode(path))
	end

	if istable(order) then
		for _, name in ipairs(order) do
			local names = {}
			local ignore = string.StartWith(name, '!')

			if ignore then
				name = string.sub(name, 2)
			end

			if string.find(name, '*') then
				local includeNames = table.GetKeys(includeFuncs)
				for _, includeName in SortedPairsByValue(includeNames) do
					if string.match(includeName, '^' .. string.Replace(name, '*', '.+') .. '$') then
						table.insert(names, includeName)
					end
				end
			elseif includeFuncs[name] then
				table.insert(names, name)
			end

			for _, name in ipairs(names) do
				if not ignore then
					includeFuncs[name]()
				end

				includeFuncs[name] = nil
			end
		end
	else
		for _, includeFunc in SortedPairs(includeFuncs) do
			includeFunc()
		end
	end
end

function octolib.include.modules(path, order)
	path = octolib.path.resolve(path, 1)

	octolib.include.custom(path, {
		octolib.include.modes.modules,
		octolib.include.modes.filesShared,
	}, order)
end

function octolib.include.prefixed(path, order)
	path = octolib.path.resolve(path, 1)

	local sharedOrder = {}
	local serverOrder = {}
	local clientOrder = {}

	if istable(order) then
		for _, name in ipairs(order) do
			table.insert(sharedOrder, 'sh_' .. name)
			table.insert(serverOrder, 'sv_' .. name)
			table.insert(clientOrder, 'cl_' .. name)
		end
	else
		table.insert(sharedOrder, 'sh_*')
		table.insert(serverOrder, 'sv_*')
		table.insert(clientOrder, 'cl_*')
	end

	octolib.include.custom(path, octolib.include.modes.filesShared, sharedOrder)
	octolib.include.custom(path, octolib.include.modes.filesServer, serverOrder)
	octolib.include.custom(path, octolib.include.modes.filesClient, clientOrder)
end

function octolib.include.files(path, order)
	path = octolib.path.resolve(path, 1)

	octolib.include.custom(path, octolib.include.modes.files, order)
end

function octolib.include.shared(path, order)
	path = octolib.path.resolve(path, 1)

	octolib.include.custom(path, octolib.include.modes.filesShared, order)
end

function octolib.include.server(path, order)
	path = octolib.path.resolve(path, 1)

	octolib.include.custom(path, octolib.include.modes.filesServer, order)
end

function octolib.include.client(path, order)
	path = octolib.path.resolve(path, 1)

	octolib.include.custom(path, octolib.include.modes.filesClient, order)
end
