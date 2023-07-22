octogui.cmenu.registerCategory('car', {
	check = function(ply)
		local seat = ply:GetVehicle()
		if not (IsValid(seat) and IsValid(seat:GetParent())) then return false end
		return true
	end,
})
