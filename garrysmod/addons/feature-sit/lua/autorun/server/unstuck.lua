local ply = nil

-- WeHateGarbage
local t = {start=nil,endpos=nil,mask=MASK_PLAYERSOLID,filter=nil}
local function PlayerNotStuck()

	t.start = ply:GetPos()
	t.endpos = t.start
	t.filter = ply
	
	return util.TraceEntity(t,ply).StartSolid == false
	
end

local NewPos = nil
local function FindPassableSpace( direction, step )

	local i = 0
	while ( i < 100 ) do
		local origin = ply:GetPos()

		--origin = VectorMA( origin, step, direction )
		origin = origin + step * direction
		
		ply:SetPos( origin )
		if ( PlayerNotStuck( ply ) ) then
			NewPos = ply:GetPos()
			return true
		end
		i = i + 1
	end
	return false
end

/* 	
	Purpose: Unstucks player ,
	Note: Very expensive to call, you have been warned!
*/
local function UnstuckPlayer( pl )
	ply = pl

	NewPos = ply:GetPos()
	local OldPos = NewPos
	
	if ( !PlayerNotStuck( ply ) ) then
	
		local angle = ply:GetAngles()
		
		local forward = angle:Forward()
		local right = angle:Right()
		local up = angle:Up()
		
		local SearchScale = 3 -- Increase and it will unstuck you from even harder places but with lost accuracy. Please, don't try higher values than 12
		if ( !FindPassableSpace(  forward, SearchScale ) )
		then
			if ( !FindPassableSpace(  right, SearchScale ) )
			then
				if ( !FindPassableSpace(  right, -SearchScale ) )		// left
				then
					if ( !FindPassableSpace(  forward, -SearchScale ) )	// back
					then
						if ( !FindPassableSpace(  up, -SearchScale ) )	// down
						then
							if ( !FindPassableSpace(  up, SearchScale ) )	// up
							then
							
								-- spam spam spam
								
								--Msg( "Can't find the world for player "..tostring(ply).."\n" )
								
								return false
									
							end
						end
					end
				end
			end
		end
		
		if OldPos == NewPos then 
			print("Unstuck: Shouldnothappen")
			return true -- Not stuck?
		else
			ply:SetPos( NewPos )
			if SERVER and ply and ply:IsValid() and ply:GetPhysicsObject():IsValid() then
				if ply:IsPlayer() then
					ply:SetVelocity(vector_origin)
				end
				ply:GetPhysicsObject():SetVelocity(vector_origin) -- For some reason setting origin MAY apply some velocity so we're resetting it here.
			end
			return true
		end
		
	end
	
	
end




---------------------	
-- Helper functions
---------------------
local meta = FindMetaTable"Player" 

if meta.UnStuck then
	--ErrorNoHalt"Player:UnStuck implemented by other addon?"	
else


	/*	Unstucks a player

	returns:
		true:	Unstucked
		false:	Could not UnStuck
		else:	Not stuck 
	*/
	function meta:UnStuck()
		return UnstuckPlayer(self)
	end
end