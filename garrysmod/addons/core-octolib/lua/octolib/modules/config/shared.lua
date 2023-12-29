-- TODO: implement config

-- octolib.config = octolib.config or {}
-- octolib.config.storedOptions = octolib.config.storedOptions or {}
-- octolib.config.types = octolib.config.types or {}

-- octolib.include.prefixed('meta')
-- octolib.include.prefixed('contract')
-- octolib.include.client('vgui')

-- function octolib.config.option(id, optionConfig)
-- 	local option
-- 	if octolib.config.storedOptions[id] then
-- 		option = octolib.config.storedOptions[id]
-- 	else
-- 		option = setmetatable({ id = id }, octolib.meta.stored.configOption)
-- 		option:Load()
-- 	end

-- 	if optionConfig then table.Merge(option, optionConfig) end

-- 	octolib.config.storedOptions[id] = option

-- 	return option
-- end

-- function octolib.config.defineType(name, options)
-- 	local type
-- 	local changed = false
-- 	if octolib.config.types[name] then
-- 		type = octolib.config.types[name]

-- 		if options then
-- 			table.Merge(type, options)
-- 			changed = true
-- 		end
-- 	else
-- 		type = options
-- 		changed = true
-- 	end

-- 	if changed then
-- 		octolib.config.types[name] = type
-- 	end

-- 	return type
-- end
