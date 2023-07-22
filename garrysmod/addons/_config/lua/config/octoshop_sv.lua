--
-- SERVER
--

octoshop.server_id = 'dbg'
octoshop.server_name = 'Доброград'

--
-- COUPONS
--

octoshop.couponLength = 48 -- max: 64
octoshop.couponUseDelay = 45 -- seconds

--
-- SALARY
--

octoshop.salaryAmount = {
	trainee = 1,
	admin = 2,
	tadmin = 3,
	sadmin = 4,
	superadmin = 5,
	founder = 5,

	contentmanager = 5,
	rpmanager = 5,
	projectmanager = 5,
	dev = 5,

	quenter = 1,
	squenter = 1,
	gamemaster = 1,
	sgamemaster = 2,
}
octoshop.hackCallback = function(ply, t)

	-- notifyAdmins(ply:SteamName() .. ' (' .. ply:SteamID() .. ') пытается обмануть нас на Доброграде: ' .. t)
	-- ply:Ban(1440, true)

end

--
-- FUNCTIONS
--

octoshop.notify = octolib.notify.send
octoshop.notifyAll = octolib.notify.sendAll
