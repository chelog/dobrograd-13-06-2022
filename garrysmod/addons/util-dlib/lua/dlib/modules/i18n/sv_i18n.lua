
-- Copyright (C) 2016-2018 DBot

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

net.pool('dlib.clientlang')

local i18n = i18n

i18n.DEBUG_LANG_STRINGS = CreateConVar('gmod_language_dlib_dbg', '0', {FCVAR_ARCHIVE}, 'Debug language strings (do not localize them)')

--[[
	@doc
	@fname DLib.i18n.getPlayer
	@alias DLib.i18n.getByPlayer
	@alias DLib.i18n.localizePlayer
	@alias DLib.i18n.localizebyPlayer
	@alias DLib.i18n.byPlayer
	@alias Player:LocalizePhrase
	@alias Player:DLibPhrase
	@alias Player:DLibLocalize
	@alias Player:GetDLibPhrase

	@args Player ply, string phrase, vararg formatArguments
	@server

	@returns
	string: formatted message
]]
function i18n.getPlayer(ply, phrase, ...)
	return i18n.localizeByLang(phrase, ply.DLib_Lang or 'en', ...)
end

i18n.getByPlayer = i18n.getPlayer
i18n.localizePlayer = i18n.getPlayer
i18n.localizebyPlayer = i18n.getPlayer
i18n.byPlayer = i18n.getPlayer

--[[
	@doc
	@fname DLib.i18n.getPlayerAdvanced
	@alias DLib.i18n.getByPlayerAdvanced
	@alias DLib.i18n.localizePlayerAdvanced
	@alias DLib.i18n.localizebyPlayerAdvanced
	@alias DLib.i18n.byPlayerAdvanced
	@alias Player:LocalizePhraseAdvanced
	@alias Player:DLibPhraseAdvanced
	@alias Player:DLibLocalizeAdvanced
	@alias Player:GetDLibPhraseAdvanced

	@args Player ply, string phrase, Color colorDef = color_white, vararg formatArguments
	@server

	@desc
	Supports colors from custom format arguments
	You don't want to use this unless you know that
	some of phrases can contain custom format arguments
	@enddesc

	@returns
	table: formatted message
	number: arguments "consumed"
]]
function i18n.getPlayerAdvanced(ply, phrase, ...)
	return i18n.localizeByLangAdvanced(phrase, ply.DLib_Lang or 'en', ...)
end

i18n.getByPlayerAdvanced = i18n.getPlayerAdvanced
i18n.localizePlayerAdvanced = i18n.getPlayerAdvanced
i18n.localizebyPlayerAdvanced = i18n.getPlayerAdvanced
i18n.byPlayerAdvanced = i18n.getPlayerAdvanced

local plyMeta = FindMetaTable('Player')

--[[
	@doc
	@fname Player:LocalizePhrase
	@alias Player:DLibPhrase
	@alias Player:DLibLocalize
	@alias Player:GetDLibPhrase

	@args string phrase, vararg formatArguments
	@server

	@returns
	string: formatted message
]]
function plyMeta:LocalizePhrase(phrase, ...)
	return i18n.localizeByLang(phrase, self.DLib_Lang or 'en', ...)
end

plyMeta.DLibPhrase = plyMeta.LocalizePhrase
plyMeta.DLibLocalize = plyMeta.LocalizePhrase
plyMeta.GetDLibPhrase = plyMeta.LocalizePhrase

--[[
	@doc
	@fname Player:LocalizePhraseAdvanced
	@alias Player:DLibPhraseAdvanced
	@alias Player:DLibLocalizeAdvanced
	@alias Player:GetDLibPhraseAdvanced

	@args string phrase, Color colorDef = color_white, vararg formatArguments
	@server

	@desc
	Supports colors from custom format arguments
	You don't want to use this unless you know that
	some of phrases can contain custom format arguments
	@enddesc

	@returns
	table: formatted message
	number: arguments "consumed"
]]
function plyMeta:LocalizePhraseAdvanced(phrase, ...)
	return i18n.localizeByLangAdvanced(phrase, self.DLib_Lang or 'en', ...)
end

plyMeta.DLibPhraseAdvanced = plyMeta.LocalizePhraseAdvanced
plyMeta.DLibLocalizeAdvanced = plyMeta.LocalizePhraseAdvanced
plyMeta.GetDLibPhraseAdvanced = plyMeta.LocalizePhraseAdvanced

local ipairs = ipairs
local player = player
local game = game
local GetName = FindMetaTable('Entity').GetName
local SetName = FindMetaTable('Entity').SetName

local function tickPlayers()
	if game.SinglePlayer() then
		timer.Remove('DLib.TickPlayerNames')
		hook.Remove('PlayerSpawn', 'DLib.TickPlayerNames')
		hook.Remove('DoPlayerDeath', 'DLib.TickPlayerNames')
		return
	end

	for i, ply in ipairs(player.GetAll()) do
		local name = GetName(ply)

		if #name < 4 then
			--DLib.Message(ply, ' network name was considered as exploit, changing...')
			SetName(ply, '_bad_playername_' .. ply:UserID())
		end

		local nick = ply:Nick()

		if nick == 'unnamed' or i18n.exists(nick) then
			ply:Kick('[DLib/I18N] Invalid nickname')
		end
	end
end

function i18n.RegisterProxy(...)
	-- do nothing
end

local LANG_OVERRIDE = CreateConVar('gmod_language_dlib_sv', '', {FCVAR_ARCHIVE}, 'gmod_language override for DLib based addons')


--[[
	@doc
	@hook DLib.LanguageChanged
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
		hook.Call('DLib.LanguageChanged')
		hook.Call('DLib.LanguageChanged2')
	end

	LastLanguage = i18n.CURRENT_LANG
end

cvars.AddChangeCallback('gmod_language', i18n.UpdateLang, 'DLib')
cvars.AddChangeCallback('gmod_language_dlib_sv', i18n.UpdateLang, 'DLib')
timer.Simple(0, i18n.UpdateLang)

--[[
	@doc
	@hook DLib.PlayerLanguageChanges
	@args Player ply, string oldOrNil, string new
]]

net.receive('dlib.clientlang', function(len, ply)
	local old = ply.DLib_Lang
	ply.DLib_Lang = net.ReadString()
	hook.Run('DLib.PlayerLanguageChanges', ply, old, ply.DLib_Lang)
end)

timer.Create('DLib.TickPlayerNames', 0.5, 0, tickPlayers)
hook.Add('PlayerSpawn', 'DLib.TickPlayerNames', timer.Simple:Wrap(0, tickPlayers))
hook.Add('DoPlayerDeath', 'DLib.TickPlayerNames', tickPlayers)
