hook.Add('PreGamemodeLoaded', 'octolib.widgets', function()
	widgets.PlayerTick = nil
	hook.Remove( 'PlayerTick', 'TickWidgets' )
	hook.Remove( 'PostDrawEffects', 'RenderWidgets' )
end)
