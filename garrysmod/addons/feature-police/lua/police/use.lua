CFG.use.ent_dbg_spike_strips = {
	function(ply, ent)
		if not (ply:Team() == TEAM_DPD or ply:Team() == TEAM_WCSO) then return end
		return 'Поднять', 'octoteam/icons/arrow_up2.png', function(ply, ent)
			ply:DelayedAction('grabspike', 'Подбор шипов', {
				time = 1,
				check = function() return octolib.use.check(ply, ent) end,
				succ = function()
					if not IsValid(ply) or not IsValid(ent) then return end

					ply:AddItem('spike_strips', {expire = ent.expire or os.time() + 7200})
					ent:Remove()
				end,
			}, {
				time = 1.5,
				inst = true,
				action = function()
					ent:EmitSound('physics/rubber/rubber_tire_strain'..math.random(1,3)..'.wav', 65)
					ply:DoAnimation(ACT_GMOD_GESTURE_ITEM_DROP + math.random(0,1))
				end,
			})
		end
	end,
}
