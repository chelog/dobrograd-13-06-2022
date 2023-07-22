TOOL.Category		= "Construction"
TOOL.Name			= "#Tool.weight.name"
TOOL.Command		= nil
TOOL.ConfigName		= ""

TOOL.ClientConVar["set"] = "1"

if CLIENT then
	language.Add( "Tool.weight.name", "Weight" )
	language.Add( "Tool.weight.desc", "Изменяет массу объекта" )
	language.Add( "Tool.weight.0", "Primary: Set   Secondary: Copy   Reload: Reset" )
	language.Add( "Tool.weight.set", "Масса:" )
	language.Add( "Tool.weight.set_desc", "Установить массу" )
	language.Add( "Tool.weight.zeromass", "Масса должна быть больше 0!" )
else
	util.AddNetworkString "WeightSTool_1"
	Weights = Weights or {}
end

local function SetMass( Player, Entity, Data )
	if not SERVER then return end

	if Data.Mass then
		local physobj = Entity:GetPhysicsObject()
		if physobj:IsValid() then physobj:SetMass(math.Clamp(Data.Mass, 0.1, 10000)) end
	end

	duplicator.StoreEntityModifier( Entity, "mass", Data )
end
duplicator.RegisterEntityModifier( "mass", SetMass )

local function IsReallyValid(trace)
	if not trace.Entity:IsValid() then return false end
	if trace.Entity:IsPlayer() then return false end
	if SERVER and not trace.Entity:GetPhysicsObject():IsValid() then return false end
	return true
end

function TOOL:LeftClick( trace )
	if CLIENT and IsReallyValid(trace) then return true end
	if not IsReallyValid(trace) then return false end
	
	if not Weights[trace.Entity:GetModel()] then 
		Weights[trace.Entity:GetModel()] = trace.Entity:GetPhysicsObject():GetMass() 
	end
	local mass = tonumber(self:GetClientInfo("set"))
	
	if mass > 0 then
		SetMass( self:GetOwner(), trace.Entity, { Mass = mass } )
	else
		net.Start("WeightSTool_1")
		net.Send(self:GetOwner())
		--umsg.Start("WeightSTool_1", self:GetOwner()) 
		--umsg.End()
	end
	
	return true;
end

function TOOL:RightClick( trace )
	if CLIENT and IsReallyValid(trace) then return true end
	if not IsReallyValid(trace) then return end
	
	local mass = trace.Entity:GetPhysicsObject():GetMass()
	self:GetOwner():ConCommand("weight_set "..mass);
	return true;
end

function TOOL:Reload( trace )
	if CLIENT then return false end
	if not IsReallyValid(trace) then return false end
	local pl = self:GetOwner()
	local weight = Weights[trace.Entity:GetModel()]
	if not weight then return end
	
	SetMass( self:GetOwner(), trace.Entity, { Mass = weight } )
	
	self.Weapon:EmitSound( Sound( "Airboat.FireGunRevDown" )	)
	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
	
	local effectdata = EffectData()
		effectdata:SetOrigin( trace.HitPos )
		effectdata:SetNormal( trace.HitNormal )
		effectdata:SetEntity( trace.Entity )
		effectdata:SetAttachment( trace.PhysicsBone )
	util.Effect( "selection_indicator", effectdata )	
	
	local effectdata = EffectData()
		effectdata:SetOrigin( trace.HitPos )
		effectdata:SetStart( pl:GetShootPos() )
		effectdata:SetAttachment( 1 )
		effectdata:SetEntity( self.Weapon )
	util.Effect( "ToolTracer", effectdata )
	
	return false
end

function TOOL:Think()
	if CLIENT then return end
	local pl = self:GetOwner()
	local wep = pl:GetActiveWeapon()
	if not wep:IsValid() or wep:GetClass() != "gmod_tool" or pl:GetInfo("gmod_toolmode") != "weight" then return end
	local trace = pl:GetEyeTrace()
	if not IsReallyValid(trace) then return end
	if not Weights[trace.Entity:GetModel()] then 
		Weights[trace.Entity:GetModel()] = trace.Entity:GetPhysicsObject():GetMass() 
	end
	pl:SetNetworkedFloat("WeightMass", trace.Entity:GetPhysicsObject():GetMass())
	pl:SetNetworkedFloat("OWeight", Weights[trace.Entity:GetModel()] or 0)
end

function TOOL.BuildCPanel( cp )
	cp:AddControl( "Header", { Text = "#Tool.weight.name", Description	= "#Tool.weight.desc" }  )

	local params = { Label = "#Presets", MenuButton = 1, Folder = "weight", Options = {}, CVars = {} }
	
	params.Options.default = { weight_set = 3 }
	table.insert( params.CVars, "weight_set" )
	
	cp:AddControl("ComboBox", params )
	cp:AddControl("Slider", { Label = "#Tool.weight.set", Type = "Float", Min = "0.01", Max = "10000", Command = "weight_set" } )
	-- cp:AddControl("Slider", { Label = "Tooltip Scale:", Type = "Numeric", Min = "100", Max = "10000", Command = "weight_tooltip_scale" } )
end

if CLIENT then
-- 	local TipColor = Color( 250, 250, 200, 255 )

-- 	surface.CreateFont("NewTooltip", {font = "coolvetica", size = 300, weight = 500})
-- 	surface.CreateFont("GModWorldtip", {font = "coolvetica", size = 24, weight = 500})
	
-- 	local function DrawWeight()
-- 		local pl = LocalPlayer()
-- 		local wep = pl:GetActiveWeapon()

-- 		if not wep:IsValid() or wep:GetClass() != "gmod_tool" or pl:GetInfo("gmod_toolmode") != "weight" then return end
		
-- 		local trace = pl:GetEyeTrace()
-- 		if not IsReallyValid(trace) then return end

-- 		local ang = LocalPlayer():EyeAngles()
-- 		ang:RotateAroundAxis(LocalPlayer():GetForward(), 270)
-- 		ang:RotateAroundAxis(LocalPlayer():GetRight(), -180)
-- 		ang:RotateAroundAxis(LocalPlayer():GetUp(), 90)
-- 		ang = Angle(0, ang.y, ang.r)

-- 		local rOBB = trace.Entity:OBBCenter()
-- 		rOBB:Rotate(trace.Entity:GetAngles())

-- 		local black = Color( 0, 0, 0, 255 )
-- 		local tipcol = Color( TipColor.r, TipColor.g, TipColor.b, 255 )
		
-- 		local mass = LocalPlayer():GetNetworkedFloat("WeightMass") or 0
-- 		local omass = LocalPlayer():GetNetworkedFloat("OWeight") or 0
-- 		local str = "Current: " .. mass .. ", Original: " .. omass
-- 		cam.IgnoreZ(true)
-- 		if (GetConVarNumber("weight_tooltip_old") == 0) then
-- 			surface.SetFont("NewTooltip")
-- 			local w,h = surface.GetTextSize(str)
-- 			cam.Start3D2D(trace.Entity:GetPos()+rOBB, ang, trace.StartPos:Distance(trace.Entity:GetPos()+rOBB)/GetConVarNumber("weight_tooltip_scale"))
-- 				surface.SetDrawColor(Color(0, 0, 0, 100))
-- 				surface.DrawRect(-w/2 - 5, -h/2, w + 10, h)
-- 				surface.SetTextPos(0 - w/2, -h/2)
-- 				surface.SetTextColor(Color(255,255,255))
-- 				surface.DrawText(str) 
-- 		else
-- 			surface.SetFont("GModWorldtip")
-- 			local w,h = surface.GetTextSize(str)
-- 			cam.Start3D2D(trace.Entity:GetPos()+rOBB, ang, trace.StartPos:Distance(trace.Entity:GetPos()+rOBB)/700)
-- 				local x,y = -w/1.5, -50
-- 				local offset = 30
-- 				local padding = 10 -- Does what it says on the tin
-- 				-- Old draw method
-- 				-- Outline
-- 				draw.RoundedBox( 8, x-padding-2, y-padding-2, w+padding*2+4, h+padding*2+4, black )
-- 				local verts = {}
-- 				verts[1] = { x=x+(w/1.5)-offset-3, y=y+h }
-- 				verts[2] = { x=x+(w/1.5)+offset+3, y=y+h/2 }
-- 				verts[3] = { x=0, y=2 }
-- 				draw.NoTexture()
-- 				surface.SetDrawColor( 0, 0, 0, tipcol.a )
-- 				surface.DrawPoly( verts )

-- 				-- Inner "Yellow"
-- 				draw.RoundedBox( 8, x-padding, y-padding, w+padding*2, h+padding*2, tipcol )
-- 				local verts = {}
-- 				verts[1] = { x=x+(w/1.5)-offset, y=y+h }
-- 				verts[2] = { x=x+(w/1.5)+offset, y=y+h/2 }
-- 				verts[3] = { x=0, y=0 }			
-- 				draw.NoTexture()
-- 				surface.SetDrawColor( tipcol.r, tipcol.g, tipcol.b, tipcol.a )
-- 				surface.DrawPoly( verts )

-- 				-- Actual Text
-- 				draw.DrawText( str, "GModWorldtip", x + w/2, y, black, TEXT_ALIGN_CENTER )
-- 		end
-- 		cam.End3D2D()
-- 		cam.IgnoreZ(false)
-- 	end
-- 	hook.Add("PreDrawEffects", "DrawWeight", DrawWeight)
	
	local function ZMass()
		LocalPlayer():ConCommand("weight_set 1")
		GAMEMODE:AddNotify("#Tool.weight.zeromass", NOTIFY_ERROR, 6);
		surface.PlaySound( "buttons/button10.wav" )
	end
	net.Receive("WeightSTool_1", ZMass)

-- 	CreateClientConVar("weight_tooltip_old", "0", true, false)
-- 	CreateClientConVar("weight_tooltip_scale", "1600", true, false)
end
