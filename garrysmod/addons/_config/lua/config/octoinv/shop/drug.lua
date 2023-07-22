--
-- CATEGORIES
--

octoinv.addShopCat('pharm', {
	name = L.pharm,
	icon = 'octoteam/icons/drug2.png',
	jobs = {'pharm', 'pharm2', 'paramedic'},
})

--
-- ITEMS
--

octoinv.addShopItem('drug_vitalex', { cat = 'pharm', price = 520 })
octoinv.addShopItem('drug_painkiller', { cat = 'pharm', price = 250 })
octoinv.addShopItem('drug_relaxant', { cat = 'pharm', price = 450 })
octoinv.addShopItem('drug_vampire', { cat = 'pharm', price = 750, jobs = {'pharm2'}})
octoinv.addShopItem('drug_dextradose', { cat = 'pharm', price = 600 })
octoinv.addShopItem('drug_roids', { cat = 'pharm', price = 450, jobs = {'pharm', 'pharm2'}})
octoinv.addShopItem('drug_bouncer', { cat = 'pharm', price = 1350, jobs = {'pharm2'}})
octoinv.addShopItem('drug_antitoxin', { cat = 'pharm', price = 150 })
octoinv.addShopItem('drug_weed', { cat = 'pharm', price = 420 })
octoinv.addShopItem('drug_pingaz', { cat = 'pharm', price = 350 , jobs = {'pharm', 'pharm2'}})
octoinv.addShopItem('drug_preserver', { cat = 'pharm', price = 3300, jobs = {'pharm2', 'paramedic'}})
-- octoinv.addShopItem('drug_meth', { cat = 'pharm', price = 1000 })
