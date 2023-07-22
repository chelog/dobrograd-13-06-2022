
TOOL.Category = "Robotboy655"
TOOL.Name = "#tool.rb655_easy_bodygroup.name"

local gLastSelecetedEntity = NULL

local MaxBodyGroups = 72

TOOL.ClientConVar[ "noglow" ] = "0"
TOOL.ClientConVar[ "skin" ] = "0"
for i = 0, MaxBodyGroups do TOOL.ClientConVar[ "group" .. i ] = "1" end

local function MakeNiceName( str )
	local newname = {}

	for _, s in pairs( string.Explode( "_", str ) ) do
		if ( string.len( s ) == 1 ) then table.insert( newname, string.upper( s ) ) continue end
		table.insert( newname, string.upper( string.Left( s, 1 ) ) .. string.Right( s, string.len( s ) - 1 ) ) -- Ugly way to capitalize first letters.
	end

	return string.Implode( " ", newname )
end

local function IsEntValid( ent )
	if ( !IsValid( ent ) or ent:IsWorld() ) then return false end
	if ( ( ent:SkinCount() or 0 ) > 1 ) then return true end
	if ( ( ent:GetNumBodyGroups() or 0 ) > 1) then return true end
	if ( ( ent:GetBodygroupCount( 0 ) or 0 ) > 1 ) then return true end
	return false
end

local function SetBodygroup( _, ent, t )
	ent:SetBodygroup( t.group, t.id )
end
for i = 0, MaxBodyGroups do duplicator.RegisterEntityModifier( "bodygroup" .. i, SetBodygroup ) end -- We only have this so old dupes will work

function TOOL:GetSelecetedEntity()
	return self:GetWeapon():GetNWEntity( "rb655_bodygroup_entity" )
end

function TOOL:SetSelecetedEntity( ent )
	if ( IsValid( ent ) && ent:GetClass() == "prop_effect" ) then ent = ent.AttachedEntity end
	if ( !IsValid( ent ) ) then ent = NULL end

	if ( self:GetSelecetedEntity() == ent ) then return end

	self:GetWeapon():SetNWEntity( "rb655_bodygroup_entity", ent )
end

-- The whole Ready system is to make sure it have time to sync the console vars. Not the best idea, but it does work.
if ( SERVER ) then
	TOOL.Ready = 0

	util.AddNetworkString( "rb655_easy_bodygroup_ready" )

	net.Receive( "rb655_easy_bodygroup_ready", function( len, ply )
		local tool = ply:GetTool( "rb655_easy_bodygroup" )
		if ( tool && net.ReadEntity() == tool:GetSelecetedEntity() ) then tool.Ready = 1 end
	end )
end

function TOOL:Think()
	local ent = self:GetSelecetedEntity()
	if ( !IsValid( ent ) ) then self:SetSelecetedEntity( NULL ) end

	if ( CLIENT ) then
		if ( ent:EntIndex() == gLastSelecetedEntity ) then return end
		gLastSelecetedEntity = ent:EntIndex()
		self:UpdateControlPanel()
		return
	end

	if ( !IsEntValid( ent ) ) then return end
	if ( self.Ready == 0 ) then return end
	if ( self.Ready > 0 && self.Ready < 50 ) then self.Ready = self.Ready + 1 return end -- Another ugly workaround

	if ( ent:SkinCount() > 1 ) then ent:SetSkin( self:GetClientNumber( "skin" ) ) end

	for i = 0, ent:GetNumBodyGroups() - 1 do
		if ( ent:GetBodygroupCount( i ) <= 1 ) then continue end
		if ( ent:GetBodygroup( i ) == self:GetClientNumber( "group" .. i ) ) then continue end
		SetBodygroup( nil, ent, { group = i, id = self:GetClientNumber( "group" .. i ) } )
	end
end

function TOOL:LeftClick( trace )
	if ( SERVER && trace.Entity != self:GetSelecetedEntity() ) then
		self.Ready = 0
		self:SetSelecetedEntity( trace.Entity )
	end
	return true
end

function TOOL:RightClick( trace ) return self:LeftClick( trace ) end

function TOOL:Reload()
	if ( SERVER ) then
		self.Ready = 0
		self:SetSelecetedEntity( self:GetOwner() )
	end
	return true
end

if ( SERVER ) then return end

TOOL.Information = {
	{ name = "info", stage = 1 },
	{ name = "left" },
	{ name = "reload" },
}

language.Add( "tool.rb655_easy_bodygroup.left", "Select an object to edit" )
language.Add( "tool.rb655_easy_bodygroup.reload", "Select yourself" )

language.Add( "tool.rb655_easy_bodygroup.name", "Easy Bodygroup Tool" )
language.Add( "tool.rb655_easy_bodygroup.desc", "Eases change of bodygroups and skins" )
language.Add( "tool.rb655_easy_bodygroup.1", "Use context menu to edit bodygroups or skins" )

language.Add( "tool.rb655_easy_bodygroup.noglow", "Don't render glow/halo around models" )
language.Add( "tool.rb655_easy_bodygroup.skin", "Skin" )
language.Add( "tool.rb655_easy_bodygroup.badent", "This entity does not have any skins or bodygroups." )
language.Add( "tool.rb655_easy_bodygroup.noent", "No entity selected." )

function TOOL:GetStage()
	if ( IsValid( self:GetSelecetedEntity() ) ) then return 1 end
	return 0
end

function TOOL:UpdateControlPanel( index )
	local panel = controlpanel.Get( "rb655_easy_bodygroup" )
	if ( !panel ) then MsgN( "Couldn't find rb655_easy_bodygroup panel!" ) return end

	panel:ClearControls()
	self.BuildCPanel( panel, self:GetSelecetedEntity() )
end

-- We don't use the normal automatic stuff because we need to leave out the noglow convar
local ConVarsDefault = {}
ConVarsDefault[ "rb655_easy_bodygroup_skin" ] = 0
for i = 0, MaxBodyGroups do ConVarsDefault[ "rb655_easy_bodygroup_group" .. i ] = 0 end

function TOOL.BuildCPanel( panel, ent )
	panel:AddControl( "Checkbox", { Label = "#tool.rb655_easy_bodygroup.noglow", Command = "rb655_easy_bodygroup_noglow" } )

	if ( !IsValid( ent ) ) then panel:AddControl( "Label", { Text = "#tool.rb655_easy_bodygroup.noent" } ) return end
	if ( !IsEntValid( ent ) ) then panel:AddControl( "Label", { Text = "#tool.rb655_easy_bodygroup.badent" } ) return end

	panel:AddControl( "ComboBox", {
		MenuButton = 1,
		Folder = "rb655_ez_bg_" .. ent:GetModel():lower():Replace( "/", "_" ):StripExtension():sub( 8 ), -- Some hacky bussiness
		Options = { [ "#preset.default" ] = ConVarsDefault },
		CVars = table.GetKeys( ConVarsDefault )
	} )

	if ( ent:SkinCount() > 1 ) then
		LocalPlayer():ConCommand( "rb655_easy_bodygroup_skin " .. ent:GetSkin() )
		panel:AddControl( "Slider", { Label = "#tool.rb655_easy_bodygroup.skin", Max = ent:SkinCount() - 1, Command = "rb655_easy_bodygroup_skin" } )
	end

	for k = 0, ent:GetNumBodyGroups() - 1 do
		if ( ent:GetBodygroupCount( k ) <= 1 ) then continue end
		LocalPlayer():ConCommand( "rb655_easy_bodygroup_group" .. k .. " " .. ent:GetBodygroup( k ) )
		panel:AddControl( "Slider", { Label = MakeNiceName( ent:GetBodygroupName( k ) ), Max = ent:GetBodygroupCount( k ) - 1, Command = "rb655_easy_bodygroup_group" .. k } )
	end

	net.Start( "rb655_easy_bodygroup_ready" )
		net.WriteEntity( ent )
	net.SendToServer()
end

function TOOL:DrawHUD()
	local ent = self:GetSelecetedEntity()
	if ( !IsValid( ent ) or tobool( self:GetClientNumber( "noglow" ) ) ) then return end

	local t = { ent }
	if ( ent.GetActiveWeapon ) then table.insert( t, ent:GetActiveWeapon() ) end
	halo.Add( t, HSVToColor( ( CurTime() * 3 ) % 360, math.abs( math.sin( CurTime() / 2 ) ), 1 ), 2, 2, 1 )
end
