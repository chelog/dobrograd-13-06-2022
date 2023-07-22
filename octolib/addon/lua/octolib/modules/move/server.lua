if CFG.disabledModules.move then return end

local defaultWalk, defaultRun, defaultLadder = 80, 185, 200
local defaultJump = 200
local meta = FindMetaTable 'Player'

function meta:UpdateSpeed()

	local walk, run, ladder = self.moveWalkSpeed or defaultWalk, self.moveRunSpeed or defaultRun, self.moveLadderSpeed or defaultLadder
	local jump = self.moveJumpPower or defaultJump
	local norun, nojump, nostand = false, false

	self.moveMods = self.moveMods or {}
	for modID, mod in pairs(self.moveMods) do
		if mod.walkadd then walk = walk + mod.walkadd end
		if mod.walkmul then walk = walk * mod.walkmul end
		if mod.runadd then run = run + mod.runadd end
		if mod.runmul then run = run * mod.runmul end
		if mod.ladderadd then ladder = ladder + mod.ladderadd end
		if mod.laddermul then ladder = ladder * mod.laddermul end
		if mod.jumpadd then jump = jump + mod.jumpadd end
		if mod.jumpmul then jump = jump * mod.jumpmul end
		if mod.norun then norun = true end
		if mod.nojump then nojump = true end
		if mod.nostand then nostand = true end
	end

	self:SetWalkSpeed(walk)
	self:SetRunSpeed(norun and walk or run)
	self:SetLadderClimbSpeed(ladder)
	self:SetJumpPower(nojump and 0 or jump)
	self:SetCanWalk(false)
	self:SetLocalVar('nostand', nostand or nil)
	self:SetLocalVar('norun', norun or nil)

end

function meta:MoveModifier(name, val)

	if not IsValid(self) then return end

	self.moveMods = self.moveMods or {}
	self.moveMods[name] = val
	self:UpdateSpeed()

end

function meta:GetMoveModifier(name)

	return self.moveMods and self.moveMods[name] or nil

end

function meta:SetBaseWalkSpeed(val)

	self.moveWalkSpeed = val
	self:UpdateSpeed()

end

function meta:SetBaseRunSpeed(val)

	self.moveRunSpeed = val
	self:UpdateSpeed()

end

function meta:SetBaseJumpPower(val)

	self.moveJumpPower = val
	self:UpdateSpeed()

end

function meta:SetBaseLadderClimbSpeed(val)

	self.moveLadderSpeed = val
	self:UpdateSpeed()

end

hook.Add('PlayerSpawn', 'octolib.move', function(ply)

	timer.Simple(0.5, function()
		if not IsValid(ply) then return end
		ply:UpdateSpeed()
	end)

end)

-- quickie to fix fast crouching bug
hook.Add('CanPlayerEnterVehicle', 'octolib.move', function(ply, veh, role)

	if ply:Crouching() then return false end

end)
