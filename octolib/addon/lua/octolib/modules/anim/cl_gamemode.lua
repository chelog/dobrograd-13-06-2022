local function run()
	if not GAMEMODE then return end
	function GAMEMODE:HandlePlayerNoClipping(ply)

		if ply:GetMoveType() == MOVETYPE_NOCLIP and not ply:InVehicle() then
			ply.CalcIdeal = ACT_MP_SWIM
			return true
		end

	end

	function GAMEMODE:HandlePlayerVaulting(ply, velocity)

		if (velocity:LengthSqr() < 90000 and not ply:GetNetVar('flying')) then return end
		if (ply:IsOnGround()) then return end

		ply.CalcIdeal = ACT_MP_SWIM

		return true

	end

	function GAMEMODE:MouthMoveAnimation(ply)

		if not ply.mmFlexes or ply.mmFlexes.model ~= ply:GetModel() then
			ply.mmFlexes = {
				ply:GetFlexIDByName('jaw_drop'),
				ply:GetFlexIDByName('left_part'),
				ply:GetFlexIDByName('right_part'),
				ply:GetFlexIDByName('left_mouth_drop'),
				ply:GetFlexIDByName('right_mouth_drop'),
				ply:GetFlexIDByName('right_funneler'),
				ply:GetFlexIDByName('left_funneler'),
				model = ply:GetModel(),
			}
		end

		if not ply.octolib_flexes or not ply.octolib_flexes[ply.mmFlexes[1]] then
			ply.octolib_flexes = ply.octolib_flexes or {}
			for _, id in ipairs(ply.mmFlexes) do
				ply.octolib_flexes[id] = 0
			end
		end

		local tgt = ply:IsSpeaking() and math.Clamp(ply:VoiceVolume() * 2.5, 0, 2) or 0
		if ply.mmWeight ~= tgt then
			ply.mmWeight = math.Approach(ply.mmWeight or 0, tgt, FrameTime() * 8)

			for _, id in ipairs(ply.mmFlexes) do
				ply:SetFlexWeight(id, ply.mmWeight + (ply.octolib_flexes[id] or 0))
			end
		end

	end
end

hook.Add('darkrp.loadModules', 'player-anim', run)
run()
