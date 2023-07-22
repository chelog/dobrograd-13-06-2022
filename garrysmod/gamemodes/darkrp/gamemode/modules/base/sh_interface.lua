DarkRP.findPlayer = DarkRP.stub{
	name = "findPlayer",
	description = "Find a single player based on vague information.",
	parameters = {
		{
			name = "info",
			description = "The information of the player (UserID, SteamID, name).",
			type = "string",
			optional = false
		}
	},
	returns = {
		{
			name = "found",
			description = "The player that matches the description.",
			type = "Player"
		}
	},
	metatable = DarkRP
}

DarkRP.findPlayers = DarkRP.stub{
	name = "findPlayers",
	description = "Find a list of players based on vague information.",
	parameters = {
		{
			name = "info",
			description = "The information of the player (UserID, SteamID, name).",
			type = "string",
			optional = false
		}
	},
	returns = {
		{
			name = "found",
			description = "Table of players that match the description.",
			type = "table"
		}
	},
	metatable = DarkRP
}

DarkRP.nickSortedPlayers = DarkRP.stub{
	name = "nickSortedPlayers",
	description = "A table of players sorted by RP name.",
	parameters = {},
	returns = {
		{
			name = "players",
			description = "The list of players sorted by RP name.",
			type = "table"
		}
	},
	metatable = DarkRP
}

DarkRP.explodeArg = DarkRP.stub{
	name = "explodeArg",
	description = "String arguments exploded into a table. It accounts for substrings in quotes, which makes it more intelligent than string.Explode",
	parameters = {
		{
			name = "arg",
			description = "The full string of the argument",
			type = "string",
			optional = false
		},
	},
	returns = {
		{
			name = "args",
			description = "The table of arguments",
			type = "table"
		}
	},
	metatable = DarkRP
}


DarkRP.formatMoney = DarkRP.stub{
	name = "formatMoney",
	description = "Format a number as a money value. Includes currency symbol.",
	parameters = {
		{
			name = "amount",
			description = "The money to format, e.g. 100000.",
			type = "number",
			optional = false
		}
	},
	returns = {
		{
			name = "money",
			description = "The money as a nice string, e.g. \"$100,000\".",
			type = "string"
		}
	},
	metatable = DarkRP
}

DarkRP.getJobByCommand = DarkRP.stub{
	name = "getJobByCommand",
	description = "Get the job table and number from the command of the job.",
	parameters = {
		{
			name = "command",
			description = "The command of the job, without preceding slash (e.g. 'medic' for medic)",
			type = "string",
			optional = false
		}
	},
	returns = {
		{
			name = "tbl",
			description = "A table containing all information about the job.",
			type = "table"
		},
		{
			name = "jobindex",
			description = "The index of the job (for 'medic' it's the value of TEAM_MEDIC).",
			type = "number"
		}
	},
	metatable = DarkRP
}

DarkRP.simplerrRun = DarkRP.stub{
	name = "simplerrRun",
	description = "Run a function with the given parameters and send any runtime errors to admins.",
	parameters = {
		{
			name = "f",
			description = "The function to be called.",
			type = "function",
			optional = false
		},
		{
			name = "args",
			description = "The arguments to be given to f.",
			type = "vararg",
			optional = true
		},
	},
	returns = {
		{
			name = "retVals",
			description = "The return values of f.",
			type = "vararg"
		}
	},
	metatable = DarkRP
}

DarkRP.error = DarkRP.stub{
	name = "error",
	description = "Throw a simplerr formatted error. Also halts the stack, which means that statements after calling this function will not execute.",
	parameters = {
		{
			name = "message",
			description = "The message of the error.",
			type = "string",
			optional = false
		},
		{
			name = "stack",
			description = "From which point in the function call stack to report the error. 1 to include the function that called DarkRP.error, 2 to exclude it, etc. The default value is 1.",
			type = "number",
			optional = true
		},
		{
			name = "hints",
			description = "Table containing hint strings. Use these hints to explain the error, describe possible causes or provide help to solve the problem.",
			type = "table",
			optional = true
		},
		{
			name = "path",
			description = "Override the path of the error. Will be shown in the error message. By default this is determined by the stack level.",
			type = "string",
			optional = true
		},
		{
			name = "line",
			description = "Override the line number of the error. By default this is determined by the stack level.",
			type = "number",
			optional = true
		},

	},
	returns = {
		{
			name = "succeed",
			description = "Simplerr return value: whether the calculation succeeded. Always false. This return value will never be reached.",
			type = "boolean"
		},
		{
			name = "msg",
			description = "Simplerr return value: nicely formatted error message. This return value will never be reached.",
			type = "string"
		}
	},
	metatable = DarkRP
}

DarkRP.errorNoHalt = DarkRP.stub{
	name = "errorNoHalt",
	description = "Throw a simplerr formatted error. Unlike DarkRP.error, this does not halt the stack. This means that statements after calling this function will be executed like normal.",
	parameters = {
		{
			name = "message",
			description = "The message of the error.",
			type = "string",
			optional = false
		},
		{
			name = "stack",
			description = "From which point in the function call stack to report the error. 1 to include the function that called DarkRP.error, 2 to exclude it, etc. The default value is 1.",
			type = "number",
			optional = true
		},
		{
			name = "hints",
			description = "Table containing hint strings. Use these hints to explain the error, describe possible causes or provide help to solve the problem.",
			type = "table",
			optional = true
		},
		{
			name = "path",
			description = "Override the path of the error. Will be shown in the error message. By default this is determined by the stack level.",
			type = "string",
			optional = true
		},
		{
			name = "line",
			description = "Override the line number of the error. By default this is determined by the stack level.",
			type = "number",
			optional = true
		},

	},
	returns = {
		{
			name = "succeed",
			description = "Simplerr return value: whether the calculation succeeded. Always false.",
			type = "boolean"
		},
		{
			name = "msg",
			description = "Simplerr return value: nicely formatted error message.",
			type = "string"
		}
	},
	metatable = DarkRP
}

-- This function is one of the few that's already defined before the stub is created
DarkRP.stub{
	name = "SteamName",
	description = "Retrieve a player's real (steam) name.",
	parameters = {

	},
	returns = {
		{
			name = "name",
			description = "The player's steam name.",
			type = "string"
		}
	},
	metatable = DarkRP.PLAYER
}

DarkRP.PLAYER.getJobTable = DarkRP.stub{
	name = "getJobTable",
	description = "Get the job table of a player.",
	parameters = {
	},
	returns = {
		{
			name = "job",
			description = "Table with the job information.",
			type = "table"
		}
	},
	metatable = DarkRP.PLAYER
}

DarkRP.PLAYER.getAgenda = DarkRP.stub{
	name = "getAgenda",
	description = "Get the agenda a player manages.",
	deprecated = "Use ply:getAgendaTable() instead.",
	parameters = {
	},
	returns = {
		{
			name = "agenda",
			description = "The agenda.",
			type = "table"
		}
	},
	metatable = DarkRP.PLAYER
}

DarkRP.PLAYER.getAgendaTable = DarkRP.stub{
	name = "getAgendaTable",
	description = "Get the agenda a player can see. Note: when a player is not the manager of an agenda, it returns the agenda of the manager.",
	parameters = {
	},
	returns = {
		{
			name = "agenda",
			description = "The agenda.",
			type = "table"
		}
	},
	metatable = DarkRP.PLAYER
}

DarkRP.PLAYER.hasDarkRPPrivilege = DarkRP.stub{
	name = "hasDarkRPPrivilege",
	description = "Whether the player has a certain privilege.",
	parameters = {
		{
			name = "priv",
			description = "The name of the privilege.",
			type = "string",
			optional = false
		}
	},
	returns = {
		{
			name = "answer",
			description = "Whether the player has the privilege.",
			type = "boolean"
		}
	},
	metatable = DarkRP.PLAYER
}

DarkRP.PLAYER.getEyeSightHitEntity = DarkRP.stub{
	name = "getEyeSightHitEntity",
	description = "Get the entity that is closest to a player's line of sight and its distance.",
	parameters = {
		{
			name = "searchDistance",
			description = "How far to look. You usually don't want this function to return an entity millions of units away. The default is 100 units.",
			type = "number",
			optional = true
		},
		{
			name = "hitDistance",
			description = "The maximum distance between the player's line of sight and the object. Basically how far the player can be 'looking away' from the object. The default is 15 units.",
			type = "number",
			optional = true
		},
		{
			name = "filter",
			description = "The filter for which entities to look for. By default it only looks for players.",
			type = "function",
			optional = true
		}
	},
	returns = {
		{
			name = "closestEnt",
			description = "The entity that is closest to the player's line of sight. Returns nil when not found.",
			type = "Entity"
		},
		{
			name = "distance",
			description = "The (minimum) distance between the player's line of sight and the object.",
			type = "number"
		}
	},
	metatable = DarkRP.PLAYER
}

DarkRP.VECTOR.isInSight = DarkRP.stub{
	name = "isInSight",
	description = "Decides whether the vector could be seen by the player if they were to look at it.",
	parameters = {
		{
			name = "filter",
			description = "Trace filter that decides what the player can see through.",
			type = "table",
			optional = false
		},
		{
			name = "ply",
			description = "The player for whom the vector may or may not be visible.",
			type = "Player",
			optional = false
		}
	},
	returns = {
		{
			name = "answer",
			description = "Whether the player can see the position.",
			type = "boolean"
		},
		{
			name = "HitPos",
			description = "The position of the thing that blocks the player's sight.",
			type = "Vector"
		}
	},
	metatable = DarkRP.VECTOR
}

DarkRP.hookStub{
	name = "UpdatePlayerSpeed",
	description = "Change a player's walking and running speed.",
	deprecated = "Use GMod's SetupMove and Move hooks instead.",
	parameters = {
		{
			name = "ply",
			description = "The player for whom the speed changes.",
			type = "Player"
		}
	},
	returns = {
	}
}

/*---------------------------------------------------------------------------
Creating custom items
---------------------------------------------------------------------------*/
DarkRP.createJob = DarkRP.stub{
	name = "createJob",
	description = "Create a job for DarkRP.",
	parameters = {
		{
			name = "name",
			description = "The name of the job.",
			type = "string",
			optional = false
		},
		{
			name = "tbl",
			description = "Table containing the information for the job.",
			type = "table",
			optional = false
		}
	},
	returns = {
		{
			name = "team",
			description = "The team number of the job you've created.",
			type = "number"
		}
	},
	metatable = DarkRP
}
AddExtraTeam = DarkRP.createJob

DarkRP.removeJob = DarkRP.stub{
	name = "removeJob",
	description = "Remove a job from DarkRP.",
	parameters = {
		{
			name = "i",
			description = "The TEAM_ number of the job. Also the index of the job in RPExtraTeams.",
			type = "number",
			optional = false
		}
	},
	returns = {
	},
	metatable = DarkRP
}

DarkRP.removeAgenda = DarkRP.stub{
	name = "removeAgenda",
	description = "Remove a agenda from DarkRP. NOTE: Must be called from BOTH server AND client to properly get it removed!",
	parameters = {
		{
			name = "name",
			description = "The name of the item.",
			type = "string",
			optional = false
		}
	},
	returns = {
	},
	metatable = DarkRP
}

DarkRP.createAgenda = DarkRP.stub{
	name = "createAgenda",
	description = "Create an agenda for groups of jobs to communicate.",
	parameters = {
		{
			name = "title",
			description = "The name of the agenda.",
			type = "string",
			optional = false
		},
		{
			name = "manager",
			description = "The team numer of the manager of the agenda (the one who can set the agenda).",
			type = "number",
			optional = false
		},
		{
			name = "listeners",
			description = "The jobs that can see this agenda.",
			type = "table",
			optional = false
		}
	},
	returns = {
	},
	metatable = DarkRP
}
AddAgenda = DarkRP.createAgenda

DarkRP.getAgendas = DarkRP.stub{
	name = "getAgendas",
	description = "Get all agendas. Note: teams that share an agenda use the exact same agenda table. E.g. when you change the agenda of the CP, the agenda of the Chief will automatically be updated as well. Make sure this property is maintained when modifying the agenda table. Not maintaining that property will lead to players not seeing the right agenda text.",
	parameters = {

	},
	returns = {
		{
			name = "agendas",
			description = "Table in which the keys are team numbers and the values agendas.",
			type = "table"
		}
	},
	metatable = DarkRP
}

DarkRP.hookStub{
	name = "DarkRPVarChanged",
	description = "Called when a DarkRPVar was changed.",
	parameters = {
		{
			name = "ply",
			description = "The player for whom the DarkRPVar changed.",
			type = "Player"
		},
		{
			name = "varname",
			description = "The name of the variable that has changed.",
			type = "string"
		},
		{
			name = "oldValue",
			description = "The old value of the DarkRPVar.",
			type = "any"
		},
		{
			name = "newvalue",
			description = "The new value of the DarkRPVar.",
			type = "any"
		}
	},
	returns = {
	}
}

DarkRP.hookStub{
	name = "canBuyPistol",
	description = "Whether a player can buy a pistol.",
	parameters = {
		{
			name = "ply",
			description = "The player.",
			type = "Player"
		},
		{
			name = "shipmentTable",
			description = "The table, as defined in the shipments file.",
			type = "table"
		}
	},
	returns = {
		{
			name = "canBuy",
			description = "Whether it can be bought.",
			type = "boolean"
		},
		{
			name = "suppressMessage",
			description = "Suppress the notification message when it cannot be bought.",
			type = "boolean"
		},
		{
			name = "message",
			description = "A replacement for the message that shows if it cannot be bought.",
			type = "string"
		},
		{
			name = "price",
			description = "An optional override for the price.",
			type = "number"
		}
	}
}

DarkRP.hookStub{
	name = "canBuyShipment",
	description = "Whether a player can buy a shipment.",
	parameters = {
		{
			name = "ply",
			description = "The player.",
			type = "Player"
		},
		{
			name = "shipmentTable",
			description = "The table, as defined in the shipments file.",
			type = "table"
		}
	},
	returns = {
		{
			name = "canBuy",
			description = "Whether it can be bought.",
			type = "boolean"
		},
		{
			name = "suppressMessage",
			description = "Suppress the notification message when it cannot be bought.",
			type = "boolean"
		},
		{
			name = "message",
			description = "A replacement for the message that shows if it cannot be bought.",
			type = "string"
		},
		{
			name = "price",
			description = "An optional override for the price.",
			type = "number"
		}
	}
}

DarkRP.hookStub{
	name = "canBuyVehicle",
	description = "Whether a player can buy a vehicle.",
	parameters = {
		{
			name = "ply",
			description = "The player.",
			type = "Player"
		},
		{
			name = "vehicleTable",
			description = "The table, as defined in the vehicles file.",
			type = "table"
		}
	},
	returns = {
		{
			name = "canBuy",
			description = "Whether it can be bought.",
			type = "boolean"
		},
		{
			name = "suppressMessage",
			description = "Suppress the notification message when it cannot be bought.",
			type = "boolean"
		},
		{
			name = "message",
			description = "A replacement for the message that shows if it cannot be bought.",
			type = "string"
		},
		{
			name = "price",
			description = "An optional override for the price.",
			type = "number"
		}
	}
}

DarkRP.hookStub{
	name = "canBuyAmmo",
	description = "Whether a player can buy ammo.",
	parameters = {
		{
			name = "ply",
			description = "The player.",
			type = "Player"
		},
		{
			name = "ammoTable",
			description = "The table, as defined in the a ammo file.",
			type = "table"
		}
	},
	returns = {
		{
			name = "canBuy",
			description = "Whether it can be bought.",
			type = "boolean"
		},
		{
			name = "suppressMessage",
			description = "Suppress the notification message when it cannot be bought.",
			type = "boolean"
		},
		{
			name = "message",
			description = "A replacement for the message that shows if it cannot be bought.",
			type = "string"
		},
		{
			name = "price",
			description = "An optional override for the price.",
			type = "number"
		}
	}
}

DarkRP.hookStub{
	name = "canBuyCustomEntity",
	description = "Whether a player can a certain custom entity.",
	parameters = {
		{
			name = "ply",
			description = "The player.",
			type = "Player"
		},
		{
			name = "entTable",
			description = "The table, as defined by the user.",
			type = "table"
		}
	},
	returns = {
		{
			name = "canBuy",
			description = "Whether it can be bought.",
			type = "boolean"
		},
		{
			name = "suppressMessage",
			description = "Suppress the notification message when it cannot be bought.",
			type = "boolean"
		},
		{
			name = "message",
			description = "A replacement for the message that shows if it cannot be bought.",
			type = "string"
		},
		{
			name = "price",
			description = "An optional override for the price.",
			type = "number"
		}
	}
}

DarkRP.hookStub{
	name = "onJobRemoved",
	description = "Called when a job was removed.",
	parameters = {
		{
			name = "num",
			description = "The TEAM_ number of the job.",
			type = "number"
		},
		{
			name = "jobbtable",
			description = "The table containing all the job info.",
			type = "table"
		}
	},
	returns = {
	}
}

DarkRP.hookStub{
	name = "onShipmentRemoved",
	description = "Called when a shipment was removed.",
	parameters = {
		{
			name = "num",
			description = "The index of this item.",
			type = "number"
		},
		{
			name = "itemTable",
			description = "The table containing all the info about this item.",
			type = "table"
		}
	},
	returns = {
	}
}

DarkRP.hookStub{
	name = "onVehicleRemoved",
	description = "Called when a vehicle was removed.",
	parameters = {
		{
			name = "num",
			description = "The index of this item.",
			type = "number"
		},
		{
			name = "itemTable",
			description = "The table containing all the info about this item.",
			type = "table"
		}
	},
	returns = {
	}
}

DarkRP.hookStub{
	name = "onEntityRemoved",
	description = "Called when a buyable entity was removed.",
	parameters = {
		{
			name = "num",
			description = "The index of this item.",
			type = "number"
		},
		{
			name = "itemTable",
			description = "The table containing all the info about this item.",
			type = "table"
		}
	},
	returns = {
	}
}

DarkRP.hookStub{
	name = "onGroupChatRemoved",
	description = "Called when a groupchat was removed.",
	parameters = {
		{
			name = "num",
			description = "The index of this item.",
			type = "number"
		},
		{
			name = "itemTable",
			description = "The table containing all the info about this item.",
			type = "table"
		}
	},
	returns = {
	}
}

DarkRP.hookStub{
	name = "onAmmoTypeRemoved",
	description = "Called when a ammotype was removed.",
	parameters = {
		{
			name = "num",
			description = "The index of this item.",
			type = "number"
		},
		{
			name = "itemTable",
			description = "The table containing all the info about this item.",
			type = "table"
		}
	},
	returns = {
	}
}

DarkRP.hookStub{
	name = "onEntityGroupRemoved",
	description = "Called when an entity group was removed.",
	parameters = {
		{
			name = "name",
			description = "The name of this item.",
			type = "string"
		},
		{
			name = "itemTable",
			description = "The table containing all the info about this item.",
			type = "table"
		}
	},
	returns = {
	}
}

DarkRP.hookStub{
	name = "onAgendaRemoved",
	description = "Called when an agenda was removed.",
	parameters = {
		{
			name = "name",
			description = "The name of this item.",
			type = "string"
		},
		{
			name = "itemTable",
			description = "The table containing all the info about this item.",
			type = "table"
		}
	},
	returns = {
	}
}

DarkRP.hookStub{
	name = "onDemoteGroupRemoved",
	description = "Called when a job was demotegroup.",
	parameters = {
		{
			name = "name",
			description = "The name of this item.",
			type = "string"
		},
		{
			name = "itemTable",
			description = "The table containing all the info about this item.",
			type = "table"
		}
	},
	returns = {
	}
}

DarkRP.hookStub{
	name = "loadCustomDarkRPItems",
	description = "Runs right after the scripts from the DarkRPMod are run. You can add custom jobs, entities, shipments and whatever in this hook.",
	parameters = {
	},
	returns = {
	}
}

DarkRP.hookStub{
	name = "DarkRPStartedLoading",
	description = "Runs at the very start of loading DarkRP. Not even sandbox has loaded here yet.",
	parameters = {
	},
	returns = {
	}
}

DarkRP.hookStub{
	name = "DarkRPFinishedLoading",
	description = "Runs right after DarkRP itself has loaded. All DarkRPMod stuff (except for disabled_defaults) is loaded during this hook. NOTE! NO CUSTOM STUFF WILL BE AVAILABLE DURING THIS HOOK. USE `loadCustomDarkRPItems` INSTEAD IF YOU WANT THAT!",
	parameters = {
	},
	returns = {
	}
}
