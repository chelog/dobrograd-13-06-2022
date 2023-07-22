local function PlayerPickup( ply, ent )
	if (ent:GetClass():lower() == 'gmod_sent_vehicle_fphysics_wheel') then
		return false
	end
end
hook.Add( 'GravGunPickupAllowed', 'disableWheelPickup', PlayerPickup )

properties.Add('evacuation', {
	MenuLabel = 'Эвакуация авто',
	Order = 750,
	MenuIcon = octolib.icons.silk16('evacuator'),
	Action = octolib.func.zero,

	Filter = function(_, ent, ply)
		if not IsValid(ent) or ent:GetClass() ~= 'gmod_sent_vehicle_fphysics_base' then return false end
		if not ply:query('DBG: Эвакуировать автомобили') then return false end
		return true
	end,

	MenuOpen = function(self, option, ent)
		local submenu = option:AddSubMenu()
		submenu:AddOption('Отключить', function() self:Turn(ent, false) end):SetIcon(octolib.icons.silk16('lightbulb_off'))
		submenu:AddOption('Включить', function() self:Turn(ent, true) end):SetIcon(octolib.icons.silk16('lightbulb'))
	end,

	Turn = function(self, ent, state)
		self:MsgStart()
		net.WriteEntity(ent)
		net.WriteBool(state)
		self:MsgEnd()
	end,

	Receive = function(self, _, ply)

		local ent = net.ReadEntity()
		if not (IsValid(ply) and IsValid(ent) and self:Filter(ent, ply)) then return false end

		local state = net.ReadBool()
		ent.doNotEvacuate = not state or nil
		ent.idleScore = state and 0 or nil

		if state then
			ply:Notify('ooc', 'Теперь этот автомобиль будет эвакуирован, если будет долго находиться на месте. Таймер эвакуатора сброшен')
		else
			ply:Notify('ooc', 'Теперь этот автомобиль не будет эвакуирован (полиция или владелец автомобиля все равно могут инициировать эвакуацию)')
		end

		return true
	end,
})
