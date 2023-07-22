--[[
	https://github.com/notcake/glib/blob/master/lua/glib/io/outbuffer.lua
	Cake's io.outbuffer (converted to not use constuctor)
]]
local bit_band	= bit.band
local math_floor  = math.floor
local math_min	= math.min
local string_byte = string.byte

function gAC.OutBuffer()
	local self = {}

	function self:Clear ()
		Error ("OutBuffer:Clear : Not implemented.")
	end

	function self:GetSize ()
		Error ("OutBuffer:GetSize : Not implemented.")
	end

	function self:GetString ()
		Error ("OutBuffer:GetString : Not implemented.")
	end

	function self:UInt8 (n)
		Error ("OutBuffer:UInt8 : Not implemented.")
	end

	function self:UInt16 (n)
		self:UInt8 (n % 0x0100)
		self:UInt8 (math_floor (n / 0x0100))
	end

	function self:UInt32 (n)
		self:UInt16 (n % 0x00010000)
		self:UInt16 (math_floor (n / 0x00010000))
	end

	function self:UInt64 (n)
		self:UInt32 (n % 4294967296)
		self:UInt32 (math_floor (n / 4294967296))
	end

	function self:ULEB128 (n)
		if n ~= n then n = 0 end
		if n < 0 then n = -n end
		if n >= 4294967296 then n = 4294967295 end
		
		while n > 0 do
			if n >= 0x80 then
				self:UInt8 (0x80 + bit_band (n, 0x7F))
				n = math_floor (n / 0x80)
			else
				self:UInt8 (bit_band (n, 0x7F))
			end
		end
	end

	function self:Int8 (n)
		Error ("OutBuffer:Int8 : Not implemented.")
	end

	function self:Int16 (n)
		self:UInt8 (n % 0x0100)
		self:Int8 (math_floor (n / 0x0100))
	end

	function self:Int32 (n)
		self:UInt16 (n % 0x00010000)
		self:Int16 (math_floor (n / 0x00010000))
	end

	function self:Int64 (n)
		self:UInt32 (n % 4294967296)
		self:Int32 (math_floor (n / 4294967296))
	end

	function self:Float (f)
		local n = gAC.BitConverter.FloatToUInt32 (f)
		self:UInt32 (n)
	end

	function self:Double (f)
		local low, high = gAC.BitConverter.DoubleToUInt32s (f)
		self:UInt32 (low)
		self:UInt32 (high)
	end

	function self:Vector (v)
		self:Float (v.x)
		self:Float (v.y)
		self:Float (v.z)
	end

	function self:Bytes (data, length)
		length = length or #data
		length = math_min (length, #data)
		for i = 1, length do
			self:UInt8 (string_byte (data, i))
		end
	end

	function self:String (data)
		Error ("OutBuffer:String : Not implemented.")
	end

	function self:StringN8 (data)
		data = data or ""
		
		self:UInt8 (#data)
		self:Bytes (data)
	end

	function self:StringN16 (data)
		data = data or ""
		
		self:UInt16 (#data)
		self:Bytes (data)
	end

	function self:StringN32 (data)
		data = data or ""
		
		self:UInt32 (#data)
		self:Bytes (data)
	end

	function self:StringZ (data)
		data = data or ""
		
		self:Bytes (data)
		self:UInt8 (0)
	end

	function self:Boolean (b)
		self:UInt8 (b and 1 or 0)
	end
	return self
end