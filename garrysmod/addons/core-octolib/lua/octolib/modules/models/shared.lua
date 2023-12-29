octolib.models = octolib.models or {}

local additionalFemaleModels = octolib.array.toKeys({
	'medic_01_f.mdl',
	'medic_02_f.mdl',
	'medic_03_f.mdl',
	'medic_04_f.mdl',
	'medic_05_f.mdl',
	'medic_06_f.mdl',
})

function octolib.models.isMale(mdl)
	if additionalFemaleModels[mdl:gsub('.+%/', '')] then return false end

	return not mdl:find('female')
end

local Entity = FindMetaTable 'Entity'

function Entity:IsMale()
	return octolib.models.isMale(self:GetModel())
end