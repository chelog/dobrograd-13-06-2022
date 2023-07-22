
AddCSLuaFile()

properties.Add( "rb655_make_animatable", {
	MenuLabel = "#tool.rb655_easy_animation.property",
	Order = 654,
	MenuIcon = "icon16/tick.png",
	Filter = function( self, ent, ply )
		if ( !IsValid( ent ) or !gamemode.Call( "CanProperty", ply, "rb655_make_animatable", ent ) ) then return false end
		if ( ent:GetClass() == "prop_animatable" ) then return false end
		--if ( string.find( ent:GetClass(), "prop_physics" ) or string.find( ent:GetClass(), "prop_ragdoll" ) ) then return true end
		return true
	end,
	Action = function( self, ent )
		self:MsgStart()
		net.WriteEntity( ent )
		self:MsgEnd()
	end,
	Receive = function( self, len, ply )
		local ent = net.ReadEntity()

		if ( !IsValid( ply ) or !IsValid( ent ) or !self:Filter( ent, ply ) ) then return false end
		if not ply:query('Make Animatable') then return end

		local prop_animatable = ents.Create( "prop_animatable" )
		prop_animatable:SetModel( ent:GetModel() )
		prop_animatable:SetPos( ent:GetPos() )
		prop_animatable:SetAngles( ent:GetAngles() )

		prop_animatable:SetSkin( ent:GetSkin() )
		prop_animatable:SetFlexScale( ent:GetFlexScale() )
		for i = 0, ent:GetFlexNum() - 1 do prop_animatable:SetFlexWeight( i, ent:GetFlexWeight( i ) ) end
		for i = 0, ent:GetNumBodyGroups() - 1 do prop_animatable:SetBodygroup( i, ent:GetBodygroup( i ) ) end
		--for i = 0, ent:GetNumPoseParameters() - 1 do prop_animatable:SetPoseParameter( i, ent:GetPoseParameter( i ) ) end
		for i = 0, ent:GetBoneCount() do
			prop_animatable:ManipulateBoneScale( i, ent:GetManipulateBoneScale( i ) )
			prop_animatable:ManipulateBoneAngles( i, ent:GetManipulateBoneAngles( i ) )
			prop_animatable:ManipulateBonePosition( i, ent:GetManipulateBonePosition( i ) )
			prop_animatable:ManipulateBoneJiggle( i, ent:GetManipulateBoneJiggle( i ) ) -- Even though we don't know what this does, I am still putting this here.
		end
		--prop_animatable:InvalidateBoneCache()

		prop_animatable:Spawn()
		prop_animatable:Activate()
		prop_animatable:CPPISetOwner(ent:CPPIGetOwner())

		prop_animatable.EntityMods = ent.EntityMods
		prop_animatable.BoneMods = ent.BoneMods
		duplicator.ApplyEntityModifiers( nil, prop_animatable )
		duplicator.ApplyBoneModifiers( nil, prop_animatable )

		if ( string.find( ent:GetClass(), "prop_ragdoll" ) or ent:IsNPC() ) then -- We use string find because there are might be subclasses, like prop_ragdoll_multiplayer or something
			prop_animatable:FixRagdoll() -- This WILL have false-positives, but it will have to do for now
		end

		undo.ReplaceEntity( ent, prop_animatable )
		cleanup.ReplaceEntity( ent, prop_animatable )

		constraint.RemoveAll( ent ) -- Remove all constraints ( this stops ropes from hanging around )
		ent:Remove()
	end
} )

properties.Add( "rb655_make_ragdoll", {
	MenuLabel = "#tool.rb655_easy_animation.property_ragdoll",
	Order = 653,
	MenuIcon = "icon16/tick.png",
	Filter = function( self, ent, ply )
		if ( !IsValid( ent ) or !gamemode.Call( "CanProperty", ply, "rb655_make_ragdoll", ent ) ) then return false end
		if ( ent:GetClass() != "prop_animatable" ) then return false end
		if ( !ent.GetIsRagdoll or !ent:GetIsRagdoll() ) then return false end
		return true
	end,
	Action = function( self, ent )
		self:MsgStart()
		net.WriteEntity( ent )
		self:MsgEnd()
	end,
	Receive = function( self, len, ply )
		local ent = net.ReadEntity()

		if ( !IsValid( ply ) or !IsValid( ent ) or !self:Filter( ent, ply ) ) then return false end
		if not ply:IsSuperAdmin() then return end

		local ragdoll = ents.Create( "prop_ragdoll" )
		ragdoll:SetModel( ent:GetModel() )
		ragdoll:SetPos( ent:GetPos() )
		ragdoll:SetAngles( ent:GetAngles() )

		ragdoll:SetSkin( ent:GetSkin() )
		ragdoll:SetFlexScale( ent:GetFlexScale() )
		for i = 0, ent:GetNumBodyGroups() - 1 do ragdoll:SetBodygroup( i, ent:GetBodygroup( i ) ) end
		for i = 0, ent:GetFlexNum() - 1 do ragdoll:SetFlexWeight( i, ent:GetFlexWeight( i ) ) end
		for i = 0, ent:GetBoneCount() do
			ragdoll:ManipulateBoneScale( i, ent:GetManipulateBoneScale( i ) )
			ragdoll:ManipulateBoneAngles( i, ent:GetManipulateBoneAngles( i ) )
			ragdoll:ManipulateBonePosition( i, ent:GetManipulateBonePosition( i ) )
			ragdoll:ManipulateBoneJiggle( i, ent:GetManipulateBoneJiggle( i ) ) -- Even though we don't know what this does, I am still putting this here.
		end

		ragdoll:Spawn()
		ragdoll:Activate()

		ragdoll.EntityMods = ent.EntityMods
		ragdoll.BoneMods = ent.BoneMods
		duplicator.ApplyEntityModifiers( nil, ragdoll )
		duplicator.ApplyBoneModifiers( nil, ragdoll )

		for i = 0, ragdoll:GetPhysicsObjectCount() - 1 do
			local bone = ragdoll:GetPhysicsObjectNum( i )
			if ( IsValid( bone ) ) then
				local pos, ang = ent:GetBonePosition( ragdoll:TranslatePhysBoneToBone( i ) )
				if ( pos ) then bone:SetPos( pos ) end
				if ( ang ) then bone:SetAngles( ang ) end

				bone:EnableMotion( false )
			end
		end

		undo.ReplaceEntity( ent, ragdoll )
		cleanup.ReplaceEntity( ent, ragdoll )

		constraint.RemoveAll( ent ) -- Remove all constraints ( this stops ropes from hanging around )
		ent:Remove()
	end
} )
