--
-- INIT STUFF
--

octoinv.items = octoinv.items or {}
octoinv.itemClasses = octoinv.itemClasses or {}

-- default data to be returned if it's missing from both class and item tables
octoinv.defaultData = {
	amount = 1,
	volume = 0,
	mass = 0,
	name = L.unknown,
	icon = 'icon16/exclamation.png',
	model = 'models/props_junk/garbage_bag001a.mdl',
}

octoinv.defaultHand = {
	name = L.inventory_hands,
	volume = 100,
	icon = octolib.icons.color('hand'),
	craft = true,
}
-- default inventory setup for new players
octoinv.defaultInventory = {
	top = {
		name = L.jacket,
		volume = 5,
		icon = octolib.icons.color('clothes_jacket'),
		items = {},
	},
	bottom = {
		name = L.pants,
		volume = 1,
		icon = octolib.icons.color('clothes_jeans'),
		items = {},
	},
	_hand = defaultHand,
}

--
-- UTIL
--

-- sync thingie (to fix multiple updates per frame)
local syncQueue = {}
function octoinv.syncCont(cont) syncQueue[cont] = true end
function octoinv.unsyncCont(cont) syncQueue[cont] = nil end
hook.Add('Think', 'octoinv.sync', function()
	for cont, v in pairs(syncQueue) do
		cont:Sync()
		syncQueue[cont] = nil
	end
end)

function octoinv.registerItem(id, t)

	if not id then
		octoinv.msg('ERROR: Cannot register item \'%s\' - no id!', t.name)
		return
	end

	t.name = t.name or id
	t.mass = t.mass or 0
	t.volume = t.volume or 0
	octoinv.items[id] = t

	if t.class then
		octoinv.itemClasses[t.class] = id
	end

end

function octoinv.getItemData(field, class, data)

	local classTbl = octoinv.items[class]
	if not classTbl then return end

	if field == 'amount' and isnumber(data) then return data end
	return istable(data) and data[field] or classTbl[field] or octoinv.defaultData[field] or nil

end

function octoinv.itemStr(item)

	local amount = isnumber(item[2]) and item[2] or octoinv.getItemData('amount', item[1], item[2])
	return ('%sx%s'):format(amount, octoinv.getItemData('name', item[1], item[2]))

end

--
-- LOAD RESOURCES
--

-- load meta
octolib.server('meta_item')
octolib.server('meta_cont')
octolib.server('meta_inv')
octolib.server('ext_entity')
octolib.server('ext_player')
