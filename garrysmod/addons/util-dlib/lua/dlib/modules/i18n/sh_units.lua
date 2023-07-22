
-- Copyright (C) 2018-2019 DBotThePony

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

i18n.METRES_IN_HU = 0.0254

local prefixL = {
	{math.pow(10, -24), 'yocto'},
	{math.pow(10, -21), 'zepto'},
	{math.pow(10, -18), 'atto'},
	{math.pow(10, -15), 'femto'},
	{math.pow(10, -12), 'pico'},
	{math.pow(10, -9), 'nano'},
	{math.pow(10, -6), 'micro'},
	{math.pow(10, -3), 'milli'},
	-- {math.pow(10, -2), 'centi', true},
	-- {math.pow(10, -1), 'deci', true},
	{math.pow(10, 3), 'kilo'},
	{math.pow(10, 6), 'mega'},
	{math.pow(10, 9), 'giga'},
	{math.pow(10, 12), 'tera'},
	{math.pow(10, 15), 'peta'},
	{math.pow(10, 18), 'exa'},
	{math.pow(10, 21), 'zetta'},
	{math.pow(10, 24), 'yotta'},
}

function i18n.FormatNumImperial(numIn)
	if numIn >= -1000 and numIn <= 1000 then
		return string.format('%.2f', numIn)
	end

	return string.format('%.2fk', numIn / 1000)
end

--[[
	@doc
	@fname DLib.i18n.FormatNum
	@args number numIn

	@returns
	string
]]
function i18n.FormatNum(numIn, minFormat)
	local abs = numIn:abs()

	if abs >= (minFormat or 1) and abs <= 1000 then
		return string.format('%.2f', numIn)
	end

	local prefix, lastNum = prefixL[1][2], prefixL[1][1]

	for i, row in ipairs(prefixL) do
		if row[1] <= abs then
			prefix, lastNum = row[2], row[1]
		else
			break
		end
	end

	return string.format('%.2f%s', numIn / lastNum, i18n.localize('info.dlib.si.prefix.' .. prefix .. '.prefix'))
end

--[[
	@doc
	@fname DLib.i18n.FormatFrequency
	@args number Hz

	@returns
	string
]]

--[[
	@doc
	@fname DLib.i18n.FormatForce
	@args number N

	@returns
	string
]]

--[[
	@doc
	@fname DLib.i18n.FormatPressure
	@args number Pa

	@returns
	string
]]

--[[
	@doc
	@fname DLib.i18n.FormatWork
	@alias DLib.i18n.FormatHeat
	@alias DLib.i18n.FormatEnergy
	@args number J

	@returns
	string
]]

--[[
	@doc
	@fname DLib.i18n.FormatPower
	@args number W

	@returns
	string
]]

--[[
	@doc
	@fname DLib.i18n.FormatVoltage
	@args number V

	@returns
	string
]]

--[[
	@doc
	@fname DLib.i18n.FormatElectricalCapacitance
	@args number F

	@returns
	string
]]

--[[
	@doc
	@fname DLib.i18n.FormatElectricalResistance
	@alias DLib.i18n.FormatImpedance
	@alias DLib.i18n.FormatReactance
	@args number Ω

	@returns
	string
]]

--[[
	@doc
	@fname DLib.i18n.FormatElectricalConductance
	@args number S

	@returns
	string
]]

--[[
	@doc
	@fname DLib.i18n.FormatMagneticFlux
	@args number wb

	@returns
	string
]]

--[[
	@doc
	@fname DLib.i18n.FormatMagneticFluxDensity
	@alias DLib.i18n.FormatMagneticInduction
	@args number T

	@returns
	string
]]

--[[
	@doc
	@fname DLib.i18n.FormatIlluminance
	@args number lx

	@returns
	string
]]

--[[
	@doc
	@fname DLib.i18n.FormatRadioactivity
	@args number Bq

	@returns
	string
]]

--[[
	@doc
	@fname DLib.i18n.FormatAbsorbedDose
	@args number Gy

	@returns
	string
]]

--[[
	@doc
	@fname DLib.i18n.FormatEquivalentDose
	@args number Sv

	@returns
	string
]]

--[[
	@doc
	@fname DLib.i18n.FormatCatalyticActivity
	@args number kat

	@returns
	string
]]
local units = [[hertz    Hz  frequency   1/s     s−1
radian      rad     angle   m/m     1
steradian   sr      solidAngle     m2/m2   1
newton      N       force, weight   kg⋅m/s2     kg⋅m⋅s−2
pascal      Pa      pressure, stress    N/m2    kg⋅m−1⋅s−2
joule       J       energy, work, heat  N⋅m, C⋅V, W⋅s   kg⋅m2⋅s−2
watt        W       power, radiantFlux     J/s, V⋅A    kg⋅m2⋅s−3
coulomb     C       electricCharge, electricityQuantity  s⋅A, F⋅V    s⋅A
volt        V       voltage, electrical potential difference, electromotive force   W/A, J/C    kg⋅m2⋅s−3⋅A−1
farad       F       electricalCapacitance  C/V, s/Ω    kg−1⋅m−2⋅s4⋅A2
ohm         Ω       electricalResistance, impedance, reactance, resistance     1/S, V/A    kg⋅m2⋅s−3⋅A−2
siemens     S       electricalConductance  1/Ω, A/V    kg−1⋅m−2⋅s3⋅A2
weber       Wb      magneticFlux   J/A, T⋅m2   kg⋅m2⋅s−2⋅A−1
tesla       T       magneticInduction, magneticFluxDensity   V⋅s/m2, Wb/m2, N/(A⋅m)  kg⋅s−2⋅A−1
henry       H       electricalInductance   V⋅s/A, Ω⋅s, Wb/A    kg⋅m2⋅s−2⋅A−2
lumen       lm      luminous flux   cd⋅sr   cd
lux         lx      illuminance     lm/m2   cd⋅sr/m2
becquerel   Bq      radioactivity (decays per unit time)    1/s     s−1
gray        Gy      absorbedDose (of ionizing radiation)   J/kg    m2⋅s−2
sievert     Sv      equivalentDose (of ionizing radiation)     J/kg    m2⋅s−2
katal       kat     catalyticActivity  mol/s   s−1⋅mol]]

for i, row in ipairs(units:split('\n')) do
	local measure, NaM, mtype = row:match('(%S+)%s+(%S+)%s+(.+)')

	if measure and NaM and mtype then
		for i, ttype in ipairs(mtype:split(',')) do
			ttype = ttype:match('(%S+)')

			if ttype then
				i18n['Format' .. ttype:formatname()] = function(numIn)
					return string.format('%s%s', type(numIn) == 'number' and i18n.FormatNum(numIn) or numIn, i18n.localize('info.dlib.si.units.' .. measure .. '.suffix'))
				end
			end
		end
	end
end

i18n.TEMPERATURE_UNITS = CreateConVar('dlib_unit_system_temperature', 'C', {FCVAR_ARCHIVE}, 'C/K/F')
i18n.TEMPERATURE_UNITS_TYPE_CELSIUS = 0
i18n.TEMPERATURE_UNITS_TYPE_KELVIN = 1
i18n.TEMPERATURE_UNITS_TYPE_FAHRENHEIT = 2

--[[
	@doc
	@fname DLib.i18n.FormatTemperature
	@args number numIn, number providedType

	@desc
	`providedType` define in whcih temp units `numIn` is
	Valid values are:
	`DLib.i18n.TEMPERATURE_UNITS_TYPE_CELSIUS` (default)
	`DLib.i18n.TEMPERATURE_UNITS_TYPE_KELVIN`
	`DLib.i18n.TEMPERATURE_UNITS_TYPE_FAHRENHEIT`
	@enddesc

	@returns
	string
]]
function i18n.FormatTemperature(tempUnits, providedType)
	providedType = providedType or i18n.TEMPERATURE_UNITS_TYPE_CELSIUS

	if providedType == i18n.TEMPERATURE_UNITS_TYPE_CELSIUS then
		tempUnits = tempUnits + 273.15
	elseif providedType == i18n.TEMPERATURE_UNITS_TYPE_FAHRENHEIT then
		tempUnits = (tempUnits - 32) * 5 / 9 + 273.15
	end

	local units = i18n.TEMPERATURE_UNITS:GetString()

	if units == 'K' then
		return string.format('%s°%s', i18n.FormatNum(tempUnits, 0.01), i18n.localize('info.dlib.si.units.kelvin.suffix'))
	elseif units == 'F' then
		return string.format('%s°%s', i18n.FormatNumImperial((tempUnits - 273.15) * 9 / 5 + 32), i18n.localize('info.dlib.si.units.fahrenheit.suffix'))
	else
		return string.format('%s°%s', i18n.FormatNum(tempUnits - 273.15, 0.01), i18n.localize('info.dlib.si.units.celsius.suffix'))
	end
end

local sv_gravity = GetConVar('sv_gravity')

--[[
	@doc
	@fname DLib.i18n.FreeFallAcceleration

	@returns
	number: for use with `FormatForce` or anything like that
]]
function i18n.FreeFallAcceleration()
	return 9.8066 * sv_gravity:GetFloat() / 600
end

--[[
	@doc
	@fname DLib.i18n.FormatDistance
	@args number metresIn

	@returns
	string
]]
function i18n.FormatDistance(numIn)
	return string.format('%s%s', i18n.FormatNum(numIn), i18n.localize('info.dlib.si.units.metre.suffix'))
end

--[[
	@doc
	@fname DLib.i18n.FormatHU
	@alias DLib.i18n.FormatHammerUnits
	@args number hammerUnitsIn

	@returns
	string
]]
function i18n.FormatHU(numIn)
	return i18n.FormatDistance(numIn * i18n.METRES_IN_HU)
end

i18n.FormatHammerUnits = i18n.FormatHU

do
	local prefixL = table.Copy(prefixL)

	for i, row in ipairs(prefixL) do
		row[1] = row[1]:pow(2)
	end

--[[
	@doc
	@fname DLib.i18n.FormatArea
	@args number squareMetresIn

	@returns
	string
]]
	function i18n.FormatArea(numIn)
		assert(numIn >= 0, 'Area can not be negative')

		if numIn >= 1 and numIn <= 1000 then
			return string.format('%.2fm^2', numIn)
		end

		local index = 1

		for i, row in ipairs(prefixL) do
			if row[1] <= numIn then
				index = i
			else
				break
			end
		end

		local lastNum, prefix = prefixL[index][1], prefixL[index][2]

		if numIn / lastNum > 10000 and index < #prefixL then
			index = index + 1
			lastNum, prefix = prefixL[index][1], prefixL[index][2]
		end

		return string.format('%.2f%s%s^2', numIn / lastNum, i18n.localize('info.dlib.si.prefix.' .. prefix .. '.prefix'), i18n.localize('info.dlib.si.units.metre.suffix'))
	end

--[[
	@doc
	@fname DLib.i18n.FormatAreaHU
	@alias DLib.i18n.FormatAreaHammerUnits
	@args number squareHammerUnitsIn

	@returns
	string
]]
	function i18n.FormatAreaHU(numIn)
		return i18n.FormatArea(numIn * i18n.METRES_IN_HU)
	end

	i18n.FormatAreaHammerUnits = i18n.FormatAreaHU
end

do
	local prefixL = table.Copy(prefixL)

	for i, row in ipairs(prefixL) do
		row[1] = row[1]:pow(3)
	end

	i18n.VOLUME_UNITS = CreateConVar('dlib_unit_system_volume', 'L', {FCVAR_ARCHIVE}, 'L/m')

--[[
	@doc
	@fname DLib.i18n.FormatVolume
	@args number litres

	@returns
	string
]]
	function i18n.FormatVolume(litres)
		assert(litres >= 0, 'Volume can not be negative')

		if i18n.VOLUME_UNITS:GetString() == 'm' then
			local numIn = litres / 1000

			if numIn >= 0.0001 and numIn <= 1000000 then
				return string.format('%.4fm^3', numIn)
			end

			local index = 1

			for i, row in ipairs(prefixL) do
				if row[1] <= numIn then
					index = i
				else
					break
				end
			end

			local lastNum, prefix = prefixL[index][1], prefixL[index][2]

			if numIn / lastNum > 10000 and index < #prefixL then
				index = index + 1
				lastNum, prefix = prefixL[index][1], prefixL[index][2]
			end

			return string.format('%.4f%s%s^3', numIn / lastNum, i18n.localize('info.dlib.si.prefix.' .. prefix .. '.prefix'), i18n.localize('info.dlib.si.units.metre.suffix'))
		end

		return string.format('%s%s', i18n.FormatNum(litres), i18n.localize('info.dlib.si.units.litre.suffix'))
	end

--[[
	@doc
	@fname DLib.i18n.FormatVolumeHU
	@alias DLib.i18n.FormatVolumeHammerUnits
	@args number cubicHammerUnitsIn

	@returns
	string
]]
	function i18n.FormatVolumeHU(numIn)
		return i18n.FormatVolume(numIn * i18n.METRES_IN_HU * 0.2587786259)
	end

	i18n.FormatVolumeHammerUnits = i18n.FormatVolumeHU

	cvars.AddChangeCallback('dlib_unit_system_volume', function(self, old, new)
		if new ~= 'L' and new ~= 'm' then
			DLib.MessageError('Invalid value for dlib_unit_system_volume specified, reverting to L')
			i18n.VOLUME_UNITS:Reset()
		end
	end, 'DLib')
end

--[[
	@doc
	@fname DLib.i18n.FormatWeight
	@args number grams

	@returns
	string
]]
function i18n.FormatWeight(numIn)
	return string.format('%s%s', i18n.FormatNum(numIn), i18n.localize('info.dlib.si.units.gram.suffix'))
end

--[[
	@doc
	@fname DLib.i18n.GetNormalPressure

	@returns
	number: Pa
]]
function i18n.GetNormalPressure()
	return 101325
end

cvars.AddChangeCallback('dlib_unit_system_temperature', function(self, old, new)
	if new ~= 'C' and new ~= 'K' and new ~= 'F' then
		DLib.MessageError('Invalid value for dlib_unit_system_temperature specified, reverting to C')
		i18n.TEMPERATURE_UNITS:Reset()
	end
end, 'DLib')
