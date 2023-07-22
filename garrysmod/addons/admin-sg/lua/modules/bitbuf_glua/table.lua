
--
-- Read/Write an entity to the stream
-- CClientEntityList::GetMaxEntityIndex() returns 8096
--
MAX_ENTITIES = 8096

if (SERVER) then
	AddCSLuaFile()
end
local function WriteEntity( buf, e )
	if ( IsValid( e ) or game.GetWorld() == e) then

		buf:UInt(1, 1)
		buf:UInt( e:EntIndex(), 13 )

		return

	end

	buf:UInt(0, 1) -- NULL
end

local function ReadEntity(buf)
	if ( buf:UInt(1) == 1 ) then -- non null
		return Entity( buf:UInt( 13 ) )
	end

	return NULL
end

--
-- Read/Write a color to/from the stream
--
local function WriteColor( buf, col )

	assert( IsColor( col ), "WriteColor: color expected, got ".. type( col ) )

	buf:UInt( col.r, 8 )
	buf:UInt( col.g, 8 )
	buf:UInt( col.b, 8 )
	buf:UInt( col.a, 8 )

end

local function ReadColor(buf)

	return Color(
		buf:UInt( 8 ), buf:UInt( 8 ),
		buf:UInt( 8 ), buf:UInt( 8 )
	)

end

--
-- Sizes for ints to send
--
local TYPE_SIZE = 4
local UINTV_SIZE = 5

local Char2HexaLookup, Hexa2CharLookup = {}, {}

--
-- Generate Hexa Lookups
-- Hexa is a 6-bit English character encoding
--
local HexaRanges = {
	{ "a", "z" }, -- 26
	{ "A", "Z" }, -- 52
	{ "0", "9" }, -- 62
	{ "_", "_" }, -- 63
}

local offset = 1

for k, v in ipairs( HexaRanges ) do
	local starts, ends = v[ 1 ]:byte(), v[ 2 ]:byte()

	for char = starts, ends do
		local hexa = char - starts + offset

		Char2HexaLookup[ char ] = hexa
		Hexa2CharLookup[ hexa ] = string.char( char )
	end

	offset = offset + 1 + ends - starts
end


--
-- Converts an ASCII character in to a Hexa Character
--
local function CharToHexa( c )
	return Char2HexaLookup[ c ]
end

--
-- Converts a Hexa character in to an ASCII character
--
local function HexaToChar( h )
	return Hexa2CharLookup[ h ]
end

--
-- Returns true if the string can be represented in 7-Bit ASCII
-- Null bytes are not allowed as they are used for termination
--
local function Is7BitString( str )
	return str:find( "[\x80-\xFF%z]" ) == nil
end

--
-- Returns true if the string can be represented in Hexa
--
local function IsHexaString( str )
	return str:find( "[^a-zA-Z0-9_]" ) == nil
end

--
-- Returns true if the argument is NaN ( can also be interpreted as 0/0 )
--
local function IsNaN( x )
	return x ~= x
end

--
-- An imaginary NaN table for caching in writing.table
--
local NaN = {}

--
-- This exists because you can't make a table index NaN
-- We need to do this so we can cache it in our references table
--
local function IndexSafe( x )
	if ( IsNaN( x ) ) then return NaN end
	return x
end

local reading, writing

--
-- Gets the type of way we are going to send the data
-- Not all of these exist in reality
-- We are only going to add 16 types ( 0-15 ) since that's
-- the max we can fit into 4 bits
--
local function SendType( x )

	if ( x == 1 or x == 0 ) then return "bit" end

	local t = type( x )

	--
	-- check if a number has no decimal places
	-- and is able to be sent in an int
	--

	if ( t == "number" and x % 1 == 0 and x >= -0x7FFFFFFF and x <= 0xFFFFFFFF ) then

		-- test if we can fit it in a single iteration with uintv
		if ( x < bit.lshift( 1, UINTV_SIZE ) and x >= 0 ) then
			return "uintv"
		end

		if ( x <= 0x7FFF and x >= -0x7FFF ) then
			return "int16"
		end

		if ( x <= 0x7FFFFFFF and x >= -0x7FFFFFFF ) then
			return "int32"
		end

		return "uintv"

	end

	if ( t == "string" and IsHexaString( x ) ) then
		return "hexastring"
	end

	if ( t == "string" and Is7BitString( x ) ) then
		return "string7"
	end

	if ( IsColor( x ) ) then
		return "Color"
	end

	if ( TypeID( x ) == TYPE_ENTITY ) then
		return "Entity"
	end

	return t

end

local StringToTypeLookup, TypeToStringLookup = { }, { }

do
	--
	-- MUST BE 16 OR LESS TYPES
	--
	StringToTypeLookup = {
		-- strings
		string	   = 0,
		hexastring   = 1,
		string7	  = 2,

		--numbers
		bit		  = 3,
		int16		= 4,
		int32		= 5,
		number	   = 6,
		uintv		= 7,

		-- default things
		boolean	  = 8,

		--float arrays
		Vector	   = 9,
		Angle		= 10,

		--tables
		table		= 11,
		reference	= 13,


		-- Garry's Mod specific
		VMatrix	  = 12,
		Color		= 14,
		Entity	   = 15,
	}

	--
	-- backwards lookup
	--
	for k,v in pairs( StringToTypeLookup ) do
		TypeToStringLookup[ v ] = k
	end

end

local function TypeToString( n )
	return TypeToStringLookup[ n ]
end

local function StringToType( s )
	return StringToTypeLookup[ s ]
end

local ReferenceType = StringToType( "reference" )
local TableType	 = StringToType( "table" )

reading = {
	--
	-- Normal gmod types we can't really improve
	--
	Color	   = ReadColor,
	boolean	 = function(buf) return buf:UInt(1) == 1 end,
	number	  = function(buf) return buf:Double() end,
	bit		 = function(buf) return buf:UInt(1) end,
	Entity	  = ReadEntity,
	VMatrix	 = error, --net.ReadMatrix,
	Angle	   = function(buf) return Angle(buf:Float(), buf:Float(), buf:Float()) end, --net.ReadAngle,
	Vector	  = function(buf) return Vector(buf:Float(), buf:Float(), buf:Float()) end, --net.ReadVector,

	--
	-- Simple integers
	--
	int16 = function(buf) return buf:Int( 16 ) end,
	int32 = function(buf) return buf:Int( 32 ) end,

	--
	-- A reference index in our already-sent-table
	--
	reference = function( buf, references ) return references[ reading.uintv(buf) ] end,

	--
	-- Variable length unsigned integers
	--
	uintv = function(buf)
		local i = 0
		local ret = 0

		while buf:UInt(1) == 1 do
			local t = buf:UInt( UINTV_SIZE )
			ret = ret + bit.lshift( t, i * UINTV_SIZE )

			i = i + 1
		end

		return ret
	end,

	--
	-- 7 bit encoded strings
	-- NULL terminated
	--
	string7 = function(buf)
		if ( buf:UInt(1) == 1 ) then -- it's compressed
			return util.Decompress( buf:Data( reading.uintv(buf) ) )
		else -- it's not compressed
			local ret = ""

			while true do
				local chr = buf:UInt( 7 )
				if ( chr == 0 ) then return ret end
				ret = ret..string.char( chr )
			end
		end
	end,

	--
	-- Our 6-bit encoded strings
	-- NULL terminated
	--
	hexastring = function(buf)
		if ( buf:UInt(1) == 1 ) then
			return util.Decompress( buf:Data( reading.uintv(buf) ) )
		else
			local ret = ""

			while true do
				local chr = buf:UInt( 6 )
				if ( chr == 0 ) then return ret end -- terminator
				ret = ret..Hexa2CharLookup[ chr ]
			end
		end
	end,

	--
	-- C String
	-- NULL terminated
	-- NOTE: Must be NULL terminated or else will break compatibility
	-- with some addons! Also could lead to exploits
	--
	string = function(buf)
		if ( buf:UInt(1) == 1 ) then -- compressed or not
			return util.Decompress( buf:Data( reading.uintv(buf) ) )
		else
			return buf:String()
		end
	end,

	--
	-- our readtable
	-- directly used as net.ReadTable
	--
	table = function( buf, references )
		local ret = {}

		references = references or {}

		local reference = function( type, value )
			if ( not type or ( type ~= TableType and type ~= ReferenceType ) ) then
				table.insert( references, value )
			end
		end

		reference(nil, ret)

		for i = 1, reading.uintv(buf) do
			local type = buf:UInt( TYPE_SIZE )
			local value = reading[ TypeToString( type ) ]( buf, references )

			reference(type, value)

			ret[ i ] = value
		end

		for i = 1, reading.uintv(buf) do
			local keytype = buf:UInt(TYPE_SIZE)
			local keyvalue = reading[ TypeToString( keytype ) ]( buf, references )

			reference(keytype, keyvalue)

			local valuetype = buf:UInt(TYPE_SIZE)
			local valuevalue = reading[ TypeToString( valuetype ) ]( buf, references )

			reference(valuetype, valuevalue)

			ret[ keyvalue ] = valuevalue

		end

		return ret
	end
}

--
-- We need this since #table returns undefined values
-- by the lua spec if it doesn't have incremental keys
-- we use pairs since it's backwards compatible
--
-- code_gs: pairs loop is needed to run the __pairs metamethod
local function array_len(x)
	local tIndicies = {}
	
	for k, _ in pairs(x) do
		tIndicies[k] = true
	end
	
	for i = 1, MAX_ENTITIES do
		if (tIndicies[i] == nil) then
			return i - 1
		end
	end

	return MAX_ENTITIES
end

writing = {

	bit	  = function(buf, n) buf:UInt(n, 1) end,
	Color	= WriteColor,
	boolean  = function(buf, n) buf:UInt(n and 1 or 0, 1) end,
	number   = function(buf, d) buf:Double(d) end,
	Entity   = WriteEntity,
	VMatrix  = error,
	Vector   = function(buf, v) buf:Float(v.x) buf:Float(v.y) buf:Float(v.z) end,
	Angle	= function(buf, v) buf:Float(v.p) buf:Float(v.y) buf:Float(v.r) end,

	int16 = function( buf, w ) buf:Int( w, 16 ) end,
	int32 = function( buf, d ) buf:Int( d, 32 ) end,

	--
	-- Variable length unsigned integers
	--
	uintv = function( buf, n )
		while( n > 0 ) do
			buf:UInt(1, 1)
			buf:UInt( n, UINTV_SIZE )
			n = bit.rshift( n, UINTV_SIZE )
		end

		buf:UInt(0, 1)
	end,


	--
	-- 7 bit encoded strings
	-- NULL terminated
	--
	string7 = function( buf, s )
		local null = s:find( "%z" )

		if (null) then
			s = s:sub( 1, null - 1 )
		end

		local compressed = util.Compress( s )

		-- add one for the null terminator
		if ( compressed and compressed:len() < (s:len() + 1) / 8 * 7 ) then
			buf:UInt(1, 1)
			writing.uintv( buf, compressed:len() )
			buf:Data( compressed )
		else
			buf:UInt(0, 1)

			for i = 1, s:len() do
				buf:UInt( s:byte( i, i ), 7 )
			end

			buf:UInt( 0, 7 )
		end
	end,

	--
	-- Our 6-bit encoded strings
	-- NULL terminated
	--
	hexastring = function( buf, s )
		local null = s:find( "%z" )

		if (null) then
			s = s:sub( 1, null - 1 )
		end

		local compressed = util.Compress( s )

		-- add one for the null terminator
		if ( compressed and compressed:len() < ( s:len() + 1 ) / 8 * 6 ) then
			buf:UInt(1, 1)
			writing.uintv( buf, compressed:len() )
			buf:Data( compressed )
		else
			buf:UInt(0, 1)

			for i = 1, s:len() do
				buf:UInt( Char2HexaLookup[ s:byte( i, i ) ], 6 )
			end

			buf:UInt( 0, 6 )
		end
	end,

	--
	-- C String
	-- NULL terminated
	-- NOTE: Must be NULL terminated or else will break compatibility
	-- with some addons! Also could lead to exploits
	--
	string = function( buf, x )
		local null = x:find( "%z" )

		if (null) then
			x = x:sub( 1, null - 1 )
		end

		local compressed = util.Compress( x )

		if ( compressed and compressed:len() < x:len() + 1 ) then
			buf:UInt(1, 1)
			writing.uintv( buf, compressed:len() )
			buf:Data( compressed )
		else
			buf:UInt(0, 1)
			buf:String( x )
		end
	end,


	--
	-- our writetable
	-- directly used as net.WriteTable
	--

	table = function( buf, tbl, references, num )
		references = references or {[tbl] = 1}
		num = num or 1

		local SendValue = function( value )
			if ( references[ IndexSafe( value ) ] ) then
				buf:UInt( ReferenceType, TYPE_SIZE )
				writing.uintv( buf, references[ IndexSafe( value ) ] )

				return
			end

			local sendtype = SendType( value )

			num = num + 1
			references[ IndexSafe( value ) ] = num

			buf:UInt( StringToType( sendtype ), TYPE_SIZE )

		 	num = writing[ sendtype ]( buf, value, references, num ) or num
		end

		local pairs_table = {}

		for k,v in pairs(tbl) do
			pairs_table[k] = v
		end

		local array_size = array_len( pairs_table )

		writing.uintv( buf, array_size )

		for i = 1, array_size do
			local value = pairs_table[ i ]
			pairs_table[ i ] = nil

			SendValue( value )
		end

		local object_key_count = table.Count( pairs_table )

		writing.uintv( buf, object_key_count )

		for k,v in next, pairs_table, nil do
			SendValue( k )
			SendValue( v )
		end

		return num
	end
}

return {
	write = function(b, t) writing.table(b, t) end,
	read = function(b) return reading.table(b) end
}