AddCSLuaFile "cl_init.lua"
AddCSLuaFile "shared.lua"

include "shared.lua"

octoinv.registerLoot(70, {
	mode = 'christmas',
	item = {'food', {
		name = L.cookie,
		energy = 15,
		icon = 'octoteam/icons/food_cookies.png',
		mass = 0.15,
		volume = 0.15,
		-- amount = 5,
	}},
})

octoinv.registerLoot(50, {
	mode = 'christmas',
	item = {'food', {
		name = 'Леденец',
		desc = '',
		energy = 25,
		icon = 'octoteam/icons/food_candy.png',
		mass = 0.2,
		volume = 0.2,
		-- amount = 3,
	}},
})

octoinv.registerLoot(4, {
	mode = 'christmas',
	item = {'h_mask', {
		name = L.mask_gingerbread,
		mask = 'gingerbread',
	}},
})

octoinv.registerLoot(4, {
	mode = 'christmas',
	item = {'h_mask', {
		name = 'Новогодний колпак',
		icon = 'octoteam/icons/xmas_hat.png',
		mask = 'santa',
	}},
})

octoinv.registerLoot(1, {
	mode = 'christmas',
	item = {'car_att', {
		name = 'Снеговичок',
		att = 'snowman',
		desc = 'Немного рождества на приборной панели твоего авто!',
	}},
})

local perDay, resetTime, interval = 2, 23*60*60, 3*60
local function checkTreat(ply)

	local amount, resetAfter = unpack(ply:GetDBVar('nyCache') or { perDay, os.time() + resetTime })
	if amount <= 0 and os.time() > resetAfter then
		amount = perDay
		ply:SetDBVar('nyCache', { amount, resetAfter })
	end

	return amount > 0

end

local function takeTreat(ply)

	local amount, resetAfter = unpack(ply:GetDBVar('nyCache') or { perDay, os.time() + resetTime })
	amount = amount - 1
	if amount <= 0 then
		resetAfter = os.time() + resetTime
	end

	ply:SetDBVar('nyCache', { amount, resetAfter })

end

local function canMoveIn()
	return false, ''
end

local pmeta = FindMetaTable('Player')

function pmeta:RandomXMasTreat(prevent)

	local box = table.Random(ents.FindByClass('ent_dbg_xmas_box'))
	if not IsValid(box) then return end

	local sID = self:SteamID()
	local inv = box:GetInventory()
	local cont = inv:GetContainer(sID) or inv:AddContainer(sID, {name = 'Подарок', volume = 250, icon = octolib.icons.color('gift_xmas')}):Hook('canMoveIn', 'xmasbox', canMoveIn)
	if self:GetKarma() < 0 and math.random(2) == 1 then
		cont:AddItem('souvenir', {
			name = 'Уголек',
			icon = 'octoteam/icons/coal.png',
			desc = 'Существует древняя традиция, согласно которой Санта Клаус оставляет непослушным детям уголек вместо подарка',
		})
	else
		local item = octoinv.getRandomLoot({
			flatten = math.Clamp(self:GetKarma() or 0, -1000, 1000) / 1000,
			mode = 'christmas',
		}).item
		cont:AddItem(unpack(item))
	end

	self:Notify('hint', 'Санта положил тебе подарок под елочку, забирай скорей!')
	self:AddMarker {
		txt = 'Подарок',
		pos = box:GetPos() + Vector(0,0,12),
		col = Color(255,92,38),
		des = {'dist', { 100 }},
		icon = 'octoteam/icons-16/gift_add.png',
	}
	if not prevent then takeTreat(self) end

end

timer.Create('dbg-newyear.giveAway', interval, 0, function()

	if player.GetCount() < 10 or math.random(2) ~= 1 then return end

	local plys = octolib.array.filter(player.GetAll(), function(ply) return not ply:IsAFK() and checkTreat(ply) end)
	if #plys >= 1 then table.Random(plys):RandomXMasTreat() end

end)

timer.Simple(10, function()
	math.randomseed(os.time())
	for _,v in ipairs(ents.FindByClass('ent_dbg_xmas_box')) do
		v:SetSkin(math.random(0, 5))
	end
end)

function ENT:Initialize()

	self:SetModel('models/brewstersmodels/christmas/present1_large.mdl')
	self:SetSkin(math.random(0, 5))
	self:SetModelScale(2.5)

	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)

	self.inv = self:CreateInventory()

end

function ENT:Use(ply, caller)

	if not ply:IsPlayer() then return end
	if not ply:CanUseInventory(self.inv) then return end

	local contID = ply:SteamID()
	local cont = self.inv:GetContainer(contID)
	if not cont then return end

	ply:DoAnimation(ACT_GMOD_GESTURE_ITEM_PLACE)
	timer.Simple(0.5, function()
		if not IsValid(self) then return end
		ply:OpenInventory(self.inv, { contID })
	end)

end

function ENT:Think()

	for contID, cont in pairs(self.inv.conts) do
		if cont.volume == cont:FreeSpace() then
			cont:Remove()
		end
	end

	self:NextThink(CurTime() + 1)
	return true

end

