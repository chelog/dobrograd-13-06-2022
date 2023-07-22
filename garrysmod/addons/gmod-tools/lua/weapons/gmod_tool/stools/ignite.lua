TOOL.Category		= "Dobrograd"
TOOL.Name			= L.ignite
TOOL.Command		= nil
TOOL.ConfigName		= nil

if CLIENT then
language.Add("tool.ignite.name", "Ignite")
language.Add("tool.ignite.desc", "Light a prop or ragdoll on fire")
language.Add("tool.ignite.0", "Left click to light on fire. Right click to extinguish.")
language.Add("tool.ignite.length", "Duration:")
language.Add("tool.ignite.desc", "How long the prop stays on fire")
end

TOOL.ClientConVar["length"] = 15

function TOOL:LeftClick( trace )

	if (!trace.Entity) then return false end
	if (!trace.Entity:IsValid() ) then return false end
	if (trace.Entity:IsPlayer()) then return false end
	if (trace.Entity:IsWorld()) then return false end

	if ( CLIENT ) then return true end

	local _length	= math.Max( self:GetClientNumber( "length" ), 2 )

	trace.Entity:Extinguish()
	trace.Entity:Ignite( _length, 0 )

	return true

end

function TOOL.BuildCPanel( panel )
	panel:AddControl( "Header", { Text = "#tool.ignite.name", Description	= "#tool.ignite.desc" }  )
	panel:AddControl( "Slider", { Label = "#tool.ignite.length", Type = "Float", Command = "ignite_length", Min = "0", Max = "1000" }  )
end

function TOOL:RightClick( trace )

	if (!trace.Entity) then return false end
	if (!trace.Entity:IsValid() ) then return false end
	if (trace.Entity:IsPlayer()) then return false end
	if (trace.Entity:IsWorld()) then return false end

	// Client can bail out now
	if ( CLIENT ) then return true end

	trace.Entity:Extinguish()

	return true

end
