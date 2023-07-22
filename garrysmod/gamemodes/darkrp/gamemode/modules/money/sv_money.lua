/*---------------------------------------------------------------------------
functions
---------------------------------------------------------------------------*/
local meta = FindMetaTable('Player')
function meta:addMoney(amount)
	if not amount then return false end
	if not IsValid(self) then return end
	if not self.inv then
		self:SetLocalVar('money', 0)
		if amount > 0 then
			timer.Simple(1, function()
				self:addMoney(amount)
			end)
		end
		return
	end

	local given
	if amount > 0 then
		given = self:AddItem('money', math.floor(amount))
	elseif amount < 0 then
		given = self:TakeItem('money', math.floor(-amount))
	else
		self:SetLocalVar('money', self:HasItem('money') or 0)
		return
	end

	local total = self:HasItem('money') or 0
	hook.Call('playerWalletChanged', GAMEMODE, self, amount, self:GetNetVar('money'))

	self:SetLocalVar('money', total)

	if amount > 0 and given < amount then
		local toDrop = amount - given
		for contID, cont in pairs(self.inv.conts) do
			cont:DropNewItem('money', {amount = toDrop})
			self:Notify('warning', DarkRP.formatMoney(toDrop), L.didnt_fit)
			break
		end
	end

	return given
end

hook.Add('octoinv.dropped', 'DarkRP.money', function(cont, item, ent)

	if not item or item.class ~= 'money' then return end

	local ply = cont.inv.owner
	timer.Simple(0, function() -- wait for item amount to be updated
		if not IsValid(ply) or not ply:IsPlayer() then return end
		ply:addMoney(0)
	end)

end)

hook.Add('octoinv.added', 'DarkRP.money', function(cont, item, amount)

	if not item or item.class ~= 'money' then return end

	local ply = cont.inv.owner
	if IsValid(cont.inv.owner) and cont.inv.owner:IsPlayer() then
		ply:addMoney(0)
	end

end)

hook.Add('octoinv.taken', 'DarkRP.money', function(cont, item, amount)

	if not item or item.class ~= 'money' then return end

	local ply = cont.inv.owner
	if IsValid(cont.inv.owner) and cont.inv.owner:IsPlayer() then
		ply:addMoney(0)
	end

end)

local function death(ply)

	timer.Simple(0, function()
		ply:addMoney(0)
	end)

end
hook.Add('PlayerDeath', 'DarkRP.money', death)
hook.Add('PlayerSilentDeath', 'DarkRP.money', death)

function DarkRP.payPlayer(ply1, ply2, amount)
	if not IsValid(ply1) or not IsValid(ply2) then return end
	ply1:addMoney(-amount)
	ply2:addMoney(amount)

	hook.Run('DarkRP.payPlayer', ply1, ply2, amount or 1)
end

function meta:payDay()
	if not IsValid(self) then return end
	if not self:isArrested() then
		if self:GetKarma() <= -25 then
			-- self:Notify('warning', 'У тебя слишком низкая карма для получения зарплаты')
			return
		end

		-- if self:IsAFK() then return end

		local amount = math.floor(self:Salary())
		local suppress, message, hookAmount = hook.Call('playerGetSalary', GAMEMODE, self, amount)
		amount = hookAmount or amount

		local bonus = 0
		if self:GetKarma() >= 200 then
			bonus = math.floor(amount)
		elseif self:GetKarma() >= 50 then
			bonus = math.floor(amount * 0.5)
		elseif self:GetKarma() > 20 then
			bonus = math.floor(amount * 0.2)
		end

		if amount < 0 or not amount or self:getJobTable().hobo then
			if not suppress then self:Notify('ooc', message or L.payday_unemployed) end
		else
			self:addMoney(amount + bonus)
			local text = message or L.payday_message:format(DarkRP.formatMoney(amount))
			if bonus > 0 then text = L.bonus_salary:format(text, DarkRP.formatMoney(bonus)) end
			if not suppress then self:Notify('hint', text) end
		end
	else
		self:Notify('warning', L.payday_missed)
	end
end

function DarkRP.createMoneyBag(pos, amount, ply)
	ent = ents.Create 'octoinv_item'
	ent:SetPos(pos)
	ent:SetData('money', math.Min(amount, 2147483647))
	ent.Model = 'models/props/cs_assault/money.mdl'
	ent:Spawn()
	ent:Activate()

	local phys = ent:GetPhysicsObject()
	if IsValid(phys) then
		phys:Wake()
	end

	if ply then ply:LinkEntity(ent) end
	return ent
end
