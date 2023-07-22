local function throw(ply, ent, expire)
	local force = 300
	local pos, ang, vel = ply:GetBonePosition(ply:LookupBone('ValveBiped.Bip01_L_Hand') or 16)
	local tr = util.TraceLine { start = ply:GetShootPos(), endpos = pos, filter = ply }
	if tr.Hit then
		pos = tr.HitPos + tr.HitNormal * 5
		vel = tr.HitNormal * force * 0.4
	else
		vel = ply:GetAimVector()
		vel = (vel + VectorRand() * math.random() * 0.1) * force
	end

	ent:SetPos(pos)
	ent:SetAngles(ang)

	ent:Spawn()
	ent:Activate()
	ent.owner = ply
	ent.expire = expire
	ply:LinkEntity(ent)

	local phys = ent:GetPhysicsObject()
	if IsValid(phys) then
		phys:Wake()
		phys:SetVelocity(vel)
	end
end


octoinv.registerItem('spike_strips', {
	name = 'Полицейские шипы',
	icon = 'octoteam/icons/spike_strips.png',
	mass = 1.5,
	volume = 1.5,
	model = 'models/props_junk/cardboard_box001a.mdl',
	desc = 'Шипы, применяемые при погонях для быстрой остановки подозреваемого',
	nostack = true,
	use = {
		function(ply, item)
			if not (ply:Team() == TEAM_DPD or ply:Team() == TEAM_WCSO) then return end
			return 'Бросить', 'octoteam/icons/hand.png', function(ply, item)
				ply:DoAnimation(ACT_GMOD_GESTURE_ITEM_THROW)
            	timer.Simple(0.88, function()
					local ent = ents.Create('ent_dbg_spike_strips')
					if not IsValid(ent) then return end
					throw(ply, ent, item:GetData('expire'))
				end)
				return 1
			end
		end,
	},
})
