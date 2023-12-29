function octolib.models.getValidSelection(mdl, skin, userBgs, userMats)
	-- validate skin
	skin = isnumber(skin) and skin or 0
	if not mdl.requiredSkin and mdl.skin and mdl.skin.vals then
		local found = false
		for _, v in ipairs(mdl.skin.vals) do
			if v[2] == skin then
				found = true
			end
		end
		if not found then skin = 0 end
	elseif mdl.requiredSkin then skin = mdl.requiredSkin
	else skin = 0 end

	-- validate bodygroups
	userBgs = istable(userBgs) and userBgs or {}
	local bgs = {}
	if mdl.bgs then
		for bgID, bgVal in pairs(userBgs) do
			local bgData = mdl.bgs[bgID]
			if not bgData then continue end

			if bgData.vals then
				for _, selection in ipairs(bgData.vals) do
					if selection[2] == bgVal then
						bgs[bgID] = bgVal
						break
					end
				end
			else
				if bgVal == 0 or bgVal == 1 then
					bgs[bgID] = bgVal
				end
			end
		end
	end
	if mdl.requiredBgs then
		for bgID, bgVal in pairs(mdl.requiredBgs) do
			bgs[bgID] = bgVal
		end
	end

	-- validate materials
	userMats = istable(userMats) and userMats or {}
	local mats = {}
	if mdl.subMaterials then
		for matID, matVal in pairs(userMats) do
			local matData = mdl.subMaterials[matID]
			if not matData then continue end

			for _, selection in ipairs(matData.vals) do
				if selection[2] == matVal then
					mats[matID] = matVal
					break
				end
			end
		end
	end
	if mdl.requiredMats then
		for matID, matVal in pairs(mdl.requiredMats) do
			mats[matID] = matVal
		end
	end

	return skin, bgs, mats
end

local Player = FindMetaTable('Player')

local pending = {}
function Player:SelectModel(mdls, callback)
	if not istable(mdls) then return end

	local id = self:SteamID()
	netstream.Start(self, 'octolib.modelSelector', mdls)

	pending[id] = { self, mdls, callback }
	timer.Create('octolib.modelSelectorTimeout' .. id, 600, 1, function()
		local callback = pending[id][2]
		if callback then callback(false) end
		pending[id] = nil
	end)
end

netstream.Hook('octolib.modelSelector', function(ply, index, userSkin, userBgs, userMats)
	local sid = ply:SteamID()
	if not pending[sid] then return end

	timer.Remove('octolib.modelSelectorTimeout' .. sid)
	local func = pending[sid][3] or octolib.func.zero
	if not index then return func(ply, false) end

	local mdl = pending[sid][2][index]
	if not istable(mdl) then return func(ply, false) end

	local skin, bgs, mats = octolib.models.getValidSelection(mdl, userSkin, userBgs, userMats)
	func(ply, mdl, skin, bgs, mats)
	pending[sid] = nil
end)

hook.Add('PlayerDisconnected', 'octolib.modelSelector', function(ply)
	local sid = ply:SteamID()
	pending[sid] = nil
	timer.Remove('octolib.modelSelectorTimeout' .. sid)
end)