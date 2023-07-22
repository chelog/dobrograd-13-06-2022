
--[[
Stungun SWEP Created by Donkie (http://steamcommunity.com/id/Donkie/)
For personal/server usage only, do not resell or distribute!
]]

include("shared.lua")

SWEP.Slot = 5
SWEP.SlotPos = 20
SWEP.DrawAmmo = (not SWEP.InfiniteAmmo)
SWEP.DrawCrosshair = true

hook.Add('dbg-view.override', 'stungun', function()
	if LocalPlayer():GetNetVar('Tased') then return false end
end)
