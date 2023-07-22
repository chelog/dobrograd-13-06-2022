--[[
	mysql - 1.0.0
	A simple MySQL wrapper for Garry's Mod.

	Alexander Grist-Hucker
	http://www.alexgrist.com
--]]

--- ## Serverside
-- Handles SQL module selection, SQL queries.
-- @module serverguard.mysql

serverguard.mysql = serverguard.mysql or {};

local QueueTable = {};
local Module = "mysqloo";

local type = type;
local tostring = tostring;
local table = table;

--[[
	Phrases
--]]

local MODULE_NOT_EXIST = "[mysql] The %s module does not exist!\n";

--- Query class object that holds information about the current query being built.
-- @type QUERY_CLASS
local QUERY_CLASS = {};
QUERY_CLASS.__index = QUERY_CLASS;

--- **This is called internally, use the corresponding methods.**
-- Creates a new query object.
-- @string tableName The name of the table to manipulate.
-- @string queryType The type of query to start building. (i.e CREATE, UPDATE, INSERT, etc.)
function QUERY_CLASS:New(tableName, queryType)
	local newObject = setmetatable({}, QUERY_CLASS);
		newObject.queryType = queryType;
		newObject.tableName = tableName;
		newObject.selectList = {};
		newObject.insertList = {};
		newObject.updateList = {};
		newObject.createList = {};
		newObject.whereList = {};
		newObject.orderByList = {};
	return newObject;
end;

--- Escapes the given string.
-- @string text The string to escape.
-- @treturn string The escaped string.
function QUERY_CLASS:Escape(text)
	return serverguard.mysql:Escape(tostring(text));
end;

function QUERY_CLASS:ForTable(tableName)
	self.tableName = tableName;
end;

--- Adds a WHERE clause to the SQL query. Analagous to WhereEqual.
-- @string key The key to compare.
-- @string value The value to compare to.
function QUERY_CLASS:Where(key, value)
	self:WhereEqual(key, value);
end;

--- Adds a "WHERE `column` = value" clause to the query.
-- You can use multiple of these statements to compare more than one column.
-- @string key The column to compare.
-- @string value The value to compare with.
function QUERY_CLASS:WhereEqual(key, value)
	self.whereList[#self.whereList + 1] = "`"..key.."` = "..self:Escape(value);
end;

--- Adds a "WHERE `column` != value" clause to the query.
-- You can use multiple of these statements to compare more than one column.
-- @string key The column to compare.
-- @string value The value to compare with.
function QUERY_CLASS:WhereNotEqual(key, value)
	self.whereList[#self.whereList + 1] = "`"..key.."` != "..self:Escape(value);
end;

--- Adds a "WHERE `column` LIKE value" clause to the query.
-- You can use multiple of these statements to compare more than one column.
-- @string key The column to compare.
-- @string value The value to compare with.
function QUERY_CLASS:WhereLike(key, value)
	self.whereList[#self.whereList + 1] = "`"..key.."` LIKE "..self:Escape(value);
end;

--- Adds a "WHERE `column` NOT LIKE value" clause to the query.
-- You can use multiple of these statements to compare more than one column.
-- @string key The column to compare.
-- @string value The value to compare with.
function QUERY_CLASS:WhereNotLike(key, value)
	self.whereList[#self.whereList + 1] = "`"..key.."` NOT LIKE "..self:Escape(value);
end;

--- Adds a "WHERE `column` > value" clause to the query.
-- You can use multiple of these statements to compare more than one column.
-- @string key The column to compare.
-- @string value The value to compare with.
function QUERY_CLASS:WhereGT(key, value)
	self.whereList[#self.whereList + 1] = "`"..key.."` > "..self:Escape(value);
end;

--- Adds a "WHERE `column` < value" clause to the query.
-- You can use multiple of these statements to compare more than one column.
-- @string key The column to compare.
-- @string value The value to compare with.
function QUERY_CLASS:WhereLT(key, value)
	self.whereList[#self.whereList + 1] = "`"..key.."` < "..self:Escape(value);
end;

--- Adds a "WHERE `column` >= value" clause to the query.
-- You can use multiple of these statements to compare more than one column.
-- @string key The column to compare.
-- @string value The value to compare with.
function QUERY_CLASS:WhereGTE(key, value)
	self.whereList[#self.whereList + 1] = "`"..key.."` >= "..self:Escape(value);
end;

--- Adds a "WHERE `column` <= value" clause to the query.
-- You can use multiple of these statements to compare more than one column.
-- @string key The column to compare.
-- @string value The value to compare with.
function QUERY_CLASS:WhereLTE(key, value)
	self.whereList[#self.whereList + 1] = "`"..key.."` <= "..self:Escape(value);
end;

--- Adds a "ORDER BY `column` DESC" clause to the query.
-- You can use multiple of these statements to sort by more than one column.
-- @string key The column to sort.
function QUERY_CLASS:OrderByDesc(key)
	self.orderByList[#self.orderByList + 1] = "`"..key.."` DESC";
end;

--- Adds a "ORDER BY `column` ASC" clause to the query.
-- You can use multiple of these statements to sort by more than one column.
-- @string key The column to sort.
function QUERY_CLASS:OrderByAsc(key)
	self.orderByList[#self.orderByList + 1] = "`"..key.."` ASC";
end;

--- Sets the function to be called when the query finishes.
-- @func queryCallback The callback function to execute.
function QUERY_CLASS:Callback(queryCallback)
	self.callback = queryCallback;
end;

--- Adds a "SELECT `column` FROM" clause to the query.
-- You can use multiple of these statements to select more than one column.
-- @string fieldName The column to select.
function QUERY_CLASS:Select(fieldName)
	self.selectList[#self.selectList + 1] = "`"..fieldName.."`";
end;

--- Adds a "INSERT INTO `column` VALUES(value)" clause to the query.
-- @string key The column to insert into.
-- @string value The value to insert.
function QUERY_CLASS:Insert(key, value)
	self.insertList[#self.insertList + 1] = {"`"..key.."`", self:Escape(value)};
end;

--- Adds a "UPDATE `column` SET key=value" clause to the query.
-- @string key The column to update.
-- @string value The value to update to.
function QUERY_CLASS:Update(key, value)
	self.updateList[#self.updateList + 1] = {"`"..key.."`", self:Escape(value)};
end;

--- Populates the table create list with the given keys and values if the query is a CREATE query.
-- @string key The column to create.
-- @string value The value to set it to.
function QUERY_CLASS:Create(key, value)
	self.createList[#self.createList + 1] = {"`"..key.."`", value};
end;

--- Sets the primary key for the table.
-- @string key The primary key.
function QUERY_CLASS:PrimaryKey(key)
	self.primaryKey = "`"..key.."`";
end;

--- Adds a "LIMIT value" clause to the query.
-- @number value The value to limit the query to.
function QUERY_CLASS:Limit(value)
	self.limit = value;
end;

--- Adds a "OFFSET value" clause to the query.
-- @number value The amount to offset by.
function QUERY_CLASS:Offset(value)
	self.offset = value;
end;

local function BuildSelectQuery(queryObj)
	local queryString = {"SELECT"};

	if (type(queryObj.selectList) != "table" or #queryObj.selectList == 0) then
		queryString[#queryString + 1] = " *";
	else
		queryString[#queryString + 1] = " "..table.concat(queryObj.selectList, ", ");
	end;

	if (type(queryObj.tableName) == "string") then
		queryString[#queryString + 1] = " FROM `"..queryObj.tableName.."` ";
	else
		ErrorNoHalt("[mysql] No table name specified!\n");
		return;
	end;

	if (type(queryObj.whereList) == "table" and #queryObj.whereList > 0) then
		queryString[#queryString + 1] = " WHERE ";
		queryString[#queryString + 1] = table.concat(queryObj.whereList, " AND ");
	end;

	if (type(queryObj.orderByList) == "table" and #queryObj.orderByList > 0) then
		queryString[#queryString + 1] = " ORDER BY ";
		queryString[#queryString + 1] = table.concat(queryObj.orderByList, ", ");
	end;

	if (type(queryObj.limit) == "number") then
		queryString[#queryString + 1] = " LIMIT ";
		queryString[#queryString + 1] = queryObj.limit;
	end;

	return table.concat(queryString);
end;

local function BuildInsertQuery(queryObj)
	local queryString = {"INSERT INTO"};
	local keyList = {};
	local valueList = {};

	if (type(queryObj.tableName) == "string") then
		queryString[#queryString + 1] = " `"..queryObj.tableName.."`";
	else
		ErrorNoHalt("[mysql] No table name specified!\n");
		return;
	end;

	for i = 1, #queryObj.insertList do
		keyList[#keyList + 1] = queryObj.insertList[i][1];
		valueList[#valueList + 1] = queryObj.insertList[i][2];
	end;

	if (#keyList == 0) then
		return;
	end;

	queryString[#queryString + 1] = " ("..table.concat(keyList, ", ")..")";
	queryString[#queryString + 1] = " VALUES ("..table.concat(valueList, ", ")..")";

	return table.concat(queryString);
end;

local function BuildUpdateQuery(queryObj)
	local queryString = {"UPDATE"};

	if (type(queryObj.tableName) == "string") then
		queryString[#queryString + 1] = " `"..queryObj.tableName.."`";
	else
		ErrorNoHalt("[mysql] No table name specified!\n");
		return;
	end;

	if (type(queryObj.updateList) == "table" and #queryObj.updateList > 0) then
		local updateList = {};

		queryString[#queryString + 1] = " SET";

		for i = 1, #queryObj.updateList do
			updateList[#updateList + 1] = queryObj.updateList[i][1].." = "..queryObj.updateList[i][2];
		end;

		queryString[#queryString + 1] = " "..table.concat(updateList, ", ");
	end;

	if (type(queryObj.whereList) == "table" and #queryObj.whereList > 0) then
		queryString[#queryString + 1] = " WHERE ";
		queryString[#queryString + 1] = table.concat(queryObj.whereList, " AND ");
	end;

	if (type(queryObj.offset) == "number") then
		queryString[#queryString + 1] = " OFFSET ";
		queryString[#queryString + 1] = queryObj.offset;
	end;

	return table.concat(queryString);
end;

local function BuildDeleteQuery(queryObj)
	local queryString = {"DELETE FROM"}

	if (type(queryObj.tableName) == "string") then
		queryString[#queryString + 1] = " `"..queryObj.tableName.."`";
	else
		ErrorNoHalt("[mysql] No table name specified!\n");
		return;
	end;

	if (type(queryObj.whereList) == "table" and #queryObj.whereList > 0) then
		queryString[#queryString + 1] = " WHERE ";
		queryString[#queryString + 1] = table.concat(queryObj.whereList, " AND ");
	end;

	if (type(queryObj.limit) == "number") then
		queryString[#queryString + 1] = " LIMIT ";
		queryString[#queryString + 1] = queryObj.limit;
	end;

	return table.concat(queryString);
end;

local function BuildDropQuery(queryObj)
	local queryString = {"DROP TABLE"}

	if (type(queryObj.tableName) == "string") then
		queryString[#queryString + 1] = " `"..queryObj.tableName.."`";
	else
		ErrorNoHalt("[mysql] No table name specified!\n");
		return;
	end;

	return table.concat(queryString);
end;

local function BuildCreateQuery(queryObj)
	local queryString = {"CREATE TABLE IF NOT EXISTS"};

	if (type(queryObj.tableName) == "string") then
		queryString[#queryString + 1] = " `"..queryObj.tableName.."`";
	else
		ErrorNoHalt("[mysql] No table name specified!\n");
		return;
	end;

	queryString[#queryString + 1] = " (";

	if (type(queryObj.createList) == "table" and #queryObj.createList > 0) then
		local createList = {};

		for i = 1, #queryObj.createList do
			if (Module == "sqlite") then
				createList[#createList + 1] = queryObj.createList[i][1].." "..string.gsub(string.gsub(string.gsub(queryObj.createList[i][2], "AUTO_INCREMENT", ""), "AUTOINCREMENT", ""), "INT ", "INTEGER ");
			else
				createList[#createList + 1] = queryObj.createList[i][1].." "..queryObj.createList[i][2];
			end;
		end;

		queryString[#queryString + 1] = " "..table.concat(createList, ", ").."," ;
	end;

	if (type(queryObj.primaryKey) == "string") then
		queryString[#queryString + 1] = " PRIMARY KEY";
		queryString[#queryString + 1] = " ("..queryObj.primaryKey..")";
	end;

	queryString[#queryString + 1] = " )";

	return table.concat(queryString);
end;

--- Executes the query on the database.
-- @bool[opt] bQueueQuery Whether or not to queue the query. Defaults to false.
function QUERY_CLASS:Execute(bQueueQuery)
	local queryString = nil;
	local queryType = string.lower(self.queryType);

	if (queryType == "select") then
		queryString = BuildSelectQuery(self);
	elseif (queryType == "insert") then
		queryString = BuildInsertQuery(self);
	elseif (queryType == "update") then
		queryString = BuildUpdateQuery(self);
	elseif (queryType == "delete") then
		queryString = BuildDeleteQuery(self);
	elseif (queryType == "drop") then
		queryString = BuildDropQuery(self);
	elseif (queryType == "create") then
		queryString = BuildCreateQuery(self);
	end;

	if (type(queryString) == "string") then
		if (!bQueueQuery) then
			return serverguard.mysql:RawQuery(queryString, self.callback);
		else
			return serverguard.mysql:Queue(queryString, self.callback);
		end;
	end;
end;

--- Creates a new SELECT query.
-- @string tableName The name of the table.
-- @treturn QUERY_CLASS The query object.
function serverguard.mysql:Select(tableName)
	return QUERY_CLASS:New(tableName, "SELECT");
end;

--- Creates a new INSERT INTO query.
-- @string tableName The name of the table.
-- @treturn QUERY_CLASS The query object.
function serverguard.mysql:Insert(tableName)
	return QUERY_CLASS:New(tableName, "INSERT");
end;

--- Creates a new UPDATE query.
-- @string tableName The name of the table.
-- @treturn QUERY_CLASS The query object.
function serverguard.mysql:Update(tableName)
	return QUERY_CLASS:New(tableName, "UPDATE");
end;

--- Creates a new DELETE query.
-- @string tableName The name of the table.
-- @treturn QUERY_CLASS The query object.
function serverguard.mysql:Delete(tableName)
	return QUERY_CLASS:New(tableName, "DELETE");
end;

--- Creates a new DROP query.
-- @string tableName The name of the table.
-- @treturn QUERY_CLASS The query object.
function serverguard.mysql:Drop(tableName)
	return QUERY_CLASS:New(tableName, "DROP");
end;

--- Creates a new CREATE TABLE query.
-- @string tableName The name of the table.
-- @treturn QUERY_CLASS The query object.
function serverguard.mysql:Create(tableName)
	return QUERY_CLASS:New(tableName, "CREATE");
end;

--- Connects to the SQL database with the given information.
-- @string host The host name.
-- @string username The username.
-- @string password The password.
-- @string database The name of the database.
-- @number[opt] port The port to use. Defaults to 3306.
-- @string[opt] socket The unix socket to use. Defaults to none.
-- @number flags The query flags to use. Usually these aren't needed.
function serverguard.mysql:Connect(host, username, password, database, port, socket, flags)
	if (!port) then
		port = 3306;
	end;

	if (Module == "tmysql4") then
		if (type(tmysql) != "table") then
			require("tmysql4");
		end;

		if (tmysql) then
			local errorText = nil;

			self.connection, errorText = tmysql.initialize(host, username, password, database, port, socket, flags);

			if (!self.connection) then
				self:OnConnectionFailed(errorText);
			else
				self:OnConnected();
			end;
		else
			ErrorNoHalt(string.format(MODULE_NOT_EXIST, Module));
		end;
	elseif (Module == "mysqloo") then
		if (type(mysqloo) != "table") then
			require("mysqloo");
		end;

		if (mysqloo) then

			self.connection = mysqloo.connect(host, username, password, database, port, socket or "", (flags or 0));

			self.connection.onConnected = function(database)
				serverguard.mysql:OnConnected();
			end;

			self.connection.onConnectionFailed = function(database, errorText)
				serverguard.mysql:OnConnectionFailed(errorText);
			end;

			self.connection:connect();
		else
			ErrorNoHalt(string.format(MODULE_NOT_EXIST, Module));
		end;
	elseif (Module == "sqlite") then
		serverguard.mysql:OnConnected();
	end;
end;

--- Sends a query to the database without any preprocessing. You should not use this unless
-- you know what you're doing.
-- @string query The query to run.
-- @func callback The function to call when the query finishes.
-- @number flags The flags to set on the query. Usually this isn't needed.
function serverguard.mysql:RawQuery(query, callback, flags, ...)
	if (!self.connection and Module != "sqlite") then
		self:Queue(query);
	end;

	if (Module == "tmysql4") then
		local queryFlag = flags or QUERY_FLAG_ASSOC;

		self.connection:Query(query, function(result)
			local queryStatus = result[1]["status"];

			if (queryStatus) then
				if (type(callback) == "function") then
					local bStatus, value = pcall(callback, result[1]["data"], queryStatus, result[1]["lastid"]);

					if (!bStatus) then
						ErrorNoHalt(string.format("[mysql] MySQL Callback Error!\n%s\n", value));
					end;
				end;
			else
				ErrorNoHalt(string.format("[mysql] MySQL Query Error!\nQuery: %s\n%s\n", query, result[1]["error"]));
			end;
		end, queryFlag, ...);
	elseif (Module == "mysqloo") then
		local queryObj = self.connection:query(query);

		queryObj:setOption(mysqloo.OPTION_NAMED_FIELDS);

		queryObj.onSuccess = function(queryObj, result)
			if (callback) then
				local bStatus, value = pcall(callback, result, self.connection:status(), queryObj:lastInsert());

				if (!bStatus) then
					ErrorNoHalt(string.format("[mysql] MySQL Callback Error!\n%s\n", value));
				end;
			end;
		end;

		queryObj.onError = function(queryObj, errorText, ...)
			if (self.connection:status() != mysqloo.DATABASE_CONNECTED) then
				self:Queue(query, callback);
				self.connection:connect();
				return;
			end;

			ErrorNoHalt(string.format("[mysql] MySQL Query Error!\nQuery: %s\n%s\n", query, errorText));
		end;

		queryObj:start();
	elseif (Module == "sqlite") then
		local result = sql.Query(query);

		if (result == false) then
			ErrorNoHalt(string.format("[mysql] SQL Query Error!\nQuery: %s\n%s\n", query, sql.LastError()));
		else
			if (callback) then
				local bStatus, value = pcall(callback, result);

				if (!bStatus) then
					ErrorNoHalt(string.format("[mysql] SQL Callback Error!\n%s\n", value));
				end;
			end;
		end;
	else
		ErrorNoHalt(string.format("[mysql] Unsupported module \"%s\"!\n", Module));
	end;
end;

--- Adds a query to the queue to be executed once previously pending ones have finished.
-- @string queryString The query to run.
-- @func callback The function to run when the query executes.
function serverguard.mysql:Queue(queryString, callback)
	if (type(queryString) == "string") then
		QueueTable[#QueueTable + 1] = {queryString, callback};
	end;
end;

--- Escapes the string to be used in a query.
-- @string text The string to escape.
-- @bool[opt] bNoQuotes Whether or not to NOT wrap with quotes. Defaults to false.
function serverguard.mysql:Escape(text, bNoQuotes)
	if (self.connection) then
		if (Module == "tmysql4") then
			if (bNoQuotes) then
				return self.connection:Escape(text);
			else
				return string.format("\"%s\"", self.connection:Escape(text));
			end;
		elseif (Module == "mysqloo") then
			if (bNoQuotes) then
				return self.connection:escape(text);
			else
				return string.format("\"%s\"", self.connection:escape(text));
			end;
		end;
	else
		return sql.SQLStr(text, bNoQuotes);
	end;
end;

--- Disconnects from the SQL database.
function serverguard.mysql:Disconnect()
	if (self.connection) then
		if (Module == "tmysql4") then
			return self.connection:Disconnect();
		end;
	end;
end;

-- Function that's ran for checking the query queue.
function serverguard.mysql:Think()
	if (#QueueTable > 0) then
		if (type(QueueTable[1]) == "table") then
			local queueObj = QueueTable[1];
			local queryString = queueObj[1];
			local callback = queueObj[2];

			if (type(queryString) == "string") then
				self:RawQuery(queryString, callback);
			end;

			table.remove(QueueTable, 1);
		end;
	end;
end;

--- A function to set the SQL module to be used. This should not be set unless
-- you know what you're doing!
function serverguard.mysql:SetModule(moduleName)
	Module = moduleName;
end;

-- Called when the database connects sucessfully.
function serverguard.mysql:OnConnected()
	serverguard.PrintConsole("[mysql] Connected to the database!\n");

	self.UpgradeCount = 0;
	self.FinishedUpgrades = 0

	hook.Call("serverguard.mysql.CreateTables", nil);
	hook.Call("serverguard.mysql.UpgradeSchemas", nil, function()
		self.FinishedUpgrades = self.FinishedUpgrades + 1
		if (self.UpgradeCount == self.FinishedUpgrades) then
			hook.Call("serverguard.mysql.OnConnected", nil);
		end
	end);
end;

-- Called when the database connection fails.
function serverguard.mysql:OnConnectionFailed(errorText)
	ErrorNoHalt("[mysql] Unable to connect to the database!\n"..errorText.."\n");

	hook.Call("serverguard.mysql.DatabaseConnectionFailed", nil, errorText);
end;

include 'sg_mysql.lua'
hook.Add("serverguard.Initialize", "serverguard.mysql.Initialize", function()
	local config = SERVERGUARD.MySQL

	if (config and config.enabled == 1) then
		if (config.module != Module) then
			Module = config.module;
		end;

		serverguard.mysql:Connect(config.host, config.username, config.password, config.database, config.port, config.unixsocket);
		return;
	end;

	serverguard.mysql:Connect();
end);

hook.Add("serverguard.mysql.CreateTables", "serverguard.mysql.CreateTables", function()
	local USERS_TABLE_QUERY = serverguard.mysql:Create("serverguard_users");
		USERS_TABLE_QUERY:Create("id", "INTEGER NOT NULL AUTO_INCREMENT");
		USERS_TABLE_QUERY:Create("steam_id", "VARCHAR(25) NOT NULL");
		USERS_TABLE_QUERY:Create("rank", "VARCHAR(255) DEFAULT \"\" NOT NULL");
		USERS_TABLE_QUERY:Create("name", "VARCHAR(255) NOT NULL");
		USERS_TABLE_QUERY:Create("last_played", "INT(11) NOT NULL");
		USERS_TABLE_QUERY:Create("data", "TEXT");
		USERS_TABLE_QUERY:PrimaryKey("id");
	USERS_TABLE_QUERY:Execute();

	local BANS_TABLE_QUERY = serverguard.mysql:Create("serverguard_bans");
		BANS_TABLE_QUERY:Create("id", "INTEGER NOT NULL AUTO_INCREMENT");
		BANS_TABLE_QUERY:Create("steam_id", "VARCHAR(25) NOT NULL");
		BANS_TABLE_QUERY:Create("community_id", "TEXT NOT NULL");
		BANS_TABLE_QUERY:Create("player", "VARCHAR(255) NOT NULL");
		BANS_TABLE_QUERY:Create("reason", "TEXT NOT NULL");
		BANS_TABLE_QUERY:Create("start_time", "INT(11) NOT NULL");
		BANS_TABLE_QUERY:Create("end_time", "INT(11) NOT NULL");
		BANS_TABLE_QUERY:Create("admin", "VARCHAR(255) NOT NULL");
		BANS_TABLE_QUERY:Create("ip_address", "VARCHAR(15) NOT NULL");
		BANS_TABLE_QUERY:PrimaryKey("id");
	BANS_TABLE_QUERY:Execute();

	local SCHEMA_TABLE_QUERY = serverguard.mysql:Create("serverguard_schema");
		SCHEMA_TABLE_QUERY:Create("id", "VARCHAR(31) NOT NULL");
		SCHEMA_TABLE_QUERY:Create("version", "INT(11) NOT NULL DEFAULT '0'");
		SCHEMA_TABLE_QUERY:PrimaryKey("id");
	SCHEMA_TABLE_QUERY:Execute()
end);

-- Upgrades Schemas to latest
-- input: database name, table of strings for each version, callback when done
function serverguard.mysql:UpgradeSchema(id, schemas, callback)
	self.UpgradeCount = self.UpgradeCount + 1

	self:Queue("SELECT `version` from `serverguard_schema` where `id` = "..self:Escape(id)..";",
		function(query)
			local version = tonumber(query and query[1] and query[1].version or 0)

			if (version == #schemas) then
				callback(false)
			else
				local complete_query = "";

				for i = 1, #schemas do
					table.insert(schemas[i], "REPLACE INTO `serverguard_schema` (`id`, `version`) VALUES ("..serverguard.mysql:Escape(id)..", '"..i.."');");
				end

				local function UpgradeRecursion(upgrade, version, index)
					if (not upgrade[version]) then
						return callback(true)
					end
					local final_version_query = index == #upgrade[version];
					local next_version = (final_version_query and 1 or 0) + version;
					local next_index = final_version_query and 1 or index + 1
					if (not upgrade[next_version]) then
						return callback(true)
					end
					serverguard.mysql:Queue(upgrade[next_version][next_index], function()
						UpgradeRecursion(upgrade, next_version, next_index);
					end);

				end

				UpgradeRecursion(schemas, version + 1, 0)

			end
		end
	);

end

timer.Create("serverguard.mysql.Think", 1, 0, function()
	serverguard.mysql:Think();
end);
