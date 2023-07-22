AddCSLuaFile 'cl_init.lua'
AddCSLuaFile 'shared.lua'

include 'shared.lua'

function ENT:Initialize()

	self:SetModel('models/mark2580/sanctum/props/sanctum_christmas_tree.mdl')
	for i = 1, 4 do
		self:SetBodygroup(i, 1)
	end
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self.balls = {}
	self.fireworks = {}
	self.lastPurchaseID = 0
	self.nextBallPosition = 1

end

local function parse(data)
	math.randomseed(CurTime())
	local ans = {}
	for _,obj in RandomPairs(string.Explode('; ', data)) do
		local dat = string.Explode(' ', obj)
		ans[#ans + 1] = {
			Vector(tonumber(dat[1]), tonumber(dat[2]), tonumber(dat[3]) - 1.5),
			Angle(tonumber(dat[4]), tonumber(dat[5]), tonumber(dat[6])),
		}
	end
	return ans
end
local poses = parse('70.5 -41.1 37.3 0 -62.7 0; 70.5 -68.9 38.5 0 16.4 0; -50.7 50.8 39.2 0 67.1 0; -59.3 24.3 40.2 0 0 0; -25.2 -67 41 0 -60 0; -61.3 -44.2 41.2 0 -60 0; 64.3 -13.7 42.1 0 -25.4 0; -8.6 98.6 47.6 0 0 0; -74.9 -12.2 50.9 0 -60 0; 12.5 -74.6 51.3 0 16.4 0; 26.7 81.2 54.4 0 0 0; -59.6 53.7 62.2 0 45.4 0; 82.2 33.3 67.1 0 -60.8 0; -70.4 -57.8 68.3 0 -60 0; -81.6 -4.8 70.1 0 -60 0; 85.8 5.4 71.3 0 31.9 0; 63.9 -76.3 75 0 98 0; -57.4 -36.6 75.5 0 -60 0; 67.5 58.4 76.7 0 -15.3 0; 50 -92.2 77.6 0 6.1 0; -73.5 37.6 77.7 0 94.2 0; 4.4 -82.1 78.7 0 6.1 0; -24.2 74.2 80.6 0 22.3 0; 66.3 -23.8 81.4 0 35.4 0; -77.6 20 81.6 0 50.4 0; 26.3 63.3 81.6 0 -15.3 0; -40.3 -69.8 81.7 0 -60 0; -11.3 88.9 86 0 0 0; -45.6 60.3 88.8 0 56.8 0; 41.6 -70 93.6 0 18.1 0; 96.2 17.5 95.1 0 -94.6 0; 64.5 -10.5 100.2 0 -94.6 0; -52 -21.3 102 0 56.8 0; -40.1 -61.3 105.2 0 119.2 0; -18.8 -82 108.7 0 11.7 0; 64.3 14.5 115.6 0 18.1 0; 39.4 50.4 117.9 0 -52.7 0; 59.2 -38 122.3 0 52.8 0; 28 79.6 129.9 0 -19 0; -13.6 56.8 130.2 0 38 0; -48.7 38.1 133 0 51.2 0; -48.7 -2.6 135.9 0 -78.8 0; 29.5 -36.5 142.4 0 -7.4 0; -43.2 -28.2 144.6 0 -42 0; 5.2 -59.7 147.8 0 52.8 0; -28.2 -60.5 148.2 0 -42 0; 69.1 5.3 149.5 0 -84.2 0; -1.2 65.4 153.7 0 -13.7 0; 60.7 26.3 160.2 0 0 0; 23.5 -59.3 162.5 0 52.8 0; 56.4 -23.1 163.6 0 81.9 0; -32.5 53.9 165 0 29 0; -40.1 -46.2 170.7 0 -27 0; 24.1 44.3 176 0 -33.5 0; -21.5 -45.6 179.5 0 -27 0; 40 -43 182.8 0 82.7 0; 8.7 45 185.9 0 -33.5 0; 48.8 9 188.9 0 -33.5 0; -51.1 10.3 189.6 0 5.5 0; -39.9 40.6 192.3 0 5.5 0; 23.3 -24.6 192.5 0 106.5 0; -16.1 58 194 0 54.6 0; 49.2 -10.9 196.4 0 106.5 0; 36.8 21.2 198 0 -111.7 0; -52.5 -4.6 201.8 0 97 0; -36.9 -31.8 203.3 0 -27 0; -13.2 -42.6 207.7 0 -27 0; 31.9 31.6 211.9 0 -7.5 0; 19.2 -32.9 215.5 0 11 0; -8 35.6 224 0 -35.8 0; -39.2 21.6 226.1 0 54.9 0; 11.6 37.9 231.2 0 -7.5 0; 38.5 7.3 235.9 0 -111.3 0; 16.7 -29.3 249.9 0 13.2 0; -12.3 -33.5 254.5 0 0 0; 28.5 14.1 259.9 0 -32.1 0; 33.4 -2.9 260.9 0 88.5 0; -14.8 22.3 269 0 0 0; 19 -14.3 274 0 -38.3 0; -25.9 4.8 279.3 0 -91.2 0; 13.9 23 279.5 0 71.6 0; -11.8 -19.5 281.8 0 -17.9 0; -4.9 17.1 291.4 0 24.1 0')

local function placeAround(tree, ent, r)
	local dir = VectorRand()
	dir.z = 0
	dir = dir:GetNormalized() * math.Rand(0.75, 1.1) * r
	dir = dir + tree:GetPos()
	local res = util.TraceEntity({
		start = dir + Vector(0, 0, 200),
		endpos = dir - Vector(0, 0, 100),
		filter = tree,
	}, ent)
	ent:SetPos(res.HitPos)
	ent:SetAngles(Angle(0, math.random(0, 360), 0))
end

function ENT:QueueFirework(sid64, name, amount)

	self.fireworks[#self.fireworks + 1] = {name, amount}

	-- local ply = player.GetBySteamID64(sid64)
	-- if IsValid(ply) then
	-- 	ply:RandomXMasTreat(true)
	-- end

end

function ENT:LaunchFireworks()

	if not self.fireworks or #self.fireworks == 0 then return end

	local names = {}
	for i, v in ipairs(self.fireworks) do
		names[v[1]] = true

		local fw = ents.Create('ent_dbg_fireworks')
		placeAround(self, fw, 150)
		fw.ShellsNum = math.min(math.ceil(v[2] / 50), 20) * 10
		fw.LaunchInterval = 1
		fw.LaunchVariance = { -2, 2 }
		fw:Spawn()
		self:DeleteOnRemove(fw)
		fw:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
		local phys = fw:GetPhysicsObject()
		if IsValid(phys) then phys:EnableMotion(false) end

		fw:SetNetVar('dbgLook', {
			name = v[1],
			desc = tostring(v[2]) .. 'р',
			time = 1,
		})

		timer.Simple(i + 5 * 60, function()
			if IsValid(fw) then
				fw:Use(Entity(0), Entity(0), USE_TOGGLE, 1)
			end
		end)
	end
	table.Empty(self.fireworks)

	names = table.GetKeys(names)
	local msg = table.concat(names, ', ', 1, #names-1)
	if #names > 1 then msg = msg .. ' и ' .. names[#names]
	else msg = names[1] end
	octolib.notify.sendAll('hint', 'Через 5 минут около елки будет салют в честь ' .. msg .. '! <3')

end

function ENT:AddBall(sid64, name, amount)

	local pos = poses[self.nextBallPosition]
	if not pos then
		return self:QueueFirework(sid64, name, amount)
	end

	local ball = ents.Create('ent_dbg_xmas_ornament')
	ball:SetParent(self, 0)
	ball:SetLocalPos(pos[1])
	ball:SetLocalAngles(pos[2])
	self:DeleteOnRemove(ball)
	ball.ownerSID64 = sid64
	ball:Spawn()

	local phys = ball:GetPhysicsObject()
	if IsValid(phys) then
		phys:EnableMotion(false)
	end

	ball:SetNetVar('dbgLook', {
		name = '',
		desc = ('%s от %s'):format(amount .. 'р', name),
		time = 1,
	})
	self.balls[#self.balls + 1] = ball
	if #self.balls >= 42 then self:SetBodygroup(4, 0) end

end

function ENT:UpdateStar(name)

	local sid64, amount =
		self.maxPayment.steamID64,
		self.maxPayment.amount

	local star = self.star
	if not IsValid(star) then
		star = ents.Create('ent_dbg_xmas_ornament')
		star:SetParent(self)
		star:SetLocalPos(Vector(0, 0, 343))
		star.isStar = true
		star.ownerSID64 = sid64
		star:Spawn()
		self.star = star
	end

	star:SetNetVar('dbgLook', {
		name = name,
		desc = tostring(amount) .. 'р',
		time = 1,
	})

end

function ENT:Think()

	if CWI.IsNight() then
		self:LaunchFireworks()
	end

	octolib.db:PrepareQuery([[
		SELECT payments.id, amount, anonymous, steamID64, timeCompleted FROM ]] .. CFG.db.shop .. [[.octoshop_payments AS payments
		JOIN ]] .. CFG.db.shop .. [[.octoshop_users AS users
		ON payments.userID = users.id
			WHERE payments.id > ?
			AND amount >= ?
			AND timeCompleted >= UNIX_TIMESTAMP(curdate() - INTERVAL((WEEKDAY(curdate()))) DAY)
	]], { self.lastPurchaseID or 0, self.ballCost or 100 }, function(_, _, dbResult)
		if not istable(dbResult) then
			print(dbResult)
			return
		end

		if #dbResult < 1 then return end

		-- update star
		local maxPayment = octolib.array.reduce(dbResult, function(max, payment) return max.amount >= payment.amount and max or payment end)
		if maxPayment.amount > self.starCost then
			self.maxPayment = maxPayment
			self.starCost = maxPayment.amount
			if tobool(maxPayment.anonymous) then
				self:UpdateStar(self.anonymousName)
			else
				octolib.getSteamData({ maxPayment.steamID64 }, function(steamResult)
					self:UpdateStar(steamResult[1].name)
				end)
			end
		end

		-- update balls
		local sids = octolib.table.map(dbResult, function(payment) return payment.steamID64 end)
		octolib.getSteamData(sids, function(steamResult)
			for i, steamData in ipairs(steamResult) do
				local payment = dbResult[i]
				local name = tobool(payment.anonymous) and self.anonymousName or steamData.name
				self:AddBall(payment.steamID64, name, payment.amount)
				self.nextBallPosition = self.nextBallPosition + 1

				self.lastPurchaseID = payment.id
			end
		end)
	end)

	self:NextThink(CurTime() + self.updateInterval)
	return true

end
