carDealer.enabled = true
carDealer.cache = carDealer.cache or {
	owned = {},
	categories = {},
}

local function attachWheel(ent, mdlOrig, mdl, pos, ang, radius)

	local w = octolib.createDummy(mdlOrig)
	w:SetParent(ent)
	w:SetLocalPos(pos)
	w:SetLocalAngles(ang)
	w:SetNoDraw(true)
	ent.wheels[#ent.wheels + 1] = w

	if mdl ~= mdlOrig then
		local mins, maxs = w:GetRenderBounds()
		local origwheelsize = maxs - mins
		if not radius then
			radius = math.max(origwheelsize.x, origwheelsize.y, origwheelsize.z) * 0.5
		end

		w:SetModel(mdl)
		local mins, maxs = w:GetRenderBounds()
		local wheelsize = maxs - mins
		local size = (radius * 2) / math.max(wheelsize.x, wheelsize.y, wheelsize.z)
		w:SetModelScale(size)
	end

end

local function wheelAngle(members, data, model, right)
	local Forward = Vector(0, 1, 0)
	local Right = Vector(right and 1 or -1, 0, 0)
	local Up = Vector(0, 0, 1)
	if members.SpawnAngleOffset then
		local ang = Angle(0, members.SpawnAngleOffset, 0)
		Forward:Rotate(ang)
		Right:Rotate(ang)
		Up:Rotate(ang)
	end

	local angleoffset = members.CustomWheelAngleOffset
	local mirAng = right and 1 or -1
	local ang = Right:Angle()
	ang:RotateAroundAxis(Forward, angleoffset.p * mirAng)
	ang:RotateAroundAxis(Right, angleoffset.r * mirAng)
	ang:RotateAroundAxis(Up, 90)
	ang:RotateAroundAxis(Forward, (data.camber or 0) * mirAng)

	local add = simfphys.GetWheelAngle(model)
	if add then
		ang:RotateAroundAxis(Forward, add.p * mirAng)
		ang:RotateAroundAxis(Right, add.r * mirAng)
		ang:RotateAroundAxis(Up, -add.y)
	end

	return ang
end

function carDealer.attachWheels(ent, vehID, data)

	data = data or {}
	local cdData = carDealer.vehicles[vehID]
	if not cdData then return end

	local spData = list.Get('simfphys_vehicles')[cdData.simfphysID]
	assert(spData ~= nil, 'Wrong simfphysID for ' .. vehID)

	ent.wheels = {}
	local m = spData.Members
	local mdlOrigF, mdlOrigR = m.CustomWheelModel, m.CustomWheelModel_R or m.CustomWheelModel
	local mdlF, mdlR =
		data.rims and data.rims[1] or m.CustomWheelModel,
		data.rims and data.rims[2] or m.CustomWheelModel_R or m.CustomWheelModel

	if m.CustomWheelPosFL then
		attachWheel(ent, mdlOrigF, mdlF, m.CustomWheelPosFL - Vector(0, 0, m.FrontHeight / 4), wheelAngle(m, data, mdlF, false), m.FrontWheelRadius)
	end
	if m.CustomWheelPosFR then
		attachWheel(ent, mdlOrigF, mdlF, m.CustomWheelPosFR - Vector(0, 0, m.FrontHeight / 4), wheelAngle(m, data, mdlF, true), m.FrontWheelRadius)
	end
	if m.CustomWheelPosRL then
		attachWheel(ent, mdlOrigR, mdlR, m.CustomWheelPosRL - Vector(0, 0, m.RearHeight / 4), wheelAngle(m, data, mdlR, false), m.RearWheelRadius)
	end
	if m.CustomWheelPosRR then
		attachWheel(ent, mdlOrigR, mdlR, m.CustomWheelPosRR - Vector(0, 0, m.RearHeight / 4), wheelAngle(m, data, mdlR, true), m.RearWheelRadius)
	end

	ent:CallOnRemove('DeleteWheels', function(ent)
		if not ent.wheels then return end
		for _, w in ipairs(ent.wheels) do
			if IsValid(w) and w ~= NULL then w:Remove() end
		end
	end)

end

function carDealer.attachAccessories(ent, atts)

	ent.atts = {}

	for _, data in pairs(atts) do
		local attEnt = octolib.createDummy(data.model, data.rg)
		data.parent = ent
		octolib.applyEntData(attEnt, data)
		attEnt.col = data.col
		attEnt:SetNoDraw(true)
		ent.atts[#ent.atts + 1] = attEnt
	end

	ent:CallOnRemove('DeleteAttachments', function(ent)
		if not ent.atts then return end
		for _, a in ipairs(ent.atts) do
			if IsValid(a) and a ~= NULL then a:Remove() end
		end
	end)

end

netstream.Hook('car-dealer.sync', function(owned, categories)
	for id, veh in pairs(owned) do veh.id = id end
	carDealer.cache = {
		owned = owned,
		categories = categories,
	}

	hook.Run('car-dealer.sync', carDealer.cache)
end)

hook.Add('InitPostEntity', 'car-dealer', function()

	local atts = simfphys.attachments
	carDealer.canAttach = function(ent, att)
		if not att then return false end
		if not IsValid(ent) then return false end
		if not ent.vehicleName or not atts[att].cars[ent.vehicleName] then return false end

		local t = atts[att].type
		if not force and ent.atts and IsValid(ent.atts[t]) and ent.atts[t]:GetModel() == atts[att].mdl then
			return false
		end

		return true
	end
	carDealer.removeAttachment = function(ent, type)
		if ent.atts and IsValid(ent.atts[type]) and ent.atts[type] ~= NULL then
			ent.atts[type]:Remove()
			ent.atts[type] = nil
		end
	end
	carDealer.addAttachment = function(ent, att)
		if not carDealer.canAttach(ent, att) then return end

		local t = atts[att].type
		carDealer.removeAttachment(ent, t)

		local attData = atts[att].cars[ent.vehicleName]
		local attEnt = octolib.createDummy(atts[att].mdl)
		attEnt:SetParent(ent)
		attEnt:SetLocalPos(attData[1] or Vector())
		attEnt:SetLocalAngles(attData[2] or Angle())
		attEnt:SetModelScale(attData[3] or 1)
		attEnt:SetSkin(atts[att].skin or 0)
		attEnt.attClass = att
		attEnt.noPaint = atts[att].noPaint
		if not attEnt.noPaint then attEnt:SetColor(ent:GetColor()) end
		attEnt:SetNoDraw(true)

		ent.atts = ent.atts or {}
		ent.atts[t] = attEnt
	end

end)

hook.Add('octogui.f4-tabs', 'car-dealer', function()

	octogui.addToF4({
		order = 11.6,
		id = 'dealer',
		name = 'Гараж',
		icon = Material('octoteam/icons/car2.png'),
		build = function(f)
			f:SetSize(800, 600)
			f:DockPadding(0, 24, 0, 0)
			f:Center()

			local br = f:Add 'DButton'
			br:SetPos(700, 2)
			br:SetSize(60, 20)
			br:SetText('Обновить')
			function br:DoClick()
				netstream.Start('car-dealer.sync')
			end

			f:Add 'cd_menu'
			netstream.Start('car-dealer.sync')
		end,
		show = function(f, st)
			carDealer.menu:SetMinimized(not st)
		end
	})

end)

surface.CreateFont('car-dealer.plate', {
	font = 'License Plate',
	size = 64,
	weight = 500,
	antialias = true,
	extended = true,
})

local function roundVector(pos, decimals)
	local float = '%.' .. decimals .. 'f'
	return table.concat({'(',float,', ',float,', ',float,')'}, ''):format(pos.x, pos.y, pos.z)
end
local function roundAngle(ang, decimals)
	local float = '%.' .. decimals .. 'f'
	return table.concat({'[',float,', ',float,', ',float,']'}, ''):format(ang.p, ang.y, ang.r)
end

hook.Add('octolib.configLoaded', 'car-dealer', function()
	if not CFG.dev then return end

	concommand.Add('car_setup', function()
		local seat = LocalPlayer():GetVehicle()
		local car = IsValid(seat) and seat:GetParent()
		if not IsValid(car) then return octolib.notify.show('warning', 'Нужно находиться в автомобиле') end

		local radius = car:GetModelRadius()
		octolib.flyEditor.start({
			parent = car,
			props = {
				{
					name = 'Передний номер',
					model = 'models/octoteam/vehicles/attachments/licenceplate_01.mdl',
					pos = Vector(radius, 0, 0),
					ang = Angle(0, 0, 0),
				}, {
					name = 'Задний номер',
					model = 'models/octoteam/vehicles/attachments/licenceplate_01.mdl',
					pos = Vector(-radius, 0, 0),
					ang = Angle(0, 180, 0),
				}, {
					name = 'Приборная панель',
					model = 'models/props_c17/gravestone_coffinpiece001a.mdl',
					pos = Vector(0, radius / 8, radius / 8),
					ang = Angle(0, -90, 90),
					size = Vector(0.096, 0.07, 0.0015),
				}, {
					name = 'Зеркало в салоне',
					model = 'models/props/cs_italy/orange.mdl',
					pos = Vector(radius / 2, 0, radius / 4),
					ang = Angle(0, 0, 0),
				}, {
					name = 'Левое зеркало',
					model = 'models/props/cs_italy/orange.mdl',
					pos = Vector(0, radius / 2, 0),
					ang = Angle(0, 0, 0),
				}, {
					name = 'Правое зеркало',
					model = 'models/props/cs_italy/orange.mdl',
					pos = Vector(0, -radius / 2, 0),
					ang = Angle(0, 0, 0),
				}, {
					name = 'Радио',
					model = 'models/props_lab/reciever01d.mdl',
					pos = Vector(0, 0, 0),
					ang = Angle(0, 180, 0),
				},
			},

			space = octolib.flyEditor.SPACE_PARENT,
			vPos = vPos,
			vAng = vAng,
			maxDist = 500,
			anchorEnt = car,
			noCopy = true,
			noRemove = true,
		}, function(data)
			local fPlate, rPlate, dash, mMirror, lMirror, rMirror, radio = unpack(data)
			chat.AddText('---')
			chat.AddText('Автомобиль: ' .. car:GetSpawn_List())
			chat.AddText('Передний номер: ' .. roundVector(fPlate.pos, 3) .. roundAngle(fPlate.ang, 1))
			chat.AddText('Задний номер: ' .. roundVector(rPlate.pos, 3) .. roundAngle(rPlate.ang, 1))
			chat.AddText('Приборная панель: ' .. roundVector(dash.pos, 3) .. roundAngle(dash.ang, 1))
			chat.AddText('Зеркало в салоне: ' .. roundVector(mMirror.pos, 3))
			chat.AddText('Левое зеркало: ' .. roundVector(lMirror.pos, 3))
			chat.AddText('Правое зеркало: ' .. roundVector(rMirror.pos, 3))
			chat.AddText('Радио: ' .. roundVector(radio.pos, 3) .. roundAngle(radio.ang, 1))
		end)
	end)
end)
