util.AddNetworkString 'FPP_ShareSettings'
util.AddNetworkString 'FPP_CheckBuddy'
util.AddNetworkString 'FPP_Notify'
util.AddNetworkString 'FPP_BlockedModel'
util.AddNetworkString 'FPP_blockedlist'
util.AddNetworkString 'FPP_RestrictedToolList'
util.AddNetworkString 'OnChangedTeam'
util.AddNetworkString 'darkrp_playerscale'
util.AddNetworkString 'GotArrested'

function DarkRP.printConsoleMessage(ply, msg)
	if ply:EntIndex() == 0 then
		print(msg)
	else
		ply:PrintMessage(HUD_PRINTCONSOLE, msg)
	end
end

function DarkRP.isEmpty(vector, ignore)
	if not vector then return false end

	ignore = ignore or {}

	local point = util.PointContents(vector)
	local a = point ~= CONTENTS_SOLID
		and point ~= CONTENTS_MOVEABLE
		and point ~= CONTENTS_LADDER
		and point ~= CONTENTS_PLAYERCLIP
		and point ~= CONTENTS_MONSTERCLIP

	local b = true

	for k,v in pairs(ents.FindInSphere(vector, 35)) do
		if (v:IsNPC() or v:IsPlayer() or v:GetClass() == "prop_physics") and not table.HasValue(ignore, v) then
			b = false
			break
		end
	end

	return a and b
end


/*---------------------------------------------------------------------------
Find an empty position near the position given in the first parameter
pos - The position to use as a center for looking around
ignore - what entities to ignore when looking for the position (the position can be within the entity)
distance - how far to look
step - how big the steps are
area - the position relative to pos that should also be free

Performance: O(N^2) (The Lua part, that is, I don't know about the C++ counterpart)
Don't call this function too often or with big inputs.
---------------------------------------------------------------------------*/
function DarkRP.findEmptyPos(pos, ignore, distance, step, area)
	if DarkRP.isEmpty(pos, ignore) and DarkRP.isEmpty(pos + area, ignore) then
		return pos
	end

	for j = step, distance, step do
		for i = -1, 1, 2 do -- alternate in direction
			local k = j * i

			-- Look North/South
			if DarkRP.isEmpty(pos + Vector(k, 0, 0), ignore) and DarkRP.isEmpty(pos + Vector(k, 0, 0) + area, ignore) then
				return pos + Vector(k, 0, 0)
			end

			-- Look East/West
			if DarkRP.isEmpty(pos + Vector(0, k, 0), ignore) and DarkRP.isEmpty(pos + Vector(0, k, 0) + area, ignore) then
				return pos + Vector(0, k, 0)
			end

			-- Look Up/Down
			if DarkRP.isEmpty(pos + Vector(0, 0, k), ignore) and DarkRP.isEmpty(pos + Vector(0, 0, k) + area, ignore) then
				return pos + Vector(0, 0, k)
			end
		end
	end

	return pos
end

local meta = FindMetaTable("Player")
function meta:applyPlayerClassVars(applyHealth)
	local playerClass = baseclass.Get(player_manager.GetPlayerClass(self))

	-- self:SetWalkSpeed(playerClass.WalkSpeed >= 0 and playerClass.WalkSpeed or GAMEMODE.Config.walkspeed)
	-- self:SetRunSpeed(playerClass.RunSpeed >= 0 and playerClass.RunSpeed or (self:isCP() and GAMEMODE.Config.runspeedcp or GAMEMODE.Config.runspeed))

	hook.Call("UpdatePlayerSpeed", GAMEMODE, self) -- Backwards compatitibly, do not use

	self:SetCrouchedWalkSpeed(playerClass.CrouchedWalkSpeed)
	self:SetDuckSpeed(playerClass.DuckSpeed)
	self:SetUnDuckSpeed(playerClass.UnDuckSpeed)
	-- self:SetJumpPower(playerClass.JumpPower)
	self:AllowFlashlight(playerClass.CanUseFlashlight)

	self:SetMaxHealth(playerClass.MaxHealth >= 0 and playerClass.MaxHealth or (tonumber(GAMEMODE.Config.startinghealth) or 100))
	if applyHealth then
		self:SetHealth(playerClass.StartHealth >= 0 and playerClass.StartHealth or (tonumber(GAMEMODE.Config.startinghealth) or 100))
	end
	self:SetArmor(playerClass.StartArmor)

	self.dropWeaponOnDeath = playerClass.DropWeaponOnDie
	-- self:SetNoCollideWithTeammates(playerClass.TeammateNoCollide)
	-- self:SetAvoidPlayers(playerClass.AvoidPlayers)

	hook.Call("playerClassVarsApplied", nil, self)
end
