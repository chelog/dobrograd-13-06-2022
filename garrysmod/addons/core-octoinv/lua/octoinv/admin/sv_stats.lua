local function entToItem(item)
	return {
		pos = item:GetPos(),
		uid = item.uid,
		data = item:GetNetVar('Item'),
	}
end

netstream.Listen('octoinv.stats', function(reply, ply)
	if not ply:IsAdmin() then return end
	local ct = CurTime()
	if (ply.octoinv_nextStatsRequest or 0) > ct then return end
	ply.octoinv_nextStatsRequest = ct + 4
	reply(octolib.array.map(ents.FindByClass('octoinv_item'), entToItem))
end)

netstream.Hook('octoinv.stats.removeItem', function(ply, uid)
	if not ply:IsAdmin() then return end
	for _, v in ipairs(ents.FindByClass('octoinv_item')) do
		if v.uid == uid then
			v:Remove()
			break
		end
	end
end)

local warnOn = 100
timer.Create('octoinv.stats.check', 120, 0, function()
	local amount = #ents.FindByClass('octoinv_item')
	if amount > warnOn then
		RunConsoleCommand('sg', 'a', ('На сервере %d %s! Пожалуйста, проверьте и удалите ненужные с помощью консольной команды octoinv_stats'):format(
			amount, octolib.string.formatCount(amount, 'выброшенный предмет', 'выброшенных предмета', 'выброшенных предметов')
		))
	end
end)