local ply = FindMetaTable 'Player'

function ply:DoAnimation(animID)

	local state = { weight = 1 }
	local function update()
		if not IsValid(self) then return end
		self:AnimSetGestureWeight(GESTURE_SLOT_CUSTOM, state.weight)
	end

	octolib.tween.create(0.2, state, { weight = 0 }, 'inOutQuad', function()
		if not IsValid(self) then return end
		self:AnimRestartGesture(GESTURE_SLOT_CUSTOM, animID, true)
		octolib.tween.create(0.2, state, { weight = 1 }, 'inOutQuad', nil, update)
	end, update)

end

netstream.Hook('player-anim', function(ply, animID)

	if IsValid(ply) then
		ply:DoAnimation(animID)
	end

end)

netstream.Hook('player-custom-anim', function(ply, catID, animID)

	if not IsValid(ply) then return end

	if not catID then
		octolib.stopAnimations(ply)
		return
	end

	local cat = octolib.animations[catID or -1]
	if not cat then return end

	local anim = cat.anims[animID or -1]
	if not anim then return end

	if cat.type == 'act' then
		ply:DoAnimation(anim[2])
		return
	end

	if cat.type == 'seq' then
		local seqID = ply:LookupSequence(anim[2])
		octolib.overrideSequence[ply] = seqID

		if seqID == -1 then
			octolib.stopAnimations(ply)
			return
		end

		if cat.stand then
			octolib.resetSequenceOnMove[ply] = true
		else
			octolib.resetSequenceOnMove[ply] = nil
		end

		if anim.bones then
			octolib.manipulateBones(ply, anim.bones, 0.4)
		else
			octolib.manipulateBones(ply, nil, 0.4)
		end

		if anim.startTime then
			octolib.overrideSequenceTime[ply] = anim.startTime
		end

		return
	end

end)
