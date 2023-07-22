local GAMEMODE = GM or GAMEMODE

-- check functions
local function dobrojob( ply )
	return ply:GetNetVar('os_dobro') == true, L.jobs_only_dobro
end

local function adminjob( ply )
	return ply:IsAdmin()
end

local function timed(hours)
	return function(ply)
		return CFG.dev or ply:GetTimeTotal() > 60 * 60 * hours, L.you_need_more_hours:format(hours)
	end
end

local function karma(val)
	return function(ply)
		return ply:GetKarma() >= val, 'У тебя слишком низкая карма'
	end
end

local function customJob()
	return false
end

local function cantJoinPolice(ply)
	return false, ply:getJobTable().hobo and L.hobo_cant_work or L.job_notallow
end

--
-- The list itself
--

TEAM_CITIZEN = DarkRP.createJob(L.citizen, {
	admin = 0,
	-- allowedWeapons = { 'blunt', 'sharp', 'pistols', 'smgs', 'rifles', 'snipers', 'shotguns', 'grenades' }
	candemote = false,
	category = 'Citizens',
	color = Color(76, 175, 80, 255),
	command = 'citizen',
	hasLicense = false,
	icon = 'user',
	max = 0,
	salary = GAMEMODE.Config.normalsalary,
	vote = false,
	weapons = {},
})

TEAM_CITIZEN2 = DarkRP.createJob(L.citizen2, {
	admin = 0,
	candemote = false,
	category = 'Citizens',
	color = Color(76, 175, 80, 255),
	command = 'citizen2',
	customCheck = dobrojob,
	hasLicense = false,
	icon = 'user_gray',
	max = 0,
	salary = GAMEMODE.Config.normalsalary,
	vote = false,
	weapons = {'gmod_camera', 'weapon_flashlight'},
})

TEAM_COOK = DarkRP.createJob(L.cooker, {
	admin = 0,
	-- allowedWeapons = { 'blunt', 'sharp' },
	canJoinPolice = cantJoinPolice,
	color = Color(229, 57, 53, 255),
	command = 'cook',
	cook = true,
	displayAs = 'citizen',
	hasLicense = false,
	icon = 'user_cook',
	max = 0.2,
	salary = GAMEMODE.Config.normalsalary * 1.85,
	vote = false,
	weapons = {},
	clothes = {
		'models/humans/modern/octo/cook1_sheet',
		'models/humans/modern/octo/cook2_sheet',
	},
})

TEAM_GUN = DarkRP.createJob(L.gunsmith, {
	admin = 0,
	canDestruct = true,
	canJoinPolice = cantJoinPolice,
	color = Color(251, 140, 0, 255),
	command = 'gun',
	customCheck = timed(5),
	displayAs = 'citizen',
	hasLicense = false,
	seesLicense = true,
	icon = 'gun',
	max = 0.15,
	salary = GAMEMODE.Config.normalsalary * 1.45,
	vote = false,
	weapons = {},
})

TEAM_GUN2 = DarkRP.createJob(L.gunsmith2, {
	admin = 0,
	canDestruct = true,
	canJoinPolice = cantJoinPolice,
	color = Color(245, 124, 0, 255),
	command = 'gun2',
	customCheck = dobrojob,
	displayAs = 'citizen',
	hasLicense = true,
	seesLicense = true,
	icon = 'gun',
	max = 0.1,
	salary = GAMEMODE.Config.normalsalary * 1.55,
	vote = false,
	weapons = {},
})

TEAM_MECH = DarkRP.createJob(L.mechanic, {
	admin = 0,
	color = Color(251, 140, 0, 255),
	command = 'mech',
	hasLicense = false,
	icon = 'wrench_orange',
	max = 0.05,
	mech = true,
	salary = GAMEMODE.Config.normalsalary * 1.45,
	vote = false,
	weapons = {},
	clothes = {
		'models/humans/modern/octo/work1_sheet',
		'models/humans/modern/octo/work2_sheet',
		'models/humans/modern/octo/work3_sheet',
		'models/humans/modern/octo/work4_sheet',
		'models/humans/modern/octo/work5_sheet',
		'models/humans/modern/octo/work6_sheet',
	},
})

TEAM_WORKER = DarkRP.createJob(L.worker, {
	admin = 0,
	canDestruct = true,
	canJoinPolice = cantJoinPolice,
	color = Color(251, 140, 0, 255),
	command = 'worker',
	hasLicense = false,
	icon = 'wrench',
	max = 0.2,
	salary = GAMEMODE.Config.normalsalary * 0.25,
	vote = false,
	weapons = {},
	worker = true,
	clothes = {
		'models/humans/modern/octo/work1_sheet',
		'models/humans/modern/octo/work2_sheet',
		'models/humans/modern/octo/work3_sheet',
		'models/humans/modern/octo/work4_sheet',
		'models/humans/modern/octo/work7_sheet',
		'models/humans/modern/octo/work8_sheet',
	},
})

TEAM_CSD = DarkRP.createJob('Коммунальный работник', {
	admin = 0,
	canDestruct = true,
	canJoinPolice = cantJoinPolice,
	color = Color(251, 140, 0, 255),
	command = 'csd',
	hasLicense = false,
	icon = 'wrench',
	max = 0.2,
	salary = GAMEMODE.Config.normalsalary * 1.4,
	vote = false,
	noPreference = true,
	weapons = {
		'gmod_camera',
		'broom',
		'weapon_flashlight',
		'weapon_octo_axe',
		'weapon_octo_shovel',
	},
	worker = true,
	hasTalkie = true,
	clothes = {
		'models/humans/modern/octo/work1_sheet',
		'models/humans/modern/octo/work2_sheet',
		'models/humans/modern/octo/work3_sheet',
		'models/humans/modern/octo/work4_sheet',
		'models/humans/modern/octo/work7_sheet',
		'models/humans/modern/octo/work8_sheet',
	},
})

local pharmClothes = {
	'models/humans/modern/octo/medic1_sheet',
	'models/humans/modern/octo/medic2_sheet',
	'models/humans/modern/octo/medic3_sheet',
}

TEAM_PHARM = DarkRP.createJob(L.doctor, {
	admin = 0,
	-- allowedWeapons = {},
	canJoinPolice = cantJoinPolice,
	color = Color(38,166,154, 255),
	command = 'pharm',
	hasLicense = false,
	icon = 'pill',
	max = 0.05,
	medic = true,
	salary = GAMEMODE.Config.normalsalary * 1.55,
	vote = false,
	weapons = {},
	clothes = pharmClothes,
})

TEAM_PHARM2 = DarkRP.createJob(L.doctor2, {
	admin = 0.05,
	-- allowedWeapons = {},
	canJoinPolice = cantJoinPolice,
	color = Color(0, 150, 136, 255),
	command = 'pharm2',
	customCheck = dobrojob,
	hasLicense = false,
	icon = 'pill_add',
	max = 0.05,
	medic = true,
	salary = GAMEMODE.Config.normalsalary * 1.75,
	vote = false,
	weapons = {},
	clothes = pharmClothes,
})

TEAM_DOCTOR = DarkRP.createJob('Парамедик', {
	admin = 0,
	-- allowedWeapons = {'pistols'},
	color = Color(0, 150, 136, 255),
	command = 'paramedic',
	customCheck = customJob,
	ems = true,
	hasLicense = false,
	hasTalkie = true,
	icon = 'user_medical',
	max = 0,
	medic = true,
	noPreference = true,
	police = false,
	seesName = true,
	noCivilCars = true,
	salary = GAMEMODE.Config.normalsalary * 1.8,
	vote = false,
	weapons = {
		'med_kit',
		'weapon_flashlight',
	},
})

TEAM_CORONER = DarkRP.createJob('Коронер', {
	admin = 0,
	color = Color(61, 117, 111, 255),
	command = 'coroner',
	customCheck = customJob,
	ems = true,
	hasLicense = false,
	hasTalkie = true,
	icon = 'medical_record',
	max = 0,
	medic = true,
	maxHealAmount = 50,
	noPreference = true,
	police = false,
	seesName = true,
	seesCaliber = true,
	seesTime = true,
	noCivilCars = true,
	canZip = true,
	canPackCorpse = true,
	salary = GAMEMODE.Config.normalsalary * 1.8,
	vote = false,
	weapons = {
		'gmod_camera',
		'med_kit',
		'weapon_flashlight',
		'weapon_flashlight_uv',
	},
})

TEAM_PRIEST = DarkRP.createJob(L.priest, {
	admin = 0,
	-- allowedWeapons = { 'blunt', 'sharp' },
	canJoinPolice = cantJoinPolice,
	color = Color(33, 33, 33, 255),
	command = 'priest',
	customCheck = karma(-30),
	hasLicense = false,
	hearsGhosts = true,
	icon = 'user_priest',
	max = 0.05,
	salary = 0,
	seesGhosts = true,
	vote = false,
	weapons = {},
	clothes = {
		'models/humans/modern/octo/priest1_sheet',
	},
})

TEAM_FIREFIGHTER = DarkRP.createJob('Пожарный', {
	admin = 0,
	armor = 28,
	color = Color(63, 81, 181, 255),
	command = 'firefighter',
	customCheck = customJob,
	description = 'Борец с пожарами',
	hasLicense = false,
	hasTalkie = true,
	max = 0,
	medic = true,
	seesName = true,
	noCivilCars = true,
	movemods = { runmul = 1.01, laddermul = 1.3 },
	noPreference = true,
	OnPlayerChangedTeam = function(ply)
		ply:SetModel('models/player/portal/male_08_fireman.mdl')
	end,
	salary = GAMEMODE.Config.normalsalary * 1.8,
	vote = false,
	orgID = 'fire',
	weapons = {
		'weapon_flashlight',
		'med_kit',
		'weapon_octo_axe',
		'weapon_fire_hose',
	},
})

TEAM_BANK = DarkRP.createJob('Сотрудник банка', {
	admin = 0,
	ammo = {
		['pistol'] = 360,
		['SMG1'] = 150,
	},
	armor = 45,
	color = Color(0, 0, 100, 255),
	command = 'bank',
	customCheck = customJob,
	displayAs = 'citizen',
	hasLicense = true,
	hasTalkie = true,
	icon = 'money',
	max = 0,
	noPreference = true,
	canSearch = true,
	noKarmaDamagePenalty = true,
	salary = GAMEMODE.Config.normalsalary * 1.8,
	vote = false,
	candemote = false,
	weapons = {
		'weapon_flashlight',
		'weapon_octo_p228',
		'weapon_octo_m4a1',
		'weapon_octo_mp5',
		'weapon_cuff_police',
		'stunstick',
		'med_kit',
		'stungun',
	},
})

TEAM_PRISON = DarkRP.createJob('Сотрудник тюрьмы', {
	admin = 0,
	ammo = {
		['air'] = 400,
		['pistol'] = 180,
		['buckshot'] = 60,
		['sniper'] = 60,
		['SMG1'] = 360,
	},
	armor = 28,
	color = Color(0, 0, 100, 255),
	command = 'prison',
	customCheck = customJob,
	displayAs = 'citizen',
	hasLicense = true,
	hasTalkie = true,
	icon = 'user_police_england',
	max = 0,
	noPreference = true,
	police = true,
	canUnarrest = true,
	disabledKarma = true,
	salary = GAMEMODE.Config.normalsalary * 1.8,
	vote = false,
	candemote = false,
	noPBoard = true,
	weapons = {
		'weapon_flashlight',
		'weapon_octo_m4a1',
		'weapon_octo_beanbag',
		'weapon_cuff_police',
		'stunstick',
		'med_kit',
		'stungun',
		{'dbg_shield', 'models/bshields/rshield.mdl'},
	},
})

TEAM_DPD = DarkRP.createJob('DPD', {
	admin = 0,
	ammo = {
		['air'] = 400,
		['pistol'] = 180,
		['buckshot'] = 60,
		['sniper'] = 60,
		['SMG1'] = 360,
	},
	armor = 28,
	color = Color(57, 73, 171, 255),
	command = 'dpd',
	customName = true,
	displayAs = 'citizen',
	hasLicense = true,
	hasTalkie = true,
	icon = 'shield',
	max = 0,
	movemods = { runmul = 1.02, laddermul = 1.1 },
	noPBoard = true,
	noPreference = true,
	police = true,
	seesName = true,
	seesCaliber = true,
	canUnarrest = true,
	disabledKarma = true,
	salary = GAMEMODE.Config.normalsalary * 1.90,
	candemote = false,
	orgID = 'dpd',
	weapons = {
		'stunstick',
		'stungun',
		'weapon_flashlight',
		'weapon_octo_glock17',
		'weapon_cuff_police',
		'dbg_speedometer',
		'med_kit',
		'gmod_camera',
	},
})

TEAM_WCSO = DarkRP.createJob('Сотрудник офиса Шерифа', {
	admin = 0,
	ammo = {
		['air'] = 400,
		['pistol'] = 180,
		['buckshot'] = 60,
		['sniper'] = 60,
		['SMG1'] = 360,
	},
	armor = 40,
	color = Color(244, 81, 28, 255),
	command = 'wcso',
	customName = true,
	displayAs = 'citizen',
	hasLicense = true,
	hasTalkie = true,
	icon = 'sheriff',
	max = 0,
	movemods = { runmul = 1.02, laddermul = 1.1 },
	noPBoard = true,
	noPreference = true,
	police = true,
	seesName = true,
	seesCaliber = true,
	canUnarrest = true,
	disabledKarma = true,
	salary = GAMEMODE.Config.normalsalary * 1.90,
	candemote = false,
	orgID = 'wcso',
	weapons = {
		'stunstick',
		'stungun',
		'weapon_flashlight',
		'weapon_octo_glock17',
		'weapon_cuff_police',
		'med_kit',
		'gmod_camera',
	},
})

TEAM_FBI = DarkRP.createJob('FBI', {
	admin = 0,
	ammo = {
		['air'] = 400,
		['pistol'] = 180,
		['buckshot'] = 60,
		['sniper'] = 60,
		['SMG1'] = 360,
	},
	armor = 25,
	color = Color(57, 73, 171, 255),
	command = 'fbi',
	customName = true,
	displayAs = 'citizen',
	hasLicense = true,
	hasTalkie = true,
	icon = 'ceo',
	max = 0,
	movemods = { runmul = 1.06 },
	noPBoard = true,
	noPreference = true,
	police = true,
	canUnarrest = true,
	noKarmaDamagePenalty = true,
	salary = GAMEMODE.Config.normalsalary,
	vote = true,
	weapons = {
		'stungun',
		'weapon_flashlight',
		'weapon_octo_usp',
		'weapon_octo_mp5',
		'weapon_cuff_police',
		'gmod_camera',
	},
})

TEAM_MEDCOP = DarkRP.createJob(L.medcop, {
	admin = 0,
	allowedWeapons = {'blunt', 'sharp', 'pistols', 'smgs', 'shotguns'},
	ammo = {
		['pistol'] = 180,
	},
	armor = 28,
	color = Color(63, 81, 181, 255),
	command = 'medcop',
	customCheck = timed(25),
	displayAs = 'citizen',
	hasLicense = true,
	hasTalkie = true,
	icon = 'asterisk_yellow',
	max = 0,
	medic = true,
	maxHealAmount = 50,
	movemods = { runmul = 0.92, laddermul = 1.1 },
	noPreference = true,
	OnPlayerChangedTeam = function(ply)
		ply:SetSkin(1)
	end,
	police = true,
	noKarmaDamagePenalty = true,
	salary = GAMEMODE.Config.normalsalary * 1.90,
	vote = true,
	weapons = {
		'weapon_octo_glock17',
		'med_kit',
		'drug_scanner',
		'stunstick',
		'stungun',
		'weapon_flashlight',
		'weapon_cuff_police',
		'gmod_camera',
	},
})

TEAM_POLICE = DarkRP.createJob(L.officer, {
	admin = 0,
	allowedWeapons = {'blunt', 'sharp', 'pistols', 'smgs', 'rifles', 'snipers'},
	ammo = {
		['pistol'] = 180,
	},
	armor = 16,
	color = Color(57, 73, 171, 255),
	command = 'cop',
	customCheck = timed(25),
	displayAs = 'citizen',
	hasLicense = true,
	hasTalkie = true,
	icon = 'set_security_question',
	max = 0,
	movemods = { runmul = 1.05, laddermul = 1.1 },
	noPreference = true,
	OnPlayerChangedTeam = function(ply, oldTeam, newTeam)
		ply:SetSkin(1)
	end,
	police = true,
	noKarmaDamagePenalty = true,
	salary = GAMEMODE.Config.normalsalary * 1.80,
	slots = {'hat'},
	vote = true,
	weapons = {
		'weapon_octo_glock17',
		'stunstick',
		'dbg_speedometer',
		'stungun',
		'weapon_cuff_police',
		'weapon_flashlight',
	},
})

TEAM_TAXI = DarkRP.createJob('Таксист', {
	admin = 0,
	-- allowedWeapons = {'blunt', 'sharp', 'pistols'},
	candemote = false,
	color = Color(76, 175, 80, 255),
	command = 'taxi',
	hasTalkie = true,
	hasLicense = false,
	noPreference = true,
	candemote = false,
	icon = 'car_taxi',
	max = 0,
	salary = GAMEMODE.Config.normalsalary * 1.5,
	vote = false,
	weapons = {},
})

TEAM_RA = DarkRP.createJob('Работник склада', {
	admin = 0,
	-- allowedWeapons = {'blunt', 'sharp', 'pistols'},
	candemote = false,
	color = Color(81, 117, 56, 255),
	command = 'ra',
	customCheck = function(ply)
		return ply:GetNetVar('dbg-orgs.member', {}).ra, 'Для получения этой професии нужно состоять в организации "Richardson Atlantics"'
	end,
	hasLicense = false,
	hidden = true,
	icon = 'lorry',
	max = 0,
	salary = GAMEMODE.Config.normalsalary * 1,
	vote = false,
	weapons = {},
})

TEAM_ELSEC = DarkRP.createJob('Частный охранник', {
	admin = 0,
	ammo = {
		['pistol'] = 360,
		['SMG1'] = 150,
	},
	armor = 45,
	color = Color(0, 0, 100, 255),
	command = 'elsec',
	customCheck = customJob,
	description = [[Организация Elegant Security]],
	displayAs = 'citizen',
	hasLicense = true,
	hasTalkie = true,
	icon = 'lock',
	max = 0,
	noPBoard = true,
	noPreference = true,
	canSearch = true,
	noKarmaDamagePenalty = true,
	salary = GAMEMODE.Config.normalsalary * 1.8,
	vote = false,
	candemote = false,
	weapons = {
		'weapon_octo_p228',
		'weapon_octo_mp5',
		'weapon_cuff_police',
		'stungun',
	},
})

TEAM_ALPHA = DarkRP.createJob('Охранник Alpha', {
	admin = 0,
	ammo = {
		['pistol'] = 360,
		['SMG1'] = 150,
	},
	armor = 45,
	color = Color(0, 0, 100, 255),
	command = 'alpha',
	customCheck = customJob,
	description = [[Организация Alpha]],
	hasLicense = true,
	hasTalkie = true,
	icon = 'lock',
	max = 0,
	noPBoard = true,
	noPreference = true,
	canSearch = true,
	noKarmaDamagePenalty = true,
	salary = GAMEMODE.Config.normalsalary * 1.8,
	vote = false,
	candemote = false,
	orgID = 'alpha',
	weapons = {
		'weapon_octo_p228',
		'weapon_octo_ump45',
		'weapon_octo_m4a1',
		'weapon_cuff_police',
		'stungun',
		'stunstick',
		'weapon_flashlight',
	},
})

TEAM_POLICE2 = DarkRP.createJob(L.officer2, {
	admin = 0,
	allowedWeapons = {'blunt', 'sharp', 'pistols', 'smgs', 'shotguns', 'heavy'},
	ammo = {
		['pistol'] = 180,
		['buckshot'] = 60,
	},
	armor = 40,
	color = Color(48, 63, 159, 255),
	command = 'cop2',
	customCheck = dobrojob,
	displayAs = 'citizen',
	hasLicense = true,
	hasTalkie = true,
	icon = 'set_security_question',
	max = 0,
	movemods = { runmul = 0.85, laddermul = 1.1 },
	noPreference = true,
	OnPlayerChangedTeam = function(ply)
		ply:SetSkin(2)
	end,
	police = true,
	noKarmaDamagePenalty = true,
	canUnarrest = true,
	salary = GAMEMODE.Config.normalsalary * 1.80,
	vote = true,
	weapons = {
		'weapon_octo_glock17',
		'weapon_octo_m3',
		'stunstick',
		'dbg_speedometer',
		'stungun',
		'door_ram',
		'weapon_cuff_police',
		'weapon_flashlight',
		{'dbg_shield', 'models/bshields/rshield.mdl'},
	},
})

TEAM_CHIEF = DarkRP.createJob(L.chief, {
	admin = 0,
	ammo = {
		['pistol'] = 180,
		['SMG1'] = 360,
	},
	armor = 28,
	chief = true,
	color = Color(40, 53, 147, 255),
	command = 'chief',
	customCheck = timed(45),
	hasLicense = true,
	hasTalkie = true,
	icon = 'user_policeman_white',
	max = 1,
	movemods = { runmul = 0.92, laddermul = 1.1 },
	noPreference = true,
	OnPlayerChangedTeam = function(ply)
		ply:SetSkin(4)
	end,
	police = true,
	noKarmaDamagePenalty = true,
	canUnarrest = true,
	salary = GAMEMODE.Config.normalsalary * 2,
	vote = true,
	weapons = {
		'weapon_octo_glock17',
		'weapon_octo_m4a1',
		'stunstick',
		'dbg_speedometer',
		'stungun',
		'door_ram',
		'weapon_cuff_police',
		'weapon_flashlight',
		{'dbg_shield', 'models/bshields/rshield.mdl'},
	},
})

TEAM_MAYOR = DarkRP.createJob(L.mayor, {
	admin = 0,
	allowedWeapons = {'pistols'},
	color = Color(26, 35, 126, 255),
	command = 'mayor',
	customCheck = timed(60),
	hasLicense = true,
	hasTalkie = true,
	icon = 'star',
	max = 1,
	mayor = true,
	noPreference = true,
	police = true,
	noKarmaDamagePenalty = true,
	salary = GAMEMODE.Config.normalsalary * 3.1,
	vote = true,
	orgID = 'gov',
	weapons = {
		'weapon_flashlight',
	},
})

local hoboClothes = {
	'models/humans/modern/octo/hobo1_sheet',
	'models/humans/modern/octo/hobo2_sheet',
	'models/humans/modern/octo/hobo3_sheet',
	'models/humans/modern/octo/hobo4_sheet',
	'models/humans/modern/octo/hobo5_sheet',
	'models/humans/modern/octo/hobo6_sheet',
}

TEAM_HOBO = DarkRP.createJob(L.hobo, {
	admin = 0,
	allowedWeapons = { 'blunt', 'sharp' },
	candemote = false,
	canJoinPolice = cantJoinPolice,
	color = Color(158, 158, 158, 255),
	command = 'hobo',
	hasLicense = false,
	hobo = true,
	icon = 'bin_empty',
	max = 0,
	salary = 0,
	vote = false,
	weapons = {},
	clothes = hoboClothes,
})

TEAM_HOBO2 = DarkRP.createJob(L.hobo2, {
	admin = 0,
	allowedWeapons = { 'blunt', 'sharp' },
	candemote = false,
	canJoinPolice = cantJoinPolice,
	color = Color(117, 117, 117, 255),
	command = 'hobo2',
	customCheck = dobrojob,
	hasLicense = false,
	hobo = true,
	icon = 'bin',
	max = 0,
	salary = 0,
	vote = false,
	weapons = {'weapon_octo_bottle'},
	clothes = hoboClothes,
})

TEAM_K9 = DarkRP.createJob('K9', {
	admin = 0,
	allowedWeapons = { },
	candemote = false,
	color = Color(200, 123, 35),
	armor = 20,
	command = 'k9',
	customCheck = adminjob,
	icon = 'dog',
	max = 1,
	movemods = { runmul = 1.5, laddermul = 0, jumpmul = 0.75 },
	noPreference = true,
	OnPlayerChangedTeam = function(ply, oldTeam, newTeam)
		if not SERVER then return end
		octolib.request.send(ply, {
			{
				name = 'Кличка',
				desc = 'Собака должна иметь кличку. Как тебя звать, дружок?',
				type = 'strShort',
				default = L.dog_names[math.random(#L.dog_names)],
			}, {
				name = 'Нашивка',
				type = 'comboBox',
				opts = {
					{ 'Sheriff K-9', 0, true },
					{ 'Police', 1 },
					{ 'S.W.A.T.', 2 },
				},
			}
		}, function(data)
			if not IsValid(ply) then return end
			if not (istable(data) and isstring(data[1]) and isnumber(data[2]) and octolib.math.inRange(data[2], 0, 2)) then
				return ply:changeTeam(GAMEMODE.DefaultTeam, true, true)
			end

			local name = string.Trim(octolib.string.camel(octolib.string.stripNonWord(string.Replace(data[1], ' ', ''))))
			if name == '' then name = L.dog_names[math.random(#L.dog_names)] end
			ply:SetName(name)
			ply:SetModel('models/player/octo_doge/doge.mdl')
			ply:SetBodygroup(2, data[2])

			ply:StripWeapons()
			ply:Give('dbg_dog')
			ply:SetMaxHealth(50)
			ply:SetArmor(20)
			ply:SetNetVar('dbg-police.job', 'k9')
			ply:SetNetVar('sgGagged', true)

			local dbgLook = ply:GetNetVar('dbgLook')
			dbgLook.desc = nil
			ply:SetNetVar('dbgLook', dbgLook)
		end, function()
			if IsValid(ply) then ply:changeTeam(GAMEMODE.DefaultTeam, true, true) end
		end)
	end,
	OnPlayerChangedTeamFrom = function(ply)
		if not SERVER then return end
		timer.Simple(0, function()
			if IsValid(ply) and ply:GetModel() == 'models/player/octo_doge/doge.mdl' then
				ply:KillSilent()
				ply:SetNetVar('_SpawnTime', CurTime())
			end
		end)
		ply:SetMaxHealth(100)
		ply:SetNetVar('dbg-police.job')
		ply:SetNetVar('sgGagged')
	end,
	notHuman = true,
	noKarmaDamagePenalty = true,
	salary = 0,
	vote = true,
	weapons = { 'dbg_dog' },
})

TEAM_ADMIN = DarkRP.createJob(L.administrator, {
	admin = 1,
	candemote = false,
	color = Color(33, 33, 33, 255),
	command = 'adminjob',
	customCheck = adminjob,
	hasLicense = false,
	hasTalkie = true,
	hearsGhosts = true,
	icon = 'lightbulb',
	max = 0,
	noPreference = true,
	salary = GAMEMODE.Config.normalsalary * 2,
	canSearch = true,
	disabledKarma = true,
	canUnarrest = true,
	seesGhosts = true,
	vote = false,
	weapons = {'dbg_admingun', 'dbg_punisher', 'weapon_octo_deagle', 'gmod_camera', 'weapon_flashlight'},
})

--[[---------------------------------------------------------------------------
Define which team joining players spawn into and what team you change to if demoted
---------------------------------------------------------------------------]]
GAMEMODE.DefaultTeam = TEAM_CITIZEN

--[[---------------------------------------------------------------------------
Define which teams belong to civil protection
Civil protection can set warrants, make people wanted and do some other police related things
---------------------------------------------------------------------------]]
GAMEMODE.CivilProtection = {
	[TEAM_CHIEF] = true,
	[TEAM_DPD] = true,
	[TEAM_FBI] = true,
	[TEAM_MAYOR] = true,
	[TEAM_MEDCOP] = true,
	[TEAM_POLICE] = true,
	[TEAM_POLICE2] = true,
}
