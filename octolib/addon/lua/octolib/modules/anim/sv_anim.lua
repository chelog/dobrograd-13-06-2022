--
-- GESTURES
--

local function run()
	if not GAMEMODE then return end
	GAMEMODE.PlayerShouldTaunt = octolib.func.no
	GAMEMODE.HandlePlayerNoClipping = octolib.func.zero
	GAMEMODE.HandlePlayerVaulting = octolib.func.zero
	GAMEMODE.HandlePlayerJumping = octolib.func.zero
	GAMEMODE.HandlePlayerSwimming = octolib.func.zero
	GAMEMODE.HandlePlayerVaulting = octolib.func.zero
end
hook.Add('darkrp.loadModules', 'player-anim', run)
run()

local ply = FindMetaTable 'Player'
function ply:DoAnimation(animID, freeze)

	self:AnimRestartGesture(GESTURE_SLOT_CUSTOM, animID, true)

	local s = self:SelectWeightedSequence(animID)
	local d = self:SequenceDuration(s)
	self.nextAnim = CurTime() + d

	if freeze then
		self:Freeze(true)
		timer.Simple(d, function()
			self:Freeze(false)
		end)
	end

	netstream.StartPVS(self:GetPos(), 'player-anim', self, animID)

end

netstream.Hook('player-anim', function(ply, catID, animID)

	if not IsValid(ply) or CurTime() < (ply.nextAnim or 0) then return end

	local cat = octolib.animations[catID or -1]
	if not cat or cat.hide then return end

	local anim = cat.anims[animID or -1]
	if not anim then return end

	if not ply:Alive() or ply:IsFrozen() or ply:InVehicle() or hook.Run('octolib.canUseAnimation', ply, cat, anim) == false then return end

	local wep = ply:GetActiveWeapon()
	if IsValid(wep) and wep.CanUseAnimation and wep:CanUseAnimation(cat, anim) == false then return end

	if cat.donate and not ply:GetNetVar('os_dobro') then
		ply:Notify('warning', L.gesture_only_for_dobro)
		return
	end

	if cat.type == 'act' then
		octolib.stopAnimations(ply)
		ply:DoAnimation(anim[2], cat.freeze)
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
			ply:MoveModifier('anim', { nojump = true })
		else
			octolib.resetSequenceOnMove[ply] = nil
			ply:MoveModifier('anim', nil)
		end

		ply.octolib_customAnim = { catID, animID }
		netstream.StartPVS(ply:GetPos(), 'player-custom-anim', ply, catID, animID)
	end

end)

