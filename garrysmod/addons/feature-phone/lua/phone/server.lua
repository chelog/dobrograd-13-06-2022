netstream.Hook('dbg-phone.cr', function(ply, ent, s)
	if (ply.nextEMSRequest or 0) > CurTime() then return end
	local name = ply:Nick()
	if IsValid(ent) then
		if ent:GetClass() ~= 'ent_dbg_phone' or ply:AtStationaryPhone() ~= ent then return end
		name = ent:GetNick()
	elseif not ply:HasMobilePhone() then return end
	DarkRP.callEMS(ply, name, tostring(s))
end)

local ply = FindMetaTable 'Player'

function ply:HasMobilePhone()
	return self.inv and self:FindItem({class = 'phone', on = true}) ~= nil
end

function ply:AtStationaryPhone()
	local ent = octolib.use.getTrace(self).Entity
	if IsValid(ent) and ent:GetClass() == 'ent_dbg_phone' and not ent.off then
		return ent
	end
end

function ply:HasPhone()
	return not self:IsGhost() and (self:HasMobilePhone() or self:AtStationaryPhone())
end

function ply:SendSMS(...)
	if not self:HasMobilePhone() then return end

	octochat.talkTo(self, ...)

	local phone = self:FindItem({class = 'phone', on = true})
	if phone:GetData('notification') then
		self:EmitSound('phone/phone_notification.wav', 38)
	end

	if phone:GetData('vibration') then
		self:EmitSound('phone/phone_vibration.wav', 25)
	end
end

hook.Add('octochat.canExecute', 'dbg-phone', function(ply, cmd)

	if octochat.commands[cmd].phone and not ply:HasPhone() then
		return false, L.need_phone
	end

end)

hook.Add('octoinv.shop.order-override', 'dbg-phone', function(ply)

	if not ply:HasPhone() then
		return false, L.need_phone
	end

end)

local function updateTypeStatus(ply, state, sounds)

	if not ply:Alive() or ply:IsGhost() or not ply:HasMobilePhone() then return end
	if ply:GetNetVar('sgMuted') then return end

	if state then
		local weapon = ply:GetActiveWeapon()

		if IsValid(weapon) and weapon:GetHoldType() ~= 'normal' and not ply:Crouching() and not ply:InVehicle() then
			if weapon:GetHoldType() ~= 'revolver' then return end
			ply.last_wep = {wep = weapon:GetClass(), hold = weapon:GetHoldType()}
			weapon:SetHoldType('normal')
		end

		ply:SetNetVar('UsingPhone', true)
	else
		ply:SetNetVar('UsingPhone', false)
		if ply:Alive() then
			local weapon = ply:GetActiveWeapon()
			local last_wep = ply.last_wep
			if last_wep then
				local wep, hold = ply.last_wep.wep, ply.last_wep.hold

				if IsValid(weapon) and wep and hold and weapon:GetClass() == wep then
					weapon:SetHoldType(hold or 'normal')
				end
			end
		end
		ply.last_wep = {}
	end
end

netstream.Hook('dbg-phone.updateTypeStatus', function(ply, state)
	updateTypeStatus(ply, state)
end)

octolib.func.loop(function(done)
	octolib.func.throttle(player.GetAll(), 10, 0.2, function(ply)

		if not IsValid(ply) then return end
		if not ply:HasMobilePhone() or not ply:GetNetVar('UsingPhone') then return end

		local weapon = ply:GetActiveWeapon()
		if not IsValid(weapon) then return end

		if (weapon:GetHoldType() ~= 'normal' or weapon:GetHoldType() ~= 'passive') and not ply:Crouching() and not ply:InVehicle() then
			ply.last_wep = {wep = weapon:GetClass(), hold = weapon:GetHoldType()}
			weapon:SetHoldType('normal')
		end

	end):Then(done)
end)

netstream.Hook('dbg-phone.typingSMS', function(ply)
	if not IsValid(ply) then return end

	local phone = ply.inv and ply:FindItem({class = 'phone', on = true, notification = true})
	if phone then
		ply:EmitSound('type.mp3', 50)
	end
end)