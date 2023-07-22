--[[---------------------------------------------------------
	This module was primarily developed to enable toolmodes
	to share the numpad.

	Scripted Entities can add functions to be excecuted when
	a certain key on the numpad is pressed or released.
-----------------------------------------------------------]]

if ( !SERVER ) then return end

local isstring		= isstring
local tonumber		= tonumber
local pairs			= pairs
local unpack		= unpack
local table			= table
local ErrorNoHalt	= ErrorNoHalt
local MsgN			= MsgN
local saverestore	= saverestore
local math			= math
local IsValid		= IsValid

module( "numpad" )

local functions = {}
local keys_in = {}
local keys_out = {}
local keystates = {}
local lastindex = 1
local button_fired = false

function Debug()
	PrintTable(functions)
	PrintTable(keys_in)
	PrintTable(keys_out)
end

function FromButton()

	return button_fired == true

end

local function Save( save )

	saverestore.WriteTable( keys_in, save )
	saverestore.WriteTable( keys_out, save )
	saverestore.WriteVar( lastindex, save )

end

local function Restore( restore )

	keys_in = saverestore.ReadTable( restore )
	keys_out = saverestore.ReadTable( restore )
	lastindex = saverestore.ReadVar( restore )

end

saverestore.AddSaveHook( "NumpadModule", Save )
saverestore.AddRestoreHook( "NumpadModule", Restore )

--[[---------------------------------------------------------
	Returns a unique index based on a player.
-----------------------------------------------------------]]
local function GetPlayerIndex( ply )

	return isstring(ply) and ply or IsValid(ply) and ply:SteamID() or nil

end

--[[---------------------------------------------------------
	Fires the impulse to the child functions
-----------------------------------------------------------]]
local function FireImpulse( tab, uid )

	if not tab or not tab[uid] then return end

	for k, v in pairs(tab[uid]) do
		local func = functions[v.name]
		if not func then continue end
		local retval = func(uid, unpack(v.arg))

		if retval == false then
			tab[uid][k] = nil
		end
	end

end

--[[---------------------------------------------------------
	Console Command
-----------------------------------------------------------]]
function Activate( uid, num, bIsButton )

	uid = GetPlayerIndex(uid)

	local key = math.Clamp( tonumber( num ), 0, 256 )

	-- Hack. Kinda. Don't call it again until the key has been lifted.
	-- When holding down 9 or 3 on the numpad it will repeat. Ignore that.
	keystates[uid] = keystates[uid] or {}
	if keystates[uid][key] then return end
	keystates[uid][key] = true

	button_fired = bIsButton

		FireImpulse( keys_in[ key ], uid )

	button_fired = false

end

--[[---------------------------------------------------------
	Console Command
-----------------------------------------------------------]]
function Deactivate( uid, num, bIsButton )

	uid = GetPlayerIndex(uid)

	local key = math.Clamp( tonumber( num ) , 0, 256 )

	keystates[uid] = keystates[uid] or {}
	keystates[uid][key] = nil
	if table.Count(keystates[uid]) == 0 then
		keystates[uid] = nil
	end

	button_fired = bIsButton

		FireImpulse( keys_out[ key ], uid )

	button_fired = false

end

--[[---------------------------------------------------------
	Toggle
-----------------------------------------------------------]]
function Toggle( uid, num )

	local key = math.Clamp( tonumber( num ), 0, 256 )

	uid = GetPlayerIndex(uid)

	keystates[uid] = keystates[uid] or {}
	if ( keystates[ uid ][ key ] ) then return Deactivate( uid, num ) end

	return Activate( uid, num )

end

--[[---------------------------------------------------------
	Adds an impulse to to the specified table
-----------------------------------------------------------]]
local function AddImpulse( table, uid, impulse )

	lastindex = lastindex + 1

	uid = GetPlayerIndex(uid)

	table[ uid ] = table[ uid ] or {}
	table[ uid ][ lastindex ] = impulse

	return lastindex

end

--[[---------------------------------------------------------
	Adds a function to call when ply presses key
-----------------------------------------------------------]]
function OnDown( uid, key, name, ... )

	if ( !key ) then ErrorNoHalt( "ERROR: OnDown key is nil!\n" ) return end
	if ( key ~= key ) then MsgN( "ERROR: OnDown key is NaN!" ) return end
	keys_in[ key ] = keys_in[ key ] or {}

	uid = GetPlayerIndex(uid)

	local impulse = {}
	impulse.name = name
	impulse.arg = { ... }

	table.insert( impulse.arg, uid )

	return AddImpulse( keys_in[ key ], uid, impulse )

end

--[[---------------------------------------------------------
	Adds a function to call when ply releases key
-----------------------------------------------------------]]
function OnUp( uid, key, name, ... )

	if ( !key ) then ErrorNoHalt( "ERROR: OnUp key is nil!\n" ) return end
	if ( key ~= key ) then MsgN( "ERROR: OnUp key is NaN!" ) return end
	keys_out[ key ] = keys_out[ key ] or {}

	uid = GetPlayerIndex(uid)

	local impulse = {}
	impulse.name = name
	impulse.arg = { ... }

	table.insert( impulse.arg, uid )

	return AddImpulse( keys_out[ key ], uid, impulse )

end

--[[---------------------------------------------------------
	Removes key from tab (by unique index)
-----------------------------------------------------------]]
local function RemoveFromKeyTable( tab, idx )

	for k, v_key in pairs( tab ) do

		for k_, v_player in pairs( v_key ) do

			if ( v_player[ idx ] != nil ) then
				v_player[ idx ] = nil
			end

		end

	end

end

--[[---------------------------------------------------------
	Removes key (by unique index)
-----------------------------------------------------------]]
function Remove( idx )

	if ( !idx ) then return end

	RemoveFromKeyTable( keys_out, idx )
	RemoveFromKeyTable( keys_in, idx )

end

--[[---------------------------------------------------------
	Register a function
-----------------------------------------------------------]]
function Register( name, func )

	functions[ name ] = func

end
