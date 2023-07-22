DarkRP.initDatabase = DarkRP.stub{
	name = "initDatabase",
	description = "Initialize the DarkRP database.",
	parameters = {
	},
	returns = {
	},
	metatable = DarkRP
}

DarkRP.restorePlayerData = DarkRP.stub{
	name = "restorePlayerData",
	description = "Internal function that restores a player's DarkRP information when they join.",
	parameters = {
	},
	returns = {
	},
	metatable = DarkRP
}

DarkRP.storeDoorData = DarkRP.stub{
	name = "storeDoorData",
	description = "Store the information about a door in the database.",
	parameters = {
		{
			name = "ent",
			description = "The door.",
			type = "Entity",
			optional = false
		}
	},
	returns = {
	},
	metatable = DarkRP
}

DarkRP.storeTeamDoorOwnability = DarkRP.stub{
	name = "storeTeamDoorOwnability",
	description = "Store the ownability information of a door in the database.",
	parameters = {
		{
			name = "ent",
			description = "The door.",
			type = "Entity",
			optional = false
		}
	},
	returns = {
	},
	metatable = DarkRP
}

DarkRP.storeDoorGroup = DarkRP.stub{
	name = "storeDoorGroup",
	description = "Store the group of a door in the database.",
	parameters = {
		{
			name = "ent",
			description = "The door.",
			type = "Entity",
			optional = false
		},
		{
			name = "group",
			description = "The group of the door.",
			type = "string",
			optional = false
		}
	},
	returns = {
	},
	metatable = DarkRP
}

DarkRP.notify = DarkRP.stub{
	name = "notify",
	description = "Make a notification pop up on the player's screen.",
	parameters = {
		{
			name = "ply",
			description = "The receiver(s) of the message.",
			type = "Player, table",
			optional = true
		},
		{
			name = "msgType",
			description = "The type of the message.",
			type = "number",
			optional = false
		},
		{
			name = "time",
			description = "For how long the notification should stay on the screen.",
			type = "number",
			optional = false
		},
		{
			name = "message",
			description = "The actual message.",
			type = "string",
			optional = false
		}
	},
	returns = {
	},
	metatable = DarkRP
}

DarkRP.notifyAll = DarkRP.stub{
	name = "notifyAll",
	description = "Make a notification pop up on the everyone's screen.",
	parameters = {
		{
			name = "msgType",
			description = "The type of the message.",
			type = "number",
			optional = false
		},
		{
			name = "time",
			description = "For how long the notification should stay on the screen.",
			type = "number",
			optional = false
		},
		{
			name = "message",
			description = "The actual message.",
			type = "string",
			optional = false
		}
	},
	returns = {
	},
	metatable = DarkRP
}

DarkRP.printConsoleMessage = DarkRP.stub{
	name = "printConsoleMessage",
	description = "Prints a message to a given player's console. This function also handles server consoles too (EntIndex = 0).",
	parameters = {
		{
			name = "ply",
			description = "The player to send the console message to.",
			type = "Player",
			optional = false
		},
		{
			name = "msg",
			description = "The actual message.",
			type = "string",
			optional = false
		}
	},
	returns = {
	},
	metatable = DarkRP
}

DarkRP.isEmpty = DarkRP.stub{
	name = "isEmpty",
	description = "Check whether the given position is empty.",
	parameters = {
		{
			name = "pos",
			description = "The position to check for emptiness.",
			type = "Vector",
			optional = false
		},
		{
			name = "ignore",
			description = "Table of things the algorithm can ignore.",
			type = "table",
			optional = true
		}
	},
	returns = {
		{
			name = "empty",
			description = "Whether the given position is empty.",
			type = "boolean"
		}
	},
	metatable = DarkRP
}
-- findEmptyPos(pos, ignore, distance, step, area) -- returns pos
DarkRP.findEmptyPos = DarkRP.stub{
	name = "findEmptyPos",
	description = "Find an empty position as close as possible to the given position (Note: this algorithm is slow!).",
	parameters = {
		{
			name = "pos",
			description = "The position to check for emptiness.",
			type = "Vector",
			optional = false
		},
		{
			name = "ignore",
			description = "Table of things the algorithm can ignore.",
			type = "table",
			optional = true
		},
		{
			name = "distance",
			description = "The maximum distance to look for empty positions.",
			type = "number",
			optional = false
		},
		{
			name = "step",
			description = "The size of the steps to check (it places it will look are STEP units removed from one another).",
			type = "number",
			optional = false
		},
		{
			name = "area",
			description = "The hull to check, this is Vector(16, 16, 64) for players.",
			type = "Vector",
			optional = false
		}
	},
	returns = {
		{
			name = "pos",
			description = "A found position. When no position was found, the parameter is returned",
			type = "Vector"
		}
	},
	metatable = DarkRP
}

DarkRP.PLAYER.applyPlayerClassVars = DarkRP.stub{
	name = "applyPlayerClassVars",
	description = "Applies all variables in a player's associated GMod player class to the player.",
	parameters = {
		{
			name = "applyHealth",
			description = "Whether the player's health should be set to the starting health.",
			type = "boolean",
			optional = true
		}
	},
	returns = {},
	metatable = DarkRP.PLAYER
}

DarkRP.PLAYER.setRPName = DarkRP.stub{
	name = "setRPName",
	description = "Set the RPName of a player.",
	parameters = {
		{
			name = "name",
			description = "The new name of the player.",
			type = "string",
			optional = false
		},
		{
			name = "firstrun",
			description = "Whether to play nice and find a different name if it has been taken (true) or to refuse the name change when taken (false).",
			type = "boolean",
			optional = true
		}
	},
	returns = {},
	metatable = DarkRP.PLAYER
}

DarkRP.PLAYER.getPreferredModel = DarkRP.stub{
	name = "getPreferredModel",
	description = "Get the preferred model of a player for a job.",
	parameters = {
		{
			name = "TeamNr",
			description = "The job number.",
			type = "number",
			optional = false
		}
	},
	returns = {
		{
			name = "model",
			description = "The preferred model for the job.",
			type = "string"
		}
	},
	metatable = DarkRP.PLAYER
}

DarkRP.hookStub{
	name = "DarkRPDBInitialized",
	description = "Called when DarkRP is done initializing the database.",
	parameters = {
	},
	returns = {
	}
}

DarkRP.hookStub{
	name = "CanChangeRPName",
	description = "Whether a player can change their RP name.",
	parameters = {
		{
			name = "ply",
			description = "The player.",
			type = "Player"
		},
		{
			name = "name",
			description = "The name.",
			type = "string"
		}
	},
	returns = {
		{
			name = "answer",
			description = "Whether the player can change their RP names.",
			type = "boolean"
		},
		{
			name = "reason",
			description = "When answer is false, this return value is the reason why.",
			type = "string"
		}
	}
}

DarkRP.hookStub{
	name = "onPlayerChangedName",
	description = "Called when a player's DarkRP name has been changed.",
	parameters = {
		{
			name = "ply",
			description = "The player.",
			type = "Player"
		},
		{
			name = "oldName",
			description = "The old name.",
			type = "string"
		},
		{
			name = "newName",
			description = "The new name.",
			type = "string"
		}
	},
	returns = {
	}
}

DarkRP.hookStub{
	name = "playerBoughtPistol",
	description = "Called when a player bought a pistol.",
	parameters = {
		{
			name = "ply",
			description = "The player.",
			type = "Player"
		},
		{
			name = "weaponTable",
			description = "The table (from the CustomShipments table).",
			type = "table"
		},
		{
			name = "ent",
			description = "The spawned weapon.",
			type = "Weapon"
		},
		{
			name = "price",
			description = "The eventual price.",
			type = "number"
		}
	},
	returns = {
	}
}

DarkRP.hookStub{
	name = "playerBoughtShipment",
	description = "Called when a player bought a shipment.",
	parameters = {
		{
			name = "ply",
			description = "The player.",
			type = "Player"
		},
		{
			name = "shipmentTable",
			description = "The table (from the CustomShipments table).",
			type = "table"
		},
		{
			name = "ent",
			description = "The spawned entity.",
			type = "Entity"
		},
		{
			name = "price",
			description = "The eventual price.",
			type = "number"
		}
	},
	returns = {
	}
}

DarkRP.hookStub{
	name = "playerBoughtCustomVehicle",
	description = "Called when a player bought a vehicle.",
	parameters = {
		{
			name = "ply",
			description = "The player.",
			type = "Player"
		},
		{
			name = "vehicleTable",
			description = "The table (from the CustomVehicles table).",
			type = "table"
		},
		{
			name = "ent",
			description = "The spawned vehicle.",
			type = "Entity"
		},
		{
			name = "price",
			description = "The eventual price.",
			type = "number"
		}
	},
	returns = {
	}
}

DarkRP.hookStub{
	name = "playerBoughtCustomEntity",
	description = "Called when a player bought an entity (like a money printer or a gun lab).",
	parameters = {
		{
			name = "ply",
			description = "The player.",
			type = "Player"
		},
		{
			name = "entityTable",
			description = "The table of the custom entity (from the DarkRPEntities table).",
			type = "table"
		},
		{
			name = "ent",
			description = "The spawned vehicle.",
			type = "Entity"
		},
		{
			name = "price",
			description = "The eventual price.",
			type = "number"
		}
	},
	returns = {
	}
}

DarkRP.hookStub{
	name = "playerBoughtAmmo",
	description = "Called when a player buys some ammo.",
	parameters = {
		{
			name = "ply",
			description = "The player.",
			type = "Player"
		},
		{
			name = "ammoTable",
			description = "The table (from the AmmoTypes table).",
			type = "table"
		},
		{
			name = "ent",
			description = "The spawned ammo entity.",
			type = "Weapon"
		},
		{
			name = "price",
			description = "The eventual price.",
			type = "number"
		}
	},
	returns = {
	}
}

DarkRP.hookStub{
	name = "canDemote",
	description = "Whether a player can demote another player.",
	parameters = {
		{
			name = "ply",
			description = "The player who wants to demote.",
			type = "Player"
		},
		{
			name = "target",
			description = "The player whom is to be demoted.",
			type = "Player"
		},
		{
			name = "reason",
			description = "The reason provided for the demote.",
			type = "string"
		}
	},
	returns = {
		{
			name = "canDemote",
			description = "Whether the player can change demote the target.",
			type = "boolean"
		},
		{
			name = "message",
			description = "The message to show when the player cannot demote the other player. Only useful when canDemote is false.",
			type = "string"
		}
	}
}

DarkRP.hookStub{
	name = "onPlayerDemoted",
	description = "Called when a player is demoted.",
	parameters = {
		{
			name = "source",
			description = "The player who demoted the target.",
			type = "Player"
		},
		{
			name = "target",
			description = "The player who has been demoted.",
			type = "Player"
		},
		{
			name = "reason",
			description = "The reason provided for the demote.",
			type = "string"
		}
	},
	returns = {
	}
}

DarkRP.hookStub{
	name = "canDropWeapon",
	description = "Whether a player can drop a certain weapon.",
	parameters = {
		{
			name = "ply",
			description = "The player who wants to drop the weapon.",
			type = "Player"
		},
		{
			name = "weapon",
			description = "The weapon the player wants to drop.",
			type = "Weapon"
		}
	},
	returns = {
		{
			name = "canDrop",
			description = "Whether the player can drop the weapon.",
			type = "boolean"
		}
	}
}

DarkRP.hookStub{
	name = "canSeeLogMessage",
	description = "Whether a player can see a DarkRP log message in the console.",
	parameters = {
		{
			name = "ply",
			description = "The player.",
			type = "Player"
		},
		{
			name = "message",
			description = "The log message.",
			type = "string"
		},
		{
			name = "color",
			description = "The color of the message.",
			type = "Color"
		}
	},
	returns = {
		{
			name = "canHear",
			description = "Whether the player can see the log message.",
			type = "boolean"
		}
	}
}

DarkRP.hookStub{
	name = "canVote",
	description = "Whether a player can cast a vote.",
	parameters = {
		{
			name = "ply",
			description = "The player.",
			type = "Player"
		},
		{
			name = "vote",
			description = "Table containing all information about the vote.",
			type = "table"
		}
	},
	returns = {
		{
			name = "canVote",
			description = "Whether the player can vote.",
			type = "boolean"
		},
		{
			name = "message",
			description = "The message to show when the player cannot vote. Only useful when canVote is false.",
			type = "string"
		}
	}
}

DarkRP.hookStub{
	name = "playerGetSalary",
	description = "When a player receives salary.",
	parameters = {
		{
			name = "ply",
			description = "The player who is receiving salary.",
			type = "Player"
		},
		{
			name = "amount",
			description = "The amount of money given to the player.",
			type = "number"
		}
	},
	returns = {
		{
			name = "suppress",
			description = "Suppress the salary message.",
			type = "boolean"
		},
		{
			name = "message",
			description = "Override the default message (suppress must be false).",
			type = "string"
		},
		{
			name = "amount",
			description = "Override the salary.",
			type = "number"
		}
	}
}

DarkRP.hookStub{
	name = "playerWalletChanged",
	description = "When a player receives money.",
	parameters = {
		{
			name = "ply",
			description = "The player who is getting money.",
			type = "Player"
		},
		{
			name = "amount",
			description = "The amount of money given to the player.",
			type = "number"
		},
		{
			name = "wallet",
			description = "How much money the player had before receiving the money.",
			type = "number"
		}
	},
	returns = {
		{
			name = "total",
			description = "Override the total amount of money (optional).",
			type = "number"
		}
	}
}

DarkRP.hookStub{
	name = "playerClassVarsApplied",
	description = "When a player has had GMod player class variables applied to them through ply:applyPlayerClassVars().",
	parameters = {
		{
			name = "ply",
			description = "The player in question.",
			type = "Player"
		}
	},
	returns = {}
}
