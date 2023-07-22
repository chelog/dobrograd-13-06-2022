--
-- CONVARD
--
simpleOrgs.addOrg('convard', {
	name = 'ConVard HotDogs',
	title = '',
	shortTitle = '',
	secret = true,
	owners = {},
})

-- carDealer.addCategory('convard', {
-- 	name = 'ConVard',
-- 	icon = 'octoteam/icons-16/hamburger.png',
-- 	doNotEvacuate = true,
-- 	canUse = function(ply)
-- 		if not ply:IsOrgMember('convard') then
-- 			return false, 'Доступно только для ConVard HotDogs'
-- 		end
-- 	end,
-- })

-- carDealer.addVeh('convard_hotdog', {
-- 	name = 'HotDog',
-- 	simfphysID = 'simfphys_gta_sa_hotdog',
-- 	price = 0,
-- 	deposit = true,
-- })