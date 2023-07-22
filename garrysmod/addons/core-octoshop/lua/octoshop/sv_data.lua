hook.Add('octolib.db.init', 'octoshop', function()

	--
	-- CREATE COMMON TABLES
	--

	octolib.db:RunQuery([[
		CREATE TABLE IF NOT EXISTS ]] .. CFG.db.shop .. [[.octoshop_users (
			id INT(8) UNSIGNED NOT NULL AUTO_INCREMENT,
			steamID VARCHAR(30) NOT NULL,
			steamID64 VARCHAR(20) NOT NULL,
			balance INT(10) NOT NULL,
			totalTopup INT(10) NOT NULL,
			totalSpent INT(10) NOT NULL,
			totalPurchases INT(10) NOT NULL,
				PRIMARY KEY (id),
				UNIQUE (steamID)
		) ENGINE=INNODB CHARACTER SET utf8 COLLATE utf8_general_ci
	]])

	octolib.db:RunQuery([[
		CREATE TABLE IF NOT EXISTS ]] .. CFG.db.shop .. [[.octoshop_servers (
			id VARCHAR(30) NOT NULL,
			address VARCHAR(25) NOT NULL,
			name VARCHAR(80) NOT NULL,
			totalSpent INT(10) NOT NULL,
			totalPurchases INT(10) NOT NULL,
			items JSON NOT NULL,
				PRIMARY KEY (id),
				UNIQUE (address)
		) ENGINE=INNODB CHARACTER SET utf8 COLLATE utf8_general_ci
	]])

	octolib.db:RunQuery([[
		CREATE TABLE IF NOT EXISTS ]] .. CFG.db.shop .. [[.octoshop_payments (
			id INT(8) UNSIGNED NOT NULL AUTO_INCREMENT,
			userID INT(8) UNSIGNED NOT NULL,
			amount INT(10) NOT NULL,
			anonymous TINYINT(1) NOT NULL DEFAULT 0,
			timeCompleted INT(10) NOT NULL,
			PRIMARY KEY (id),
			CONSTRAINT Cons_OS_PaymentUser
				FOREIGN KEY (userID) REFERENCES ]] .. CFG.db.shop .. [[.octoshop_users(id)
				ON UPDATE CASCADE ON DELETE CASCADE
		) ENGINE=INNODB CHARACTER SET utf8 COLLATE utf8_general_ci
	]])

	octolib.db:RunQuery([[
	CREATE TABLE IF NOT EXISTS ]] .. CFG.db.shop .. [[.octoshop_purchases (
			id INT(8) UNSIGNED NOT NULL AUTO_INCREMENT,
			userID INT(8) UNSIGNED NOT NULL,
			serverID VARCHAR(30) NOT NULL,
			itemID INT(8) UNSIGNED NOT NULL,
			itemClass VARCHAR(30) NOT NULL,
			price INT(10) NOT NULL,
			timeCompleted INT(10) NOT NULL,
				PRIMARY KEY (id),
			CONSTRAINT Cons_OS_PurchaseServer
				FOREIGN KEY (serverID) REFERENCES ]] .. CFG.db.shop .. [[.octoshop_servers(id)
				ON UPDATE CASCADE ON DELETE CASCADE,
			CONSTRAINT Cons_OS_PurchaseUser
				FOREIGN KEY (userID) REFERENCES ]] .. CFG.db.shop .. [[.octoshop_users(id)
				ON UPDATE CASCADE ON DELETE CASCADE
		) ENGINE=INNODB CHARACTER SET utf8 COLLATE utf8_general_ci
	]])

	--
	-- CREATE SERVER DATA
	--

	octolib.db:RunQuery([[
		CREATE TABLE IF NOT EXISTS ]] .. CFG.db.shop .. [[.items_]] .. octoshop.server_id .. [[ (
			id INT(8) UNSIGNED NOT NULL AUTO_INCREMENT,
			userID INT(8) UNSIGNED NOT NULL,
			itemName VARCHAR(255) NOT NULL,
			itemClass VARCHAR(30) NOT NULL,
			data TEXT,
				PRIMARY KEY (id),
			CONSTRAINT Cons_OS_Items_]] .. octoshop.server_id .. [[
				FOREIGN KEY (userID) REFERENCES ]] .. CFG.db.shop .. [[.octoshop_users(id)
				ON UPDATE CASCADE ON DELETE CASCADE
		) ENGINE=INNODB CHARACTER SET utf8 COLLATE utf8_general_ci
	]])

	octolib.db:RunQuery([[
		CREATE TABLE IF NOT EXISTS ]] .. CFG.db.shop .. [[.coupons_]] .. octoshop.server_id .. [[ (
			code VARCHAR(64) NOT NULL,
			reward VARCHAR(255) NOT NULL,
			userID INT(8) UNSIGNED,
			timeUsed INT(10),
				PRIMARY KEY(code),
			CONSTRAINT Cons_OS_CouponUser_]] .. octoshop.server_id .. [[
				FOREIGN KEY (userID) REFERENCES ]] .. CFG.db.shop .. [[.octoshop_users(id)
				ON UPDATE CASCADE ON DELETE CASCADE
		) ENGINE=INNODB CHARACTER SET utf8 COLLATE utf8_general_ci
	]])

	-- octolib.db:PrepareQuery([[
	-- 	SELECT name FROM ]] .. CFG.db.shop .. [[.octoshop_servers
	-- 	WHERE id = ?
	-- ]], {
	-- 	octoshop.server_id,
	-- }, function(q, st, data)
	-- 	data = istable(data) and data[1]
	-- 	if data then
	-- 		octoshop.msg('DATABASE: Server ' .. data.name .. ' loaded.')
	-- 		octolib.db:PrepareQuery([[
	-- 			UPDATE ]] .. CFG.db.shop .. [[.octoshop_servers
	-- 			SET address = ?, name = ?
	-- 			WHERE id = ?
	-- 		]], {
	-- 			game.GetIPAddress(),
	-- 			octoshop.server_name,
	-- 			octoshop.server_id,
	-- 		})
	-- 	else
	-- 		octoshop.msg('DATABASE: New server, setting up...')
	-- 		octolib.db:PrepareQuery([[
	-- 			INSERT INTO ]] .. CFG.db.shop .. [[.octoshop_servers (id, address, name, totalSpent, totalPurchases, items)
	-- 			VALUES (?, ?, ?, 0, 0, 'null')
	-- 		]], {
	-- 			octoshop.server_id,
	-- 			game.GetIPAddress(),
	-- 			octoshop.server_name,
	-- 		})
	-- 	end
	-- end)

	local items = {}
	for class, item in pairs(octoshop.items) do
		table.insert(items, {
			class = class,
			name = item.name,
			desc = item.desc,
			price = item.price,
			order = item.order,
			icon = item.icon,
			hidden = item.hidden,
			attributes = item.attributes,
		})
	end

	octolib.db:PrepareQuery([[
		UPDATE ]] .. CFG.db.shop .. [[.octoshop_servers
			SET items = ?
			WHERE id = ?
	]], {
		util.TableToJSON(items),
		octoshop.server_id,
	})

end)
