
TOOL.Category = "Dobrograd"
TOOL.Name = L.resizer
TOOL.ClientConVar[ "sx" ] =	"1.0"
TOOL.ClientConVar[ "sy" ] =	"1.0"
TOOL.ClientConVar[ "sz" ] =	"1.0"
TOOL.ClientConVar[ "smwo" ] =	"1"
TOOL.ClientConVar[ "cx" ] =	"1.0"
TOOL.ClientConVar[ "cy" ] =	"1.0"
TOOL.ClientConVar[ "cz" ] =	"1.0"
TOOL.ClientConVar[ "prco" ] =	"0"
TOOL.ClientConVar[ "dcp" ] =	"0"

local function IsValidEntity( ent )
	return isentity( ent ) and ent:IsValid()
end

local function IsValidPhysicsObject( physobj )
	return ( TypeID( physobj ) == TYPE_PHYSOBJ ) and physobj:IsValid()
end
local RESET = Vector( 1, 1, 1 )
local EMPTY = Vector( 0, 0, 0 )
local ENT = {}
ENT.Type = "anim"
ENT.Spawnable =			false
ENT.DisableDuplicator =	true

local function FindSizeHandler( ent )
	for k, handler in pairs( ents.FindByClass( "sizehandler" ) ) do
		if ( handler:GetParent() == ent ) then return handler end
	end
end

local function ResizePhysics( ent, scale )
	ent:PhysicsInit( SOLID_VPHYSICS )
	local physobj = ent:GetPhysicsObject()
	if ( not IsValidPhysicsObject( physobj ) ) then return false end
	local physmesh = physobj:GetMeshConvexes()
	if ( not istable( physmesh ) ) or ( #physmesh < 1 ) then return false end
	for convexkey, convex in pairs( physmesh ) do
		for poskey, postab in pairs( convex ) do
			convex[ poskey ] = postab.pos * scale
		end
	end
	ent:PhysicsInitMultiConvex( physmesh )
	ent:EnableCustomCollisions( true )
	return IsValidPhysicsObject( ent:GetPhysicsObject() )
end
if ( SERVER ) then

	local meta = FindMetaTable( "Entity" )
--	if ( meta ) then
		local o_StartMotionController = meta.StartMotionController
		meta.StartMotionController = function( ent )
			o_StartMotionController( ent )
			ent.IsMotionControlled = true
		end
		local o_StopMotionController = meta.StopMotionController
		meta.StopMotionController = function( ent )
			o_StopMotionController( ent )
			ent.IsMotionControlled = nil
		end
--	end

	local function HasValidPhysics( ent )
		return ( ent:GetSolid() == SOLID_VPHYSICS ) and ( ent:GetPhysicsObjectCount() == 1 )
	end

	local ConstraintData = {}
	local function ForgetConstraint( ent, RConstraint )
		local Constraints = ent.Constraints
		if ( Constraints ) then
			local NewTab = {}
			for k, Constraint in pairs( Constraints ) do
				if ( Constraint ~= RConstraint ) then
					table.insert( NewTab, Constraint )
				end
			end
			ent.Constraints = NewTab
		end
	end

	local function SafeInsert( t, k, v )
		if ( v ) then
			t[ k ] = v
		else
			t[ k ] = false
		end
	end

	local function GetConstraintVals( ent, Constraint, Type )
		for Arg, Val in pairs( Constraint:GetTable() ) do
			if ( ( string.sub( Arg, 1, 3 ) == "Ent" ) and IsValidEntity( Val ) and ( Val ~= ent ) ) then
				ForgetConstraint( Val, Constraint )
			end
		end
		local Factory = duplicator.ConstraintType[ Type ]
		local ConstraintVals = {}
		for Key, Arg in pairs( Factory.Args ) do
			SafeInsert( ConstraintVals, Key, Constraint[ Arg ] )
		end
		ConstraintData[ Constraint ] = { Factory.Func, ConstraintVals }
		Constraint:Remove()
	end

	local function GetAndResizeConstraintVals( ent, Constraint, Type, scale )
		local LPos = {}
		for Arg, Val in pairs( Constraint:GetTable() ) do
			if ( string.sub( Arg, 1, 3 ) == "Ent" ) then
				if ( Val == ent ) then
					table.insert( LPos, "LPos"..string.sub( Arg, 4 ) )
				elseif ( IsValidEntity( Val ) ) then
					ForgetConstraint( Val, Constraint )
				end
			end
		end
		local Factory = duplicator.ConstraintType[ Type ]
		local ConstraintVals = {}
		for Key, Arg in pairs( Factory.Args ) do
			if ( table.HasValue( LPos, Arg ) ) then
				local Val = Constraint[ Arg ]
				if ( isvector( Val ) ) then
					ConstraintVals[ Key ] = Val * scale
				else
					SafeInsert( ConstraintVals, Key, Val )
				end
			else
				SafeInsert( ConstraintVals, Key, Constraint[ Arg ] )
			end
		end
		ConstraintData[ Constraint ] = { Factory.Func, ConstraintVals }
		Constraint:Remove()
	end

	local function StoreConstraintData( ent )
		local Constraints = ent.Constraints
		if ( Constraints ) then
			for Key, Constraint in pairs( Constraints ) do
				if ( IsValidEntity( Constraint ) and ( ConstraintData[ Constraint ] == nil ) ) then
					local Type = Constraint.Type
					if ( Type ) then
						GetConstraintVals( ent, Constraint, Type )
					end
				end
				Constraints[ Key ] = nil
			end
		end
	end

	local function ResizeAndStoreConstraintData( ent, scale, oldscale )
		local Constraints = ent.Constraints
		if ( Constraints ) then
			for Key, Constraint in pairs( Constraints ) do
				if ( IsValidEntity( Constraint ) and ( ConstraintData[ Constraint ] == nil ) ) then
					local Type = Constraint.Type
					if ( Type ) then
						if ( Type == "Axis" ) then
							GetConstraintVals( ent, Constraint, Type )
						else
							GetAndResizeConstraintVals( ent, Constraint, Type, Vector( scale.x / oldscale.x, scale.y / oldscale.y, scale.z / oldscale.z ) )
						end
					end
				end
				Constraints[ Key ] = nil
			end
		end
	end

	local function ApplyConstraintData()
		for OldConstraint, Factory in pairs( ConstraintData ) do
			local NewConstraint = Factory[ 1 ]( unpack( Factory[ 2 ] ) )
			if ( IsValidEntity( NewConstraint ) ) then
				-- undo.ReplaceEntity( OldConstraint, NewConstraint )
				-- cleanup.ReplaceEntity( OldConstraint, NewConstraint )
			end
			ConstraintData[ OldConstraint ] = nil
		end
	end

	local PhysicsData = {}
	local function StorePhysicsData( physobj )
		PhysicsData[ 1 ] = physobj:IsGravityEnabled()
		PhysicsData[ 2 ] = physobj:GetMaterial()
		PhysicsData[ 3 ] = physobj:IsCollisionEnabled()
		PhysicsData[ 4 ] = physobj:IsDragEnabled()
		PhysicsData[ 5 ] = physobj:GetVelocity()
		PhysicsData[ 6 ] = physobj:GetAngleVelocity()
		PhysicsData[ 7 ] = physobj:IsMotionEnabled()
	end

	local function ApplyPhysicsData( physobj )
		physobj:EnableGravity( PhysicsData[ 1 ] )
		physobj:SetMaterial( PhysicsData[ 2 ] )
		physobj:EnableCollisions( PhysicsData[ 3 ] )
		physobj:EnableDrag( PhysicsData[ 4 ] )
		physobj:SetVelocity( PhysicsData[ 5 ] )
		physobj:AddAngleVelocity( PhysicsData[ 6 ] - physobj:GetAngleVelocity() )
		physobj:EnableMotion( PhysicsData[ 7 ] )
	end

	local models_error = Model( "models/error.mdl" )
	local function CreateSizeHandler( ent )
		local handler = ents.Create( "sizehandler" )
		handler:SetPos( ent:GetPos() )
		handler:SetAngles( ent:GetAngles() )
		handler:SetModel( models_error )
		handler:SetNoDraw( true )
		handler:DrawShadow( false )
		handler:SetNotSolid( true )
		handler:SetMoveType( MOVETYPE_NONE )
		handler:SetParent( ent )
		handler:SetTransmitWithParent( true )
		handler:Spawn()
		return handler
	end

	local function GetSizeHandler( ent )
		local handler = FindSizeHandler( ent )
		if ( IsValidEntity( handler ) ) then return handler end
		return CreateSizeHandler( ent )
	end

	local ResizedEntities = {}
	local function CreateSizeData( ent, physobj )
		for k, v in pairs( ResizedEntities ) do if ( not IsValidEntity( k ) ) then ResizedEntities[ k ] = nil end end
		local sizedata = {}
		sizedata[ 1 ] = Vector( 1, 1, 1 )
		sizedata[ 2 ], sizedata[ 3 ] = ent:GetCollisionBounds()
		sizedata[ 4 ] = physobj:GetMass()
		ResizedEntities[ ent ] = sizedata
		return sizedata
	end

--[[
	hook.Add( "EntityRemoved", "advresizer", function( ent )
		if ( ResizedEntities[ ent ] ~= nil ) then ResizedEntities[ ent ] = nil end
	end )]]
	saverestore.AddSaveHook( "advresizer", function( save )
		save:StartBlock( "advresizer_SaveData" )
			local EntitiesToSave = {}
			for ent, sizedata in pairs( ResizedEntities ) do
				if ( IsValidEntity( ent ) ) then
					table.insert( EntitiesToSave, { ent, sizedata } )
				else
					ResizedEntities[ ent ] = nil
				end
			end
			local l = #EntitiesToSave
			save:WriteInt( l )
			for Key = 1, l do
				local Factory = EntitiesToSave[ Key ]
				local ent = Factory[ 1 ]
				save:WriteEntity( ent )
				local savedata = { Factory[ 2 ] }
				if ( HasValidPhysics( ent ) ) then
					local physobj = ent:GetPhysicsObject()
					if ( IsValidPhysicsObject( physobj ) ) then
						savedata[ 2 ] =	{
									physobj:IsGravityEnabled(),
									physobj:GetMaterial(),
									physobj:IsCollisionEnabled(),
									physobj:IsDragEnabled(),
									physobj:GetVelocity(),
									physobj:GetAngleVelocity(),
									physobj:IsMotionEnabled(),
									physobj:IsAsleep()
								}
					end
				end
				saverestore.WriteTable( savedata, save )
			end
		save:EndBlock()
	end )

	local EntitiesToRestore = {}
	saverestore.AddRestoreHook( "advresizer", function( restore )
		local name = restore:StartBlock()
		if ( name == "advresizer_SaveData" ) then
			local l = restore:ReadInt()
			for i = 1, l do
				local ent = restore:ReadEntity()
				local savedata = saverestore.ReadTable( restore )
				if ( IsValidEntity( ent ) ) then
					EntitiesToRestore[ ent ] = savedata
				end
			end
		end
		restore:EndBlock()
	end )

	hook.Add( "Restored", "advresizer", function()
		local PhysicsData_Restore = {}
		for ent, savedata in pairs( EntitiesToRestore ) do
			local sizedata = savedata[ 1 ]
			ResizedEntities[ ent ] = sizedata
			local physdata = savedata[ 2 ]
			if ( physdata ) then
				local scale = sizedata[ 1 ]
				StoreConstraintData( ent )
				PhysicsData_Restore[ ent ] = physdata
				local success = ResizePhysics( ent, scale )
				ent:SetCollisionBounds( sizedata[ 2 ] * scale, sizedata[ 3 ] * scale )
				if ( success ) then
					local physobj = ent:GetPhysicsObject()
					physobj:SetMass( math.Clamp( sizedata[ 4 ] * scale.x * scale.y * scale.z, 0.1, 50000 ) )
					physobj:SetDamping( 0, 0 )
				else
					PhysicsData_Restore[ ent ] = nil
				end
			end
			EntitiesToRestore[ ent ] = nil
		end
		ApplyConstraintData()
		for ent, physdata in pairs( PhysicsData_Restore ) do
			local physobj = ent:GetPhysicsObject()
			physobj:EnableGravity( physdata[ 1 ] )
			physobj:SetMaterial( physdata[ 2 ] )
			physobj:EnableCollisions( physdata[ 3 ] )
			physobj:EnableDrag( physdata[ 4 ] )
			physobj:SetVelocity( physdata[ 5 ] )
			physobj:AddAngleVelocity( physdata[ 6 ] - physobj:GetAngleVelocity() )
			physobj:EnableMotion( physdata[ 7 ] )
			if ( physdata[ 8 ] ) then physobj:Sleep() else physobj:Wake() end
			if ( ent.IsMotionControlled ) then o_StartMotionController( ent ) end
		end
	end )

	duplicator.RegisterEntityModifier( "advr", function( ply, ent, data )
		local override = hook.Run('CanTool', ply, { Entity = ent }, 'advresizer')
		if override == false then return end
		local pscale = Vector( data[ 1 ], data[ 2 ], data[ 3 ] )
		local vscale = Vector( data[ 4 ], data[ 5 ], data[ 6 ] )
		if ( pscale ~= RESET ) and ( HasValidPhysics( ent ) ) then
			local physobj = ent:GetPhysicsObject()
			if ( IsValidPhysicsObject( physobj ) ) then
				local sizedata = CreateSizeData( ent, physobj )
				sizedata[ 1 ]:Set( pscale )
				StorePhysicsData( physobj )
				local success = ResizePhysics( ent, pscale )
				if ( data[ 7 ] ) then
					GetSizeHandler( ent ):SetActualPhysicsScale( tostring( RESET ) )
				else
					GetSizeHandler( ent ):SetActualPhysicsScale( tostring( pscale ) )
				end
				ent:SetCollisionBounds( sizedata[ 2 ] * pscale, sizedata[ 3 ] * pscale )
				if ( success ) then
					physobj = ent:GetPhysicsObject()
					physobj:SetMass( math.Clamp( sizedata[ 4 ] * pscale.x * pscale.y * pscale.z, 0.1, 50000 ) )
					physobj:SetDamping( 0, 0 )
					ApplyPhysicsData( physobj )
					physobj:Wake()
					if ( ent.IsMotionControlled ) then o_StartMotionController( ent ) end
				end
			end
		end
		local handler = GetSizeHandler( ent )
		handler:SetVisualScale( tostring( vscale ) )

		ent._size = pscale
	end )

	function meta:SetSize(size)
		if size ~= RESET then
			self._size = size
			self:SetNetVar('size', size)
			duplicator.StoreEntityModifier( self, 'advr', { size.x, size.y, size.z, size.x, size.y, size.z } )
		else
			self._size = nil
			self:SetNetVar('size', nil)
			duplicator.ClearEntityModifier( self, 'advr' )
			GetSizeHandler( self ):SetActualPhysicsScale( tostring( RESET ) )
		end

		if ( size ~= RESET ) and ( HasValidPhysics( self ) ) then
			local physobj = self:GetPhysicsObject()
			if ( IsValidPhysicsObject( physobj ) ) then
				local sizedata = CreateSizeData( self, physobj )
				sizedata[ 1 ]:Set( size )
				StorePhysicsData( physobj )
				local success = ResizePhysics( self, size )
				GetSizeHandler( self ):SetActualPhysicsScale( tostring( size ) )
				self:SetCollisionBounds( sizedata[ 2 ] * size, sizedata[ 3 ] * size )
				if ( success ) then
					physobj = self:GetPhysicsObject()
					physobj:SetMass( math.Clamp( sizedata[ 4 ] * size.x * size.y * size.z, 0.1, 50000 ) )
					physobj:SetDamping( 0, 0 )
					ApplyPhysicsData( physobj )
					physobj:Wake()
					if ( self.IsMotionControlled ) then o_StartMotionController( self ) end
				end
			end
		end

		local handler = GetSizeHandler( self )
		handler:SetVisualScale( tostring( size ) )

		net.Start( "advresizer_set_visual_size" )
			net.WriteEntity( self )
			net.WriteString( tostring( size ) )
		net.Broadcast()

		net.Start( "advresizer_set_physical_size" )
			net.WriteEntity( self )
			net.WriteString( tostring( size ) )
		net.Broadcast()

	end

	function meta:GetSize()
		return self._size and Vector(self._size) or Vector(1,1,1)
	end

	function TOOL:GetClientBool( name )
		return tobool( self:GetClientInfo( name ) )
	end

	local SIZEHANDLER = NULL
	local WAS_RESIZED = false
	util.AddNetworkString( "advresizer_set_physical_size" )
	util.AddNetworkString( "advresizer_fix_physical_size" )

	function TOOL:SetPhysicalSize( ent, scale )
		ent._size = pscale
		if ( HasValidPhysics( ent ) ) then
			local physobj = ent:GetPhysicsObject()
			if ( IsValidPhysicsObject( physobj ) ) then
				local sizedata = ResizedEntities[ ent ] or CreateSizeData( ent, physobj )
				if ( self:GetClientBool( "prco" ) ) then StoreConstraintData( ent ) else ResizeAndStoreConstraintData( ent, scale, sizedata[ 1 ] ) end
				StorePhysicsData( physobj )
				local success = ResizePhysics( ent, scale )
				if ( self:GetClientBool( "dcp" ) ) then
					net.Start( "advresizer_fix_physical_size" )
						net.WriteEntity( ent )
					net.Broadcast()
					if ( WAS_RESIZED ) then
						SIZEHANDLER:SetActualPhysicsScale( tostring( RESET ) )
					end
				else
					if ( WAS_RESIZED ) then
						net.Start( "advresizer_set_physical_size" )
							net.WriteEntity( ent )
							net.WriteString( tostring( scale ) )
						net.Broadcast()
					else
						SIZEHANDLER = CreateSizeHandler( ent )
					end
					SIZEHANDLER:SetActualPhysicsScale( tostring( scale ) )
				end
				ent:SetCollisionBounds( sizedata[ 2 ] * scale, sizedata[ 3 ] * scale )
				if ( success ) then
					physobj = ent:GetPhysicsObject()
					physobj:SetMass( math.Clamp( sizedata[ 4 ] * scale.x * scale.y * scale.z, 0.1, 50000 ) )
					physobj:SetDamping( 0, 0 )
					ApplyConstraintData()
					ApplyPhysicsData( physobj )
					physobj:Wake()
					if ( ent.IsMotionControlled ) then o_StartMotionController( ent ) end
				else
					ApplyConstraintData()
				end
				sizedata[ 1 ]:Set( scale )
			end
		end
	end

	function TOOL:FixPhysicalSize( ent )
		ent._size = nil
		if ( HasValidPhysics( ent ) ) then
			local physobj = ent:GetPhysicsObject()
			if ( IsValidPhysicsObject( physobj ) ) then
				local sizedata = ResizedEntities[ ent ]
				if ( not sizedata ) then return end
				if ( self:GetClientBool( "prco" ) ) then StoreConstraintData( ent ) else ResizeAndStoreConstraintData( ent, RESET, sizedata[ 1 ] ) end
				StorePhysicsData( physobj )
				ent:EnableCustomCollisions( false )
				ent:PhysicsInit( SOLID_VPHYSICS )
				net.Start( "advresizer_fix_physical_size" )
					net.WriteEntity( ent )
				net.Broadcast()
				if ( WAS_RESIZED ) then
					SIZEHANDLER:SetActualPhysicsScale( tostring( RESET ) )
				end
				ent:SetCollisionBounds( sizedata[ 2 ], sizedata[ 3 ] )
				physobj = ent:GetPhysicsObject()
				if ( IsValidPhysicsObject( physobj ) ) then
					physobj:SetMass( sizedata[ 4 ] )
					ApplyConstraintData()
					ApplyPhysicsData( physobj )
					physobj:Wake()
					if ( ent.IsMotionControlled ) then o_StartMotionController( ent ) end
				else
					ApplyConstraintData()
				end
				ResizedEntities[ ent ] = nil
			end
		end
	end

	util.AddNetworkString( "advresizer_set_visual_size" )
	util.AddNetworkString( "advresizer_fix_visual_size" )

	function TOOL:SetVisualSize( ent, scale )
		if ( not WAS_RESIZED ) then return end
		net.Start( "advresizer_set_visual_size" )
			net.WriteEntity( ent )
			net.WriteString( tostring( scale ) )
		net.Broadcast()
	end

	function TOOL:FixVisualSize( ent )
		net.Start( "advresizer_fix_visual_size" )
			net.WriteEntity( ent )
		net.Broadcast()
	end

	local advresizer_clamp =	CreateConVar( "advresizer_clamp",	"0",	FCVAR_ARCHIVE + FCVAR_NOTIFY,	"Force the Prop Resizer to clamp its values." )
	local function ClampVal( scale )
		scale.x = math.Clamp( scale.x, 0.2, 5 )
		scale.y = math.Clamp( scale.y, 0.2, 5 )
		scale.z = math.Clamp( scale.z, 0.2, 5 )
	end

	function TOOL:LeftClick( Trace )
		local ent = Trace.Entity
		if ( not IsValidEntity( ent ) ) then return false end
		if ( ent:IsRagdoll() ) then return false end
		local pscale = Vector( self:GetClientNumber( "sx" ), self:GetClientNumber( "sy" ), self:GetClientNumber( "sz" ) )
		local vscale = pscale
		if ( self:GetClientBool( "smwo" ) ) then
			-- if ( advresizer_clamp:GetBool() ) then
				ClampVal( pscale )
			-- end
		else
			vscale = Vector( self:GetClientNumber( "cx" ), self:GetClientNumber( "cy" ), self:GetClientNumber( "cz" ) )
			-- if ( advresizer_clamp:GetBool() ) then
				ClampVal( pscale )
				ClampVal( vscale )
			-- end
		end
		SIZEHANDLER = FindSizeHandler( ent )
		WAS_RESIZED = IsValidEntity( SIZEHANDLER )
		if ( pscale == RESET ) then
			self:FixPhysicalSize( ent )
			if ( vscale == RESET ) then
				self:FixVisualSize( ent )
				if ( WAS_RESIZED ) then SIZEHANDLER:Remove() end
				duplicator.ClearEntityModifier( ent, "advr" )
				return true
			else
				self:SetVisualSize( ent, vscale )
			end
		else
			self:SetPhysicalSize( ent, pscale )
			if ( vscale == RESET ) then
				self:FixVisualSize( ent )
			else
				self:SetVisualSize( ent, vscale )
			end
		end
		if ( not IsValidEntity( SIZEHANDLER ) ) then SIZEHANDLER = CreateSizeHandler( ent ) end
		SIZEHANDLER:SetVisualScale( tostring( vscale ) )
		duplicator.StoreEntityModifier( ent, "advr", { pscale.x, pscale.y, pscale.z, vscale.x, vscale.y, vscale.z, self:GetClientBool( "dcp" ) } )
		return true
	end

	function TOOL:RightClick( Trace )
		local ent = Trace.Entity
		if ( not IsValidEntity( ent ) ) then return false end
		if ( ent:IsRagdoll() ) then return false end
		SIZEHANDLER = FindSizeHandler( ent )
		WAS_RESIZED = IsValidEntity( SIZEHANDLER )
		self:FixPhysicalSize( ent )
		self:FixVisualSize( ent )
		if ( WAS_RESIZED ) then SIZEHANDLER:Remove() end
		duplicator.ClearEntityModifier( ent, "advr" )
		return true
	end

end

if ( CLIENT ) then
	local function IsValidModel( mdl )
		return isstring( mdl ) and mdl ~= models_error
	end
	local ResizedEntities = {}
	local function CreateSizeData( ent )
		for k, v in pairs( ResizedEntities ) do if ( not IsValidEntity( k ) ) then ResizedEntities[ k ] = nil end end
		local sizedata = {}
		sizedata[ 1 ] = Vector( 1, 1, 1 )
		sizedata[ 2 ], sizedata[ 3 ] = ent:GetRenderBounds()
		ResizedEntities[ ent ] = sizedata
		return sizedata
	end

	local ClientPhysics = {}
	local function CreateClientPhysicsData( ent )
		for k, v in pairs( ClientPhysics ) do if ( not IsValidEntity( k ) ) then ClientPhysics[ k ] = nil end end
		local physdata = {}
		physdata[ 1 ] = Vector( 1, 1, 1 )
		ClientPhysics[ ent ] = physdata
		return physdata
	end

--[[
	hook.Add( "EntityRemoved", "advresizer", function( ent )
		if ( ResizedEntities[ ent ] ~= nil ) then ResizedEntities[ ent ] = nil end
	end )]]
	local function IsBig( scale )
		if ( scale.x >= 4 ) then
			return ( scale.y >= 4 ) or ( scale.z >= 4 )
		elseif ( scale.y >= 4 ) then
			return ( scale.z >= 4 )
		end
		return false
	end

	saverestore.AddSaveHook( "advresizer", function( save )
		save:StartBlock( "advresizer_SaveData" )
			local EntitiesToSave = {}
			for ent, sizedata in pairs( ResizedEntities ) do
				if ( IsValidEntity( ent ) ) then
					table.insert( EntitiesToSave, { ent, sizedata } )
				else
					ResizedEntities[ ent ] = nil
				end
			end
			local l = #EntitiesToSave
			save:WriteInt( l )
			for Key = 1, l do
				local Factory = EntitiesToSave[ Key ]
				save:WriteEntity( Factory[ 1 ] )
				saverestore.WriteTable( Factory[ 2 ], save )
			end
		save:EndBlock()
	end )

	saverestore.AddRestoreHook( "advresizer", function( restore )
		local name = restore:StartBlock()
		if ( name == "advresizer_SaveData" ) then
			local l = restore:ReadInt()
			for Key = 1, l do
				local ent = restore:ReadEntity()
				local sizedata = saverestore.ReadTable( restore )
				if ( IsValidEntity( ent ) ) then
					ResizedEntities[ ent ] = sizedata
				end
			end
		end
		restore:EndBlock()
	end )

	net.Receive( "advresizer_set_visual_size", function( l )
		local ent = net.ReadEntity()
		local scale = net.ReadString()
		if IsValidEntity( ent ) then
			ent:SetSize( Vector( scale ) )
		end
	end )

	net.Receive( "advresizer_fix_visual_size", function( l )
		local ent = net.ReadEntity()
		if IsValidEntity( ent ) then
			ent:SetSize( RESET )
		end
	end )

	local meta = FindMetaTable 'Entity'

	function meta:SetSize(size)
		if not IsValid(self) or not IsValidModel( self:GetModel() ) then return end

		if size ~= RESET then
			self._size = size

			local sizedata = ResizedEntities[ self ] or CreateSizeData( self )
			local m = Matrix()
			m:Scale( size )
			self:EnableMatrix( "RenderMultiply", m )
			self:SetRenderBounds( sizedata[ 2 ] * size, sizedata[ 3 ] * size )
			self:DestroyShadow()
			if ( IsBig( size ) ) then self:SetLOD( 0 ) else self:SetLOD( -1 ) end
			sizedata[ 1 ]:Set( size )

			local physdata = ClientPhysics[ self ] or CreateClientPhysicsData( self )
			local success = ResizePhysics( self, size )
			if ( success ) then
				local physobj = self:GetPhysicsObject()
				if ( IsValidPhysicsObject( physobj ) ) then
					physobj:SetPos( self:GetPos() )
					physobj:SetAngles( self:GetAngles() )
					physobj:EnableMotion( false )
					physobj:Sleep()
				end
			end
			physdata[ 1 ]:Set( size )
		else
			self._size = nil

			local sizedata = ResizedEntities[ self ]
			if ( not sizedata ) then return end
			self:DisableMatrix( "RenderMultiply" )
			self:SetRenderBounds( sizedata[ 2 ], sizedata[ 3 ] )
			self:DestroyShadow()
			self:SetLOD( -1 )
			ResizedEntities[ self ] = nil

			local physdata = ClientPhysics[ self ]
			if ( not physdata ) then return end
			self:PhysicsDestroy()
			ClientPhysics[ self ] = nil
		end
	end

	function meta:GetSize()
		return self._size and Vector(self._size) or Vector(1,1,1)
	end

--[[
	hook.Add( "EntityRemoved", "advresizer_clientphysics", function( ent )
		if ( ClientPhysics[ ent ] ~= nil ) then ClientPhysics[ ent ] = nil end
	end )]]
	saverestore.AddSaveHook( "clientphysics", function( save )
		save:StartBlock( "PhysData" )
			local EntitiesToSave = {}
			for ent, physdata in pairs( ClientPhysics ) do
				if ( IsValidEntity( ent ) ) then
					table.insert( EntitiesToSave, { ent, physdata } )
				else
					ClientPhysics[ ent ] = nil
				end
			end
			local l = #EntitiesToSave
			save:WriteInt( l )
			for Key = 1, l do
				local Factory = EntitiesToSave[ Key ]
				save:WriteEntity( Factory[ 1 ] )
				saverestore.WriteTable( Factory[ 2 ], save )
			end
		save:EndBlock()
	end )

	saverestore.AddRestoreHook( "clientphysics", function( restore )
		local name = restore:StartBlock()
		if ( name == "PhysData" ) then
			local l = restore:ReadInt()
			for Key = 1, l do
				local ent = restore:ReadEntity()
				local physdata = saverestore.ReadTable( restore )
				if ( IsValidEntity( ent ) ) then
					ClientPhysics[ ent ] = physdata
				end
			end
		end
		restore:EndBlock()
	end )

	net.Receive( "advresizer_set_physical_size", function( l )
		local ent = net.ReadEntity()
		local scale = net.ReadString()
		if ( IsValidEntity( ent ) ) then
			scale = Vector( scale )
			local physdata = ClientPhysics[ ent ] or CreateClientPhysicsData( ent )
			local success = ResizePhysics( ent, scale )
			if ( success ) then
				local physobj = ent:GetPhysicsObject()
				if ( IsValidPhysicsObject( physobj ) ) then
					physobj:SetPos( ent:GetPos() )
					physobj:SetAngles( ent:GetAngles() )
					physobj:EnableMotion( false )
					physobj:Sleep()
				end
			end
			physdata[ 1 ]:Set( scale )
		end
	end )

	net.Receive( "advresizer_fix_physical_size", function( l )
		local ent = net.ReadEntity()
		if ( IsValidEntity( ent ) ) then
			local physdata = ClientPhysics[ ent ]
			if ( not physdata ) then return end
			ent:PhysicsDestroy()
			ClientPhysics[ ent ] = nil
		end
	end )

	function ENT:Think()
		local ent = self:GetParent()
		if ( not IsValidEntity( ent ) ) then return end
		if ( not ClientPhysics[ ent ] ) then return end
		local physobj = ent:GetPhysicsObject()
		if ( not IsValidPhysicsObject( physobj ) ) then return end
		physobj:SetPos( ent:GetPos() )
		physobj:SetAngles( ent:GetAngles() )
		physobj:EnableMotion( false )
		physobj:Sleep()
	end

	function ENT:RefreshVisualSize( ent )
		local sizedata = ResizedEntities[ ent ]
		if ( sizedata ) then
			local scale = sizedata[ 1 ]
			local m = Matrix()
			m:Scale( scale )
			ent._size = scale
			ent:EnableMatrix( "RenderMultiply", m )
			ent:SetRenderBounds( sizedata[ 2 ] * scale, sizedata[ 3 ] * scale )
			ent:DestroyShadow()
			if ( IsBig( scale ) ) then ent:SetLOD( 0 ) else ent:SetLOD( -1 ) end
		elseif ( isfunction( self.GetVisualScale ) ) then
			local scale = Vector( self:GetVisualScale() )
			if ( scale ~= RESET ) and ( scale ~= EMPTY ) then
				sizedata = CreateSizeData( ent )
				sizedata[ 1 ]:Set( scale )
				local m = Matrix()
				m:Scale( scale )
				ent._size = scale
				ent:EnableMatrix( "RenderMultiply", m )
				ent:SetRenderBounds( sizedata[ 2 ] * scale, sizedata[ 3 ] * scale )
				ent:DestroyShadow()
				if ( IsBig( scale ) ) then ent:SetLOD( 0 ) else ent:SetLOD( -1 ) end
			end
		end
	end

	function ENT:RefreshClientPhysics( ent )
		local physdata = ClientPhysics[ ent ]
		if ( physdata ) then
			local success = ResizePhysics( ent, physdata[ 1 ] )
			if ( success ) then
				local physobj = ent:GetPhysicsObject()
				physobj:SetPos( ent:GetPos() )
				physobj:SetAngles( ent:GetAngles() )
				physobj:EnableMotion( false )
				physobj:Sleep()
			end
		elseif ( isfunction( self.GetActualPhysicsScale ) ) then
			local scale = Vector( self:GetActualPhysicsScale() )
			if ( scale ~= RESET ) and ( scale ~= EMPTY ) then
				physdata = CreateClientPhysicsData( ent )
				physdata[ 1 ]:Set( scale )
				local success = ResizePhysics( ent, scale )
				if ( success ) then
					local physobj = ent:GetPhysicsObject()
					physobj:SetPos( ent:GetPos() )
					physobj:SetAngles( ent:GetAngles() )
					physobj:EnableMotion( false )
					physobj:Sleep()
				end
			end
		end
	end

	function ENT:OnNetworkEntityCreated()
		local ent = self:GetParent()
		if ( not IsValidEntity( ent ) ) then return end
		if ( isfunction( self.GetVisualScale ) ) then
			local sizedata = ResizedEntities[ ent ]
			if ( sizedata ) then
				local scale = sizedata[ 1 ]
				local m = Matrix()
				m:Scale( scale )
				ent._size = scale
				ent:EnableMatrix( "RenderMultiply", m )
				ent:SetRenderBounds( sizedata[ 2 ] * scale, sizedata[ 3 ] * scale )
				ent:DestroyShadow()
				if ( IsBig( scale ) ) then ent:SetLOD( 0 ) else ent:SetLOD( -1 ) end
			else
				local scale = Vector( self:GetVisualScale() )
				if ( scale ~= RESET ) and ( scale ~= EMPTY ) then
					sizedata = CreateSizeData( ent )
					sizedata[ 1 ]:Set( scale )
					local m = Matrix()
					m:Scale( scale )
					ent._size = scale
					ent:EnableMatrix( "RenderMultiply", m )
					ent:SetRenderBounds( sizedata[ 2 ] * scale, sizedata[ 3 ] * scale )
					ent:DestroyShadow()
					if ( IsBig( scale ) ) then ent:SetLOD( 0 ) else ent:SetLOD( -1 ) end
				end
			end
		end
		if ( isfunction( self.GetActualPhysicsScale ) ) then
			local physdata = ClientPhysics[ ent ]
			if ( physdata ) then
				local scale = physdata[ 1 ]
				local success = ResizePhysics( ent, scale )
				if ( success ) then
					local physobj = ent:GetPhysicsObject()
					physobj:SetPos( ent:GetPos() )
					physobj:SetAngles( ent:GetAngles() )
					physobj:EnableMotion( false )
					physobj:Sleep()
				end
			else
				local scale = Vector( self:GetActualPhysicsScale() )
				if ( scale ~= RESET ) and ( scale ~= EMPTY ) then
					physdata = CreateClientPhysicsData( ent )
					physdata[ 1 ]:Set( scale )
					local success = ResizePhysics( ent, scale )
					if ( success ) then
						local physobj = ent:GetPhysicsObject()
						physobj:SetPos( ent:GetPos() )
						physobj:SetAngles( ent:GetAngles() )
						physobj:EnableMotion( false )
						physobj:Sleep()
					end
				end
			end
		end
	end
	hook.Add( "NetworkEntityCreated", "advresizer", function( ent )
		if ( ent:GetClass() == "sizehandler" ) and isfunction( ent.OnNetworkEntityCreated ) then
			ent:OnNetworkEntityCreated()
		end
	end )
	TOOL.Information =	{
		{ name = "left" },
		{ name = "right" }
	}
	language.Add( "tool.advresizer.name", "Prop Resizer" )
	language.Add( "tool.advresizer.desc", "Resizes props" )
--	language.Add( "tool.advresizer.0", "Left click to resize. Right click to reset." )
	language.Add( "tool.advresizer.left", "Set size" )
	language.Add( "tool.advresizer.right", "Fix size" )
	language.Add( "tool.advresizer.sx", "Physical X Scale" )
	language.Add( "tool.advresizer.sy", "Physical Y Scale" )
	language.Add( "tool.advresizer.sz", "Physical Z Scale" )
	language.Add( "tool.advresizer.smwo", "Scale Visual with Physical" )
	language.Add( "tool.advresizer.smwo.help", "Use the above values to scale visually." )
	language.Add( "tool.advresizer.cx", "Visual X Scale" )
	language.Add( "tool.advresizer.cy", "Visual Y Scale" )
	language.Add( "tool.advresizer.cz", "Visual Z Scale" )
	language.Add( "tool.advresizer.prco", "Preserve Constraint Locations" )
	language.Add( "tool.advresizer.dcp", "Disable Client Physics" )

	function TOOL.BuildCPanel( CPanel )
		CPanel:Help( "#tool.advresizer.desc" )
		local ctrl = vgui.Create( "ControlPresets", CPanel )
		ctrl:SetPreset( "advresizer" )
		local default =		{
						advresizer_sx =		"1",
						advresizer_sy =		"1",
						advresizer_sz =		"1",
						advresizer_smwo =	"1",
						advresizer_cx =		"1",
						advresizer_cy =		"1",
						advresizer_cz =		"1",
						advresizer_prco =	"0",
						advresizer_dcp =	"0"
					}
		ctrl:AddOption( "#preset.default", default )
		for k, v in pairs( default ) do ctrl:AddConVar( k ) end
		CPanel:AddPanel( ctrl )
		CPanel:NumSlider( "#tool.advresizer.sx", "advresizer_sx", 0.1, 10, 2 )
		CPanel:NumSlider( "#tool.advresizer.sy", "advresizer_sy", 0.1, 10, 2 )
		CPanel:NumSlider( "#tool.advresizer.sz", "advresizer_sz", 0.1, 10, 2 )
		CPanel:CheckBox( "#tool.advresizer.smwo", "advresizer_smwo" )
		CPanel:NumSlider( "#tool.advresizer.cx", "advresizer_cx", 0.1, 10, 2 )
		CPanel:NumSlider( "#tool.advresizer.cy", "advresizer_cy", 0.1, 10, 2 )
		CPanel:NumSlider( "#tool.advresizer.cz", "advresizer_cz", 0.1, 10, 2 )
		CPanel:CheckBox( "#tool.advresizer.prco", "advresizer_prco" )
		CPanel:CheckBox( "#tool.advresizer.dcp", "advresizer_dcp" )
	end
end

function ENT:SetupDataTables()
	self:NetworkVar( "String",	0,	"VisualScale",		{ KeyName = "visualscale" } )
	self:NetworkVar( "String",	1,	"ActualPhysicsScale",	{ KeyName = "actualphysicsscale" } )
	if ( CLIENT ) then
		local ent = self:GetParent()
		if ( IsValidEntity( ent ) ) then
			if ( isfunction( self.RefreshVisualSize ) ) then self:RefreshVisualSize( ent ) end
			if ( isfunction( self.RefreshClientPhysics ) ) then self:RefreshClientPhysics( ent ) end
		end
	end
end
scripted_ents.Register( ENT, "sizehandler" )

local unique_name = "Effect_Resizer_641848001"
local function SetDimensions(ply, effect, data, scale)
	if not IsValid(effect) then return end

	local override = hook.Run('CanTool', ply, { Entity = effect }, 'effectresizer')
	if override == false then return end

	if scale then effect:SetModelScale(scale, ANIM_LENGTH) end	-- only happens when called from the toolgun, not from duplicator library

	local old_dims = effect:GetNW2Vector(unique_name, FULL_SIZE)

	local new_dims = data.dimensions
	local x, y, z = new_dims.x, new_dims.y, new_dims.z

	local fullsize = x == 1 and y == 1 and z == 1 -- if all dimensions are 1, then there's no dimensions at all

	local xflat = (x == 0) and 1 or 0
	local yflat = (y == 0) and 1 or 0
	local zflat = (z == 0) and 1 or 0
	local tooflat = xflat + yflat + zflat > 1	-- only one axis is allowed to be flat, otherwise nothing is visible

	if fullsize or tooflat then
		-- bad/irrelevant dimensions
		effect:SetNW2Vector(unique_name, nil)
		new_dims = FULL_SIZE
		duplicator.ClearEntityModifier(effect, unique_name) -- I've checked the duplicator library source code, and removing a modifier while it's being run will not cause problems. It loops through available modifiers, not through the entity's modifiers.
	else
		effect:SetNW2Vector(unique_name, data.dimensions)
		duplicator.StoreEntityModifier(effect, unique_name, data)
	end

	net.Start(unique_name)
		net.WriteUInt(effect:EntIndex(), 16)	-- entity might not yet be valid clientside, so send as entity index
		net.WriteVector(scale and old_dims or new_dims)	-- in general, this writes old_dims; However, if this was called from the duplicator library, I don't want the animation to play, so I send new_dims twice.
		net.WriteVector(new_dims)
	net.Broadcast()
end

--[[-------------------------------------------------------------------------
Register duplicator entity modifier
---------------------------------------------------------------------------]]
duplicator.RegisterEntityModifier(unique_name, SetDimensions)
