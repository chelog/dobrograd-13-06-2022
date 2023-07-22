local mdls = {
	['female_01'] = 'models/dizcordum/citizens/playermodels/p_female_01.mdl',
	['female_02'] = 'models/dizcordum/citizens/playermodels/p_female_02.mdl',
	['female_03'] = 'models/dizcordum/citizens/playermodels/p_female_03.mdl',
	['female_04'] = 'models/dizcordum/citizens/playermodels/p_female_04.mdl',
	['female_06'] = 'models/dizcordum/citizens/playermodels/p_female_06.mdl',
	['female_07'] = 'models/dizcordum/citizens/playermodels/p_female_05.mdl',

	['male_01_01'] = 'models/dizcordum/citizens/playermodels/pm_male_01.mdl',
	['male_01_02'] = 'models/dizcordum/citizens/playermodels/pm_male_01.mdl',
	['male_01_03'] = 'models/dizcordum/citizens/playermodels/pm_male_01.mdl',

	['male_02_01'] = 'models/dizcordum/citizens/playermodels/pm_male_02.mdl',
	['male_02_02'] = 'models/dizcordum/citizens/playermodels/pm_male_02.mdl',
	['male_02_03'] = 'models/dizcordum/citizens/playermodels/pm_male_02.mdl',

	['male_03_01'] = 'models/dizcordum/citizens/playermodels/pm_male_03.mdl',
	['male_03_02'] = 'models/dizcordum/citizens/playermodels/pm_male_03.mdl',
	['male_03_03'] = 'models/dizcordum/citizens/playermodels/pm_male_03.mdl',
	['male_03_04'] = 'models/dizcordum/citizens/playermodels/pm_male_03.mdl',
	['male_03_05'] = 'models/dizcordum/citizens/playermodels/pm_male_03.mdl',
	['male_03_06'] = 'models/dizcordum/citizens/playermodels/pm_male_03.mdl',
	['male_03_07'] = 'models/dizcordum/citizens/playermodels/pm_male_03.mdl',

	['male_04_01'] = 'models/dizcordum/citizens/playermodels/pm_male_04.mdl',
	['male_04_02'] = 'models/dizcordum/citizens/playermodels/pm_male_04.mdl',
	['male_04_03'] = 'models/dizcordum/citizens/playermodels/pm_male_04.mdl',
	['male_04_04'] = 'models/dizcordum/citizens/playermodels/pm_male_04.mdl',

	['male_05_01'] = 'models/dizcordum/citizens/playermodels/pm_male_05.mdl',
	['male_05_02'] = 'models/dizcordum/citizens/playermodels/pm_male_05.mdl',
	['male_05_03'] = 'models/dizcordum/citizens/playermodels/pm_male_05.mdl',
	['male_05_04'] = 'models/dizcordum/citizens/playermodels/pm_male_05.mdl',
	['male_05_05'] = 'models/dizcordum/citizens/playermodels/pm_male_05.mdl',

	['male_06_01'] = 'models/dizcordum/citizens/playermodels/pm_male_06.mdl',
	['male_06_02'] = 'models/dizcordum/citizens/playermodels/pm_male_06.mdl',
	['male_06_03'] = 'models/dizcordum/citizens/playermodels/pm_male_06.mdl',
	['male_06_04'] = 'models/dizcordum/citizens/playermodels/pm_male_06.mdl',
	['male_06_05'] = 'models/dizcordum/citizens/playermodels/pm_male_06.mdl',

	['male_07_01'] = 'models/dizcordum/citizens/playermodels/pm_male_07.mdl',
	['male_07_02'] = 'models/dizcordum/citizens/playermodels/pm_male_07.mdl',
	['male_07_03'] = 'models/dizcordum/citizens/playermodels/pm_male_07.mdl',
	['male_07_04'] = 'models/dizcordum/citizens/playermodels/pm_male_07.mdl',
	['male_07_05'] = 'models/dizcordum/citizens/playermodels/pm_male_07.mdl',
	['male_07_06'] = 'models/dizcordum/citizens/playermodels/pm_male_07.mdl',

	['male_08_01'] = 'models/dizcordum/citizens/playermodels/pm_male_08.mdl',
	['male_08_02'] = 'models/dizcordum/citizens/playermodels/pm_male_08.mdl',
	['male_08_03'] = 'models/dizcordum/citizens/playermodels/pm_male_08.mdl',
	['male_08_04'] = 'models/dizcordum/citizens/playermodels/pm_male_08.mdl',

	['male_09_01'] = 'models/dizcordum/citizens/playermodels/pm_male_07.mdl',
	['male_09_02'] = 'models/dizcordum/citizens/playermodels/pm_male_07.mdl',
	['male_09_03'] = 'models/dizcordum/citizens/playermodels/pm_male_08.mdl',
	['male_09_04'] = 'models/dizcordum/citizens/playermodels/pm_male_07.mdl',
}

local maleBgs = {
	{
		id = 1,
		name = 'Верх',
		vals = {
			{'Куртка болотного цвета', 0},
			{'Серая куртка', 1},
			{'Серая куртка с капюшоном', 2},
			{'Бирюзовая куртка, расстегнута', 4},
			{'Бирюзовая куртка, застегнута', 7},
			{'Синяя куртка, расстегнута', 3},
			{'Синяя куртка, застегнута', 6},
			{'Красная куртка, расстегнута', 5},
			{'Красная куртка, застегнута', 8},
		},
	}, {
		id = 2,
		name = 'Низ',
		vals = {
			{'Синие джинсы', 0},
			{'Темно-синие джинсы', 1},
			{'Серые джинсы', 2},
			{'Синие свободные джинсы', 3},
			{'Темные свободные джинсы', 4},
			{'Серые болоневые штаны', 5},
			{'Синие болоневые штаны', 6},
			{'Серые рабочие брюки', 7},
			{'Камуфляжные рабочие брюки', 8},
		},
	}, {
		id = 3,
		name = 'Перчатки',
	}, {
		id = 4,
		name = 'Шапка',
		vals = {3},
	}
}

local femaleBgs = {
	{
		id = 1,
		name = 'Верх',
		vals = {
			{'Куртка болотного цвета', 0},
			{'Бирюзовая куртка, расстегнута', 1},
			{'Бирюзовая куртка, застегнута', 5},
			{'Синяя куртка, расстегнута', 2},
			{'Синяя куртка, застегнута', 4},
			{'Красная куртка, расстегнута', 3},
			{'Красная куртка, застегнута', 6},
		},
	},
	{
		id = 2,
		name = 'Низ',
		vals = {
			{'Синие джинсы + Ботинки', 0},
			{'Брюки + Сапоги', 1},
			{'Штаны с полоской + Ботинки', 2},
			{'Синие испачканные штаны + Ботинки', 3},
			{'Серые испачканные штаны + Ботинки', 4},
			{'Серые болоневые штаны', 5},
			{'Светлые болоневые штаны', 6},
			{'Серые рабочие брюки', 7},
		},
	}, {
		id = 3,
		name = 'Перчатки'
	}
}

local function getMdlData(ply)
	local oldMdl, newMdl = ply:GetModel()
	for pattern, mdl in pairs(mdls) do
		if oldMdl:find(pattern) then newMdl = mdl break end
	end
	if not newMdl then return end
	return {
		name = 'Теплая одежда',
		model = newMdl,
		unisex = true,
		bgs = octolib.models.isMale(newMdl) and maleBgs or femaleBgs,
	}
end

function EventMakeRefugee(ply, callback, check)

	callback = isfunction(callback) and callback or octolib.func.zero
	if not (IsValid(ply) and ply:IsPlayer()) then return callback(false) end
	local mdlData = getMdlData(ply)
	if not mdlData then return callback(false) end

	if ply.pendingRefugee then
		ply.pendingRefugee[1](false)
		ply.pendingRefugee = nil
	end

	ply.pendingRefugee = { callback, isfunction(check) and check or octolib.func.yes }
	netstream.Start(ply, 'dbg-event.askForRefugee', mdlData)

end

netstream.Hook('dbg-event.askForRefugee', function(ply, userSkin, userBgs)

	if not ply.pendingRefugee then return end
	local callback, check = unpack(ply.pendingRefugee)
	ply.pendingRefugee = nil
	if not userSkin then return callback(false) end

	local mdlData = getMdlData(ply)
	if not mdlData then return callback(false) end
	local skin, bgs = octolib.models.getValidSelection(getMdlData(ply), userSkin, userBgs)
	if check(ply, skin, bgs) == false then return callback(false) end

	ply:SetModel(mdlData.model)
	ply:SetSkin(skin)
	for _, v in ipairs(ply:GetBodyGroups()) do
		ply:SetBodygroup(v.id, bgs[v.id] or 0)
	end
	callback(true)

end)

concommand.Add('dbg_makerefugee', function(ply, _, args)

	if not ply:IsAdmin() then return end

	local tgt = player.GetBySteamID(table.concat(args, ''):gsub(' ', ''))
	if IsValid(tgt) then
		EventMakeRefugee(tgt)
	end

end)
