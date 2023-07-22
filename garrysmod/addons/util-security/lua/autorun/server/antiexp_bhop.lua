hook.Add('OnPlayerHitGround', 'antibhop', function(ply, inWater, onFloater, speed)
	local velocity = ply:GetVelocity()
	if velocity:Length2DSqr() > 40000 then
		ply:SetVelocity(Vector(velocity.x * -0.5, velocity.y * -0.5, velocity.z))
	end
end)
