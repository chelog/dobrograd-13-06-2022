local pmeta = FindMetaTable 'Player'
function pmeta:ChangePhysgunColor(col)
	if not IsColor(col) then return end

	self.changePGCol = self.changePGCol or octolib.func.debounceStart(function(col)
		if not IsColor(col) then return end
		col.a = 255
		if col.r == 0 and col.g == 0 and col.b == 0 then
			col = Color(1,1,1) -- tried to make an invisible beam
		end
		if IsValid(self) then
			if not self:GetNetVar('os_build') then
				return self:Notify('warning', 'Смена цвета физгана доступна только Строителям')
			end
			self:SetNetVar('physgunColor', col)
		end
	end, 0.5)

	self.changePGCol(col)

end

netstream.Hook('dbg-physguns.changeColor', pmeta.ChangePhysgunColor)
hook.Add('dbg-char.spawn', 'dbg-physguns', function(ply)
	timer.Simple(3, function()
		if not IsValid(ply) then return end
		if not ply:GetNetVar('os_build') then return end
		ply:GetClientVar({'physgunColor'}, function(vars)
			if not istable(vars.physgunColor) then return end
			local col = Color(vars.physgunColor.r or 0, vars.physgunColor.g or 161, vars.physgunColor.b or 255)
			if col == Color(0,161,255) then return end
			ply:ChangePhysgunColor(col)
		end)
	end)
end)
