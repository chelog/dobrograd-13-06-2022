/*---------------------------------------------------------------------------
Functions
---------------------------------------------------------------------------*/
local meta = FindMetaTable("Player")
function meta:changeTeam(t, force, suppressNotification)
	local prevTeam = self:Team()
	local notify = suppressNotification and octolib.func.zero or octolib.notify.show

	if self:isArrested() and not force then
		notify(self, 'warning', L.unable:format(team.GetName(t), ""))
		return false
	end

	if self.LastJob and GAMEMODE.Config.changejobtime - (CurTime() - self.LastJob) >= 0 and not force then
		notify(self, 'warning', L.have_to_wait:format(math.ceil(GAMEMODE.Config.changejobtime - (CurTime() - self.LastJob)), "/job"))
		return false
	end

	if self.IsBeingDemoted then
		self:changeTeam(GAMEMODE.DefaultTeam, true)
		octolib.finishVote(self.IsBeingDemoted, true)
		self.IsBeingDemoted = nil
		notify(self, 'warning', L.tried_to_avoid_demotion)

		return false
	end


	if prevTeam == t then
		notify(self, 'warning', L.unable:format(team.GetName(t), ""))
		return false
	end

	local TEAM = RPExtraTeams[t]
	if not TEAM then return false end

	if TEAM.customCheck and not TEAM.customCheck(self) and (not force or force and not GAMEMODE.Config.adminBypassJobRestrictions) then
		local message = isfunction(TEAM.CustomCheckFailMsg) and TEAM.CustomCheckFailMsg(self, TEAM) or
			TEAM.CustomCheckFailMsg or
			L.unable:format(team.GetName(t), "")
		notify(self, 'warning', message)
		return false
	end

	if not force then
		if type(TEAM.NeedToChangeFrom) == "number" and prevTeam ~= TEAM.NeedToChangeFrom then
			notify(self, 'warning', L.need_to_be_before:format(team.GetName(TEAM.NeedToChangeFrom), TEAM.name))
			return false
		elseif type(TEAM.NeedToChangeFrom) == "table" and not table.HasValue(TEAM.NeedToChangeFrom, prevTeam) then
			local teamnames = ""
			for a, b in pairs(TEAM.NeedToChangeFrom) do
				teamnames = teamnames .. " or " .. team.GetName(b)
			end
			notify(self, 'warning', string.format(string.sub(teamnames, 5), team.GetName(TEAM.NeedToChangeFrom), TEAM.name))
			return false
		end
		local max = TEAM.max
		if max ~= 0 and -- No limit
		(max >= 1 and team.NumPlayers(t) >= max or -- absolute maximum
		max < 1 and (team.NumPlayers(t) + 1) / #player.GetAll() > max) then -- fractional limit (in percentages)
			notify(self, 'warning',  L.team_limit_reached:format(TEAM.name))
			return false
		end
	end

	if TEAM.PlayerChangeTeam then
		local val = TEAM.PlayerChangeTeam(self, prevTeam, t)
		if val ~= nil then
			return val
		end
	end

	local hookValue, reason = hook.Call("playerCanChangeTeam", nil, self, t, force)
	if hookValue == false then
		if reason then
			notify(self, 'warning', reason)
		end
		return false
	end

	local isMayor = RPExtraTeams[prevTeam] and RPExtraTeams[prevTeam].mayor
	self:updateJob(TEAM.name)
	self:SetSalary(TEAM.salary)

	if self:GetNetVar("HasGunlicense") and GAMEMODE.Config.revokeLicenseOnJobChange then
		self:SetNetVar("HasGunlicense", nil)
	end
	if TEAM.hasLicense then
		self:SetNetVar("HasGunlicense", L.weapons)
	end

	self.LastJob = CurTime()

	if isMayor and GAMEMODE.Config.shouldResetLaws then
		DarkRP.resetLaws()
	end

	self:SetTeam(t)
	hook.Call("OnPlayerChangedTeam", GAMEMODE, self, prevTeam, t)
	if self:InVehicle() then self:ExitVehicle() end
	if GAMEMODE.Config.norespawn and self:Alive() then
		self:StripWeapons()
		local vPoint = self:GetShootPos() + Vector(0,0,50)
		local effectdata = EffectData()
		effectdata:SetEntity(self)
		effectdata:SetStart(vPoint) -- Not sure if we need a start and origin (endpoint) for this effect, but whatever
		effectdata:SetOrigin(vPoint)
		effectdata:SetScale(1)
		util.Effect("entity_remove", effectdata)
		player_manager.SetPlayerClass(self, TEAM.playerClass or "player_darkrp")
		self:applyPlayerClassVars(false)
		gamemode.Call("PlayerLoadout", self)
	end

	net.Start("OnChangedTeam")
		net.WriteUInt(prevTeam, 16)
		net.WriteUInt(t, 16)
	net.Send(self)
	return true
end

function meta:jobHasWeapon(class)
	if istable(self.orgWeps) and table.HasValue(self.orgWeps, class) then
		return true
	end
	local weps = self:getJobTable().weapons
	if not weps then return false end

	for _, wep in ipairs(self:getJobTable().weapons) do
		if istable(wep) and wep[1] == class or wep == class then
			return true
		end
	end
	return false
end

function meta:updateJob(job)
	self:SetNetVar('job', job)
	self.LastJob = CurTime()

	timer.Create(self:UniqueID() .. "jobtimer", GAMEMODE.Config.paydelay, 0, function()
		if not IsValid(self) then return end
		self:payDay()
	end)
end

function GM:canChangeJob(ply, args)
	if ply:isArrested() then return false end
	if ply.LastJob and 10 - (CurTime() - ply.LastJob) >= 0 then return false, L.have_to_wait:format(math.ceil(10 - (CurTime() - ply.LastJob)), "/job") end
	if not ply:Alive() then return false end

	local len = string.len(args)

	if len < 4 then return false, L.unable:format("/job", L.too_short) end
	if len > 70 then return false, L.unable:format("/job", L.too_long) end

	return true
end

hook.Add( "PlayerDeath", "RevokeLicenceOnDeath", function( ply, inflictor, attacker )
	if !ply:getJobTable().hasLicense then
		ply:SetNetVar("HasGunlicense", nil)
	end
end)
