properties.Add('givemoney', {
	MenuLabel = L.c_language_money,
	Order = 1,
	MenuIcon = octolib.icons.silk16('money'),
	Filter = function(self, ent, ply)
		return IsValid(ent) and ent:IsPlayer() and ply:GetPos():Distance(ent:GetPos()) < 200
		and not ent:GetNetVar('Ghost') and not ply:GetNetVar('Ghost')
	end,
	Action = function(self, ent)
		Derma_StringRequest(L.c_language_money, L.c_language_money_description, nil, function(a)
			if not tonumber(a) then return end
			self:MsgStart()
				net.WriteEntity(ent)
				net.WriteInt(math.floor(tonumber(a)), 20)
			self:MsgEnd()
		end)
	end,
	Receive = function(self, length, ply)
		local ent = net.ReadEntity()
		local amount = net.ReadInt(20)
		if (amount or 0) <= 0 then return end
		if not self:Filter(ent, ply) then return end

		if not ply:canAfford(amount) then
			return ply:Notify('warning', 'У тебя нет столько денег')
		end

		ply:DoAnimationEvent(ACT_GMOD_GESTURE_ITEM_GIVE)

		ply:addMoney(-amount)
		ply:Notify(L.you_gave:format(ent:Name(), DarkRP.formatMoney(amount)))

		timer.Simple(1.2, function()
			if not IsValid(ply) or not IsValid(ent) then return end

			ent:addMoney(amount)
			ent:Notify(L.has_given:format(ply:Name(), DarkRP.formatMoney(amount)))
		end)

		hook.Run('DarkRP.payPlayer', ply, ent, amount or 1)

	end
})

properties.Add('showhand', {
	MenuLabel = L.show_hand,
	Order = 2,
	MenuIcon = octolib.icons.silk16('briefcase'),
	Filter = function(self, ent, ply)
		local hasHand = CLIENT or tobool(ply.inv:GetContainer('_hand'))
		return IsValid(ent) and ent:IsPlayer() and
			not ent:GetNetVar('Ghost') and not ply:GetNetVar('Ghost') and
			hasHand and ent:GetPos():DistToSqr(ply:GetPos()) < 15000
	end,
	Action = function(self, ent)
		self:MsgStart()
			net.WriteEntity(ent)
		self:MsgEnd()
	end,
	Receive = function(self, length, ply)
		local ent = net.ReadEntity()
		if not self:Filter(ent, ply) then return end

		ply:DoAnimation(ACT_GMOD_GESTURE_ITEM_PLACE)
		ent:OpenInventory(ply.inv, {'_hand'})
	end
})
