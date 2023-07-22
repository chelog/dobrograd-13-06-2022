octoinv.loot = {}

function octoinv.registerLoot(chance, data)

	local item = table.Copy(data)
	item.chance = chance
	if data.mode then
		item.mode = istable(data.mode) and octolib.array.toKeys(data.mode) or {[data.mode] = true}
	end

	octoinv.loot[#octoinv.loot + 1] = {chance, item}
	return item

end

function octoinv.getRandomLoot(opts)

	local items = opts.mode
		and octolib.array.filter(octoinv.loot, function(v) return not v[2].mode or v[2].mode[opts.mode] end)
		or octoinv.loot

	return table.Copy(octolib.array.randomWeighted(items, opts.flatten))

end

-- location can be either player, inventory or container
function octoinv.placeRandomLoot(location, opts)

	local loot = octoinv.getRandomLoot(opts)
	local amount, item = location:AddItem(unpack(loot.item))
	if item and loot.given then loot.given(item) end

	return item, loot

end
