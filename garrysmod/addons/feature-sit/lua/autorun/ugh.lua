if SERVER then
	AddCSLuaFile()
	return
end

local last = false
local lsit = 0
hook.Remove("Think","Sitting_AltUse")
hook.Add("Think","Sitting_CtrlUse",function()
	if IsValid( LocalPlayer() ) and IsValid( LocalPlayer():GetVehicle() ) then
		LocalPlayer():GetVehicle():SetThirdPersonMode( false )
	end

	-- if(last and !input.IsKeyDown(KEY_E)) then
	-- 	if input.IsKeyDown(KEY_LSHIFT) or input.IsKeyDown(KEY_RSHIFT) then
	-- 		if lsit + 1 < CurTime() then
	-- 			RunConsoleCommand("sit")
	-- 			lsit = CurTime()
	-- 		end
	-- 	end
	-- end
	-- last = input.IsKeyDown(KEY_E)
end)
