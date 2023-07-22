NOTIFY_GENERIC = 0
NOTIFY_ERROR = 1
NOTIFY_UNDO = 2
NOTIFY_HINT = 3
NOTIFY_CLEANUP = 4

local meta = FindMetaTable('Player')

function meta:applyPlayerClassVars(applyHealth)

	local playerClass = baseclass.Get(player_manager.GetPlayerClass(self))

	self:SetBaseWalkSpeed(playerClass.WalkSpeed >= 0 and playerClass.WalkSpeed or GAMEMODE.Config.walkspeed)
	self:SetBaseRunSpeed(playerClass.RunSpeed >= 0 and playerClass.RunSpeed or (self:isCP() and GAMEMODE.Config.runspeedcp or GAMEMODE.Config.runspeed))
	self:SetBaseLadderClimbSpeed(playerClass.LadderClimbSpeed or 200)

	hook.Call('UpdatePlayerSpeed', GAMEMODE, self) -- Backwards compatitibly, do not use

	self:SetCrouchedWalkSpeed(playerClass.CrouchedWalkSpeed)
	self:SetDuckSpeed(playerClass.DuckSpeed)
	self:SetUnDuckSpeed(playerClass.UnDuckSpeed)
	self:SetBaseJumpPower(playerClass.JumpPower)
	self:AllowFlashlight(playerClass.CanUseFlashlight)

	self:SetMaxHealth(playerClass.MaxHealth >= 0 and playerClass.MaxHealth or (tonumber(GAMEMODE.Config.startinghealth) or 100))
	if applyHealth then
		self:SetHealth(playerClass.StartHealth >= 0 and playerClass.StartHealth or (tonumber(GAMEMODE.Config.startinghealth) or 100))
	end
	self:SetArmor(playerClass.StartArmor)

	self.dropWeaponOnDeath = playerClass.DropWeaponOnDie
	self:SetNoCollideWithTeammates(false)
	self:SetAvoidPlayers(false)

	hook.Call('playerClassVarsApplied', nil, self)

end

-- some chat commands

--
-- CHAT STUFF
--

hook.Add('canDemote', 'FixDemote', function()
	local players_count = player.GetCount()

	if players_count <= 2 then

		return false, L.vote_not_enough_players

	end
end)

local restrictedEnts = {
	gmod_sent_vehicle_fphysics_base = true,
	gmod_sent_vehicle_fphysics_wheel = true,
}

local function run()
if not GAMEMODE then return end

function GAMEMODE:OnAchievementAchieved()
	-- nothing
end

function GAMEMODE:CalcMainActivity( ply, velocity )

	ply.CalcIdeal = ACT_MP_STAND_IDLE
	ply.CalcSeqOverride = -1

	if not self:HandlePlayerDriving(ply) and not self:HandlePlayerDucking(ply, velocity) then
		local len2d = velocity:Length2DSqr()
		if len2d > 22500 then ply.CalcIdeal = ACT_MP_RUN elseif len2d > 0.25 then ply.CalcIdeal = ACT_MP_WALK end
	end

	ply.m_bWasOnGround = ply:IsOnGround()
	ply.m_bWasNoclipping = ply:GetMoveType() == MOVETYPE_NOCLIP and not ply:InVehicle()

	return ply.CalcIdeal, ply.CalcSeqOverride

end

function GAMEMODE:CanProperty(ply, property, ent)
	if restrictedEnts[ent:GetClass()] and not (ply:query('DBG: Изменять автомобили') or property == 'skin' and ply:IsAdmin()) then
		return false
	end

	if ent:IsDoor() and property ~= 'collision' and property ~= 'bodygroups' and property ~= 'skin' then
		return false
	end

	if ent:GetClass() == 'prop_effect' and property == 'collision' then
		return false
	end

	if self.Config.allowedProperties[property] and ent:CPPICanTool(ply, 'remover') then
		return true
	end

	if property == 'persist' and ply:IsSuperAdmin() then
		return true
	end

	ply:Notify('warning', 'Property disabled for now')
	return false -- Disabled until antiminge measure is found
end

end
hook.Add('darkrp.loadModules', 'dbg-property', run)
run()

hook.Add('canDemote', 'dbg-demote', function()

	for _, v in ipairs(player.GetAll()) do
		if v:IsAdmin() and v:GetAFKTime() <= CFG.afkAdminNotActive and cats.config.actualAdminRanks[v:GetUserGroup()] then
			return false, L.ticket_admins
		end
	end

end)

hook.Add('canUnarrest', 'dbg-demote', function(ply, arrested)

	local tr = {}
	tr.start = ply:EyePos()
	tr.endpos = arrested:EyePos()
	tr.filter = { ply, arrested }
	tr = util.TraceLine(tr)

	if tr.Hit then return false, L.something_interferes end

end)

hook.Add('dbg-char.firstSpawn', 'dbg-wanted', function(ply)

	timer.Simple(3, function()
		if not IsValid(ply) then return end

		local wanted = ply:GetDBVar('wanted')
		if wanted and wanted.till then
			local time = wanted.till - os.time()
			if time > 0 then
				ply:wanted(nil, wanted.reason, time)
			else
				ply:SetDBVar('wanted', nil)
			end
		end
	end)

end)

hook.Add('hungerUpdate', 'dbg-admin', function(ply)
	if ply:Team() == TEAM_ADMIN or ply:IsGhost() then return true end
end)

hook.Add('hungerUpdate', 'dbg-jobs.k9', function(ply)
	if ply:getJobTable().notHuman then return true end
end)

hook.Add('octoinv.canLock', 'dbg-admin', function(ply, ent)
	if ply:Team() == TEAM_ADMIN then
		return true
	end
end, -3)

hook.Add('octoinv.canUnlock', 'dbg-admin', function(ply, ent)
	if ply:Team() == TEAM_ADMIN then
		return true
	end
end, -3)

local disabledWeps = octolib.array.toKeys {'gmod_camera','gmod_tool', 'weapon_physgun'}
hook.Add('octolib.canUse', 'dbg-use.disablePhysAndToolGun', function(ply)
	local wep = ply:GetActiveWeapon()
	if IsValid(wep) and disabledWeps[wep:GetClass()] then
		return false
	end
end)

hook.Add('EntityTakeDamage', 'dbg-move', function(ent, dmg)

	if ent:IsPlayer() and not hook.Run('shouldViewPunchOnDamage', ent) then
		local ang = math.random() * math.pi * 2
		local dmgAmount = dmg:GetDamage() / 1.5
		ent:ViewPunch(Angle(math.sin(ang) * dmgAmount, math.cos(ang) * dmgAmount, 0))
	end

end)

hook.Add('OnPlayerChangedTeam', 'dbg-move', function(ply)

	timer.Simple(1, function()
		if not IsValid(ply) then return end
		ply:MoveModifier('job', ply:getJobTable().movemods)
	end)

end)
