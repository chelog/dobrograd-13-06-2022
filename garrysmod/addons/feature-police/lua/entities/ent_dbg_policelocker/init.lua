AddCSLuaFile "cl_init.lua"
AddCSLuaFile "shared.lua"

include "shared.lua"

local GM = GM or GAMEMODE

function ENT:Initialize()

	self:SetModel('models/props_c17/lockers001a.mdl')
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then phys:Wake() end

end

local skins = {
	medcop = 0,
	cop = 0,
	cop2 = 1,
	chief = 2,
}

local mdls = {
	male = {
		{ 'models/humans/dpdsl/male_01_01.mdl' },
		{ 'models/humans/dpdsl/male_02_01.mdl' },
		{ 'models/humans/dpdsl/male_03_01.mdl' },
		{ 'models/humans/dpdsl/male_04_01.mdl' },
		{ 'models/humans/dpdsl/male_05_01.mdl' },
		{ 'models/humans/dpdsl/male_06_01.mdl' },
		{ 'models/humans/dpdsl/male_07_01.mdl' },
		{ 'models/humans/dpdsl/male_08_01.mdl' },
		{ 'models/humans/dpdsl/male_09_01.mdl' },
	},
	female = {
		{ 'models/humans/dpdfem/female_01.mdl' },
		{ 'models/humans/dpdfem/female_02.mdl' },
		{ 'models/humans/dpdfem/female_03.mdl' },
		{ 'models/humans/dpdfem/female_04.mdl' },
		{ 'models/humans/dpdfem/female_06.mdl' },
		{ 'models/humans/dpdfem/female_07.mdl' },
	}
}

util.AddNetworkString 'dbg-police.equip'
function ENT:Use( ply )

	if not IsValid(ply) then return end

	if ply.currentOrg then
		return ply:Notify('warning', 'Сначала нужно сдать форму организации')
	end

	if ply.armorItem then
		if ply.armorItem.amount == ply:Armor() then
			return ply:Notify('warning', 'Нужно снять свой бронежилет')
		else
			ply.armorItem = nil
		end
	end

	local job = ply:GetNetVar('dbg-police.job', '')
	job = DarkRP.getJobByCommand(job)

	if not job or not job.police then
		return ply:Notify('warning', L.this_locker_only_for_police)
	end

	if next(ply.Buffs) then -- if he has any drug buff
		return ply:Notify('warning', 'Чтобы заступить на службу, нужна чистая голова! Приведи себя в порядок и возвращайся позже')
	end

	local models = table.Copy(mdls[ply:GetModel():find('female') and 'female' or 'male'])
	local skin = skins[job.command] or 0
	for i, v in ipairs(models) do
		v[2] = skin
	end

	net.Start('dbg-police.equip')
		net.WriteEntity(self)
	if ply:getJobTable().police then
		net.WriteBool(false)
	else
		net.WriteBool(true)
		net.WriteTable(models)
	end
	net.Send(ply)

	ply.dbgPolice_policeModels = models

end

net.Receive('dbg-police.equip', function(len, ply)

	local ent = net.ReadEntity()
	local equip = net.ReadBool()

	if ply.dbgPolice_nextEquip and CurTime() < ply.dbgPolice_nextEquip then
		ply:Notify('warning', L.wait_boy)
		return
	end
	ply.dbgPolice_nextEquip = CurTime() + 1

	if not IsValid(ent) or ent:GetClass() ~= 'ent_dbg_policelocker' or ply:GetPos():DistToSqr(ent:GetPos()) > 90000 then
		return ply:addExploitAttempt()
	end

	local pJob, pJobID = DarkRP.getJobByCommand(ply:GetNetVar('dbg-police.job', ''))
	local job = ply:getJobTable()

	if not pJob then
		ply:Notify('warning', L.error_job)
		return
	end

	if ply:IsHandcuffed() then
		ply:Notify('warning', L.error_cuffs)
		return
	end

	if IsValid(ply.tazeragdoll) then
		ply:Notify('warning', L.error_tazer)
		return
	end

	local time = ply:CheckPoliceDenied()
	if time == true then
		return ply:Notify('warning', 'Ты не можешь играть за полицейские профессии')
	elseif time then
		return ply:Notify('warning', 'Ты сможешь играть за полицейские профессии ' .. octolib.time.formatIn(time))
	end

	local veh = carDealer.getCurVeh(ply)
	if equip then
		if job.police then
			local curWep = ply:GetActiveWeapon()
			if IsValid(curWep) and curWep.civil then
				return ply:Notify('Ты не можешь заряжать личное оружие из служебного запаса')
			end
			local medkit = ply:GetWeapon('med_kit')
			if IsValid(medkit) then medkit:SetClip1(200) end
			ply:SetAmmo(180, 'pistol')
			ply:SetAmmo(360, 'SMG1')
			ply:SetArmor(job.armor or 0)
			-- ply:EmitSound('')
		else
			if IsValid(veh) then
				return ply:Notify('Сначала нужно загнать гражданский автомобиль')
			end

			local mdlChoice = net.ReadUInt(8)
			local hat = net.ReadBool()
			local mdlData = ply.dbgPolice_policeModels and ply.dbgPolice_policeModels[mdlChoice]
			if not mdlData then return end

			ply:SelectWeapon('dbg_hands')

			ply:SaveCitizen()
			if isfunction(pJob.customCheck) then
				local allow, reason = pJob.customCheck(ply)
				if not allow then
					reason = reason or pJob.customCheckFailMsg or L.job_denied
					ply:Notify('warning', reason)
					return
				end
			end

			ply:SetClothes(nil)
			ply:changeTeam(pJobID, true, true)
			if pJobID ~= TEAM_MAYOR then
				ply:SetModel(mdlData[1])
				local cmd = pJob.command
				ply:SetSkin(skins[cmd])
				ply:SetBodygroup(4, hat and (cmd == 'chief' and 2 or 1) or 0)
			end
			local medkit = ply:GetWeapon('med_kit')
			if IsValid(medkit) then medkit:SetClip1(200) end
			ply:SetAmmo(180, 'pistol')
			ply:SetAmmo(360, 'SMG1')
			ply:SetArmor(pJob.armor or 0)
			ply:SelectWeapon('dbg_hands')

			ply:ConnectTalkie('ems')
		end
	else
		if not job.police then return ply:addExploitAttempt() end
		if not ply.dbgPolice_citizenData then
			ply:Notify('warning', L.error_character)
			return
		end

		if IsValid(veh) then
			return ply:Notify('Сначала нужно загнать служебный автомобиль')
		end

		ply:RestoreCitizen()
	end

end)
