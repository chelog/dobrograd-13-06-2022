local Mybuffs = {}

surface.CreateFont( "Drugz_Font1", { font = "Trebuchet", size = 16, weight = 800, antialias = true } )

net.Receive( "UpdateBuffs", function( length ) -- this net message is recieved once per frame
Mybuffs = net.ReadTable()
end)

net.Receive( "SendBuffs", function( length )
local fag = net.ReadEntity()
local drugtab = net.ReadTable()
local rekt = false
if table.ToString(drugtab, false) == "{}" then chat.AddText( Color(0,205,50), L.clear_drug:format(fag:Nick()) ) return end
chat.AddText( Color(0,205,50), L.on_drugs:format(fag:Nick()) )

	for k, v in pairs(drugtab) do
	local ref = Drugmod_Buffs[k]
	if ref.Illegal then chat.AddText( Color(255,0,0), k ) rekt = true else chat.AddText( Color(0,155,150), k ) end
	end

if rekt then chat.AddText( Color(255,0,0), L.illegal_drugs_hint ) else chat.AddText( Color(0,205,50), L.not_found_illegal_drugs_hint ) end

end)

local dividebuffs = 50
local startstack = (ScrH() / 2)

local function DrawBuffs()

local grad = Material( "gui/gradient" )
local i = 1
for k, v in pairs(Mybuffs) do
	if not Drugmod_Buffs[k] then continue end
	i = i + 1
	local dcol = Drugmod_Buffs[k].Col
	surface.SetDrawColor(Color(30, 30, 30, 255))
	surface.DrawRect( 0, startstack - ( i * dividebuffs ) + 8, 205, 45 )
	surface.SetDrawColor(Color(dcol.r, dcol.g, dcol.b, 100))
	surface.SetMaterial( grad )
	surface.DrawTexturedRect( 205, startstack - ( i * dividebuffs ) + 8, 30, 45 )
--	surface.DrawRect( 200, startstack - ( i * dividebuffs ) + 8, 5, 45 )
	surface.DrawRect( 0, startstack - ( i * dividebuffs ) + 8, 205, 2 )
	draw.SimpleText( Drugmod_Buffs[k].ItemName, "Trebuchet18", 5, startstack - ( (i * dividebuffs) - 12 ), Drugmod_Buffs[k].Col, 0, 0 )
	draw.SimpleText( math.Round(math.Clamp(v - CurTime(), 1, v - CurTime() + 1)), "Trebuchet18", 175, startstack - ( (i * dividebuffs) - 12 ), Color(255,255,255, 255), 0, 0 )
--	draw.SimpleText( Drugmod_Buffs[k].Description, "PopuliHUD2", 5, ScrH() / 2 - ( (i * 30) - 30 ), Color(200,200,200,255), 0, 0 )
	draw.DrawText( Drugmod_Buffs[k].Description, "Trebuchet18", 5, startstack - ( (i * dividebuffs) - 30 ), Color(200,200,200,255) )
end

end
--hook.Add("HUDPaint", "drawmybuffs", DrawBuffs)

hook.Add("RenderScreenspaceEffects", "test", function()
for k, v in pairs(Mybuffs) do
	if !Drugmod_Buffs[k] then continue end
	local tbl = Drugmod_Buffs[k]
	if tbl.ColorModify then DrawColorModify( tbl.ColorModify ) end
	if tbl.MotionBlur then DrawMotionBlur( tbl.MotionBlur[1], tbl.MotionBlur[2], tbl.MotionBlur[3] ) end
	if tbl.SobelEffect then DrawSobel( tbl.SobelEffect ) end
	if tbl.Sharpen then DrawSharpen( tbl.Sharpen[1], tbl.Sharpen[2] ) end
--	if tbl.Bloom then DrawBloom( 0.35, 2, 9, 9, 1, 1, 1, 1, 1 ) end

	if k == "Drunk" then
		local dmul = (v - CurTime()) / 90
		DrawMotionBlur( (dmul / 8), (dmul / 2), 0.01 )
	end

	if k == "Pingaz" then
		local dmul = (v - CurTime()) / 180
		local bmul = (math.abs(math.sin(RealTime() * math.pi * 1.5))) / 3
		DrawBloom( (1 -  bmul) * (1.5 - dmul), 2, 9, 9, 1, 1, 1, 1, 1 )
--		DrawMotionBlur( (dmul / 8), (dmul / 2), 0.01 )
	end

end

end)


--[[ hook.Add("HUDPaint", "DrawDrugs", function()

	local tr = LocalPlayer():GetEyeTrace()
	if !tr.Entity:IsValid() or !tr.Entity.DrugDescription or LocalPlayer():GetPos():Distance( tr.Entity:GetPos() ) > 200 then return end
	local ent = tr.Entity

	local p = ent:GetPos():ToScreen()
	surface.SetFont( "Default" )
	local offx, offy = surface.GetTextSize(ent.DrugDescription)
	if !ent.DrugLegal then offy = offy + 15 end

	surface.SetDrawColor(Color(30,30,30, 180))
	surface.DrawRect( (p.x - 5) - (offx/2), p.y - 15, offx + 10, offy + 20 )

	draw.SimpleText(ent.PrintName,"Drugz_Font1",p.x,p.y - 8 , ent.DrugColor,1, 1)
	if !ent.DrugLegal then draw.SimpleText(L.illegal,"Drugz_Font1",p.x,(p.y + offy) - 6 , Color(255,0,0),1, 1) end

	draw.DrawText(ent.DrugDescription,"Default",p.x,p.y,Color(255,255,255, 150),1)

end)
 ]]

local smoothing
local Speedmul, SmoothHorizontal, SmoothVertical = 0,0,0
local count = 0
local sign
local side
local value
local swayspeed = 0.02

timer.Create( "DM_viewswayiterate", 0.01, 0, function()
	if !LocalPlayer():IsValid() or !Mybuffs["Drunk"] or !LocalPlayer():Alive() then return end
	Speedmul = swayspeed * 8
	count = count + ( swayspeed * 11 ) * Speedmul
--	smoothing = Lerp(0.01 * 5, smoothing, ( fov2 + Speedmul * 2 ))
	SmoothHorizontal = -math.abs( math.sin(count) * 1 )
	SmoothVertical = math.sin(count)*1.5
end)

function Drunkview( ply, pos, ang, fov )
	if ply:InVehicle() or ply:GetObserverMode() != OBS_MODE_NONE then return end
	if !Mybuffs["Drunk"] then return end
--	if LocalPlayer():GetActiveWeapon().Base == "cw_base" then return end

	local view = dbgView.calcView(ply, pos, ang, fov)

--	if not smoothing then smoothing = fov end

	local dmul = (Mybuffs["Drunk"] - CurTime()) / 90
	local ang = view.angles

	ang:RotateAroundAxis(ang:Right(), SmoothHorizontal * dmul)
	ang:RotateAroundAxis(ang:Up(), (SmoothVertical * 0.5) * dmul)
	ang:RotateAroundAxis(ang:Forward(), (SmoothVertical * 2) * dmul )

	view.angles = ang
	view.fov = view.fov + (-SmoothVertical * 2) * dmul

	return view
end

hook.Add( "CalcView", "DM_Drunkview", Drunkview, -5 )
