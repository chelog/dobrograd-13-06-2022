local maxCars = carDealer.maxCars[game.GetMap()] or carDealer.maxCars.default
carDealer.queue = carDealer.queue or {}

function carDealer.addToQueue(ply, id)

	if ply:GetLocalVar('car-dealer.queued') then
		carDealer.removeFromQueue(ply)
	end

	carDealer.queue[#carDealer.queue + 1] = ply
	ply:SetLocalVar('car-dealer.queued', {id, #carDealer.queue})
	ply:SetLocalVar('car-dealer.queuedReady')

end

function carDealer.removeFromQueue(ply)

	local key = table.RemoveByValue(carDealer.queue, ply)
	if key then
		for i = key, #carDealer.queue do
			local v = carDealer.queue[i]
			v:SetLocalVar('car-dealer.queued', {v:GetLocalVar('car-dealer.queued')[1], i})
		end
	end

	if IsValid(ply) then
		ply:SetLocalVar('car-dealer.queued')
		ply:SetLocalVar('car-dealer.queuedReady')
	end

end
hook.Add('PlayerDisconnected', 'car-dealer.queue', carDealer.removeFromQueue)

timer.Create('car-dealer.queue', CFG.dev and 5 or 30, 0, function()

	if carDealer.spawningQueuedAuto then return end

	local ply = carDealer.queue[1]
	while ply do
		if #carDealer.queue < 1 then return end
		if not IsValid(ply) then
			table.remove(carDealer.queue, 1)
			for i,v in ipairs(carDealer.queue) do
				v:SetLocalVar('car-dealer.queued', {v:GetLocalVar('car-dealer.queued')[1], i})
			end
			ply = carDealer.queue[1]
		elseif ply:GetLocalVar('car-dealer.queuedReady') then
			carDealer.notify(ply, 'warning', 'Ты не подтвердил машину вовремя и был исключен из очереди')
			carDealer.removeFromQueue(ply)
			ply = carDealer.queue[1]
		else
			break
		end
	end
	if not ply then return end

	local count = 0
	for _, v in ipairs(ents.FindByClass('gmod_sent_vehicle_fphysics_base')) do
		local cat = carDealer.categories[v.cdData and v.cdData.category or '']
		if cat and cat.queue then
			count = count + 1
			if count >= maxCars then return end
		end
	end

	ply:SetLocalVar('car-dealer.queuedReady', true)
	ply:Notify('admin', CFG.dev and 5 or 30, 'Машина готова к доставке!', 'Открой меню гаража и подтверди получение, прежде чем закончится таймер под этим сообщением')
	carDealer.sync(ply)

end)
