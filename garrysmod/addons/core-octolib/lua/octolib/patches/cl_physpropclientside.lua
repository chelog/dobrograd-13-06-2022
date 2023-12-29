hook.Add('OnEntityCreated', 'octolib.physpropclientside', function(ent)

	if ent:GetClass() == 'class C_PhysPropClientside' then
		timer.Simple(10, function()
			for _, v in ipairs(ents.GetAll()) do
				if v:GetClass() == 'class C_PhysPropClientside' then
					v:Remove()
				end
			end
		end)
	end

end)
