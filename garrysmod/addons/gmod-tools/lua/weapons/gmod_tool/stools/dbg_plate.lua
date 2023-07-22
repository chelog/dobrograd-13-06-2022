TOOL.Category = 'Dobrograd'
TOOL.Name = 'Автомобильные знаки'
TOOL.Command = nil

TOOL.Information = {
	{ name = 'left' },
	{ name = 'right' },
}

local vars = {
	txt = 'SPAWNED',
	colBG = Color(255,255,255),
	colBorder = Color(40,40,40),
	colTitle = Color(40,40,40),
	colTxt = Color(0,0,0),
}

if CLIENT then
	for k, v in pairs(vars) do
		octolib.vars.init('tools.dbg_plate.' .. k, v)
	end
end

local varList = octolib.table.map(table.GetKeys(vars), function(v) return 'tools.dbg_plate.' .. v end)

local function doEffect(ent)

	local e = EffectData()
	e:SetEntity(ent)
	e:SetScale(1)
	util.Effect('sparkling_ent', e)

end

function TOOL:LeftClick(tr)

	local ent = tr.Entity
	if not IsValid(ent) or ent:GetClass() ~= 'gmod_sent_vehicle_fphysics_base' or not self:GetOwner():query('DBG: Изменять автомобили') then return false end

	if SERVER then
		self:GetOwner():GetClientVar(varList, function(vars)
			ent:SetNetVar('cd.plate', vars['tools.dbg_plate.txt'] or '')
			ent:SetNetVar('cd.plateCol', {
				vars['tools.dbg_plate.colBG'] or Color(255,255,255),
				vars['tools.dbg_plate.colBorder'] or Color(40,40,40),
				vars['tools.dbg_plate.colTitle'] or Color(255,255,255),
				vars['tools.dbg_plate.colTxt'] or Color(0,0,0),
			})
		end)
	else
		doEffect(ent)
	end

	return true

end

function TOOL:RightClick(tr)

	local ent = tr.Entity
	if not IsValid(ent) or ent:GetClass() ~= 'gmod_sent_vehicle_fphysics_base' or not self:GetOwner():query('DBG: Изменять автомобили') then return false end

	if SERVER then
		ent:SetNetVar('cd.plate', false)
		ent:SetNetVar('cd.plateCol', nil)
	else
		doEffect(ent)
	end

	return true

end

function TOOL:BuildCPanel()

	octolib.vars.textEntry(self, 'tools.dbg_plate.txt', 'Текст')
	octolib.vars.colorPicker(self, 'tools.dbg_plate.colBG', 'Цвет фона', true, true)
	octolib.vars.colorPicker(self, 'tools.dbg_plate.colBorder', 'Цвет рамки', true, true)
	octolib.vars.colorPicker(self, 'tools.dbg_plate.colTitle', 'Цвет заголовка', true, true)
	octolib.vars.colorPicker(self, 'tools.dbg_plate.colTxt', 'Цвет текста', true, true)

	-- fuck DForm
	for _, pnl in ipairs(self:GetChildren()) do
		pnl:DockPadding(10, 0, 10, 0)
	end

end

if CLIENT then
	language.Add('Tool.dbg_plate.name', 'Знаки')
	language.Add('Tool.dbg_plate.desc', 'Меняем знаки на автомобилях')
	language.Add('Tool.dbg_plate.left', 'Установить знаки')
	language.Add('Tool.dbg_plate.right', 'Убрать знаки')
end
