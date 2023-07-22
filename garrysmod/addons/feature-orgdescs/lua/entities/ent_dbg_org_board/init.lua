AddCSLuaFile 'cl_init.lua'
AddCSLuaFile 'shared.lua'

include 'shared.lua'

duplicator.RegisterEntityClass('ent_dbg_org_board', function(ply, data)
	local ent = duplicator.GenericDuplicatorFunction(ply, data)
	ent:SetOrgID(ent.orgId)
	return ent
end, 'Data', 'orgId')

function ENT:Initialize()

	self:SetModel('models/props/cs_office/offcorkboarda.mdl')
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetUseType(SIMPLE_USE)

end

function ENT:SetOrgID(id)
	self.orgId = id
	local title = simpleOrgs and simpleOrgs.orgs and simpleOrgs.orgs[self.orgId] and simpleOrgs.orgs[self.orgId].shortTitle or nil
	if title == '' then title = nil end
	self:SetNetVar('title', title)
end

local function equip(ply, mdlData, skin, bgs, mats)
	local ent = ply.pendingOrgEnt
	ply.pendingOrgEnt = nil
	if not mdlData then return ply:SetNetVar('activeRank', nil) end
	if not IsValid(ent) then return end
	if not octolib.use.check(ply, ent) then return end
	if not ent.orgId or not simpleOrgs.orgs[ent.orgId] then return end
	local org = simpleOrgs.orgs[ent.orgId]
	if not ply:IsOrgMember(ent.orgId) then return end

	ply:SaveCitizen()
	local job, jobID = DarkRP.getJobByCommand(org.team)
	ply:changeTeam(jobID, true, true)
	if org.police then
		ply:SetNetVar('dbg-police.job', job.command)
	end
	ply:SetClothes(nil)
	ply:SetModel(mdlData.model)
	ply:SetSkin(skin)
	for _, v in ipairs(ply:GetBodyGroups()) do
		ply:SetBodygroup(v.id, bgs[v.id] or 0)
	end
	if mats then
		for k, v in pairs(mats) do
			ply:SetSubMaterial(k, v)
		end
	end

	ply.currentOrg = ent.orgId
	ply.currentOrgModel = mdlData

	ply.prevArmor = ply:Armor()
	ply:SetArmor(job.armor or 0)
	ply:SelectWeapon('dbg_hands')
	if job.hasTalkie and org.talkieFreq then
		ply:ConnectTalkie(org.talkieFreq)
		ply:SyncTalkieChannels()
	end

	hook.Run('simple-orgs.getEquip', ply)

end

function ENT:Use(ply)
	if not IsValid(ply) then return end
	if not self.orgId or not simpleOrgs.orgs[self.orgId] then return end
	local org = simpleOrgs.orgs[self.orgId]
	if org.secret then return end

	if not ply:IsOrgMember(self.orgId) then
		if ply:getJobTable().command == self.team then
			ply:RestoreCitizen()
		end
		if not org.flyer or org.flyer == '' then
			return ply:Notify('error', 'Для этого нужно состоять в организации "' .. org.name .. '"')
		end
		netstream.Start(ply, 'simple-orgs.guest', self.orgId, org.url, org.flyer)
		return
	end


	if ply:getJobTable().command == org.team then
		netstream.Start(ply, 'simple-orgs.activeWindow', self, ply.currentOrgModel)
	elseif ply.dbgPolice_citizenData then
		ply:Notify('Ты не можешь сейчас занять эту должность')
	else
		if next(ply.Buffs) then -- if he has any drug buff
			return ply:Notify('warning', 'Чтобы заступить на службу, нужна чистая голова! Приведи себя в порядок и возвращайся позже')
		end
		local mdls = hook.Run('simple-orgs.overrideModels', ply, self.orgId, org.mdls, self)
		if mdls and not mdls[1] then return end
		ply.pendingOrgEnt = self
		ply:SelectModel(mdls or org.mdls, equip)
	end
end

netstream.Hook('simple-orgs.getAmmo', function(ply, ent, userSkin, userBgs, userMats)
	if not IsValid(ent) or ent:GetClass() ~= 'ent_dbg_org_board' then return end
	if not octolib.use.check(ply, ent) then return end
	if not ent.orgId or not simpleOrgs.orgs[ent.orgId] then return end
	local org = simpleOrgs.orgs[ent.orgId]
	if not ply:IsOrgMember(ent.orgId) then return end
	if ply:getJobTable().command ~= org.team then return end

	local wep = ply:GetWeapon('med_kit')
	if IsValid(wep) then wep:SetClip1(200) end

	local job = DarkRP.getJobByCommand(org.team)
	for k,v in pairs(job.ammo or {}) do
		ply:SetAmmo(math.max(ply:GetAmmoCount(k), v), k)
	end
	ply:SetArmor(job.armor or 0)

	local mdlData = ply.currentOrgModel
	if mdlData then
		local skin, bgs, mats = octolib.models.getValidSelection(mdlData, userSkin, userBgs, userMats)
		ply:SetSkin(skin)
		for _, v in ipairs(ply:GetBodyGroups()) do
			ply:SetBodygroup(v.id, bgs[v.id] or 0)
		end
		for k, v in pairs(mats) do
			ply:SetSubMaterial(k, v)
		end
	end
	ply:EmitSound('npc/combine_soldier/gear5.wav', 65)

	hook.Run('simple-orgs.getAmmo', ply, ent.orgId)
end)

netstream.Hook('simple-orgs.handOver', function(ply, ent)
	if not IsValid(ent) or ent:GetClass() ~= 'ent_dbg_org_board' then return end
	if not octolib.use.check(ply, ent) then return end
	if not ent.orgId or not simpleOrgs.orgs[ent.orgId] then return end
	local org = simpleOrgs.orgs[ent.orgId]
	if not ply:IsOrgMember(ent.orgId) then return end
	if ply:getJobTable().command ~= org.team then return end

	if not ply.dbgPolice_citizenData then
		ply:Notify('warning', L.error_character)
		return
	end
	ply:SetArmor(ply.prevArmor or 0)
	ply:SetNetVar('dbg-police.job', nil)

	for i, _ in ipairs(ply:GetMaterials()) do
		if ply:GetSubMaterial(i) then
			ply:SetSubMaterial(i, nil)
		end
	end

	ply:RestoreCitizen()
	ply.currentOrg, ply.currentOrgModel = nil

	hook.Run('simple-orgs.handOver', ply)

end)
