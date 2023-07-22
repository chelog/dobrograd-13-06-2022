local white = Color(255, 255, 255, 200)
local red = Color(128, 30, 30, 255)

surface.CreateFont('dbg-doors', {
	font = 'Calibri',
	extended = true,
	size = 76,
	weight = 350,
})

local types = {
	[1] = '(Для бизнеса)',
	[2] = '(Для проживания)'
}

local function doorText(ent)

	local playerOwned = ent:GetPlayerOwner()
	local doorInfo = {}

	local door = dbgEstates.getData(ent:GetEstateID()) or {}
	local owners = door.owners or {}
	if not owners[1] then return doorInfo end

	doorInfo[#doorInfo + 1] = L.keys_owned_by
	for _,v in ipairs(owners) do

		if octolib.string.isSteamID(v) then
			local ply = player.GetBySteamID(v)
			doorInfo[#doorInfo + 1] = IsValid(ply) and ply:Name() or ('Игрок вышел (' .. playerOwned .. ')')

		elseif string.StartWith(v, 'g:') then
			local name = dbgDoorGroups.groups[v:sub(3)]
			if name then
				doorInfo[#doorInfo + 1] = name
			end

		elseif string.StartWith(v, 'j:') then
			local job = DarkRP.getJobByCommand(v:sub(3))
			if job then
				doorInfo[#doorInfo + 1] = job.name
			end
		end

	end

	if LocalPlayer():Team() == TEAM_ADMIN then doorInfo[#doorInfo + 1] = types[door.purpose] end

	return doorInfo
end

local identifiedInfo = {}

netstream.Hook('dbg-estates.unown', function(estIdx)
	identifiedInfo[estIdx] = nil
end)
netstream.Hook('dbg-doors.identify', function(estIdx)
	if not LocalPlayer():isCP() then return end
	local door = dbgEstates.getData(estIdx).doors[1]
	local info = doorText(door)
	if #info > 0 then identifiedInfo[estIdx] = info end
end)

local buyText
hook.Add('dbg-view.chPaint', 'dbg-doors', function(tr, icon)

	local ent = LocalPlayer():GetEyeTrace().Entity
	if tr.Fraction < 0.05 and IsValid(ent) and ent:IsDoor() then
		local blocked, owned = ent:IsBlocked(), ent:IsOwned()
		local doorInfo = {}

		local title = ent:GetTitle()
		if title then
			doorInfo[#doorInfo + 1] = title
		end

		local job = RPExtraTeams[LocalPlayer():Team()]
		if not job.hobo then
			if owned then
				local mergeInfo
				if LocalPlayer():Team() == TEAM_ADMIN then
					mergeInfo = doorText(ent)
				else
					mergeInfo = identifiedInfo[ent:GetEstateID()] or {}
				end
				for _, v in ipairs(mergeInfo) do
					doorInfo[#doorInfo + 1] = v
				end
			elseif not blocked then
				buyText = buyText or L.to_buy .. (utf8.upper(input.LookupBinding('use')) or 'E')
				doorInfo[#doorInfo + 1] = L.priceTag:format(DarkRP.formatMoney(ent:GetPrice()))
				doorInfo[#doorInfo + 1] = buyText
			end
		end

		draw.DrawText(table.concat(doorInfo, '\n'), 'dbg-doors', 2, 37, color_black, TEXT_ALIGN_CENTER)
		draw.DrawText(table.concat(doorInfo, '\n'), 'dbg-doors', 0, 35, (blocked or owned) and red or white, TEXT_ALIGN_CENTER)
	end

end)

local meta = FindMetaTable('Entity')
function meta:drawOwnableInfo() end
