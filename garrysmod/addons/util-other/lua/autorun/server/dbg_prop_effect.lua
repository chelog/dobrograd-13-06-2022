hook.Add('PlayerSpawnedEffect', 'dbg.noCollideForEffects', function(ply, mdl, ent)
	if not IsValid(ent) then return end
	ent:SetCollisionGroup(COLLISION_GROUP_WORLD)
end)
