
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
local KEY_NONE = KEY_NONE
DLib.KeyMap = {}

DLib.KeyMap.KEY = {
	[KEY_0] = '0',
	[KEY_1] = '1',
	[KEY_2] = '2',
	[KEY_3] = '3',
	[KEY_4] = '4',
	[KEY_5] = '5',
	[KEY_6] = '6',
	[KEY_7] = '7',
	[KEY_8] = '8',
	[KEY_9] = '9',
	[KEY_A] = 'A',
	[KEY_B] = 'B',
	[KEY_C] = 'C',
	[KEY_D] = 'D',
	[KEY_E] = 'E',
	[KEY_F] = 'F',
	[KEY_G] = 'G',
	[KEY_H] = 'H',
	[KEY_I] = 'I',
	[KEY_J] = 'J',
	[KEY_K] = 'K',
	[KEY_L] = 'L',
	[KEY_M] = 'M',
	[KEY_N] = 'N',
	[KEY_O] = 'O',
	[KEY_P] = 'P',
	[KEY_Q] = 'Q',
	[KEY_R] = 'R',
	[KEY_S] = 'S',
	[KEY_T] = 'T',
	[KEY_U] = 'U',
	[KEY_V] = 'V',
	[KEY_W] = 'W',
	[KEY_X] = 'X',
	[KEY_Y] = 'Y',
	[KEY_Z] = 'Z',
	[KEY_PAD_0] = '0',
	[KEY_PAD_1] = '1',
	[KEY_PAD_2] = '2',
	[KEY_PAD_3] = '3',
	[KEY_PAD_4] = '4',
	[KEY_PAD_5] = '5',
	[KEY_PAD_6] = '6',
	[KEY_PAD_7] = '7',
	[KEY_PAD_8] = '8',
	[KEY_PAD_9] = '9',
	[KEY_PAD_DIVIDE] = '/',
	[KEY_PAD_MULTIPLY] = '*',
	[KEY_PAD_MINUS] = '-',
	[KEY_PAD_PLUS] = '+',
	[KEY_LBRACKET] = '(',
	[KEY_RBRACKET] = ')',
	[KEY_SEMICOLON] = ';',
	[KEY_PAD_DECIMAL] = '.',
	[KEY_APOSTROPHE] = "'",
	[KEY_BACKQUOTE] = '`',
	[KEY_COMMA] = ',',
	[KEY_PERIOD] = '.',
	[KEY_SLASH] = '/',
	[KEY_BACKSLASH] = '\\',
	[KEY_MINUS] = '-',
	[KEY_EQUAL] = '=',
	[KEY_SPACE] = ' ',
	[KEY_TAB] = '	',
	[KEY_UP] = 'UP',
	[KEY_LEFT] = 'LEFT',
	[KEY_DOWN] = 'DOWN',
	[KEY_RIGHT] = 'RIGHT',
	[KEY_F1] = 'F1',
	[KEY_F2] = 'F2',
	[KEY_F3] = 'F3',
	[KEY_F4] = 'F4',
	[KEY_F5] = 'F5',
	[KEY_F6] = 'F6',
	[KEY_F7] = 'F7',
	[KEY_F8] = 'F8',
	[KEY_F9] = 'F9',
	[KEY_F10] = 'F10',
	[KEY_F11] = 'F11',
	[KEY_F12] = 'F12',
}

DLib.KeyMap.KEY_LOWER = {}
DLib.KeyMap.KEY_REVERSE = {}

for k, v in pairs(DLib.KeyMap.KEY) do
	DLib.KeyMap.KEY_LOWER[k] = v:lower()
	DLib.KeyMap.KEY_REVERSE[v] = k
	DLib.KeyMap.KEY_REVERSE[v:lower()] = k
end

function DLib.KeyMap.GetKeyFromString(strIn)
	return DLib.KeyMap.KEY_REVERSE[strIn:lower()] or KEY_NONE
end

DLib.KeyMap.NUMBERS_LIST = {
	KEY_0,
	KEY_1,
	KEY_2,
	KEY_3,
	KEY_4,
	KEY_5,
	KEY_6,
	KEY_7,
	KEY_8,
	KEY_9,
	KEY_PAD_0,
	KEY_PAD_1,
	KEY_PAD_2,
	KEY_PAD_3,
	KEY_PAD_4,
	KEY_PAD_5,
	KEY_PAD_6,
	KEY_PAD_7,
	KEY_PAD_8,
	KEY_PAD_9,
	KEY_MINUS,
	KEY_PAD_MINUS,
	KEY_PAD_DECIMAL,
	KEY_PERIOD,
}

DLib.KeyMap.NUMBERS_HASH = {}
DLib.KeyMap.NUMBERS_STR = {}
DLib.KeyMap.NUMBERS_STR_LIST = {}
DLib.KeyMap.NUMBERS_STR_REVERSE = {}

for k, v in ipairs(DLib.KeyMap.NUMBERS_LIST) do
	DLib.KeyMap.NUMBERS_HASH[v] = v

	table.insert(DLib.KeyMap.NUMBERS_STR_LIST, DLib.KeyMap.KEY[v])
	DLib.KeyMap.NUMBERS_STR[v] = DLib.KeyMap.KEY[v]
	DLib.KeyMap.NUMBERS_STR_REVERSE[DLib.KeyMap.KEY[v]] = v
end
