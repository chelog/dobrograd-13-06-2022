AddCSLuaFile 'cl_init.lua'
AddCSLuaFile 'shared.lua'

include 'shared.lua'

function ENT:Initialize()

	self:SetModel('models/props/cs_office/offcorkboarda.mdl')
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then phys:Wake() end

end

local applyCooldown = 10 * 60 -- 10 minutes

local activeVotes = {}
local demotedPlys = {}

util.AddNetworkString 'dbg-police.menu'
util.AddNetworkString 'dbg-police.apply'
util.AddNetworkString 'dbg-police.quit'
util.AddNetworkString 'dbg-police.fire'
function ENT:Use( ply )

	if not IsValid(ply) then return end

	if os.time() < ply:GetDBVar('lastDeath', 0) + applyCooldown then
		ply:Notify('warning', 'После смерти персонажа работу в полиции можно получить только через 10 минут')
		return
	end
	if ply.currentOrg then
		ply:Notify('warning', 'Сначала нужно сдать форму организации')
		return
	end

	local job = ply:getJobTable()
	if job.canJoinPolice and not job.canJoinPolice(ply) then
		ply:Notify('warning', select(2, job.canJoinPolice(ply)))
		return
	end

	net.Start('dbg-police.menu')
	net.Send(ply)

end

hook.Add('PlayerDeath', 'dbg-police.death', function(ply)

	ply:SetDBVar('lastDeath', os.time())
	timer.Create('resetLastDeath_' .. ply:SteamID(), applyCooldown, 1, function()
		if not IsValid(ply) then return end
		ply:SetDBVar('lastDeath', nil)
	end)

end)

local function makeJob(ply, job)

	if not ply or not istable(job) then return end

	if ply.dbgPolice_citizenData then
		ply:RestoreCitizen()
	end

	ply:SetNetVar('dbg-police.job', job.command)
	ply:Notify(L.now_you:format(job.name))

end

local function loseJob(ply)

	ply:SetNetVar('dbg-police.job', nil)
	local sID = ply:SteamID()
	demotedPlys[sID] = true
	timer.Simple(1800, function() demotedPlys[sID] = nil end)

end

local inCopLimit = octolib.array.toKeys {'medcop', 'cop', 'cop2', 'chief', 'dpd'}
local avoidLimit = octolib.array.toKeys {'chief', 'mayor'}
local function inPoliceLimits()
	local limit = math.Round(player.GetCount() * 0.178)
	if limit <= 0 then limit = 1 end

	for _,v in ipairs(player.GetAll()) do
		if inCopLimit[v:GetNetVar('dbg-police.job', '')] then
			limit = limit - 1
		end
	end

	return limit > 0
end

local function startVote(ply, job, text)

	local steamID = ply:SteamID()

	for voteSID in pairs(activeVotes) do
		local votePly = player.GetBySteamID(voteSID)
		if IsValid(votePly) then
			return ply:Notify('warning', L.already_vote_hint)
		else activeVotes[voteSID] = nil end
	end

	if CurTime() < (ply.dbgPolice_nextVote or 0) then
		ply:Notify('warning', L.need_wait_demote)
		return
	end

	if job.command == 'chief' or job.command == 'mayor' then
		for i, v in ipairs(player.GetAll()) do
			if v:GetNetVar('dbg-police.job') == job.command then
				ply:Notify('warning', L.already_work .. v:Name())
				return
			end
		end
	end

	if player.GetCount() <= 1 then
		ply:Notify(L.win_vote_one)
		makeJob(ply, job)
		return
	end

	local voters = {}
	for _, v in ipairs(player.GetAll()) do
		if v ~= ply and v:GetKarma() > -50 and not v:getJobTable().hobo then
			voters[#voters + 1] = v
		end
	end

	activeVotes[steamID] = octolib.questions.start({
		text = L.want_job_hint:format(ply:Name(), job.name),
		recipients = voters,
		spectators = ply,
		time = 30,
		onFinish = function(result)
			activeVotes[steamID] = nil
			if not IsValid(ply) then return end

			if result > 0 then
				octolib.notify.sendAll(L.won_in_vote:format(ply:Name()))
				makeJob(ply, job)
			else
				octolib.notify.sendAll(L.lose_in_vote:format(ply:Name()))
				ply.dbgPolice_nextVote = CurTime() + 1800
			end
		end,
	})
	ply:Notify(L.vote_started_hint)

	ply.dbgPolice_nextVote = CurTime() + 180

	return true
end

local function sendApplication(ply, job, boss)

	local steamID = ply:SteamID()

	if activeVotes[steamID] then
		ply:Notify('warning', L.already_sent_vote)
		return
	end

	activeVotes[steamID] = octolib.questions.start({
		text = L.want_job_hint:format(ply:Name(), job.name),
		recipients = boss,
		left = 'Принять',
		right = 'Отклонить',
		time = 180,
		sound = 'Town.d1_town_02_elevbell1',
		onFinish = function(result)
			activeVotes[steamID] = nil
			if not IsValid(ply) then return end
			if result > 0 then
				ply:Notify(L.your_request_approved)
				makeJob(ply, job)
				if IsValid(boss) then boss:Notify(L.request_approved) end
			elseif result < 0 then
				ply:Notify(L.your_request_rejected)
				if IsValid(boss) then boss:Notify(L.request_rejected) end
				ply.dbgPolice_nextApply = CurTime() + 1800
			else
				ply:Notify('Твою заявку пропустили :(')
			end
		end,
	})

	ply:Notify(L.application_sent_hint)
	ply.dbgPolice_nextApply = CurTime() + 180

end

net.Receive('dbg-police.apply', function(len, ply)

	local job, jobID = net.ReadString()
	if CurTime() < (ply.dbgPolice_nextApply or 0) then
		ply:Notify('warning', L.wait_boy)
		return
	end
	ply.dbgPolice_nextApply = CurTime() + 1

	if ply:isWanted() then
		ply:Notify('warning', L.you_wanted)
		return
	end

	if ply:GetKarma() <= -50 then
		ply:Notify('warning', L.bad_reputation)
		return
	end

	local time = ply:CheckPoliceDenied()
	if time == true then
		return ply:Notify('warning', 'Ты не можешь играть за полицейские профессии')
	elseif time then
		return ply:Notify('warning', 'Ты сможешь играть за полицейские профессии ' .. octolib.time.formatIn(time))
	end

	if ply:IsHandcuffed() then
		ply:Notify('warning', L.error_cuffs)
		return
	end

	local curJob = ply:getJobTable()
	if curJob.hobo then
		ply:Notify('warning', L.hobo_cant_work)
		return
	end

	if curJob.canJoinPolice and not curJob.canJoinPolice(ply) then
		ply:Notify(select(2, curJob.canJoinPolice(ply)))
		return
	end

	if demotedPlys[ply:SteamID()] then
		ply:Notify('warning', L.wait_after_demote)
		return
	end

	if not inPoliceLimits() then
		if not avoidLimit[job] then
			ply:Notify('warning', 'В городе сейчас много полиции, попробуй позже!')
			return
		end
	end

	job, jobID = DarkRP.getJobByCommand(job)
	if not job or not job.police or job.noPBoard then
		ply:Notify('warning', L.job_doesnt_exist2)
		return
	end

	if isfunction(job.customCheck) then
		local allow, reason = job.customCheck(ply)
		if not allow then
			reason = reason or job.customCheckFailMsg or L.job_denied
			ply:Notify('warning', reason)
			return
		end
	end

	if jobID == TEAM_CHIEF or jobID == TEAM_MAYOR then
		local text = net.ReadString()
		if startVote(ply, job, text and string.Trim(text) or nil) then
			if (text and text ~= '') and activeVotes[steamID] then
				octochat.talkTo(nil, octochat.textColors.rp, '[Предвыборная речь] ', ply:Name(), ': ', Color(250,250,200), text)
			end
		end
	else
		if team.NumPlayers(TEAM_CHIEF) > 0 then
			sendApplication(ply, job, team.GetPlayers(TEAM_CHIEF)[1])
		elseif team.NumPlayers(TEAM_MAYOR) > 0 then
			sendApplication(ply, job, team.GetPlayers(TEAM_MAYOR)[1])
		else
			for i, v in ipairs(player.GetAll()) do
				if v:GetNetVar('dbg-police.job') == 'mayor' or v:GetNetVar('dbg-police.job') == 'chief' then
					sendApplication(ply, job, v)
					return
				end
			end

			ply:Notify(L.automatic_accepted)
			makeJob(ply, job)
		end
	end

end)

net.Receive('dbg-police.quit', function(len, ply)

	if ply:GetNetVar('dbg-police.job', '') == '' then
		ply:Notify('warning', L.you_not_work_in_police)
		return
	end

	if IsValid(ply.tazeragdoll) then
		ply:Notify('warning', L.error_tazer)
		return
	end

	loseJob(ply)

	ply:Notify(L.you_retired)

	if ply.dbgPolice_citizenData then
		ply:RestoreCitizen()
	end

end)

net.Receive('dbg-police.fire', function(len, ply)

	local target = net.ReadEntity()

	if CurTime() < (ply.dbgPolice_nextFire or 0) then
		ply:Notify('warning', L.wait_boy)
		return
	end
	ply.dbgPolice_nextFire = CurTime() + 1

	if not IsValid(target) or not target:IsPlayer() then
		return ply:addExploitAttempt()
	end

	if ply:GetNetVar('dbg-police.job') ~= 'mayor' and ply:GetNetVar('dbg-police.job') ~= 'chief' then
		ply:Notify('warning', L.you_cant_demote)
		return
	end

	if target:GetNetVar('dbg-police.job') == 'mayor' then
		ply:Notify('warning', L.you_cant_demote_up)
		return
	end

	if target:GetNetVar('dbg-police.job', '') == '' then
		ply:Notify('warning', L.he_not_work_in_police)
		return
	end

	if IsValid(target.tazeragdoll) then
		target:Notify('warning', L.him_dont_stay)
		return
	end

	loseJob(target)
	target:Notify(L.police_demoted_you:format(ply:Name()))
	ply:Notify(L.police_demoted_by_you:format(target:Name()))

	if target.dbgPolice_citizenData then
		target:RestoreCitizen()
	end

end)

hook.Add('PlayerDisconnected', 'dbg-police', function(ply)

	local steamID = ply:SteamID()
	if activeVotes[steamID] then
		octolib.questions.finish(activeVotes[steamID], true)
		activeVotes[steamID] = nil
	end

end)

local function loseJobOnSpawn(ply)

	if ply:GetNetVar('dbg-police.job', '') ~= '' then
		ply:Notify(L.death_lose_job)
		loseJob(ply)
	end
	ply.dbgPolice_citizenData = nil

end
hook.Add('dbg-char.spawn', 'dbg-police', loseJobOnSpawn)

local function keysAccess(ply, ent)

	local data = dbgEstates.getData(ent:GetEstateID())
	if not data or not data.owners then return end
	for _,v in ipairs(data.owners) do
		if v == 'g:police' then
			local job = DarkRP.getJobByCommand(ply:GetNetVar('dbg-police.job', ''))
			return job and job.police or nil
		end
	end

end
hook.Add('canKeysLock', 'dbg-police', keysAccess)
hook.Add('canKeysUnlock', 'dbg-police', keysAccess)

local function loseJobOnDemote(demoter, ply, reason)

	loseJob(ply)
	if ply.dbgPolice_citizenData then
		ply:RestoreCitizen()
	end

end
hook.Add('onPlayerDemoted', 'dbg-police', loseJobOnDemote)

hook.Add('dbg-winter.isWarm', 'dbg-police', function(ply)
	if ply:isCP() then
		return true
	end
end)
