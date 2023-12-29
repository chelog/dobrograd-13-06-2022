util.AddNetworkString 'octolib.delay'
local activeDelays = {}

local function removeDelay(id)

	if not activeDelays[id] then return end

	local ply = activeDelays[id].ply
	if IsValid(ply) then
		netstream.Start(ply, 'octolib.delay', id, false)
		ply:SetNetVar('currentAction', nil)
	end

	activeDelays[id] = nil

end

local meta = FindMetaTable 'Player'
function meta:DelayedAction(id, text, delayData, periodData)

	id = id .. self:SteamID()

	if activeDelays[id] and isfunction(activeDelays[id].fail) then activeDelays[id].fail() end
	if delayData.time <= 0 then
		removeDelay(id)
		delayData.succ()
		return
	end

	if delayData.check and not delayData.check() then
		return isfunction(delayData.fail) and delayData.fail()
	end

	local finish = CurTime() + delayData.time
	activeDelays[id] = {
		ply = self,
		finish = finish,
		check = delayData.check,
		succ = delayData.succ,
		fail = delayData.fail,
	}

	if periodData then
		if periodData.inst then periodData.action() end
		timer.Create(id, periodData.time, periodData.reps or 0, function()
			if CurTime() > finish or not activeDelays[id] or not IsValid(self) then return timer.Destroy(id) end
			periodData.action()
		end)
	end

	netstream.Start(self, 'octolib.delay', id, true, text, finish)
	self:SetNetVar('currentAction', text)

end

function meta:GetRunningAction(id)

	id = id .. self:SteamID()
	return activeDelays[id]

end

hook.Add('Think', 'octolib.delay', function()

	for id, data in pairs(activeDelays) do
		if not IsValid(data.ply) then
			removeDelay(id)
			if isfunction(data.fail) then
				data.fail()
			end
		end

		if data.check and not data.check() then
			removeDelay(id)
			if isfunction(data.fail) then
				data.fail()
			end
		elseif CurTime() >= data.finish then
			removeDelay(id)
			data.succ()
		end
	end

end)
