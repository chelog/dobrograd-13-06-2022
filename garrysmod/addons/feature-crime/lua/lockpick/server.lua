local function check(ply, ent, checkFunc)

	if not IsValid(ent) then return false end
	if ply:IsGhost() then return false end
	if not ply.inv or not ply.inv.conts._hand or ply.inv.conts._hand:HasItem('lockpick') <= 0 then
		ply:Notify('warning', L.needlockpick)
		return
	end

	local wep = ply:GetActiveWeapon()
	if IsValid(wep) and wep:GetClass() ~= 'dbg_hands' then return false end

	if ply.lockpickCache and isfunction(ply.lockpickCache.check) and not ply.lockpickCache.check(ply, ent) then
		return false
	end
	if isfunction(checkFunc) and not checkFunc(ply, ent) then return false end

	if util.TraceLine({
		start = ply:GetShootPos(),
		endpos = ply:GetShootPos() + ply:GetAimVector() * CFG.useDist,
		filter = function(e)
			return e == ent
		end,
	}).Entity ~= ent then return false end

	return true

end

local function succ(ply, ent)

	if ply.lockpickCache.succ then
		ply.lockpickCache.succ(ply, ent)
	end

	ply:LockpickStop()
	hook.Run('onLockpickCompleted', ply, true, ent)

end

local pushSounds = {'weapons/357/357_reload1.wav', 'weapons/357/357_reload3.wav', 'weapons/357/357_reload4.wav'}
local failSounds = {'weapons/crowbar/crowbar_impact1.wav', 'weapons/crowbar/crowbar_impact2.wav'}

local function fail(ply, ent)

	if CurTime() < (ply.nextLockpickFail or 0) then return end
	ply.nextLockpickFail = CurTime() + 1

	local snd = table.Random(failSounds)
	ply:EmitSound(snd, 65, 100, 0.8)

	if ply.lockpickCache and ply.lockpickCache.fail then
		ply.lockpickCache.fail(ply, ent)
	end

	ply:LockpickStop()
	ply.inv.conts._hand:TakeItem('lockpick', 1)
	ply.inv.conts._hand:AddItem('lockpick_broken', 1)
	hook.Run('onLockpickCompleted', ply, false, ent)

end

netstream.Hook('dbg-lockpick.push', function(ply)

	if not ply.lockpickCache or not ply.lockpickCache.key or not check(ply, ply.lockpickCache.ent) then
		ply:LockpickStop()
		return
	end
	local w = ply:GetActiveWeapon()
	if IsValid(w) then w:SetHoldType('revolver') end
	if math.random(3) ~= 3 then
		local snd = table.Random(pushSounds)
		ply:EmitSound(snd, 60, 100, 0.8)
		ply:SetAnimation(PLAYER_ATTACK1)
	end

end)

netstream.Hook('dbg-lockpick', function(ply, ent, resp)

	if not ply.lockpickCache then return end

	if ent then
		if ply.lockpickCache.key ~= resp then
			fail(ply, ent)
		elseif check(ply, ent) then
			succ(ply, ent)
		end
	else
		ply:LockpickStop()
	end

end)

netstream.Hook('dbg-lockpick.exploit', function(ply)
	if ply:TriggerCooldown('lockpick.exploit', 1.5) then
		ply.lockpickExploit = (ply.lockpickExploit or 0) + 1
		octochat.talkToAdmins(octochat.notifyColors.warning, ('%s (%s) подозревается в использовании макросов для взлома (%d/3)'):format(ply:Name(), ply:SteamID(), ply.lockpickExploit))
		if ply.lockpickExploit >= 3 then
			ply:BanEverywhere(0, 'Exploits 1')
		end
	end
end)

local ply = FindMetaTable 'Player'
function ply:Lockpick(ent, data)

	data = data or {}
	if not check(self, ent, data.check) then return end

	local key = ''
	for i = 1, 16 do key = key .. string.char(math.random(64)) end

	local resp = ''
	for c in string.gmatch(key, '.') do
		resp = resp .. string.char(string.byte(c) + 8)
	end


	self.lockpickCache = {
		key = resp,
		succ = data.succ,
		fail = data.fail,
		check = data.check,
		ent = ent,
	}
	local w = self:GetActiveWeapon()
	if IsValid(w) then
		self.lockpickCache.holdtype = w:GetHoldType()
		w:SetHoldType('revolver')
	end
	octolib.stopAnimations(self)

	self:SetNetVar('currentAction', L.lockpick)
	netstream.Start(self, 'dbg-lockpick', ent, key, {
		num = data.numOverride or ent.lockNum,
		time = data.timeOverride or ent.lockTime,
		space = data.spaceOverride or ent.lockSpace,
		width = data.widthOverride or ent.lockWidth,
	})

end

function ply:LockpickStop()

	if self.lockpickCache then
		local w = self:GetActiveWeapon()
		if IsValid(w) and self.lockpickCache.holdtype then
			w:SetHoldType(self.lockpickCache.holdtype or 'normal')
		end
	end

	self.lockpickCache = nil
	self:SetNetVar('currentAction', nil)
	netstream.Start(self, 'dbg-lockpick', nil)

end
