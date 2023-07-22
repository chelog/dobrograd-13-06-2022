--[[
	NetStream - 1.0.2

	Alexander Grist-Hucker
	http://www.revotech.org
	
	Credits to:
		Alexandru-Mihai Maftei aka Vercas for vON.
		https://github.com/vercas/vON
--]]

--- ## Shared
-- Networking helper library that provides easier access to networking with chunking support.
-- @module serverguard.netstream

local type, error, pcall, pairs, AddCSLuaFile, _player = type, error, pcall, pairs, AddCSLuaFile, player;

--[[
	AddCSLuaFile("includes/modules/von.lua");
	require("von");
--]]

AddCSLuaFile();

serverguard.netstream = serverguard.netstream or {};

local stored = {};
local chunks = {};

local bb_write, bb_read = 
	include "bitbuf_glua/write.lua",
	include "bitbuf_glua/read.lua"

local coded = 
	include "bitbuf_glua/table.lua"
	
local function encode(t)
	local buf = bb_write()
	coded.write(buf, t)
	return buf:ExportAsString()	
end

local function decode(t)
	local read = bb_read(t)
	return coded.read(read)
end

serverguard.tables = {
	write = function(t)
		local dat = encode(t)
		net.WriteUInt(#dat, 32)
		net.WriteData(dat, #dat)
	end,
	read = function()
		return decode(net.ReadData(net.ReadUInt(32)))
	end
}
local tables = serverguard.tables;

--- Splits a table into a series of strings for easier networking.
-- @see serverguard.netstream.Build
-- @table data The data to split.
-- @treturn table A table of strings representing the split data.
function serverguard.netstream.Split(data)
	if (type(data) != "string") then
		data = encode(data)
	end;

	local result = {};
	
	for i = 1, data:len(), 0x8000 do
		result[#result + 1] = data:sub(i, i + 0x7fff)
	end

	return result;
end;

--- Reconstructs a table of split strings.
-- @see serverguard.netstream.Split
-- @table data The data to reconstruct.
-- @treturn table The reconstructed data.
function serverguard.netstream.Build(data)
	return decode(table.concat(data));
end;

--- Adds a hook to a data stream.
-- @see serverguard.netstream.Start
-- @string name Name of the data stream.
-- @func callback Function to execute when the data stream has been received.
function serverguard.netstream.Hook(name, Callback)
	if (!stored[name]) then
		stored[name] = {};
	end;

	table.insert(stored[name], Callback);
end;

function serverguard.netstream.GetStored()
	return stored;
end;

if (SERVER) then
	local chunkQueue = {};

	util.AddNetworkString("ServerGuardDS");
	util.AddNetworkString("ServerGuardChunkedDS");

	--- Sends a data stream to the target. Will send to client as server and vice versa.
	-- @see serverguard.netstream.Hook
	-- @player player The player to send the data to. You should **not** pass this argument clientside.
	-- @string name The name of the data stream to send.
	-- @table data The data to send.
	function serverguard.netstream.Start(ply, name, data)
		net.Start("ServerGuardDS");
			net.WriteString(name);
			tables.write {data};
		
		if (ply) then
			if (istable(ply)) then
				local recipients = RecipientFilter()
				
				for k, v in pairs(ply) do
					-- FIXME: Do player finding here or assume they are player entities?
					if (isplayer(v)) then
						recipients:AddPlayer(v);
					elseif (isplayer(k)) then
						recipients:AddPlayer(k);
					end;
				end;
				
				net.Send(recipients)
			else
				net.Send(ply)
			end;
		else
			net.Broadcast()
		end;
	end;

	--- Sends a data stream to the target. This is used for larger data sets that may exceed the 64kb networking limit.
	-- @see serverguard.netstream.Hook
	-- @player player The player to send the data to. You should **not** pass this argument clientside.
	-- @string name The name of the data stream to send.
	-- @table data The data to send.
	function serverguard.netstream.StartChunked(pPlayer, name, data)
		local recipients;
		
		-- Skip loop if we can
		if (pPlayer) then
			if (istable(pPlayer)) then
				recipients = {}
				local pos = -1
				
				for k, v in pairs(pPlayer) do
					if (isplayer(v)) then
						pos = pos + 1
						recipients[pos] = v;
					elseif (isplayer(k)) then
						pos = pos + 1
						recipients[pos] = k;
					end;
				end;
				
				if (pos == -1) then
					recipients = nil
				end
			else
				recipients = {pPlayer}
			end
		else
			recipients = player.GetAll()
		end
		
		if (recipients) then
			local splitData = serverguard.netstream.Split({data = (data or 0)});
			
			if (splitData) then
				local len = #splitData
				
				if (len ~= 0) then
					chunkQueue[name] = {
						recipients = recipients,
						data = splitData;
					};

					net.Start("ServerGuardChunkedDS");
						net.WriteString(name);
						net.WriteUInt(1, 32);
						net.WriteUInt(len, 32);
						
						local len = #splitData[1]
						net.WriteUInt(len, 32);
						net.WriteData(splitData[1], len);
					net.Send(recipients);
				end
			end;
		end;
	end;
	
	net.Receive("ServerGuardDS", function(length, pPlayer)
		local NS_DS_NAME = net.ReadString();
		local NS_DS_DATA = tables.read();
		
		if (NS_DS_NAME) then
			pPlayer.nsDataStreamName = NS_DS_NAME;
			pPlayer.nsDataStreamData = "";
			pPlayer.nsDataStreamData = NS_DS_DATA;
							
			if (stored[pPlayer.nsDataStreamName]) then
				for k, v in pairs(stored[pPlayer.nsDataStreamName]) do
					v(pPlayer, NS_DS_DATA[1]);
				end;
			end;
			
			pPlayer.nsDataStreamName = nil;
			pPlayer.nsDataStreamData = nil;
		end;
	end);

	net.Receive("ServerGuardChunkedDS", function(length, player)
		local NS_DS_NAME = net.ReadString();
		local NS_DS_NEXT = net.ReadUInt(32);

		if (!chunkQueue[NS_DS_NAME] or !chunkQueue[NS_DS_NAME].data[NS_DS_NEXT] or !table.HasValue(chunkQueue[NS_DS_NAME].recipients, player)) then
			return;
		end;

		if (NS_DS_NEXT >= #chunkQueue[NS_DS_NAME].data) then
			for k, v in pairs(chunkQueue[NS_DS_NAME].recipients) do
				if (v == player) then
					chunkQueue[NS_DS_NAME].recipients[k] = nil;
				end;
			end;
		end;

		net.Start("ServerGuardChunkedDS");
			net.WriteString(NS_DS_NAME);
			net.WriteUInt(NS_DS_NEXT, 32);
			net.WriteUInt(#chunkQueue[NS_DS_NAME].data, 32);

			net.WriteUInt(#chunkQueue[NS_DS_NAME].data[NS_DS_NEXT], 32);
			net.WriteData(chunkQueue[NS_DS_NAME].data[NS_DS_NEXT], #chunkQueue[NS_DS_NAME].data[NS_DS_NEXT]);
		net.Send(player);
	end);
else
	function serverguard.netstream.Start(name, data)
		net.Start("ServerGuardDS");
			net.WriteString(name);
			tables.write {data}
		net.SendToServer();
	end;
	
	net.Receive("ServerGuardDS", function(length)
		local NS_DS_NAME = net.ReadString();
		local NS_DS_DATA = tables.read();
		
		if (NS_DS_NAME) then
			if (stored[NS_DS_NAME]) then
				for k, v in pairs(stored[NS_DS_NAME]) do
					v(NS_DS_DATA[1]);
				end;
			end;
		end;
	end);

	net.Receive("ServerGuardChunkedDS", function(length)
		local NS_DS_NAME = net.ReadString();
		local NS_DS_CURRENT = net.ReadUInt(32);
		local NS_DS_TOTAL = net.ReadUInt(32);

		local NS_DS_LENGTH = net.ReadUInt(32);
		local NS_DS_DATA = net.ReadData(NS_DS_LENGTH);
		
		if (!NS_DS_NAME or !NS_DS_CURRENT or !NS_DS_TOTAL or !NS_DS_LENGTH or !NS_DS_DATA) then
			return;
		end;

		if (!chunks[NS_DS_NAME]) then
			chunks[NS_DS_NAME] = {};
		end;

		if (NS_DS_CURRENT > 0 and NS_DS_DATA) then
			table.insert(chunks[NS_DS_NAME], NS_DS_DATA);
		end;

		if (NS_DS_CURRENT >= NS_DS_TOTAL) then
			if (chunks[NS_DS_NAME] and stored[NS_DS_NAME]) then
				local bStatus, value = pcall(serverguard.netstream.Build, chunks[NS_DS_NAME]);
			
				if (bStatus) then
					for k, v in pairs(stored[NS_DS_NAME]) do
						v(value.data);
					end;

					chunks[NS_DS_NAME] = nil;
				else
					ErrorNoHalt("NetStream: '"..NS_DS_NAME.."'\n"..value.."\n");
				end;
			end;
		else
			net.Start("ServerGuardChunkedDS");
				net.WriteString(NS_DS_NAME);
				net.WriteUInt(NS_DS_CURRENT + 1, 32);
			net.SendToServer();
		end;
		
		NS_DS_NAME, NS_DS_CURRENT, NS_DS_TOTAL, NS_DS_LENGTH, NS_DS_DATA = nil, nil, nil, nil, nil;
	end);
end;