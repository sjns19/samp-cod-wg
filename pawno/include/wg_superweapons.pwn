function Andromada_BombDrop(playerid, vehicleid, team)
{
	new Float:x, Float:y, Float:z, count = 0;

	foreach(new i : Player)
	{
	    if (IsPlayerInDynamicArea(i, Team(team, ZoneArea)))
		{
		    if (Player(i, Team) != Player(playerid, Team))
			{
		        if (!Var(i, Duty))
				{
				    SetPlayerHealth(i, 0.0);
				    GetPlayerPos(i, x, y, z);

				    CreateExplosion(x, y, z, 3, 10.0);
					SendDeathMessage(playerid, i, 51);

					SendClientMessage(playerid, -1, sprintf("You received +$2000 for killing %s.", playerName(i)));
					SendClientMessage(i, c_red, sprintf("You have been killed by the bombs dropped by pilot %s.", playerName(playerid)));
					++count;
				}
			}
		}
	}

	if (count)
	{
	    Player(playerid, Kills) += count;
		UpdateBoard(playerid);
		SendClientMessageToAll(c_red, "");
	    SendClientMessageToAll(c_red, sprintf("*** Bombs dropped by pilot %s killed %i people at %s's base.", playerName(playerid), count, Team(team, Name)));
        SendClientMessageToAll(c_red, "");
	}
	else
	{
		SendClientMessageToAll(c_red, sprintf("Bombs dropped by pilot %s did not kill anyone.", playerName(playerid)));
	}
}

nuke_Blast()
{
    new id, playerid, tmp_area, teamid, count = 0;

	playerid = Nuke(Player);
	Nuke(Player) = INVALID_PLAYER_ID;
	teamid = Player(playerid, Team);

	switch (Nuke(Type))
	{
	    case NUKE_TYPE_ZONE:
		{
	    	id = Nuke(RecentZone);
			tmp_area = Zone(id, Area);
	    	SendClientMessageToAll(c_red, sprintf("Team %s has launched the nuclear bomb to %s.", Team(teamid, Name), Zone(id, Name)));
	    	SendClientMessage(playerid, c_green, sprintf("Successfully nuked %s for $200000.", Zone(id, Name)));
		}
		case NUKE_TYPE_BASE:
		{
		    id = Nuke(RecentTeam);
			tmp_area = Team(id, ZoneArea);
			SendClientMessageToAll(Team(id, Color), sprintf("Team %s has launched the nuclear bomb to %s's base.", Team(teamid, Name), Team(id, Name)));
            SendClientMessage(playerid, c_green, sprintf("Successfully nuked %s's base for $200000.", Team(id, Name)));
		}
	}

	RewardPlayer(playerid, -200000, 0);
    DestroyDynamicObject(Nuke(Object));

	SetWeather(19);
	SetTimer("reset_Dust", 15000, 0);

	Nuke(AffectedArea) = tmp_area;
	Nuke(TimeAffected) = 30;

	foreach(new i : Player)
	{
        if (Player(i, Team) != Player(playerid, Team))
		{
			if (IsPlayerInDynamicArea(i, tmp_area))
			{
	            if (!Var(i, Duty))
				{
					SendClientMessage(playerid, -1, sprintf("You received $1000 and +1 for killin %s with the launched nuke.", playerName(i)));
					SendClientMessage(i, c_red, sprintf("You have been killed by the nuclear bomb launched by the %s.", Team(teamid, Name)));
					
					if (!Player(i, Protected))
					{
		            	SetPlayerHealth(i, 0.0);
					}
					
					GameTextForPlayer(i, ""#TXT_LINE"~r~nuked", 2000, 3);
		            SendDeathMessage(playerid, i, 47);
					++count;
	 			}
			}
		}
	}
	
	SendClientMessageToAll(-1, "");
	SendClientMessageToAll(c_tomato, sprintf("Total of %i people died from the nuclear bomb attack.", count));
    SendClientMessageToAll(c_tomato, "* The nuked area is now affected. Anyone in the area without mask will lose -5HP every 30 seconds.");
	SendClientMessageToAll(-1, "");
	SendClientMessageToAll(c_grey, "* To wipe out the nuclear effect, capture the Abandoned Airport.");
	
	if (count)
	{
		RewardPlayer(playerid, (count * 2000), count, true);
		Player(playerid, Kills) += count;
	}
	else
	{
		SendClientMessageToAll(c_red, "* The nuclear bomb did not kill anyone.");
	}

	return 1;
}

function reset_Dust()
{
	return SetWeather(DEFAULT_WEATHER);
}

nuke_Launch(playerid, id, type)
{
	switch (type)
	{
	    case NUKE_TYPE_ZONE: Nuke(RecentZone) = id;
		case NUKE_TYPE_BASE: Nuke(RecentTeam) = id;
	}

    GameTextForPlayer(playerid, ""#TXT_LINE"~y~~h~launching...", 3000, 3);
	MoveDynamicObject(Nuke(Object), 268.70752, 1883.76501, 349.00388, 60.0, 0.0, 0.0, 0.0);
	Nuke(Time) = gettime() + 620;
	Nuke(Type) = type;
	Nuke(Player) = playerid;
}

nuke_CheckAffectedArea()
{
	if (--Nuke(TimeAffected) <= 0)
	{
	    new Float:health;

		foreach(new i : Player)
		{
			if (IsPlayerInDynamicArea(i, Nuke(AffectedArea)))
			{
			    if (Var(i, Spawned) && !Var(i, Duty))
				{
			        if (!Player(i, VIP) && !Var(i, Mask) && !Player(i, Protected))
					{
					    GetPlayerHealth(i, health);
					    SetPlayerHealth(i, health - 5.0);
					}
				}
			}
		}
		Nuke(TimeAffected) = 30;
	}
}

nuke_ReturnAffectedAreaName()
{
	new name[25];

    if (Zone(Nuke(RecentZone), Area) == Nuke(AffectedArea))
	{
        Format:name("%s", Zone(Nuke(RecentZone), Name));
	}
	else if (Team(Nuke(RecentTeam), ZoneArea) == Nuke(AffectedArea))
	{
		Format:name("%s's base", Team(Nuke(RecentTeam), Name));
	}

	return name;
}

sam_Launch(playerid, areaid, type)
{
	new tmp_area, areaname[36];

	switch (type)
	{
		case SAM_TYPE_ZONE:
		{
			tmp_area = Zone(areaid, Area);
			format(areaname, 36, "%s", Zone(areaid, Name));
		}

		case SAM_TYPE_BASE:
		{
			tmp_area = Team(areaid, ZoneArea);
			format(areaname, 36, "%s", Team(areaid, Name));
		}
	}

	RewardPlayer(playerid, -10000, 0);
	SendClientMessageToAll(c_tomato, sprintf("* Area 51 SAM: The missile has targeted %s's airspace.", areaname));
	CreateExplosion(340.7094, 2013.0056, 34.9102, 2, 2.0);
	CreateExplosion(336.3549, 2019.1854, 35.0603, 2, 2.0);
	Server(SAMTime) = gettime() + 320;

	new Float:x, Float:y, Float:z, count = 0, vehicleid;

	foreach(new i : Player)
	{
	    vehicleid = GetPlayerVehicleID(i);
	    
	    if (vehicle_IsAircraft(vehicleid))
		{
	        if (Player(i, Team) != Player(playerid, Team))
			{
				if (IsPlayerInDynamicArea(i, tmp_area))
				{
		            if (!Var(i, Duty) && !Player(i, Protected))
					{
					    GetPlayerPos(i, x, y, z);

						SendClientMessage(playerid, -1, sprintf("You received $1000 and +1 score for destroying %s's aircraft.", playerName(i)));
						SendClientMessage(i, c_red, sprintf("Your aircraft has been destroyed by the SAM missile launched by %s.", playerName(playerid)));

						SetPlayerHealth(i, 0.0);
						CreateExplosion(x, y, z, 5, 2.0);
						GameTextForPlayer(i, ""#TXT_LINE"~r~destroyed", 2000, 3);
			            SendDeathMessage(playerid, i, 47);
						++count;
		 			}
				}
			}
		}
	}
	
	if (count)
	{
		RewardPlayer(playerid, (count * 2000), count, true);
		Player(playerid, Kills) += count;
	}
	else
	{
		SendClientMessage(playerid, c_red, "* The SAM missile did not destroy any aircraft.");
	}
	
	return 1;
}
