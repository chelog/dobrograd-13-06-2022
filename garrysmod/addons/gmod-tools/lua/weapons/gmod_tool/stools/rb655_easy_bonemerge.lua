
TOOL.Category = "Robotboy655"
TOOL.Name = "#tool.rb655_easy_bonemerge.name"

TOOL.ClientConVar[ "noglow" ] = "0"

if ( SERVER ) then

	-- Replaces the bonemerged entity with a custom one for easier everything for the tool
	local function ReplaceEntity( oldent )
		local newEntity = ents.Create( "ent_bonemerged" )
		newEntity:SetModel( oldent:GetModel() )
		newEntity:SetSkin( oldent:GetSkin() || 0 )
		if ( oldent:GetFlexScale() != newEntity:GetFlexScale() ) then newEntity:SetFlexScale( oldent:GetFlexScale() ) end -- Don't create unnecessary entities
		if ( oldent:GetNumBodyGroups() ) then
			for id = 0, oldent:GetNumBodyGroups() - 1 do newEntity:SetBodygroup( id, oldent:GetBodygroup( id ) ) end
		end
		for i = 0, oldent:GetFlexNum() - 1 do newEntity:SetFlexWeight( i, oldent:GetFlexWeight( i ) ) end
		for i = 0, oldent:GetBoneCount() do
			if ( oldent:GetManipulateBoneScale( i ) != newEntity:GetManipulateBoneScale( i ) ) then newEntity:ManipulateBoneScale( i, oldent:GetManipulateBoneScale( i ) ) end
			if ( oldent:GetManipulateBoneAngles( i ) != newEntity:GetManipulateBoneAngles( i ) ) then newEntity:ManipulateBoneAngles( i, oldent:GetManipulateBoneAngles( i ) ) end
			if ( oldent:GetManipulateBonePosition( i ) != newEntity:GetManipulateBonePosition( i ) ) then newEntity:ManipulateBonePosition( i, oldent:GetManipulateBonePosition( i ) ) end
			if ( oldent:GetManipulateBoneJiggle( i ) != newEntity:GetManipulateBoneJiggle( i ) ) then newEntity:ManipulateBoneJiggle( i, oldent:GetManipulateBoneJiggle( i ) ) end
		end

		newEntity:Spawn()

		newEntity.EntityMods = oldent.EntityMods
		newEntity.BoneMods = oldent.BoneMods

		duplicator.ApplyEntityModifiers( nil, newEntity )
		duplicator.ApplyBoneModifiers( nil, newEntity )

		return newEntity
	end

	-- Adds any constrained entities to the bonemerge
	function rb655_CheckForWelds( ent, parent )
		if ( !constraint.HasConstraints( ent ) ) then return end

		for _, v in pairs( constraint.GetAllConstrainedEntities( ent ) ) do
			if ( v == ent ) then continue end
			if ( constraint.FindConstraint( v, "EasyBonemergeParent" ) ) then continue end

			local oldent = v
			if ( IsValid( v ) && v:GetClass() == "prop_effect" ) then oldent = v.AttachedEntity end

			local newEntity = ReplaceEntity( oldent )

			newEntity.LocalPos = ent:WorldToLocal( v:GetPos() )
			newEntity.LocalAng = ent:WorldToLocalAngles( v:GetAngles() )

			constraint_EasyBonemergeParent( parent, newEntity )

			v:Remove()
		end
	end

	-- Allows for bonemerging depth
	function rb655_CheckForBonemerges( oldent, newent )
		for _, ent in ipairs(ents.FindByClassAndParent("ent_bonemerged", oldent) or {}) do
			if ( !ent.LocalPos ) then
				rb655_ApplyBonemerge( ent, newent )
			end
		end
	end

	-- Entry point
	function rb655_ApplyBonemerge( ent, selectedEnt )
		local oldent = ent
		if ( IsValid( ent ) && ent:GetClass() == "prop_effect" ) then oldent = ent.AttachedEntity end

		local newEntity = ReplaceEntity( oldent )

		constraint_EasyBonemerge( selectedEnt, newEntity )
		rb655_CheckForBonemerges( oldent, newEntity )
		rb655_CheckForWelds( oldent, newEntity )

		ent:Remove()

		return newEntity
	end

	function constraint_EasyBonemerge( Ent1, Ent2, EntityMods, BoneMods )
		if ( !IsValid( Ent1 ) ) then MsgN( "Easy Bonemerge Tool: Your dupe/save is missing the target entity, cannot apply bonemerged props!" ) return end
		if ( !IsValid( Ent2 ) ) then MsgN( "Easy Bonemerge Tool: Your dupe/save is missing the bonemerged prop, cannot restore bonemerged prop!" ) return end

		Ent2:SetParent( Ent1, 0 )

		-- I don't remember why I put these here
		Ent2:SetMoveType( MOVETYPE_NONE )
		Ent2:SetLocalPos( Vector( 0, 0, 0 ) )
		Ent2:SetLocalAngles( Angle( 0, 0, 0 ) )

		Ent2:AddEffects( EF_BONEMERGE )
		--Ent2:Fire( "SetParentAttachment", Ent1:GetAttachments()[1].name )

		constraint.AddConstraintTable( Ent1, Ent2, Ent2 )

		Ent2:SetTable( {
			Type = "EasyBonemerge",
			Ent1 = Ent1,
			Ent2 = Ent2,
			EntityMods = EntityMods || Ent2.EntityMods,
			BoneMods = BoneMods || Ent2.BoneMods
		} )

		duplicator.ApplyEntityModifiers( nil, Ent2 )
		duplicator.ApplyBoneModifiers( nil, Ent2 )

		Ent1:DeleteOnRemove( Ent2 )

		rb655_CheckForBonemerges( Ent2, Ent2 )

		return Ent2
	end
	duplicator.RegisterConstraint( "EasyBonemerge", constraint_EasyBonemerge, "Ent1", "Ent2", "EntityMods", "BoneMods" )

	function constraint_EasyBonemergeParent( Ent1, Ent2, LocalPos, LocalAng, EntityMods, BoneMods )
		if ( !IsValid( Ent1 ) ) then MsgN( "Easy Bonemerge Tool: Your dupe/save is missing parent target entity, cannot apply bonemerged props!" ) return end
		if ( !IsValid( Ent2 ) ) then MsgN( "Easy Bonemerge Tool: Your dupe/save is missing parent bonemerged prop, cannot restore bonemerged prop!" ) return end

		Ent2:SetParent( Ent1, 0 )
		Ent2.BoneMergeParent = true

		Ent2:SetLocalPos( LocalPos || Ent2.LocalPos )
		Ent2:SetLocalAngles( LocalAng || Ent2.LocalAng )

		constraint.AddConstraintTable( Ent1, Ent2, Ent2 )

		Ent2:SetTable( {
			Type = "EasyBonemergeParent",
			Ent1 = Ent1,
			Ent2 = Ent2,
			LocalPos = LocalPos || Ent2.LocalPos,
			LocalAng = LocalAng || Ent2.LocalAng,
			EntityMods = EntityMods || Ent2.EntityMods,
			BoneMods = BoneMods || Ent2.BoneMods
		} )

		duplicator.ApplyEntityModifiers( nil, Ent2 )
		duplicator.ApplyBoneModifiers( nil, Ent2 )

		Ent1:DeleteOnRemove( Ent2 )

		return Ent2
	end
	duplicator.RegisterConstraint( "EasyBonemergeParent", constraint_EasyBonemergeParent, "Ent1", "Ent2", "LocalPos", "LocalAng", "EntityMods", "BoneMods" )

	-- Undo bonemerges from UI
	util.AddNetworkString( "rb655_bm_undo" )
	net.Receive( "rb655_bm_undo", function( len, ply )
		local ent = net.ReadEntity()
		if ( !IsValid( ent ) || ent:GetClass() != "ent_bonemerged" ) then return end

		local parent = ent:GetParent()
		if ( !IsValid( parent ) ) then return end

		local tool = ply:GetTool( "rb655_easy_bonemerge" )
		if ( !istable( tool ) ) then return end

		if ( tool:GetSelectedEntity() != parent ) then return end

		ply:SendLua( "hook.Run( 'OnUndo', 'Bonemerge' )" )
		ent:Remove()
	end )

end

function TOOL:GetSelectedEntity()
	return self:GetWeapon():GetNWEntity( "rb655_bonemerge_entity" )
end

function TOOL:SetSelectedEntity( ent )
	if ( IsValid( ent ) && ent:GetClass() == "prop_effect" ) then ent = ent.AttachedEntity end
	if ( !IsValid( ent ) ) then ent = NULL end
	if ( IsValid( ent ) && ent:GetModel():StartWith( "*" ) ) then ent = NULL end
	if ( IsValid( ent ) && ent:IsPlayer() && ent != self:GetOwner() && !self:GetOwner():query('DBG: Применять тулы на игроках') ) then ent = NULL end

	if ( self:GetSelectedEntity() == ent ) then return end

	self:GetWeapon():SetNWEntity( "rb655_bonemerge_entity", ent )
end

function TOOL:LeftClick( tr )
	local ent = self:GetSelectedEntity()
	if ( IsValid( tr.Entity ) && tr.Entity:GetClass() == "prop_effect" ) then tr.Entity = tr.Entity.AttachedEntity end

	if ( !IsValid( ent ) || !IsValid( tr.Entity ) || tr.Entity == ent || tr.Entity:IsPlayer() || tr.Entity:IsNPC() || tr.Entity:GetModel():StartWith( "*" ) ) then return false end

	if ( CLIENT ) then return true end

	local newEntity = rb655_ApplyBonemerge( tr.Entity, ent )

	undo.Create( "bonemerge" )
		undo.AddEntity( newEntity )
		undo.SetPlayer( self:GetOwner() )
	undo.Finish()

	return true
end

function TOOL:RightClick( tr )
	local ent = !self:GetOwner():KeyDown( IN_USE ) && tr.Entity || self:GetOwner()
	--if ( IsValid( ent ) && #( ent:GetAttachments() || {} ) < 1 ) then return false end
	if ( SERVER ) then self:SetSelectedEntity( ent ) end
	return true
end

function TOOL:Reload( tr )
	local ent = !self:GetOwner():KeyDown( IN_USE ) && tr.Entity || self:GetOwner()
	if ( !IsValid( ent ) ) then return false end
	if ( SERVER --[[&& ( constraint.HasConstraints( ent, "EasyBonemerge" ) || constraint.HasConstraints( ent, "EasyBonemergeParent" ) )]] ) then
		constraint.RemoveConstraints( ent, "EasyBonemerge" )
		constraint.RemoveConstraints( ent, "EasyBonemergeParent" )
	end
	return true
end

function TOOL:MakeGhostEntity( model, pos, angle )

	util.PrecacheModel( model )

	-- We do ghosting serverside in single player
	-- It's done clientside in multiplayer
	if ( SERVER && !game.SinglePlayer() ) then return end
	if ( CLIENT && game.SinglePlayer() ) then return end

	-- Release the old ghost entity
	self:ReleaseGhostEntity()

	-- Don't allow ragdolls/effects to be ghosts
	-- if ( !util.IsValidProp( model ) ) then return end

	if ( CLIENT ) then
		self.GhostEntity = ents.CreateClientProp( model )
	else
		self.GhostEntity = ents.Create( "prop_physics" )
	end

	-- If there's too many entities we might not spawn..
	if ( !IsValid( self.GhostEntity ) ) then
		self.GhostEntity = nil
		return
	end

	self.GhostEntity:SetModel( model )
	self.GhostEntity:SetPos( pos )
	self.GhostEntity:SetAngles( angle )
	self.GhostEntity:Spawn()

	self.GhostEntity:SetSolid( SOLID_VPHYSICS )
	self.GhostEntity:SetMoveType( MOVETYPE_NONE )
	self.GhostEntity:SetNotSolid( true )
	self.GhostEntity:SetRenderMode( RENDERMODE_GLOW ) -- Allows for transparency and proper Z order
	self.GhostEntity:SetColor( Color( 255, 255, 255, 128 ) )

end

function TOOL:UpdateGhostEntity( ent, ply, tr )
	if ( !IsValid( ent ) || !IsValid( self:GetSelectedEntity() ) ) then return end

	local trEnt = tr.Entity

	if ( !IsValid( trEnt ) || trEnt == self:GetSelectedEntity() ) then
		ent:SetNoDraw( true )
		return
	end

	if ( trEnt:GetClass() == "prop_effect" ) then
		local attachedEntity = trEnt.AttachedEntity

		if ( !IsValid( trEnt.AttachedEntity ) ) then
			local tab = ents.FindByClassAndParent( "prop_dynamic", trEnt )
			if ( tab && IsValid( tab[ 1 ] ) ) then attachedEntity = tab[ 1 ] end
		end

		if ( IsValid( attachedEntity ) ) then trEnt = attachedEntity end
	end

	if ( trEnt:GetNumBodyGroups() ) then
		for id = 0, trEnt:GetNumBodyGroups() - 1 do ent:SetBodygroup( id, trEnt:GetBodygroup( id ) ) end
	end

	local clr = trEnt:GetColor()
	clr.a = clr.a / 2
	ent:SetColor( clr )

	ent:SetMaterial( trEnt:GetMaterial() )
	ent:SetSkin( trEnt:GetSkin() || 0 )
	ent:SetModel( trEnt:GetModel() )
	ent:SetParent( self:GetSelectedEntity(), 0 )
	ent:AddEffects( EF_BONEMERGE )
	ent:SetNoDraw( false )
end

function TOOL:Think()
	if ( !IsValid( self:GetSelectedEntity() ) ) then self:ReleaseGhostEntity() return end

	local tr = util.TraceLine( {
		start = self:GetOwner():GetShootPos(),
		endpos = self:GetOwner():GetShootPos() + self:GetOwner():GetAimVector() * 16000,
		filter = self:GetOwner(),
		mask = MASK_ALL,
	} )

	if ( !IsValid( tr.Entity ) || tr.Entity == self:GetSelectedEntity() || tr.Entity:IsPlayer() || tr.Entity:GetModel():StartWith( "*" ) ) then
		self:ReleaseGhostEntity()
		return
	end

	if ( IsValid( tr.Entity ) && !IsValid( self.GhostEntity ) ) then
		self:MakeGhostEntity( tr.Entity:GetModel(), Vector( 0, 0, 0 ), Angle( 0, 0, 0 ) )
	end

	self:UpdateGhostEntity( self.GhostEntity, self:GetOwner(), tr )
end

if ( SERVER ) then return end

TOOL.Information = {
	{ name = "left", stage = 1 },
	{ name = "right" },
	{ name = "right_use" },
	{ name = "reload", stage = 0 },
	{ name = "reload_use", stage = 0 },
}

language.Add( "tool.rb655_easy_bonemerge.left", "Attach a model to selected object" )
language.Add( "tool.rb655_easy_bonemerge.right", "Select an object to attach model(s) to" )
language.Add( "tool.rb655_easy_bonemerge.reload", "Remove all attached model(s) from an object" )
language.Add( "tool.rb655_easy_bonemerge.right_use", "Select yourself" )
language.Add( "tool.rb655_easy_bonemerge.reload_use", "Remove all attached model(s) from yourself" )

language.Add( "tool.rb655_easy_bonemerge.name", "Easy Bonemerge Tool" )
language.Add( "tool.rb655_easy_bonemerge.desc", "Attaches models to objects using bonemerging" )

language.Add( "tool.rb655_easy_bonemerge.infos", [[
What is bone merging?
Bone merging is essentially what it sounds like, you select a model and click on other models to merge their bones together.

For bone merging to work successfully, two models MUST have at least ONE bone with exactly the same name.

If two models do not meet this requirement, the model you are trying to attach will be placed into the center of coordinates of the selected model, which is usually in the visual center of the model or it's lowest point.

Once bonemerged, the bones of the target model(s) will be placed into the exact positions of the bones with same names on the selected model.

You cannot select which bones to attach objects to. Bonemerging features are defined by the model author(s) and cannot be changed without editing the model.

Selected model - The entity you select with right click
Target model(s) - The entities you left click to bone merge onto the selected model]] )

language.Add( "tool.rb655_easy_bonemerge.noshared", "Warning!\nNo shared bones!\nThese 2 models are not bonemerge compatible!" )
language.Add( "tool.rb655_easy_bonemerge.backwards", "Warning!\nSelected model has less bones than target model!\nYou are most likely trying to bonemerge backwards!" )

language.Add( "undone_Bonemerge", "Undone Bonemerged Prop" )

language.Add( "tool.rb655_easy_bonemerge.noglow", "Don't render glow/halo around models" )
language.Add( "tool.rb655_easy_bonemerge.selected_undo", "Undo:" )
language.Add( "tool.rb655_easy_bonemerge.noent", "No entity selected!" )
language.Add( "tool.rb655_easy_bonemerge.nomodels", "No attached models!" )

function TOOL:GetStage()
	if ( IsValid( self:GetSelectedEntity() ) ) then return 1 end
	return 0
end

local function CountBonemergedChildren( ent )
	local counter = 0
	for k, v in ipairs( ent:GetChildren() ) do
		if ( !IsValid( v ) || v:GetClass() != "ent_bonemerged" ) then continue end

		counter = counter + 1
	end
	return counter
end

local function UndoThisBonemerge( ent )
	net.Start( "rb655_bm_undo" )
		net.WriteEntity( ent )
	net.SendToServer()
end

function TOOL.BuildCPanel( panel )

	panel:Help( "#tool.rb655_easy_bonemerge.infos" )

	panel:AddControl( "Checkbox", { Label = "#tool.rb655_easy_bonemerge.noglow", Command = "rb655_easy_bonemerge_noglow" } )

	local pnl = vgui.Create( "DPanel", panel )
	pnl:Dock( TOP )
	pnl:DockMargin( 10, 10, 10, 10 )
	pnl.Think = function( s )
		local toolgun = LocalPlayer()
		if ( !IsValid( toolgun ) || !toolgun.GetTool ) then return end
		toolgun = toolgun:GetTool( "rb655_easy_bonemerge" )
		if ( !istable( toolgun ) ) then return end

		local ent = toolgun:GetSelectedEntity()
		if ( !IsValid( ent ) && s.LastSelectedEntity != nil ) then
			s.LastSelectedEntity = nil
			s:Rebuild()
		elseif ( IsValid( ent ) && ( s.LastSelectedEntity == nil || s.LastSelectedEntity != ent || ( s.LastChildrenNum || 0 ) != CountBonemergedChildren( ent ) ) ) then
			s.LastSelectedEntity = ent
			s.LastChildrenNum = CountBonemergedChildren( ent )
			s:Rebuild()
		end
	end
	pnl.Rebuild = function( s )
		for k, v in pairs( s:GetChildren() ) do v:Remove() end

		if ( !IsValid( s.LastSelectedEntity ) ) then
			local txt = s:Add( "DLabel" )
			txt:SetText( "#tool.rb655_easy_bonemerge.noent" )
			txt:Dock( TOP )
			txt:SetDark( true )
			txt:DockMargin( 10, 10, 10, 10 )

			s:SetTall( 40 )
			return
		end

		local height = 0
		for k, v in pairs( s.LastSelectedEntity:GetChildren() ) do
			if ( !IsValid( v ) || v:GetClass() != "ent_bonemerged" ) then continue end

			local txt = s:Add( "DButton" )
			txt:SetText( "Undo " .. v:GetModel() .. "#" .. v:EntIndex() )
			txt:Dock( TOP )
			txt.ent = v
			txt:DockMargin( 5, 5, 5, 0 )
			txt.DoClick = function( t )
				UndoThisBonemerge( t.ent )
			end

			height = height + txt:GetTall() + 5
		end

		if ( height > 0 ) then
			s:SetTall( height + 5 )
		else
			local txt = s:Add( "DLabel" )
			txt:SetText( "#tool.rb655_easy_bonemerge.nomodels" )
			txt:Dock( TOP )
			txt:SetDark( true )
			txt:DockMargin( 10, 10, 10, 10 )
			s:SetTall( 40 )
		end
	end
	pnl:Rebuild()

end

--------------------------------------------------------------------------
----------------------------------- HUD ----------------------------------
--------------------------------------------------------------------------

surface.CreateFont( "rb655_easy_bonemerge_font", {
	size = ScreenScale( 8 ),
	font = "Roboto"
} )

local function boxText( txt, _x, _y )
	surface.SetFont( "rb655_easy_bonemerge_font" )

	local t = string.Explode( "\n", language.GetPhrase( txt ) )

	local w, h = 0, 0
	for id, txt in pairs( t ) do
		local id = id - 1
		local tW, tH = surface.GetTextSize( txt )
		w = math.max( w, tW )
		h = math.max( h, h + tH )
	end
	local x, y = _x - w / 2, _y
	draw.RoundedBox( 0, x - 5, y, w + 10, h + 10 , Color( 0, 0, 0, 128 ) )

	for id, txt in pairs( t ) do
		local id = id - 1
		local tW, tH = surface.GetTextSize( txt )

		draw.SimpleText( txt, "rb655_easy_bonemerge_font", _x, _y + id * tH + 5, color_white, 1, 0 )
	end
end

local crossmat = Material( "icon16/cross.png" )
function TOOL:DrawHUD()
	local ent = self:GetSelectedEntity()
	if ( !IsValid( ent ) ) then return end
	local ply, ct = LocalPlayer(), CurTime()

	if ( !tobool( self:GetClientNumber( "noglow" ) ) ) then
		local t = { ent }
		if ( ent.GetActiveWeapon ) then table.insert( t, ent:GetActiveWeapon() ) end
		halo.Add( t, HSVToColor( ( ct * 3 ) % 360, math.abs( math.sin( ct / 2 ) ), 1 ), 2, 2, 1 )
	end

	-- =============================================================================================== --

	local hasBones = false
	local target = util.TraceLine( {
		start = ply:GetShootPos(),
		endpos = ply:GetShootPos() + ply:GetAimVector() * 16000,
		filter = ply,
		mask = MASK_ALL,
	} ).Entity

	if ( !IsValid( target ) ) then return end

	if ( target:GetClass() == "prop_effect" ) then
		local attachedEntity = target.AttachedEntity

		if ( !IsValid( target.AttachedEntity ) ) then
			local tab = ents.FindByClassAndParent( "prop_dynamic", target )
			if ( tab && IsValid( tab[ 1 ] ) ) then attachedEntity = tab[ 1 ] end
		end

		if ( IsValid( attachedEntity ) ) then target = attachedEntity end
	end

	if ( !IsValid( target ) ) then return end
	if ( target:GetModel():StartWith( "*" ) ) then return end

	local bones = {}
	for id = 0, ent:GetBoneCount() - 1 do table.insert( bones, ent:GetBoneName( id ) ) end

	if ( target:GetBoneCount() ) then
		for id = 0, target:GetBoneCount() - 1 do
			if ( table.HasValue( bones, target:GetBoneName( id ) ) && target:GetBoneName( id ) != "__INVALIDBONE__" ) then
				hasBones = true
				break
			end
		end
	end

	if ( !hasBones ) then
		boxText( "tool.rb655_easy_bonemerge.noshared", ScrW() / 2, ScrH() / 2 + 32 )

		local size = 32
		surface.SetDrawColor( color_white )
		surface.SetMaterial( crossmat )
		surface.DrawTexturedRect( ScrW() / 2 - size / 2, ScrH() / 2 - size / 2, size, size )
	end

	if ( hasBones && ent:GetBoneCount() < target:GetBoneCount() && target != ent ) then
		boxText( "tool.rb655_easy_bonemerge.backwards", ScrW() / 2, ScrH() / 2 + 100 )
	end
end
