local offset = Vector(2,2,2)

timer.Create('loopUnstuck', 3, 0, function()
	octolib.func.throttle(player.GetAll(), 5, 0.1, function(ply)
		if IsValid(v) and v:IsPlayer() and v:Alive() and not v:InVehicle() then
			local isStuck = false
			for _, ent in ipairs(ents.FindInBox(v:GetPos() + v:OBBMins() + offset, v:GetPos() + v:OBBMaxs() - offset)) do
				if IsValid(ent) and ent ~= v and ent:IsPlayer() and ent:Alive() and not (ent:IsGhost() or v:IsGhost()) then
					v:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
					v:SetVelocity(Vector(-10, -10, 1) * 20)
					ent:SetVelocity(Vector(10, 10, 1) * 20)
					isStuck = true
				end
			end

			if not isStuck then
				v:SetCollisionGroup(v:IsGhost() and COLLISION_GROUP_IN_VEHICLE or COLLISION_GROUP_PLAYER)
			end
		end
	end)
end)
