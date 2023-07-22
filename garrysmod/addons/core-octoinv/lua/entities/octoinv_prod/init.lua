AddCSLuaFile 'cl_init.lua'
AddCSLuaFile 'shared.lua'

include 'shared.lua'

DEFINE_BASECLASS('octoinv_cont')

ENT.Model = 'models/props_wasteland/laundry_washer003.mdl'
ENT.CollisionGroup = COLLISION_GROUP_NONE
ENT.Physics = true

ENT.LoopSound = 'octoinv.prod3'
ENT.WorkSound = 'octoinv.prod13'
ENT.Containers = {
	ref_fuel = { name = L.refinery_fuel, volume = 100, prod = true },
	ref = { name = L.refinery, volume = 100 },
}

ENT.Fuel = {
	ref_fuel = {
		craft_stick = 5,
		craft_plank = 60,
	},
}

ENT.Prod = {
	{
		time = 2,
		ins = {
			ref = {
				{'craft_screw2', 2},
				{'craft_screwnut', 2},
			},
		},
		out = {
			ref = {
				{'ingot_iron', 1},
			},
		},
	},
	{
		time = 5,
		ins = {
			ref = {
				{'craft_nail', 5},
			},
		},
		out = {
			ref = {
				{'ingot_iron', 1},
			},
		},
	},
}

function ENT:Initialize()

	BaseClass.Initialize(self)
	self.itemsWorking = self.itemsWorking or {}

end

function ENT:SetProdData(data)

	if not istable(data) then return end

	self.Prod = data.prod
	self.Fuel = data.fuel
	self.DestructParts = data.destruct
	self.DestroyParts = data.destroy
	self.Explode = data.explode
	self.ContHealth = data.health

	local sounds = data.sounds
	self.LoopSound = sounds and sounds.loop or 'octoinv.prod3'
	self.WorkSound = sounds and sounds.work or 'octoinv.prod13'

end

function ENT:TakeFuel()

	if not self.Fuel then
		for contID, items in pairs(self.inv.conts) do
			local cont = self.inv:GetContainer(contID)
			if cont.on then return 1 end
		end
	else
		for contID, items in pairs(self.Fuel) do
			local cont = self.inv:GetContainer(contID)
			if not cont or not cont.on then continue end

			for class, time in pairs(items) do
				if cont:HasItem(class) > 0 then
					cont:TakeItem(class)
					return time
				end
			end
		end
	end

	return false

end

function ENT:FindTask()

	-- search for a task to complete
	for taskID, task in pairs(self.Prod) do
		local ok = true
		for contID, items in pairs(task.ins) do
			local cont = self.inv:GetContainer(contID)
			if not cont then
				ok = false
				break
			end

			for i, item in ipairs(items) do
				if isstring(item[1]) then
					-- stackable
					if cont:HasItem(item[1]) < item[2] then
						ok = false
						break
					end
				else
					-- non-stackable
					local res = cont:FindItem(item)
					if not res then
						ok = false
						break
					end
				end
			end

			if not ok then break end
		end

		if ok then
			self.curTask = task
			self.taskStart = CurTime()
			break
		end
	end

	if self.curTask then
		-- found task, initialize
		for contID, items in pairs(self.curTask.ins) do
			local cont = self.inv:GetContainer(contID)
			for i, item in ipairs(items) do
				if isstring(item[1]) then
					-- stackable
					cont:TakeItem(item[1], item[2])
				else
					-- non-stackable
					local res = cont:FindItem(item)
					if res then
						self.itemsWorking[cont] = self.itemsWorking[cont] or {}
						self.itemsWorking[cont][i] = res
						cont:TakeItem(res)
					end
				end
			end
		end

		return true
	else
		return false
	end

end

function ENT:FinishTask()

	if not self.curTask then return end

	for contID, items in pairs(self.curTask.out) do
		local cont = self.inv:GetContainer(contID)
		for i, item in pairs(items) do
			if isfunction(item) then
				local res = self.itemsWorking[cont] and self.itemsWorking[cont][i]
				if res then
					cont:AddItem(res)
					item(res)
				end
			else
				local chance, class, amountOrData = unpack(item)
				if isstring(chance) then
					chance = 1
					class, amountOrData = unpack(item)
				end
				local amount = isnumber(amountOrData) and amountOrData or 1
				if math.random() > chance then continue end

				local added = cont:AddItem(class, amountOrData)
				if added < amount then
					cont:DropNewItem(class, isnumber(amountOrData) and (amount - added) or amountOrData)
				end
			end
		end
	end
	self.itemsWorking = {}
	self.curTask = nil

end

function ENT:FailTask()

	if not self.curTask then return end

	for contID, items in pairs(self.curTask.ins) do
		local cont = self.inv:GetContainer(contID)
		for i, item in ipairs(items) do
			if isstring(item[1]) then
				local added = cont:AddItem(item[1], item[2])
				if isnumber(item[2]) and isnumber(added) and added < item[2] then
					cont:DropNewItem(item[1], item[2] - added)
				end
			else
				local res = self.itemsWorking[cont] and self.itemsWorking[cont][i]
				if res then
					if cont:SpaceFor(res) > 0 then
						cont:AddItem(res)
					else
						cont:DropNewItem(res)
					end
				end
			end
		end
	end
	self.itemsWorking = {}
	self.curTask = nil

end

function ENT:Think()

	if not self.inv then return end

	-- check if is working and on fuel
	if not self.working then
		local time = self:TakeFuel()
		if time then
			self.working = CurTime() + time
			self:EmitSound(self.LoopSound)
		else
			self:NextThink(CurTime() + 1)
			return true
		end
	elseif CurTime() > self.working then
		local time = self:TakeFuel()
		if time then
			self.working = self.working + time
		else
			self.working = nil
			self:StopSound(self.LoopSound)

			if self.curTask then
				if CurTime() > self.taskStart + self.curTask.time then
					self:FinishTask()
				else
					self:FailTask()
				end
				self:StopSound(self.WorkSound)
			end

			self:NextThink(CurTime() + 1)
			return true
		end
	end

	-- finish task if has one and time passed
	if self.curTask then
		if CurTime() > self.taskStart + self.curTask.time then
			self:FinishTask()
			if not self:FindTask() then
				self:StopSound(self.WorkSound)
			end
		end
	else
		if self:FindTask() then
			self:EmitSound(self.WorkSound)
		else
			-- no task meets requirements, take a rest
			self:NextThink(CurTime() + 1)
			return true
		end
	end

end
