if SERVER then
	local function AddCSLuaFolder(path)
		local files, folders = file.Find(path .. '/*', 'LUA')
		for _, fileName in ipairs(files) do
			if fileName:sub(-4) == '.lua' then
				AddCSLuaFile(path .. '/' .. fileName)
			end
		end

		for _, folderName in ipairs(folders) do
			AddCSLuaFolder(path .. '/' .. folderName)
		end
	end
	AddCSLuaFolder('spawnlists')
else
	hook.Add('PopulatePropMenu', 'dbg-props', function()
		local curID = 8000

		local packs = {}
		local function includeFolder(target, parentID, path)
			local categoryFile = path .. '/_category.lua'
			local files, folders = file.Find(path .. '/*', 'LUA')

			local parentPack
			if file.Exists(categoryFile, 'LUA') then
				parentPack = include(categoryFile)
				parentPack.id = curID
				parentPack.parent = parentID
				parentPack.packs = {}
				parentPack.content = parentPack.content or {}

				target[#target + 1] = parentPack

				parentID = curID
				curID = curID + 1
			end

			for _, fileName in ipairs(files) do
				if fileName:sub(-4) == '.lua' and fileName ~= '_category.lua' then
					local childPack = include(path .. '/' .. fileName)
					childPack.id = curID
					curID = curID + 1
					childPack.parent = parentID
					childPack.content = childPack.content or {}

					local childTarget = parentPack and parentPack.packs or target
					childTarget[#childTarget + 1] = childPack
				end
			end

			for _, folderName in ipairs(folders) do
				includeFolder(parentPack and parentPack.packs or target, parentID, path .. '/' .. folderName)
			end
		end
		includeFolder(packs, 0, 'spawnlists')

		local function addPack(pack)
			local content = {}
			for _, category in ipairs(pack.content or {}) do
				-- add category header
				content[#content + 1] = {
					type = 'header',
					text = category[1],
				}

				-- add category models
				for i = 2, #category do
					local mdl = category[i]
					content[#content + 1] = {
						type = 'model',
						model = mdl,
					}
				end
			end
			spawnmenu.AddPropCategory('dbg-props.build' .. pack.id, pack.name, content, pack.icon, pack.id, pack.parent)

			for _, childPack in ipairs(pack.packs or {}) do
				addPack(childPack)
			end
		end
		for _, pack in ipairs(packs) do
			addPack(pack)
		end
	end)
end
