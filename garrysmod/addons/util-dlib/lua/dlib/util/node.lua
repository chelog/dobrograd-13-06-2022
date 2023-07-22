
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

-- TODO: Consider removal or rewrite
return function()
	local export = {}
	local usedSlots = {}

	export.slotUsagePriority = {
		{0, 0},
		{1, 0},
		{-1, 0},
		{0, 1},
		{0, -1},
		{-1, 1},
		{1, 1},
		{1, -1},
		{-1, -1},
	}

	local slotUsagePriority = export.slotUsagePriority

	function export.findNearest(x, y, size)
		usedSlots[size] = usedSlots[size] or {}
		local div = size * 24
		local ctab = usedSlots[size]
		local slotX, slotY = math.floor(x / div), math.floor(y / div)

		if ctab[slotX] == nil then
			ctab[slotX] = {}
			ctab[slotX][slotY] = true
			return x, y
		else
			local findFreeSlotX, findFreeSlotY = 0, 0

			for radius = 1, 10 do
				local success = false

				for i, priorityData in ipairs(slotUsagePriority) do
					local sx, sy = priorityData[1] * radius + slotX, priorityData[2] * radius + slotY

					if not ctab[sx] or not ctab[sx][sy] then
						findFreeSlotX, findFreeSlotY = sx, sy
						success = true
						break
					end
				end

				if success then
					break
				end
			end

			ctab[findFreeSlotX] = ctab[findFreeSlotX] or {}
			ctab[findFreeSlotX][findFreeSlotY] = true

			return findFreeSlotX * div, findFreeSlotY * div
		end
	end

	function export.findNearestAlt(x, y, size, sizeH)
		size = size or 16
		sizeH = sizeH or size
		usedSlots[size] = usedSlots[size] or {}
		local div = size * 24
		local divY = sizeH * 24
		local ctab = usedSlots[size]
		local slotX, slotY = math.floor(x / div), math.floor(y / divY)

		if ctab[slotX] == nil then
			ctab[slotX] = {}
			ctab[slotX][slotY] = true
			return x, y
		else
			local findFreeSlotX, findFreeSlotY = 0, 0

			for radius = 1, 10 do
				local success = false

				for x = radius, -radius, -1 do
					for y = radius, -radius, -1 do
						local sx, sy = x + slotX, y + slotY

						if not ctab[sx] or not ctab[sx][sy] then
							findFreeSlotX, findFreeSlotY = sx, sy
							success = true
							break
						end
					end
				end

				if success then
					break
				end
			end

			ctab[findFreeSlotX] = ctab[findFreeSlotX] or {}
			ctab[findFreeSlotX][findFreeSlotY] = true

			return findFreeSlotX * div, findFreeSlotY * divY
		end
	end

	function export.clear()
		usedSlots = {}
	end

	return export
end
