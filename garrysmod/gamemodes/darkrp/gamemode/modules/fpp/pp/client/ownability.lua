FPP = FPP or {}

FPP.entOwners	   = FPP.entOwners or {}
FPP.entTouchability = FPP.entTouchability or {}
FPP.entTouchReasons = FPP.entTouchReasons or {}

local touchTypes = {
	Physgun = 1,
	Gravgun = 2,
	Toolgun = 4,
	PlayerUse = 8,
	EntityDamage = 16
}

local reasonSize = 4 -- bits
local reasons = L.reasons


local function receiveTouchData(len)
	repeat
		local entIndex = net.ReadUInt(32)
		local ownerIndex = net.ReadUInt(32)
		local touchability = net.ReadUInt(5)
		local reason = net.ReadUInt(20)

		FPP.entOwners[entIndex] = ownerIndex
		FPP.entTouchability[entIndex] = touchability
		FPP.entTouchReasons[entIndex] = reason
	until net.ReadBit() == 1
end
net.Receive("FPP_TouchabilityData", receiveTouchData)

function FPP.entGetOwner(ent)
	local idx = FPP.entOwners[ent:EntIndex()]
	ent.FPPOwner = idx and Entity(idx) or nil

	return ent.FPPOwner
end

function FPP.canTouchEnt(ent, touchType)
	ent.FPPCanTouch = FPP.entTouchability[ent:EntIndex()]
	if not touchType or not ent.FPPCanTouch then
		return ent.FPPCanTouch
	end

	return bit.bor(ent.FPPCanTouch, touchTypes[touchType]) == ent.FPPCanTouch
end


local touchTypeMultiplier = {
	["Physgun"] = 0,
	["Gravgun"] = 1,
	["Toolgun"] = 2,
	["PlayerUse"] = 3,
	["EntityDamage"] = 4
}

local displayName = {
	[1] = true,
	[4] = true,
	[5] = true,
}

local hideClasses = {
	gmod_sent_vehicle_fphysics_base = true,
	gmod_sent_vehicle_fphysics_wheel = true,
}

function FPP.entGetTouchReason(ent, touchType)
	-- sorry for this messy hack, but FPP is damn unfriendly on mods
	if LocalPlayer():IsAdmin() then
		local octoOwner = ent:GetNetVar('owner')
		if IsValid(octoOwner) and octoOwner:IsPlayer() then return octoOwner:Nick() end
	end
	if hideClasses[ent:GetClass()] and not LocalPlayer():IsAdmin() then
		return L.unknown
	end

	local idx = FPP.entTouchReasons[ent:EntIndex()] or 0
	ent.FPPCanTouchWhy = idx

	if not touchType then
		return ent.FPPCanTouchWhy
	end

	local maxReasonValue = 15
	-- 1111 shifted to the right touch type
	local touchTypeMask = bit.lshift(maxReasonValue, reasonSize * touchTypeMultiplier[touchType])
	-- Extract reason for touch type from reason number
	local touchTypeReason = bit.band(idx, touchTypeMask)
	-- Shift it back to the right
	local reasonNr = bit.rshift(touchTypeReason, reasonSize * touchTypeMultiplier[touchType])

	local reason = reasons[reasonNr]
	local owner = ent:CPPIGetOwner()

	if displayName[reasonNr] then -- convert owner to the actual player
		return not isnumber(owner) and IsValid(owner) and owner:Nick() or L.unknown
	elseif reasonNr == 6 then
		return (IsValid(owner) and owner:Nick() or L.unknown) .. L.ownability_friend
	end

	return reason
end
