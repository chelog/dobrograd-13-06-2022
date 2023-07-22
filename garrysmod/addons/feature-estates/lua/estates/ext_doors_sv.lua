local meta = FindMetaTable('Entity')

function meta:AddGroupOwner(gID)
	if not self:IsDoor() or self:IsBlocked() then return end
	if not isstring(gID) or not dbgDoorGroups.groups[gID] then return end
	if dbgEstates.addOwner(self:GetEstateID(), 'g:' .. gID) then
		hook.Run('dbg-estates.owned', 'g:' .. gID, self:GetEstateID())
		return true
	end
	return false
end

function meta:AddJobOwner(jID)
	if not self:IsDoor() or self:IsBlocked() then return end
	if not isstring(jID) or not DarkRP.getJobByCommand(jID) then return end
	if dbgEstates.addOwner(self:GetEstateID(), 'j:' .. jID) then
		hook.Run('dbg-estates.owned', 'j:' .. jID, self:GetEstateID())
		return true
	end
	return false
end

function meta:SetPlayerOwner(ply)
	if not self:IsDoor() or self:IsBlocked() then return end
	if not IsEntity(ply) or not ply:IsPlayer() or not self:IsDoor() then return end
	if dbgEstates.addOwner(self:GetEstateID(), ply:SteamID()) then
		hook.Run('dbg-estates.owned', ply:SteamID(), self:GetEstateID())
		return true
	end
	return false
end

function meta:RemoveOwner(owner)
	if not self:IsDoor() or self:IsBlocked() then return end
	if IsEntity(owner) then
		if not owner:IsPlayer() then return end
		owner = owner:SteamID()
	elseif not isstring(owner) then return end
	local estId = self:GetEstateID()
	if dbgEstates.removeOwner(estId, owner) then
		hook.Run('dbg-estates.unowned', owner, estId)
		if octolib.string.isSteamID(owner) then
			local doors = self:GetEstate().doors
			if not doors then return end
			for _,v in ipairs(doors) do
				v:Fire('Close')
				v:DoLock()
				hook.Run('dbg-doors.unowned', v, owner, estId)
			end
		end
		return true
	end
end

function meta:SetBlocked(blocked)

	if not self:IsDoor() or self:IsBlocked() == blocked then return end

	if blocked then
		dbgEstates.unlinkDoor(self)
	else
		dbgEstates.createEstate(self)
	end
end

function meta:SetTitle(title, save)
	if title ~= nil and not isstring(title) then return end
	if self:GetPlayerOwner() == nil or save then
		self.title = title
		if self:IsBlocked() then
			dbgEstates.unlinkDoor(self)
		end
		dbgEstates.planDBUpdate()
	end
	self:SetNetVar('tempTitle', title or self.title)
end

function meta:IsDoorLocked()
	if not self:IsDoor() then return end
	return self:GetInternalVariable('m_bLocked') or false
end

function meta:CanBeLockedBy(ply)
	if not self:IsDoor() or self:IsBlocked() then return end
	local h = hook.Run('canKeysLock', ply, self)
	if h ~= nil then return h end
	return self:ShouldObey(ply)
end

function meta:CanBeUnlockedBy(ply)
	if not self:IsDoor() or self:IsBlocked() then return end
	local h = hook.Run('canKeysUnlock', ply, self)
	if h ~= nil then return h end
	return self:ShouldObey(ply)
end

function meta:DoLock()
	self:Fire('lock', '', 0)
	hook.Run('onKeysLocked', self)
end

function meta:DoUnlock()
	self:Fire('unlock', '', 0)
	hook.Run('onKeysUnlocked', self)
end

-- This method is used for "double doors", which need to be opened and closed at the same time.
function meta:GetPairedDoor()

	-- we've already found our pair
	if self.secondDoor ~= nil then return self.secondDoor end

	-- let's check if we have master
	local tbl = self:GetSaveTable()
	local pair = tbl.m_hOwnerEntity
	if IsValid(pair) then
		self.secondDoor, pair.secondDoor = pair, self
		return self.secondDoor
	end
	pair = tbl.m_hMaster
	if IsValid(pair) then
		self.secondDoor, pair.secondDoor = pair, self
		return self.secondDoor
	end

	-- we're master, let's find our slave
	for _, v in ipairs(ents.GetAll()) do
		if not v:IsDoor() then continue end
		local tbl = v:GetSaveTable()
		if tbl.m_hOwnerEntity == self or tbl.m_hMaster == self then
			self.secondDoor, v.secondDoor = v, self
			return self.secondDoor
		end
	end

	-- we're single
	self.secondDoor = NULL
	return self.secondDoor

end
