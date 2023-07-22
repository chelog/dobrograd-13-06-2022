octolib.animations = octolib.animations or {}
function octolib.registerAnimationCategory(id, data)
	octolib.animations[id] = data
end

local function load(path)
	local fs, _ = file.Find(path .. '*.lua', 'LUA')
	for _, f in pairs(fs) do
		octolib.shared(path .. f:sub(1, -5))
	end
end

load('config/octolib-anim/')

local angle_zero = Angle()

local running = {}
hook.Add('Think', 'octolib-anim.manipulate', function()

	local ct = CurTime()
	local deleted = 0
	for i = 1, #running do
		local data = running[i - deleted]
		local ply = data.ply
		if IsValid(ply) then
			local frac = math.EaseInOut(math.Clamp(math.TimeFraction(data.start, data.finish, ct), 0, 1), 0.7, 0.7)
			for boneID, ang in pairs(data.tgt) do
				local curAng = LerpAngle(frac, data.old[boneID], ang)
				ply:ManipulateBoneAngles(boneID, curAng)
			end
			if ct > data.finish then
				table.remove(running, i)
				deleted = deleted + 1
			end
		else
			table.remove(running, i)
			deleted = deleted + 1
		end
	end

end)

octolib.overrideSequence = octolib.overrideSequence or {}
octolib.overrideSequenceTime = octolib.overrideSequenceTime or {}
octolib.resetSequenceOnMove = octolib.resetSequenceOnMove or {}
hook.Add('CalcMainActivity', 'octolib-anim', function(ply, vel)

	local seq = octolib.overrideSequence[ply]
	if not seq then return end

	local standing = ply:IsOnGround() and not ply:Crouching()
	if octolib.resetSequenceOnMove[ply] and (not standing or vel.x ~= 0 or vel.y ~= 0 or vel.z ~= 0) then
		octolib.stopAnimations(ply, true)
		return
	end

	if not standing then return end

	local time = octolib.overrideSequenceTime[ply]
	if time then
		ply:SetAnimTime(CurTime() - time)
		octolib.overrideSequenceTime[ply] = nil
	end

	return ACT_HL2MP_WALK, seq

end)

timer.Create('octolib-anim.cleanup', 60, 0, function()

	for ply, _ in pairs(octolib.overrideSequence) do
		if not IsValid(ply) then
			octolib.overrideSequence[ply] = nil
		end
	end

end)

function octolib.manipulateBones(ply, tbl, time)

	if not IsValid(ply) then return end

	local old = {}
	local tgt = {}

	if not tbl then
		for i = 0, ply:GetBoneCount() - 1 do
			old[i] = ply:GetManipulateBoneAngles(i) or angle_zero
			tgt[i] = angle_zero
		end
	end

	for bone, ang in pairs(tbl or {}) do
		local boneID = ply:LookupBone(bone)
		if boneID then
			old[boneID] = ply:GetManipulateBoneAngles(boneID) or angle_zero
			tgt[boneID] = ang
		end
	end

	for boneID, ang in pairs(tgt) do
		if old[boneID] == ang then
			old[boneID] = nil
			tgt[boneID] = nil
		end
	end

	running[#running + 1] = {
		ply = ply,
		old = old,
		tgt = tgt,
		start = CurTime(),
		finish = CurTime() + (time or 0),
	}

end

function octolib.stopAnimations(ply, noSync)

	octolib.overrideSequence[ply] = nil
	octolib.overrideSequenceTime[ply] = nil
	octolib.resetSequenceOnMove[ply] = nil
	octolib.manipulateBones(ply, nil, 0.4)
	ply.octolib_customAnim = nil

	if SERVER then
		ply:MoveModifier('anim', nil)
		if not noSync then
			netstream.StartPVS(ply:GetPos(), 'player-custom-anim', ply, nil)
		end
	end

end
