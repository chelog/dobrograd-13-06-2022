DarkRP.PLAYER.isCook = DarkRP.stub{
	name = "isCook",
	description = "Whether this player is a cook. This function is only available if hungermod is enabled.",
	parameters = {
	},
	returns = {
		{
			name = "answer",
			description = "Whether this player is a cook.",
			type = "boolean"
		}
	},
	metatable = DarkRP.PLAYER
}
