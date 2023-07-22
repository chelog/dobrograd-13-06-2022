
-- Copyright (C) 2016-2018 DBot

-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
-- of the Software, and to permit persons to whom the Software is furnished to do so,
-- subject to the following conditions:

-- The above copyright notice and this permission notice shall be included in all copies
-- or substantial portions of the Software.

-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
-- INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
-- PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
-- FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
-- OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
-- DEALINGS IN THE SOFTWARE.


surface.CreateFont('BuyCSSFont', {
	font = 'Comic Sans MS',
	size = 32
})

surface.CreateFont('BuyCSSFont2', {
	font = 'Comic Sans MS',
	size = 24
})

surface.CreateFont('BuyDLibPremium', {
	font = 'PT Serif',
	size = 32
})

surface.CreateFont('BuyRTFont', {
	font = 'Roboto',
	size = 48
})

surface.CreateFont('BuyFontsFont', {
	font = 'Times New Roman',
	size = 32
})

local ENABLED = CreateConVar('dlib_replace_missing_textures', '0', {FCVAR_ARCHIVE}, 'Replace missing textures with something less boring')
local buy_rt = GetRenderTargetEx('buy_counter_strike', 128, 128, RT_SIZE_NO_CHANGE, MATERIAL_RT_DEPTH_SHARED, 0, CREATERENDERTARGETFLAGS_UNFILTERABLE_OK, IMAGE_FORMAT_RGB888)

local Textings = {
	{'buy\ncounter\nstrike', 'BuyCSSFont'},
	{'buy\ndlib\npremium', 'BuyDLibPremium'},
	{'install\ndlib\nv3', 'BuyDLibPremium'},
	{'go play\nvalve idiot', 'BuyDLibPremium'},
	{'put texture\nHere!!1', 'BuyDLibPremium'},
	{'hl2.exe\nis\ndumb', 'Default'},
	{'F U C K\nBUY CSS\nF U C K', 'BuyCSSFont'},
	{'here, buy\nyourself some\ncounter-strike', 'BuyCSSFont2'},
	{':RT:', 'BuyRTFont'},
	{':missing:', 'BuyRTFont'},
	{'Times\nNew\nRumanian', 'BuyFontsFont'},
	{':missing_texture:', 'BuyFontsFont'},
	{'install\nnew\nfonts', 'BuyFontsFont'},
	{'use\ncomic sans', 'BuyFontsFont'},
	{'you forgot\nyour texture', 'BuyDLibPremium'},
	{'buy yourself\nsome textures', 'BuyFontsFont'},
	{'texture\nGone\nMISSING', 'BuyDLibPremium'},
	{'dlib did nothing\nto this missing\nTEXTURE', 'BuyCSSFont2'},
	{'no missing\ntextures for\nU', 'BuyCSSFont2'},
}

local Backgrounds = {
	Color(),
	Color(77, 202, 233),
	Color(20, 246, 227),
	Color(67, 216, 92),
	Color(169, 67, 216),
	Color(204, 227, 75),
	Color(227, 172, 75),
	Color(210, 110, 50),
	Color(221, 75, 181),
	Color(216, 51, 82),
	Color(123, 28, 196),
}

local draw = draw
local surface = surface
local render = render
local cam = cam
local Material = Material
local RealTimeL = RealTimeL
local LerpQuintic = LerpQuintic
local errormat

local BackgroundIndex = 1
local BackgroundStart = 0
local BackgroundNext = 0
local BackgroundColorCurrent, BackgroundColorState, BackgroundColorNext

local CurrentText, CurrentFont
local NextText = 0
local LocalPlayer = LocalPlayer
local nextTraceCheck = 0

local function RedrawRT()
	if not ENABLED:GetBool() then return end
	local compute = false

	if not errormat then
		errormat = Material('__error')
		DLib.ErrorTexture = DLib.ErrorTexture or errormat:GetTexture('$basetexture')
		compute = true
	end

	local time = RealTimeL()

	if time > BackgroundNext then
		BackgroundIndex = BackgroundIndex + 1

		if BackgroundIndex > #Backgrounds then
			BackgroundIndex = 1
			BackgroundColorCurrent = Backgrounds[1]
			BackgroundColorNext = Backgrounds[2]
		elseif BackgroundIndex == #Backgrounds then
			BackgroundColorCurrent = Backgrounds[BackgroundIndex]
			BackgroundColorNext = Backgrounds[1]
		else
			BackgroundColorCurrent = Backgrounds[BackgroundIndex]
			BackgroundColorNext = Backgrounds[BackgroundIndex + 1]
		end

		BackgroundStart = time
		BackgroundNext = time + 20
	end

	if time > NextText then
		local data = table.frandom(Textings)
		CurrentText, CurrentFont = data[1], data[2]
		NextText = time + math.random(60, 120)
	end

	BackgroundColorState = BackgroundColorCurrent:Lerp(time:progression(BackgroundStart, BackgroundNext), BackgroundColorNext)

	render.PushRenderTarget(buy_rt)
	cam.Start2D()

	draw.NoTexture()
	surface.SetDrawColor(BackgroundColorState)
	surface.DrawRect(0, 0, 128, 128)
	draw.DrawText(CurrentText, CurrentFont, 64, 18, BackgroundColorState:Invert(), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	render.CopyRenderTargetToTexture(DLib.ErrorTexture)

	cam.End2D()
	render.PopRenderTarget()

	if compute then
		errormat:SetTexture('$basetexture', buy_rt)
		errormat:Recompute()
	end

	if time > nextTraceCheck then
		local tr = LocalPlayer():GetEyeTrace()
		local HitTexture = tr.HitTexture

		if HitTexture then
			local mat = Material(HitTexture)

			if mat and mat:IsError() then
				--local tex = mat:GetTexture('$basetexture')
				--local tex2 = mat:GetTexture('$refracttexture')
				--local check1 = not tex or tex:GetName() == '__error' or tex:GetName() == 'error'
				--local check2 = not tex2 or tex2:GetName() == '__error' or tex2:GetName() == 'error'

				mat:SetTexture('$basetexture', buy_rt)
				mat:Recompute()
			end
		end

		nextTraceCheck = time + 1
	end
end

hook.Add('PostRender', 'DLib.BuyCounterStrike', RedrawRT)
