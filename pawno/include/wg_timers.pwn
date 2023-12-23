function timer_Jail(playerid)
{
	if (--Player(playerid, Jailed) <= 0)
	{
		new query[100];
		
		Query("UPDATE `users` SET `jail_time`='0' WHERE `id`='%i'", Player(playerid, UserID));
		mysql_tquery(connection, query, "ExecuteQuery", "i", res_none);

		KillTimer(Timer(playerid, Jail));
		Timer(playerid, Jail) = -1;
		Player(playerid, Jailed) = 0;

	    SendClientMessage(playerid, c_green, "You have been unjailed.");
		GameTextForPlayer(playerid, ""#TXT_LINE"~g~unjailed", 1000, 3);
		ProtectedSpawn(playerid);
	}
	else
	{
	    new minutes, seconds;

	    seconds = (Player(playerid, Jailed) % 60);
	    minutes = (Player(playerid, Jailed) - seconds) / 60;
		GameTextForPlayer(playerid, sprintf(""#TXT_LINE"~r~jail time: ~w~%02i:%02i", minutes, seconds), 999999, 3);
	}
}

function timer_Global()
{
	new players[MAX_CZ];

	foreach(new i : Player)
	{
	    if (Var(i, CappingZone) != -1)
		{
		    if (IsPlayerInAnyVehicle(i))
			{
				SendClientMessage(i, c_red, "* You must be on foot in order to capture zones.");
				zone_StopCapture(i);
				break;
			}
		    players[Var(i, CappingZone)]++;
		}
	}

	foreach(new i : Zones)
	{
	    if (Flag(i, Captured))
		{
	        if (Flag(i, Time) != 0 && gettime() > Flag(i, Time))
			{
				Flag(i, CapturedTeam) = 0;
         		Flag(i, Time) = 0;
         		Flag(i, Captured) = false;
         		zone_RecreateFlag(i);
	        }
	        else
			{
			    new teamid, time;

				teamid = Flag(i, CapturedTeam);
			    time = ConvertTime(Flag(i, Time), MINUTES);
	            UpdateDynamic3DTextLabelText(Flag(i, FlagLabel), -1, sprintf("This zone's flag was captured by {%06x}%s\n"#sc_white"Next flag will appear in %i minutes.", (Team(teamid, Color) >>> 8), Team(teamid, Name), time));
	        }
	    }

	    if (Zone(i, Capturing))
		{
			if (Zone(i, CapTime) >= Zone(i, TotalCapTime) - 1.0)
			{
		        new _team;

				_team = Zone(i, Team);
				Zone(i, CapTime) = 0;
		        Zone(i, Capturing) = false;
		        Zone(i, Team) = Zone(i, CapturingTeam);

				GangZoneStopFlashForAll(Zone(i, Zone));
				GangZoneShowForAll(Zone(i, Zone), (Team(Zone(i, Team), Color) & opacity));
				UpdateDynamic3DTextLabelText(Zone(i, Label), -1, sprintf("%s, captured by the {%06x}%s\n\n"#sc_white"Capture time: %is\nZone score: +%i", Zone(i, Name), (Team(Zone(i, Team), Color) >>> 8), Team(Zone(i, Team), Name), floatround(Zone(i, TotalCapTime)), Zone(i, Score)));
				
				foreach(new j : Player)
				{
				    if (Var(j, CappingZone) == i)
					{
						Var(j, CappingZone) = -1;
						Zone(i, CappingPlayer) = -1;
						DisablePlayerCheckpoint(j);
						SetPlayerProgressBarMaxValue(j, g_TextDraw[j][ZoneBar], 0.0);
						HidePlayerProgressBar(j, g_TextDraw[j][ZoneBar]);

					    if (Var(j, Assisting))
						{
							SendClientMessage(j, -1, "You received +1 score for assisting your teammate to capture this zone.");
					        Var(j, Assisting) = false;
							RewardPlayer(j, 0, 1, true);
						}
						else
						{
						    if (Player(j, ClanID) != -1)
							{
							    new clanid;

								clanid = Player(j, ClanID);
							    clan_GivePoints(clanid, 1);
							    clan_SendMessage(clanid, c_clan, sprintf("Clan '%s' received +1 point from %s's capture.", Clan(clanid, Name), playerName(j)));
							}

						    new cash, score, team, boost_active;

							score = Zone(i, Score);
							team = Player(j, Team);
							boost_active = IsItemActivated(Player(j, BoostActivated));
							cash = (score * 1000) - RandomEx(100, 500);

							SendClientMessage(j, c_green, sprintf("You received +%i score and $%i for capturing the %s for team %s.", score, cash, Zone(i, Name), Team(team, Name)));
							ScreenMessage(j, "ZONE CAPTURED", sprintf("~y~~h~+%i SCORE", score));
							RewardPlayer(j, cash, score, true);
							
							if (boost_active)
							{
								RewardPlayer(j, cash, score);
							    SendClientMessage(j, c_darkgreen, sprintf("VIP Boost: "#sc_white"You received extra %i score, 1 capture and $%i.", score, cash));
							}
							
							PlayerPlaySound(j, 4203, 0.0, 0.0, 0.0);
							Var(j, RecentZone) = i;
							
							Player(j, CapturedZones) += (boost_active) ? 2 : 1;
							++Player(j, ZoneStreak);
							++Player(j, SessionCaps);

						   	News(sprintf("~w~~h~%s has captured the %s for team %s", playerName(j), Zone(i, Name), Team(team, Name)));
                            IRC_Echo(g_IRC_Conn[IRC_MAIN_CHANNEL], sprintf("7[ZONE] %s has captured the %s for team %s!", playerName(j), Zone(i, Name), Team(team, Name)));
                            SpreeMessage(j, 1);
							
							if (Var(j, SquadID) != -1)
							{
							    new sq_reward;

								sq_reward = RandomEx(100, 1000);
								squad_Reward(j, sq_reward, 1, sprintf("The squad received +$%i and +1 score from %s's capture.", sq_reward, playerName(j)));
							}
							
							foreach(new k : Player)
							{
							    if (!Var(k, DM))
								{
								    if (Player(k, Team) == team)
									{
							   	        if (j != k)
						   				{
									   		SendClientMessage(k, c_lightyellow, sprintf("Team %s received $2000 and +1 score from %s's capture.", Team(team, Name), playerName(j)));
											RewardPlayer(k, 2000, 1);
										}
										if (i == 17)
										{
											SendClientMessage(k, c_lightgrey, "The Ammunation will supply you with +10 ammo every 60 seconds until your team loses it.");
											Zone(i, AmmoTime) = 60;
										}
							   		}
									else
									{
										if (Player(k, Team) == _team)
										{
										    SendClientMessage(k, c_red, sprintf("Your team lost 1 score for losing the %s.", Zone(i, Name)));
											RewardPlayer(k, 0, -1);
										}
									}
								}
							}
	      				}
					}
				}
		    }
		    else
			{
				Zone(i, CapTime) += float(players[i]) + cap_Time[Player(Zone(i, CappingPlayer), VIP)][0];
			}
		}
		
		if (!i || i != -1 && i == 17 && Zone(i, Team) != 0)
		{
			if (--Zone(i, AmmoTime) <= 0)
			{
			    Zone(i, AmmoTime) = 60;
				foreach(new x : Player)
				{
				    if (Var(x, Spawned) && Zone(i, Team) == Player(x, Team))
					{
						switch (GetPlayerWeapon(x))
						{
						    case 22..34:
							{
								GivePlayerWeapon(x, GetPlayerWeapon(x), 10);
							}
						}
					}
				}
			}
		}
	}

	foreach(new i : Player)
	{
	    if (Var(i, CappingZone) != -1)
		{
	    	if (GetPlayerState(i) == PLAYER_STATE_ONFOOT)
			{
				SetPlayerProgressBarValue(i, g_TextDraw[i][ZoneBar], Zone(Var(i, CappingZone), CapTime) + 1);
				ShowPlayerProgressBar(i, g_TextDraw[i][ZoneBar]);
			}
		}
	}
	
	if (Nuke(Time) != 0 && Nuke(Time) < gettime())
	{
	    Nuke(Object) = CreateDynamicObject(3258, nuke_X, nuke_Y, nuke_Z, 0.0, 0.0, 0.0, -1, -1, -1, 5000.0, 1000.0);
	    Nuke(Type) = 0;
        Nuke(Time) = 0;
        Nuke(AffectedArea) = -1;
        Nuke(TimeAffected) = 0;
        
	    SendClientMessageToAll(c_lightyellow, "*** The nuclear bomb is now ready for launch.");
	}

	if (Server(RadioFixTime) != 0 && Server(RadioFixTime) < gettime())
	{
	    foreach(new i : Teams)
	    {
	        if (Team(i, RadioBroken) == true)
	        {
	            Team(i, RadioBroken) = false;
			}
		}

	    Server(RadioFixTime) = 0;
	    SendClientMessageToAll(c_lightyellow, "*** The radio damage feature is now ready for use, previously damaged radio as been fixed.");
	}

	if (Server(RadioHackTime) != 0 && Server(RadioHackTime) < gettime())
	{
	    Team(Server(RadioHackedTeam), RadioHackingTeam) = 0;
	    Server(RadioHackTime) = 0;
	    Server(RadioHackedTeam) = 0;

	    SendClientMessageToAll(c_lightyellow, "*** The radio hack is now ready for use.");
	}
	
	if (Server(SAMTime) != 0 && Server(SAMTime) < gettime())
	{
	    Server(SAMTime) = 0;
	    SendClientMessageToAll(c_lightyellow, "* The SAM missile is now ready for launch.");
	}
	
	if (Nuke(AffectedArea) != -1)
	{
		nuke_CheckAffectedArea();
	}
	
	bridge_Check();
}

function timer_RandMsg()
{
    SendClientMessageToAll(0x03B8FCFF, g_TimedMsgs[Server(TimedMsg)++]);
	
	if (Server(TimedMsg) == sizeof(g_TimedMsgs))
	{
	    Server(TimedMsg) = 0;
	}
}

function timer_UpdatePlayers()
{
	foreach(new i : Player)
	{
		UpdatePlayer(i);
	}
}

function timer_AndromadaLoad(vehicleid)
{
	if (Vehicle(vehicleid, BombLoadTimer) != -1)
	{
		if (++Vehicle(vehicleid, BombLoadCounter) >= 100)
		{
		    Vehicle(vehicleid, BombLoadCounter) = 0;
			KillTimer(Vehicle(vehicleid, BombLoadTimer));
	        Vehicle(vehicleid, BombLoadTimer) = -1;
			UpdateDynamic3DTextLabelText(Vehicle(vehicleid, TimeDisplayLabel), -1, "");
		    SendClientMessageToAll(c_lightyellow, "*** The Andromada has been fully loaded.");
		}
		else
		{
			UpdateDynamic3DTextLabelText(Vehicle(vehicleid, TimeDisplayLabel), -1, sprintf("Loading...\n%i%", Vehicle(vehicleid, BombLoadCounter)));
		}
	}
}

function timer_GroundZero()
{
	if (Server(GroundZeroTime) < 100)
	{
	    if (++Server(GroundZeroTime) >= 100)
	    {
	        Server(GroundZeroTime) = 100;
	        UpdateDynamic3DTextLabelText(Server(GroundZeroTimeDisp), -1, "Ground Zero\nThe weapons are fully charged\nPress 'Y' to open menu");
	        SendClientMessageToAll(c_lightyellow, "Ground Zero: The weapons have been fully charged.");
	    }
		else
		{
			UpdateDynamic3DTextLabelText(Server(GroundZeroTimeDisp), -1, sprintf("Ground Zero\nThe weapons are currently charging\n%i%s", Server(GroundZeroTime), "%"));
		}
	}
}
