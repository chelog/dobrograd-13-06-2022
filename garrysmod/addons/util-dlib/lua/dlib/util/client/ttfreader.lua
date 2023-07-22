
-- Copyright (C) 2017-2020 DBotThePony

-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
-- of the Software, and to permit persons to whom the Software is furnished to do so,
-- subject to the following conditions:

-- The above copyright notice and this permission notice shall be included in all copies
-- or substantial portions of the Software.

-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
-- INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
-- PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
-- FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
-- OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
-- DEALINGS IN THE SOFTWARE.

local DLib = DLib
local table = table
local string = string

DLib.ttf = {}
local meta = FindMetaTable('DLibTTF') or {}
debug.getregistry().DLibTTF = meta
DLib.ttf.meta = meta

meta.__index = meta

do
	local HeadStruct = DLib.BytesBuffer.CompileStructure([[
		uint32  scaler type
		uint16  numTables
		uint16  searchRange
		uint16  entrySelector
		uint16  rangeShift
	]])

	local OffsetStruct = DLib.BytesBuffer.CompileStructure([[
		uint8  tagA
		uint8  tagB
		uint8  tagC
		uint8  tagD
		uint32  checkSum
		uint32  offset
		uint32  length
	]])

	function DLib.ttf.Open(bytesbuffer)
		local readFrom = bytesbuffer:Ask()
		local head = HeadStruct(bytesbuffer)
		local offsets = {}

		for i = 1, head.numTables do
			local offset = OffsetStruct(bytesbuffer)
			offset.tag = string.char(offset.tagA, offset.tagB, offset.tagC, offset.tagD)
			offsets[offset.tag] = offset
		end

		local self = {}

		self.head = head
		self.offsets = offsets
		self.bytesbuffer = bytesbuffer
		self.bytespos = readFrom

		return setmetatable(self, meta)
	end
end

function meta:HasName()
	return self.offsets.name ~= nil
end

local NameRecordStruct = DLib.BytesBuffer.CompileStructure([[
	UInt16  platformID                      // Platform identifier code.
	UInt16  platformSpecificID              // Platform-specific encoding identifier.
	UInt16  languageID                      // Language identifier.
	UInt16  nameID                          // Name identifiers.
	UInt16  length                          // Name string length in bytes.
	UInt16  offset                          // Name string offset in bytes from stringOffset.
]])

local NameTableStruct = DLib.BytesBuffer.CompileStructure([[
	UInt16  format                      // Format selector. Set to 0.
	UInt16  count                       // The number of nameRecords in this name table.
	UInt16  stringOffset                // Offset in bytes to the beginning of the name character strings.
	NameRecord  nameRecords             // The name records array.
]], {NameRecord = function(self, read)
	local output = {}

	for i = 1, read.count do
		table.insert(output, NameRecordStruct(self, read))
	end

	return output
end})

function meta:GetNames()
	if not self.offsets.name then
		error('Font lack "name" offsets!')
	end

	if self._getNamesCache then
		return self._getNamesCache
	end

	self.bytesbuffer:Seek(self.bytespos + self.offsets.name.offset)

	local read = NameTableStruct(self.bytesbuffer)
	read.name = self.bytesbuffer:ReadBinary(self.offsets.name.length - read.stringOffset)
	self._getNamesCache = read

	for i, record in ipairs(read.nameRecords) do
		record.contents = read.name:sub(record.offset + 1, record.length + record.offset)
	end

	return read
end

--[[
	0   Unicode     Indicates Unicode version.
	1   Macintosh   QuickDraw Script Manager code.
	2   (reserved; do not use)
	3   Microsoft   Microsoft encoding.
]]

--[[
	0   Roman   17  Malayalam
	1   Japanese    18  Sinhalese
	2   Traditional Chinese     19  Burmese
	3   Korean  20  Khmer
	4   Arabic  21  Thai
	5   Hebrew  22  Laotian
	6   Greek   23  Georgian
	7   Russian     24  Armenian
	8   RSymbol     25  Simplified Chinese
	9   Devanagari  26  Tibetan
	10  Gurmukhi    27  Mongolian
	11  Gujarati    28  Geez
	12  Oriya   29  Slavic
	13  Bengali     30  Vietnamese
	14  Tamil   31  Sindhi
	15  Telugu  32  (Uninterpreted)
	16  Kannada
]]

--[[
	0   Default semantics
	1   Version 1.1 semantics
	2   ISO 10646 1993 semantics (deprecated)
	3   Unicode 2.0 or later semantics (BMP only)
	4   Unicode 2.0 or later semantics (non-BMP characters allowed)
	5   Unicode Variation Sequences
	6   Full Unicode coverage (used with type 13.0 cmaps by OpenType)
]]

--[[
	0   Copyright notice.
	1   Font Family.
	2   Font Subfamily.
	3   Unique subfamily identification.
	4   Full name of the font.
	5   Version of the name table.
	6   PostScript name of the font. All PostScript names in a font must be identical. They may not be longer than 63 characters and the characters used are restricted to the set of printable ASCII characters (U+0021 through U+007E), less the ten characters '[', ']', '(', ')', '{', '}', '<', '>', '/', and '%'.
	7   Trademark notice.
	8   Manufacturer name.
	9   Designer; name of the designer of the typeface.
	10  Description; description of the typeface. Can contain revision information, usage recommendations, history, features, and so on.
	11  URL of the font vendor (with procotol, e.g., http://, ftp://). If a unique serial number is embedded in the URL, it can be used to register the font.
	12  URL of the font designer (with protocol, e.g., http://, ftp://)
	13  License description; description of how the font may be legally used, or different example scenarios for licensed use. This field should be written in plain language, not legalese.
	14  License information URL, where additional licensing information can be found.
	15  Reserved
	16  Preferred Family. In Windows, the Family name is displayed in the font menu, and the Subfamily name is presented as the Style name. For historical reasons, font families have contained a maximum of four styles, but font designers may group more than four fonts to a single family. The Preferred Family and Preferred Subfamily IDs allow font designers to include the preferred family/subfamily groupings. These IDs are only present if they are different from IDs 1 and 2.
	17  Preferred Subfamily. In Windows, the Family name is displayed in the font menu, and the Subfamily name is presented as the Style name. For historical reasons, font families have contained a maximum of four styles, but font designers may group more than four fonts to a single family. The Preferred Family and Preferred Subfamily IDs allow font designers to include the preferred family/subfamily groupings. These IDs are only present if they are different from IDs 1 and 2.
	18  Compatible Full (Macintosh only). In QuickDraw, the menu name for a font is constructed using the FOND resource. This usually matches the Full Name. If you want the name of the font to appear differently than the Full Name, you can insert the Compatible Full Name in ID 18. This name is not used by OS X itself, but may be used by application developers (e.g., Adobe).
	19  Sample text. This can be the font name, or any other text that the designer thinks is the best sample text to show what the font looks like.
	20–22   Defined by OpenType.
	23–255  Reserved for future expansion.
	256 - 32767     Font-specific names (layout features and settings, variations, track names, etc.)
]]

function meta:GetNameID(id)
	local read = self:GetNames()

	for i, record in ipairs(read.nameRecords) do
		if record.nameID == id and (record.platformID == 0 or record.platformID == 1) and record.platformSpecificID == 0 and not record.contents:find('\x00') then
			-- Microsoft's encoding sux
			return record.contents, record
		end
	end

	return false
end

function meta:GetFamily()
	return self:GetNameID(1)
end

function meta:GetUniqueFamily()
	return self:GetNameID(3) or self:GetNameID(1)
end

function DLib.ttf.SearchFamilies()
	local files = file.Find('resource/fonts/*.ttf', 'GAME')
	local files2 = file.Find('cache/workshop/resource/fonts/*.ttf', 'GAME')
	local output = {}

	for i, mfile in ipairs(files) do
		local ttf = DLib.ttf.Open(DLib.BytesBuffer(file.Read('resource/fonts/' .. mfile, 'GAME')))

		if ttf:HasName() then
			local getName = ttf:GetFamily()

			if getName and getName ~= '' then
				table.insert(output, getName)
			end
		end
	end

	for i, mfile in ipairs(files2) do
		if not table.qhasValue(files, mfile) then
			local ttf = DLib.ttf.Open(DLib.BytesBuffer(file.Read('cache/workshop/resource/fonts/' .. mfile, 'GAME')))

			if ttf:HasName() then
				local getName = ttf:GetFamily()

				if getName and getName ~= '' then
					table.insert(output, getName)
				end
			end
		end
	end

	return table.deduplicate(output)
end

local concurrentRunning

function DLib.ttf.ASyncSearchFamilies()
	if concurrentRunning then
		return concurrentRunning
	end

	concurrentRunning = DLib.Promise(function(resolve, reject)
		local thread = coroutine.create(function()
			local files = file.Find('resource/fonts/*.ttf', 'GAME')
			local files2 = file.Find('cache/workshop/resource/fonts/*.ttf', 'GAME')
			local output = {}

			for i, mfile in ipairs(files) do
				local ttf = DLib.ttf.Open(DLib.BytesBuffer(file.Read('resource/fonts/' .. mfile, 'GAME')))
				coroutine.syswait(0.1)

				if ttf:HasName() then
					local getName = ttf:GetFamily()

					if getName and getName ~= '' then
						table.insert(output, getName)
					end
				end
			end

			for i, mfile in ipairs(files2) do
				if not table.qhasValue(files, mfile) then
					local ttf = DLib.ttf.Open(DLib.BytesBuffer(file.Read('cache/workshop/resource/fonts/' .. mfile, 'GAME')))
					coroutine.syswait(0.1)

					if ttf:HasName() then
						local getName = ttf:GetFamily()

						if getName and getName ~= '' then
							table.insert(output, getName)
						end
					end
				end
			end

			concurrentRunning = nil
			return resolve(table.deduplicate(output))
		end)

		coroutine.resume(thread)
	end)

	return concurrentRunning
end

surface.DLibCreateFont('DLib.ASyncSearchFamilies', {
	font = 'Roboto',
	size = 24,
	weight = 500
})

local surface = surface
local ScrWL, ScrHL = ScrWL, ScrHL
local drawColorNotify = Color(200, 200, 200)
local color_black = color_black
local ScreenSize = ScreenSize
local draw = draw
local TEXT_ALIGN_CENTER = TEXT_ALIGN_CENTER

hook.Add('PostRenderVGUI', 'DLib.ASyncSearchFamilies', function()
	if not concurrentRunning then return end

	surface.SetFont('DLib.ASyncSearchFamilies')
	local text = DLib.i18n.localize('gui.dlib.notify.families_loading')
	local w, h = surface.GetTextSize(text)

	local x, y = ScrWL() / 2, ScrHL() * 0.03
	x = x - w / 2 - h - ScreenSize(4)

	DLib.HUDCommons.DrawLoading(x + 2, y + 2, h, color_black, 50, math.floor(h / 6):ceil():max(4))
	DLib.HUDCommons.DrawLoading(x, y, h, drawColorNotify, 50, math.floor(h / 6):ceil():max(4))
	x = x + ScreenSize(4) + w / 2 + h

	draw.DrawText(text, 'DLib.ASyncSearchFamilies', x + 1, y + 1, color_black, TEXT_ALIGN_CENTER)
	draw.DrawText(text, 'DLib.ASyncSearchFamilies', x, y, drawColorNotify, TEXT_ALIGN_CENTER)
end)

function DLib.ttf.SearchFamiliesCached()
	if DLib.ttf.__familyCache then
		return DLib.ttf.__familyCache
	end

	DLib.ttf.__familyCache = DLib.ttf.SearchFamilies()
	return DLib.ttf.__familyCache
end

function DLib.ttf.IsFamilyCachePresent()
	return DLib.ttf.__familyCache ~= nil
end

function DLib.ttf.IsFamilyCacheBuilding()
	return concurrentRunning ~= nil
end

function DLib.ttf.ASyncSearchFamiliesCached()
	return DLib.Promise(function(resolve, reject)
		if DLib.ttf.__familyCache then
			return resolve(DLib.ttf.__familyCache)
		end

		DLib.ttf.ASyncSearchFamilies():Then(function(list)
			DLib.ttf.__familyCache = list
			return resolve(DLib.ttf.__familyCache)
		end):Catch(reject)
	end)
end
