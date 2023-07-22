AddCSLuaFile 'cl_init.lua'
AddCSLuaFile 'shared.lua'

include 'shared.lua'

function ENT:Initialize()

	self:SetModel('models/props/de_tides/vending_cart.mdl')
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetUseType(SIMPLE_USE)

end

function ENT:Use(ply)

	if not ply:Alive() or not ply.inv or not ply.inv.conts._hand then
		ply:Notify('warning', L.hands_free)
		return
	end

	if ply:GetDBVar('gotBDayCap') then
		ply:Notify('warning', L.you_received_cap)
		return
	end

	ply:SetDBVar('gotBDayCap', true)
	ply.inv.conts._hand:AddItem('h_mask', {
		name = L.cap_dobrograd,
		icon = 'octoteam/icons/clothes_cap.png',
		desc = L.cap_dobrograd_desc,
		mask = 'cap_dobrograd',
	})

	ply:Notify(L.bday_desc)
	timer.Simple(2, function()
		ply:Notify('hint', 'Хей, парниша, не хочешь получить НАСТОЯЩУЮ кепку патриота? Тогда участвуй в нашем конкурсе!')
		ply:Notify('hint', 'Подробности в нашем сообществе VK: ', {'https://vk.com/octoteam'})
	end)

end
