hook.Add('car-dealer.populateTags', 'dbg-jobs.trucks', function(id, data, tags)
	if list.Get('simfphys_vehicles')[data.simfphysID].Members.CanAttachPackages then
		tags[#tags + 1] = carDealer.tags.truck
	end
end)

local cookForbidden = octolib.array.toKeys({ 'Доставка еды' })

hook.Add('dbg-jobs.canTake', 'dbg-jobs.restrict', function(ply, publishData)
	if ply:IsGhost() then
		return false, 'Мертвые не могут этого делать'
	end

	if ply:GetNetVar('dbg-police.job', '') ~= '' then
		return false, 'Полицейские не могут принимать заказы'
	end

	if ply:isCook() and cookForbidden[publishData.name] then
		return false, 'Повар готовит еду, а не доставляет'
	end
end)
