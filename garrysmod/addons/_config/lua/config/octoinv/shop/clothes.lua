octoinv.addShopCat('clothes', {
	name = 'Одежда',
	icon = 'octoteam/icons/clothes_tshirt.png',
})

octoinv.addShopCat('accessories', {
	name = 'Аксессуары',
	icon = 'octoteam/icons/clothes_cap.png',
})

local clothes = {
	-- common
	{ 19000, 'models/humans/modern/octo/standart1_sheet', 'octoteam/icons/clothes_jacket.png', 'Костюм "Gotu"', 'Бордовая куртка с белой футболкой, черные джинсы, белые кроссовки с синими полосами по бокам' },
	{ 20000, 'models/humans/modern/octo/standart2_sheet', 'octoteam/icons/clothes_jacket.png', 'Костюм "Edward"', 'Коричневая куртка с черным свитером и белой футболкой, темно-синие джинсы с кожаным ремнем и черными ботинками' },
	{ 24500, 'models/humans/modern/octo/standart3_sheet', 'octoteam/icons/clothes_shirt.png', 'Костюм "Gentleman"', 'Синее полупальто с белой футболкой, черные штаны, коричневые ботинки' },
	{ 23000, 'models/humans/modern/octo/standart4_sheet', 'octoteam/icons/clothes_shirt.png', 'Костюм "Frant"', 'Черный пиджак с серым свитером, серые джинсы, черные туфли' },
	{ 14500, 'models/humans/modern/octo/standart5_sheet', 'octoteam/icons/clothes_jumper.png', 'Зеленая рубашка', 'Зеленая рубашка с белой футболкой с длинным рукавом, серые штаны, коричневые ботинки' },
	{ 20000, 'models/humans/modern/octo/standart6_sheet', 'octoteam/icons/clothes_jacket.png', 'Кожанка "Belić"', 'Коричневая кожаная куртка с бежевой футболкой и бело-желтой олимпийкой, полуперчатки, синие штаны, белые кроссовки с синими полосками по бокам' },
	{ 20000, 'models/humans/modern/octo/standart7_sheet', 'octoteam/icons/clothes_jacket.png', 'Кожанка "Niko"', 'Черная кожаная куртка с синей рубашкой и бежевой футболкой, черные штаны, черные ботинки' },
	{ 16000, 'models/humans/modern/octo/standart8_sheet', 'octoteam/icons/clothes_jumper.png', 'Костюм "Bro3s"', 'Серая кофта с белой футболкой, штаны в раскраске "камо", коричневые ботинки' },
	{ 17500, 'models/humans/modern/octo/standart9_sheet', 'octoteam/icons/clothes_jacket.png', 'Голубая клетчатая рубашка', 'Клетчатая рубашка в голубых тонах с серой футболкой с длинными рукавами, бежевые джинсы, черные кроссовки с белым ободом ' },
	{ 17500, 'models/humans/modern/octo/standart10_sheet', 'octoteam/icons/clothes_jacket.png', 'Красная клетчатая рубашка', 'Клетчатая красная рубашка с зеленой футболкой с длинными рукавами, голубые джинсы, коричневые ботинки с белым ободом' },
	{ 26500, 'models/humans/modern/octo/standart11_sheet', 'octoteam/icons/clothes_jacket.png', 'Байкер "Wolf"', 'Коричневая куртка с белой футболкой, полуперчатки, серые джинсы, коричневые ботинки' },
	{ 28500, 'models/humans/modern/octo/standart12_sheet', 'octoteam/icons/clothes_jacket.png', 'Классический байкер', 'Черная кожаная куртка с белыми полосами, полуперчатки, синими джинсами и белыми кроссовками' },
	{ 23500, 'models/humans/modern/octo/standart13_sheet', 'octoteam/icons/clothes_jacket.png', 'Сельский байкер', 'Красная клетчатая рубашка с оранжевым жилетом и белой футболкой, серые джинсы, черные ботинки' },
	{ 23500, 'models/humans/modern/octo/standart14_sheet', 'octoteam/icons/clothes_jumper.png', 'Степной байкер', 'Зеленая клетчатая рубашка с черно-бежевым жилетом и черной футболкой, черные джинсы, коричневые ботинки' },
	{ 20500, 'models/humans/modern/octo/standart15_sheet', 'octoteam/icons/clothes_jacket.png', 'Костюм "Arlo"', 'Желтая кофта с черным жилетом, голубые джинсы, черные ботинки' },
	{ 19500, 'models/humans/modern/octo/standart16_sheet', 'octoteam/icons/clothes_jumper.png', 'Джинсовый костюм', 'Джинсовая куртка с белой футболкой, голубые джинсы, коричневые ботинки' },
	{ 22500, 'models/humans/modern/octo/standart17_sheet', 'octoteam/icons/clothes_jacket.png', 'Костюм "CityLife"', 'Джинсовая куртка, серый худи, синие джинсы, белые кроссовки' },
	{ 17500, 'models/humans/modern/octo/standart18_sheet', 'octoteam/icons/clothes_jacket.png', 'Костюм "Dandy"', 'Клетчатая рубашка в синих тонах с серой футболкой с принтом, голубые джинсы, черные кроссовки' },
	{ 26000, 'models/humans/modern/octo/standart19_sheet', 'octoteam/icons/clothes_jacket.png', 'Костюм "Tommy"', 'Темно-синяя толстовка с белой футболкой, синие джинсы, черные кроссовки' },
	{ 17500, 'models/humans/modern/octo/standart20_sheet', 'octoteam/icons/clothes_jacket.png', 'Голубая поло', 'Голубая рубашка поло, черные джинсы, черные ботинки' },
	{ 21000, 'models/humans/modern/octo/standart21_sheet', 'octoteam/icons/clothes_jacket.png', 'Костюм "Retro"', 'Бирюзовая олимпийка с зеленой рубашкой поло, голубые джинсы, черные ботинки' },
	{ 20500, 'models/humans/modern/octo/standart22_sheet', 'octoteam/icons/clothes_jacket.png', 'Худи "Polo"', 'Серая толстовка с принтом, черные джинсы, коричневые ботинки' },
	{ 20000, 'models/humans/modern/octo/standart23_sheet', 'octoteam/icons/clothes_jumper.png', 'Худи "Nike SB"', 'Черный худи с принтом, синие джинсы, черные кроссовки' },
	{ 17500, 'models/humans/modern/octo/sport1_sheet', 'octoteam/icons/clothes_jumper.png', 'Худи "In The Hood"', 'Черная кофта с белой футболкой, черные штаны, черные кроссовки' },
	{ 20000, 'models/humans/modern/octo/sport2_sheet', 'octoteam/icons/clothes_tshirt.png', 'Зеленый спортивный костюм', 'Черно-зеленая куртка с белой футболкой, черные штаны, черные кроссовки' },
	{ 21500, 'models/humans/modern/octo/sport3_sheet', 'octoteam/icons/clothes_tshirt.png', 'Красный спортивный костюм', 'Черно-оранжевая куртка с белой футболкой, голубые джинсы, белые кроссовки' },
	{ 15500, 'models/humans/modern/octo/sport4_sheet', 'octoteam/icons/clothes_tshirt.png', 'Костюм "Jordan"', 'Белая кофта с символикой Jordan в центре и черной футболкой, темные брюки, оранжевые кроссовки' },
	{ 18500, 'models/humans/modern/octo/sport5_sheet', 'octoteam/icons/clothes_jumper.png', 'Худи "Banana"', 'Голубая кофта с изображением банана в центре и белой футболкой, коричневые штаны, белые кроссовки' },
	{ 23500, 'models/humans/modern/octo/sport6_sheet', 'octoteam/icons/clothes_tshirt.png', 'Черный спортивный костюм', 'Черная куртка с белыми полосами на руках и белой футболкой, черные штаны, черные кроссовки' },
	{ 22500, 'models/humans/modern/octo/sport7_sheet', 'octoteam/icons/clothes_tshirt.png', 'Синий спортивный костюм', 'Голубая куртка с белой футболкой, голубые штаны, черные кроссовки' },
	{ 20500, 'models/humans/modern/octo/sport8_sheet', 'octoteam/icons/clothes_jumper.png', 'Костюм "Marce"', 'Серая толстовка с белой футболкой, черные брюки, черные кроссовки' },
	{ 22000, 'models/humans/modern/octo/sport9_sheet', 'octoteam/icons/clothes_tshirt.png', 'Синий костюм Adidas', 'Сине-голубая куртка с белой футболкой, темно-синие штаны, белые кроссовки' },
	{ 24000, 'models/humans/modern/octo/sport10_sheet', 'octoteam/icons/clothes_tshirt.png', 'Зеленый костюм Adidas', 'Черно-зеленая куртка с белой футболкой, черные штаны, белые кроссовки' },
	{ 19000, 'models/humans/modern/octo/sport11_sheet', 'octoteam/icons/clothes_tshirt.png', 'Красный костюм Adidas', 'Красный спортивный костюм, белые кроссовки' },
	{ 20000, 'models/humans/modern/octo/sport12_sheet', 'octoteam/icons/clothes_tshirt.png', 'Костюм "Kappa"', 'Черный спортивный костюм с принтами по бокам, белые кроссовки' },
	{ 23500, 'models/humans/modern/octo/sport13_sheet', 'octoteam/icons/clothes_tshirt.png', 'Зеленый костюм Nike', 'Зелено-серая куртка, белая футболка с принтом, зеленые штаны, белые кроссовки' },
	{ 25000, 'models/humans/modern/octo/sport14_sheet', 'octoteam/icons/clothes_tshirt.png', 'Черный костюм Nike', 'Черно-серая куртка, черная футболка с принтом, черные штаны, белые кроссовки' },
	{ 70000, 'models/humans/modern/octo/suit1_sheet', 'octoteam/icons/clothes_coat.png', 'Костюм "D\'Anglere"', 'Синий деловой костюм в полосочку с белой рубашкой, красным галстуком и черными туфлями' },
	{ 60000, 'models/humans/modern/octo/suit2_sheet', 'octoteam/icons/clothes_coat.png', 'Черный деловой костюм', 'Черный деловой костюм с белой рубашкой, черным галстуком и черными туфлями' },
	{ 80000, 'models/humans/modern/octo/suit3_sheet', 'octoteam/icons/clothes_coat.png', 'Белый деловой костюм', 'Белый деловой костюм с черной рубашкой, желтым галстуком и черными туфлями' },
	{ 65000, 'models/humans/modern/octo/suit4_sheet', 'octoteam/icons/clothes_coat.png', 'Серый деловой костюм', 'Серый деловой костюм с голубой рубашкой, желтым галстуком и серыми туфлями' },
	{ 75000, 'models/humans/modern/octo/suit5_sheet', 'octoteam/icons/clothes_coat.png', 'Зеленый деловой костюм', 'Зеленый деловой костюм с белой рубашкой, зеленым галстуком и черными туфлями' },
	{ 72000, 'models/humans/modern/octo/suit6_sheet', 'octoteam/icons/clothes_coat.png', 'Голубой деловой костюм', 'Голубой деловой костюм с красной рубашкой, синим галстуком и коричневыми туфлями' },
	{ 45000, 'models/humans/modern/octo/suit7_sheet', 'octoteam/icons/clothes_coat.png', 'Черный пиджак', 'Черный пиджак с белой рубашкой, черные брюки и черные туфли' },
	{ 47000, 'models/humans/modern/octo/suit8_sheet', 'octoteam/icons/clothes_coat.png', 'Синий пиджак', 'Синий пиджак с белой рубашкой, синие брюки и черные туфли' },
}

for i, data in ipairs(clothes) do
	local price, mat, icon, name, desc = unpack(data)
	octoinv.addShopItem('clothes' .. i, {
		cat = 'clothes',
		name = name,
		desc = desc,
		plyMat = mat,
		icon = icon,
		item = 'clothes_custom',
		price = price,
		data = {
			name = name,
			desc = desc,
			icon = icon,
			mat = mat,
			mass = 1.5,
			volume = 5,
		},
	})
end

for class, data in pairs(CFG.masks) do
	if not data.price then continue end
	octoinv.addShopItem(class, {
		cat = 'accessories',
		name = data.name,
		desc = data.desc,
		skin = data.skin,
		item = 'h_mask',
		icon = data.icon,
		price = data.price,
		data = {
			name = data.name,
			icon = data.icon,
			model = data.mdl,
			mask = class,
			mass = 0.3,
			volume = 0.3,
		},
	})
end

local forbiddenSubmats = {}
for _, data in ipairs(clothes) do forbiddenSubmats[data[2]] = true end
hook.Add('submaterial.canUseOnPlayer', 'dbg-clothes', function(ply, target, mat)
	if forbiddenSubmats[mat] and not ply:IsAdmin() then return false end
end)
