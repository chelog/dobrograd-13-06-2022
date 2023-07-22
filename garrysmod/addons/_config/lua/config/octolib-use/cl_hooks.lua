local icon = Material('octoteam/icons/hand_point.png')
hook.Add('dbg-view.chOverride', 'octolib.use', function(tr)

	if tr.Fraction > 0.05 or HAND_DRAGGING then return end

	local ent = tr.Entity
	if IsValid(ent) and octolib.use.classes[ent:GetClass()] then
		return icon, 255, 0.3
	end

end)
