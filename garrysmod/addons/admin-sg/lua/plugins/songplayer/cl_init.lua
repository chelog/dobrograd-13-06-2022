--[[
	© 2017 Thriving Ventures Limited do not share, re-distribute or modify

	without permission of its author (gustaf@thrivingventures.com).
]]

local plugin = plugin
local medialib = include( "modules/cl_medialib.lua" )

plugin:IncludeFile( "shared.lua", SERVERGUARD.STATE.CLIENT )
plugin:IncludeFile( "sh_commands.lua", SERVERGUARD.STATE.CLIENT )
plugin:IncludeFile( "cl_panel.lua", SERVERGUARD.STATE.CLIENT )

local volumeConVarName = "serverguard_songplayer_volume"

plugin.songVolume = CreateClientConVar( volumeConVarName, "50", true )

cvars.AddChangeCallback( volumeConVarName, function( conVarName, oldValue, newValue )
	if IsValid( plugin.mediaclip ) then plugin.mediaclip:setVolume( newValue / 100 ) end
end )

local function errorWithLoadingSong()
	plugin.ui.panel:SetTitle( "Error loading song!" )
	plugin.ui.panel:FadeOut()

	serverguard.PrintConsole( "There was a problem loading the YouTube video!\n" )
end

-- Plugin methods.
function plugin:FetchVideoInfo( id, callback )
	if IsValid( medialib ) then medialib:stop() end
	if IsValid( plugin.mediaclip ) then plugin.mediaclip:stop() end

	-- Get the service that this link uses
	local service = medialib.load( "media" ).guessService( id )
	if not service then errorWithLoadingSong() return end

	-- Create a mediaclip from the link
	plugin.mediaclip = service:load( id )

	-- Query media title (eg youtube video title)
	service:query( id, function( err, data )
		if err then
			if IsValid( plugin.ui.panel ) then
				errorWithLoadingSong()
			end
			return
		end

		callback( data, plugin.mediaclip )
	end )
end

function plugin:Play( id, offsetTime )
	offsetTime = offsetTime or 0

	if IsValid( plugin.ui.panel ) then plugin.ui.panel:Remove() end
	plugin.ui.panel = vgui.Create( "serverguard.songplayer" )

	plugin.startTime = 0
	plugin.currentSongDuration = 0

	self.ui.panel:SetLoading( true )
	self.ui.panel:SetTitle( "Loading song..." )

	if not self.ui.panel:IsVisible() then
		self.ui.panel:FadeIn()
	end

	self:FetchVideoInfo( id, function( data, mediaclip )
		if data then
			plugin.currentTitle = data.title
			plugin.offsetTime = offsetTime

			if IsValid( plugin.ui.panel ) then
				local time = string.FormattedTime( data.duration )
				local title = string.format( "%s [%s]", data.title or "unknown", string.format( "%i:%i", time.m, time.s ) )

				plugin.ui.panel:SetTitle( title )
				plugin.ui.panel:SetLoading( false )
			end

			timer.Simple( data.duration, function()
				if not IsValid( plugin.ui.panel ) then return end

				plugin.ui.panel:FadeOut()
			end )

			plugin.startTime = CurTime() - plugin.offsetTime
			plugin.currentSongDuration = data.duration

			-- Play media
			mediaclip:play()
			mediaclip:seek( offsetTime or 0 )
			mediaclip:setVolume( plugin.songVolume:GetInt() / 100 )
		else
			errorWithLoadingSong()
		end
	end )
end

plugin:Hook( "OnContextMenuOpen", "serverguard.songplayer.OnContextMenuOpen", function()
	if IsValid( plugin.ui.panel ) and plugin.ui.panel:IsVisible() then
		-- some gamemodes like clockwork like to arbitrarily control the context menu, so we
		-- have to delay the panel update by a bit to make sure we've got the final result
		timer.Simple( 0.1, function()
			local x, y = plugin.ui.panel:GetPos()
			local parentPanel = vgui.GetWorldPanel()

			if IsValid( g_ContextMenu ) and g_ContextMenu:IsVisible() then
				parentPanel = g_ContextMenu

				if IsValid( menubar.Control ) and menubar.Control:IsVisible() then
					plugin.ui.panel:SetPos( x, 30 )
				else
					plugin.ui.panel:SetPos( x, 0 )
				end
			end

			plugin.ui.panel:SetParent( parentPanel )
			plugin.ui.panel:MoveToFront()
		end )
	end
end )

plugin:Hook( "OnContextMenuClose", "serverguard.songplayer.OnContextMenuClose", function()
	if IsValid( plugin.ui.panel ) and plugin.ui.panel:IsVisible() then
		local x, y = plugin.ui.panel:GetPos()

		plugin.ui.panel:SetPos( x, 0 )
		plugin.ui.panel:SetParent( vgui.GetWorldPanel() )
		plugin.ui.panel:MoveToFront()
	end
end )

serverguard.netstream.Hook( "sgSongPlayerPlay", function( data )
	plugin:Play( data[1], data[2] )
end )

serverguard.netstream.Hook( "sgSongPlayerStop", function( data )
	plugin.ui.panel:FadeOut()
	if IsValid( plugin.mediaclip ) then plugin.mediaclip:stop() end
end )
