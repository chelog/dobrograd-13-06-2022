AddCSLuaFile "shared.lua"
AddCSLuaFile "cl_init.lua"
include "shared.lua"

-------------------------------------------------
-- MAIN
-------------------------------------------------

function SWEP:PrimaryAttack()

	-- do nothing

end

function SWEP:SecondaryAttack()

	local ply = self.Owner:GetEyeTrace().Entity
	if IsValid(ply) and ply:IsPlayer() then
		if not ply:GetDBVar('sgMuted') then
			serverguard.command.Run(self.Owner, 'mute', true, ply:SteamID(), 15)
			serverguard.command.Run(self.Owner, 'gag', true, ply:SteamID(), 15)
			self.Owner:Notify('ooc', L.gag_and_mute:format(ply:Name()))
			ply:Notify('ooc', self.Owner:Name() .. L.gag_and_mute2)
		else
			serverguard.command.Run(self.Owner, 'unmute', true, ply:SteamID())
			serverguard.command.Run(self.Owner, 'ungag', true, ply:SteamID())
			self.Owner:Notify('ooc', L.ungag_and_unmute:format(ply:Name()))
			ply:Notify('ooc', self.Owner:Name() .. L.ungag_and_unmute2)
		end
	end

end

SWEP.nextReload = 0
function SWEP:Reload()

	if CurTime() < self.nextReload then return end

	self.Owner:Say('/invisible')
	if self.Owner:GetNoDraw() then
		self.Owner:Notify('ooc', L.invisible_god_en)
	else
		self.Owner:Notify('ooc', L.invisible_god_dis)
	end

	self.nextReload = CurTime() + 1.5

end

concommand.Add('dbg_admin', function(ply)

	if not ply:IsAdmin() or IsValid(ply.tazeragdoll) then return end

	if ply:Team() ~= TEAM_ADMIN then
		local GM = GM or GAMEMODE
		if ply:IsInvisible() then
			ply:MakeInvisible(false)
			timer.Simple(0, function()
				ply:MakeInvisible(true)
			end)
		end

		local weapons = {}
		for _,wep in ipairs(ply:GetWeapons()) do
			if not (GM.Config.DisallowDrop[wep:GetClass()] or ply:jobHasWeapon(wep:GetClass())) then
				table.insert(weapons, {wep:GetClass(), wep:Clip1()})
			end
		end

		ply.dbgAdmin_data = {
			j = ply:getJobTable().command,
			mdl = ply:GetModel(),
			sk = ply:GetSkin(),
			a = ply:Armor(),
			p = ply:GetAmmoCount('pistol'),
			smg = ply:GetAmmoCount('SMG1'),
			lc = ply:GetNetVar('HasGunlicense'),
			wps = weapons,
			freq = ply:GetFrequency(),
		}

		ply:changeTeam(TEAM_ADMIN, true, true)
		ply:SetModel('models/player/kleiner.mdl')
		ply:GodEnable()

		ply:SetAmmo(180, 'pistol')
		ply:SetAmmo(360, 'SMG1')
		ply:SetArmor(100)
		ply:ConnectTalkie('ems')
		ply:SyncTalkieChannels()

		ply:SelectWeapon('dbg_admingun')
		ply:Notify('ooc', L.admin_mode_on)
	elseif ply.dbgAdmin_data then

		if ply:IsInvisible() then
			ply:MakeInvisible(false)
			timer.Simple(0, function()
				ply:MakeInvisible(true)
			end)
		end

		local data = ply.dbgAdmin_data

		local _, job = DarkRP.getJobByCommand(data.j)
		ply:changeTeam(job, true, true)
		ply:SetModel(data.mdl)
		ply:SetSkin(data.sk)
		ply:SetArmor(data.a)
		ply:SetAmmo(data.p, 'pistol')
		ply:SetAmmo(data.smg, 'SMG1')
		ply:SetNetVar('HasGunlicense', data.lc)
		for _,v in ipairs(data.wps) do
			local wep = ply:Give(v[1], true)
			if IsValid(wep) then wep:SetClip1(v[2]) end
		end
		ply:GodDisable()

		ply.dbgAdmin_data = nil

		ply:SelectWeapon('dbg_hands')
		ply:Notify('ooc', L.admin_mode_off)

	else ply:Notify('warning', 'Информация об админ-режиме утеряна! Попробуй сменить персонажа или воскресить себя') end

end)

netstream.Hook('AdminTell', function(ply, target, time, title, msg)

	if not ply:IsAdmin() then return end
	if not IsValid(target) or not target:IsPlayer() then return end

	hook.Run('dbg-admin.tell', ply, time, title, msg, target)
	target:Notify('admin', time, title, msg)

end)


-- local _desc = ' Можно продать у входа в убежище'
-- local function souvenir(name, icon, vol, model, desc)
-- 	return {'souvenir', {
--		 name = name,
--		 icon = 'octoteam/icons/' .. icon .. '.png',
--		 model = model,
--		 desc = desc,
-- 		volume = vol,
-- 		mass = 1,
--	 }}
-- end

-- local items = {
-- 	{'coupon_food', 1},
-- 	{'coupon_ammo', 1},
-- 	{'coupon_exit', 1},
-- 	{'radio', 1},
-- 	{'h_mask', {
-- 		name = 'Противогаз',
-- 		icon = 'octoteam/icons/gasmask.png',
-- 		mask = 'gasmask',
-- 	}},
-- 	{'food', {
-- 		name = 'МРЕ',
-- 		icon = 'octoteam/icons/mre.png',
-- 		energy = 100,
-- 	}},
-- 	souvenir('Пыльный набор механика', 'hammer', 3, 'models/props_junk/cardboard_box004a.mdl', 'Хм... Может для кого и сгодится' .. _desc),
-- 	souvenir('Странные таблеточки', 'pills', 1, 'models/props_lab/jar01b.mdl', 'Помнится такие же по переулкам валялись, только пустые' .. _desc),
-- 	souvenir('Странный механизм', 'robot_arm', 1.5, 'models/jaanus/wiretool/wiretool_grabber_forcer.mdl', 'Выглядит, как что-то полезное' .. _desc),
-- 	souvenir('Серебряный бюст', 'bust', 1, 'models/props_junk/cardboard_box004a.mdl', 'Наверное он был какой-то важной шишкой в обществе. Думаю, кто-то сочтет это ценным' .. _desc),
-- 	souvenir(, 'battery_charge', 1, 'models/Items/car_battery01.mdl', 'Любые источники энергии сейчас на вес золота' .. _desc),
-- 	souvenir('Гантели', 'dumbbell', 3, 'models/props_junk/cardboard_box004a.mdl', 'Фух! Надеюсь, дотащу...' .. _desc),
-- 	souvenir('Моток каната', 'rope', 2, 'models/props_junk/cardboard_box004a.mdl', 'Полезная штуковина для выживания' .. _desc),
-- 	souvenir('Газовый баллон', 'keg', 20, 'models/props_junk/PropaneCanister001a.mdl', 'Незаменимая вещь в полевой кухне' .. _desc),
-- 	souvenir('Топливный генератор', 'engine', 35, 'models/gibs/airboat_broken_engine.mdl', 'Доступная энергия, главное не забыть заправить' .. _desc),
-- 	souvenir('Образец «Плантего Уртика»', 'plant', 0.2, 'models/props_junk/cardboard_box004a.mdl', 'Важный образец одного из видов растений. Отнеси это ученому'),
-- 	souvenir('Образец «Нигрум Мэйор»', 'plant', 0.2, 'models/props_junk/cardboard_box004a.mdl', 'Важный образец одного из видов растений. Отнеси это ученому'),
-- 	souvenir('Образец «Рубиус Чалгос»', 'plant', 0.2, 'models/props_junk/cardboard_box004a.mdl', 'Важный образец одного из видов растений. Отнеси это ученому'),
-- }

-- netstream.Hook('dysplasia.give', function(ply, tgt, itemID)

-- 	local cont = tgt.inv and tgt.inv.conts._hand
-- 	if not cont then
-- 		ply:Notify('warning', 'У игрока должны быть свободны руки')
-- 		return
-- 	end

-- 	if itemID == 1 then
-- 		for i, data in ipairs({
-- 			{'coupon_food', 3},
-- 			{'coupon_ammo', 1},
-- 			{'radio', 1},
-- 			{'h_mask', {
-- 				name = 'Противогаз',
-- 				icon = 'octoteam/icons/gasmask.png',
-- 				mask = 'gasmask',
-- 			}},
-- 		}) do
-- 			cont:AddItem(data[1], data[2])
-- 		end
-- 	else
-- 		local data = items[itemID - 1]
-- 		if data then cont:AddItem(data[1], data[2]) end
-- 	end

-- end)
