octogui.cmenu.registerItem('car', 'radio', {
	text = L.radio,
	check = function(ply)
		local seat = ply:GetVehicle()
		if seat:GetParent().GetDriverSeat and seat:GetParent():GetDriverSeat() == seat then
			return true
		end

		return simfphys.GetSeatProperty(seat, 'hasRadio')
	end,
	icon = octolib.icons.silk16('radio_modern'),
	netstream = 'dbg-radio.openCar',
})

octogui.cmenu.registerItem('car', 'seat', {
	text = 'Пересесть',
	icon = octolib.icons.silk16('chair'),
	build = function(sm)
		netstream.Request('dbg-cars.seatStatus'):Then(function(data)
			if not IsValid(sm) then return end
			for _, v in ipairs(data) do
				local opt = sm:AddOption(v.name, function()
					net.Start('simfphys_request_seatswitch')
						net.WriteInt(v.id, 32)
					net.SendToServer()
				end)
				opt:SetChecked(v.check)
				if v.icon then opt:SetImage(octolib.icons.silk16(v.icon)) end
			end
		end)
	end,
})
