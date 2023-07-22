
AddCSLuaFile()

if ( CLIENT ) then
	CreateConVar( "cl_draweffectrings", "1", 0, "Should the effect green rings be visible?" )
end

ENT.Type = "anim"

ENT.Spawnable = false

function ENT:Initialize()

	local Radius = 6
	local min = Vector( 1, 1, 1 ) * Radius * -0.5
	local max = Vector( 1, 1, 1 ) * Radius * 0.5

	if ( SERVER ) then
		self:PhysicsInitBox( min, max )

		local phys = self:GetPhysicsObject()
		if ( IsValid( phys ) ) then
			phys:Wake()
			phys:EnableGravity( false )
			phys:EnableDrag( false )
		end

		-- self:DrawShadow( false )
		-- self:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	else
		self.GripMaterial = Material( "sprites/grip" )
	end

	-- Set collision bounds exactly
	self:SetCollisionBounds( min, max )

end

function ENT:Draw()

	self:DrawModel()

	if ( GetConVarNumber( "cl_draweffectrings" ) == 0 ) then return end

	-- don't draw rings over other's props
	local owner = self:CPPIGetOwner()
	if owner ~= LocalPlayer() then return end

	-- Don't draw the grip if there's no chance of us picking it up
	local ply = LocalPlayer()
	local wep = ply:GetActiveWeapon()
	if ( !IsValid( wep ) ) then return end

	local weapon_name = wep:GetClass()

	if ( weapon_name != "weapon_physgun" && weapon_name != "weapon_physcannon" && weapon_name != "gmod_tool" ) then
		return
	end

	render.SetMaterial( self.GripMaterial )
	render.DrawSprite( self:GetPos(), 16, 16, color_white )

end

function ENT:PhysicsUpdate( physobj )

	if ( CLIENT ) then return end

	-- Don't do anything if the player isn't holding us
	if ( !self:IsPlayerHolding() && !self:IsConstrained() ) then

		physobj:SetVelocity( Vector( 0, 0, 0 ) )
		physobj:Sleep()

	end

end

function ENT:OnEntityCopyTableFinish( tab )

	-- We need to store the model of the attached entity
	-- Not the one we have here.
	tab.Model = self:GetModel()

	-- Store the attached entity's table so we can restore it after being pasted
	tab.AttachedEntityInfo = table.Copy( tab )
	tab.AttachedEntityInfo.Pos = nil -- Don't even save angles and position, we are a parented entity
	tab.AttachedEntityInfo.Angle = nil

	-- Do NOT store the attached entity itself in our table!
	-- Otherwise, if we copy-paste the prop with the duplicator, its AttachedEntity value will point towards the original prop's attached entity instead, and that'll break stuff
	tab.AttachedEntity = nil

end

function ENT:PostEntityPaste( ply )

	self.AttachedEntityInfo = nil

end
