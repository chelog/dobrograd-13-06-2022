local function getModels(orgID, rank, originMdls)

	local org = simpleOrgs.orgs[orgID]
	if not (org and org.ranks[rank]) then return {} end
	if not org.ranks[rank] then return {} end
	local rankData = org.ranks[rank]

	local mdls = table.Copy(rankData.mdls)
	for _, v in ipairs(mdls) do
		v.name = v.name:format(rankData.shortName)
		v.requiredSkin = v.everyday and rankData.everydaySkin or rankData.skin or v.requiredSkin or 0
		v.requiredMats = v.everyday and rankData.everydayMats or rankData.requiredMats or v.requiredMats or nil
	end

	return mdls
end

hook.Add('simple-orgs.overrideModels', 'simple-orgs.multirank', function(ply, orgID, originMdls, ent)
	local org = simpleOrgs.orgs[orgID]
	if not org.multirank then return end

	-- trying to determine current rank
	local ranks = ply:GetOrgRanks(orgID)
	if not ranks[1] then return {} end
	if not ranks[2] then
		ply:SetNetVar('activeRank', { orgID, ranks[1] })
		return getModels(orgID, ranks[1], originMdls)
	end
	if ply.tempOrg == orgID and ply.tempOrgRank then
		local mdls = getModels(orgID, ply.tempOrgRank, originMdls)
		ply.tempOrg, ply.tempOrgRank = nil
		return mdls
	end

	-- asking about preferred rank
	octolib.request.send(ply, {rank = {
		name = 'Ранг',
		desc = 'Тебе разрешено использовать несколько рангов. Выбери тот, который соответствует твоему текущему персонажу',
		type = 'comboBox',
		opts = octolib.table.mapSequential(ranks, function(v) return org.ranks[v] and {org.ranks[v].shortName, v} or nil end),
		required = true,
	}}, function(data)
		if not data or not org.ranks[data.rank or ''] then return end
		if IsValid(ent) then
			ply:SetNetVar('activeRank', { orgID, data.rank })
			ply.tempOrg, ply.tempOrgRank = orgID, data.rank
			ent:Use(ply, ply, USE_TOGGLE, 1)
		end
	end)
	return {}

end)

local function class(v) return istable(v) and v[1] or v end

local function parseOldTeam(ply, old, new)
	local oldOrgID = RPExtraTeams[old].orgID
	if not oldOrgID then return end
	local oldOrg = simpleOrgs.orgs[oldOrgID]
	if not (oldOrg and oldOrg.multirank) then return end

	if new ~= TEAM_ADMIN and ply:GetActiveOrg() == oldOrgID then ply:SetNetVar('activeRank', nil) end
	local hMask = ply:GetNetVar('hMask')
	if hMask and hMask[1] == 'gasmask' and not ply:CanUnmask() then
		ply:SetNetVar('hMask', nil)
	end
	ply:SetNetVar('customJob', nil)
	ply.orgWeps = nil
end

local function parseNewTeam(ply, old, new)
	local newOrgID = RPExtraTeams[new].orgID
	if not newOrgID then return end
	local newOrg = simpleOrgs.orgs[newOrgID]
	if not (newOrg and newOrg.multirank) then return end

	local rank = ply:GetActiveRank(newOrgID)
	if not rank or not newOrg.ranks[rank] then return end
	local rankData = newOrg.ranks[rank]

	timer.Simple(0, function()

		if rankData.weps then
			ply.orgWeps = octolib.table.mapSequential(rankData.weps, class)
			for _, v in ipairs(rankData.weps) do
				if istable(v) then
					local wep = ply:Give(v[1])
					if IsValid(wep) then
						wep.WorldModel = v[2]
						wep:Initialize()
						local clip1 = wep:GetMaxClip1()
						if clip1 then
							wep:SetClip1(clip1)
						end
					end
				else
					local wep = ply:Give(v)
					if IsValid(wep) then
						local clip1 = wep:GetMaxClip1()
						if clip1 then
							wep:SetClip1(clip1)
						end
					end
				end
			end
		end

		if rankData.excludeWeps then
			for _, v in ipairs(rankData.excludeWeps) do
				ply:StripWeapon(v)
			end
		end

		if rankData.ammo then
			for _, v in ipairs(rankData.ammo) do
				ply:SetAmmo(v[2], v[1])
			end
		end

		local armor
		if isfunction(rankData.armor) then
			armor = rankData.armor(ply)
		else armor = rankData.armor end
		if armor then
			ply:SetArmor(armor)
		end

	end)

	ply:SetNetVar('customJob', {rankData.name, rankData.icon})

end

hook.Add('OnPlayerChangedTeam', 'simple-orgs.multirank', function(ply, old, new)
	parseOldTeam(ply, old, new)
	parseNewTeam(ply, old, new)
end)

hook.Add('simple-orgs.getAmmo', 'simple-orgs.multirank', function(ply, orgID)
	local org = simpleOrgs.orgs[orgID]
	if not org.multirank then return end
	local rank = ply:GetActiveRank(orgID)
	if not (rank and org.ranks[rank]) then return end

	for _, v in ipairs(org.ranks[rank].ammo or {}) do
		ply:SetAmmo(math.max(ply:GetAmmoCount(v[1]), v[2]), v[1])
	end
end)
