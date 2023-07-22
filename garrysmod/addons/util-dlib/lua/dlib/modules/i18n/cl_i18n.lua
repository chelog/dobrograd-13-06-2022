
-- Copyright (C) 2018-2020 DBotThePony

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

local i18n = i18n
local hook = hook
local unpack = unpack

i18n.DEBUG_LANG_STRINGS = CreateConVar('gmod_language_dlib_dbg_cl', '0', {FCVAR_ARCHIVE}, 'Debug language strings (do not localize them)')

local DefaultPanelCreated

do
	local function languageWatchdog(self)
		self:_SetTextDLib(i18n.localize(self._DLibLocalize, unpack(self._DLibLocalizeArgs)))
	end

	local function SetText(self, text, ...)
		if not text or not isstring(text) then
			hook.Remove('DLib.i18n.LangUpdate5', self)
			return self:_SetTextDLib(text, ...)
		end

		local text2 = text

		if text2[1] == '#' then
			text2 = text2:sub(2)
		end

		if not i18n.exists(text2) then
			hook.Remove('DLib.i18n.LangUpdate5', self)
			return self:_SetTextDLib(text, ...)
		end

		hook.Add('DLib.i18n.LangUpdate5', self, languageWatchdog)
		self._DLibLocalize = text2
		self._DLibLocalizeArgs = {...}
		return self:_SetTextDLib(i18n.localize(text2, ...))
	end

	function DefaultPanelCreated(self)
		if not self.SetText then return end

		self._SetTextDLib = self._SetTextDLib or self.SetText
		self.SetText = SetText
	end
end

local LabelPanelCreated

do
	local function languageWatchdog(self)
		self:_SetLabelDLib(i18n.localize(self._DLibLocalize, unpack(self._DLibLocalizeArgs)))
	end

	local function SetLabel(self, text, ...)
		if not isstring(text) or not i18n.exists(text) then
			hook.Remove('DLib.i18n.LangUpdate4', self)
			return self:_SetLabelDLib(text, ...)
		end

		hook.Add('DLib.i18n.LangUpdate4', self, languageWatchdog)
		self._DLibLocalize = text
		self._DLibLocalizeArgs = {...}
		return self:_SetLabelDLib(i18n.localize(text, ...))
	end

	function LabelPanelCreated(self)
		if not self.SetLabel then return end

		self._SetLabelDLib = self._SetLabelDLib or self.SetLabel
		self.SetLabel = SetLabel
	end
end

local TooltipPanelCreated

do
	local function languageWatchdog(self)
		self:_SetTooltipDLib(i18n.localize(self._DLibLocalize, unpack(self._DLibLocalizeArgs)))
	end

	local function SetTooltip(self, text, ...)
		if not isstring(text) or not i18n.exists(text) then
			hook.Remove('DLib.i18n.LangUpdate3', self)
			return self:_SetTooltipDLib(text, ...)
		end

		hook.Add('DLib.i18n.LangUpdate3', self, languageWatchdog)
		self._DLibLocalize = text
		self._DLibLocalizeArgs = {...}
		return self:_SetTooltipDLib(i18n.localize(text, ...))
	end

	function TooltipPanelCreated(self)
		if not self.SetTooltip then return end

		self._SetTooltipDLib = self._SetTooltipDLib or self.SetTooltip
		self.SetTooltip = SetTooltip
	end
end

local TitlePanelCreated

do
	local function languageWatchdog(self)
		self:_SetTitleDLib(i18n.localize(self._DLibLocalize, unpack(self._DLibLocalizeArgs)))
	end

	local function SetTitle(self, text, ...)
		if not isstring(text) or not i18n.exists(text) then
			hook.Remove('DLib.i18n.LangUpdate2', self)
			return self:_SetTitleDLib(text, ...)
		end

		hook.Add('DLib.i18n.LangUpdate2', self, languageWatchdog)
		self._DLibLocalize = text
		self._DLibLocalizeArgs = {...}
		return self:_SetTitleDLib(i18n.localize(text, ...))
	end

	function TitlePanelCreated(self)
		if not self.SetTitle then return end

		self._SetTitleDLib = self._SetTitleDLib or self.SetTitle
		self.SetTitle = SetTitle
	end
end

local NamedPanelCreated

do
	local function languageWatchdog(self)
		self:_SetNameDLib(i18n.localize(self._DLibLocalize, unpack(self._DLibLocalizeArgs)))
	end

	local function SetName(self, text, ...)
		if not isstring(text) or not i18n.exists(text) then
			hook.Remove('DLib.i18n.LangUpdate1', self)
			return self:_SetNameDLib(text, ...)
		end

		hook.Add('DLib.i18n.LangUpdate1', self, languageWatchdog)
		self._DLibLocalize = text
		self._DLibLocalizeArgs = {...}
		return self:_SetNameDLib(i18n.localize(text, ...))
	end

	function NamedPanelCreated(self)
		if not self.SetName then return end

		self._SetNameDLib = self._SetNameDLib or self.SetName
		self.SetName = SetName
	end
end

-- lmao this way to workaround
hook.Add('DLib.LanguageChanged2', 'DLib.i18nPanelsBridge', function(...)
	hook.Run('DLib.i18n.LangUpdate1', ...)
	hook.Run('DLib.i18n.LangUpdate2', ...)
	hook.Run('DLib.i18n.LangUpdate3', ...)
	hook.Run('DLib.i18n.LangUpdate4', ...)
	hook.Run('DLib.i18n.LangUpdate5', ...)
end)

cvars.AddChangeCallback('gmod_language_dlib_dbg_cl', function()
	hook.Run('DLib.i18n.LangUpdate1')
	hook.Run('DLib.i18n.LangUpdate2')
	hook.Run('DLib.i18n.LangUpdate3')
	hook.Run('DLib.i18n.LangUpdate4')
	hook.Run('DLib.i18n.LangUpdate5')
end, 'DLib')

local function vguiPanelCreated(self)
	local classname = self:GetClassName():lower()
	if classname:find('textentry') or classname:lower():find('input') or classname:lower():find('editor') then return end

	DefaultPanelCreated(self)
	LabelPanelCreated(self)
	TooltipPanelCreated(self)
	TitlePanelCreated(self)
	NamedPanelCreated(self)
end


--[[
	@doc
	@fname DLib.i18n.AddChat
	@args vararg arguments

	@client
]]
function i18n.AddChat(...)
	local rebuild = i18n.rebuildTable({...})
	return chat.AddText(unpack(rebuild))
end

i18n.WatchLegacyPhrases = i18n.WatchLegacyPhrases or {}

--[[
	@doc
	@fname DLib.i18n.RegisterProxy
	@args string legacyName, string newName

	@client
	@deprecated

	@desc
	allows you to do language.Add(legacyName, localized newName) easily
	@enddesc
]]
function i18n.RegisterProxy(legacyName, newName)
	newName = newName or legacyName

	i18n.WatchLegacyPhrases[legacyName] = newName
	language.Add(legacyName, i18n.localize(newName))
end

hook.Add('DLib.LanguageChanged', 'DLib.i18n.WatchLegacyPhrases', function(...)
	for legacyName, newName in pairs(i18n.WatchLegacyPhrases) do
		language.Add(legacyName, i18n.localize(newName))
	end
end)

hook.Add('VGUIPanelCreated', 'DLib.I18n', vguiPanelCreated)
chat.AddTextLocalized = i18n.AddChat

local gmod_language, LastLanguage
local LANG_OVERRIDE = CreateConVar('gmod_language_dlib_cl', '', {FCVAR_ARCHIVE}, 'gmod_language override for DLib based addons')

--[[
	@doc
	@fname DLib.i18n.UpdateLang

	@internal
]]
function i18n.UpdateLang()
	gmod_language = gmod_language or GetConVar('gmod_language')
	if not gmod_language then return end
	local grablang = LANG_OVERRIDE:GetString():lower():trim()

	if grablang ~= '' then
		i18n.CURRENT_LANG = grablang
	else
		i18n.CURRENT_LANG = gmod_language:GetString():lower():trim()
	end

	if LastLanguage ~= i18n.CURRENT_LANG then
		hook.Run('DLib.LanguageChanged', LastLanguage, i18n.CURRENT_LANG)
		hook.Run('DLib.LanguageChanged2', LastLanguage, i18n.CURRENT_LANG)
	end

	LastLanguage = i18n.CURRENT_LANG

	net.Start('dlib.clientlang')
	net.WriteString(i18n.CURRENT_LANG)
	net.SendToServer()
end

cvars.AddChangeCallback('gmod_language', i18n.UpdateLang, 'DLib')
cvars.AddChangeCallback('gmod_language_dlib_cl', i18n.UpdateLang, 'DLib')
timer.Simple(0, i18n.UpdateLang)
