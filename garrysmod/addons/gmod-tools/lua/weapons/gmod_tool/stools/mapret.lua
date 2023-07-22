--[[
   \   MAP RETEXTURIZER
 =3 ]]  local mr_revision = "MAP. RET. rev.12 - 16/04/2018 (dd/mm/yyyy)" --[[
 =o |   License: MIT
   /   Created by: Xalalau Xubilozo
  |
   \   Garry's Mod Brasil
 =< |   http://www.gmbrblog.blogspot.com.br/
 =b |   https://github.com/xalalau/GMod/tree/master/Map%20Retexturizer
   /   Enjoy! - Aproveitem!

----- Special thanks to the testers:

 [*] Beckman
 [*] BombermanMaldito
 [*] duck
 [*] XxtiozionhoxX
 [*] le0board
 [*] Matsilagi
 [*] NickMBR

 Valeu, pessoal!!
]]

--------------------------------
--- TOOL STUFF
--------------------------------

TOOL.Category = "Render"
TOOL.Name = "#tool.mapret.name"
TOOL.Information = {
	{name = "left"},
	{name = "right"},
	{name = "reload"}
}

if (CLIENT) then
	language.Add("tool.mapret.name", "Map Retexturizer")
	language.Add("tool.mapret.left", "Set material")
	language.Add("tool.mapret.right", "Copy material")
	language.Add("tool.mapret.reload", "Remove material")
	language.Add("tool.mapret.desc", "Change many materials on models and maps and also use them as decals.")
end

--------------------------------
--- CLIENT CVARS
--------------------------------

CreateConVar("mapret_admin", "1", { FCVAR_CLIENTCMD_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_REPLICATED })

CreateConVar("mapret_autosave", "1", { FCVAR_CLIENTCMD_CAN_EXECUTE, FCVAR_REPLICATED })
CreateConVar("mapret_autoload", "", { FCVAR_CLIENTCMD_CAN_EXECUTE, FCVAR_REPLICATED })
TOOL.ClientConVar["savename"] = ""

CreateConVar("mapret_skybox", "", { FCVAR_CLIENTCMD_CAN_EXECUTE, FCVAR_REPLICATED })

TOOL.ClientConVar["material"] = ""
TOOL.ClientConVar["detail"] = "None"
TOOL.ClientConVar["alpha"] = "1"
TOOL.ClientConVar["offsetx"] = "0"
TOOL.ClientConVar["offsety"] = "0"
TOOL.ClientConVar["scalex"] = "1"
TOOL.ClientConVar["scaley"] = "1"
TOOL.ClientConVar["rotation"] = "0"

-- Different declarations for these vars because I can control them better this way (SetChecked() works fine)
CreateClientConVar("mapret_preview", 0, false, false)
CreateClientConVar("mapret_decal", 0, false, false)

--------------------------------
--- GLOBAL VARS / INITIALIZATION
--------------------------------

-- Materials management
local mr_mat = {
	-- Tell if material changes were already made since the beggining of the game
	-- (Server)
	initialized = false,
	-- (Shared)
	map = {
		-- The name of our backup map material files. They are file1, file2, file3...
		filename = "mapretexturizer/file",
		-- 1024 file limit seemed to be more than enough. I only use this physical method because of GMod limitations
		limit = 1024,
		-- Data structures, all the modifications
		list = {}
	},
	-- (Client)
	model = {
		-- materialID = String, all the modifications
		list = {}
	},
	-- (Server)
	decal = {
		-- ID = String, all the modifications
		list = {}
	},
	-- (Client)
	detail = {
		-- Menu element
		element,
		-- Initialized later (Note: only "None" remains as bool)
		list = {
			["Concrete"] = false,
			["Metal"] = false,
			["None"] = true,
			["Plaster"] = false,
			["Rock"] = false
		}
	},
	-- (Client)
	skybox = {
		-- Text elemment
		element_text,
		-- Combobox elemment
		element_combo,
		-- HL2 sky list
		hl2_list = {
			[""] = "",
			["skybox/sky_borealis01"] = "",
			["skybox/sky_day01_01"] = "",
			["skybox/sky_day01_04"] = "",
			["skybox/sky_day01_05"] = "",
			["skybox/sky_day01_06"] = "",
			["skybox/sky_day01_07"] = "",
			["skybox/sky_day01_08"] = "",
			["skybox/sky_day01_09"] = "",
			["skybox/sky_day02_01"] = "",
			["skybox/sky_day02_02"] = "",
			["skybox/sky_day02_03"] = "",
			["skybox/sky_day02_04"] = "",
			["skybox/sky_day02_05"] = "",
			["skybox/sky_day02_06"] = "",
			["skybox/sky_day02_07"] = "",
			["skybox/sky_day02_09"] = "",
			["skybox/sky_day02_10"] = "",
			["skybox/sky_day03_01"] = "",
			["skybox/sky_day03_02"] = "",
			["skybox/sky_day03_03"] = "",
			["skybox/sky_day03_04"] = "",
			["skybox/sky_day03_05"] = "",
			["skybox/sky_day03_06"] = "",
			["skybox/sky_wasteland02"] = "",
		}
	},
	-- (Client)
	preview = {
		-- I have to use this extra entry to store the real newMaterial that the preview material is using
		newMaterial = "",
		-- For some reason the materials don't set their angles perfectly, so I have troubles comparing the values. This is a workaround
		rotation_workaround = -1,
		-- HACK to avoid running the TOOL:Holster() code when the player selects the tool for the first time
		holster_workaround = false
	}
}

if CLIENT then
	-- Detail init
	local function CreateMaterialAux(path)
		return CreateMaterial(path, "VertexLitGeneric", {["$basetexture"] = path})
	end

	mr_mat.detail.list["Concrete"] = CreateMaterialAux("detail/noise_detail_01")
	mr_mat.detail.list["Metal"] = CreateMaterialAux("detail/metal_detail_01")
	mr_mat.detail.list["Plaster"] = CreateMaterialAux("detail/plaster_detail_01")
	mr_mat.detail.list["Rock"] = CreateMaterialAux("detail/rock_detail_01")

	-- Preview material
	CreateMaterial("MatRetPreviewMaterial", "UnlitGeneric", {["$basetexture"] = ""})
end

-- Duplicator management
local mr_dup = {
	-- If a save is being loaded, the name keep stored here until it's done
	-- (Shared)
	running = "",
	-- Workaround to duplicate map and decal materials
	-- (Server)
	entity,
	-- It simulates a player so we can apply changes in empty servers
	-- (Shared)
	fake_ply = {},
	-- Disable our generic dup entity physics and rendering after the duplicate
	-- (Server)
	hidden = false,
	-- First dup cleanup
	-- (Server)
	clean = false,
	-- Force to stop the current loading to begin a new one
	-- (Shared)
	force_stop = false,
	-- Special aditive delay for models
	-- (Server)
	models = {
		delay = 0,
		max_delay = 0
	},
	-- Register what type of materials the duplicator has
	-- (Server)
	has = {
		models = false,
	}
}
-- Now I have to index the rest of duplicator inside players, so the process can be unique for each one of them
local function mr_dup_set(ply)
	local add = {
		-- Tell if duplicator is running and what it's processing
		-- (Shared)
		run = "",
		-- Register what type of materials the duplicator has
		-- (Server)
		has = {
			map = false,
			decals = false
		},
		-- Number of elements
		-- (Shared)
		count = {
			total = 0,
			current = 0,
			errors = {
				n = 0,
				list = {}
			},
		}
	}
	-- Index into the player
	-- (Shared)
	ply.mr_dup = add
end
-- Initialize the fake player
mr_dup_set(mr_dup.fake_ply)

-- Saves and loads!
local mr_manage = {
	-- Our folder inside data
	-- (Shared)
	main_folder = "mapret/",
	-- map_folder inside the main_folder
	-- (Shared)
	map_folder = game.GetMap().."/",
	save = {
		-- A table to join all the information about the modified materials to be saved
		-- (Server)
		list = {},
		-- Default save name
		-- (Client)
		defaul_name = game.GetMap().."_save",
		-- Menu element
		-- (Client)
		element
	},
	load = {
		-- List of save names
		-- (Shared)
		list = {},
		-- Menu element
		-- (Client)
		element
	},
	autosave = {
		-- Name to be listed in the save list
		-- (Server)
		name = "[autosave]",
		-- The autosave file for this map
		-- (Server)
		file = "[autosave].txt"
	},
	autoload = {
		-- autoload.folder inside the map_folder
		-- (Server)
		folder = "autoload/",
		-- The autoload file inside autoload.folder (unique for each map, will receive a save name)
		-- (Server)
		file = "autoload.txt",
		-- Menu element
		-- (Client)
		element
	}
}
-- Initialize paths
-- (Shared)
mr_manage.map_folder = mr_manage.main_folder..mr_manage.map_folder
mr_manage.autoload.folder = mr_manage.map_folder..mr_manage.autoload.folder
mr_manage.autosave.file = mr_manage.map_folder..mr_manage.autosave.file
mr_manage.autoload.file = mr_manage.autoload.folder..mr_manage.autoload.file
if SERVER then
	-- Create the main save folder
	if !file.Exists(mr_manage.main_folder, "DATA") then
		file.CreateDir(mr_manage.main_folder)
	end

	-- Create the current map save folder
	if !file.Exists(mr_manage.map_folder, "DATA") then
		file.CreateDir(mr_manage.map_folder)
	end

	-- Create the autoload folder
	if !file.Exists(mr_manage.autoload.folder, "DATA") then
		file.CreateDir(mr_manage.autoload.folder)
	end

	-- Set the autoload command
	local value = file.Read(mr_manage.autoload.file, "DATA")

	if value then
		RunConsoleCommand("mapret_autoload", value)
	else
		RunConsoleCommand("mapret_autoload", "")
	end

	-- Fill the load list on the server
	local files = file.Find(mr_manage.map_folder.."*", "DATA")

	for k,v in pairs(files) do
		mr_manage.load.list[v:sub(1, -5)] = mr_manage.map_folder..v
	end
end

-- Add a multiplayer delay in TOOL functions to run Material_ShouldChange() with accuracy
-- (Server)
local multiplayer_action_delay = 0
if not game.SinglePlayer() then
	multiplayer_action_delay = 0.01
end

-- I used to use the clientside player entity to store some states but it takes an almost random time to initialize and
-- was causing many syncing issues, so now these variables got moved into mr_ply
-- (Client)
local mr_ply
if CLIENT then
	local add = {
		mr_previewmode = false,
		mr_decalmode = false,
		mr_firstspawn = true,
		-- mr_dup = table (from the command bellow)
	}

	mr_ply = add

	mr_dup_set(mr_ply)
end

--------------------------------
--- FUNCTION DECLARATIONS
--------------------------------

local Ply_IsAdmin

local MML_Check
local MML_GetFreeIndex
local MML_InsertElement
local MML_GetElement
local MML_DisableElement
local MML_Clean
local MML_Count

local Data_Create
local Data_CreateFromMaterial
local Data_Get

local CVars_SetToData
local CVars_SetToDefaults

local Material_IsValid
local Material_GetOriginal
local Material_GetCurrent
local Material_GetNew
local Material_ShouldChange
local Material_Restore
local Material_RestoreAll

local Model_Material_RevertIDName
local Model_Material_GetID
local Model_Material_Create
local Model_Material_Set
local Model_Material_RemoveAll

local Map_Material_Set
local Map_Material_SetAux
local Map_Material_RemoveAll
local Map_Material_SetAll

local Decal_Toogle
local Decal_Start
local Decal_Apply
local Decal_RemoveAll

local Skybox_Apply
local Skybox_Remove
local Skybox_Render
local Skybox_Start

local Duplicator_CreateEnt
local Duplicator_SendStatusToCl
local Duplicator_SendErrorCountToCl
local Duplicator_LoadModelMaterials
local Duplicator_LoadDecals
local Duplicator_LoadMapMaterials
local Duplicator_Finish

local Preview_IsOn
local Preview_Toogle

local Save_Start
local Save_Apply
local Save_SetAuto_Start
local Save_SetAuto_Apply

local Load_Start
local Load_Apply
local Load_FillList
local Load_Delete_Start
local Load_Delete_Apply
local Load_SetAuto_Start
local Load_SetAuto_Apply
local Load_FirstSpawn

-------------------------------------
--- GENERAL
-------------------------------------

-- The tool is admin only, but can be free if the admin runs the cvar mapret_admin 0
function Ply_IsAdmin(ply)
	if ply ~= mr_dup.fake_ply and not ply:IsAdmin() and not ply:IsSuperAdmin() and GetConVar("mapret_admin"):GetString() == "1" then
		if CLIENT then
			ply:PrintMessage(HUD_PRINTTALK, "[Map Retexturizer] Sorry, this tool is set as admin only!")
		end

		return false
	end

	return true
end

-------------------------------------
--- mr_mat.map.list (MML) management
-------------------------------------

-- Check if the table is full
function MML_Check()
	-- Check upper limit
	if MML_Count() == mr_mat.map.limit then
		-- Limit reached! Try to open new spaces in the mr_mat.map.list table checking if the player removed something and cleaning the entry for real
		MML_Clean()

		-- Check again
		if MML_Count() == mr_mat.map.limit then
			if SERVER then
				PrintMessage(HUD_PRINTTALK, "[Map Retexturizer] ALERT!!! Tool's material limit reached ("..mr_mat.map.limit..")! Notify the developer for more space.")
			end

			return false
		end
	end

	return true
end

-- Get a free index
function MML_GetFreeIndex()
	local i = 1

	for k,v in pairs(mr_mat.map.list) do
		if v.oldMaterial == nil then
			break
		end
		i = i + 1
	end

	return i
end

-- Insert an element
function MML_InsertElement(data, position)
	mr_mat.map.list[position or MML_GetFreeIndex()] = data
end

-- Get an element and its index
function MML_GetElement(oldMaterial)
	for k,v in pairs(mr_mat.map.list) do
		if v.oldMaterial == oldMaterial then
			return v, k
		end
	end

	return nil
end

-- Disable an element
function MML_DisableElement(element)
	for m,n in pairs(element) do
		element[m] = nil
	end
end

-- Remove all disabled elements
function MML_Clean()
	local i = mr_mat.map.limit

	while i > 0 do
		if mr_mat.map.list[i].oldMaterial == nil then
			table.remove(mr_mat.map.list, i)
		end
		i = i - 1
	end
end

-- Table count
function MML_Count(inTable)
	local i = 0

	for k,v in pairs(inTable or mr_mat.map.list) do
		if v.oldMaterial ~= nil then
			i = i + 1
		end
	end

	return i
end

--------------------------------
--- DATA TABLES
--------------------------------

-- Set a data table
function Data_Create(ply, tr)
	local data = {
		ent = tr and tr.Entity or game.GetWorld(),
		oldMaterial = tr and Material_GetOriginal(tr) or "",
		newMaterial = ply:GetInfo("mapret_material"),
		offsetx = ply:GetInfo("mapret_offsetx"),
		offsety = ply:GetInfo("mapret_offsety"),
		scalex = ply:GetInfo("mapret_scalex") ~= "0" and ply:GetInfo("mapret_scalex") or "0.01",
		scaley = ply:GetInfo("mapret_scaley") ~= "0" and ply:GetInfo("mapret_scaley") or "0.01",
		rotation = ply:GetInfo("mapret_rotation"),
		alpha = ply:GetInfo("mapret_alpha"),
		detail = ply:GetInfo("mapret_detail"),
	}

	return data
end

-- Convert a map material into a data table
function Data_CreateFromMaterial(materialName, i)
	local theMaterial = Material(materialName)

	local scalex = theMaterial:GetMatrix("$basetexturetransform") and theMaterial:GetMatrix("$basetexturetransform"):GetScale() and theMaterial:GetMatrix("$basetexturetransform"):GetScale()[1] or "1.00"
	local scaley = theMaterial:GetMatrix("$basetexturetransform") and theMaterial:GetMatrix("$basetexturetransform"):GetScale() and theMaterial:GetMatrix("$basetexturetransform"):GetScale()[2] or "1.00"
	local offsetx = theMaterial:GetMatrix("$basetexturetransform") and theMaterial:GetMatrix("$basetexturetransform"):GetTranslation() and theMaterial:GetMatrix("$basetexturetransform"):GetTranslation()[1] or "0.00"
	local offsety = theMaterial:GetMatrix("$basetexturetransform") and theMaterial:GetMatrix("$basetexturetransform"):GetTranslation() and theMaterial:GetMatrix("$basetexturetransform"):GetTranslation()[2] or "0.00"
	local newMaterial

	local data = {
		ent = game.GetWorld(),
		oldMaterial = materialName,
		newMaterial = i and mr_mat.map.filename..tostring(i) or "",
		offsetx = string.format("%.2f", math.floor((offsetx)*100)/100),
		offsety = string.format("%.2f", math.floor((offsety)*100)/100),
		scalex = string.format("%.2f", math.ceil((1/scalex)*1000)/1000),
		scaley = string.format("%.2f", math.ceil((1/scaley)*1000)/1000),
		-- NOTE: for some reason the rotation never returns exactly the same as the one chosen by the user
		rotation = theMaterial:GetMatrix("$basetexturetransform") and theMaterial:GetMatrix("$basetexturetransform"):GetAngles() and theMaterial:GetMatrix("$basetexturetransform"):GetAngles().y or "0",
		alpha = string.format("%.2f", theMaterial:GetString("$alpha") or "1.00"),
		detail = theMaterial:GetString("$detail") and theMaterial:GetTexture("$detail"):GetName() or "None",
	}

	-- Get a valid detail key
	for k,v in pairs(mr_mat.detail.list) do
		if not isbool(v) then
			if v:GetTexture("$basetexture"):GetName() == data.detail then
				data.detail = k
			end
		end
	end

	if not mr_mat.detail.list[data.detail] then
		data.detail = "None"
	end

	return data
end

-- Set a data table with the default properties
function DataTable_CreateDefaults(ply, tr)
	local data = {
		ent = game.GetWorld(),
		oldMaterial = Material_GetCurrent(tr),
		newMaterial = ply:GetInfo("mapret_material"),
		offsetx = "0.00",
		offsety = "0.00",
		scalex = "1.00",
		scaley = "1.00",
		rotation = "0",
		alpha = "1.00",
		detail = "None",
	}

	return data
end

-- Get the data table if it exists or return nil
function Data_Get(tr)
	return IsValid(tr.Entity) and tr.Entity.modifiedmaterial or MML_GetElement(Material_GetOriginal(tr))
end

--------------------------------
--- CVARS
--------------------------------

-- Get a stored data and refresh the cvars
function CVars_SetToData(ply, data)
	if CLIENT then return; end

	--ply:ConCommand("mapret_detail "..data.detail) -- Server is not getting the right detail, only Client
	ply:ConCommand("mapret_offsetx "..data.offsetx)
	ply:ConCommand("mapret_offsety "..data.offsety)
	ply:ConCommand("mapret_scalex "..data.scalex)
	ply:ConCommand("mapret_scaley "..data.scaley)
	ply:ConCommand("mapret_rotation "..data.rotation)
	ply:ConCommand("mapret_alpha "..data.alpha)
end

-- Set the cvars to data defaults
function CVars_SetToDefaults(ply)
	--ply:ConCommand("mapret_detail ") -- Server is not getting the right detail, only Client
	ply:ConCommand("mapret_offsetx 0")
	ply:ConCommand("mapret_offsety 0")
	ply:ConCommand("mapret_scalex 1")
	ply:ConCommand("mapret_scaley 1")
	ply:ConCommand("mapret_rotation 0")
	ply:ConCommand("mapret_alpha 1")

	mr_mat.detail.element:SetValue("None")
end

--------------------------------
--- MATERIALS (GENERAL)
--------------------------------

-- Check if a given material path is valid
function Material_IsValid(material)
	-- Do not try to load nonexistent materials
	if not material or material == "" then
		return false
	end

	local fileExists = false

		--for _,v in pairs({ ".vmf", ".png", ".jpg" }) do
	for _,v in pairs({ ".vmf" }) do
		if file.Exists("materials/"..material..v, "GAME") then
			fileExists = true
		end
	end

	if not fileExists then
		-- For some reason there are map materials loaded and working but not present in the folders.
		-- I guess they are embbeded. So if the material is not considered an error, go ahead...
		if Material(material):IsError() then
			return false
		end
	end

	-- Checks
	if material == "" or
		string.find(material, "../", 1, true) or
		string.find(material, "pp/", 1, true) or
		not Material(material):GetTexture("$basetexture") or
		Material(material):IsError() and not fileExists then

		return false
	end

	-- Ok
	return true
end

-- Get the original material full path
function Material_GetOriginal(tr)
	-- Model
	if IsValid(tr.Entity) then
		return tr.Entity:GetMaterials()[1]
	-- Map
	elseif tr.Entity:IsWorld() then
		return string.Trim(tr.HitTexture):lower()
	end
end

-- Get the current material full path
function Material_GetCurrent(tr)
	local path

	-- Model
	if IsValid(tr.Entity) then
		path = tr.Entity.modifiedmaterial
		-- Get a material generated for the model
		if path then
			path = Model_Material_RevertIDName(tr.Entity.modifiedmaterial.newMaterial)
		-- Or the real thing
		else
			path = tr.Entity:GetMaterials()[1]
		end
	-- Map
	elseif tr.Entity:IsWorld() then
		local element = MML_GetElement(Material_GetOriginal(tr))

		if element then
			path = element.newMaterial
		else
			path = Material_GetOriginal(tr)
		end
	end

	return path
end

-- Get the new material from the cvar
function Material_GetNew(ply)
	return ply:GetInfo("mapret_material")
end

-- Check if the material should be replaced
function Material_ShouldChange(ply, currentDataIn, newDataIn, tr)
	local currentData = table.Copy(currentDataIn)
	local newData = table.Copy(newDataIn)
	local backup

	-- If the material is still untouched, let's get the data from the map and compare it
	if not currentData then
		local material = Material_GetCurrent(tr)

		-- If the material is invalid, we can't modify it
		if not material then
			ply:PrintMessage(HUD_PRINTTALK, "[Map Retexturizer] The material you are trying to modify has an invalid name.")

			return false
		end

		currentData = Data_CreateFromMaterial(material, 0)
		currentData.newMaterial = currentData.oldMaterial -- Force the newMaterial to be the oldMaterial
	-- Else we need to hide its internal backup
	else
		backup = currentData.backup
		currentData.backup = nil
	end

	-- Correct a model newMaterial entry for the comparision
	if IsValid(tr.Entity) then
		newData.newMaterial = Model_Material_GetID(newData)
	end

	-- Check if some property is different
	local isDifferent = false
	for k,v in pairs(currentData) do
		if v ~= newData[k] then
			isDifferent = true
			break
		end
	end

	-- Restore the internal backup
	currentData.backup = backup

	-- The material needs to be changed if data ~= data2
	if isDifferent then
		return true
	end

	-- No need for changes
	return false
end

-- Clean previous modifications:::
if SERVER then
	util.AddNetworkString("Material_Restore")
end
function Material_Restore(ent, oldMaterial)
	local isValid = false

	-- Model
	if IsValid(ent) then
		if ent.modifiedmaterial then
			if CLIENT then
				ent:SetMaterial("")
				ent:SetRenderMode(RENDERMODE_NORMAL)
				ent:SetColor(Color(255,255,255,255))
			end

			ent.modifiedmaterial = nil

			if SERVER then
				duplicator.ClearEntityModifier(ent, "MapRetexturizer_Models")
			end

			isValid = true
		end
	-- Map
	else
		if MML_Count() > 0 then
			local element = MML_GetElement(oldMaterial)

			if element then
				if CLIENT then
					Map_Material_SetAux(element.backup)
				end

				MML_DisableElement(element)

				if SERVER then
					if MML_Count() == 0 then
						if IsValid(mr_dup.entity) then
							duplicator.ClearEntityModifier(mr_dup.entity, "MapRetexturizer_Maps")
						end
					end
				end

				isValid = true
			end
		end
	end
	-- Run on client
	if isValid then
		if SERVER then
			net.Start("Material_Restore")
				net.WriteEntity(ent)
				net.WriteString(oldMaterial)
			net.Broadcast()
		end

		return true
	end

	return false
end
if CLIENT then
	net.Receive("Material_Restore", function()
		Material_Restore(net.ReadEntity(), net.ReadString())
	end)
end

-- Clean up everything
function Material_RestoreAll(ply, plyLoadingStatus)
	if CLIENT then return; end

	-- Admin only
	if not Ply_IsAdmin(ply) then
		return false
	end

	-- Don't start a cleaning process if we are stopping a loading
	if not mr_dup.force_stop then
		-- Force to stop any loading
		local delay = 0

		if Duplicator_ForceStop(plyLoadingStatus) then
			delay = 0.4
		end

		-- cleanup
		timer.Create("MapRetMaterialCleanupDelay"..tostring(math.random(999))..tostring(ply), delay, 1, function()
			Model_Material_RemoveAll(ply)
			Map_Material_RemoveAll(ply)
			Decal_RemoveAll(ply)
			Skybox_Remove(ply)

			-- Reset the force stop var (It was set true in Duplicator_ForceStop())
			mr_dup.force_stop = false
		end)
	end
end
if SERVER then
	util.AddNetworkString("Material_RestoreAll")

	net.Receive("Material_RestoreAll", function(_,ply)
		Material_RestoreAll(ply, net.ReadBool())
	end)

	concommand.Add("mapret_remote_cleanup", function()
		Material_RestoreAll(mr_dup.fake_ply, true)

		PrintMessage(HUD_PRINTTALK, "[Map Retexturizer] Console: cleaning modifications...")
		print("[Map Retexturizer] Console: cleaning modifications...")
	end)
end

--------------------------------
--- MATERIALS (MODELS)
--------------------------------

-- Get the old "newMaterial" from a unique model material name generated by this tool
function Model_Material_RevertIDName(materialID)
	local parts = string.Explode("-=+", materialID)
	local result

	if parts then
		result = parts[2]
	end

	return result
end

-- Generate the material unique id
function Model_Material_GetID(data)
	if SERVER then return; end

	local materialID = ""

	-- SortedPairs so the order will be always the same
	for k,v in SortedPairs(data) do
		-- Remove the ent to avoid creating the same material later
		if v ~= data.ent then
			-- Separate the ID Generator (newMaterial) inside a "-=+" box
			if isstring(v) then
				if v == data.newMaterial then
					v = "-=+"..v.."-=+"
				end
			-- Round if it's a number
			elseif isnumber(v) then
				v = math.Round(v)
			end

			-- Generating...
			materialID = materialID..tostring(v)
		end
	end

	-- Remove problematic chars
	materialID = materialID:gsub(" ", "")
	materialID = materialID:gsub("%.", "")

	return materialID
end

-- Create a new model material (if it doesn't exist yet) and return its unique new name
function Model_Material_Create(data)
	local materialID = Model_Material_GetID(data)

	if CLIENT then
		-- Create the material if it's necessary
		if not mr_mat.model.list[materialID] then
			-- Basic info
			local material = {
				["$basetexture"] = data.newMaterial,
				["$vertexalpha"] = 0,
				["$vertexcolor"] = 1,
			}

			-- Create matrix
			local matrix = Matrix()

			matrix:SetAngles(Angle(0, data.rotation, 0)) -- Rotation
			matrix:Scale(Vector(1/data.scalex, 1/data.scaley, 1)) -- Scale
			matrix:Translate(Vector(data.offsetx, data.offsety, 0)) -- Offset

			-- Create material
			local newMaterial

			mr_mat.model.list[materialID] = CreateMaterial(materialID, "VertexLitGeneric", material)
			mr_mat.model.list[materialID]:SetTexture("$basetexture", Material(data.newMaterial):GetTexture("$basetexture"))
			newMaterial = mr_mat.model.list[materialID]

			-- Apply detail
			if data.detail ~= "None" then
				if mr_mat.detail.list[data.detail] then
					newMaterial:SetTexture("$detail", mr_mat.detail.list[data.detail]:GetTexture("$basetexture"))
					newMaterial:SetString("$detailblendfactor", "1")
				else
					newMaterial:SetString("$detailblendfactor", "0")
				end
			else
				newMaterial:SetString("$detailblendfactor", "0")
			end

			-- Try to apply Bumpmap ()
			local bumpmapPath = data.newMaterial .. "_normal" -- checks for a file placed with the model (named like mymaterial_normal.vtf)
			local bumpmap = Material(data.newMaterial):GetTexture("$bumpmap") -- checks for a copied material active bumpmap

			if file.Exists("materials/"..bumpmapPath..".vtf", "GAME") then
				if not mr_mat.model.list[bumpmapPath] then
					mr_mat.model.list[bumpmapPath] = CreateMaterial(bumpmapPath, "VertexLitGeneric", {["$basetexture"] = bumpmapPath})
				end
				newMaterial:SetTexture("$bumpmap", mr_mat.model.list[bumpmapPath]:GetTexture("$basetexture"))
			elseif bumpmap then
				newMaterial:SetTexture("$bumpmap", bumpmap)
			end

			-- Apply matrix
			newMaterial:SetMatrix("$basetexturetransform", matrix)
			newMaterial:SetMatrix("$detailtexturetransform", matrix)
			newMaterial:SetMatrix("$bumptransform", matrix)
		end
	end

	return materialID
end

-- Set model material:::
if SERVER then
	util.AddNetworkString("Model_Material_Set")
end
function Model_Material_Set(data)
	if not IsValid(data.ent) then return end

	if SERVER then
		-- Send the modification to every player
		net.Start("Model_Material_Set")
			net.WriteTable(data)
		net.Broadcast()

		-- Set the duplicator
		duplicator.StoreEntityModifier(data.ent, "MapRetexturizer_Models", data)
	end

	-- Create a material
	local materialID = Model_Material_Create(data)

	-- Changes the new material for the created new one
	data.newMaterial = materialID

	-- Indicate that the model got modified by this tool
	data.ent.modifiedmaterial = data

	-- Set the alpha
	data.ent:SetRenderMode(RENDERMODE_TRANSALPHA)
	data.ent:SetColor(Color(255,255,255,255*data.alpha))

	if CLIENT then
		-- Apply the material
		data.ent:SetMaterial("!"..materialID)
	end
end
if CLIENT then
	net.Receive("Model_Material_Set", function()
		Model_Material_Set(net.ReadTable())
	end)
end

-- Remove all modified model materials
function Model_Material_RemoveAll(ply)
	if CLIENT then return; end

	-- Admin only
	if not Ply_IsAdmin(ply) then
		return false
	end

	for k,v in pairs(ents.GetAll()) do
		if IsValid(v) then
			Material_Restore(v, "")
		end
	end
end
if SERVER then
	util.AddNetworkString("Model_Material_RemoveAll")

	net.Receive("Model_Material_RemoveAll", function(_,ply)
		Model_Material_RemoveAll(ply)
	end)
end

--------------------------------
--- MATERIALS (MAPS)
--------------------------------

-- Set map material:::
if SERVER then
	util.AddNetworkString("Map_Material_Set")
end
function Map_Material_Set(ply, data)
	-- Note: if data has a backup we need to restore it, otherwise let's just do the normal stuff

	-- Force to skip bad materials (sometimes it happens, so let's just avoid the script errors)
	if not data.oldMaterial then
		print("[MAP RETEXTURIZER] Map_Material_Set() received a bad material. Skipping it...")

		return
	end

	-- Set the backup:
	-- Olny register the modifications if they are being made by a player not in the first spawn or
	-- a player in the first spawn and initializing the materials on the serverside
	if CLIENT or SERVER and not ply.mr_firstSpawn or SERVER and ply.mr_firstSpawn and ply.mr_mat_initializing then
		 -- Duplicator check
		local isNewMaterial = false

		if SERVER then
			if not data.backup then
				isNewMaterial = true
			end
		end

		local i
		local element = MML_GetElement(data.oldMaterial)

		-- If we are modifying an already modified material
		if element then
			-- Create an entry in the material Data poiting to the backup data
			data.backup = element.backup

			-- Cleanup
			MML_DisableElement(element)
			Map_Material_SetAux(data.backup)

			-- Get a mr_mat.map.list free index
			i = MML_GetFreeIndex()
		-- If the material is untouched
		else
			-- Get a mr_mat.map.list free index
			i = MML_GetFreeIndex()

			-- Get the current material info (It's only going to be data.backup if we are running the duplicator)
			local dataBackup = data.backup or Data_CreateFromMaterial(data.oldMaterial, i)

			-- Save the material texture
			Material(dataBackup.newMaterial):SetTexture("$basetexture", Material(dataBackup.oldMaterial):GetTexture("$basetexture"))

			-- Create an entry in the material Data poting to the new backup Data (data.backup will shows itself already done only if we are running the duplicator)
			if not data.backup then
				data.backup = dataBackup
			end
		end

		-- Index the Data
		MML_InsertElement(data, i)

		-- Apply the new state to the map material
		Map_Material_SetAux(data)

		if SERVER then
			-- Set the duplicator
			if isNewMaterial then
				duplicator.StoreEntityModifier(mr_dup.entity, "MapRetexturizer_Maps", mr_mat.map.list)
			end
		end
	end

	if SERVER then
		-- Send the modification to every player
		if not ply.mr_firstSpawn then
			net.Start("Map_Material_Set")
				net.WriteTable(data)
				net.WriteBool(true)
			net.Broadcast()
		-- Or for a single player
		else
			net.Start("Map_Material_Set")
				net.WriteTable(data)
				net.WriteBool(false)
			net.Send(ply)
		end
	end
end
if CLIENT then
	net.Receive("Map_Material_Set", function()
		local ply = LocalPlayer()
		local theTable = net.ReadTable()
		local isBroadcasted = net.ReadBool()

		-- Block the changes if it's a new player joining in the middle of a loading. He'll have his own load.
		if mr_ply.mr_firstSpawn and isBroadcasted then
			return
		end

		Map_Material_Set(ply, theTable)
	end)
end

-- Copy "all" the data from a material to another (auxiliar to Map_Material_Set())
function Map_Material_SetAux(data)
	if SERVER then return; end

	-- Get the materials
	local oldMaterial = Material(data.oldMaterial)
	local newMaterial = Material(data.newMaterial)

	-- Apply the base texture
	oldMaterial:SetTexture("$basetexture", newMaterial:GetTexture("$basetexture"))
--[[
	-- It's better to not support
	if not newMaterial:IsError() then -- If the file is a .vmt
		oldMaterial:SetTexture("$basetexture", newMaterial:GetTexture("$basetexture"))
	else
		oldMaterial:SetTexture("$basetexture", data.newMaterial)
	end
]]

	-- Alpha stuff
	oldMaterial:SetString("$translucent", "1")
	oldMaterial:SetString("$alpha", data.alpha)

	-- Apply the matrix
	local texture_matrix = oldMaterial:GetMatrix("$basetexturetransform")

	texture_matrix:SetAngles(Angle(0, data.rotation, 0))
	texture_matrix:SetScale(Vector(1/data.scalex, 1/data.scaley, 1))
	texture_matrix:SetTranslation(Vector(data.offsetx, data.offsety))
	oldMaterial:SetMatrix("$basetexturetransform", texture_matrix)

	-- Apply the detail
	if data.detail ~= "None" then
		oldMaterial:SetTexture("$detail", mr_mat.detail.list[data.detail]:GetTexture("$basetexture"))
		oldMaterial:SetString("$detailblendfactor", "1")
	else
		oldMaterial:SetString("$detailblendfactor", "0")
		oldMaterial:SetString("$detail", "")
		oldMaterial:Recompute()
	end

	--[[
	-- Old tests that I want to keep here
	mapMaterial:SetTexture("$bumpmap", Material(data.newMaterial):GetTexture("$basetexture"))
	mapMaterial:SetString("$nodiffusebumplighting", "1")
	mapMaterial:SetString("$normalmapalphaenvmapmask", "1")
	mapMaterial:SetVector("$color", Vector(100,100,0))
	mapMaterial:SetString("$surfaceprop", "Metal")
	mapMaterial:SetTexture("$detail", Material(data.oldMaterial):GetTexture("$basetexture"))
	mapMaterial:SetMatrix("$detailtexturetransform", texture_matrix)
	mapMaterial:SetString("$detailblendfactor", "0.2")
	mapMaterial:SetString("$detailblendmode", "3")
	]]--
end

function Map_Material_SetAll(ply)
	if CLIENT then return; end

	-- Admin only
	if not Ply_IsAdmin(ply) then
		return false
	end

	-- Create the duplicator entity used to restore map materials, decals and skybox
	if SERVER then
		Duplicator_CreateEnt()
	end

	-- Check upper limit
	if not MML_Check() then
		return false
	end

	-- Get the material
	local material = ply:GetInfo("mapret_material")

	-- Don't apply bad materials
	if not Material_IsValid(material) then
		if SERVER then
			ply:PrintMessage(HUD_PRINTTALK, "[Map Retexturizer] Bad material.")
		end

		return false
	end

	-- Register that the map is manually modified
	if not mr_mat.initialized then
		mr_mat.initialized = true
	end

	-- Clean the map
	Material_RestoreAll(ply, true)

	timer.Create("MapRetChangeAllDelay"..tostring(math.random(999))..tostring(ply), 0.5, 1, function()
		-- Create a fake loading table
		local newTable = {}
		local map = {}

		for k, v in pairs (game.GetWorld():GetMaterials()) do
			local data = Data_Create(ply)

			-- Ignore water
			if not string.find(v, "water") then
				data.oldMaterial = v
				data.newMaterial = material

				table.insert(map, data)
			end
		end

		newTable.map = map

		-- Apply the fake load
		Load_Apply(ply, newTable)
	end)
end
if CLIENT then
	-- Set all materials (with confirmation box)
	concommand.Add("mapret_changeall", function()

	local qPanel = vgui.Create( "DFrame" )
		qPanel:SetTitle( "Loading Confirmation" )
		qPanel:SetSize( 284, 95 )
		qPanel:SetPos( 10, 10 )
		qPanel:SetDeleteOnClose( true )
		qPanel:SetVisible( true )
		qPanel:SetDraggable( true )
		qPanel:ShowCloseButton( true )
		qPanel:MakePopup( true )
		qPanel:Center()

	local text = vgui.Create( "DLabel", qPanel )
		text:SetPos( 10, 25 )
		text:SetSize( 300, 25)
		text:SetText( "Are you sure you want to change all the map materials?" )

	local buttonYes = vgui.Create( "DButton", qPanel )
		buttonYes:SetPos( 24, 50 )
		buttonYes:SetText( "Yes" )
		buttonYes:SetSize( 120, 30 )
		buttonYes.DoClick = function()
			net.Start("Map_Material_SetAll")
			net.SendToServer()
			qPanel:Close()
		end

	local buttonNo = vgui.Create( "DButton", qPanel )
		buttonNo:SetPos( 144, 50 )
		buttonNo:SetText( "No" )
		buttonNo:SetSize( 120, 30 )
		buttonNo.DoClick = function()
			qPanel:Close()
		end
	end)
else
	util.AddNetworkString("Map_Material_SetAll")

	net.Receive("Map_Material_SetAll", function(_,ply)
		Map_Material_SetAll(ply)
	end)
end

-- Remove all modified map materials
function Map_Material_RemoveAll(ply)
	if CLIENT then return; end

	-- Admin only
	if not Ply_IsAdmin(ply) then
		return false
	end

	if MML_Count() > 0 then
		for k,v in pairs(mr_mat.map.list) do
			if v.oldMaterial ~=nil then
				Material_Restore(nil, v.oldMaterial)
			end
		end
	end
end
if SERVER then
	util.AddNetworkString("Map_Material_RemoveAll")

	net.Receive("Map_Material_RemoveAll", function(_,ply)
		Map_Material_RemoveAll(ply)
	end)
end

--------------------------------
--- MATERIALS (DECALS)
--------------------------------

-- Toogle the decal mode for a player
function Decal_Toogle(ply, value)
	if SERVER then return; end

	mr_ply.mr_decalmode = value

	net.Start("MapRetToogleDecal")
		net.WriteBool(value)
	net.SendToServer()
end
if SERVER then
	util.AddNetworkString("MapRetToogleDecal")

	net.Receive("MapRetToogleDecal", function(_, ply)
		ply.mr_decalmode = net.ReadBool()
	end)
end

-- Apply decal materials:::
function Decal_Start(ply, tr, duplicatorData)
	local mat = tr and Material_GetNew(ply) or duplicatorData.mat

	-- Don't apply bad materials
	if not Material_IsValid(mat) then
		if SERVER then
			ply:PrintMessage(HUD_PRINTTALK, "[Map Retexturizer] Bad material.")
		end

		return false
	end

	-- Ok for client
	if CLIENT then
		return true
	end

	-- Get the basic properties
	local ent = tr and tr.Entity or duplicatorData.ent
	local pos = tr and tr.HitPos or duplicatorData.pos
	local hit = tr and tr.HitNormal or duplicatorData.hit

	-- Register and duplicator:
	-- Olny register the modifications if they are being made by a player not in the first spawn or
	-- a player in the first spawn and initializing the materials on the serverside
	if not ply.mr_firstSpawn or ply.mr_firstSpawn and ply.mr_mat_initializing then
		table.insert(mr_mat.decal.list, {ent = ent, pos = pos, hit = hit, mat = mat})

		duplicator.StoreEntityModifier(mr_dup.entity, "MapRetexturizer_Decals", mr_mat.decal.list)
	end

	-- Send to all players
	if not ply.mr_firstSpawn then
		net.Start("Decal_Apply")
			net.WriteString(mat)
			net.WriteEntity(ent)
			net.WriteVector(pos)
			net.WriteVector(hit)
			net.WriteBool(true)
		net.Broadcast()
	-- Or for a single player
	else
		net.Start("Decal_Apply")
			net.WriteString(mat)
			net.WriteEntity(ent)
			net.WriteVector(pos)
			net.WriteVector(hit)
			net.WriteBool(false)
		net.Send(ply)
	end

	return true
end

-- Create decal materials
function Decal_Apply(materialPath, ent, pos, normal)
	if SERVER then return; end

	-- Create the material
	local decalMaterial = mr_mat.decal.list[materialPath.."2"]

	if not decalMaterial then
		decalMaterial = CreateMaterial(materialPath.."2", "LightmappedGeneric", {["$basetexture"] = materialPath})
		decalMaterial:SetInt("$decal", 1)
		decalMaterial:SetInt("$translucent", 1)
		decalMaterial:SetFloat("$decalscale", 1.00)
		decalMaterial:SetTexture("$basetexture", Material(materialPath):GetTexture("$basetexture"))
	end

	-- Apply the decal
	-- Notes:
	-- Vertical normals don't work
	-- Resizing doesn't work (width x height)
	util.DecalEx(decalMaterial, ent, pos, normal, Color(255,255,255,255), decalMaterial:Width(), decalMaterial:Height())
end
if SERVER then
	util.AddNetworkString("Decal_Apply")
end
if CLIENT then
	net.Receive("Decal_Apply", function()
		local ply = LocalPlayer()
		local material = net.ReadString()
		local entity = net.ReadEntity()
		local position = net.ReadVector()
		local normal = net.ReadVector()
		local isBroadcasted = net.ReadBool()

		-- Block the changes if it's a new player joining in the middle of a loading. He'll have his own load.
		if mr_ply.mr_firstSpawn and isBroadcasted then
			return
		end

		-- Material, entity, position, normal, color, width and height
		Decal_Apply(material, entity, position, normal)
	end)
end

-- Remove all decals
function Decal_RemoveAll(ply)
	if CLIENT then return; end

	-- Admin only
	if not Ply_IsAdmin(ply) then
		return false
	end

	for k,v in pairs(player.GetAll()) do
		if v:IsValid() then
			v:ConCommand("r_cleardecals")
		end
	end
	table.Empty(mr_mat.decal.list)
	duplicator.ClearEntityModifier(mr_dup.entity, "MapRetexturizer_Decals")
end
if SERVER then
	util.AddNetworkString("Decal_RemoveAll")

	net.Receive("Decal_RemoveAll", function(_, ply)
		Decal_RemoveAll(ply)
	end)
end

--------------------------------
--- SKYBOX MATERIAL
--------------------------------

-- Change the skybox
function Skybox_Start(ply, value)
	if SERVER then return; end

	net.Start("MapRetSkybox")
		net.WriteString(value)
	net.SendToServer()
end
function Skybox_Apply(ply, mat)
	if CLIENT then return; end

	-- Admin only
	if not Ply_IsAdmin(ply) then
		return false
	end

	-- Create the duplicator entity if it's necessary
	Duplicator_CreateEnt()

	-- Set the duplicator
	duplicator.StoreEntityModifier(mr_dup.entity, "MapRetexturizer_Skybox", { skybox = mat })

	-- Apply the material to every client
	RunConsoleCommand("mapret_skybox", mat)
end
if SERVER then
	util.AddNetworkString("MapRetSkybox")

	net.Receive("MapRetSkybox", function(_, ply)
		Skybox_Apply(ply, net.ReadString())
	end)
end

-- Material rendering
if CLIENT then
	local distance = 200
	local width = distance * 2
	local height = distance * 2

	-- Skybox extra layer rendering
	local function Skybox_Render()
		local mat = GetConVar("mapret_skybox"):GetString()

		-- Check if it's empty
		if mat ~= "" then
			local suffixes
			local aux = { "ft", "bk", "lf", "rt", "up", "dn" }

			-- If we aren't using a HL2 sky we need to check what is going on
			if not mr_mat.skybox.hl2_list[mat] then
				-- Check if the material is valid
				if not Material_IsValid(mat) and not Material_IsValid(mat.."ft") then
					-- Nope
					return
				else
					-- Check if a valid 6 side skybox
					for k, v in pairs(aux) do
						if not Material_IsValid(mat..v) then
							-- If it's not a full skybox, it's a valid single material
							suffixes = { "", "", "", "", "", "" }
							break
						end
					end
				end

				-- It's a valid full skybox
				if not suffixes then
					suffixes = aux
				end
			else
				suffixes = aux
			end

			-- Render our sky layer
			render.OverrideDepthEnable(true, false)
			render.SetLightingMode(2)
			cam.Start3D(Vector(0, 0, 0), EyeAngles())
				render.SetMaterial(Material(mat..suffixes[1]))
				render.DrawQuadEasy(Vector(-distance,0,0), Vector(1,0,0), width, height, Color(255,255,255,255), 180)
				render.SetMaterial(Material(mat..suffixes[2]))
				render.DrawQuadEasy(Vector(distance,0,0), Vector(-1,0,0), width, height, Color(255,255,255,255), 180)
				render.SetMaterial(Material(mat..suffixes[3]))
				render.DrawQuadEasy(Vector(0,distance,0), Vector(0,-1,0), width, height, Color(255,255,255,255), 180)
				render.SetMaterial(Material(mat..suffixes[4]))
				render.DrawQuadEasy(Vector(0,-distance,0), Vector(0,1,0), width, height, Color(255,255,255,255), 180)
				render.SetMaterial(Material(mat..suffixes[5]))
				render.DrawQuadEasy(Vector(0,0,distance), Vector(0,0,-1), width, height, Color(255,255,255,255), 90)
				render.SetMaterial(Material(mat..suffixes[6]))
				render.DrawQuadEasy(Vector(0,0,-distance), Vector(0,0,1), width, height, Color(255,255,255,255), 180)
			cam.End3D()
			render.OverrideDepthEnable(false, false)
			render.SetLightingMode(0)
		end
	end

	hook.Add("PostDraw2DSkyBox", "MapRetSkyboxLayer", function()
		Skybox_Render()
	end)
end

-- Remove all decals
function Skybox_Remove(ply)
	if CLIENT then return; end

	-- Admin only
	if not Ply_IsAdmin(ply) then
		return false
	end

	RunConsoleCommand("mapret_skybox", "")

	duplicator.ClearEntityModifier(mr_dup.entity, "MapRetexturizer_Skybox")
end
if SERVER then
	util.AddNetworkString("Skybox_Remove")

	net.Receive("Skybox_Remove", function(_, ply)
		Skybox_Remove(ply)
	end)
end

--------------------------------
--- DUPLICATOR
--------------------------------

-- Models and decals must be processed first than the map.

-- Set the duplicator
function Duplicator_CreateEnt(ent)
	if CLIENT then return; end

	-- Hide/Disable our entity after a duplicator
	if not mr_dup.hidden and ent then
		mr_dup.entity = ent
		mr_dup.entity:SetNoDraw(true)
		mr_dup.entity:SetSolid(0)
		mr_dup.entity:PhysicsInitStatic(SOLID_NONE)
		mr_dup.hidden = true
	-- Create a new entity if we don't have one yet
	elseif not IsValid(mr_dup.entity) and not ent then
		mr_dup.entity = ents.Create("prop_physics")
		mr_dup.entity:SetModel("models/props_phx/cannonball_solid.mdl")
		mr_dup.entity:SetPos(Vector(0, 0, 0))
		mr_dup.entity:SetNoDraw(true)
		mr_dup.entity:Spawn()
		mr_dup.entity:SetSolid(0)
		mr_dup.entity:PhysicsInitStatic(SOLID_NONE)
	end
end

-- Function to send the duplicator state to the client(s)
function Duplicator_SendStatusToCl(ply, current, total, section, resetValues)
	if CLIENT then return; end

	-- Reset the counting
	if resetValues then
		Duplicator_SendStatusToCl(ply, 0, 0, "")
	end

	-- Update every client
	if not ply.mr_firstSpawn then
		net.Start("MapRetUpdateDupProgress")
			net.WriteInt(current or -1, 14)
			net.WriteInt(total or -1, 14)
			net.WriteString(section or "-1")
			net.WriteBool(true)
		net.Broadcast()
	-- Or a single client
	else
		net.Start("MapRetUpdateDupProgress")
			net.WriteInt(current or -1, 14)
			net.WriteInt(total or -1, 14)
			net.WriteString(section or "-1")
			net.WriteBool(false)
		net.Send(ply)
	end
end
if SERVER then
	util.AddNetworkString("MapRetUpdateDupProgress")
else
	-- Updates the duplicator progress in the client
	net.Receive("MapRetUpdateDupProgress", function()
		local a, b, c = net.ReadInt(14), net.ReadInt(14), net.ReadString()
		local ply = LocalPlayer()
		local isBroadcasted = net.ReadBool()

		-- Block the changes if it's a new player joining in the middle of a loading. He'll have his own load.
		if mr_ply.mr_firstSpawn and isBroadcasted then
			return
		end

		-- Update the dup state
		if c != "-1" then
			mr_ply.mr_dup.run = c
		end

		if a ~= -1 then
			mr_ply.mr_dup.count.current = a
		end

		if b ~= -1 then
			mr_ply.mr_dup.count.total = b
		end
	end)
end

-- If any errors are found
function Duplicator_SendErrorCountToCl(ply, count, material)
	if CLIENT then return; end

	-- Send the status all players
	if not ply.mr_firstSpawn then
		net.Start("MapRetUpdateDupErrorCount")
			net.WriteInt(count or 0, 14)
			net.WriteString(material or "")
			net.WriteBool(true)
		net.Broadcast()
	-- Or for a single player
	else
		net.Start("MapRetUpdateDupErrorCount")
			net.WriteInt(count or 0, 14)
			net.WriteString(material or "")
			net.WriteBool(false)
		net.Send(ply)
	end
end
if SERVER then
	util.AddNetworkString("MapRetUpdateDupErrorCount")
else
	-- Error printing in the console
	net.Receive("MapRetUpdateDupErrorCount", function()
		local count = net.ReadInt(14)
		local mat = net.ReadString()
		local isBroadcasted = net.ReadBool()

		-- Block the changes if it's a new player joining in the middle of a loading. He'll have his own load.
		if mr_ply.mr_firstSpawn and isBroadcasted then
			return
		end

		-- Set the error count
		mr_ply.mr_dup.count.errors.n = count

		-- Get the missing material name
		if mr_ply.mr_dup.count.errors.n > 0 then
			table.insert(mr_ply.mr_dup.count.errors.list, mat)
		-- Print the failed materials table
		else
			if table.Count(mr_ply.mr_dup.count.errors.list)> 0 then
				LocalPlayer():PrintMessage(HUD_PRINTTALK, "[Map Retexturizer] Check the terminal for the errors.")
				print("")
				print("-------------------------------------------------------------")
				print("[MAP RETEXTURIZER] - Failed to load these files:")
				print("-------------------------------------------------------------")
				print(table.ToString(mr_ply.mr_dup.count.errors.list, "Missing Materials ", true))
				print("-------------------------------------------------------------")
				print("")
				table.Empty(mr_ply.mr_dup.count.errors.list)
			end
		end
	end)
end

-- Load model materials from saves (Models spawn almost at the same time, so my strange timers work nicelly)
function Duplicator_LoadModelMaterials(ply, ent, savedTable)
	if CLIENT then return; end

	-- Check if client is valid
	if IsEntity(ply) then
		if not ply:IsValid() then
			return
		end
	end

	-- First cleanup
	if not mr_dup.clean then
		mr_dup.clean = true
		Material_RestoreAll(ply)
	end

	-- Register that we have model materials to duplicate and count elements
	if not mr_dup.has.models then
		mr_dup.has.models = true
		ply.mr_dup.run = "models"
		Duplicator_SendStatusToCl(ply, nil, nil, "Model Materials")
	end

	-- Set the aditive delay time
	mr_dup.models.delay = mr_dup.models.delay + 0.1

	-- Change the stored entity to the actual one
	savedTable.ent = ent

	-- Get the max delay time
	if mr_dup.models.delay > mr_dup.models.max_delay then
		mr_dup.models.max_delay = mr_dup.models.delay
	end

	-- Count 1
	ply.mr_dup.count.total = ply.mr_dup.count.total + 1
	Duplicator_SendStatusToCl(ply, nil, ply.mr_dup.count.total)

	timer.Create("MapRetDuplicatorMapMatWaiting"..tostring(mr_dup.models.delay)..tostring(ply), mr_dup.models.delay, 1, function()
		-- Count 2
		ply.mr_dup.count.current = ply.mr_dup.count.current + 1
		Duplicator_SendStatusToCl(ply, ply.mr_dup.count.current)

		-- Check if the material is valid
		local isValid = Material_IsValid(savedTable.newMaterial)

		-- Apply the model material
		if isValid then
			Model_Material_Set(savedTable)
		-- Or register an error
		else
			ply.mr_dup.count.errors.n = ply.mr_dup.count.errors.n + 1
			Duplicator_SendErrorCountToCl(ply, ply.mr_dup.count.errors.n, savedTable.newMaterial)
		end

		-- No more entries. Set the next duplicator section to run if it's active and try to reset variables
		if mr_dup.models.delay == mr_dup.models.max_delay then
			ply.mr_dup.run = "decals"
			mr_dup.has.models = false
			Duplicator_Finish(ply)
		end
	end)
end
duplicator.RegisterEntityModifier("MapRetexturizer_Models", Duplicator_LoadModelMaterials)

-- Load map materials from saves
function Duplicator_LoadDecals(ply, ent, savedTable, position, forceCheck)
	if CLIENT then return; end

	-- Check if client is valid
	if IsEntity(ply) then
		if not ply:IsValid() then
			return
		end
	end

	-- Force check
	if forceCheck and not mr_dup.has.models then
		ply.mr_dup.run = "decals"
	end

	-- Register that we have decals to duplicate
	if not ply.mr_dup.has.decals then
		ply.mr_dup.has.decals = true
	end

	if ply.mr_dup.run == "decals" then
		-- First cleanup
		if not mr_dup.clean then
			if not ply.mr_firstSpawn then
				mr_dup.clean = true
				Material_RestoreAll(ply)
				timer.Create("MapRetDuplicatorDecalsWaitCleanup", 1, 1, function()
					Duplicator_LoadDecals(ply, ent, savedTable)
				end)

				return
			end
		end

		-- Fix the duplicator generic spawn entity
		if not mr_dup.hidden then
			Duplicator_CreateEnt(ent)
		end

		if not position then
			-- Set the first position
			position = 1

			-- Set the counting
			ply.mr_dup.count.total = table.Count(savedTable)
			ply.mr_dup.count.current = 0

			-- Update the client
			Duplicator_SendStatusToCl(ply, nil, ply.mr_dup.count.total, "Decals", true)
		end

		-- Apply decal
		Decal_Start(ply, nil, savedTable[position])

		-- Count
		ply.mr_dup.count.current = ply.mr_dup.count.current + 1
		Duplicator_SendStatusToCl(ply, ply.mr_dup.count.current)

		-- Next material
		position = position + 1
		if savedTable[position] and not mr_dup.force_stop then
			timer.Create("MapRetDuplicatorDecalDelay"..tostring(ply), 0.1, 1, function()
				Duplicator_LoadDecals(ply, nil, savedTable, position)
			end)
		-- No more entries. Set the next duplicator section to run if it's active and try to reset variables
		else
			ply.mr_dup.run = "map"
			ply.mr_dup.has.decals = false
			Duplicator_Finish(ply)
		end
	else
		-- Keep waiting
		timer.Create("MapRetDuplicatorDecalWaitModelsDelay"..tostring(ply), 0.3, 1, function()
			Duplicator_LoadDecals(ply, ent, savedTable, nil, true)
		end)
	end
end
duplicator.RegisterEntityModifier("MapRetexturizer_Decals", Duplicator_LoadDecals)

-- Load map materials from saves
function Duplicator_LoadMapMaterials(ply, ent, savedTable, position, forceCheck)
	if CLIENT then return; end

	-- Check if client is valid
	if IsEntity(ply) then
		if not ply:IsValid() then
			return
		end
	end

	-- Force check
	if forceCheck and (not mr_dup.has.models and not ply.mr_dup.has.decals) then
		ply.mr_dup.run = "map"
	end

	-- Register that we have map materials to duplicate
	if not ply.mr_dup.has.map then
		ply.mr_dup.has.map = true
	end

	if ply.mr_dup.run == "map" then
		-- First cleanup
		if not mr_dup.clean then
			if not ply.mr_firstSpawn then
				mr_dup.clean = true
				Material_RestoreAll(ply)
				timer.Create("MapRetDuplicatorMapMatWaitCleanup", 1, 1, function()
					Duplicator_LoadMapMaterials(ply, ent, savedTable)
				end)

				return
			end
		end

		-- Fix the duplicator generic spawn entity
		if not mr_dup.hidden then
			Duplicator_CreateEnt(ent)
		end

		if not position then
			-- Set the first position
			position = 1

			-- Set the counting
			ply.mr_dup.count.total = MML_Count(savedTable)
			ply.mr_dup.count.current = 0

			-- Update the client
			Duplicator_SendStatusToCl(ply, nil, ply.mr_dup.count.total, "Map Materials", true)
		end

		-- Check if we have a valid entry
		if savedTable[position] and not mr_dup.force_stop then
			-- Yes. Is it an INvalid entry?
			if savedTable[position].oldMaterial == nil then
				-- Yes. Let's check the next entry
				Duplicator_LoadMapMaterials(ply, nil, savedTable, position + 1)

				return
			end
			-- No. Let's apply the changes
		-- No more entries. And because it's the last duplicator section, just reset the variables
		else
			ply.mr_dup.has.map = false
			Duplicator_Finish(ply)

			return
		end

		-- Count
		ply.mr_dup.count.current = ply.mr_dup.count.current + 1
		Duplicator_SendStatusToCl(ply, ply.mr_dup.count.current)

		-- Check if the material is valid
		local isValid = Material_IsValid(savedTable[position].newMaterial)

		-- Apply the map material
		if isValid then
			Map_Material_Set(ply, savedTable[position])
		-- Or register an error
		else
			ply.mr_dup.count.errors.n = ply.mr_dup.count.errors.n + 1
			Duplicator_SendErrorCountToCl(ply, ply.mr_dup.count.errors.n, savedTable[position].newMaterial)
		end

		-- Next material
		timer.Create("MapRetDuplicatorMapMatDelay"..tostring(ply), 0.1, 1, function()
			Duplicator_LoadMapMaterials(ply, nil, savedTable, position + 1)
		end)
	else
		-- Keep waiting
		timer.Create("MapRetDuplicatorMapMatWaitDecalsDelay"..tostring(ply), 0.3, 1, function()
			Duplicator_LoadMapMaterials(ply, ent, savedTable, nil, true)
		end)
	end
end
duplicator.RegisterEntityModifier("MapRetexturizer_Maps", Duplicator_LoadMapMaterials)

-- Load the skybox
function Duplicator_LoadSkybox(ply, ent, savedTable)
	if CLIENT then return; end

	-- This timer is only for good aesthetics on loading
	timer.Create("MapRetDuplicatorSkyboxWait", 2.5, 1, function()
		-- Check if client is valid
		if IsEntity(ply) then
			if not ply:IsValid() then
				return
			end
		end

		Skybox_Apply(ply, savedTable.skybox)
	end)
end
duplicator.RegisterEntityModifier("MapRetexturizer_Skybox", Duplicator_LoadSkybox)

-- Render duplicator progress bar based on the ply.mr_dup.count numbers
if CLIENT then
	function Duplicator_RenderProgress(ply)
		if mr_ply.mr_dup then
			if mr_ply.mr_dup.count.total > 0 and mr_ply.mr_dup.count.current > 0 then
				local x, y, w, h = 25, ScrH()/2 + 200, 200, 20

				surface.SetDrawColor(0, 0, 0, 255)
				surface.DrawOutlinedRect(x, y, w, h)

				surface.SetDrawColor(200, 0, 0, 255)
				surface.DrawRect(x + 1.2, y + 1.2, w * (mr_ply.mr_dup.count.current / mr_ply.mr_dup.count.total) - 2, h - 2)

				surface.SetDrawColor(0, 0, 0, 150)
				surface.DrawRect(x + 1.2, y - 42, w, h * 2)

				draw.DrawText("MAP RETEXTURIZER","HudHintTextLarge",x+w/2,y-40,Color(255,255,255,255),1)
				draw.DrawText(mr_ply.mr_dup.run..": "..tostring(mr_ply.mr_dup.count.current).."/"..tostring(mr_ply.mr_dup.count.total),"CenterPrintText",x+w/2,y-20,Color(255,255,255,255),1)
				if mr_ply.mr_dup.count.errors.n > 0 then
					draw.DrawText("Errors: "..tostring(mr_ply.mr_dup.count.errors.n),"CenterPrintText",x+w/2,y,Color(255,255,255,255),1)
				end
			end
		end
	end

	hook.Add("HUDPaint", "MapRetDupProgress", function()
		Duplicator_RenderProgress(LocalPlayer())
	end)
end

-- Force to stop the duplicator
function Duplicator_ForceStop(plyLoadingStatus)
	if SERVER then
		if mr_dup.running ~= "" or plyLoadingStatus then
			mr_dup.force_stop = true

			net.Start("MapRetForceDupToStop")
			net.Broadcast()

			return true
		end

		return false
	else
		mr_dup.force_stop = true

		timer.Create("MapRetDuplicatorForceStop", 0.3, 1, function()
			mr_dup.force_stop = false
		end)
	end

	return
end
if SERVER then
	util.AddNetworkString("MapRetForceDupToStop")
else
	net.Receive("MapRetForceDupToStop", function()
		Duplicator_ForceStop()
	end)
end

-- Reset the duplicator state if it's finished
function Duplicator_Finish(ply)
	if CLIENT then return; end

	if not mr_dup.has.models and not ply.mr_dup.has.decals and not ply.mr_dup.has.map then
		-- Set the duplicator as initialized
		if not mr_mat.initialized then
			mr_mat.initialized = true
		end

		-- Reset the progress bar
		ply.mr_dup.run = ""
		ply.mr_dup.count.total = 0
		ply.mr_dup.count.current = 0
		Duplicator_SendStatusToCl(ply, 0, 0, "")

		-- Reset the error counting
		if ply.mr_dup.count.errors.n > 0 then
			Duplicator_SendErrorCountToCl(0)
			ply.mr_dup.count.errors.n = 0
		end

		-- Finish for new players
		if ply.mr_firstSpawn then
			ply.mr_firstSpawn = false
			net.Start("MapRetPlyFirstSpawnEnd")
			net.Send(ply)
		-- Finish for the normal usage
		else
			-- Set "running" to nothing
			mr_dup.running = ""
			net.Start("MapRetDupFinish")
			net.Broadcast()

			-- Reset the first clean state
			mr_dup.clean = false

			-- Reset model delay adjuster
			mr_dup.models.delay = 0
			mr_dup.models.max_delay = 0

			print("[Map Retexturizer] Loading finished.")
		end
	end
end
if SERVER then
	util.AddNetworkString("MapRetDupFinish")
else
	net.Receive("MapRetDupFinish", function()
		mr_dup.running = ""
	end)
end

--------------------------------
--- PREVIEW
--------------------------------

-- Toogle the preview mode for a player
function Preview_Toogle(ply, state, setOnClient, setOnServer)
	if CLIENT then
		if setOnClient then
			mr_ply.mr_previewmode = state
		end
		if setOnServer then
			net.Start("MapRetTooglePreview")
				net.WriteBool(state)
			net.SendToServer()
		end
	else
		if setOnServer then
			ply.mr_previewmode = state
		end
		if setOnClient then
			net.Start("MapRetTooglePreview")
				net.WriteBool(state)
			net.Send(ply)
		end
	end
end
if SERVER then
	util.AddNetworkString("MapRetTooglePreview")
end
net.Receive("MapRetTooglePreview", function(_, ply)
	ply = ply or mr_ply

	ply.mr_previewmode = net.ReadBool()
end)

-- Material rendering
if CLIENT then
	function Preview_Render(ply, mapMatMode)
		local tr = ply:GetEyeTrace()
		local oldData = Data_CreateFromMaterial("MatRetPreviewMaterial", nil)
		local newData = mapMatMode and Data_Create(ply, tr) or DataTable_CreateDefaults(ply, tr)

		-- Don't apply bad materials
		if not Material_IsValid(newData.newMaterial) then
			return
		end

		-- Don't render decal materials over the skybox
		if not mapMatMode and Material_GetOriginal(tr) == "tools/toolsskybox" then
			return
		end

		-- Preview adjustments
		oldData.newMaterial = mr_mat.preview.newMaterial
		if mr_mat.preview.rotation_workaround and mr_mat.preview.rotation_workaround ~= -1 then
			oldData.rotation = mr_mat.preview.rotation_workaround -- "Fix" the rotation
		end
		newData.oldMaterial = "MatRetPreviewMaterial"

		-- Update the material if necessary
		if Material_ShouldChange(ply, oldData, newData, tr) then
			Map_Material_SetAux(newData)
			mr_mat.preview.rotation_workaround = newData.rotation
			mr_mat.preview.newMaterial = newData.newMaterial
		end

		-- Get the properties
		local preview = Material("MatRetPreviewMaterial")
		local width = preview:Width()
		local height = preview:Height()

		-- Map material
		if mapMatMode then
			-- Resize
			while width > 512 or height > 300 do
				width = width/1.1
				height = height/1.1
			end

			-- Render map material
			surface.SetDrawColor(255, 255, 255, 255)
			surface.SetMaterial(preview)
			surface.DrawTexturedRect(25, ScrH()/2 - height/2, width, height)
		-- Decal
		else
			local ang = tr.HitNormal:Angle()

			-- Render decal (It's imprecise because util.DecalEx() is buggy)
			render.SetMaterial(preview)
			render.DrawQuadEasy(tr.HitPos, tr.HitNormal, width, height, Color(255,255,255), 180)

			-- Render imprecision alert
			local corretion = 51

			if height <= 32 then
				corretion = 70
			elseif height <= 64 then
				corretion = 60
			elseif height <= 128 then
				corretion = 53
			end

			cam.Start3D2D(Vector(tr.HitPos.x, tr.HitPos.y, tr.HitPos.z + (height*corretion)/100), Angle(ang.x, ang.y + 90, ang.z + 90), 0.09)
				surface.SetFont("CloseCaption_Normal")
				surface.SetTextColor(255, 255, 255, 255)
				surface.SetTextPos(0, 0)
				surface.DrawText("Decals preview may be inaccurate.")
			cam.End3D2D()
		end
	end

	-- Start map materials preview
	function Preview_Render_Map_Materials()
		local ply = LocalPlayer()

		if mr_ply.mr_previewmode and not mr_ply.mr_decalmode then
			Preview_Render(ply, true)
		end
	end
	hook.Add("HUDPaint", "MapRetPreview", function()
		Preview_Render_Map_Materials()
	end)

	-- Start decals preview
	function Preview_Render_Decals()
		local ply = LocalPlayer()

		if mr_ply.mr_previewmode and mr_ply.mr_decalmode then
			Preview_Render(ply, false)
		end
	end
	hook.Add("PostDrawOpaqueRenderables", "MapRetPreview", function()
		Preview_Render_Decals()
	end)
end

--------------------------------
--- SAVING / LOADING
--------------------------------

-- Save the modifications to a file and reload the menu
function Save_Start(ply, forceName)
	if SERVER then return; end

	local name = GetConVar("mapret_savename"):GetString()

	if name == "" then
		return
	end

	net.Start("MapRetSave")
		net.WriteString(name)
	net.SendToServer()
end
function Save_Apply(name, theFile)
	if CLIENT then return; end

	--[[
	-- Not working, just listed. I think that reloading models here is a bad idea
	local modelList = {}

	for k,v in pairs(ents.GetAll()) do
		if v.modifiedmaterial then
			table.insert(modelList, v)
		end
	end

	mr_manage.save.list[name] = { models = modelList, decals = mr_mat.decal.list, map = mr_mat.map.list, dupEnt = mr_dup.entity}
	]]

	-- Create a save table
	mr_manage.save.list[name] = { decals = mr_mat.decal.list, map = mr_mat.map.list, skybox = GetConVar("mapret_skybox"):GetString() }

	-- Save it in a file
	file.Write(theFile, util.TableToJSON(mr_manage.save.list[name]))

	-- Server alert
	print("[Map Retexturizer] Saved the materials state.")

	-- Associte a name with the saved file
	mr_manage.load.list[name] = theFile

	-- Update the load list on every client
	net.Start("MapRetSaveAddToLoadList")
		net.WriteString(name)
	net.Broadcast()
end
if SERVER then
	util.AddNetworkString("MapRetSave")
	util.AddNetworkString("MapRetSaveAddToLoadList")

	net.Receive("MapRetSave", function(_, ply)
		-- Admin only
		if not Ply_IsAdmin(ply) then
			return false
		end

		local name = net.ReadString()

		Save_Apply(name, mr_manage.map_folder..name..".txt")
	end)

	concommand.Add("mapret_remote_save", function(_1, _2, _3, name)
		if name == "" then
			return
		end

		Save_Apply(name, mr_manage.map_folder..name..".txt")
	end)
end
if CLIENT then
	net.Receive("MapRetSaveAddToLoadList", function()
		local name = net.ReadString()
		local theFile = mr_manage.map_folder..name..".txt"

		if mr_manage.load.list[name] == nil then
			if mr_manage.load.element then mr_manage.load.element:AddChoice(name) end
			mr_manage.load.list[name] = theFile
		end
	end)
end

-- Set autoloading for the map
function Save_SetAuto_Start(ply, value)
	if SERVER then return; end

	-- Set the autosave option on every client
	net.Start("MapRetAutoSaveSet")
		net.WriteBool(value)
	net.SendToServer()
end
function Save_SetAuto_Apply(ply, value)
	if CLIENT then return; end

	-- Admin only
	if not Ply_IsAdmin(ply) then
		return false
	end

	-- Remove the autosave timer
	if not value then
		if timer.Exists("MapRetAutoSave") then
			timer.Remove("MapRetAutoSave")
		end
	end

	-- Set the autosave
	RunConsoleCommand("mapret_autosave", value and "1" or "0")
end
if SERVER then
	util.AddNetworkString("MapRetAutoSaveSet")

	net.Receive("MapRetAutoSaveSet", function(_, ply)
		Save_SetAuto_Apply(ply, net.ReadBool(value))
	end)

	concommand.Add("mapret_remote_autosave", function(_1, _2, _3, valueIn)
		local value

		if valueIn == "1" then
			value = true
		elseif valueIn == "0" then
			value = false
		else
			print("[Map Retexturizer] Invalid value. Choose 1 or 0.")

			return
		end

		Save_SetAuto_Apply(mr_dup.fake_ply, value)

		PrintMessage(HUD_PRINTTALK, "[Map Retexturizer] Console: autosaving "..(value and "enabled" or "disabled")..".")
		print("[Map Retexturizer] Console: autosaving "..(value and "enabled" or "disabled")..".")
	end)
end

-- Load modifications
function Load_Start(ply)
	if SERVER then return; end

	-- Get and check the name
	local name = mr_manage.load.element:GetSelected()

	if not name or name == "" then
		return false
	end

	-- Load the file
	net.Start("MapRetLoad")
		net.WriteString(name)
	net.SendToServer()
end
function Load_Apply(ply, loadTable)
	if CLIENT then return; end

	--[[
	-- Send the model materias (Not working, just listed. I think that reloading models here is a bad idea)
	for k,v in pairs(loadTable and loadTable.models or ents.GetAll()) do
		if v.modifiedmaterial then
			Duplicator_LoadModelMaterials(ply, v, v.modifiedmaterial)
		end
	end
	]]

	local outTable1, outTable2, outTable3

	-- Don't start another loading process if we are stopping one yet
	if not mr_dup.force_stop then
		local delay = 0

		-- Force to stop any running loading
		if not ply.mr_firstSpawn then
			Duplicator_ForceStop()
			delay = 0.4
		end

		-- Wait to the last command to be done
		timer.Create("MapRetFirstJoinStart", delay, 1, function()
			-- Apply decals
			outTable1 = loadTable and loadTable.decals or mr_mat.decal.list
			if table.Count(outTable1) > 0 then
				Duplicator_LoadDecals(ply, nil, outTable1)
			end

			-- Then map materials
			outTable2 = loadTable and loadTable.map or mr_mat.map.list
			if MML_Count(outTable2) > 0 then
				Duplicator_LoadMapMaterials(ply, nil, outTable2)
			end

			-- Then the skybox
			local currentSkybox = { skybox = GetConVar("mapret_skybox"):GetString() }
			outTable3 = loadTable and loadTable or currentSkybox
			if outTable3.skybox ~= "" then
				Duplicator_LoadSkybox(ply, nil, outTable3)
			end

			if table.Count(outTable1) == 0 and MML_Count(outTable2) == 0 and outTable3.skybox == "" then
				-- Manually reset the mr_firstSpawn state if it's true and there aren't any modifications
				if ply.mr_firstSpawn then
					ply.mr_firstSpawn = false
					net.Start("MapRetPlyFirstSpawnEnd")
					net.Send(ply)
				end
			else
				-- Server alert
				if not ply.mr_firstSpawn then
					print("[Map Retexturizer] Loading started...")
				end
			end

			-- Reset the force stop var (It was set true in Duplicator_ForceStop())
			if not ply.mr_firstSpawn then
				mr_dup.force_stop = false
			end
		end)
	end
end
if SERVER then
	util.AddNetworkString("MapRetLoad")
	util.AddNetworkString("MapRetLoad_SetPly")

	local function Load_Apply_Start(ply, name)
		-- Admin only
		if not Ply_IsAdmin(ply) then
			return false
		end

		-- Get and check the load file
		local theFile = mr_manage.load.list[name]

		if theFile == nil then
			return false
		end

		-- Get the load file content
		loadTable = util.JSONToTable(file.Read(theFile, "DATA"))

		if loadTable then
			-- Register the name of the loading (one that is running for all the players)
			mr_dup.running = name
			net.Start("MapRetLoad_SetPly")
				net.WriteString(name)
			net.Send(ply)

			-- Load it
			Load_Apply(ply, loadTable)

			return true
		end

		return false
	end

	net.Receive("MapRetLoad", function(_, ply)
		Load_Apply_Start(ply, net.ReadString())
	end)

	concommand.Add("mapret_remote_load", function(_1, _2, _3, name)
		if Load_Apply_Start(mr_dup.fake_ply, name) then
			PrintMessage(HUD_PRINTTALK, "[Map Retexturizer] Console: loading \""..name.."\"...")
		else
			print("[Map Retexturizer] File not found.")
		end
	end)
else
	net.Receive("MapRetLoad_SetPly", function(_, ply)
		mr_dup.running = net.ReadString()
	end)
end

-- Fill the clients load combobox with saves
function Load_FillList()
	if SERVER then return; end

	for k,v in pairs(mr_manage.load.list) do
		mr_manage.load.element:AddChoice(k)
	end
end
if SERVER then
	util.AddNetworkString("MapRetLoadFillList")
end
if CLIENT then
	net.Receive("MapRetLoadFillList", function()
		mr_manage.load.list = net.ReadTable()
	end)
end

-- Prints the load list in the console
if SERVER then
	local function Load_ShowList()
		print("----------------------------")
		print("[Map Retexturizer] SAVES:")
		print("----------------------------")
		for k,v in pairs(mr_manage.load.list) do
			print(k)
		end
		print("----------------------------")
	end

	concommand.Add("mapret_remote_list", function(_1, _2, _3, name)
		Load_ShowList()
	end)
end

-- Delete a saved file and reload the menu
function Load_Delete_Start(ply)
	if SERVER then return; end

	-- Get the load name and check if it's no empty
	local theName = mr_manage.load.element:GetSelected()

	if not theName or theName == "" then
		return
	end

	-- Remove the load on every client
	net.Start("MapRetLoadDeleteSV")
		net.WriteString(theName)
	net.SendToServer()
end
function Load_Delete_Apply(ply, theName)
	-- Admin only
	if not Ply_IsAdmin(ply) then
		return false
	end

	local theFile = mr_manage.load.list[theName]

	-- Check if the file exists
	if theFile == nil then
		return false
	end

	-- Remove the load entry
	mr_manage.load.list[theName] = nil

	-- Remove the load from the autoload if it is there
	if GetConVar("mapret_autoload"):GetString() == theName then
		RunConsoleCommand("mapret_autoload", "")
	end

	-- Delete the file
	file.Delete(theFile)

	-- Updates the load list on every client
	net.Start("MapRetLoadDeleteCL")
		net.WriteString(theName)
	net.Broadcast()

	return true
end
if SERVER then
	util.AddNetworkString("MapRetLoadDeleteSV")
	util.AddNetworkString("MapRetLoadDeleteCL")

	net.Receive("MapRetLoadDeleteSV", function(_, ply)
		Load_Delete_Apply(ply,  net.ReadString())
	end)

	concommand.Add("mapret_remote_delete", function(_1, _2, _3, name)
		if Load_Delete_Apply(mr_dup.fake_ply, name) then
			PrintMessage(HUD_PRINTTALK, "[Map Retexturizer] Console: deleted the save \""..name.."\".")
			print("[Map Retexturizer] Console: deleted the save \""..name.."\".")
		else
			print("[Map Retexturizer] File not found.")
		end
	end)
end
if CLIENT then
	net.Receive("MapRetLoadDeleteCL", function()
		local name = net.ReadString()

		mr_manage.load.list[name] = nil
		mr_manage.load.element:Clear()

		for k,v in pairs(mr_manage.load.list) do
			mr_manage.load.element:AddChoice(k)
		end
	end)
end

-- Set autoloading for the map
function Load_SetAuto_Start(ply, text)
	if SERVER then return; end

	-- Set the autoload on every client
	net.Start("MapRetAutoLoadSet")
		net.WriteString(text or mr_manage.load.element:GetText())
	net.SendToServer()
end
function Load_SetAuto_Apply(ply, text)
	if CLIENT then return; end

	-- Admin only
	if not Ply_IsAdmin(ply) then
		return false
	end

	if not mr_manage.load.list[text] and text ~= "" then
		return false
	end

	RunConsoleCommand("mapret_autoload", text)

	timer.Create("MapRetWaitToSave", 0.3, 1, function()
		file.Write(mr_manage.autoload.file, GetConVar("mapret_autoload"):GetString())
	end)

	return true
end
if SERVER then
	util.AddNetworkString("MapRetAutoLoadSet")

	net.Receive("MapRetAutoLoadSet", function(_, ply)
		local text = net.ReadString()

		Load_SetAuto_Apply(ply, text)
	end)

	concommand.Add("mapret_remote_autoload", function(_1, _2, _3, text)
		if Load_SetAuto_Apply(mr_dup.fake_ply, text) then
			PrintMessage(HUD_PRINTTALK, "[Map Retexturizer] Console: autoload set to \""..text.."\".")
			print("[Map Retexturizer] Console: autoload set to \""..text.."\".")
		else
			print("[Map Retexturizer] File not found.")
		end
	end)
end

-- Load the server modifications on the first spawn (start)
function Load_FirstSpawn(ply)
	if CLIENT then return; end

	-- Set the player status
	ply.mr_firstSpawn = true

	-- Index duplicator stuff (serverside)
	mr_dup_set(ply)

	-- Fill up the player load list
	net.Start("MapRetLoadFillList")
		net.WriteTable(mr_manage.load.list)
	net.Send(ply)

	-- Do not go on if it's not needed
	if GetConVar("mapret_skybox"):GetString() == ""
		and table.Count(mr_mat.decal.list) == 0
		and MML_Count(mr_mat.map.list) == 0
		and GetConVar("mapret_autoload"):GetString() == ""
		then

		-- Register that the player completed the spawn
		ply.mr_firstSpawn = false
		net.Start("MapRetPlyFirstSpawnEnd")
		net.Send(ply)

		return
	end

	-- Wait a little (decals need this)
	timer.Create("MapRetFirstSpawnApplyDelay"..tostring(ply), 5, 1, function()
	-- Send the current modifications
	if mr_dup.running == "" and (GetConVar("mapret_autoload"):GetString() == "" or mr_mat.initialized) then
		Load_Apply(ply, nil)
	-- Or load an saved file
	else
		-- Register if the player is also initializing the material table
		if not mr_mat.initialized then
			local isLoading = false

			for k,v in pairs(player.GetAll()) do
				if v.mr_mat_initializing then
					isLoading = true
				end
			end

			if not isLoading then
				ply.mr_mat_initializing = true
			end
		end

		-- Get the save name
		local autol = mr_dup.running ~= "" and mr_dup.running or file.Read(mr_manage.autoload.file, "DATA")

		-- Load the materials
		if autol ~= "" then
			local loadTable = util.JSONToTable(file.Read(mr_manage.map_folder..autol..".txt"))
			Load_Apply(ply, loadTable)
		end
	end
	end)
end
if SERVER then
	util.AddNetworkString("MapRetPlyFirstSpawnEnd")

	hook.Add("PlayerInitialSpawn", "MapRetPlyFirstSpawn", Load_FirstSpawn)
end
if CLIENT then
	net.Receive("MapRetPlyFirstSpawnEnd", function()
		mr_ply.mr_firstSpawn = false
	end)
end

--------------------------------
--- TOOL FUNCTIONS
--------------------------------

function TOOL_BasicChecks(ply, ent, tr)
	-- Admin only
	if not Ply_IsAdmin(ply) then
		return false
	end

	-- The player can't use the tool if he's already in the joining process
	local ply2
	if SERVER then
		ply2 = ply
	else
		ply2 = mr_ply
	end
	if ply2.mr_firstSpawn then
		ply:PrintMessage(HUD_PRINTTALK, "[Map Retexturizer] The tool is not ready to use yet.")

		return false
	end

	-- It's not meant to mess with players
	if ent:IsPlayer() then
		return false
	end

	-- We can't mess with displacement materials
	if ent:IsWorld() and Material_GetCurrent(tr) == "**displacement**" then
		if SERVER then
			ply:PrintMessage(HUD_PRINTTALK, "[Map Retexturizer] Sorry, we can't handle displacement materials!")
		end

		return false
	end

	return true
end

-- Apply materials
function TOOL:LeftClick(tr)
	local ply = self:GetOwner() or LocalPlayer()
	local ent = tr.Entity

	-- Basic checks
	if not TOOL_BasicChecks(ply, ent, tr) then
		return false
	end

	-- Do not modify anything in the middle of a loading
	local ply2
	if SERVER then
		ply2 = ply
	else
		ply2 = mr_ply
	end
	if mr_dup.running ~= "" or ply2.mr_dup.run ~= "" then
		if SERVER then
			if not ply.mr_decalmode then
				ply:PrintMessage(HUD_PRINTTALK, "[Map Retexturizer] Wait for the loading to finish.")
			end
		end

		return false
	end

	-- Do not try to modify the skybox
	if Material_GetOriginal(tr) == "tools/toolsskybox" then
		if SERVER then
			if not ply.mr_decalmode then
				ply:PrintMessage(HUD_PRINTTALK, "[Map Retexturizer] Modify the skybox using the tool menu.")
			end
		end

		return false
	end

	-- Create the duplicator entity used to restore map materials, decals and skybox
	if SERVER then
		Duplicator_CreateEnt()
	end

	-- If we are dealing with decals
	local ply2 = self:GetOwner() or mr_ply
	if ply2.mr_decalmode then
		return Decal_Start(ply, tr)
	end

	-- Check upper limit
	if not MML_Check() then
		return false
	end

	-- Generate the new data
	local data = Data_Create(ply, tr)

	-- Don't apply bad materials
	if not Material_IsValid(data.newMaterial) then
		if SERVER then
			ply:PrintMessage(HUD_PRINTTALK, "[Map Retexturizer] Bad material.")
		end

		return false
	end

	-- Do not apply the material if it's not necessary
	if not Material_ShouldChange(ply, Data_Get(tr), data, tr) then
		return false
	end

	-- Register that the map is manually modified
	if not mr_mat.initialized then
		mr_mat.initialized = true
	end

	-- All verifications are done for the client. Let's only check the autosave now
	if CLIENT then
		return true
	end

	-- Auto save
	if GetConVar("mapret_autosave"):GetString() == "1" then
		if not timer.Exists("MapRetAutoSave") then
			timer.Create("MapRetAutoSave", 60, 1, function()
				Save_Apply(mr_manage.autosave.name, mr_manage.autosave.file)
				PrintMessage(HUD_PRINTTALK, "[Map Retexturizer] Auto saving...")
			end)
		end
	end

	-- Set
	timer.Create("LeftClickMultiplayerDelay"..tostring(math.random(999))..tostring(ply), multiplayer_action_delay, 1, function()
		-- model material
		if IsValid(ent) then
			Model_Material_Set(data)
		-- or map material
		elseif ent:IsWorld() then
			Map_Material_Set(ply, data)
		end
	end)

	-- Set the Undo
	undo.Create("Material")
		undo.SetPlayer(ply)
		undo.AddFunction(function(tab, data)
			if data.oldMaterial then
				Material_Restore(ent, data.oldMaterial)
			end
		end, data)
		undo.SetCustomUndoText("Undone a material")
	undo.Finish("Material ("..tostring(data.newMaterial)..")")

	return true
end

-- Copy materials
function TOOL:RightClick(tr)
	local ply = self:GetOwner() or LocalPlayer()
	local ent = tr.Entity

	-- Basic checks
	if not TOOL_BasicChecks(ply, ent, tr) then
		return false
	end

	-- Create a new data table and try to get the current one
	local newData = Data_Get(tr) or true
	local oldData = Data_Get(tr)

	-- If the material is invalid we can't get it
	if newData == true then
		local material = Material_GetOriginal(tr)

		if not material then
			ply:PrintMessage(HUD_PRINTTALK, "[Map Retexturizer] The material you are trying to modify has an invalid name.")

			return false
		end

		newData = Data_CreateFromMaterial(material)
	end

	-- Check if the copy isn't necessary
	if Material_GetCurrent(tr) == Material_GetNew(ply) then
		if oldData then
			if not Material_ShouldChange(ply, oldData, newData, tr) then
				return false
			end
		else
			return false
		end
	end

	if CLIENT then
		-- Set the detail element to the right position
		local i = 1

		for k,v in SortedPairs(mr_mat.detail.list) do
			if k == newData.detail then
				break
			else
				i = i + 1
			end
		end

		if mr_mat.detail.element then
			mr_mat.detail.element:ChooseOptionID(i)
		end

		return true
	end

	-- Copy the material
	ply:ConCommand("mapret_material "..Material_GetCurrent(tr))

	-- Set the cvars to data values
	if newData then
		CVars_SetToData(ply, newData)
	-- Or set the cvars to default values
	else
		CVars_SetToDefaults(ply)
	end

	return true
end

-- Restore materials
function TOOL:Reload(tr)
	local ply = self:GetOwner() or LocalPlayer()
	local ent = tr.Entity

	-- Basic checks
	if not TOOL_BasicChecks(ply, ent, tr) then
		return false
	end

	-- Reset the material
	if Data_Get(tr) then
		if SERVER then
			timer.Create("ReloadMultiplayerDelay"..tostring(math.random(999))..tostring(ply), multiplayer_action_delay, 1, function()
				Material_Restore(ent, Material_GetOriginal(tr))
			end)
		end

		return true
	end

	return false
end

-- Preview mode checking
function TOOL:Deploy()
	if CLIENT then return; end

	local ply = self:GetOwner()

	if ply.mr_previewmode then
		Preview_Toogle(ply, true, true, false)
	end
end

-- Preview mode checking
function TOOL:Holster()
	if SERVER then return; end

	if mr_mat.preview.holster_workaround then -- BUG!! For some reason this function is called when the tool is loaded for the first time
		Preview_Toogle(self:GetOwner(), false, true, false)
	else
		mr_mat.preview.holster_workaround = true
	end
end

-- Panels
function TOOL.BuildCPanel(CPanel)
	CPanel:SetName("#tool.mapret.name")
	CPanel:Help("#tool.mapret.desc")

	local ply = LocalPlayer()
	local properties = { label, a, b, c, d, e, f, baseMaterialReset }

	local function Properties_Toogle(val)
		if val then
			mr_mat.detail.element:Hide()
		else
			mr_mat.detail.element:Show()
		end

		for k,v in pairs(properties) do
			if val then
				v:Hide()
			else
				v:Show()
			end
		end
	end

	CPanel:Help(" ")
	local section_general = vgui.Create("DCollapsibleCategory", CPanel)
	section_general:SetLabel("General")
	CPanel:AddItem(section_general)
	RunConsoleCommand("mapret_material", "dev/dev_blendmeasure")
	CPanel:TextEntry("Material path", "mapret_material")
	CPanel:ControlHelp("\nNote: the command \"mat_crosshair\" can get a displacement material path.")
	local previewBox = CPanel:CheckBox("Preview Modifications", "mapret_preview")
	CPanel:ControlHelp("The preview is not accurate with decals (GMod bugs).")
	timer.Create("MapRetPreviewCheckDelay", 0.2, 1, function()
		previewBox:SetChecked(true)
		Preview_Toogle(ply, previewBox:GetChecked(), true, true)
	end)
	function previewBox:OnChange(val)
		-- Don't let the player mess with the option if the toolgun is not selected
		if ply:GetActiveWeapon():GetClass() ~= "gmod_tool" then
			if val then
				previewBox:SetChecked(false)
			else
				previewBox:SetChecked(true)
			end

			return false
		end

		Preview_Toogle(ply, val, true, true)
	end
	local decalBox = CPanel:CheckBox("Use as Decal", "mapret_decal")
	Decal_Toogle(ply, decalBox:GetChecked())
	function decalBox:OnChange(val)
		Properties_Toogle(val)
		Decal_Toogle(ply, val)
	end
--	CPanel:Button("Change all map materials","mapret_changeall")
--	CPanel:ControlHelp("It doesn't fully work (GMod bugs).")
	CPanel:Button("Open Material Browser","mapret_materialbrowser")

	CPanel:Help(" ")
	local section_properties = vgui.Create("DCollapsibleCategory", CPanel)
	section_properties:SetLabel("Material Properties")
	CPanel:AddItem(section_properties)
	mr_mat.detail.element, properties.label = CPanel:ComboBox("Select a Detail:", "mapret_detail")
	for k,v in SortedPairs(mr_mat.detail.list) do
		mr_mat.detail.element:AddChoice(k, k, v)
	end
	timer.Create("MapRetDetailDefaultDelay", 0.1, 1, function()
		mr_mat.detail.element:SetValue("None")
		RunConsoleCommand("mapret_detail", "None")
	end)
	properties.a = CPanel:NumSlider("Alpha", "mapret_alpha", 0, 1, 2)
	properties.b = CPanel:NumSlider("Horizontal Translation", "mapret_offsetx", -1, 1, 2)
	properties.c = CPanel:NumSlider("Vertical Translation", "mapret_offsety", -1, 1, 2)
	properties.d = CPanel:NumSlider("Width Magnification", "mapret_scalex", 0.01, 6, 2)
	properties.e = CPanel:NumSlider("Height Magnification", "mapret_scaley", 0.01, 6, 2)
	properties.f = CPanel:NumSlider("Rotation", "mapret_rotation", 0, 179, 0)
	properties.baseMaterialReset = CPanel:Button("Reset Properties")
	function properties.baseMaterialReset:DoClick()
		CVars_SetToDefaults(ply)
	end

	CPanel:Help(" ")
	local section_skybox = vgui.Create("DCollapsibleCategory", CPanel)
	section_skybox:SetLabel("Skybox")
	CPanel:AddItem(section_skybox)
	mr_mat.skybox.element_text = CPanel:TextEntry("In use:", "mapret_skybox")
	mr_mat.skybox.element_text.OnEnter = function(self)
		Skybox_Start(ply, self:GetValue())
	end
	mr_mat.skybox.element_combo = CPanel:ComboBox("HL2:")
	function mr_mat.skybox.element_combo:OnSelect(index, value, data)
		Skybox_Start(ply, value)
	end
	for k,v in pairs(mr_mat.skybox.hl2_list) do
		mr_mat.skybox.element_combo:AddChoice(k, k)
	end
	timer.Create("MapRetSkyboxDelay", 0.1, 1, function()
		mr_mat.skybox.element_combo:SetValue("")
	end)
	CPanel:ControlHelp("\nYou can use whatever you want as a sky now.")
	CPanel:ControlHelp("developer.valvesoftware.com/wiki/Sky_List.")

	CPanel:Help(" ")
	local section_save = vgui.Create("DCollapsibleCategory", CPanel)
	section_save:SetLabel("Save")
	CPanel:AddItem(section_save)
	mr_manage.save.element = CPanel:TextEntry("Filename:", "mapret_savename")
	RunConsoleCommand("mapret_savename", mr_manage.save.defaul_name)
	CPanel:ControlHelp("\nYour files are being saved under \"./data/"..mr_manage.map_folder.."\".")
	CPanel:ControlHelp("\nWARNING! Your modified models will no be saved! If you want to keep them, use the GMod default Save instead.")
	local autoSaveBox = CPanel:CheckBox("Autosave", "mapret_autosave")
	function autoSaveBox:OnChange(val)
		-- Admin only
		if not Ply_IsAdmin(ply) then
			if val then
				autoSaveBox:SetChecked(false)
			else
				autoSaveBox:SetChecked(true)
			end

			return false
		end

		Save_SetAuto_Start(ply, val)
	end
	CPanel:ControlHelp("\nWhen changes are detected it waits 60 seconds to save them automatically in the file \""..mr_manage.autosave.file.."\" under the name of \""..mr_manage.autosave.name.."\" and then repeats this cycle.")
	local saveChanges = CPanel:Button("Save")
	function saveChanges:DoClick()
		Save_Start(ply)
	end

	CPanel:Help(" ")
	local section_load = vgui.Create("DCollapsibleCategory", CPanel)
	section_load:SetLabel("Load")
	CPanel:AddItem(section_load)
	local mapSec = CPanel:TextEntry("Map:")
	mapSec:SetEnabled(false)
	mapSec:SetText(game.GetMap())
	mr_manage.autoload.element = CPanel:TextEntry("Autoload:", "mapret_autoload")
	mr_manage.autoload.element:SetEnabled(false)
	mr_manage.load.element = CPanel:ComboBox("Select a File:")
	Load_FillList(ply)
	CPanel:Help(" ")
	CPanel:Help("Apply:")
	local loadSave = CPanel:Button("Load")
	function loadSave:DoClick()
		Load_Start(ply)
	end
	local setAutoLoad = CPanel:Button("Set Autoload")
	function setAutoLoad:DoClick()
		Load_SetAuto_Start(ply)
	end
	CPanel:Help("Remove:")
	local delSave = CPanel:Button("Delete")
	function delSave:DoClick()
		Load_Delete_Start(ply)
	end
	local delAutoLoad = CPanel:Button("Remove Autoload")
	function delAutoLoad:DoClick()
		Load_SetAuto_Start(ply, "")
	end

	CPanel:Help(" ")
	local section_cleanup = vgui.Create("DCollapsibleCategory", CPanel)
	section_cleanup:SetLabel("Cleanup")
	CPanel:AddItem(section_cleanup)
	local cleanupCombobox = CPanel:ComboBox("Select a section:")
	cleanupCombobox:AddChoice("Decals","Decal_RemoveAll")
	cleanupCombobox:AddChoice("Map Materials","Map_Material_RemoveAll")
	cleanupCombobox:AddChoice("Model Materials","Model_Material_RemoveAll")
	cleanupCombobox:AddChoice("Skybox","Skybox_Remove")
	cleanupCombobox:AddChoice("All","Material_RestoreAll", true)
	local cleanupButton = CPanel:Button("Cleanup","mapret_cleanup_all")
	function cleanupButton:DoClick()
		local _, netName = cleanupCombobox:GetSelected()
		net.Start(netName)
			net.WriteBool(mr_ply.mr_dup and mr_ply.mr_dup.run ~= "" and true or false)
		net.SendToServer()
	end

	CPanel:Help(" ")
	CPanel:Help("Report bugs and make requests at the tool workshop page.")

	CPanel:Help(" ")
	CPanel:ControlHelp(mr_revision)
	CPanel:Help(" ")
end
