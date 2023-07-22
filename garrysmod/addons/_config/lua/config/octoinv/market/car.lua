octoinv.registerMarketItem('cat_cars', {
	name = L.to_car,
	icon = 'octoteam/icons/car2.png',
})

octoinv.registerMarketItem('car_rims', {
	parent = 'cat_cars',
	name = 'Диски',
	nostack = true,
})

octoinv.registerMarketItem('car_att', {
	parent = 'cat_cars',
	name = 'Аксессуары',
	icon = 'octoteam/icons/bust.png',
	nostack = true,
})

octoinv.registerMarketItem('car_part', {
	parent = 'cat_cars',
	name = 'Детали кузова',
	nostack = true,
})
