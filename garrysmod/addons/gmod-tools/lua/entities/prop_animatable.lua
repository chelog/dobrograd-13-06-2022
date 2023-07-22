
AddCSLuaFile()

ENT.Base = "base_entity"
ENT.Type = "anim"
ENT.RenderGroup = RENDERGROUP_BOTH

ENT.AutomaticFrameAdvance = true

function ENT:SetupDataTables()

	self:NetworkVar( "Bool", 0, "IsRagdoll" )

	if ( CLIENT ) then return end

	self:SetIsRagdoll( false )

end

if ( SERVER ) then
	function ENT:Initialize()
		self:SetSolid( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_NONE )
	end

	function ENT:FixRagdoll()
		local mins = self:OBBMins()
		local maxs = self:OBBMaxs()
		mins.z = 0

		self.OriginalCollisions = mins
		self.OriginalCollisionsMax = maxs

		self:PhysicsInitBox( mins, maxs )
		self:SetMoveType( MOVETYPE_NONE )

		-- Used to determine if this animatable prop should have the "Turn into Ragdoll" option.
		self:SetIsRagdoll( true )
	end

	function ENT:PreEntityCopy()
		self.DuplicatorSavedSequence = self:GetSequence()
		self.DuplicatorSavedSequenceName = self:GetSequenceName( self:GetSequence() )
		self.DuplicatorSavedCycle = self:GetCycle()
		self.DuplicatorSavedPlaybackRate = self:GetPlaybackRate()
	end

	function ENT:PostEntityPaste()
		if ( self:GetIsRagdoll() ) then self:FixRagdoll() end

		if ( !self.DuplicatorSavedSequence ) then return end

		if ( self.DuplicatorSavedSequence != self:LookupSequence( self.DuplicatorSavedSequenceName ) ) then
			print( "Something went wrong with restoring sequence for animatable prop!" )
			self.DuplicatorSavedSequence = self:LookupSequence( self.DuplicatorSavedSequenceName )
		end

		self:ResetSequence( self.DuplicatorSavedSequence )
		self:SetCycle( self.DuplicatorSavedCycle )
		self:SetPlaybackRate( self.DuplicatorSavedPlaybackRate )
	end
end

function ENT:Think()
	//self:SetCollisionBounds( self:GetModelBounds() )

	self:NextThink( CurTime() )
	return true
end

if ( SERVER ) then return end

local bboxMat = Material( "vgui/white" )
function ENT:DrawBBox()
	if ( GetConVarNumber( "rb655_easy_animation_noglow" ) != 0 ) then return end

	local wep = LocalPlayer():GetActiveWeapon()
	if ( IsValid( wep ) && wep:GetClass() == "gmod_camera" ) then
		return
	end

	local mins = self:OBBMins()
	local maxs = self:OBBMaxs()
	local corner1 = self:GetPos() + Vector( maxs.x, mins.y, mins.z )
	local corner2 = self:GetPos() + Vector( maxs.x, maxs.y, mins.z )
	local corner3 = self:GetPos() + Vector( mins.x, maxs.y, mins.z )

	render.SetMaterial( bboxMat )
	render.DrawQuad(  corner3,corner2, corner1, self:GetPos() + mins )
end

function ENT:Draw()
	-- self:DrawBBox()

	self:SetRenderBounds( self:GetModelBounds() )
	self:DrawModel()
end

function ENT:DrawTranslucent()
	self:Draw()
end
