octolib.space = octolib.space or {}

function octolib.space.getMapZ(x, y, dir, maxTries)
	dir = dir and octolib.math.sign(dir) or -1
	maxTries = maxTries or 10

	local tr = {
		HitPos = Vector(x, y, -dir * 5000),
		HitSky = true,
	}

	local tries = 0
	while tr.HitSky or tr.HitNoDraw do
		tr = util.TraceLine {
			start = tr.HitPos + Vector(0, 0, dir),
			endpos = tr.HitPos + Vector(0, 0, dir * 10000),
			collisiongroup = COLLISION_GROUP_WORLD,
		}

		tries = tries + 1
		if tries > maxTries then break end
	end

	local result = tr.HitPos and (tr.HitPos + tr.HitNormal) or Vector(x, y, 0)
	return result.z
end
