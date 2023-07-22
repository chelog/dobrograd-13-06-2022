octodeath.DeathRagdolls = octodeath.DeathRagdolls or {}
local PM = FindMetaTable('Player')
local EM = FindMetaTable('Entity')
local maxPerPlayer = octodeath.config.ragdollsPerPlayer
local maxPerServer = octodeath.config.ragdollsPerServer

local baseTime = 30 * 60 -- 30 mins
local minTime = 15 * 60 -- 15 mins
local maxTime = 4.5 * 60 * 60 -- 4.5 hours

function octodeath.getSpawnTime(ply)
	if ply:GetDBVar('ghostTime') then return ply:GetDBVar('ghostTime') end
	if ply:Team() == TEAM_PRIEST then return minTime end
	local karma = ply:GetKarma()
	return math.Clamp(baseTime - (karma > 0 and (karma * 3) or (karma * 12)), minTime, maxTime)
end

function octodeath.triggerDeath(ply)
	local time = math.max(hook.Run('dbg-ghosts.overrideTime', ply) or octodeath.getSpawnTime(ply), 10)
	ply:SetNetVar('_SpawnTime', CurTime() + time)
	ply:SetNetVar('_GhostTime', CurTime() + math.min(time, octodeath.config.ghostTime))
	ply:SetDBVar('ghostTime', time)
end

local curGhosts = {}
function PM:SetGhost(val)
	if val then
		curGhosts[self] = true
		self:SetNetVar('Ghost', true)
	else
		curGhosts[self] = nil
		self:SetNetVar('Ghost', false)

		if self:GetNetVar('launcherActivated') then
			self:SetDBVar('ghostTime', nil)
			self:SetDBVar('ghostBuffs', nil)
		end
	end
end

function player.GetGhosts()
	return table.GetKeys(curGhosts)
end

hook.Add('GetPlayerChatColor', 'ghosts-chatcolor', function(ply, txt)
	if ply:IsGhost() or not ply:Alive() then
		return octochat.textColors.ooc
	end
end)

hook.Add('PlayerCanSeePlayersChat', 'chelog-death', function(txt, t, listener, talker)

	if talker:IsGhost() and not listener:IsGhost() and listener:Team() ~= TEAM_ADMIN then
		return false
	end

end)

hook.Add('PlayerInitialSpawn', 'SendCorpsesColorsOnConnected', function(ply)
	timer.Simple(5, function()
		netstream.Start(ply, 'CorpsesCreated', octodeath.DeathRagdolls)
	end)
end)

local protectedNVars = { {'name', 'seesName'}, {'attacker'}, {'bullet', 'seesCaliber'}, {'weapon', 'seesCaliber'}, {'time', 'seesTime'} }
for _, v in ipairs(protectedNVars) do
	netvars.Register('Corpse.' .. v[1], {
		checkAccess = function(ply)
			return v[2] and ply:getJobTable()[v[2]] or ply:Team() == TEAM_ADMIN
		end,
	})
end

local deathCauses = L.deathCauses
function PM:CreateRagdoll(attacker, dmg)

	if not attacker then
		attacker = dmg:GetAttacker()
	end

	-- remove old player ragdolls
	if not self.DeathRagdolls then self.DeathRagdolls = {} end
	local numPlyR = 1
	for k,rag in pairs(self.DeathRagdolls) do
		if IsValid(rag) then
			numPlyR = numPlyR + 1
		else
			self.DeathRagdolls[k] = nil
		end
	end
	if maxPerPlayer >= 0 and numPlyR > maxPerPlayer then
		for i = 0,numPlyR do
			if numPlyR > maxPerPlayer then
				self.DeathRagdolls[1]:Remove()
				table.remove(self.DeathRagdolls, 1)
				numPlyR = numPlyR - 1
			else
				break
			end
		end
	end

	-- remove old server ragdolls
	local c2 = 1
	for k,rag in pairs(octodeath.DeathRagdolls) do
		if IsValid(rag) then
			c2 = c2 + 1
		else
			octodeath.DeathRagdolls[k] = nil
		end
	end
	if maxPerServer >= 0 and c2 > maxPerServer then
		for i = 0,c2 do
			if c2 > maxPerServer then
				if IsValid(octodeath.DeathRagdolls[1]) then
					octodeath.DeathRagdolls[1]:Remove()
				end
				table.remove(octodeath.DeathRagdolls,1)
				c2 = c2 - 1
			else
				break
			end
		end
	end

	local Data = duplicator.CopyEntTable(self)
	local subMats = {}
	for i = 0, #self:GetMaterials() - 1 do
		subMats[i] = self:GetSubMaterial(i)
	end

	local destroyIn = math.max(octodeath.getSpawnTime(self), octodeath.config.minCorpseTime)
	local ent = ents.Create('prop_ragdoll')
		duplicator.DoGeneric(ent, Data)
	ent:Spawn()
	ent:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	for id, mat in pairs(subMats) do
		ent:SetSubMaterial(id, mat)
	end
	ent:Fire('kill', '', destroyIn)
	if ent.SetPlayerColor then
		ent:SetPlayerColor(self:GetPlayerColor())
	end
	ent:SetNetVar('RagdollOwner', self)
	ent.ragdollSID = self:SteamID()

	local cause, weapon = table.Random(deathCauses.unknown)
	for k, v in pairs(deathCauses) do
		if isnumber(k) and dmg:IsDamageType(k) then
			cause = table.Random(v)
			weapon = self.lastWeapon or L.unknown
		end
	end

	ent:SetNetVar('dbgLook', {
		name = '',
		desc = 'corpseDesc',
		descRender = true,
		time = 8,
	})

	ent:SetNetVar('Corpse.name', self:Name())
	ent:SetNetVar('Corpse.attacker', self.lastAttacker or L.unknown)
	ent:SetNetVar('Corpse.bullet', dmg:IsDamageType(DMG_BULLET))
	ent:SetNetVar('Corpse.cause', cause)
	ent:SetNetVar('Corpse.weapon', weapon)
	ent:SetNetVar('Corpse.time', CWI.TimeToString())

	-- apply force to hit bone
	local hitPos = dmg:GetDamagePosition()
	local force = dmg:GetDamageForce()
	local vel = self.lastVelocity or self:GetVelocity()
	local physNum = ent:GetPhysicsObjectCount()
	local minDist, hitBone = 1000000
	for id = 0, physNum - 1 do
		local phys = ent:GetPhysicsObjectNum(id)
		if IsValid(phys) then
			local bone = ent:TranslatePhysBoneToBone(id)
			local pos, ang = self:GetBonePosition(bone)
			phys:SetPos(pos)
			phys:SetAngles(ang)
			phys:AddVelocity(vel)

			local testDist = hitPos:DistToSqr(pos)
			if testDist < minDist then
				hitBone = phys
				minDist = testDist
			end
		end
	end

	if hitBone then
		hitBone:ApplyForceOffset(force / 2, hitPos)
	end

	-- finish up
	ent:SetNetVar('DeathTime', CurTime())
	self:SetNetVar('DeathRagdoll', ent)
	timer.Simple(0, function()
		if not IsValid(self) or not IsValid(ent) then return end
		self:SetNetVar('DeathRagdoll')
		self:SetNetVar('DeathRagdoll', ent)
	end)
	self:SetGhost(true)
	self:SetClothes(nil)
	table.insert(self.DeathRagdolls, ent)
	table.insert(octodeath.DeathRagdolls, ent)

end

hook.Add('PlayerShouldTakeDamage', 'dbg-death', function(ply)
	ply.lastVelocity = ply:GetVelocity()
end)

if not PM.GetRagdollEntityOld then
	PM.GetRagdollEntityOld = PM.GetRagdollEntity
end
function PM:GetRagdollEntity()
	local ent = self:GetNetVar('DeathRagdoll')
	if IsValid(ent) then
		return ent
	else
		return self:GetRagdollEntityOld()
	end
end

if not PM.GetRagdollOwnerOld then
	PM.GetRagdollOwnerOld = PM.GetRagdollOwner
end
function EM:GetRagdollOwner()
	local ent = self:GetNetVar('RagdollOwner')
	if IsValid(ent) then
		return ent
	end
	if self.ragdollSID then
		ent = player.GetBySteamID(self.ragdollSID)
		if IsValid(ent) then return ent end
	end
	return self.GetRagdollOwnerOld and self:GetRagdollOwnerOld() or Entity(0)
end

local function penalty(ply)
	if ply:GetNetVar('launcherActivated') and (ply:GetNetVar('Ghost') or not ply:Alive()) then
		ply:SetDBVar('ghostTime', ply:GetNetVar('_SpawnTime') - CurTime())
	end
end
hook.Add('PlayerDisconnected', 'dbg-ghost.setGhostAgain', penalty)

local function check(ply)
	if not IsValid(ply) then return end
	if not ply:GetDBVar('ghostTime') then return end
	ply:Notify('warning', L.death_leave)
	ply:KillSilent()
	ply.inv = nil
end
hook.Add('dbg-test.complete', 'dbg-ghost.checkGhost', check)

local function death(ply)
	ply:SetGhost(true)

	octodeath.triggerDeath(ply)
	ply:SetLocalVar('Energy', 100)
	ply.died = true
	if ply.UpdateCharState then ply:UpdateCharState() end

	if ply:isArrested() then ply:unArrest() end
end
hook.Add('PlayerDeath', 'Ghosts', death)

local function silentDeath(ply)
	ply:SetGhost(true)

	octodeath.triggerDeath(ply)
	ply:SetLocalVar('Energy', 100)
	if ply.UpdateCharState then ply:UpdateCharState() end

	if ply:isArrested() then ply:unArrest() end
end
hook.Add('PlayerSilentDeath', 'Ghosts', silentDeath)

local function flashlight(ply, enabled)
	if ply:GetNetVar('Ghost') and not enabled then
		return false
	end
end
hook.Add('PlayerSwitchFlashlight', 'GhostsCannotUseFlashlights', flashlight)

hook.Add('PlayerSpawn', 'GhostSpawn', function(ply)

	if ply:GetNetVar('Ghost') and (not ply:GetNetVar('launcherActivated') or ply:GetNetVar('_SpawnTime') > CurTime()) then
		local function reset(ply)
			if not IsValid(ply) then return end

			ply:StripWeapons()
			ply:Give('dbg_hands')
			ply:GodEnable()

			-- i know it's done on death, but shit happens
			ply:ImportInventory(octoinv.defaultInventory)
		end

		timer.Simple(0, reset)
		timer.Simple(5, reset) -- dunno, it just happens

		-- make players look like ghosts
		ply:SetColor(Color(255,255,255, 30))
		ply:SetRenderMode(RENDERMODE_TRANSALPHA)
		ply:SetCustomCollisionCheck(true)
		ply:CollisionRulesChanged()
		ply:DrawShadow(false)
		ply:SetMaterial('models/props/cs_office/clouds')
		ply:SetBloodColor(DONT_BLEED)
		ply:SetAvoidPlayers(false)
		ply:SetHealth(100)
		ply:SetLocalVar('Energy', 100)

		timer.Simple(0.5, function()
			local corpse = ply:GetNetVar('DeathRagdoll')
			if IsValid(corpse) then
				local pos = FindSuitablePosition(corpse:GetPos(), ply, {around = 40, above = 80}, player.GetAll())
				if pos then ply:SetPos(pos) end
			end
		end)
	end

end)

--
-- OTHER
--

function FindSuitablePosition(pos, ent, dist, filtr)
	-- NOTE: ply size: (32, 32, 72)
	local function checkPos(pos)
		local trace = { start = pos, endpos = pos, filter = filtr }
		local tr = util.TraceEntity(trace, ent)

		return not tr.Hit
	end

	-- check initial position
	if checkPos(pos) then return pos end

	-- find a place around
	local testpos
	for i = 0, 300, 60 do
		testpos = pos + Angle(0, i, 0):Forward() * dist.around
		if checkPos(testpos) then return testpos end
	end

	-- check a place above
	testpos = pos + Vector(0, 0, dist.above)
	if checkPos(pos + Vector(0, 0, dist.above)) then return testpos end

	-- if we haven't found any place
	return false
end

--
-- SOME GHOST HOOKS
--

local function PlayerThink()
	for ply, _ in pairs(curGhosts) do
		if ply:GetNetVar('Ghost', false) and ply:GetNetVar('launcherActivated') and CurTime() >= ply:GetNetVar('_SpawnTime', 0) then
			ply:ExitVehicle()
			ply:SetGhost(false)
			ply:SetHealth(100)
			ply:SetLocalVar('Energy', 100)
			ply:Spawn()
			ply.died = false

			ply:GodDisable()

			-- undo ghost look
			ply:SetColor(Color(255, 255, 255, 255))
			ply:SetRenderMode(RENDERMODE_NORMAL)
			ply:SetCustomCollisionCheck(false)
			ply:CollisionRulesChanged()
			ply:DrawShadow(true)
			ply:SetMaterial('')
			ply:SetBloodColor(BLOOD_COLOR_RED)
			ply:SetAvoidPlayers(false)
		end
		if not (IsValid(ply) and ply:GetNetVar('Ghost')) then curGhosts[ply] = nil end
	end
end
hook.Add('Think', 'GhostThink', PlayerThink)

local function updateGMFuncs()
	if not GAMEMODE then return end
	function GAMEMODE:PlayerDeathThink(ply)
		if CurTime() >= ply:GetNetVar('_GhostTime', 0) then
			ply:SetGhost(true)
			ply:Spawn()
		end

		-- disable spawning
		return false
	end
end
hook.Add('darkrp.loadModules', 'dbg-ghosts', updateGMFuncs)
updateGMFuncs()

-- people can't hear ghosts
local function handleChat(listener, talker)
	if talker:IsGhost() and not listener:IsGhost() and listener:Team() ~= TEAM_ADMIN then
		return false
	end
end
hook.Add('PlayerCanHearPlayersVoice', 'GhostsHear', handleChat)

local function silentDont(ply)
	if IsValid(ply) and (not ply:Alive() or ply:GetNetVar('Ghost')) then return false end
end
hook.Add('PlayerCanPickupItem', 'GhostsCannotInteract', silentDont)
hook.Add('PlayerShouldTakeDamage', 'GhostsCannotTakeDamage', silentDont)
hook.Add('PlayerUse', 'GhostsCannotUse', silentDont)

hook.Add('shouldViewPunchOnDamage', 'GhostsCannotViewPunch', function(ply)
	if IsValid(ply) and (not ply:Alive() or ply:GetNetVar('Ghost')) then return true end
end)

local function noHandcuff(ply, victim)
	if victim:GetNetVar('Ghost') then
		return false
	end
end
hook.Add('CuffsCanHandcuff', 'noHandcuff', noHandcuff)

-- darkrp hooks
local function dont(ply)
	if IsValid(ply) and ply:GetNetVar('Ghost') then
		ply:Notify('warning', L.dead_cant_do_this)
		return false
	end
end
hook.Add('canChangeJob', 'ghosts', dont)
hook.Add('canBuyAmmo', 'ghosts', dont)
hook.Add('canBuyCustomEntity', 'ghosts', dont)
hook.Add('canBuyPistol', 'ghosts', dont)
hook.Add('canBuyShipment', 'ghosts', dont)
hook.Add('canBuyVehicle', 'ghosts', dont)
hook.Add('canDemote', 'ghosts', dont)
hook.Add('canEditLaws', 'ghosts', dont)
hook.Add('canPropertyTax', 'ghosts', dont)
hook.Add('canRequestHit', 'ghosts', dont)
hook.Add('canRequestWarrant', 'ghosts', dont)
hook.Add('canStartVote', 'ghosts', dont)
hook.Add('canTax', 'ghosts', dont)
hook.Add('canUnwant', 'ghosts', dont)
hook.Add('canVote', 'ghosts', dont)
hook.Add('canWanted', 'ghosts', dont)
hook.Add('CanPickupWeapon', 'ghosts', dont)
hook.Add('PlayerSpawnObject', 'ghosts', dont)
hook.Add('dbg-talkie.canSpeak', 'ghosts', silentDont)
hook.Add('dbg-talkie.canListen', 'ghosts', silentDont)

hook.Add('PlayerPickupDarkRPWeapon', 'ghosts', function(ply)
	if ply:GetNetVar('Ghost') then
		return true
	end
end)

hook.Add('playerGetSalary', 'ghosts', function(ply)

	if ply:GetNetVar('Ghost') then
		return true, '', 0
	end

end)

local disallowed = {
	'/rockpaperscissors',
	'/coin',
	'/dice',
	'/roll',
	'/sms',
	'//it',
	'/toit',
	'/me',
	'/yell',
	'/y',
	'/whisper',
	'/w',
	'/advert',
	'/broadcast',
	'/cr',
	'/drop',
	'/moneyput',
	'/putmoney',
	'/dropmoney',
	'/moneydrop',
	'/putmoney',
	'/moneyput',
	'/dropweapon',
	'/g',
	'/give',
	'/lockdown',
	'/unlockdown',
	'/unwarrant',
	'/warrant',
	'/write',
}

local function cantChatCommand(ply, cmd)
	if ply:IsGhost() and table.HasValue(disallowed, cmd) then
		return false, L.dead_cant_do_this
	end
end

hook.Add('octochat.canExecute', 'ghosts-cantchatcommands', cantChatCommand)
