
TOOL.Category = "Construction"
TOOL.Name = "#tool.light.name"

TOOL.ClientConVar[ "ropelength" ] = "64"
TOOL.ClientConVar[ "ropematerial" ] = "cable/rope"
TOOL.ClientConVar[ "r" ] = "255"
TOOL.ClientConVar[ "g" ] = "255"
TOOL.ClientConVar[ "b" ] = "255"
TOOL.ClientConVar[ "brightness" ] = "2"
TOOL.ClientConVar[ "size" ] = "256"
TOOL.ClientConVar[ "key" ] = "-1"
TOOL.ClientConVar[ "toggle" ] = "1"
TOOL.ClientConVar[ "invisible" ] = "0"

TOOL.Information = {
	{ name = "left" },
	{ name = "right" }
}

cleanup.Register( "lights" )

function TOOL:LeftClick( trace, attach )

	if ( IsValid( trace.Entity ) && trace.Entity:IsPlayer() ) then return false end
	if ( CLIENT ) then return true end
	if ( attach == nil ) then attach = true end

	-- If there's no physics object then we can't constraint it!
	if ( SERVER && attach && !util.IsValidPhysicsObject( trace.Entity, trace.PhysicsBone ) ) then return false end

	local ply = self:GetOwner()

	local pos, ang = trace.HitPos + trace.HitNormal * 8, trace.HitNormal:Angle() - Angle( 90, 0, 0 )

	local r = math.Clamp( self:GetClientNumber( "r" ), 0, 255 )
	local g = math.Clamp( self:GetClientNumber( "g" ), 0, 255 )
	local b = math.Clamp( self:GetClientNumber( "b" ), 0, 255 )
	local brght = math.Clamp( self:GetClientNumber( "brightness" ), 0, 255 )
	local size = self:GetClientNumber( "size" )
	local toggle = self:GetClientNumber( "toggle" ) != 1

	local key = self:GetClientNumber( "key" )

	if ( IsValid( trace.Entity ) && trace.Entity:GetClass() == "gmod_light" && trace.Entity:GetPlayer() == ply ) then

		trace.Entity:SetLightColor( Color( r, g, b, 255 ):ToVector() )
		trace.Entity.r = r
		trace.Entity.g = g
		trace.Entity.b = b
		trace.Entity.Brightness = brght
		trace.Entity.Size = size

		trace.Entity:SetBrightness( brght )
		trace.Entity:SetLightSize( size )
		trace.Entity:SetToggle( !toggle )

		trace.Entity.KeyDown = key

		numpad.Remove( trace.Entity.NumDown )
		numpad.Remove( trace.Entity.NumUp )

		trace.Entity.NumDown = numpad.OnDown( ply, key, "LightToggle", trace.Entity, 1 )
		trace.Entity.NumUp = numpad.OnUp( ply, key, "LightToggle", trace.Entity, 0 )

		return true

	end

	if ( !self:GetSWEP():CheckLimit( "lights" ) ) then return false end

	local lamp = MakeLight( ply, r, g, b, brght, size, toggle, !toggle, key, { Pos = pos, Angle = ang } )

	undo.Create( "Light" )
		undo.AddEntity( lamp )

		if ( attach ) then

			local length = math.Clamp( self:GetClientNumber( "ropelength" ), 4, 1024 )
			local material = self:GetClientInfo( "ropematerial" )

			local LPos1 = Vector( 0, 0, 5 )
			local LPos2 = trace.Entity:WorldToLocal( trace.HitPos )

			if ( IsValid( trace.Entity ) ) then

				local phys = trace.Entity:GetPhysicsObjectNum( trace.PhysicsBone )
				if ( IsValid( phys ) ) then
					LPos2 = phys:WorldToLocal( trace.HitPos )
				end

			end

			local constraint, rope = constraint.Rope( lamp, trace.Entity, 0, trace.PhysicsBone, LPos1, LPos2, 0, length, 0, 1, material )

			undo.AddEntity( rope )
			undo.AddEntity( constraint )
			ply:AddCleanup( "lights", rope )
			ply:AddCleanup( "lights", constraint )

		end

		undo.SetPlayer( ply )
	undo.Finish()

	return true

end

function TOOL:RightClick( trace )

	return self:LeftClick( trace, false )

end

if ( SERVER ) then

	function MakeLight( pl, r, g, b, brght, size, toggle, on, KeyDown, Data )

		if ( IsValid( pl ) && !pl:CheckLimit( "lights" ) ) then return false end

		local lamp = ents.Create( "gmod_light" )
		if ( !IsValid( lamp ) ) then return end

		duplicator.DoGeneric( lamp, Data )

		local dt = Data and Data.DT or {}
		local color = Data and Data.EntityMods and Data.EntityMods.colour and Data.EntityMods.colour.Color or color_white

		lamp:SetLightColor(Color(r or color.r, g or color.g, b or color.b, 255 or color.a):ToVector())
		lamp:SetBrightness( brght or dt.Brightness )
		lamp:SetLightSize( size or dt.LightSize )
		lamp:SetToggle( !toggle or dt.Toggle )
		lamp:SetOn( on or dt.On )

		lamp:Spawn()

		duplicator.DoGenericPhysics( lamp, pl, Data )

		lamp:SetPlayer( pl )

		lamp.lightr = r
		lamp.lightg = g
		lamp.lightb = b
		lamp.Brightness = brght
		lamp.Size = size
		lamp.KeyDown = KeyDown
		lamp.on = on


		if ( IsValid( pl ) ) then
			lamp.NumDown = numpad.OnDown( pl, KeyDown, "LightToggle", lamp, 1 )
			lamp.NumUp = numpad.OnUp( pl, KeyDown, "LightToggle", lamp, 0 )
			pl:AddCount( "lights", lamp )
			pl:AddCleanup( "lights", lamp )
		end

		return lamp

	end
	duplicator.RegisterEntityClass( "gmod_light", MakeLight, "lightr", "lightg", "lightb", "Brightness", "Size", "Toggle", "on", "KeyDown", "Data" )

	local function Toggle( pl, ent, onoff )

		if ( !IsValid( ent ) ) then return false end
		if ( !ent:GetToggle() ) then ent:SetOn( onoff == 1 ) return end

		if ( numpad.FromButton() ) then

			ent:SetOn( onoff == 1 )
			return

		end

		if ( onoff == 0 ) then return end

		return ent:Toggle()

	end
	numpad.Register( "LightToggle", Toggle )

end

function TOOL:UpdateGhostLight( ent, pl )

	if ( !IsValid( ent ) ) then return end

	local trace = pl:GetEyeTrace()
	if ( !trace.Hit || IsValid( trace.Entity ) && ( trace.Entity:IsPlayer() || trace.Entity:GetClass() == "gmod_light" ) ) then

		ent:SetNoDraw( true )
		return

	end

	ent:SetPos( trace.HitPos + trace.HitNormal * 8 )
	ent:SetAngles( trace.HitNormal:Angle() - Angle( 90, 0, 0 ) )

	ent:SetNoDraw( false )

end

function TOOL:Think()

	if ( !IsValid( self.GhostEntity ) || self.GhostEntity:GetModel() != "models/maxofs2d/light_tubular.mdl" ) then
		self:MakeGhostEntity( "models/maxofs2d/light_tubular.mdl", Vector( 0, 0, 0 ), Angle( 0, 0, 0 ) )
	end

	self:UpdateGhostLight( self.GhostEntity, self:GetOwner() )

end

local ConVarsDefault = TOOL:BuildConVarList()

function TOOL.BuildCPanel( CPanel )

	CPanel:AddControl( "Header", { Description = "#tool.light.desc" } )

	CPanel:AddControl( "ComboBox", { MenuButton = 1, Folder = "light", Options = { [ "#preset.default" ] = ConVarsDefault }, CVars = table.GetKeys( ConVarsDefault ) } )

	CPanel:AddControl( "Button", { Label = "Подсветить источники", Command = "dbg_light_debug" } )

	CPanel:AddControl( "Numpad", { Label = "#tool.light.key", Command = "light_key", ButtonSize = 22 } )

	CPanel:Help(L.light_hint)
	CPanel:AddControl( "Slider", { Label = L.wire_lenght, Command = "light_ropelength", Type = "Float", Min = 0, Max = 50 } )
	CPanel:AddControl( "Slider", { Label = L.light_brightness, Command = "light_brightness", Type = "Int", Min = 0, Max = 2 } )
	CPanel:AddControl( "Slider", { Label = L.light_size, Command = "light_size", Type = "Float", Min = 0, Max = 350 } )

	CPanel:AddControl( "Checkbox", { Label = "#tool.light.toggle", Command = "light_toggle" } )

	CPanel:AddControl( "Color", { Label = "#tool.light.color", Red = "light_r", Green = "light_g", Blue = "light_b" } )

end

if CLIENT then

	local lightDebug = false

	hook.Add('PostDrawTranslucentRenderables', 'dbg-light.debug', function()

		if not lightDebug then return end

		local ply = LocalPlayer()
		local admin = ply:IsAdmin()
		for _,v in ipairs(ents.FindInSphere(ply:GetShootPos(), 500)) do
			if v:GetClass() == 'gmod_light' and (admin or v:CPPIGetOwner() == ply) then
				render.DrawWireframeSphere(v:GetPos(), 9, 15, 15, v:GetLightColor():ToColor())
			end
		end

	end)

	concommand.Add('dbg_light_debug', function()
		lightDebug = true
		timer.Simple(5, function()
			lightDebug = false
		end)
	end)
end
