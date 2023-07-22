octolib.server('fishing/octoinv/items')
octolib.server('fishing/octoinv/shop')
octolib.server('fishing/octoinv/crafts')

local baits = {'fish', 'prawn', 'bacon', 'cheese', 'classic', 'synthetic'}
local favorite = {}

hook.Add('Initialize', 'dbg-fishing.init', function()
	local k = 0
	math.randomseed(os.time())
	for _,v in RandomPairs(baits) do
		favorite[v] = true
		k = k + 1
		if k == 2 then break end
	end
	octolib.msg('Selected favorite fish baits for today: %s', table.concat(table.GetKeys(favorite), ', '))
end)

local bodyMats = {}
timer.Create('dbg-fishing.checkRagdolls', 15, 0, function()
	for _,v in ipairs(ents.FindByClass('prop_ragdoll')) do
		if v.tazeplayer or v.studied then continue end
		if not v:GetNetVar('Corpse.name') then return end
		if v:WaterLevel() > 0 then
			bodyMats[#bodyMats + 1] = { v:GetNetVar('Corpse.name'), v.criminals or {} }
			v.studied = true
		end
	end
end)

local function getBodyMat()
	if not bodyMats[1] then return end
	local data = {
		collector = '(найдено рыбками)',
		corpse = bodyMats[1][1],
		criminals = bodyMats[1][2],
		expire = os.time() + 60 * 60,
	}
	table.remove(bodyMats, 1)
	return data
end

local fishItems = {
	{5, 'ing_fish1'},
	{5, 'ing_fish2'},
	{3, 'ing_fish3'},
	{1, 'ing_fish4'},
}

fishing = {}
function fishing.getLoot(ply, wep)

	if not IsValid(ply) or not IsValid(wep) then return end
	local isFavorite = favorite[wep.bait or '']

	-- 20% with thick line to get loot
	if not wep.thin and math.random(5) == 1 then
		return octoinv.getRandomLoot({
			mode = 'trash',
			flatten = math.Clamp(ply:GetKarma() or 0, -1000, 1000) / 2000
		}).item
	end

	-- 25% with thick line and not favorite bait to get body mat (if any)
	if not wep.thin and not isFavorite and math.random(4) == 1 then
		local bm = getBodyMat()
		if bm then return {'body_mat', bm} end
	end

	-- 25% of getting double fish with favorive bait
	local amount = (isFavorite and math.random(4) == 1) and 2 or 1
	return {octolib.array.randomWeighted(fishItems), amount}

end

hook.Add('dbg-weapons.getItemData', 'dbg-fishing.getItemData', function(wep)

	if wep:GetClass() ~= 'weapon_octo_fishing_rod' then return end

	return table.Merge(table.Copy(wep.itemData or {}), {
		class = 'fishing_rod',
		volume = 0.37,
		thin = wep.thin,
		usesLeft = wep.usesLeft or 0,
		desc = ('Используется для ловли рыбы.\n\nЛеска %s.\nОсталось использований: %s'):format(wep.thin and 'тонкая' or 'крепкая', wep.usesLeft or 0),
	})

end)
