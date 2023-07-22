local function isActive(item)
	return item:GetData('active')
end

local function hasUses(item)
	return item:GetData('usesLeft') > 0
end

local thankTexts = L.thankTexts

octoshop.items['coffee'] = {
	cat = L.other,
	order = 100,
	name = L.item_coffee,
	desc = L.desc_octoshop_coffee,
	attributes = {
		{L.octoshop_what, octolib.icons.silk16('heart'), L.octoshop_good_action},
	},
	price = 15,
	icon = 'octoteam/icons/cup2.png',
	CanBuy = true,
	CanUse = true,
	Use = function(self)
		local ply = self:GetOwner()
		octoshop.notifyAll('ooc', string.format(thankTexts[math.random(#thankTexts)], ply:SteamName()))

		self:Remove()
	end,
}

octoshop.items['jobs_1m'] = {
	cat = L.octoshop_buns,
	order = 1,
	name = L.item_dobrodey,
	desc = L.desc_jobs_1m,
	attributes = {
		{L.octoshop_what, octolib.icons.silk16('plugin'), L.octoshop_expansion},
		{L.octoshop_where, octolib.icons.silk16('box_open'), L.octoshop_in_some_moment},
		{L.octoshop_validity, octolib.icons.silk16('hourglass'), L.octoshop_one_month},
	},
	price = 250,
	icon = 'octoteam/icons/heart.png',
	CanBuy = true,
	OnGiven = function(self)
		if not self:GetData('usesLeft') then self:SetData('usesLeft', 1) end
		if self:GetData('active') then
			local ply = self:GetOwner()
			ply:SetNetVar('os_dobro', true)
			if not ply:GetInfo('dbg_job') or ply:GetInfo('dbg_job') == '' or ply:GetInfo('dbg_job') == 'citizen' then
				ply:ConCommand('dbg_job citizen2')
				if ply:TimeConnected() < 600 then
					timer.Simple(2, function()
						if not IsValid(ply) then return end
						ply:Spawn()
					end)
				end
			end
		end
	end,
	OnTaken = function(self)
		if self:GetData('active') then
			self:GetOwner():SetNetVar('os_dobro', false)
		end
	end,
	CanTrade = function(self)
		return self:GetData('usesLeft') > 0
	end,
	CanUse = function(self)
		return self:GetData('usesLeft') > 0 and not self:GetOwner():GetNetVar('os_dobro')
	end,
	Use = function(self)
		self:SetData('active', true)
		self:SetData('usesLeft', 0)
		self:SetExpireIn(60 * 60 * 24 * 30)
		self:OnGiven()
		self:GetOwner():osNetInv()
	end,
}

do
	local jobs2w = table.Copy(octoshop.items['jobs_1m'])
	jobs2w.hidden = true
	jobs2w.CanBuy = false
	jobs2w.CanTrade = false
	jobs2w.attributes[3] = {L.octoshop_validity, octolib.icons.silk16('hourglass'), 'Две недели'}
	jobs2w.Use = function(self)
		self:SetData('active', true)
		self:SetData('usesLeft', 0)
		self:SetExpireIn(60 * 60 * 24 * 14)
		self:OnGiven()
		self:GetOwner():osNetInv()
	end
	octoshop.items['jobs_2w'] = jobs2w
end

octoshop.items['govorilka'] = {
	cat = L.octoshop_buns,
	order = 1,
	name = L.item_govorilka,
	desc = L.desc_octoshop_govorilka,
	attributes = {
		{L.octoshop_what, octolib.icons.silk16('plugin'), L.octoshop_expansion},
		{L.octoshop_where, octolib.icons.silk16('box_open'), L.octoshop_in_some_moment},
		{L.octoshop_validity, octolib.icons.silk16('time'), L.octoshop_one_month},
	},
	price = 100,
	icon = 'octoteam/icons/megaphone2.png',
	CanBuy = true,
	OnGiven = function(self)
		if not self:GetData('usesLeft') then self:SetData('usesLeft', 1) end
		if self:GetData('equipped') then
			timer.Simple(5, function()
				self:Equip(true)
			end)
		end
	end,
	OnTaken = function(self)
		if self:GetData('active') then
			self:GetOwner():SetNetVar('os_govorilka', false)
		end
	end,
	CanEquip = isActive,
	CanUnequip = isActive,
	CanTrade = hasUses,
	CanUse = function(self) return self:GetData('usesLeft') > 0 and not self:GetOwner():GetNetVar('os_govorilka') end,
	Use = function(self)
		self:SetData('active', true)
		self:SetData('usesLeft', 0)
		self:SetExpireIn(60 * 60 * 24 * 30)
		local ply = self:GetOwner()
		ply:osNetInv()
		ply:Notify('hint', L.use_item_govorilka)
	end,
	Equip = function(self)
		local ply = self:GetOwner()
		ply:SetNetVar('os_govorilka', true)
		ply:SendLua([[octogui.reloadGovorilka()]])
		self:SetData('equipped', true)
		ply:osNetInv()
	end,
	Unequip = function(self)
		local ply = self:GetOwner()
		ply:SetNetVar('os_govorilka', false)
		ply:SendLua([[octogui.reloadGovorilka()]])
		self:SetData('equipped', nil)
		ply:osNetInv()
	end,
}

octoshop.items['delivery'] = {
	cat = L.octoshop_buns,
	order = 1,
	name = L.free_delivery,
	desc = L.desc_octoshop_free_delivery,
	attributes = {
		{L.octoshop_what, octolib.icons.silk16('plugin'), L.octoshop_expansion},
		{L.octoshop_where, octolib.icons.silk16('box_open'), L.octoshop_in_some_moment},
		{L.octoshop_validity, octolib.icons.silk16('hourglass'), L.octoshop_one_month},
	},
	price = 50,
	icon = 'octoteam/icons/box3_drop.png',
	CanBuy = true,
	OnGiven = function(self)
		if not self:GetData('usesLeft') then self:SetData('usesLeft', 1) end
		if self:GetData('active') then
			self:GetOwner():SetNetVar('os_delivery', true)
		end
	end,
	OnTaken = function(self)
		if self:GetData('active') then
			self:GetOwner():SetNetVar('os_delivery', false)
		end
	end,
	CanTrade = function(self)
		return self:GetData('usesLeft') > 0
	end,
	CanUse = function(self)
		return self:GetData('usesLeft') > 0 and not self:GetOwner():GetNetVar('os_delivery')
	end,
	Use = function(self)
		self:SetData('active', true)
		self:SetData('usesLeft', 0)
		self:SetExpireIn(60 * 60 * 24 * 30)
		self:OnGiven()
		self:GetOwner():osNetInv()
	end,
}

octoshop.items['storage'] = {
	cat = L.octoshop_buns,
	order = 1,
	name = L.item_big_storage,
	desc = L.big_storage,
	attributes = {
		{L.octoshop_what, octolib.icons.silk16('plugin'), L.octoshop_expansion},
		{L.octoshop_where, octolib.icons.silk16('box_open'), L.octoshop_in_some_moment},
		{L.octoshop_validity, octolib.icons.silk16('hourglass'), L.octoshop_one_month},
	},
	price = 100,
	icon = 'octoteam/icons/case_travel.png',
	CanBuy = true,
	OnGiven = function(self)
		if not self:GetData('usesLeft') then self:SetData('usesLeft', 1) end
		if self:GetData('active') then
			self:GetOwner():SetNetVar('os_storage', true)
		end
	end,
	OnTaken = function(self)
		if self:GetData('active') then
			self:GetOwner():SetNetVar('os_storage', false)
		end
	end,
	CanTrade = function(self)
		return self:GetData('usesLeft') > 0
	end,
	CanUse = function(self)
		return self:GetData('usesLeft') > 0 and not self:GetOwner():GetNetVar('os_storage')
	end,
	Use = function(self)
		self:SetData('active', true)
		self:SetData('usesLeft', 0)
		self:SetExpireIn(60 * 60 * 24 * 30)
		self:OnGiven()
		self:GetOwner():osNetInv()
	end,
}

octoshop.items['build'] = {
	cat = L.octoshop_buns,
	order = 1,
	name = L.item_builder,
	desc = L.builder,
	attributes = {
		{L.octoshop_what, octolib.icons.silk16('plugin'), L.octoshop_expansion},
		{L.octoshop_where, octolib.icons.silk16('box_open'), L.octoshop_in_some_moment},
		{L.octoshop_validity, octolib.icons.silk16('time'), L.octoshop_one_month},
	},
	price = 75,
	icon = 'octoteam/icons/hammer.png',
	CanBuy = true,
	CanTrade = hasUses,
	CanUse = function(self) return self:GetData('usesLeft') > 0 and not self:GetOwner():GetNetVar('os_build') end,
	OnGiven = function(self)
		if not self:GetData('usesLeft') then self:SetData('usesLeft', 1) end
		if self:GetData('active') then
			local ply = self:GetOwner()
			ply:SetNetVar('os_build', true)
			ply:SetNetVar('propLimit', math.max(ply:GetNetVar('propLimit') or 100, 200))
			ply:GetClientVar({'physgunColor'}, function(vars)
				if not istable(vars.physgunColor) then return end
				local col = Color(vars.physgunColor.r or 0, vars.physgunColor.g or 161, vars.physgunColor.b or 255)
				if col == Color(0,161,255) then return end
				ply:ChangePhysgunColor(col)
			end)
			ply:osNetInv()
		end
	end,
	OnTaken = function(self)
		if self:GetData('active') then
			local ply = self:GetOwner()
			ply:SetNetVar('os_build', nil)
			if ply:GetNetVar('propLimit') == 200 then ply:SetNetVar('propLimit', nil) end
			ply:SetNetVar('physgunColor')
			ply:osNetInv()
		end
	end,
	Use = function(self)
		local ply = self:GetOwner()
		self:SetData('active', true)
		self:SetData('usesLeft', 0)
		self:SetExpireIn(60 * 60 * 24 * 30)
		self:OnGiven()
		ply:osNetInv()
		ply:Notify('hint', L.use_item_builder)
	end,
}

octoshop.items['story'] = {
	cat = L.octoshop_buns,
	order = 1,
	name = L.item_story,
	desc = L.desc_story,
	attributes = {
		{L.octoshop_what, octolib.icons.silk16('plugin'), L.octoshop_expansion},
		{L.octoshop_where, octolib.icons.silk16('box_open'), L.octoshop_in_some_moment},
		{L.octoshop_validity, octolib.icons.silk16('time'), L.octoshop_one_month},
	},
	price = 75,
	icon = 'octoteam/icons/ink.png',
	CanBuy = true,
	CanTrade = hasUses,
	CanUse = function(self) return self:GetData('usesLeft') > 0 and not self:GetOwner():GetNetVar('os_story') end,
	OnGiven = function(self)
		if not self:GetData('usesLeft') then self:SetData('usesLeft', 1) end
		if self:GetData('active') then
			local ply = self:GetOwner()
			ply:SetNetVar('os_story', true)
			ply:osNetInv()
		end
	end,
	OnTaken = function(self)
		if self:GetData('active') then
			local ply = self:GetOwner()
			ply:SetNetVar('os_story', nil)
			ply:osNetInv()
		end
	end,
	Use = function(self)
		local ply = self:GetOwner()
		self:SetData('active', true)
		self:SetData('usesLeft', 0)
		self:SetExpireIn(60 * 60 * 24 * 30)
		self:OnGiven()
		ply:osNetInv()
		ply:Notify('hint', L.use_item_story)
	end,
}

octoshop.items['car_plate'] = {
	cat = L.octoshop_buns,
	order = 1,
	name = 'Блатной номер',
	desc = 'Позволяет установить любой номер на один из автомобилей в гараже. Устанавливаемый номерной знак должен быть похож на реально существующие, чтобы если его одобряла номерная комиссия, ни у кого не возникло претензий. Он не может содержать мат, любые непристойности или мемы. Админы могут сбросить номер, если он нарушает эти требования',
	attributes = {
		{L.octoshop_what, octolib.icons.silk16('plugin'), L.octoshop_expansion},
		{L.octoshop_where, octolib.icons.silk16('box_open'), L.octoshop_in_some_moment},
	},
	price = 50,
	icon = 'octoteam/icons/license_plate.png',
	CanBuy = true,
	CanTrade = true,
	CanUse = true,
	Use = function(self)
		local ply = self:GetOwner()
		carDealer.getGarage(ply:SteamID(), function(garage)
			if table.Count(garage) < 1 then
				ply:Notify('У тебя нет купленных автомобилей')
				return
			end

			local opts = {}
			for id, veh in pairs(garage) do
				opts[#opts + 1] = { carDealer.vehicles[veh.class].name .. ' ' .. veh.plate, id, #opts < 1 }
			end

			octolib.request.send(ply, {{
				name = 'Блатной номер',
				desc = 'Номер применится к выбранному автомобилю. Он не должен нарушать действующие правила. В противном случае можно его потерять',
			},{
				required = true,
				type = 'comboBox',
				name = 'Автомобиль',
				opts = opts,
			}, {
				required = true,
				type = 'strShort',
				name = 'Номер (6 или 7 символов)',
				ph = carDealer.randomPlate(7),
			}}, function(data)
				if self.removed then return end

				local vehID, plate = unpack(data, 2)
				if not isnumber(vehID) or not isstring(plate) then
					ply:Notify('Нужно заполнить все поля')
					return
				end

				if not octolib.math.inRange(plate:len(), 6, 7) or plate:upper():find('[^' .. carDealer.plateSymbols .. ']') then
					ply:Notify('Номер должен состоять из 6 или 7 символов и содержать только латинские буквы или цифры')
					return
				end

				carDealer.getVehByPlate(plate, function(veh)
					if veh then
						ply:Notify('Этот номер уже занят')
						return
					end

					carDealer.updateVehData(vehID, { plate = plate }, function()
						hook.Run('car-dealer.plateChanged', vehID, ply:SteamID(), plate)
					end)

					local curVeh = carDealer.getCurVeh(ply)
					if IsValid(curVeh) and curVeh:GetNetVar('cd.id') == vehID then
						curVeh:SetNetVar('cd.plate', plate)
					end

					self:Remove()
				end)
			end)
		end)
	end,
}

octoshop.items['trader'] = {
	cat = L.octoshop_buns,
	order = 1,
	name = L.item_trader,
	desc = L.item_trader_desc,
	attributes = {
		{L.octoshop_what, octolib.icons.silk16('plugin'), L.octoshop_expansion},
		{L.octoshop_where, octolib.icons.silk16('box_open'), L.octoshop_in_some_moment},
		{L.octoshop_validity, octolib.icons.silk16('hourglass'), L.octoshop_one_month},
	},
	price = 100,
	icon = 'octoteam/icons/chart_up.png',
	CanBuy = true,
	OnGiven = function(self)
		if not self:GetData('usesLeft') then self:SetData('usesLeft', 1) end
		if self:GetData('active') then
			self:GetOwner():SetNetVar('os_trader', true)
		end
	end,
	OnTaken = function(self)
		if self:GetData('active') then
			self:GetOwner():SetNetVar('os_trader', false)
		end
	end,
	CanTrade = function(self)
		return self:GetData('usesLeft') > 0
	end,
	CanUse = function(self)
		return self:GetData('usesLeft') > 0 and not self:GetOwner():GetNetVar('os_trader')
	end,
	Use = function(self)
		self:SetData('active', true)
		self:SetData('usesLeft', 0)
		self:SetExpireIn(60 * 60 * 24 * 30)
		self:OnGiven()
		local ply = self:GetOwner()
		ply:osNetInv()
		ply:Notify('hint', L.use_item_trader)
	end,
}

octoshop.items['money_15k'] = {
	cat = L.money,
	order = 5,
	name = '15,000P',
	desc = L.money_15k,
	attributes = {
		{L.octoshop_what, octolib.icons.silk16('cash_stack'), L.octoshop_game_currency},
		{L.octoshop_where, octolib.icons.silk16('box_open'), L.octoshop_in_some_moment},
	},
	price = 15,
	icon = 'octoteam/icons/coin.png',
	CanBuy = true,
	CanTrade = true,
	CanUse = true,
	Use = function(self)
		local ply = self:GetOwner()
		ply:BankAdd(15000)
		ply:Notify('hint', L.update_balance, DarkRP.formatMoney(15000))

		self:Remove()
	end,
}

octoshop.items['money_50k'] = {
	cat = L.money,
	order = 5,
	name = '50,000P',
	desc = L.money_50k,
	attributes = {
		{L.octoshop_what, octolib.icons.silk16('cash_stack'), L.octoshop_game_currency},
		{L.octoshop_where, octolib.icons.silk16('box_open'), L.octoshop_in_some_moment},
	},
	price = 50,
	icon = 'octoteam/icons/coin3.png',
	CanBuy = true,
	CanTrade = true,
	CanUse = true,
	Use = function(self)
		local ply = self:GetOwner()
		ply:BankAdd(50000)
		ply:Notify('hint', L.update_balance, DarkRP.formatMoney(50000))

		self:Remove()
	end,
}

octoshop.items['money_100k'] = {
	cat = L.money,
	order = 5,
	name = '100,000P',
	desc = L.money_100k,
	attributes = {
		{L.octoshop_what, octolib.icons.silk16('cash_stack'), L.octoshop_game_currency},
		{L.octoshop_where, octolib.icons.silk16('box_open'), L.octoshop_in_some_moment},
	},
	price = 100,
	icon = 'octoteam/icons/coin_stacks.png',
	CanBuy = true,
	CanTrade = true,
	CanUse = true,
	Use = function(self)
		local ply = self:GetOwner()
		ply:BankAdd(100000)
		ply:Notify('hint', L.update_balance, DarkRP.formatMoney(100000))

		self:Remove()
	end,
}

octoshop.items['money_250k'] = {
	cat = L.money,
	order = 5,
	name = '250,000P',
	desc = L.money_250k,
	attributes = {
		{L.octoshop_what, octolib.icons.silk16('cash_stack'), L.octoshop_game_currency},
		{L.octoshop_where, octolib.icons.silk16('box_open'), L.octoshop_in_some_moment},
	},
	price = 250,
	icon = 'octoteam/icons/money_pack.png',
	CanBuy = true,
	CanTrade = true,
	CanUse = true,
	Use = function(self)
		local ply = self:GetOwner()
		ply:BankAdd(250000)
		ply:Notify('hint', L.update_balance, DarkRP.formatMoney(250000))

		self:Remove()
	end,
}

octoshop.items['money_500k'] = {
	cat = L.money,
	order = 5,
	name = '500,000P',
	desc = L.money_500k,
	attributes = {
		{L.octoshop_what, octolib.icons.silk16('cash_stack'), L.octoshop_game_currency},
		{L.octoshop_where, octolib.icons.silk16('box_open'), L.octoshop_in_some_moment},
	},
	price = 500,
	icon = 'octoteam/icons/gold_chest.png',
	CanBuy = true,
	CanTrade = true,
	CanUse = true,
	Use = function(self)
		local ply = self:GetOwner()
		ply:BankAdd(500000)
		ply:Notify('hint', L.update_balance, DarkRP.formatMoney(500000))

		self:Remove()
	end,
}
