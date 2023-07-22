surface.CreateFont('car-dealer.view.title', {
	font = 'Calibri',
	size = 56,
	weight = 500,
	antialias = true,
	extended = true,
})

surface.CreateFont('car-dealer.view.subtitle', {
	font = 'Calibri',
	size = 28,
	weight = 500,
	antialias = true,
	extended = true,
})

surface.CreateFont('car-dealer.view.subtitle-plate', {
	font = 'Plat Nomor',
	size = 24,
	weight = 500,
	antialias = true,
	extended = true,
})

local function getTrunkSize(simfphysID, ent)
	local spData = list.Get('simfphys_vehicles')[simfphysID]
	if not spData then return end

	local trunkData = spData.Members.Trunk
	if not trunkData then return end

	for i = 2, #trunkData do
		if not istable(trunkData[i]) then break end
		local volume, bgID, bgVal = unpack(trunkData[i])
		if ent:GetBodygroup(bgID) == bgVal then
			return volume
		end
	end

	return trunkData[1]
end

local PANEL = {}

function PANEL:Init()

	self:Dock(FILL)

	local mdl = self:Add 'cd_vehModel'
	mdl:Dock(FILL)
	mdl.canControl = true
	mdl.camOffset = Vector(60, 0, 0)
	mdl.camPos = Vector(300, 400, 75)
	mdl.fovMultiplier = 0.9
	self.mdl = mdl

	local mats = cdData and cdData.default.mats or {}
	for k, v in pairs(mats) do
		self.mdl:SetSubMaterial(k-1, v)
	end

	local mdlButs = mdl:Add 'DPanel'
	mdlButs:Dock(BOTTOM)
	mdlButs:DockMargin(10, 0, 0, 10)
	mdlButs:SetTall(32)
	mdlButs:SetPaintBackground(false)
	self.mdlButs = mdlButs

	local title = self:Add 'DLabel'
	title:SetFont('car-dealer.view.title')
	title:SetText('Выбери машину внизу')
	self.title = title

	-- local tags = mdl:Add 'DPanel'
	-- tags:SetPaintBackground(false)
	-- tags:SetTall(16)
	-- self.tags = tags

	local health = self:Add 'DProgressLabel'
	health:SetWide(200)
	self.statusHealth = health

	local fuel = self:Add 'DProgressLabel'
	fuel:SetWide(200)
	self.statusFuel = fuel

	local subtitle = self:Add 'DLabel'
	subtitle:SetFont('car-dealer.view.subtitle')
	subtitle:SetText('')
	self.subtitle = subtitle

	local mass = self:Add 'DProgressLabel'
	mass:SetWide(200)
	mass.max = octolib.table.reduce(carDealer.vehicles, function(a, cdData)
		return math.max(a, list.Get('simfphys_vehicles')[cdData.simfphysID].Members.Mass)
	end, 0)
	self.mass = mass

	local grip = self:Add 'DProgressLabel'
	grip:SetWide(200)
	grip.max = octolib.table.reduce(carDealer.vehicles, function(a, cdData)
		return math.max(a, list.Get('simfphys_vehicles')[cdData.simfphysID].Members.MaxGrip)
	end, 0)
	self.grip = grip

	local torque = self:Add 'DProgressLabel'
	torque:SetWide(200)
	torque.max = octolib.table.reduce(carDealer.vehicles, function(a, cdData)
		return math.max(a, list.Get('simfphys_vehicles')[cdData.simfphysID].Members.PeakTorque)
	end, 0)
	self.torque = torque

	local steerSpeed = self:Add 'DProgressLabel'
	steerSpeed:SetWide(200)
	steerSpeed.max = octolib.table.reduce(carDealer.vehicles, function(a, cdData)
		return math.max(a, list.Get('simfphys_vehicles')[cdData.simfphysID].Members.TurnSpeed)
	end, 0)
	self.steerSpeed = steerSpeed

	local fuel = self:Add 'DProgressLabel'
	fuel:SetWide(200)
	fuel.max = octolib.table.reduce(carDealer.vehicles, function(a, cdData)
		return math.max(a, list.Get('simfphys_vehicles')[cdData.simfphysID].Members.FuelTankSize)
	end, 0)
	self.fuel = fuel

	local lv = self:Add 'DListView'
	lv:SetWide(200)
	lv:AddColumn('Параметр')
	lv:AddColumn('Значение')
	lv:SetHideHeaders(true)
	lv:SetTall(200)
	self.lv = lv

	local buts = self:Add 'DPanel'
	buts:SetPaintBackground(false)
	buts:SetSize(200, 200)
	self.buts = buts

end

function PANEL:PerformLayout()

	local y = 10

	local title = self.title
	title:SizeToContents()
	title:AlignRight(15)
	title:AlignTop(10)
	y = y + title:GetTall()

	-- local tags = self.tags
	-- tags:SetSize(100, 16)
	-- tags:AlignTop(35)
	-- tags:AlignRight(title:GetWide() + 30)

	local subtitle = self.subtitle
	if subtitle:GetText() ~= '' then
		subtitle:SizeToContents()
		subtitle:AlignRight(15)
		subtitle:SetPos(subtitle:GetPos(), y - 5)
		y = y + subtitle:GetTall() + 5
	end

	if self.vehData and self.vehData.id then
		self.mass:SetVisible(false)
		self.fuel:SetVisible(false)
		self.torque:SetVisible(false)
		self.grip:SetVisible(false)
		self.steerSpeed:SetVisible(false)
		self.lv:SetVisible(false)

		local health = self.statusHealth
		health:SetVisible(true)
		health:AlignRight(15)
		health:SetPos(health:GetPos(), y)
		y = y + health:GetTall() + 2

		local fuel = self.statusFuel
		fuel:SetVisible(true)
		fuel:AlignRight(15)
		fuel:SetPos(fuel:GetPos(), y)
		y = y + fuel:GetTall() + 15
	else
		self.statusHealth:SetVisible(false)
		self.statusFuel:SetVisible(false)

		local mass = self.mass
		mass:SetVisible(true)
		mass:AlignRight(15)
		mass:SetPos(mass:GetPos(), y)
		y = y + mass:GetTall() + 2

		local fuel = self.fuel
		fuel:SetVisible(true)
		fuel:AlignRight(15)
		fuel:SetPos(fuel:GetPos(), y)
		y = y + fuel:GetTall() + 5

		local torque = self.torque
		torque:SetVisible(true)
		torque:AlignRight(15)
		torque:SetPos(torque:GetPos(), y)
		y = y + torque:GetTall() + 2

		local grip = self.grip
		grip:SetVisible(true)
		grip:AlignRight(15)
		grip:SetPos(grip:GetPos(), y)
		y = y + grip:GetTall() + 2

		local steerSpeed = self.steerSpeed
		steerSpeed:SetVisible(true)
		steerSpeed:AlignRight(15)
		steerSpeed:SetPos(steerSpeed:GetPos(), y)
		y = y + steerSpeed:GetTall() + 2

		local lv = self.lv
		lv:SetVisible(true)
		lv:AlignRight(15)
		lv:SetPos(lv:GetPos(), y)
		y = y + lv:GetTall() + 2
	end

	local buts = self.buts
	buts:AlignRight(15)
	buts:AlignBottom(15)

end

function PANEL:DelayedRefresh()

	timer.Simple(0.5, function()
		self:Refresh()
	end)

end

function PANEL:SetVehicle(class, data)

	data = data or {}
	data.data = data.data or {}

	local cdData = carDealer.vehicles[class]
	if not cdData then return end

	local catData = carDealer.categories[cdData.category]
	if not catData then return end

	self.class = class
	self.vehData = data

	local spData = list.Get('simfphys_vehicles')[cdData.simfphysID]
	assert(spData ~= nil, 'Wrong simfphysID for ' .. class)

	local m = spData.Members
	local price = hook.Run('car-dealer.priceOverride', LocalPlayer(), class) or cdData.price

	self.mdl:SetVehicle(class, data)
	self.title:SetText(cdData.name)
	self.subtitle:SetText(data.plate or DarkRP.formatMoney(price))
	self.subtitle:SetFont(data.plate and 'car-dealer.view.subtitle-plate' or 'car-dealer.view.subtitle')

	if data.id then
		local status = data.data
		self.statusHealth:SetFraction(status.health or 1)
		self.statusHealth:SetText('Исправность: ' .. math.Round((status.health or 1) * 100, 0) .. '%')

		local liters = math.Round((status.fuel or 1) * m.FuelTankSize, 1)
		self.statusFuel:SetFraction(status.fuel or 1)
		self.statusFuel:SetText('В баке: ' .. liters .. 'л')
	end

	self.mass:SetFraction(m.Mass / self.mass.max)
	self.mass:SetText('Масса: ' .. math.floor(m.Mass * 0.75) .. 'кг')
	self.fuel:SetFraction(m.FuelTankSize / self.fuel.max)
	self.fuel:SetText('Объем бака: ' .. m.FuelTankSize .. 'л')
	self.torque:SetFraction(m.PeakTorque / self.torque.max)
	self.torque:SetText('Мощность двигателя')
	self.grip:SetFraction(m.MaxGrip / self.grip.max)
	self.grip:SetText('Сцепление с дорогой')
	self.steerSpeed:SetFraction(m.TurnSpeed / self.steerSpeed.max)
	self.steerSpeed:SetText('Скорость поворота')

	local lv = self.lv
	lv:Clear()
	lv:AddLine('Тип топлива', m.FuelType == FUELTYPE_DIESEL and 'Дизель' or 'Бензин')
	lv:AddLine('Привод', m.PowerBias > 0.5 and 'Задний' or m.PowerBias < -0.5 and 'Передний' or 'Полный')
	lv:AddLine('Угол поворота', m.CustomSteerAngle .. '°')
	lv:AddLine('Мест', #(m.PassengerSeats or {}) + 1)

	local trunk = getTrunkSize(cdData.simfphysID, self.mdl.Entity)
	local trunkLine = lv:AddLine('Багажник', trunk and (trunk .. 'л') or 'Нет')

	local function setBodygroup(bgID, bgVal)
		self.mdl.Entity:SetBodygroup(bgID, bgVal)

		local trunk = getTrunkSize(cdData.simfphysID, self.mdl.Entity)
		trunkLine:SetColumnText(2, trunk and (trunk .. 'л') or 'Нет')
	end

	self.mdlButs:Clear()
	local lData = list.Get('simfphys_lights')[m.LightsTable or '']
	if lData and lData.SubMaterials then
		local mats = lData.SubMaterials

		local headLightMode = 0
		local lightMode = 'Base'
		local function updateSubMats()
			local t
			if headLightMode == 0 then
				t = mats.off[lightMode] or mats.off.Base
			elseif headLightMode == 1 then
				t = mats.on_lowbeam[lightMode] or mats.on_lowbeam.Base
			elseif headLightMode == 2 then
				t = mats.on_highbeam[lightMode] or mats.on_highbeam.Base
			end
			for k, v in pairs(t) do
				self.mdl.Entity:SetSubMaterial(k, v)
			end
		end

		local butLights = self.mdlButs:Add 'DImageButton'
		butLights:Dock(LEFT)
		butLights:DockMargin(0, 0, 5, 0)
		butLights:SetWide(32)
		butLights:SetIcon('octoteam/icons-car/light_close.png')
		butLights:SetAlpha(100)
		butLights:AddHint('Переключить фары')
		local ppTarget = 0
		function butLights.DoClick()
			headLightMode = octolib.math.loop(headLightMode + 1, 0, 3)
			if headLightMode == 0 then
				butLights:SetIcon('octoteam/icons-car/light_close.png')
				butLights:SetAlpha(100)
				ppTarget = 0
			elseif headLightMode == 1 then
				butLights:SetIcon('octoteam/icons-car/light_close.png')
				butLights:SetAlpha(255)
				ppTarget = 1
			elseif headLightMode == 2 then
				butLights:SetIcon('octoteam/icons-car/light_far.png')
				butLights:SetAlpha(255)
				ppTarget = 1
			end
			updateSubMats()
		end
		if lData.PoseParameters then
			local curState = 0
			function butLights.Think()
				curState = math.Approach(curState, ppTarget, FrameTime() * 2)
				self.mdl.Entity:SetPoseParameter(lData.PoseParameters.name, curState)
			end
		end

		local butBrake = self.mdlButs:Add 'DImageButton'
		butBrake:Dock(LEFT)
		butBrake:DockMargin(0, 0, 5, 0)
		butBrake:SetWide(32)
		butBrake:AddHint('Переключить тормоз')
		butBrake:SetIcon('octoteam/icons-car/brake.png')
		butBrake:SetAlpha(100)
		butBrake.on = false
		function butBrake.DoClick()
			butBrake.on = not butBrake.on
			butBrake:SetAlpha(butBrake.on and 255 or 100)
			if butBrake.on then
				if lightMode == 'Base' then
					lightMode = 'Brake'
				elseif lightMode == 'Reverse' then
					lightMode = 'Brake_Reverse'
				end
			else
				if lightMode == 'Brake' then
					lightMode = 'Base'
				elseif lightMode == 'Brake_Reverse' then
					lightMode = 'Reverse'
				end
			end
			updateSubMats()
		end

		local butReverse = self.mdlButs:Add 'DImageButton'
		butReverse:Dock(LEFT)
		butReverse:DockMargin(0, 0, 5, 0)
		butReverse:SetWide(32)
		butReverse:AddHint('Переключить реверс')
		butReverse:SetIcon('octoteam/icons-car/left_3.png')
		butReverse:SetAlpha(100)
		butReverse.on = false
		function butReverse.DoClick()
			butReverse.on = not butReverse.on
			butReverse:SetAlpha(butReverse.on and 255 or 100)
			if butReverse.on then
				if lightMode == 'Base' then
					lightMode = 'Reverse'
				elseif lightMode == 'Brake' then
					lightMode = 'Brake_Reverse'
				end
			else
				if lightMode == 'Reverse' then
					lightMode = 'Base'
				elseif lightMode == 'Brake_Reverse' then
					lightMode = 'Brake'
				end
			end
			updateSubMats()
		end

		if mats.turnsignals then
			local butTurn = self.mdlButs:Add 'DImageButton'
			butTurn:Dock(LEFT)
			butTurn:DockMargin(0, 0, 5, 0)
			butTurn:SetWide(32)
			butTurn:AddHint('Переключить фары')
			butTurn:SetIcon('octoteam/icons-car/alarm.png')
			butTurn:SetAlpha(100)
			butTurn.on = false
			butTurn.curState = false
			function butTurn.DoClick()
				butTurn.on = not butTurn.on
				butTurn:SetAlpha(butTurn.on and 255 or 100)
				if not butTurn.on then
					for k in pairs(mats.turnsignals.left) do self.mdl.Entity:SetSubMaterial(k, '') end
					for k in pairs(mats.turnsignals.right) do self.mdl.Entity:SetSubMaterial(k, '') end
					butTurn.curState = false
				end
			end
			function butTurn.Think()
				local ct = CurTime()
				if not butTurn.on or ct < (butTurn.nextToggle or 0) then return end

				butTurn.curState = not butTurn.curState
				for k, v in pairs(mats.turnsignals.left) do self.mdl.Entity:SetSubMaterial(k, butTurn.curState and v or '') end
				for k, v in pairs(mats.turnsignals.right) do self.mdl.Entity:SetSubMaterial(k, butTurn.curState and v or '') end
				butTurn.nextToggle = ct + 0.5
			end
		end
	end


	-- self.tags:Clear()
	-- local tags = table.Copy(cdData.tags or {})
	-- hook.Run('car-dealer.populateTags', class, cdData, tags)
	-- for _, tag in ipairs(tags) do
	-- 	if not data.id or tag[3] then
	-- 		local icon = self.tags:Add 'DImageButton'
	-- 		icon:Dock(RIGHT)
	-- 		icon:DockMargin(5, 0, 0, 0)
	-- 		icon:SetWide(16)
	-- 		icon:SetImage(tag[1])
	-- 		icon:AddOctoHint(tag[2])
	-- 	end
	-- end

	self:InvalidateLayout(true)

	self.buts:Clear()
	local ply = LocalPlayer()
	local veh = carDealer.getCurVeh(ply)
	local q = ply:GetLocalVar('car-dealer.queued')
	if not data.id and not cdData.deposit then
		local bgs = {}
		local bgPrices = {}

		local bBuy = self.buts:Add 'DButton'
		bBuy:Dock(BOTTOM)
		bBuy:DockMargin(0, 5, 0, 0)
		bBuy:SetTall(25)
		bBuy:SetIcon('icon16/money.png')
		bBuy:SetText('Купить')
		bBuy.DoClick = function()
			local priceTotal = octolib.table.reduce(bgPrices, function(a, v) return a + v end, price)
			local text = ('Ты уверен, что хочешь купить %s за %s?')
				:format(cdData.name or 'Автомобиль', carDealer.formatMoney(priceTotal))

			Derma_Query(text, 'Купить автомобиль', 'Да', function()
				bBuy:SetEnabled(false)
				netstream.Request('car-dealer.buy', class, bgs):Then(function(ok)
					if not ok then return end
					carDealer.menu.list:SwitchToName('Мой гараж')
				end):Finally(function()
					if IsValid(bBuy) then bBuy:SetEnabled(true) end
				end)
			end, 'Нет')
		end

		if cdData.bodygroups then
			local bOptions = self.buts:Add 'DButton'
			bOptions:Dock(BOTTOM)
			bOptions:DockMargin(0, 5, 0, 0)
			bOptions:SetTall(25)
			bOptions:SetIcon('icon16/cog.png')
			bOptions:SetText('Конфигурация')
			bOptions.DoClick = function()
				local m = DermaMenu()
				for bgID, group in pairs(cdData.bodygroups) do
					local sm = m:AddSubMenu(group.name)
					for val, variant in pairs(group.variants) do
						local bgVal = val - 1
						local originalVal = cdData.default and cdData.default.bg and cdData.default.bg[bgID] or 0
						local isOriginal = bgVal == originalVal
						local variantName, variantPrice = unpack(variant)
						local o = sm:AddOption(isOriginal and variantName or ('%s (+%s)'):format(variantName, carDealer.formatMoney(variantPrice)), function()
							setBodygroup(bgID, bgVal)
							bgs[bgID] = not isOriginal and bgVal or nil
							bgPrices[bgID] = not isOriginal and variantPrice or nil

							self.subtitle:SetText(carDealer.formatMoney(octolib.table.reduce(bgPrices, function(a, v) return a + v end, price)))
							self:InvalidateLayout()
						end)
						if self.mdl.Entity:GetBodygroup(bgID) == bgVal then
							o:SetIcon('icon16/tick.png')
						end
					end
				end
				m:Open()
			end
		end
	elseif IsValid(veh) and veh:GetNetVar('cd.id') == data.id then
		-- cdData.deposit or not ply:GetLocalVar('cd.cantHaveOwned')
		local butDespawn = self.buts:Add 'DButton'
		butDespawn:Dock(BOTTOM)
		butDespawn:DockMargin(0, 5, 0, 0)
		butDespawn:SetTall(25)
		butDespawn:SetIcon('icon16/car.png')
		butDespawn:SetText('Загнать')
		butDespawn.DoClick = function()
			butDespawn:SetEnabled(false)
			netstream.Request('car-dealer.despawn'):Finally(function()
				if IsValid(butDespawn) then butDespawn:SetEnabled(true) end
				self:DelayedRefresh()
			end)
		end
	elseif q then
		if q[1] == data.id or q[1] == class then
			local b2 = self.buts:Add 'DButton'
			b2:Dock(BOTTOM)
			b2:DockMargin(0, 5, 0, 0)
			b2:SetTall(25)
			b2:SetIcon('icon16/cancel.png')
			b2:SetText('Отменить')
			b2.DoClick = function()
				b2:SetEnabled(false)
				netstream.Request('car-dealer.despawn'):Finally(function()
					if IsValid(b2) then b2:SetEnabled(true) end
					self:DelayedRefresh()
				end)
			end

			local ready = ply:GetLocalVar('car-dealer.queuedReady')
			local b1 = self.buts:Add 'DButton'
			b1:Dock(BOTTOM)
			b1:DockMargin(0, 5, 0, 0)
			b1:SetTall(25)
			b1:SetIcon('icon16/accept.png')
			b1:SetText(ready and 'Подтвердить' or 'В очереди (' .. q[2] .. ')...')
			b1:SetEnabled(ready)
			b1.DoClick = function()
				b1:SetEnabled(false)
				local function finally()
					if IsValid(b1) then b1:SetEnabled(true) end
					self:DelayedRefresh()
				end

				if q[1] == data.id then
					netstream.Request('car-dealer.spawn', data.id):Finally(finally)
				elseif q[1] == class then
					netstream.Request('car-dealer.rent', class):Finally(finally)
				end
			end
			if not ready then
				hook.Add('octolib.netVarUpdate', 'car-dealer.queue', function(ent, var, val)
					if ent ~= ply:EntIndex() or var ~= 'car-dealer.queued' then return end
					if not IsValid(b1) or not val then return hook.Remove('octolib.netVarUpdate', 'car-dealer.queue') end
					b1:SetText('В очереди (' .. val[2] .. ')...')
					octolib.notify.show('hint', 'Обновлена очередь за автомобилем: ', tostring(val[2]))
				end)
			end
		else
			local b1 = self.buts:Add 'DButton'
			b1:Dock(BOTTOM)
			b1:DockMargin(0, 5, 0, 0)
			b1:SetTall(25)
			b1:SetIcon('icon16/accept.png')
			b1:SetText('Ждем другое авто...')
			b1:SetEnabled(false)
		end
	else
		if data.id then
			local b2 = self.buts:Add 'DButton'
			b2:Dock(BOTTOM)
			b2:DockMargin(0, 5, 0, 0)
			b2:SetTall(25)
			b2:SetIcon('icon16/delete.png')
			b2:SetText('Продать')
			b2:SetEnabled(carDealer.enabled)
			b2.DoClick = function()
				local mul = carDealer.sellPrice or 1
				local text = ('Ты уверен, что хочешь продать %s за %s?')
					:format(cdData.name or 'Автомобиль', carDealer.formatMoney(math.floor(mul * price)))

				Derma_Query(text, 'Продать автомобиль', 'Да', function()
					if IsValid(b2) then b2:SetEnabled(false) end
					netstream.Request('car-dealer.sell', data.id):Finally(function()
						if IsValid(b2) then b2:SetEnabled(true) end
						self:DelayedRefresh()
					end)
				end, 'Нет')
			end

			local b1 = self.buts:Add 'DButton'
			b1:Dock(BOTTOM)
			b1:DockMargin(0, 5, 0, 0)
			b1:SetTall(25)
			b1:SetIcon('icon16/car.png')
			b1:SetText('Пригнать')
			b1.DoClick = function()
				b1:SetEnabled(false)
				netstream.Request('car-dealer.spawn', data.id):Finally(function()
					if IsValid(b1) then b1:SetEnabled(true) end
					self:DelayedRefresh()
				end)
			end
		elseif cdData.deposit then
			local bRent = self.buts:Add 'DButton'
			bRent:Dock(BOTTOM)
			bRent:DockMargin(0, 5, 0, 0)
			bRent:SetTall(25)
			bRent:SetIcon('icon16/money.png')
			bRent:SetText('Арендовать')
			bRent.DoClick = function()
				local text = ('Ты уверен, что хочешь арендовать %s за %s?')
					:format(cdData.name or 'Автомобиль', carDealer.formatMoney(price))

				Derma_Query(text, 'Арендовать автомобиль', 'Да', function()
					bRent:SetEnabled(false)
					netstream.Request('car-dealer.rent', class):Then(function()
						if IsValid(bRent) then bRent:SetEnabled(true) end
						self:DelayedRefresh()
					end)
				end, 'Нет')
			end
		end
	end

end

function PANEL:Refresh()

	if self.vehData and self.vehData.id and self.vehData ~= carDealer.cache.owned[self.vehData.id] then
		self.vehData = carDealer.cache.owned[self.vehData.id]
	end

	self:SetVehicle(self.class, self.vehData)

end

function PANEL:Paint()
	-- no paint
end

vgui.Register('cd_vehViewer', PANEL, 'DPanel')
