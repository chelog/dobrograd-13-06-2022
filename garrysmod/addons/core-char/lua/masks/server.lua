local plyMeta = FindMetaTable 'Player'

function plyMeta:Unmask()

	local mask, expire = self:GetMaskId(), self:GetMaskExpire()
	if not mask then return end
	if not self:CanUnmask() then return end

	if not self:Alive() or self:IsGhost() then
		self:Notify('warning', 'Ты мертв!')
		return
	end

	local cont = self.inv and self.inv.conts._hand
	if not cont then
		self:Notify('warning', L.hands_free)
		return
	end

	local maskData = {
		name = CFG.masks[mask].name,
		icon = CFG.masks[mask].icon,
		desc = CFG.masks[mask].desc,
		mask = mask,
		expire = expire,
	}

	local item = cont:AddItem('h_mask', maskData)
	if not item or item == 0 then
		self:Notify('warning', 'В руках недостаточно места')
		return
	end

	self:SetNetVar('hMask', nil)
	self:SetDBVar('hMask', nil)

	hook.Run('dbg-masks.unmask', self, maskData.name)

end
concommand.Add('dbg_unmask', plyMeta.Unmask)

hook.Add('PlayerFinishedLoading', 'dbg-masks', function(ply)

	timer.Simple(10, function()
		if not IsValid(ply) then return end
		local mask = ply:GetDBVar('hMask')

		if istable(mask) and mask[2] then
			if mask[2] <= os.time() then
				ply:SetDBVar('hMask')
				ply:Notify('У твоего аксессуара закончился срок годности')
				return
			else
				ply.maskExpireUid = 'octoinv.maskExpire' .. octolib.string.uuid()
				timer.Create(ply.maskExpireUid, mask[2] - os.time(), 1, function()
					if not IsValid(ply) then return end
					ply:SetNetVar('hMask')
					ply:SetDBVar('hMask')
					ply:Notify('У твоего аксессуара закончился срок годности')
				end)
			end
		end

		if mask then
			ply:SetNetVar('hMask', mask)
			hook.Run('dbg-masks.mask', ply, mask[1], true)
		end
	end)

end)

hook.Add('PlayerDeath', 'dbg-masks', function(ply)

	local mask, expire = ply:GetMaskId(), ply:GetMaskExpire()
	if not mask or not CFG.masks[mask] or CFG.masks[mask].noDrop then return end

	local shouldDrop = ply:CanUnmask()

	ply:SetNetVar('hMask', nil)
	ply:SetDBVar('hMask', nil)
	if ply.maskExpireUid then
		timer.Remove(ply.maskExpireUid)
		ply.maskExpireUid = nil
	end

	if not shouldDrop then return end

	local ent = ents.Create 'octoinv_item'
	ent:SetPos(ply:GetShootPos())
	ent:SetAngles(AngleRand())
	ent:SetData('h_mask', {
		name = CFG.masks[mask].name,
		icon = CFG.masks[mask].icon,
		desc = CFG.masks[mask].desc,
		mask = mask,
		expire = expire,
	})
	ent.droppedBy = ply

	ent:Spawn()
	ent:Activate()

	local phys = ent:GetPhysicsObject()
	if IsValid(phys) then
		phys:Wake()
		phys:SetVelocity(ply:GetAimVector() * 150)
	end

end)

hook.Add('PlayerDisconnected', 'dbg-masks', function(ply)

	ply:SetNetVar('hMask', nil)
	if ply.maskExpireUid then
		timer.Remove(ply.maskExpireUid)
	end

end)
