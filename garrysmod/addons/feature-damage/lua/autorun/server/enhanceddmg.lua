--[[
	Code is a mess, gotta fix
	Todo: Make the sounds a single function, decrapify the model check. Also stop having the same piece of code multiple times, thats a bad practice
]]--
AddCSLuaFile()

hook.Add('Initialize', 'dbg.dmg', function()
	timer.Create('damage.drown', 1, 0, function()
		octolib.func.throttle(player.GetAll(), 10, 0.1, function(ply)
			if not IsValid(ply) then return end
			if ply:WaterLevel() == 3 then
				local curScore = ply.drowningScore or 0
				if curScore >= 10 then
					local dmginfo = DamageInfo()
					dmginfo:SetDamage(10)
					dmginfo:SetDamageType(DMG_DROWN)
					dmginfo:SetAttacker(game.GetWorld())
					dmginfo:SetInflictor(game.GetWorld())
					ply:TakeDamageInfo(dmginfo)
				else
					ply.drowningScore = curScore + 1
				end
			else
				ply.drowningScore = nil
			end
		end)
	end)

	--This is terrible but whatevs
	local function BreakLeg(ply,duration)
		if !GetConVar('enhanceddamage_legbreak'):GetBool() then print('TEST') return end
		if !ply.legshot then
			ply.legshot = true
			ply:MoveModifier('dmg', {
				walkmul = 0.5,
				norun = true,
				nojump = true,
			})
			timer.Create('breakLeg_' .. ply:SteamID(), duration, 1, function() ply:MoveModifier('dmg', nil) end)
		end
	end

	local function FallDamage(ply,speed)
		if ply:IsGhost() or ply:Team() == TEAM_ADMIN then return 0 end
		local damage = speed / 7.5
		if (damage > ply:Health() / 2 and damage < ply:Health()) then
			BreakLeg(ply,10)
		end
		ply.lastDMGT = DMG_FALL
		return damage
	end

	local GM = GAMEMODE or GM
	function DarkRP.damageHands(ply, chance)

		if not ply:IsPlayer() or ply:Team() == TEAM_ADMIN then return false end
		if math.random(100) > chance then return end
		local weapon = ply:GetActiveWeapon()
		if not IsValid(weapon) then return end

		if not GM.Config.DisallowDrop[weapon:GetClass()] then
			if not ply:jobHasWeapon(weapon:GetClass()) then
				if not weapon.NoHandDamageDrop then
					local ent = ply:dropDRPWeapon(weapon)
					if IsValid(ent) and weapon.IsLethal then
						ent.isEvidence = true
					end
				end
			else
				ply:SelectWeapon('dbg_hands')
			end
		end

		ply.noPickups = true
		timer.Create('resetNoPickups' .. ply:SteamID(), 30, 1, function() if IsValid(ply) then ply.noPickups = nil end end)
	end

	hook.Add('octoinv.canPickup', 'dbg-damage', function(ply, ent, item)
		if ply.noPickups then return false, L.hurts_hand end
	end)
	hook.Add('octoinv.canUse', 'dbg-damage', function(cont, item, ply)
		if ply.noPickups then return false, L.hurts_hand end
	end)
	hook.Add('PlayerSwitchWeapon', 'dbg-damage', function(ply)
		if ply.noPickups then return true, L.hurts_hand end
	end)
	local hitgroupNames = {
		['HITGROUP_HAND'] = 'руку',
		[HITGROUP_HEAD] = 'голову',
		['HITGROUP_NUTS'] = 'голову',
		[HITGROUP_LEFTLEG] = 'левую ногу',
		[HITGROUP_RIGHTLEG] = 'правую ногу',
		[HITGROUP_LEFTARM] = 'левую руку',
		[HITGROUP_RIGHTARM] = 'правую руку',
		[HITGROUP_STOMACH] = 'область живота',
		[HITGROUP_CHEST] = 'область груди',
	}

	local function notifyDamage(ply, hitgroup)
		local hitgroupName = hitgroupNames[hitgroup]
		if hitgroupName then
			ply:Notify('hint', 'Тебе попали в ' .. hitgroupName)
		end
	end

	local function Damage(ply, hitgroup, dmginfo)
		local dmgpos = dmginfo:GetDamagePosition()

		local PelvisIndx = ply:LookupBone('ValveBiped.Bip01_Pelvis')
		if (PelvisIndx == nil) then return dmginfo end --Maybe Hitgroup still works, need testing
		local PelvisPos = ply:GetBonePosition( PelvisIndx )
		local NutsDistance = dmgpos:DistToSqr(PelvisPos)

		local LHandIndex = ply:LookupBone('ValveBiped.Bip01_L_Hand')
		local LHandPos = ply:GetBonePosition( LHandIndex )
		local LHandDistance = dmgpos:DistToSqr(LHandPos)

		local RHandIndex = ply:LookupBone('ValveBiped.Bip01_R_Hand')
		local RHandPos = ply:GetBonePosition(RHandIndex)
		local RHandDistance = dmgpos:DistToSqr(RHandPos)

		local LHandIndex = ply:LookupBone('ValveBiped.Bip01_L_Hand')
		local LHandPos = ply:GetBonePosition( LHandIndex )
		local LHandDistance = dmgpos:DistToSqr(LHandPos)

		local RCalfIndex = ply:LookupBone('ValveBiped.Bip01_R_Calf')
		local RCalfPos = ply:GetBonePosition(RCalfIndex)
		local RCalfDistance = dmgpos:DistToSqr(RCalfPos)

		local LCalfIndex = ply:LookupBone('ValveBiped.Bip01_L_Calf')
		local LCalfPos = ply:GetBonePosition(LCalfIndex)
		local LCalfDistance = dmgpos:DistToSqr(LCalfPos)

		local HeadIndex = ply:LookupBone('ValveBiped.Bip01_Head1')
		local HeadPos = ply:GetBonePosition(HeadIndex) + Vector(0,0,3)
		local HeadDistance = dmgpos:DistToSqr(HeadPos)

		if (LHandDistance < 100 || RHandDistance < 100 ) then
			hitgroup = 'HITGROUP_HAND'
		elseif HeadDistance < 80 then
			hitgroup = HITGROUP_HEAD
		elseif (NutsDistance <= 49 && NutsDistance >= 25) then
			hitgroup = 'HITGROUP_NUTS'
		elseif LCalfDistance < 350 then
			hitgroup = HITGROUP_LEFTLEG
		elseif RCalfDistance < 350 then
			hitgroup = HITGROUP_RIGHTLEG
		end

		if (hitgroup == HITGROUP_HEAD) then
			dmginfo:ScaleDamage(10)
		elseif (hitgroup == HITGROUP_LEFTARM || hitgroup == HITGROUP_RIGHTARM) then
			dmginfo:ScaleDamage(1)
			DarkRP.damageHands(ply, 50)
		elseif (hitgroup == HITGROUP_LEFTLEG || hitgroup == HITGROUP_RIGHTLEG) then
			dmginfo:ScaleDamage(0.75)
			if ply:IsPlayer() then BreakLeg(ply,5) end
		elseif (hitgroup == HITGROUP_CHEST) then
			dmginfo:ScaleDamage(3)
		elseif (hitgroup == HITGROUP_STOMACH) then
			dmginfo:ScaleDamage(1)
		elseif (hitgroup == 'HITGROUP_NUTS') then
			dmginfo:ScaleDamage(1.5)
			if ply:IsPlayer() then BreakLeg(ply,5) end
		elseif (hitgroup == 'HITGROUP_HAND') then
			dmginfo:ScaleDamage(0.45)
			DarkRP.damageHands(ply, 75)
		end

		notifyDamage(ply, hitgroup)
	end

	hook.Add('ScalePlayerDamage','EnhancedPlayerDamage',Damage)
	hook.Add('GetFallDamage','EnhancedFallDamage',FallDamage)

	local bleeding = {}
	local allowHolster = {
		weapon_flashlight = true,
		gmod_camera = true,
	}

	timer.Create('dbg-damage.dying', 1, 0, function()
		for k = #bleeding, 1, -1 do
			local sid = bleeding[k]
			local ply = player.GetBySteamID(sid)

			if not IsValid(ply) then

				timer.Remove('dbg-damage.dying' .. sid)
				table.remove(bleeding, k)

			elseif ply:Health() > 10 or not ply:Alive() or ply:IsGhost() then

				ply:MoveModifier('bleeding', nil)
				ply.bleeding = nil
				timer.Remove('dbg-damage.dying' .. sid)
				table.remove(bleeding, k)

			end

		end
	end)

	local function dying(ply, dmgInfo)
		if not IsValid(ply) or not ply:IsPlayer() or ply:IsGhost() then return end
		if ply:Team() == TEAM_ADMIN then return end
		if ply.bleeding then return end
		local left = ply:Health() - dmgInfo:GetDamage()
		if left <= 0 then return end
		if left <= 10 then
			local w = ply:GetActiveWeapon()
			if IsValid(w) and ply:HasWeapon(w:GetClass()) and not allowHolster[w:GetClass()] and hook.Call('canDropWeapon', GM, ply, w) then
				ply:dropDRPWeapon(w)
			end

			ply:Notify('warning', 'Ты при смерти. Если тебе не окажут помощь, ты погибнешь')
			ply.bleeding = true
			bleeding[#bleeding + 1] = ply:SteamID()
			ply:MoveModifier('bleeding', {
				walkmul = 0.5,
				norun = true,
				nojump = true,
				nostand = true,
			})
			timer.Create('dbg-damage.dying' .. ply:SteamID(), 18, 0, function()
				if not ply:IsMale() then
					ply:EmitSound(Sound('vo/npc/female01/moan0' .. math.random(1,5) .. '.wav'))
				else
					ply:EmitSound(Sound('vo/npc/male01/moan0' .. math.random(1,5) .. '.wav'))
				end
				if ply:Health() <= 1 then
					local dmg = DamageInfo()
					dmg:SetDamage(1)
					ply.attackedBy = ply.lastAttacker
					if ply.lastDMGT then
						dmg:SetDamageType(ply.lastDMGT)
					end
					ply.weaponUsed = ply.lastWeapon
					ply:TakeDamageInfo(dmg)
				else ply:SetHealth(ply:Health() - 1) end
			end)
		end
	end
	local function cant(ply)
		if ply.bleeding then return false, 'Ты при смерти' end
	end

	hook.Add('EntityTakeDamage', 'dbg-damage.dying', dying)
	hook.Add('CanPlayerEnterVehicle', 'dbg-damage.dying', cant)
	hook.Add('octoinv.canPickup', 'dbg-damage.dying', cant)
	hook.Add('octoinv.canUse', 'dbg-damage.dying', cant)
	hook.Add('dbg-hands.canPunch', 'dbg-damage.dying', cant)
	hook.Add('dbg-hands.canCloseLockable', 'dbg-damage.dying', cant)
	hook.Add('dbg-hands.canOpenLockable', 'dbg-damage.dying', cant)
	hook.Add('dbg-hands.canDrag', 'dbg-damage.dying', cant)

	hook.Add('PlayerDisconnected', 'dbg-damage.dying', function(ply)
		if ply.bleeding then
			local dmg = DamageInfo()
			dmg:SetDamage(ply:GetMaxHealth())
			ply.attackedBy = ply.lastAttacker
			if ply.lastDMGT then
				dmg:SetDamageType(ply.lastDMGT)
			end
			ply.weaponUsed = ply.lastWeapon
			ply:TakeDamageInfo(dmg)

			local sid = ply:SteamID()
			timer.Remove('dbg-damage.dying' .. sid)
			table.RemoveByValue(bleeding, sid)

			octodeath.triggerDeath(ply)
		end
	end)
end)

netstream.Hook('dbg-armor.unwear', function(ply)
	if not ply:Alive() then return end
	local data = ply.armorItem
	if not data then
		ply:Notify('warning', 'У тебя нет надетого бронежилета')
		return
	end
	if data.armor ~= ply:Armor() then
		ply:Notify('warning', 'Твой бронежилет поврежден')
		return
	end
	local inv = ply:GetInventory()
	local cont = inv and inv:GetContainer('_hand')
	if not cont then
		ply:Notify('warning', 'Освободи руки, чтобы туда можно было положить бронежилет')
		return
	end
	if cont:AddItem('armor', data) >= 1 then
		ply:SetArmor(0)
		ply.armorItem = nil
		ply:SetLocalVar('armor', nil)
		ply:EmitSound('npc/combine_soldier/gear3.wav', 55)
	else
		ply:Notify('warning', 'В руках недостаточно места')
	end
end)

CreateConVar('enhanceddamage_enabled', 1, {FCVAR_SERVER_CAN_EXECUTE,FCVAR_NOTIFY,FCVAR_ARCHIVE},'Enable enhanced damage')

CreateConVar('enhanceddamage_headdamagescale', 2, {FCVAR_SERVER_CAN_EXECUTE,FCVAR_NOTIFY,FCVAR_ARCHIVE},'Change the scale for this bodypart')
CreateConVar('enhanceddamage_armdamagescale', 0.50, {FCVAR_SERVER_CAN_EXECUTE,FCVAR_NOTIFY,FCVAR_ARCHIVE},'Change the scale for this bodypart')
CreateConVar('enhanceddamage_legdamagescale',0.50, {FCVAR_SERVER_CAN_EXECUTE,FCVAR_NOTIFY,FCVAR_ARCHIVE},'Change the scale for this bodypart')
CreateConVar('enhanceddamage_chestdamagescale', 1.25, {FCVAR_SERVER_CAN_EXECUTE,FCVAR_NOTIFY,FCVAR_ARCHIVE},'Change the scale for this bodypart')
CreateConVar('enhanceddamage_stomachdamagescale',0.75, {FCVAR_SERVER_CAN_EXECUTE,FCVAR_NOTIFY,FCVAR_ARCHIVE},'Change the scale for this bodypart')
CreateConVar('enhanceddamage_nutsdamagescale', 2, {FCVAR_SERVER_CAN_EXECUTE,FCVAR_NOTIFY,FCVAR_ARCHIVE},'Change the scale for this bodypart')
CreateConVar('enhanceddamage_handdamagescale', 0.25, {FCVAR_SERVER_CAN_EXECUTE,FCVAR_NOTIFY,FCVAR_ARCHIVE},'Change the scale for this bodypart')

CreateConVar('enhanceddamage_armdropchance',20, {FCVAR_SERVER_CAN_EXECUTE,FCVAR_NOTIFY,FCVAR_ARCHIVE},'The weapon drop chance for ')
CreateConVar('enhanceddamage_handdropchance', 40, {FCVAR_SERVER_CAN_EXECUTE,FCVAR_NOTIFY,FCVAR_ARCHIVE},'Change the scale for this bodypart')

CreateConVar('enhanceddamage_enablesounds', 1, {FCVAR_SERVER_CAN_EXECUTE,FCVAR_NOTIFY,FCVAR_ARCHIVE},'Enable the sounds when hurt ')

CreateConVar('enhanceddamage_legbreak', 1, {FCVAR_SERVER_CAN_EXECUTE,FCVAR_NOTIFY,FCVAR_ARCHIVE},'Enable enhanced damage')
CreateConVar('enhanceddamage_npcweapondrop',1,{FCVAR_SERVER_CAN_EXECUTE,FCVAR_NOTIFY,FCVAR_ARCHIVE},'Enable weapon dropping for npcs (Really buggy)')
CreateConVar('enhanceddamage_falldamage',1,{FCVAR_SERVER_CAN_EXECUTE,FCVAR_NOTIFY,FCVAR_ARCHIVE},'Enable enhanced falldamage (Much more "realistic" and breaks your bones)')
CreateConVar('enhanceddamage_npcfalldamage',1,{FCVAR_SERVER_CAN_EXECUTE,FCVAR_NOTIFY,FCVAR_ARCHIVE},'Enable falldamage for NPC')
CreateConVar('enhanceddamage_drowningdamage',1,{FCVAR_SERVER_CAN_EXECUTE,FCVAR_NOTIFY,FCVAR_ARCHIVE},'Toggle drowning')


CreateConVar('enhanceddamage_ragdolls',0,{FCVAR_SERVER_CAN_EXECUTE,FCVAR_NOTIFY,FCVAR_ARCHIVE},'Enable enhanced ragdolls.')
CreateConVar('enhanceddamage_autoremoveragdolls',20,{FCVAR_SERVER_CAN_EXECUTE,FCVAR_NOTIFY,FCVAR_ARCHIVE},'Time before the ragdolls are remove (0 for never)')
