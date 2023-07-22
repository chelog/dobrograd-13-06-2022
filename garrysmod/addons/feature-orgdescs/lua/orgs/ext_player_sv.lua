local meta = FindMetaTable 'Player'
function meta:SaveCitizen()

	local weapons = {}
	for _,wep in ipairs(self:GetWeapons()) do
		if not (GAMEMODE.Config.DisallowDrop[wep:GetClass()] or self:jobHasWeapon(wep:GetClass())) then
			table.insert(weapons, {wep:GetClass(), wep:Clip1()})
		end
	end

	local bg = {}
	for _,v in ipairs(self:GetBodyGroups()) do
		bg[v.id] = self:GetBodygroup(v.id)
	end
	self.dbgPolice_citizenData = {
		j = self:getJobTable().command,
		mdl = self:GetModel(),
		bg = bg,
		sk = self:GetSkin(),
		a = self:Armor(),
		p = self:GetAmmoCount('pistol'),
		smg = self:GetAmmoCount('SMG1'),
		lc = self:GetNetVar('HasGunlicense'),
		cl = self:GetNetVar('customClothes'),
		wps = weapons,
	}

end

function meta:RestoreCitizen()

	if not self.dbgPolice_citizenData or not self.dbgPolice_citizenData.mdl then return end

	local _, job = DarkRP.getJobByCommand(self.dbgPolice_citizenData.j)
	self:changeTeam(job, true, true)
	self:SetModel(self.dbgPolice_citizenData.mdl)
	self:SetSkin(self.dbgPolice_citizenData.sk)
	for k, v in pairs(self.dbgPolice_citizenData.bg) do self:SetBodygroup(k, v) end
	self:SetAmmo(self.dbgPolice_citizenData.p, 'pistol')
	self:SetAmmo(self.dbgPolice_citizenData.smg, 'SMG1')
	self:SetArmor(self.dbgPolice_citizenData.a)
	self:SetNetVar('HasGunlicense', self.dbgPolice_citizenData.lc)
	for k, v in pairs(self.dbgPolice_citizenData.wps) do
		local wep = self:Give(v[1], true)
		if IsValid(wep) then wep:SetClip1(v[2]) end
	end
	self:SetClothes(self.dbgPolice_citizenData.cl)
	self.dbgPolice_citizenData = nil
	self:SelectWeapon('dbg_hands')

	if self:HasTalkie() and not self:CanListenToChannel(self:GetFrequency(), true) then
		self:DisconnectTalkie()
	end

end

function meta:IsOrgMember(orgID)
	local is = hook.Run('simple-orgs.isMember', self, orgID)
	if is ~= nil then return is end
	local org = simpleOrgs.orgs[orgID]
	local sid = self:SteamID()
	return org and org.members and (org.members[sid] ~= nil or table.HasValue(org.members, sid)) 
end

function meta:OpenOrgEditor(orgID)
	local ok, msg = hook.Run('simple-orgs.overrideManagement', self, orgID)
	if ok ~= nil then return ok, msg end
	if not orgID or not simpleOrgs.orgs[orgID] then
		return false, 'Organization not found'
	end
	local org = simpleOrgs.orgs[orgID]
	if not (self:query('DBG: Редактировать организации') or table.HasValue(org.owners, self:SteamID())) then
		return false, 'Access denied'
	end
	netstream.Start(self, 'simple-orgs.editor.open', orgID, org.members, org.url, org.flyer, self:query('DBG: Редактировать организации') and org.owners or nil)
end

function meta:GetOrgRanks(orgID)
	local org = simpleOrgs.orgs[orgID]
	if not org then return {} end
	local sid = self:SteamID()
	if not org.multirank then return table.HasValue(org.owners, sid) and { 'owner' } or table.HasValue(org.members, sid) and { 'member' } or {} end
	return org.members[sid] or {}
end
