local meta = FindMetaTable('Player')

function meta:hungerUpdate()

	if not IsValid(self) then return end
	if not GAMEMODE.Config.hungerspeed then return end

	local energy = self:GetNetVar('Energy')
	local override = hook.Call('hungerUpdate', nil, self, energy)
	if override then
		return self:MoveModifier('hunger', nil)
	end

	energy = energy and math.Clamp(energy - GAMEMODE.Config.hungerspeed, 0, 100) or 100
	self:SetHunger(energy)

	if energy < 20 and math.random(2) == 2 then
		self:EmitSound('dbg/hunger' .. math.random(4) .. '.ogg', 64, math.random(90,110), 0.5)
	end

	local h = self:Health()
	if not self.bleeding and energy > 90 and h < 100 then
		self:SetHealth(h + 1)
	end

end

function meta:IsHungry()
	return (self:GetNetVar('Energy') or 100) <= 20
end

function meta:SetHunger(val)

	local prev = self:GetNetVar('Energy')
	self:SetLocalVar('Energy', val)

	if self.SaveCharState and math.floor(prev) ~= math.floor(val) then
		self:SaveCharState()
	end

	-- if val == 0 and self:Health() > 20 then
	-- 	self:SetHealth(self:Health() - GAMEMODE.Config.starverate)
	-- 	if self:Health() <= 0 then
	-- 		self.Slayed = true
	-- 		self.HungerDeath = true
	-- 		self:Kill()
	-- 		timer.Simple(1, function()
	-- 			self.HungerDeath = nil
	-- 		end)
	-- 	end
	-- end

	if val <= 20 and not self:GetMoveModifier('hunger') then
		self:MoveModifier('hunger', {
			norun = true,
			nojump = true,
		})
		self:Notify('Ты проголодался, пора перекусить')
	elseif val > 20 and self:GetMoveModifier('hunger') then
		self:MoveModifier('hunger', nil)
	end

end

hook.Add('octoinv.craft', 'DarkRP.Hunger', function(ply, ent, bpID, cont)

	if cont.id == 'workbench' and ply:IsHungry() then
		ply:Notify('warning', 'Ты слишком голоден, нужно что-то съесть')
		return true
	end

end)
