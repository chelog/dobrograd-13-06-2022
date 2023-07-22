local meta = FindMetaTable 'Player'

local function databaseInit()

	MySQLite.query([[
		CREATE TABLE IF NOT EXISTS dbg_karma (
			steamID VARCHAR(50) NOT NULL PRIMARY KEY,
			karma INT(8)
		)
	]])

end
hook.Add('DarkRPDBInitialized', 'dbg-karma', databaseInit)

netvars.Register('dbg.karma', {
	checkAccess = function(ply)
		return ply:Team() == TEAM_ADMIN or ply:Team() == TEAM_PRIEST
	end,
})

function meta:SetKarma(amount)

	if not IsValid(self) or not amount then return end
	self:SetNetVar('dbg.karma', amount)

	MySQLite.query(string.format([[UPDATE dbg_karma SET karma = %d WHERE steamID = %s]],
		self:GetNetVar('dbg.karma', 0),
		MySQLite.SQLStr(self:SteamID())
	))

end

local msgs = {
	goodBoy = {
		L.msg_good,
		L.msg_good2,
		L.msg_good3,
	},
	strange = {
		L.msg_strange,
		L.msg_strange2,
		L.msg_strange3,
		L.msg_strange4,
	},
}

function meta:AddKarma(amount, customMsg, noMultiply, force)

	if hook.Run('dbg-karma.override', self) == false then return end
	if not amount or amount == 0 then return end
	local job = self:getJobTable()
	if not force and amount < 0 and job.disabledKarma then return end

	local reason = customMsg or (amount < 0 and L.up_karma or L.down_karma)
	local curKarma = self:GetNetVar('dbg.karma', 0)
	if not noMultiply and curKarma > 0 and amount < 0 then
		amount = amount + math.floor(amount * curKarma / 25)
		if amount < -20 then
			reason = reason .. table.Random(msgs.strange)
		end
	end

	local newKarma = curKarma + amount
	self:SetKarma(newKarma)

	if amount < 0 then
		self:Notify('warning', L.karma_notify:format(reason, newKarma))
		timer.Start('karma_' .. self:SteamID())
	else
		self:Notify('hint', L.karma_notify:format(reason, newKarma))
	end

	hook.Run('dbg-karma.changed', self, newKarma, curKarma)

end

hook.Add('PlayerInitialSpawn', 'dbg.krama', function(ply)

	MySQLite.query(string.format([[SELECT * FROM dbg_karma WHERE steamID = %s]], MySQLite.SQLStr(ply:SteamID())), function(res)

		res = res and res[1]
		if res then
			ply:SetNetVar('dbg.karma', res.karma)
		else
			ply:SetNetVar('dbg.karma', 0)
			MySQLite.query(string.format(
				[[INSERT INTO dbg_karma (steamID, karma)
				VALUES (%s, 0)]],
				MySQLite.SQLStr(ply:SteamID())
			))

			if CFG.webhooks.cheats then
				octoservices:post('/discord/webhook/' .. CFG.webhooks.cheats, {
					username = GetHostName(),
					embeds = {{
						title = 'Первый вход на сервер',
						fields = {{
							name = L.player,
							value = ply:GetName() .. '\n[' .. ply:SteamID() .. '](' .. 'https://steamcommunity.com/profiles/' .. ply:SteamID64() .. ')',
						}},
					}},
				})
			end
		end

		ply.karmaLast = {}

	end)

	timer.Create('karma_' .. ply:SteamID(), 20 * 60, 0, function()
		if not ply:IsAFK() then
			ply:AddKarma(1, table.Random(msgs.goodBoy))
		end
	end)

end)

local function respawnMassfkVictim(steamID)
	octolib.setDBVar(steamID, 'ghostTime', nil):Then(function()
		local victimPly = player.GetBySteamID(steamID)
		if IsValid(victimPly) then
			if target:Alive() then target:KillSilent() end
			target:SetNetVar('_SpawnTime', CurTime())
		end
	end)
end

hook.Add('PlayerDeath', 'dbg.karma', function(ply, wep, attacker)

	if IsValid(attacker) and attacker:IsPlayer() then

		if attacker ~= ply then
			local wep = ply:GetActiveWeapon()
			local wasDangerous =
				CurTime() - (ply.lastAim or -20) < 20 or -- if victim didn't aim recently, get penalty
				(IsValid(wep) and dbgWeaponGroups[wep:GetClass()] ~= 'allowAll') -- if victim didn't have gun, get penalty
			local job = attacker:getJobTable()
			if not job.noKarmaDamagePenalty or not wasDangerous then
				attacker:AddKarma(-5, L.karma_kill)

				-- if victim did not intend to fight back, cache kill as massfk attempt
				if not wasDangerous and not attacker:IsAdmin() then
					attacker.massFKcache = attacker.massFKcache or {}
					attacker.massFKcache[#attacker.massFKcache + 1] = ply:SteamID()

					local timerName = 'antiMassFK_' .. attacker:SteamID()
					if #attacker.massFKcache >= 3 then
						attacker:BanEverywhere(0, 'MassFK')

						local massFKcache = attacker.massFKcache
						timer.Simple(1, function() -- wait a bit to execute after all death handlers
							for _, sID in ipairs(massFKcache) do
								respawnMassfkVictim(sID)
							end
						end)
						timer.Remove(timerName)
					else
						timer.Create(timerName, 120, 1, function()
							attacker.massFKcache = nil
						end)
					end
				end
			end
		elseif not attacker.HungerDeath then
			attacker:AddKarma(-5, L.karma_suicide)
		end
	end

end)

hook.Add('EntityTakeDamage', 'dbg.karma', function(ply, dmg)

	local attacker = dmg:GetAttacker()
	if IsValid(attacker) and attacker:IsPlayer()
	and IsValid(ply) and ply:IsPlayer() and not ply:IsGhost()
	and attacker ~= ply then
		if ply:Team() == TEAM_ADMIN then dmg:ScaleDamage(0) end

		local wep = attacker:GetActiveWeapon()
		if IsValid(wep) and not wep.IsLethal then return end

		if CurTime() - (attacker.karmaLast.damage or -120) > 120 then
			local job = attacker:getJobTable()
			if (not ply.karmaDamaged and CurTime() - (ply.lastAim or -20) > 20) and not job.noKarmaDamagePenalty then
				attacker:AddKarma(-1, L.karma_damage)
				attacker.karmaLast.damage = CurTime()
			end
		end

		attacker.karmaDamaged = true
		timer.Create('karmaDamage_' .. attacker:SteamID(), 30, 1, function()
			if IsValid(attacker) then attacker.karmaDamaged = nil end
		end)
	end

end)

hook.Add('dbg.scareStart', 'dbg.karma', function(ply, attacker)

	local job = attacker:getJobTable()
	if CurTime() - (attacker.karmaLast.scare or -180) > 180 and not job.noKarmaDamagePenalty then
		attacker:AddKarma(-1, L.karma_scare)
		attacker.karmaLast.scare = CurTime()
	end

end)

hook.Add('onLockpickCompleted', 'dbg.karma', function(ply, succ)

	if succ and CurTime() - (ply.karmaLast.lockpick or -180) > 180 then
		ply:AddKarma(-1, L.karma_not_your)
		ply.karmaLast.lockpick = CurTime()
	end

end)

hook.Add('dbg-hack.1stCommand', 'dbg.karma', function(ply, ent)
	if ply ~= ent:CPPIGetOwner() and CurTime() - (ply.karmaLast.keypad or -180) > 180 then
		ply:AddKarma(-1, L.karma_not_your)
		ply.karmaLast.keypad = CurTime()
	end
end)

hook.Add('PlayerDisconnected', 'dbg.karma', function(ply)

	timer.Remove('karma_' .. ply:SteamID())

	-- local karma, family = ply:GetNetVar('dbg.karma'), ply:GetDBVar('family') or {}
	-- for i, sID in ipairs(family) do
	-- 	MySQLite.query(string.format([[UPDATE dbg_karma SET karma = %d WHERE steamID = %s]],
	-- 		karma,
	-- 		MySQLite.SQLStr(sID)
	-- 	))
	-- end

end)

function octolib.banEverywhere(sid, time, reason)
	octolib.sendCmdToOthers('sg', { 'ban', sid, tostring(time), reason })
	serverguard:BanPlayer(nil, sid, '0', reason, true)
end

function meta:BanEverywhere(time, reason)
	octolib.banEverywhere(self:SteamID(), time, reason)
end

hook.Add('octoinv.pickup', 'dbg.suspectWeaponPickup', function(ply, ent)

	if IsValid(ent) and ent.isEvidence then
		ply:AddKarma(-2, 'Кажется, это была важная улика.')
	end

end)
