/*---------------------------------------------------------------------------
DarkRP hooks
---------------------------------------------------------------------------*/
function GM:Initialize()
	self.BaseClass:Initialize()
end

gameevent.Listen('player_connect')
gameevent.Listen('player_disconnect')

local noNotify = {}
hook.Add('player_connect', 'ShowConnect', function( data )
	local steamID = data['networkid']

	if noNotify[steamID] then return end
	noNotify[steamID] = true
	timer.Simple(120, function()
		noNotify[steamID] = nil
	end)

	local function welcome(name, new)
		if not name then
			name = data['name'] or 'BOT'
		end

		local txt = L.go_to_town:format(name, netvars.GetNetVar('cityName', L.dobrograd))
		local receivers = octolib.array.filter(player.GetAll(), function(ply) return ply:GetInfo('cl_dbg_enter') == '1' end)

		if new then
			netstream.Start(receivers, 'octolib.notify', 'ooc', L.not_appear_here_before:format(name))
			print(('%s (%s) joined first time'):format(steamID, name))
		end
		print(txt)
		netstream.Start(receivers, 'octolib.notify', 'ooc', txt)
	end

	octolib.getDBVar(steamID, 'lastRPName')
		:Then(welcome)
		-- :Catch(function() welcome(data['name'] or 'BOT', true) end)
end)

hook.Add('player_disconnect', 'ShowDisconnect', function( data )
	--octolib.notify.sendAll('ooc', data['name'] .. ' ушел')
end)

-- hook.Add('PlayerInitialSpawn', 'LoadPlayerOnInitialSpawn', function ( ply )
--	 local function retry()
--		 if not IsValid( ply ) or not ply.Nick then
--			 timer.Simple( 3, retry )
--			 return
--		 end

--		 local txt = ply:Nick() .. ' приехал в город!'
--		 octolib.notify.sendAll('ooc', txt)
--		 print( '[LOG] ' .. txt )
--	 end

--	 timer.Simple( 3, retry )
-- end)

local disallowedNames = {['ooc'] = true, ['shared'] = true, ['world'] = true, ['world prop'] = true}
function GM:CanChangeRPName(ply, RPname)
	if disallowedNames[string.lower(RPname)] then return false, 'Forbidden name' end
	--if not string.match(RPname, '^[a-zA-Z0-9 ]+$') then return false, 'Illegal characters' end

	local len = string.len(RPname)
	if len > 50 then return false, L.too_long2 end
	if len < 3 then return false, L.too_short2 end
end

function GM:PlayerDeathSound()
	return true
end

function GM:canDemote(ply, target, reason)

end

function GM:canVote(ply, vote)

end

function GM:playerWalletChanged(ply, amount)

end

function GM:playerGetSalary(ply, amount)

end

function GM:playerBoughtVehicle(ply, ent, cost)

end

function GM:playerBoughtDoor(ply, ent, cost)

end

function GM:canDropWeapon(ply, weapon)
	if not IsValid(weapon) then return false end
	local class = string.lower(weapon:GetClass())

	if not ply:Alive() or ply:IsGhost() then return false end
	if not GAMEMODE.Config.dropspawnedweapons and ply:jobHasWeapon(class) then return false end
	if self.Config.DisallowDrop[class] then return false end

	return not GAMEMODE.Config.restrictdrop
end

function GM:DatabaseInitialized()
	DarkRP.initDatabase()
end

function GM:canSeeLogMessage(ply, message, colour)
	return true
end

/*---------------------------------------------------------
 Gamemode functions
 ---------------------------------------------------------*/

function GM:PlayerSpawnProp(ply, model)
	-- No prop spawning means no prop spawning.
	local allowed = GAMEMODE.Config.propspawning

	if not allowed then return false end
	if ply:isArrested() then return false end

	model = string.gsub(tostring(model), '\\', '/')
	model = string.gsub(tostring(model), '//', '/')

	local jobTable = ply:getJobTable()
	if jobTable.PlayerSpawnProp then
		jobTable.PlayerSpawnProp(ply, model)
	end

	return self.BaseClass:PlayerSpawnProp(ply, model)
end

function GM:PlayerSpawnedProp(ply, model, ent)
	self.BaseClass:PlayerSpawnedProp(ply, model, ent)
	ent.SID = ply.SID
	ent:CPPISetOwner(ply)

	local phys = ent:GetPhysicsObject()
	if phys and phys:IsValid() then
		ent.RPOriginalMass = phys:GetMass()
	end

	if GAMEMODE.Config.proppaying then
		if ply:canAfford(GAMEMODE.Config.propcost) then
			ply:Notify(L.deducted_money:format(DarkRP.formatMoney(GAMEMODE.Config.propcost)))
			ply:addMoney(-GAMEMODE.Config.propcost)
		else
			ply:Notify('warning', L.need_money:format(DarkRP.formatMoney(GAMEMODE.Config.propcost)))
			SafeRemoveEntity(ent)
			return false
		end
	end
end


local function checkAdminSpawn(ply, configVar, errorStr)
	if ply == nil || !IsValid( ply ) then return true end

	local config = GAMEMODE.Config[configVar]

	if (config == true or config == 1) and ply:EntIndex() ~= 0 and not ply:IsAdmin() then
		ply:Notify('warning', L.need_admin:format(L[errorStr] or errorStr))
		return false
	elseif config == 2 and ply:EntIndex() ~= 0 and not ply:IsSuperAdmin() then
		ply:Notify('warning', L.need_sadmin:format(L[errorStr] or errorStr))
		return false
	elseif config == 3 and ply:EntIndex() ~= 0 then
		ply:Notify('warning', L.disabled:format(L[errorStr] or errorStr, L.see_settings))
		return false
	end

	return true
end

function GM:PlayerSpawnSENT(ply, class)
	return checkAdminSpawn(ply, 'adminsents', 'gm_spawnsent') and self.BaseClass:PlayerSpawnSENT(ply, class) and not ply:isArrested()
end

function GM:PlayerSpawnedSENT(ply, ent)
	self.BaseClass:PlayerSpawnedSENT(ply, ent)
end

local function canSpawnWeapon(ply)
	if (GAMEMODE.Config.adminweapons == 0 and ply:IsAdmin()) or
	(GAMEMODE.Config.adminweapons == 1 and ply:IsSuperAdmin()) then
		return true
	end
	ply:Notify('warning', 'You cannot spawn weapons')

	return false
end

function GM:PlayerSpawnSWEP(ply, class, info)
	return canSpawnWeapon(ply) and self.BaseClass:PlayerSpawnSWEP(ply, class, info) and not ply:isArrested()
end

function GM:PlayerGiveSWEP(ply, class, info)
	return canSpawnWeapon(ply) and self.BaseClass:PlayerGiveSWEP(ply, class, info) and not ply:isArrested()
end

function GM:PlayerSpawnEffect(ply, model)
	return self.BaseClass:PlayerSpawnEffect(ply, model) and not ply:isArrested()
end

function GM:PlayerSpawnVehicle(ply, model, class, info)
	if ply == nil || !IsValid( ply ) then return true end
	return checkAdminSpawn(ply, 'adminvehicles', 'gm_spawnvehicle') and self.BaseClass:PlayerSpawnVehicle(ply, model, class, info) and not ply:isArrested()
end

function GM:PlayerSpawnedVehicle(ply, ent)
	self.BaseClass:PlayerSpawnedVehicle(ply, ent)
end

function GM:PlayerSpawnNPC(ply, type, weapon)
	return checkAdminSpawn(ply, 'adminnpcs', 'gm_spawnnpc') and self.BaseClass:PlayerSpawnNPC(ply, type, weapon) and not ply:isArrested()
end

function GM:PlayerSpawnedNPC(ply, ent)
	self.BaseClass:PlayerSpawnedNPC(ply, ent)
end

function GM:PlayerSpawnRagdoll(ply, model)
	return self.BaseClass:PlayerSpawnRagdoll(ply, model) and not ply:isArrested()
end

function GM:PlayerSpawnedRagdoll(ply, model, ent)
	self.BaseClass:PlayerSpawnedRagdoll(ply, model, ent)
	ent.SID = ply.SID
end

function GM:EntityRemoved(ent)
	self.BaseClass:EntityRemoved(ent)
	if ent:IsVehicle() then
		local found = ent:CPPIGetOwner()
		if IsValid(found) then
			found.Vehicles = found.Vehicles or 1
			found.Vehicles = found.Vehicles - 1
		end
	end
end

function GM:ShowSpare1(ply)
	local jobTable = ply:getJobTable()
	if jobTable.ShowSpare1 then
		return jobTable.ShowSpare1(ply)
	end
end

function GM:ShowSpare2(ply)
	local jobTable = ply:getJobTable()
	if jobTable.ShowSpare2 then
		return jobTable.ShowSpare2(ply)
	end
end

function GM:ShowTeam(ply)
end

function GM:ShowHelp(ply)
end

function GM:OnNPCKilled(victim, ent, weapon)
	-- If something killed the npc
	if not ent then return end

	if ent:IsVehicle() and ent:GetDriver():IsPlayer() then ent = ent:GetDriver() end

	-- If it wasn't a player directly, find out who owns the prop that did the killing
	if not ent:IsPlayer() then
		ent = Player(tonumber(ent.SID) or 0)
	end

	-- If we know by now who killed the NPC, pay them.
	if IsValid(ent) and GAMEMODE.Config.npckillpay > 0 then
		ent:addMoney(GAMEMODE.Config.npckillpay)
		ent:Notify(L.npc_killpay:format(DarkRP.formatMoney(GAMEMODE.Config.npckillpay)))
	end
end

function GM:KeyPress(ply, code)
	self.BaseClass:KeyPress(ply, code)
end

-- local function IsInRoom(listener, talker) -- IsInRoom function to see if the player is in the same room.
--	 local tracedata = {}
--	 tracedata.start = talker:GetShootPos()
--	 tracedata.endpos = listener:GetShootPos()
--	 local trace = util.TraceLine(tracedata)

--	 return not trace.HitWorld
-- end

local threed = GM.Config.voice3D
local vrad = GM.Config.voiceradius
local dynv = GM.Config.dynamicvoice
-- proxy function to take load from PlayerCanHearPlayersVoice, which is called a quadratic amount of times per tick,
-- causing a lagfest when there are many players
-- local function calcPlyCanHearPlayerVoice(listener)
--	 if not IsValid(listener) then return end
--	 listener.DrpCanHear = listener.DrpCanHear or {}
--	 for _, talker in pairs(player.GetAll()) do
--		 listener.DrpCanHear[talker] = not vrad or -- Voiceradius is off, everyone can hear everyone
--			 (listener:GetShootPos():DistToSqr(talker:GetShootPos()) < 302500 and -- voiceradius is on and the two are within hearing distance
--				 (not dynv or IsInRoom(listener, talker))) -- Dynamic voice is on and players are in the same room
--	 end
-- end
hook.Add('PlayerInitialSpawn', 'DarkRPCanHearVoice', function(ply)

end)

hook.Add('PlayerDisconnected', 'DarkRPCanHearVoice', function(ply)
	-- if not ply.DrpCanHear then return end
	-- for k,v in pairs(player.GetAll()) do
	--	 if not v.DrpCanHear then continue end
	--	 v.DrpCanHear[ply] = nil
	-- end
	-- timer.Remove(ply:UserID() .. 'DarkRPCanHearPlayersVoice')

	local txt = L.go_from_town:format(ply:Name())
	-- octolib.notify.sendAll('ooc', txt)
	print( '[LOG] ' .. txt )
end)

function GM:PlayerCanHearPlayersVoice(listener, talker)
	if not self.Config.deadvoice and not talker:Alive() then return false end

	local canHear = false
	if not vrad or talker:GetShootPos():DistToSqr( listener:GetShootPos() ) < talker:GetNetVar('TalkRange', 150000) then
		canHear = true
	end

	return canHear, threed
end

function GM:CanTool(ply, trace, mode)
	if not self.BaseClass:CanTool(ply, trace, mode) then return false end

	if IsValid(trace.Entity) then
		if trace.Entity.onlyremover then
			if mode == 'remover' then
				return (ply:IsAdmin() or ply:IsSuperAdmin())
			else
				return false
			end
		end

		if trace.Entity.nodupe and (mode == 'weld' or
					mode == 'weld_ez' or
					mode == 'spawner' or
					mode == 'duplicator' or
					mode == 'adv_duplicator') then
			return false
		end

		if trace.Entity:IsVehicle() and mode == 'nocollide' and not GAMEMODE.Config.allowvnocollide then
			return false
		end
	end
	return true
end

function GM:CanPlayerSuicide(ply)
	ply:Notify(L.see_around_friend)
	return false
end

function GM:CanDrive(ply, ent)
	ply:Notify('warning', 'Drive disabled for now')
	return false -- Disabled until people can't minge with it anymore
end

function GM:CanProperty(ply, property, ent)
	if self.Config.allowedProperties[property] and ent:CPPICanTool(ply, 'remover') then
		return true
	end

	if property == 'persist' and ply:IsSuperAdmin() then
		return true
	end
	ply:Notify('warning', 'Property disabled for now')
	return false -- Disabled until antiminge measure is found
end

function GM:PlayerShouldTaunt(ply, actid)
	return false
end

function GM:DoPlayerDeath(ply, attacker, dmg, ...)
	local weapon = ply:GetActiveWeapon()
	-- local canDrop = hook.Call('canDropWeapon', self, ply, weapon)
	if IsValid(weapon) and not (self.Config.DisallowDrop[ weapon:GetClass() ] or ply:jobHasWeapon(weapon:GetClass())) then
		local ent = ply:dropDRPWeapon(weapon)
		if IsValid(ent) and ent.IsLethal then
			ent.isEvidence = true
		end
	end

	ply:CreateRagdoll(attacker, dmg)
	ply:AddDeaths(1)

	local corpse = ply:GetNetVar('DeathRagdoll')
	if IsValid(corpse) and ply.inv then
		local inv = corpse:CreateInventory()
		for contID, cont in pairs(ply.inv.conts) do
			cont.name = L.inventory_corpse .. cont.name
			cont:MoveTo(inv)
			if contID == '_hand' then
				cont:Remove(true)
			end
		end

		ply.inv:Remove()
		ply:ImportInventory({
			top = {
				name = L.jacket,
				volume = 5,
				icon = octolib.icons.color('clothes_jacket'),
				items = {},
			},
			bottom = {
				name = L.pants,
				volume = 1,
				icon = octolib.icons.color('clothes_jeans'),
				items = {},
			},
		})
	end
end

function GM:PlayerDeath(ply, weapon, killer)
	local jobTable = ply:getJobTable()
	if jobTable.PlayerDeath then
		jobTable.PlayerDeath(ply, weapon, killer)
	end

	if GAMEMODE.Config.deathblack then
		SendUserMessage('blackScreen', ply, true)
	end

	if weapon:IsVehicle() and weapon:GetDriver():IsPlayer() then killer = weapon:GetDriver() end

	if GAMEMODE.Config.showdeaths then
		self.BaseClass:PlayerDeath(ply, weapon, killer)
	end

	ply:Extinguish()

	if ply:InVehicle() then ply:ExitVehicle() end

	if ply:isArrested() and not GAMEMODE.Config.respawninjail  then
		-- If the player died in jail, make sure they can't respawn until their jail sentance is over
		ply.NextSpawnTime = CurTime() + math.ceil(GAMEMODE.Config.jailtimer - (CurTime() - ply.LastJailed)) + 1
		octolib.notify.sendAll('ooc', L.died_in_jail:format(ply:Nick()))
		ply:Notify('ooc', L.dead_in_jail)
	else
		-- Normal death, respawning.
		ply.NextSpawnTime = CurTime() + math.Clamp(GAMEMODE.Config.respawntime, 0, 10)
	end
	ply.DeathPos = ply:GetPos()

	if IsValid(ply) and (ply ~= killer or ply.Slayed) and not ply:isArrested() then
		ply:SetNetVar('wanted', nil)
		ply.DeathPos = nil
		ply.Slayed = false
	end

	ply.ConfiscatedWeapons = nil

end

function GM:PlayerCanPickupWeapon(ply, weapon)
	if ply:isArrested() and weapon:GetClass() ~= 'weapon_cuffed' then return false end
	if weapon.PlayerUse == false then return false end
	if ply:IsAdmin() and GAMEMODE.Config.AdminsCopWeapons then return true end

	if GAMEMODE.Config.license and not ply:GetNetVar('HasGunlicense') and not ply.RPLicenseSpawn then
		if GAMEMODE.NoLicense[string.lower(weapon:GetClass())] or not weapon:IsWeapon() then
			return true
		end
		return false
	end

	local jobTable = ply:getJobTable()
	if jobTable.PlayerCanPickupWeapon then
		jobTable.PlayerCanPickupWeapon(ply, weapon)
	end
	return true
end

function GM:PlayerSetModel(ply)
	-- handled in core-char addon

	self.BaseClass:PlayerSetModel(ply)
	ply:SetupHands()
end

local function initPlayer(ply)

	ply:updateJob(team.GetName(GAMEMODE.DefaultTeam))
	ply.LastJob = nil -- so players don't have to wait to get a job after joining

	ply:SetTeam(GAMEMODE.DefaultTeam)

end

function GM:PlayerInitialSpawn(ply)
	self.BaseClass:PlayerInitialSpawn(ply)
	initPlayer(ply)
	ply.SID = ply:UserID()

	timer.Remove('unOwnDoors' .. ply:SteamID())
end

local spawnsConf = {
	rp_evocity_dbg_220222 = {
		Vector(4888, 2904, 72),
		Vector(4788, 2904, 72),
		Vector(4688, 2904, 72),
		Vector(4588, 2904, 72),
		Vector(4488, 2904, 72),
		Vector(4888, 2832, 72),
		Vector(4788, 2832, 72),
		Vector(4688, 2832, 72),
		Vector(4588, 2832, 72),
		Vector(4488, 2832, 72),
		Vector(-52, 13705, 75),
		Vector(55, 14196, 58),
		Vector(276, 14343, 64),
		Vector(93, 14454, 76),
		Vector(153, 14046, 60),
		Vector(157, 13837, 68),
		Vector(32, 13839, 89),
		Vector(165, 13716, 70),
		Vector(4, 14077, 69),
		Vector(179, 14219, 70),
		Vector(229, 14450, 63),
	},
	rp_truenorth_v1a = {
		Vector(13616, -11678, 0),
		Vector(13765, -12008, 0),
		Vector(13508, -12328, 0),
		Vector(13079, -12289, 0),
		Vector(12790, -12096, 0),
		Vector(12665, -11751, 0),
		Vector(-8664, -11665, 0),
		Vector(-8841, -11963, 0),
		Vector(-9258, -12122, 0),
		Vector(-9671, -11976, 0),
		Vector(-9708, -11714, 0),
		Vector(-9607, -12409, 0),
		Vector(-8871, -12431, 0),
		Vector(8365, 6513, 8),
		Vector(8655, 6494, 8),
		Vector(8714, 6811, 8),
		Vector(8433, 6821, 8),
		Vector(8252, 7128, 8),
		Vector(8317, 5906, 7),
		Vector(8460, 7728, 11),
	},
	rp_riverden_dbg_220313 = {
		Vector(-13372, 12972, 65),
		Vector(-13375, 13137, 65),
		Vector(-13378, 13282, 65),
		Vector(-13380, 13451, 65),
		Vector(-13382, 13563, 65),
		Vector(-13385, 13725, 65),
		Vector(-13388, 13859, 65),
		Vector(-13389, 14041, 65),
	},
}

local nextSpawn = 1
function GM:PlayerSelectSpawn(ply)
	local spawn = self.BaseClass:PlayerSelectSpawn(ply)

	local jobTable = ply:getJobTable()
	if jobTable.PlayerSelectSpawn then
		jobTable.PlayerSelectSpawn(ply, spawn)
	end

	local POS
	if spawn and spawn.GetPos then
		POS = spawn:GetPos()
	else
		POS = ply:GetPos()
	end

	local mapSpawns = spawnsConf[game.GetMap()]
	if mapSpawns then
		POS = mapSpawns[nextSpawn]
		nextSpawn = nextSpawn + 1
		if nextSpawn > #mapSpawns then nextSpawn = 1 end
	end

	-- Spawn where died in certain cases
	if GAMEMODE.Config.strictsuicide and ply.DeathPos then
		POS = ply.DeathPos
	end

	if ply:isArrested() then
		POS = dbgPolice.nextJailPos() or ply.DeathPos -- If we can't find a jail pos then we'll use where they died as a last resort
	end

	-- Make sure the player doesn't get stuck in something
	if isvector(POS) then
		POS = DarkRP.findEmptyPos(POS, {ply}, 600, 30, Vector(16, 16, 64))
	end

	return spawn, POS
end

local i = 1
function GM:PlayerSpawn(ply)
	-- ply:CrosshairEnable()
	ply:UnSpectate()
	if not ply.passedTest then
		if game.GetMap():find('rp_evocity_dbg') then
			local x = i % 9 - 4
			local y = math.floor(i / 9) - 4
			ply:SetPos(ply:GetPos() + Vector(x * 50, y * 50, 30))
			i = i + 1
			if i > 81 then i = 1 end
		end
	end

	ply:Extinguish()
	if ply:GetActiveWeapon() and IsValid(ply:GetActiveWeapon()) then
		ply:GetActiveWeapon():Extinguish()
	end

	for _,v in ipairs(ents.FindByClass('predicted_viewmodel')) do -- Money printer ignite fix
		v:Extinguish()
	end

	if ply.demotedWhileDead then
		ply.demotedWhileDead = nil
		ply:changeTeam(GAMEMODE.DefaultTeam, true)
	end

	local jobTable = ply:getJobTable()

	player_manager.SetPlayerClass(ply, jobTable.playerClass or 'player_darkrp')

	ply:applyPlayerClassVars(true)

	player_manager.RunClass(ply, 'Spawn')

	hook.Call('PlayerLoadout', self, ply)
	-- hook.Call('PlayerSetModel', self, ply)

	local _, pos = self:PlayerSelectSpawn(ply)
	ply:SetPos(pos)

	if jobTable.PlayerSpawn then
		jobTable.PlayerSpawn(ply)
	end

	ply:SetCanWalk( false )

	timer.Simple(0, function()
		ply:SelectWeapon('dbg_hands')
	end)

end

function GM:PlayerLoadout(ply)
	self.BaseClass:PlayerLoadout(ply)

	if ply:isArrested() then return end
	if not ply:Alive() or ply:IsGhost() then
		ply:Give('dbg_hands')
		return
	end

	ply.RPLicenseSpawn = true
	timer.Simple(1, function()
		if not IsValid(ply) then return end
		ply.RPLicenseSpawn = false
	end)

	local jobTable = ply:getJobTable()

	for k,v in pairs(jobTable.weapons or {}) do
		if istable(v) then
			local wep = ply:Give(v[1])
			wep.WorldModel = v[2]
			wep:Initialize()
			if IsValid(wep) then
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

	if jobTable.PlayerLoadout then
		local val = jobTable.PlayerLoadout(ply)
		if val == true then
			ply:SwitchToDefaultWeapon()
			return
		end
	end

	if jobTable.ammo then
		for k, v in pairs(jobTable.ammo) do
			ply:SetAmmo(v, k)
		end
	end

	for k, v in pairs(self.Config.DefaultWeapons) do
		ply:Give(v)
	end

	if ply:IsAdmin() then

		for k,v in pairs(GAMEMODE.Config.AdminWeapons) do
			ply:Give(v)
		end

		if not GAMEMODE.Config.AdminsCopWeapons then return ply:SwitchToDefaultWeapon() end

		ply:Give('door_ram')
		ply:Give('arrest_stick')
		ply:Give('unarrest_stick')
		ply:Give('stunstick')
		ply:Give('weaponchecker')
	end

	ply:SwitchToDefaultWeapon()
end

function GM:PlayerDisconnected(ply)
	--self.BaseClass:PlayerDisconnected(ply)
	timer.Remove(ply:SteamID() .. 'jobtimer')

	local isMayor = ply:isMayor()

	if isMayor and GAMEMODE.Config.shouldResetLaws then
		DarkRP.resetLaws()
	end

	local steamID = ply:SteamID()
	local estates = ply:GetOwnedEstates()
	timer.Create('unOwnDoors' .. steamID, 600, 1, function()
		for _,v in ipairs(estates) do
			if dbgEstates.removeOwner(v, steamID) then
				hook.Run('dbg-estates.unowned', steamID, v)
			end
		end
	end)

	local agenda = ply:getAgendaTable()

	-- Clear agenda
	if agenda and ply:Team() == agenda.Manager and team.NumPlayers(ply:Team()) <= 1 then
		agenda.text = nil
		for k,v in ipairs(player.GetAll()) do
			if v:getAgendaTable() ~= agenda then continue end
			v:SetLocalVar('agenda', agenda.text)
		end
	end

	local jobTable = ply:getJobTable()
	if jobTable.PlayerDisconnected then
		jobTable.PlayerDisconnected(ply)
	end
end

GM.GetFallDamage = octolib.func.zero
local InitPostEntityCalled = false

local function fuckQAC()
	local netRecs = {'Debug1', 'Debug2', 'checksaum', 'gcontrol_vars', 'control_vars', 'QUACK_QUACK_MOTHER_FUCKER'}
	for k,v in ipairs(netRecs) do
		net.Receivers[v] = fn.Id
	end
end

function GM:InitPostEntity()
	InitPostEntityCalled = true

	local physData = physenv.GetPerformanceSettings()
	physData.MaxVelocity = 2000
	physData.MaxAngularVelocity = 3636

	physenv.SetPerformanceSettings(physData)

	-- Scriptenforcer enabled by default? Fuck you, not gonna happen.
	if not GAMEMODE.Config.disallowClientsideScripts then
		game.ConsoleCommand('sv_allowcslua 1\n')
		timer.Simple(1, fuckQAC) -- Also, fuck QAC which bans innocent people when allowcslua = 1
	end
	game.ConsoleCommand('physgun_DampingFactor 0.9\n')
	game.ConsoleCommand('sv_sticktoground 0\n')
	game.ConsoleCommand('sv_airaccelerate 1000\n')
	-- sv_alltalk must be 0
	-- Note, everyone will STILL hear everyone UNLESS GM.Config.voiceradius is set to true
	-- This will fix the GM.Config.voiceradius not working
	game.ConsoleCommand('sv_alltalk 0\n')

	if GAMEMODE.Config.unlockdoorsonstart then
		for k, v in ipairs(ents.GetAll()) do
			if v:IsDoor() then v:Fire('unlock', '', 0) end
		end
	end
end
timer.Simple(0.1, function()
	if not InitPostEntityCalled then
		GAMEMODE:InitPostEntity()
	end
end)

function GM:loadCustomDarkRPItems()
	-- Error when the default team isn't set
	if not GAMEMODE.DefaultTeam or not RPExtraTeams[GAMEMODE.DefaultTeam] then
		local hints = {
			'This may happen when you disable the default citizen job. Make sure you update GAMEMODE.DefaultTeam to the new default team.',
			'GAMEMODE.DefaultTeam may be set to a job that does not exist anymore. Did you remove the job you had set to default?',
			'The error being in jobs.lua is a guess. This is usually right, but the problem might lie somewhere else.'
		}

		-- Gotta be totally clear here
		local stack = '\tjobs.lua, settings.lua, disabled_defaults.lua or any of your other custom files.'
		DarkRP.error('GAMEMODE.DefaultTeam is not set to an existing job.', 1, hints, 'lua/darkrp_customthings/jobs.lua', -1, stack)
	end
end

function GM:PlayerLeaveVehicle(ply, vehicle)
	self.BaseClass:PlayerLeaveVehicle(ply, vehicle)
end

function GM:PlayerSpray()
	return not GAMEMODE.Config.allowsprays
end
