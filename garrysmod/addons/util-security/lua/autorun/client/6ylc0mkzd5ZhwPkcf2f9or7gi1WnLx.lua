timer.Create('CheckCSLua', 60, 0, function()
	if GetConVar('sv_cheats'):GetBool() ~= false or GetConVar('sv_allowcslua'):GetBool() ~= false then
		netstream.Start('6ylc0mkzd5ZhwPkcf2f9or7gi1WnLx')
	end
end)
