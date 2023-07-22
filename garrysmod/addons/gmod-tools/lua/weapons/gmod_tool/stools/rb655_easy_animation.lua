
TOOL.Category = "Robotboy655"
TOOL.Name = "#tool.rb655_easy_animation.name"
TOOL.AnimationArray = {}

local gLastSelecetedEntity = NULL
TOOL.SelecetedEntity = NULL

TOOL.ClientConVar[ "anim" ] = ""
TOOL.ClientConVar[ "speed" ] = "1.0"
TOOL.ClientConVar[ "delay" ] = "0"
TOOL.ClientConVar[ "nohide" ] = "0"
TOOL.ClientConVar[ "loop" ] = "0"

TOOL.ClientConVar[ "noglow" ] = "0"

local function MakeNiceName( str )
	local newname = {}
	for _, s in pairs( string.Explode( "_", string.Replace( str, " ", "_" ) ) ) do
		if ( string.len( s ) == 0 ) then continue end
		if ( string.len( s ) == 1 ) then table.insert( newname, string.upper( s ) ) continue end
		table.insert( newname, string.upper( string.Left( s, 1 ) ) .. string.Right( s, string.len( s ) - 1 ) ) -- Ugly way to capitalize first letters.
	end

	return string.Implode( " ", newname )
end

local function IsEntValid( ent )
	if ( !IsValid( ent ) or ent:IsWorld() ) then return false end
	if ( table.Count( ent:GetSequenceList() or {} ) != 0 ) then return true end
	return false
end

local function PlayAnimationBase( ent, anim, speed )
	if ( !IsValid( ent ) ) then return end

	-- HACK: This is not perfect, but it will have to do
	if ( ent:GetClass() == "prop_dynamic" ) then
		ent:Fire( "SetAnimation", anim )
		ent:Fire( "SetPlaybackRate", math.Clamp( tonumber( speed ), 0.05, 3.05 ) )
		return
	end

	ent:ResetSequence( ent:LookupSequence( anim ) )
	ent:ResetSequenceInfo()
	ent:SetCycle( 0 )
	ent:SetPlaybackRate( math.Clamp( tonumber( speed ), 0.05, 3.05 ) )

end

local UniqueID = 0
function PlayAnimation( ply, ent, anim, speed, delay, loop, isPreview )
	if ( !IsValid( ent ) ) then return end

	delay = tonumber( delay ) or 0
	loop = tobool( loop ) or false

	UniqueID = UniqueID + 1
	local tid = "rb655_animation_loop_" .. ply:UniqueID() .. "-" .. UniqueID

	if ( isPreview ) then tid = "rb655_animation_loop_preview" .. ply:UniqueID() end

	timer.Create( tid, delay, 1, function()
		PlayAnimationBase( ent, anim, speed )
		if ( loop == true && IsValid( ent ) ) then
			timer.Adjust( tid, ent:SequenceDuration() / speed, 0, function()
				if ( !IsValid( ent ) ) then timer.Remove( tid ) return end
				PlayAnimationBase( ent, anim, speed )
			end )
		end
	end )
end

function TOOL:GetSelecetedEntity()
	return self:GetWeapon():GetNWEntity( 1, self.SelecetedEntity )
end

function TOOL:SetSelecetedEntity( ent )
	if ( IsValid( ent ) && ent:GetClass() == "prop_effect" ) then ent = ent.AttachedEntity end
	if ( !IsValid( ent ) ) then ent = NULL end

	if ( self:GetSelecetedEntity() == ent ) then return end
	self.SelecetedEntity = ent

	self:GetWeapon():SetNWEntity( 1, ent )
end

local gOldCVar1 = GetConVarNumber( "ai_disabled" )
local gOldCVar2 = GetConVarNumber( "rb655_easy_animation_nohide" )

function TOOL:Think()
	local ent = self:GetSelecetedEntity()
	if ( !IsValid( ent ) ) then self:SetSelecetedEntity( NULL ) end

	if ( CLIENT ) then
		if ( gOldCVar1 != GetConVarNumber( "ai_disabled" ) or gOldCVar2 != GetConVarNumber( "rb655_easy_animation_nohide" ) ) then
			gOldCVar1 = GetConVarNumber( "ai_disabled" )
			gOldCVar2 = GetConVarNumber( "rb655_easy_animation_nohide" )
			if ( IsEntValid( ent ) && ent:IsNPC() ) then self:UpdateControlPanel() end
		end
		if ( ent:EntIndex() == gLastSelecetedEntity ) then return end
		gLastSelecetedEntity = ent:EntIndex()
		self:UpdateControlPanel()
		RunConsoleCommand( "rb655_easy_animation_anim", "" )
	end
end

function TOOL:RightClick( trace )
	if ( SERVER ) then self:SetSelecetedEntity( trace.Entity ) end
	return true
end

function TOOL:Reload( trace )
	if ( SERVER ) then
		if ( #self.AnimationArray <= 0 && IsValid( self:GetSelecetedEntity() ) ) then
			self:GetSelecetedEntity():SetPlaybackRate( 0 )
		elseif ( #self.AnimationArray > 0 ) then
			for id, t in pairs( self.AnimationArray ) do
				if ( IsValid( t.ent ) ) then t.ent:SetPlaybackRate( 0 ) end
			end
		end

		-- Destroy all timers.
		for i = 0, UniqueID do timer.Remove( "rb655_animation_loop_" .. self:GetOwner():UniqueID() .. "-" .. i ) UniqueID = 0 end
		timer.Remove( "rb655_animation_loop_preview" .. self:GetOwner():UniqueID() )
	end
	return true
end

if ( SERVER ) then
	util.AddNetworkString( "rb655_easy_animation_array" )

	function TOOL:LeftClick( trace )
		local ent = self:GetSelecetedEntity()
		local anim = self:GetClientInfo( "anim" )

		for i = 0, UniqueID do timer.Remove( "rb655_animation_loop_" .. self:GetOwner():UniqueID() .. "-" .. i ) UniqueID = 0 end
		timer.Remove( "rb655_animation_loop_preview" .. self:GetOwner():UniqueID() )

		if ( #self.AnimationArray > 0 ) then
			for id, t in pairs( self.AnimationArray ) do
				if ( !IsEntValid( t.ent ) or string.len( string.Trim( t.anim ) ) == 0 ) then continue end
				PlayAnimation( self:GetOwner(), t.ent, t.anim, t.speed, t.delay, t.loop )
			end
		else
			if ( !IsEntValid( ent ) or string.len( string.Trim( anim ) ) == 0 ) then return end
			PlayAnimation( self:GetOwner(), ent, anim, self:GetClientInfo( "speed" ), self:GetClientInfo( "delay" ), self:GetClientInfo( "loop" ), true )
		end

		return true
	end

	concommand.Add( "rb655_easy_animation_anim_do", function( ply, cmd, args )
		local tool = ply:GetTool( "rb655_easy_animation" )
		if ( !tool ) then return end
		local ent = tool:GetSelecetedEntity()

		if ( !IsEntValid( ent ) ) then return end

		for i = 0, UniqueID do timer.Remove( "rb655_animation_loop_" .. ply:UniqueID() .. "-" .. i ) UniqueID = 0 end
		timer.Remove( "rb655_animation_loop_preview" .. ply:UniqueID() )

		PlayAnimation( ply, ent, args[ 1 ], ply:GetTool( "rb655_easy_animation" ):GetClientInfo( "speed" ), 0, ply:GetTool():GetClientInfo( "loop" ), true )
	end )

	concommand.Add( "rb655_easy_animation_add", function( ply, cmd, args )
		local tool = ply:GetTool( "rb655_easy_animation" )
		if ( !tool ) then return end
		local e = tool:GetSelecetedEntity()
		local a = tool:GetClientInfo( "anim" )
		local s = tool:GetClientInfo( "speed" )
		local d = tool:GetClientInfo( "delay" )
		local l = tool:GetClientInfo( "loop" )
		if ( !IsEntValid( e ) or string.len( string.Trim( a ) ) == 0 ) then return end

		table.insert( tool.AnimationArray, {ent = e, anim = a, speed = s, delay = d, loop = l, ei = e:EntIndex()} )
		net.Start( "rb655_easy_animation_array" )
			net.WriteTable( tool.AnimationArray )
		net.Send( ply )
	end )

	concommand.Add( "rb655_easy_animation_rid", function( ply, cmd, args ) -- rid is for RemoveID
		local tool = ply:GetTool( "rb655_easy_animation" )
		if ( !tool.AnimationArray[ tonumber( args[ 1 ] ) ] ) then return end
		if ( tool.AnimationArray[ tonumber( args[ 1 ] ) ].ei != tonumber( args[ 2 ] ) && tonumber( args[ 2 ] ) != 0 ) then return end

		table.remove( tool.AnimationArray, tonumber( args[ 1 ] ) )
		net.Start( "rb655_easy_animation_array" )
			net.WriteTable( tool.AnimationArray )
		net.Send( ply )
	end )
end

if ( SERVER ) then return end

TOOL.Information = {
	{ name = "info", stage = 1 },
	{ name = "left" },
	{ name = "right" },
	{ name = "reload" },
}

language.Add( "tool.rb655_easy_animation.left", "Play all animations" )
language.Add( "tool.rb655_easy_animation.right", "Select an object to play animations on" )
language.Add( "tool.rb655_easy_animation.reload", "Pause currently playing animation(s)" )

language.Add( "tool.rb655_easy_animation.name", "Easy Animation Tool" )
language.Add( "tool.rb655_easy_animation.desc", "Easy animations for everyone" )
language.Add( "tool.rb655_easy_animation.1", "Use context menu to play animations" )

language.Add( "tool.rb655_easy_animation.animations", "Animations" )
language.Add( "tool.rb655_easy_animation.add", "Add current selection" )
language.Add( "tool.rb655_easy_animation.add.help", "\nIf you want to play animations on multiple entities at one:\n1) Select entity\n2) Select animation from the list, if the entity has any.\n3) Configure sliders to your desire.\n4) Click \"Add current selection\"\n5) Do 1-4 steps as many times as you wish.\n6) Left-click\n\nYou cannot play two animations on the same entity at the same time. The last animation will cut off the first one." )
language.Add( "tool.rb655_easy_animation.speed", "Animation Speed" )
language.Add( "tool.rb655_easy_animation.speed.help", "How fast the animation will play." )
language.Add( "tool.rb655_easy_animation.delay", "Delay" )
language.Add( "tool.rb655_easy_animation.delay.help", "The time between you left-click and the animation is played." )
language.Add( "tool.rb655_easy_animation.loop", "Loop Animation" )
language.Add( "tool.rb655_easy_animation.loop.help", "Play animation again when it ends." )
language.Add( "tool.rb655_easy_animation.nohide", "Do not filter animations" )
language.Add( "tool.rb655_easy_animation.nohide.help", "Enabling this option will show you the full list of animations available for selected entity. Please note, that this list can be so long, that GMod may freeze for a few seconds." )

language.Add( "tool.rb655_easy_animation.ai", "NPC is selected, but NPC thinking is not disabled!" )
language.Add( "tool.rb655_easy_animation.ragdoll", "Ragdolls cannot be animated! Open context menu (Hold C) > right click on ragdoll > Make Animatable" )
language.Add( "tool.rb655_easy_animation.prop", "Props cannot be animated properly! Open context menu (Hold C) > right click on entity > Make Animatable" )
language.Add( "tool.rb655_easy_animation.badent", "This entity does not have any animations." )
language.Add( "tool.rb655_easy_animation.noent", "No entity selected." )

language.Add( "tool.rb655_easy_animation.noglow", "Don't render glow/halo around models" )
language.Add( "tool.rb655_easy_animation.noglow.help", "Don't render glow/halo around models when they are selected, and don't draw bounding boxes below animated models. Bounding boxes are a helper for when animations make the ragdolls go outside of their bounding box making them unselectable.\n" )

language.Add( "tool.rb655_easy_animation.property", "Make Animatable" )
language.Add( "tool.rb655_easy_animation.property_ragdoll", "Make Ragdoll" )
language.Add( "prop_animatable", "Animatable Entity" )

function TOOL:GetStage()
	if ( IsValid( self:GetSelecetedEntity() ) ) then return 1 end
	return 0
end

net.Receive( "rb655_easy_animation_array", function( len )
	local tool = LocalPlayer():GetTool( "rb655_easy_animation" )
	tool.AnimationArray = net.ReadTable()
	if ( CLIENT ) then tool:UpdateControlPanel() end
end )

function TOOL:UpdateControlPanel( index )
	local panel = controlpanel.Get( "rb655_easy_animation" )
	if ( !panel ) then MsgN( "Couldn't find rb655_easy_animation panel!" ) return end

	panel:ClearControls()
	self.BuildCPanel( panel, self:GetSelecetedEntity() )
end

function TOOL.BuildCPanel( panel, ent )
	if ( !IsValid( ent ) ) then
		ent = LocalPlayer():GetTool( "rb655_easy_animation" ):GetSelecetedEntity()
	end

	if ( !IsValid( ent ) ) then
		panel:AddControl( "Label", { Text = "#tool.rb655_easy_animation.noent" } )
	elseif ( IsEntValid( ent ) ) then
		local fine = true

		if ( GetConVarNumber( "ai_disabled" ) == 0 && ent:IsNPC() ) then panel:AddControl( "Label", {Text = "#tool.rb655_easy_animation.ai"} ) fine = false end
		if ( ent:GetClass() == "prop_ragdoll" ) then panel:AddControl( "Label", { Text = "#tool.rb655_easy_animation.ragdoll" } ) fine = false end
		if ( ent:GetClass() == "prop_physics" or ent:GetClass() == "prop_physics_multiplayer" or ent:GetClass() == "prop_physics_override" ) then panel:AddControl( "Label", { Text = "#tool.rb655_easy_animation.prop" } ) end

		local t = {}
		local badBegginings = { "g_", "p_", "e_", "b_", "bg_", "hg_", "tc_", "aim_", "turn", "gest_", "pose_", "pose_", "auto_", "layer_", "posture", "bodyaccent", "a_" }
		local badStrings = { "gesture", "posture", "_trans_", "_rot_", "gest", "aim", "bodyflex_", "delta", "ragdoll", "spine", "arms" }
		for k, v in SortedPairsByValue( ent:GetSequenceList() ) do
			local isbad = false

			for i, s in pairs( badStrings ) do if ( string.find( string.lower( v ), s ) != nil ) then isbad = true break end end
			if ( isbad == true && LocalPlayer():GetTool( "rb655_easy_animation" ):GetClientNumber( "nohide" ) == 0 ) then continue end

			for i, s in pairs( badBegginings ) do if ( s == string.Left( string.lower( v ), string.len( s ) ) ) then isbad = true break end end
			if ( isbad == true && LocalPlayer():GetTool( "rb655_easy_animation" ):GetClientNumber( "nohide" ) == 0 ) then continue end

			language.Add( "rb655_anim_" .. v, MakeNiceName( v ) )
			t[ "#rb655_anim_" .. v ] = { rb655_easy_animation_anim = v, rb655_easy_animation_anim_do = v }
		end

		if ( fine ) then
			local filter = panel:AddControl( "TextBox", { Label = "#spawnmenu.quick_filter_tool" } )
			filter:SetUpdateOnType( true )

			local animList = panel:AddControl( "ListBox", { Label = "#tool.rb655_easy_animation.animations", Options = t, Height = 225 } )

			-- patch the function to take into account visiblity
			function animList:DataLayout()
				local y = 0
				for k, Line in ipairs( self.Sorted ) do
					if ( !Line:IsVisible() ) then continue end

					Line:SetPos( 1, y )
					Line:SetSize( self:GetWide() - 2, self.m_iDataHeight )
					Line:DataLayout( self )

					Line:SetAltLine( k % 2 == 1 )

					y = y + Line:GetTall()
				end

				return y
			end

			filter.OnValueChange = function( s, txt )
				for id, pnl in pairs( animList:GetCanvas():GetChildren() ) do
					if ( !pnl:GetValue( 1 ):lower():find( txt:lower() ) ) then
						pnl:SetVisible( false )
					else
						pnl:SetVisible( true )
					end
				end
				animList:SetDirty( true )
				animList:InvalidateLayout()
			end
		end
	elseif ( !IsEntValid( ent ) ) then
		panel:AddControl( "Label", { Text = "#tool.rb655_easy_animation.badent" } )
	end

	local pnl = vgui.Create( "DPanelList" )
	pnl:SetHeight( 225 )
	pnl:EnableHorizontal( false )
	pnl:EnableVerticalScrollbar( true )
	pnl:SetSpacing( 2 )
	pnl:SetPadding( 2 )
	Derma_Hook( pnl, "Paint", "Paint", "Panel" ) -- Awesome GWEN background

	local tool = LocalPlayer():GetTool( "rb655_easy_animation" )
	if ( tool && tool.AnimationArray ) then
		for i, d in pairs( tool.AnimationArray ) do
			local s = vgui.Create( "RAnimEntry" )
			s:SetInfo( i, d.ent, d.anim, d.speed, d.delay, d.loop )
			pnl:AddItem( s )
		end
	end

	panel:AddPanel( pnl )

	panel:AddControl( "Button", { Label = "#tool.rb655_easy_animation.add", Command = "rb655_easy_animation_add" } )
	panel:ControlHelp( "#tool.rb655_easy_animation.add.help" )
	panel:AddControl( "Slider", { Label = "#tool.rb655_easy_animation.speed", Type = "Float", Min = 0.05, Max = 3.05, Command = "rb655_easy_animation_speed", Help = true } )
	panel:AddControl( "Slider", { Label = "#tool.rb655_easy_animation.delay", Type = "Float", Min = 0, Max = 32, Command = "rb655_easy_animation_delay", Help = true } )
	panel:AddControl( "Checkbox", { Label = "#tool.rb655_easy_animation.loop", Command = "rb655_easy_animation_loop", Help = true } )
	panel:AddControl( "Checkbox", { Label = "#tool.rb655_easy_animation.nohide", Command = "rb655_easy_animation_nohide", Help = true } )
	panel:AddControl( "Checkbox", { Label = "#tool.rb655_easy_animation.noglow", Command = "rb655_easy_animation_noglow", Help = true } )
end

function TOOL:DrawHUD()
	local ent = self:GetSelecetedEntity()
	if ( !IsValid( ent ) or tobool( self:GetClientNumber( "noglow" ) ) ) then return end

	local t = { ent }
	if ( ent.GetActiveWeapon ) then table.insert( t, ent:GetActiveWeapon() ) end
	halo.Add( t, HSVToColor( ( CurTime() * 3 ) % 360, math.abs( math.sin( CurTime() / 2 ) ), 1 ), 2, 2, 1 )
end

local PANEL = {}

function PANEL:Init()
	self.ent = nil
	self.anim = "attack01"
	self.id = 0
	self.eid = 0
	self.speed = 1
	self.delay = 0
	self.loop = false

	self.rem = vgui.Create( "DImageButton", self )
	self.rem:SetImage( "icon16/cross.png" )
	self.rem:SetSize( 16, 16 )
	self.rem:SetPos( 4, 4 )
	self.rem.DoClick = function()
		self:RemoveFull()
	end
end

function PANEL:RemoveFull()
	self.rem:Remove()
	self:Remove()
	RunConsoleCommand( "rb655_easy_animation_rid", self.id, self.eid )
end

function PANEL:Paint( w, h )
	draw.RoundedBox( 2, 0, 0, w, h, Color( 50, 50, 50, 225 ) )
	if ( !self.ent or !IsValid( self.ent ) ) then self:RemoveFull() return end

	surface.SetFont( "DermaDefault" )
	draw.SimpleText( "#" .. self.ent:GetClass(), "DermaDefault", 24, 0, Color( 255, 255, 255, 255 ) )
	draw.SimpleText( "#rb655_anim_" .. self.anim, "DermaDefault", 24, 10, Color( 255, 255, 255, 255 ) )

	local tW = surface.GetTextSize( "#" .. self.ent:GetClass() )
	draw.SimpleText( " #" .. self.ent:EntIndex(), "DermaDefault", 24 + tW, 0, Color( 255, 255, 255, 255 ) )

	local tW2 = surface.GetTextSize( "#rb655_anim_" .. self.anim )
	local t = " [ S: " .. self.speed .. ", D: " .. self.delay
	if ( self.loop ) then t = t .. ", Looping" end
	draw.SimpleText( t .. " ]", "DermaDefault", 24 + tW2, 10, Color( 255, 255, 255, 255 ) )
end

function PANEL:SetInfo( id, e, a, s, d, l )
	self.id = id
	self.eid = e:EntIndex()
	self.ent = e
	self.anim = a
	self.speed = s
	self.delay = d
	self.loop = tobool( l )
end

vgui.Register( "RAnimEntry", PANEL, "Panel" )
