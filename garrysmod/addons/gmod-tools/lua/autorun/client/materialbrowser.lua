local Window
local MaterialBox
local List
local Reload
local MatRetMaterial = CreateMaterial("MatRetMaterial", "UnlitGeneric", {["$basetexture"] = ""})

local function ParseDir(t, dir, ext)
	local files, dirs = file.Find(dir.."*", "GAME")
	for _, fdir in pairs(dirs) do
		local n = t:AddNode(fdir)
		n:SetExpanded(true)
		n.DoClick = function()
			ParseDir(n, dir..fdir.."/", ext)
			n.DoClick = function() end
		end
	end
	for k,v in pairs(files) do
		local pathExt = string.sub(v, -4)
		local isValidExt = false
		for _,y in pairs(ext) do
			if pathExt == y then
				isValidExt = true
				break
			end
		end
		if isValidExt then
			local arq = string.sub(dir..v, 11, -5)
			local n = t:AddNode(v)
			n.Icon:SetImage("icon16/picture.png")
			n.DoClick = function()
				RunConsoleCommand("mapret_material", arq)
				if not Material(arq):IsError() then -- If the file is a .vmt
					if Material(arq):GetTexture("$basetexture") then -- If the file has a $basetexture
						MatRetMaterial:SetTexture("$basetexture", Material(arq):GetTexture("$basetexture"));
					else
						MatRetMaterial:SetTexture("$basetexture", Material("vgui/avatar_default"):GetTexture("$basetexture"));
					end
					MaterialBox:SetMaterial(MatRetMaterial)
				else
					MaterialBox:SetImage(arq..pathExt, "vgui/avatar_default") -- Shows every texture. Beautiful
					-- MaterialBox:SetTexture("$basetexture",arq) -- Shows the textures that I can apply. Realistic
				end
			end
		end
	end
end

local function CreateMaterialBrowser()
	Window = vgui.Create("DFrame")
		Window:SetTitle("Material Browser")
		Window:SetSize(300, 750)
		Window:SetDeleteOnClose(false)
		Window:SetSizable(true)
		Window:SetMinHeight(750)
		Window:SetMinWidth(300)
		Window:SetIcon("icon16/picture.png")
		Window:SetBackgroundBlur(true)
		Window:Center()
		Window:SetPaintBackgroundEnabled(false)

	MaterialBox = vgui.Create("DImage", Window)
		MaterialBox:SetSize(Window:GetWide(), 0.41*(Window:GetTall()-25))
		MaterialBox:SetPos(0, 25)

	local function CreateList()
		List = vgui.Create("DTree", Window)
			List:SetSize(Window:GetWide(), 0.55*(Window:GetTall()-25))
			List:SetPos(0, 0.41*(Window:GetTall()-25)+25)
			List:SetShowIcons(true)
	end
	CreateList()

	local function FillList()
		local node = List:AddNode("Materials! (click one to select)")
		--ParseDir(node, "materials/", { ".vmt", ".png", ".jpg" })
		ParseDir(node, "materials/", { ".vmt" })
		node:SetExpanded(true)
	end

	Reload = vgui.Create("DButton", Window)
		Reload:SetSize(Window:GetWide(), 0.04*(Window:GetTall()-25))
		Reload:SetPos(0, 0.96*(Window:GetTall()-25)+25)
		Reload:SetText("Reload List")
		Reload.DoClick = function()
			List:Remove()
			CreateList()
			FillList()
		end

	FillList()
end

local function ShowBrowser()
	if not Window then 
		CreateMaterialBrowser()
	end
	Window:SetVisible(true)
	Window:MakePopup()
end

concommand.Add("mapret_materialbrowser", ShowBrowser)
