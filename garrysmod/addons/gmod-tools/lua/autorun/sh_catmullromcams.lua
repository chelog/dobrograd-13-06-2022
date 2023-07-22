--[[
	Planetfall: Catmull-Rom Cutscene Camera Track System
	by Olivier 'LuaPineapple' Hamel
	
	I'll be nice and release a stand alone version for you guys.
	BUT I EXECPT A GODS AWFUL AMOUNT OF COOKIES!
	
	If I don't I'll get annoyed and when I get annoyed I become irritable and when I become irritable people DIE! [/quote_dr_evil]
--]]

--[[
	5:52 PM - Firgof Umbra: I worry about your sense of perception sometimes.
	5:52 PM - LuaPineapple: I AM GOD!
	5:52 PM - LuaPineapple: WORSHIP ME!
	5:52 PM - Firgof Umbra: ...
	5:53 PM - LuaPineapple: INSECT!
--]]



local function AddLua(filename)
	local tmp = string.Explode("/", string.lower(filename))
	local parts = string.Explode("_", tmp[#tmp])
	
	if SERVER then
		if (parts[1] == "sh") or (parts[1] == "shared.lua") then
			include(filename)
			return AddCSLuaFile(filename)
		elseif parts[1] == "cl" then
			return AddCSLuaFile(filename)
		elseif (parts[1] == "sv") or (parts[1] == "init.lua") then
			return include(filename)
		end
		
		ErrorNoHalt("Unknown file: ",filename,"\n")
		PrintTable(tmp)
		PrintTable(parts)
		Error("Unable to determine if shared, serverside, or clientside.\n")
	elseif CLIENT then
		if (parts[1] == "sh") or (parts[1] == "cl") or (parts[1] == "shared.lua") then
			return include(filename)
		elseif (parts[1] == "sv") or (parts[1] == "init.lua") then //others, just to keep the system happy
			return
		end
		
		ErrorNoHalt("Unknown file: ",filename,"\n")
		PrintTable(tmp)
		PrintTable(parts)
		Error("Unable to determine if shared, serverside, or clientside.\n")
	else
		return Error("Apparently we're God as we're not the client or the server.\n")
	end
end

if SERVER then AddCSLuaFile("sh_CatmullRomCams.lua") end

CatmullRomCams = CatmullRomCams or {}

CatmullRomCams.AddLua   = AddLua
CatmullRomCams.FilePath = "CatmullRomCameraTracks/"

CatmullRomCams.SV = CatmullRomCams.SV or {}
CatmullRomCams.SH = CatmullRomCams.SH or {}
CatmullRomCams.CL = CatmullRomCams.CL or {}

CatmullRomCams.SToolMethods = {}

function CatmullRomCams.SH.UnitsToMeters(dist)
	return (dist * 0.0254)
end

function CatmullRomCams.SH.MetersToUnits(dist)
	return (dist * 39.3700787)
end

function CatmullRomCams.SToolMethods.ValidTrace(trace)
	return (trace and trace.Entity and trace.Entity.GetClass and trace.Entity.IsValid and trace.Entity:IsValid() and (trace.Entity:GetClass() == "sent_catmullrom_camera"))
end

CatmullRomCams.Tracks = CatmullRomCams.Tracks or {}

local files = file.Find("CatmullRomCams/*.lua", "LUA")

for _, v in pairs(files) do
	AddLua("CatmullRomCams/" .. v)
end

local files_stools = file.Find("CatmullRomCams/STools/*.lua", "LUA")

for _, v in pairs(files_stools) do
	AddLua("CatmullRomCams/STools/" .. v)
end
---FREEZEBUG: You forgot client tool data.
local files_stools_client = file.Find("weapons/gmod_tool/stools/*.lua", "LUA")
for _, v in pairs(files_stools_client) do
	AddCSLuaFile("weapons/gmod_tool/stools/" .. v)
end
--[[

CatmullRomCams = CatmullRomCams or {}
CatmullRomCams.AddLua   = AddLua
CatmullRomCams.FilePath = "CatmullRomCameraTracks/"
local function AddLua(filename)
	local tmp = string.Explode("/", string.lower(filename))
	local parts = string.Explode("_", tmp[#tmp])
	
	if SERVER then
		if (parts[1] == "sh") or (parts[1] == "shared.lua") then
			include(filename)
			return AddCSLuaFile(filename)
		elseif parts[1] == "cl" then
			return AddCSLuaFile(filename)
		elseif (parts[1] == "sv") or (parts[1] == "init.lua") then
			return include(filename)
		end
		
		ErrorNoHalt("Unknown file: ",filename,"\n")
		PrintTable(tmp)
		PrintTable(parts)
		Error("Unable to determine if shared, serverside, or clientside.\n")
	elseif CLIENT then
		if (parts[1] == "sh") or (parts[1] == "cl") or (parts[1] == "shared.lua") then
			return include(filename)
		elseif (parts[1] == "sv") or (parts[1] == "init.lua") then //others, just to keep the system happy
			return
		end
		
		ErrorNoHalt("Unknown file: ",filename,"\n")
		PrintTable(tmp)
		PrintTable(parts)
		Error("Unable to determine if shared, serverside, or clientside.\n")
	else
		return Error("Apparently we're God as we're not the client or the server.\n")
	end
end
--[[
if SERVER then AddCSLuaFile("sh_CatmullRomCams.lua") end

CatmullRomCams = CatmullRomCams or {}

CatmullRomCams.AddLua   = AddLua
CatmullRomCams.FilePath = "CatmullRomCameraTracks/"

CatmullRomCams.SV = CatmullRomCams.SV or {}
CatmullRomCams.SH = CatmullRomCams.SH or {}
CatmullRomCams.CL = CatmullRomCams.CL or {}

CatmullRomCams.SToolMethods = {}

function CatmullRomCams.SH.UnitsToMeters(dist)
	return (dist * 0.0254)
end

function CatmullRomCams.SH.MetersToUnits(dist)
	return (dist * 39.3700787)
end

function CatmullRomCams.SToolMethods.ValidTrace(trace)
	return (trace and trace.Entity and trace.Entity.GetClass and trace.Entity.IsValid and trace.Entity:IsValid() and (trace.Entity:GetClass() == "sent_catmullrom_camera"))
end

CatmullRomCams.Tracks = CatmullRomCams.Tracks or {}

if SERVER then
AddCSLuaFile("CatmullRomCams/Stools/sh_duration_editor.lua")
AddCSLuaFile("CatmullRomCams/Stools/sh_hitchcock_effect.lua")
AddCSLuaFile("CatmullRomCams/Stools/sh_layout.lua")
AddCSLuaFile("CatmullRomCams/Stools/sh_linker.lua")
AddCSLuaFile("CatmullRomCams/Stools/sh_map_io_editor.lua")
AddCSLuaFile("CatmullRomCams/Stools/sh_numpad_trigger.lua")
AddCSLuaFile("CatmullRomCams/Stools/sh_smart_look.lua")
AddCSLuaFile("CatmullRomCams/cl_calcview_hook.lua")
AddCSLuaFile("CatmullRomCams/cl_edit_lock_display.lua")
AddCSLuaFile("CatmullRomCams/cl_tab.lua")
AddCSLuaFile("CatmullRomCams/cl_language_defs.lua")
AddCSLuaFile("CatmullRomCams/sh_catmullrom_spline_controller.lua")
AddCSLuaFile("CatmullRomCams/sh_cleanup.lua")
AddCSLuaFile("CatmullRomCams/sh_gc_booster.lua")
AddCSLuaFile("CatmullRomCams/sh_general_hooks.lua")
AddCSLuaFile("CatmullRomCams/sh_Quaternions.lua")
AddCSLuaFile("CatmullRomCams/sh_save_load.lua")
include("CatmullRomCams/sv_icon_resource.lua")
include("CatmullRomCams/sv_adv_dup_paste.lua")
include("CatmullRomCams/sv_saverestore.lua")
end
include("CatmullRomCams/sh_catmullrom_spline_controller.lua")
include("CatmullRomCams/sh_cleanup.lua")
include("CatmullRomCams/sh_gc_booster.lua")
include("CatmullRomCams/sh_general_hooks.lua")
include("CatmullRomCams/sh_Quaternions.lua")
include("CatmullRomCams/sh_save_load.lua")
include("CatmullRomCams/Stools/sh_duration_editor.lua") --
include("CatmullRomCams/Stools/sh_hitchcock_effect.lua") --
include("CatmullRomCams/Stools/sh_layout.lua") --
include("CatmullRomCams/Stools/sh_linker.lua") --
include("CatmullRomCams/Stools/sh_map_io_editor.lua") --
include("CatmullRomCams/Stools/sh_numpad_trigger.lua") --
include("CatmullRomCams/Stools/sh_smart_look.lua") --

if CLIENT then
include("CatmullRomCams/cl_language_defs.lua")
include("CatmullRomCams/cl_calcview_hook.lua")
include("CatmullRomCams/cl_edit_lock_display.lua")
include("CatmullRomCams/cl_tab.lua")

end
]]--
