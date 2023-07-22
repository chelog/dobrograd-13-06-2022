octochat.registerCommand('/forum', {
	cooldown = 5,
	execute = octolib.rewardCommands.forum,
})

octochat.registerCommand('/rewards', {
	cooldown = 60,
	execute = octolib.rewardCommands.rewards,
})
