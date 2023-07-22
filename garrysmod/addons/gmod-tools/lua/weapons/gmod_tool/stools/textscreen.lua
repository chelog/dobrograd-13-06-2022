TOOL.Category = "Dobrograd"
TOOL.Name = "#Tool.textscreen.name"
TOOL.Command = nil
TOOL.ConfigName = ""
local textBox = {}
local typeComboBox = {}
local fontComboBox = {}
local colorComboBox = {}
local colTypeComboBox = {}
local comboBox = {}
local lineLabels = {}
local labels = {}
local sliders = {}

local types = {
	["Вывески, рекламные баннеры"] = 1,
	["Граффити, листовки, плакаты"] = 2
}

local fonts = {
	[1] = {
		"Calibri",
		"DejaSana",
		"Coolvetica",
		"Helvetica",
		"Roboto",
		"Roboto +",
		"Tahoma",
		"Ms",
	},
	[2] = {
		"Coolvetica",
		"Calibri",
		"Ms",
		"Roboto"
	}
}

local colors = {
	[1] = {
		["MediumSlateBlue"] = Color(123, 104, 238),
		["Crimson"] = Color(220, 20, 60),
		["FireBrick"] = Color(178, 34, 34),
		["DarkOrange"] = Color(186, 119, 3),
		["MediumVioletRed"] = Color(122, 24, 86),
		["OrangeBlack"] = Color(131, 93, 28),
		["BlueRed"] = Color(43, 57, 123),
		["Greepie"] = Color(43, 123, 84),
		["Indigo"] = Color(255, 0, 130),
		["OrangeJuice"] = Color(163, 91, 33),
		["OrangeLight"] = Color(255, 149, 14),
		["PurpleLight"] = Color(191, 127, 255),
		["BlueLight"] = Color(63, 127, 127),
		["GraySil"] =Color(82, 182, 182),
		["PurplePink"] = Color(120, 24, 85),
		["OrangeLeen"] = Color(173, 102, 34),
		["RedJuice"] = Color( 190, 109, 109),
		["GreyIng"] = Color( 157, 139, 139)
	},
	[2] = {
		["Silver"] =  Color(192, 192, 192),
		["Gray"] =  Color(128, 128, 128),
		["DimGray"] =  Color(105, 105, 105),
		["LightGrey"] =  Color(211, 211, 211),
		["OldLace"] =  Color(253, 245, 230),
		["Black"] =  Color(0, 0, 0),
		["LightSteelBlue"] =  Color(176, 196, 222),
		["AntiqueWhite"] =  Color(250, 235, 215),
		["Lavender"] =  Color(230, 230, 250),
		["Bisque"] =  Color(255, 228, 196),
		["BurlyWood"] =  Color(222, 184, 135),
		["NavajoWhite"] =  Color(255, 222, 173),
		["PaleGoldenrod"] = Color(238, 232, 170),
		["DarkSalmon"] =  Color(233, 150, 122),
		["DarkKhaki"] =  Color(189, 183, 107),
		["Sienna"] = Color(160, 82, 45),
		["WhiteSmoke"] =  Color(245, 245, 245),
		["RosyBrown"] =  Color(188, 143, 143),
		["Thistle"] =  Color(216, 191, 216),
		["Plum"] =  Color(221, 160, 221),
		["Peru"] = Color(205, 133, 63),
		["CadetBlue"] =  Color(165, 175, 200),
		["MistyRose"] =  Color(255, 228, 225),
		["MysteryBhp"] = Color(112, 98, 98),
		["DarkSlateGray"] =  Color(47, 79, 79),
		["Tan"] = Color(210, 180, 140),
		["Moccasin"] =  Color(255, 228, 181),
		["Cornsilk"] =  Color(255, 248, 220),
		["PurpleBlack"] =  Color(75, 51, 66)
	}
}

local convars, keys = {}, {}

for i = 1, 5 do
	TOOL.ClientConVar["text" .. i] = ""
	TOOL.ClientConVar["size" .. i] = 40
	TOOL.ClientConVar["font" .. i] = "Calibri"
	TOOL.ClientConVar["col" .. i] = "MediumSlateBlue"
	TOOL.ClientConVar["type" .. i] = 1
	TOOL.ClientConVar["coltype" .. i] = 1
	TOOL.ClientConVar["r" .. i] = 255
	TOOL.ClientConVar["g" .. i] = 255
	TOOL.ClientConVar["b" .. i] = 255
	TOOL.ClientConVar["a" .. i] = 255
end
for k, v in pairs(TOOL.ClientConVar) do
	convars["textscreen_" .. k] = v
	keys[#keys + 1] = "textscreen_" .. k
end

cleanup.Register("textscreens")

local function checkAccess(ply)
	return serverguard.player:HasPermission(ply, 'DBG: Расширенный 3D2D Textscreen')
end

if (CLIENT) then
	TS_FONTS = {}
	function TS_GET_FONT( name, size )
		local fontName = "TS_FONTS_" .. name .. size

		if not TS_FONTS[ fontName ] then
			surface.CreateFont(fontName, {
				font = name,
				size = size,
				weight = 400,
				extended = true,
			})

			TS_FONTS[ fontName ] = true
			return fontName
		else
			return fontName
		end

	end

	language.Add("Tool.textscreen.name", "3D2D Textscreen")
	language.Add("Tool.textscreen.desc", "Создает текстскрин с несколькими строками, кастомизируемыми цветами и размерами")
	language.Add("Tool.textscreen.0", "Левая кнопка: Создать текстскрин Правая кнопка: Обновить параметры текстскрина")
	language.Add("Tool_textscreen_0", "Левая кнопка: Создать текстскрин Правая кнопка: Обновить параметры текстскрина")
	language.Add("Undone.textscreens", "Отмена текстскрина")
	language.Add("Undone_textscreens", "Отмена текстскрина")
	language.Add("Cleanup.textscreens", "Текстскрины")
	language.Add("Cleanup_textscreens", "Текстскрины")
	language.Add("Cleaned.textscreens", "Очищены все текстскрины")
	language.Add("Cleaned_textscreens", "Очищены все текстскрины")
	language.Add("SBoxLimit.textscreens", "Ты достиг лимита текстскринов!")
	language.Add("SBoxLimit_textscreens", "Ты достиг лимита текстскринов!")
end

function TOOL:LeftClick(tr)
	if (tr.Entity:GetClass() == "player") then return false end
	if (CLIENT) then return true end
	local ply = self:GetOwner()
	if not (self:GetWeapon():CheckLimit("textscreens")) then return false end

	local textScreen = ents.Create("textscreen")
	textScreen:SetPos(tr.HitPos)

	local angle = tr.HitNormal:Angle()
	angle:RotateAroundAxis(tr.HitNormal:Angle():Right(), -90)
	angle:RotateAroundAxis(tr.HitNormal:Angle():Forward(), 90)
	textScreen:SetAngles(angle)
	textScreen:Spawn()
	textScreen:Activate()

	for i = 1, 5 do
		local color = Color(colors[tonumber(self:GetClientInfo("type" .. i))][self:GetClientInfo("col" .. i)])
			
		if (checkAccess(ply) and self:GetClientNumber("coltype" .. i) == 2) then
			color = Color( -- Color
				tonumber(self:GetClientInfo("r"..i)) or 255,
				tonumber(self:GetClientInfo("g"..i)) or 255,
				tonumber(self:GetClientInfo("b"..i)) or 255,
				tonumber(self:GetClientInfo("a"..i)) or 255
			)
		end

		textScreen:SetLine(
			i, -- Line
			self:GetClientInfo("text"..i), -- text
			color, -- Color
			tonumber(self:GetClientInfo("size"..i)) or 14,
			self:GetClientInfo("font"..i)
		)
	end

	-- Line
	-- text
	-- Color
	undo.Create("textscreens")
	undo.AddEntity(textScreen)
	undo.SetPlayer(ply)
	undo.Finish()
	ply:AddCount("textscreens", textScreen)
	ply:AddCleanup("textscreens", textScreen)

	return true
end

function TOOL:RightClick(tr)
	if (tr.Entity:GetClass() == "player") then return false end
	if (CLIENT) then return true end
	local TraceEnt = tr.Entity

	if (IsValid(TraceEnt) and TraceEnt:GetClass() == "textscreen") then
		for i = 1, 5 do
			local color = Color(colors[tonumber(self:GetClientInfo("type" .. i))][self:GetClientInfo("col" .. i)])

			if (checkAccess(ply) and self:GetClientNumber("coltype" .. i) == 2) then
				color = Color( -- Color
					tonumber(self:GetClientInfo("r"..i)) or 255,
					tonumber(self:GetClientInfo("g"..i)) or 255,
					tonumber(self:GetClientInfo("b"..i)) or 255,
					tonumber(self:GetClientInfo("a"..i)) or 255
				)
			end

			TraceEnt:SetLine(
				i, -- Line
				tostring(self:GetClientInfo("text"..i)), -- text
				color, -- Color
				tonumber(self:GetClientInfo("size"..i)) or 14,
				self:GetClientInfo("font"..i)
			)
		end

		return true
	end
end

function TOOL.BuildCPanel(CPanel)
	CPanel:AddControl("Header", {
		Text = "#Tool.textscreen.name",
		Description = "#Tool.textscreen.desc"
	})

	CPanel:AddControl("ComboBox", {
		Label = "#Presets",
		MenuButton = "1",
		Folder = "textscreen",

		Options = {
			Default = convars,
		},

		CVars = keys,
	})

	resetall = vgui.Create("DButton", resetbuttons)
	resetall:SetSize(100, 25)
	resetall:SetText("Сбросить все")

	resetall.DoClick = function()
		local menu = DermaMenu()

		menu:AddOption("Сбросить цвета", function()
			for i = 1, 5 do
				RunConsoleCommand("textscreen_col" .. i, "MediumSlateBlue")
				RunConsoleCommand("textscreen_r" .. i, 255)
				RunConsoleCommand("textscreen_g" .. i, 255)
				RunConsoleCommand("textscreen_b" .. i, 255)
				RunConsoleCommand("textscreen_a" .. i, 255)
			end
		end)

		menu:AddOption("Сбросить размеры", function()
			for i = 1, 5 do
				RunConsoleCommand("textscreen_size" .. i, 35)
				sliders[i]:SetValue(35)
			end
		end)

		menu:AddOption("Сбросить текст", function()
			for i = 1, 5 do
				RunConsoleCommand("textscreen_text" .. i, "")
				textBox[i]:SetValue("")
			end
		end)

		menu:AddOption("Сбросить все", function()
			for i = 1, 5 do
				RunConsoleCommand("textscreen_col" .. i, "MediumSlateBlue")
				RunConsoleCommand("textscreen_r" .. i, 255)
				RunConsoleCommand("textscreen_g" .. i, 255)
				RunConsoleCommand("textscreen_b" .. i, 255)
				RunConsoleCommand("textscreen_a" .. i, 255)
				RunConsoleCommand("textscreen_size" .. i, 35)
				sliders[i]:SetValue(35)
				RunConsoleCommand("textscreen_text" .. i, "")
				textBox[i]:SetValue("")
			end
		end)

		menu:Open()
	end

	CPanel:AddItem(resetall)
	resetline = vgui.Create("DButton")
	resetline:SetSize(100, 25)
	resetline:SetText("Сбросить строку")

	resetline.DoClick = function()
		local menu = DermaMenu()

		for i = 1, 5 do
			menu:AddOption("Сбросить строку " .. i, function()
				RunConsoleCommand("textscreen_col" .. i, "MediumSlateBlue")
				RunConsoleCommand("textscreen_r" .. i, 255)
				RunConsoleCommand("textscreen_g" .. i, 255)
				RunConsoleCommand("textscreen_b" .. i, 255)
				RunConsoleCommand("textscreen_a" .. i, 255)
				RunConsoleCommand("textscreen_size" .. i, 35)
				sliders[i]:SetValue(35)
				RunConsoleCommand("textscreen_text" .. i, "")
				textBox[i]:SetValue("")
			end)
		end

		menu:AddOption("Сбросить все строки", function()
			for i = 1, 5 do
				RunConsoleCommand("textscreen_col" .. i, "MediumSlateBlue")
				RunConsoleCommand("textscreen_r" .. i, 255)
				RunConsoleCommand("textscreen_g" .. i, 255)
				RunConsoleCommand("textscreen_b" .. i, 255)
				RunConsoleCommand("textscreen_a" .. i, 255)
				RunConsoleCommand("textscreen_size" .. i, 35)
				sliders[i]:SetValue(35)
				RunConsoleCommand("textscreen_text" .. i, "")
				textBox[i]:SetValue("")
			end
		end)

		menu:Open()
	end

	CPanel:AddItem(resetline)

	for i = 1, 5 do
		lineLabels[i] = CPanel:AddControl("Label", {
			Text = "Строка " .. i,
			Description = "Строка " .. i
		})
		lineLabels[i]:SetFont("f4.normal")

		sliders[i] = vgui.Create("DNumSlider")
		sliders[i]:SetText("Размер текста")
		sliders[i]:SetMinMax(20, 100)
		sliders[i]:SetDecimals(0)
		sliders[i]:SetValue(35)
		sliders[i]:SetConVar("textscreen_size" .. i)
		sliders[i].OnValueChanged = function(panel, value)
			labels[i]:SetFont( TS_GET_FONT( GetConVar("textscreen_font" .. i):GetString(), value ) )
			labels[i]:SetTall(value)
		end

		CPanel:AddItem(sliders[i])

		textBoxLabel = CPanel:AddControl("Label", {
			Text = "Содержание",
			Description = "Содержание"
		})

		textBox[i] = vgui.Create("DTextEntry")
		textBox[i]:SetUpdateOnType(true)
		textBox[i]:SetEnterAllowed(true)
		textBox[i]:SetConVar("textscreen_text" .. i)
		textBox[i]:SetValue( GetConVar("textscreen_text" .. i):GetString() )

		textBox[i].OnTextChanged = function()
			labels[i]:SetText(textBox[i]:GetValue())
		end

		CPanel:AddItem(textBox[i])

		typeComboBoxLabel = CPanel:AddControl("Label", {
			Text = "Тип",
			Description = "Тип"
		})

		typeComboBox[i] = vgui.Create("DComboBox")
		typeComboBox[i]:SetConVar("textscreen_type" .. i)
		typeComboBox[i]:SetValue( GetConVar("textscreen_type" .. i):GetInt() )
		for k,v in pairs( types ) do
			typeComboBox[i]:AddChoice( k, v )
		end
		typeComboBox[i].OnSelect = function( pnl, index, val, data )
			GetConVar("textscreen_type" .. i):SetInt( data )

			colorComboBox[i]:Clear()
			for k, v in pairs( colors[GetConVar("textscreen_type" .. i):GetInt()] ) do
				colorComboBox[i]:AddChoice( k )
			end

			fontComboBox[i]:Clear()
			for k, v in pairs( fonts[GetConVar("textscreen_type" .. i):GetInt()] ) do
				fontComboBox[i]:AddChoice( v )
			end
		end

		CPanel:AddItem(typeComboBox[i])

		fontComboBoxLabel = CPanel:AddControl("Label", {
			Text = "Шрифт",
			Description = "Шрифт"
		})

		fontComboBox[i] = vgui.Create("DComboBox")
		fontComboBox[i]:SetConVar("textscreen_font" .. i)
		fontComboBox[i]:SetValue( GetConVar("textscreen_font" .. i):GetString() )
		for k,v in pairs( fonts[GetConVar("textscreen_type" .. i):GetInt()] ) do
			fontComboBox[i]:AddChoice( v )
		end
		fontComboBox[i].OnSelect = function( pnl, index, val )
			GetConVar("textscreen_font" .. i):SetString( val )
			labels[i]:SetFont( TS_GET_FONT( val, GetConVar("textscreen_size" .. i):GetInt() ) )
		end

		CPanel:AddItem(fontComboBox[i])

		colorComboBoxLabel = CPanel:AddControl("Label", {
			Text = "Цвет",
			Description = "Цвет"
		})

		colorComboBox[i] = vgui.Create("DComboBox")
		colorComboBox[i]:SetConVar("textscreen_col" .. i)
		colorComboBox[i]:SetValue( GetConVar("textscreen_col" .. i):GetString() )
		for k,v in pairs( colors[GetConVar("textscreen_type" .. i):GetInt()] ) do
			colorComboBox[i]:AddChoice( k )
		end
		colorComboBox[i].OnSelect = function( pnl, index, val )
			GetConVar("textscreen_col" .. i):SetString( val )
		end

		CPanel:AddItem(colorComboBox[i])

		if checkAccess(LocalPlayer()) then
			local mixer = CPanel:AddControl("Color", {
				Label = "Цвет строки " .. i,
				Red = "textscreen_r" .. i,
				Green = "textscreen_g" .. i,
				Blue = "textscreen_b" .. i,
				Alpha = "textscreen_a" .. i,
				ShowHSV = 1,
				ShowRGB = 1,
				Multiplier = 255
			})

			colTypeComboBox[i] = vgui.Create("DComboBox")
			colTypeComboBox[i]:SetConVar("textscreen_coltype" .. i)
			colTypeComboBox[i]:SetValue( GetConVar("textscreen_coltype" .. i):GetString() )
			colTypeComboBox[i]:AddChoice("Цвет из списка", 1)
			colTypeComboBox[i]:AddChoice("Цвет из миксера", 2)
			colTypeComboBox[i].OnSelect = function( pnl, index, val, data )
				GetConVar("textscreen_coltype" .. i):SetInt( data )
			end
	
			CPanel:AddItem(colTypeComboBox[i])
		end

		labels[i] = CPanel:Add("DLabel")
		labels[i]:SetText( "Пример текста " .. i )
		labels[i]:SetFont( "Default", 35 )
		labels[i]:DockMargin(12, 12, 12, 12)
		labels[i]:SetPos(0, 5)
		labels[i].Think = function()
			local color = Color(255, 255, 255)

			if (GetConVar("textscreen_coltype" .. i):GetInt() == 1) then 
				for k, v in pairs( colors[GetConVar("textscreen_type" .. i):GetInt()] ) do
					if k ~= GetConVar("textscreen_col" .. i):GetString() then continue end
					color = v
					break
				end
			else
				color = Color(
						GetConVar("textscreen_r" .. i):GetInt(),
						GetConVar("textscreen_g" .. i):GetInt(),
						GetConVar("textscreen_b" .. i):GetInt(),
						GetConVar("textscreen_a" .. i):GetInt()
					)
			end
			
			labels[i]:SetColor(color)
		end
		labels[i].Paint = function( pnl, w, h )
			draw.RoundedBox(2, -5, -5, w + 5, h + 5, Color(66, 43, 62, 155))
		end
	end
end
