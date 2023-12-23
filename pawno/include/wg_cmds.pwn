CMD:aroom(playerid, params[])
{
	if (IsAuthorizedLevel(playerid, 1))
	{
		SetPlayerPos(playerid, 2608.3267, -1297.3459, 81.6240);
		SetPlayerFacingAngle(playerid, 180.9439);
		admin_SendMessage(1, ac_cmd1, sprintf("Admin %s has entered the admin room.", playerName(playerid)));
	}
	return 1;
}

CMD:asay(playerid, params[])
{
	if (IsAuthorizedLevel(playerid, 1))
	{
		if (sscanf(params, "s[128]", params))
			return error:_usage(playerid, "/asay <message>");

		SendClientMessageToAll(c_purple, sprintf("> Admin %s said: "#sc_white"%s", playerName(playerid), params));
	}

	return 1;
}

CMD:check(playerid, params[])
{
	if (IsAuthorizedLevel(playerid, 1))
	{
		new id;

		if (sscanf(params, "u", id))
		    return error:_usage(playerid, "/check <playerid/name>");

		if (IsValidTargetPlayer(playerid, id))
		{
		    new Float:hp, Float:armour, int, world, skin, p_state, state_name[20];

		    GetPlayerHealth(id, hp);
		    GetPlayerArmour(id, armour);
			int = GetPlayerInterior(id);
			world = GetPlayerVirtualWorld(id);
			p_state = GetPlayerState(id);
			skin = GetPlayerSkin(id);

			switch (p_state)
			{
			    case 1: state_name = "ON FOOT";
			    case 2: state_name = "DRIVER";
			    case 3: state_name = "PASSENGER";
			    case 9: state_name = "SPECTATING";
			}

			SendClientMessage(playerid, ac_cmd1, sprintf("Check on %s:", playerName(id)));
			SendClientMessage(playerid, ac_cmd1, sprintf("  Health: %0.2f | Armour: %0.2f | Skin: %i | World ID: %i | Interior ID: %i | State: %s (%i)", hp, armour, skin, world, int, state_name, p_state));
			SendClientMessage(playerid, ac_cmd1, sprintf("  Weapons: %s", return_WepList(id)));
			admin_CommandMessage(playerid, "check", id);
		}
	}

	return 1;
}

CMD:muted(playerid, params[])
{
	if (IsAuthorizedLevel(playerid, 1))
	{
	    new count = 0;
	    
	    admin_CommandMessage(playerid, "muted");
        SendClientMessage(playerid, c_grey, "Muted players:");

		foreach(new i : Player)
		{
			if (Player(i, Muted) != 0)
			{
			    SendClientMessage(playerid, c_lightgrey, sprintf("   %s (ID: %i)", playerName(i), i));
			    ++count;
			}
		}

		if (!count)
		{
		    SendClientMessage(playerid, c_red, "None");
		}
	}

	return 1;
}

CMD:jailed(playerid, params[])
{
	if (IsAuthorizedLevel(playerid, 1))
	{
	    new count = 0;
	    
	    admin_CommandMessage(playerid, "jailed");
        SendClientMessage(playerid, c_grey, "Jailed players:");

		foreach(new i : Player)
		{
			if (Player(i, Jailed) != 0)
			{
			    SendClientMessage(playerid, c_lightgrey, sprintf("   %s (ID: %i)", playerName(i), i));
			    ++count;
			}
		}

		if (!count)
		{
		    SendClientMessage(playerid, c_red, "None");
		}
	}

	return 1;
}

CMD:miniguns(playerid, params[])
{
    if (IsAuthorizedLevel(playerid, 1))
	{
	    new count = 0;
	    
	    admin_CommandMessage(playerid, "miniguns");
        SendClientMessage(playerid, c_grey, "Players with minigun:");

		foreach(new i : Player)
		{
			if (!Var(i, Duty))
			{
			    if (GetPlayerWeapon(i) == 38)
				{
				    SendClientMessage(playerid, c_lightgrey, sprintf("   %s (ID: %i)", playerName(i), i));
				    ++count;
				}
			}
		}

		if (!count)
		{
		    SendClientMessage(playerid, c_red, "None");
		}
	}

	return 1;
}

CMD:frozen(playerid, params[])
{
	if (IsAuthorizedLevel(playerid, 1))
	{
	    new count = 0;
	    
	    admin_CommandMessage(playerid, "frozen");
        SendClientMessage(playerid, c_grey, "Frozen players:");

		foreach(new i : Player)
		{
			if (Var(i, Frozen))
			{
			    SendClientMessage(playerid, c_lightgrey, sprintf("   %s (ID: %i)", playerName(i), i));
			    ++count;
			}
		}

		if (!count)
		{
		    SendClientMessage(playerid, c_red, "None");
		}
	}

	return 1;
}

CMD:afk(playerid, params[])
{
	if (IsAuthorizedLevel(playerid, 1))
	{
		new id;

		if (sscanf(params, "u", id))
		    return error:_usage(playerid, "/afk <playerid/name>");

		if (IsValidTargetPlayer(playerid, id))
		{
		    if (IsTargetPlayerSpawned(playerid, id))
			{
				if (!IsPlayerPaused(id))
					SendClientMessage(playerid, c_red, "* Specified player is not AFK.");
				else
				{
					SendClientMessage(playerid, ac_cmd1, sprintf("You have kicked %s for being AFK.", playerName(id)));
					SendClientMessageToAll(c_tomato, sprintf("* Player %s has been kicked from the server for being AFK [Away From Keyboard].", playerName(id)));
					KickEx(id, c_red, "You have been kicked for being AFK [Away From Keyboard]");
					admin_CommandMessage(playerid, "afk", id);
				}
			}
		}
	}

	return 1;
}

CMD:afklist(playerid, params[])
{
	if (IsAuthorizedLevel(playerid, 1))
	{
	    new count = 0, minutes, seconds, total;
	    
	    admin_CommandMessage(playerid, "afklist");
		SendClientMessage(playerid, c_grey, "AFK players:");

		foreach(new i : Player)
		{
		    if (Var(i, Spawned))
			{
				if (IsPlayerPaused(i))
				{
					total = Var(i, PausedFor);
				    seconds = (total % 60);
				    minutes = (total - seconds) / 60;
				    SendClientMessage(playerid, c_lightgrey, sprintf("   %s (ID: %i) [AFK TIME: %02i:%02i]", playerName(i), i, minutes, seconds));
					++count;
				}
			}
		}

		if (!count)
		{
		    SendClientMessage(playerid, c_red, "None");
		}
	}

	return 1;
}

CMD:acmds(playerid, params[])
{
	if (IsAuthorizedLevel(playerid, 1))
	{
	    new level;

	    if (sscanf(params, "i", level))
	        return error:_usage(playerid, "/acmds <level>");
		
		if (Player(playerid, Level) < 5 && level > 4)
		    return SendClientMessage(playerid, c_red, "* You can only view up to level 4.");

		SendClientMessage(playerid, c_blue, sprintf("Admin level %i commands:", level));

		for (new i = 0, j = sizeof(g_AdminCmds); i < j; i++)
		{
		    if (level == g_AdminCmds[i][acmd_Level])
			{
				SendClientMessage(playerid, c_blue, g_AdminCmds[i][acmd_Msg]);
			}
		}

	    admin_CommandMessage(playerid, "acmds", level);	
	}

	return 1;
}

CMD:reports(playerid, params[])
{
	if (IsAuthorizedLevel(playerid, 1))
	{
		admin_CommandMessage(playerid, "reports");

		if (!Report(0, Used))
			return SendClientMessage(playerid, c_red, "* There are no reports logged.");
		
		new text[144];

		SendClientMessage(playerid, ac_cmd1, "Logged reports:");
		Format:text("  1: %s - reported by %s", Report(0, Name), Report(0, Reason));
		SendClientMessage(playerid, ac_cmd1, text);

		for (new i = 1, j = 10; i < j; i++)
		{
			if (Report(i, Used))
			{
	            Format:text("  %i: %s - reported by %s", (i+1), Report(i, Name), Report(i, Reason));
	            SendClientMessage(playerid, ac_cmd1, text);
			}
		}
	}

	return 1;
}

CMD:kick(playerid, params[])
{
	if (IsAuthorizedLevel(playerid, 1))
	{
		new id;

		if (sscanf(params, "us[80]", id, params))
			return error:_usage(playerid, "/kick <playerid/name> <reason>");

		if (strlen(params) > MAX_REASON)
			return SendClientMessage(playerid, c_red, "* Reason length exceeds the maximum characters limit. Limit: 35 chars");
		
		if (IsValidTargetPlayer(playerid, id))
		{
		    if (IsCommandUsable(playerid, id))
			{
				SendClientMessageToAll(c_tomato, sprintf("* Administrator %s[%i] has kicked player %s[%i]. Reason: %s", playerName(playerid), playerid, playerName(id), id, params));
				SendClientMessage(playerid, ac_cmd1, sprintf("You have kicked %s. Reason: %s", playerName(id), params));
				log(sprintf("Admin %s has kicked player %s. Reason: %s", playerName(playerid), playerName(id), params));
				IRC_Echo(g_IRC_Conn[IRC_MAIN_CHANNEL], sprintf("4* Admininistrator %s[%i] has kicked player %s[%i]. Reason: %s", playerName(playerid), playerid, playerName(id), id, params));
				KickEx(id, c_red, sprintf("You have been kicked by admin %s. Reason: %s", playerName(playerid), params));
				admin_CommandMessage(playerid, "kick", id);
			}
		}
	}

	return 1;
}

CMD:spec(playerid,params[])
{
    if (IsAuthorizedLevel(playerid, 1))
	{
        if (Var(playerid, DM) != 0 || Var(playerid, DuelID) != -1)
            return SendClientMessage(playerid, c_red, "* You cannot use this command inside DM arena.");
		
		if (GetPlayerState(playerid) == PLAYER_STATE_WASTED)
			return SendClientMessage(playerid, c_red, "Please wait...");

		new id;

	    if (sscanf(params, "u", id))
			return error:_usage(playerid, "/spec <playerid/name>");
	
		if (IsValidTargetPlayer(playerid, id))
		{
		    if (IsTargetPlayerSpawned(playerid, id))
			{
				if (GetPlayerState(id) == PLAYER_STATE_SPECTATING && Var(id, SpecType) != SPEC_TYPE_NONE)
					return SendClientMessage(playerid, c_red, "* Specified player is currently on spectate mode.");
				
				if (id == playerid)
				  	return SendClientMessage(playerid, c_red, "* You cannot spectate yourself.");

				if (Var(playerid, SpecType) == SPEC_TYPE_NONE)
				{
					GetPlayerPos(playerid, Spec(playerid, X), Spec(playerid, Y), Spec(playerid, Z));
					GetPlayerFacingAngle(playerid, Spec(playerid, A));
	                Spec(playerid, World) = GetPlayerVirtualWorld(playerid);
	                Spec(playerid, Int) = GetPlayerInterior(playerid);

					if (!Var(playerid, Duty))
					{
					    if (Player(playerid, Protected) != 0)
					    {
					        Spec(playerid, Health) = 100.0;
						}
	  					else
	  					{
						   	GetPlayerHealth(playerid, Spec(playerid, Health));
						}

	                    GetPlayerArmour(playerid, Spec(playerid, Armour));

						for (new i = 0, j = MAX_WEAPON_SLOT; i < j; i++)
							GetPlayerWeaponData(playerid, i, Spec(playerid, Weapon)[i], Spec(playerid, Ammo)[i]);
					}
				}

				if (Var(playerid, PlayerStatus) == PLAYER_STATUS_SWITCHING_TEAM)
				    Var(playerid, PlayerStatus) = PLAYER_STATUS_NONE;
				
				if (g_Reporter[id] != INVALID_PLAYER_ID)
				{
				 	SendClientMessage(g_Reporter[id], -1, "- Your report is now being checked by an administrator, please be patient.");
				 	g_Reporter[id] = INVALID_PLAYER_ID;
				}

				if (Var(playerid, CapturingFlag) != -1)
				{
			  		SendClientMessage(playerid, c_red, "* You failed to steal this flag.");
			        zone_StopFlagCapture(playerid);
				}

				admin_StartSpec(playerid, id);
				GameTextForPlayer(playerid, ""#TXT_LINE"~w~now spectating", 3000, 3);

				admin_SendMessage(1, ac_cmd1, sprintf("Admin %s used /spec on ID %i.", playerName(playerid), id));
	            IRC_Echo(g_IRC_Conn[IRC_ADMIN_CHANNEL], sprintf("6* Administrator %s used /spec on id %i.", playerName(playerid), id));

				SendClientMessage(playerid, ac_cmd1, sprintf("You are spectating %s, press 'LMB' or 'RMB' to switch through players and 'crouch' key to stop spectating.", playerName(id)));
	            
	            if (Player(playerid, Protected) != 0)
					PlayerProtection(playerid, PROTECTION_END);
			}
		}
	}

	return 1;
}

CMD:specoff(playerid,params[])
{
    if (IsAuthorizedLevel(playerid, 1))
	{
		if (Var(playerid, SpecType) == SPEC_TYPE_NONE)
			return SendClientMessage(playerid, c_red, "* You are not spectating.");

		admin_StopSpec(playerid);
		SendClientMessage(playerid, ac_cmd1, "You are no longer spectating.");
	    admin_CommandMessage(playerid, "specoff");
	}

	return 1;
}

CMD:warn(playerid, params[])
{
	if (IsAuthorizedLevel(playerid, 1))
	{
	    new id;

	    if (sscanf(params, "us[50]", id, params))
	        return error:_usage(playerid, "/warn <playerid/name> <reason>");

		if (IsValidTargetPlayer(playerid, id))
		{
		    if (IsCommandUsable(playerid, id))
			{
		        if (gettime() < Var(id, Warned))
		            return SendClientMessage(playerid, c_red, "Please wait...");
				
				if (strlen(params) > MAX_REASON)
					return SendClientMessage(playerid, c_red, "* Reason length exceeds the maximum characters limit. Limit: 35 chars");

				++Var(id, Warns);

			    SendClientMessageToAll(0xFF8000FF, sprintf("* Administrator %s[%i] has warned player %s[%i], warns: %i/5", playerName(playerid), playerid, playerName(id), id, Var(id, Warns)));
				SendClientMessageToAll(0xFF8000FF, sprintf("* Reason: %s", params));
				SendClientMessage(playerid, ac_cmd1, sprintf("You have warned %s. Reason: %s", playerName(id), params));

	            IRC_Echo(g_IRC_Conn[IRC_MAIN_CHANNEL], sprintf("7* Administrator %s[%i] has warned player %s[%i] - Reason: %s | Warns: %i/5", playerName(playerid), playerid, playerName(id), id, params, Var(id, Warns)));

				WarnPlayer(id, playerName(playerid), params);
				log(sprintf("Admin %s warned player %s. Reason: %s", playerName(playerid), playerName(id), params));
			}
		}
	}

	return 1;
}

CMD:aduty(playerid, params[])
{
	if (IsAuthorizedLevel(playerid, 1))
	{
	    if (GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
	        return SendClientMessage(playerid, c_red, "* You must be on foot to use this command.");

	    if (Var(playerid, DM) != 0 || Var(playerid, DuelID) != -1)
            return SendClientMessage(playerid, c_red, "* You cannot use this command inside DM arena.");
		
		if (Player(playerid, Jailed) != 0)
		    return SendClientMessage(playerid, c_red, "* You cannot go on duty while in jail.");

		if (Player(playerid, Protected) != 0)
			PlayerProtection(playerid, PROTECTION_END);
		
		if (Var(playerid, CapturingFlag) != -1)
	        zone_StopFlagCapture(playerid);
		
		if (Var(playerid, VSpawned) != 0)
		    Var(playerid, VSpawned) = 0;


		admin_CommandMessage(playerid, "aduty");
		admin_ToggleDuty(playerid, (Var(playerid, Duty)) ? 0 : 1);
		log(sprintf("Admin %s went on duty.", playerName(playerid)));
	}

	return 1;
}

CMD:cc(playerid, params[])
{
	if (IsAuthorizedLevel(playerid, 1))
	{
	    for (new i = 0, j = 50; i < j; ++i)
		{
			SendClientMessageToAll(-1, " ");
		}

		admin_CommandMessage(playerid, "cc");
	}

	return 1;
}

CMD:jail(playerid, params[])
{
	if (IsAuthorizedLevel(playerid, 1))
	{
		new id, time;

		if (sscanf(params, "uis[80]", id, time, params))
			return error:_usage(playerid, "/jail <playerid/name> <minutes> <reason>");
		
		if (time > 10)
		    return SendClientMessage(playerid, c_red, "* You cannot jail for more than 10 minutes.");
		
		if (strlen(params) > MAX_REASON)
			return SendClientMessage(playerid, c_red, "* Reason length exceeds the maximum characters limit. Limit: 35 chars");

		if (IsValidTargetPlayer(playerid, id))
		{
		    if (IsCommandUsable(playerid, id))
			{
		        if (IsTargetPlayerSpawned(playerid, id))
				{
				    if (Var(id, DM) != 0 || Var(id, DuelID) != -1)
			            return SendClientMessage(playerid, c_red, "* Specified player is in DM arena.");
					
					if (GetPlayerState(id) == PLAYER_STATE_SPECTATING)
					    return SendClientMessage(playerid, c_red, "* Specified player is currently spectating.");
					
					if (Player(id, Jailed) != 0)
						return SendClientMessage(playerid, c_red, "* Specified player is already in jail.");
					
					JailPlayer(id, (time * 60));

					SendClientMessageToAll(c_tomato, sprintf("* Administrator %s[%i] has jailed player %s[%i] for %i minute(s).", playerName(playerid), playerid, playerName(id), id, time));
					SendClientMessageToAll(c_tomato, sprintf("* Reason: %s", params));
					SendClientMessage(playerid, ac_cmd1, sprintf("You have jailed %s for %i minute(s) - Reason: %s", playerName(id), time, params));
					SendClientMessage(id, c_red, sprintf("You have been jailed by admin %s for %i minute(s) - Reason: %s", playerName(playerid), time, params));

		            IRC_Echo(g_IRC_Conn[IRC_MAIN_CHANNEL], sprintf("4* Administrator %s[%i] has jailed player %s[%i] for %i minute(s). Reason: %s", playerName(playerid), playerid, playerName(id), id, time, params));
					admin_CommandMessage(playerid, "jail", id, time);

					new query[100];

					Query("UPDATE `users` SET `jail_time`='%i' WHERE `id`='%i'", Player(id, Jailed), Player(id, UserID));
					mysql_tquery(connection, query, "ExecuteQuery", "i", res_none);
					log(sprintf("Admin %s has jailed player %s for %i minutes. Reason: %s", playerName(playerid), playerName(id), time, params));
				}
			}
		}
	}

	return 1;
}

CMD:unjail(playerid, params[])
{
	if (IsAuthorizedLevel(playerid, 1))
	{
		new id;

		if (sscanf(params, "u", id))
			return error:_usage(playerid, "/unjail <playerid/name>");
		
		if (strlen(params) > MAX_REASON)
			return SendClientMessage(playerid, c_red, "* Reason length exceeds the maximum characters limit. Limit: 35 chars");
		
		if (IsValidTargetPlayer(playerid, id))
		{
		    if (IsTargetPlayerSpawned(playerid, id))
			{
				if (!Player(id, Jailed))
					return SendClientMessage(playerid, c_red, "* Specified player is not in jail.");

				SendClientMessageToAll(c_green, sprintf("* Administrator %s[%i] has removed player %s[%i] from the jail.", playerName(playerid), playerid, playerName(id), id));
				SendClientMessage(playerid, ac_cmd1, sprintf("You have un-jailed %s.", playerName(id)));

				IRC_Echo(g_IRC_Conn[IRC_MAIN_CHANNEL], sprintf("10* Administrator %s[%i] has removed player %s[%i] from the jail.", playerName(playerid), playerid, playerName(id), id));

	            Player(id, Jailed) = 0;
				admin_CommandMessage(playerid, "unjail", id);

				new query[100];

				Query("UPDATE `users` SET `jail_time`='0' WHERE `id`='%i'", Player(id, Jailed), Player(id, UserID));
				mysql_tquery(connection, query, "ExecuteQuery", "i", res_none);
				log(sprintf("Admin %s has unjailed player %s.", playerName(playerid), playerName(id)));
			}
		}
	}

	return 1;
}

CMD:mute(playerid, params[])
{
	if (IsAuthorizedLevel(playerid, 1))
	{
		new id, time;

		if (sscanf(params, "uds[80]", id, time, params))
			return error:_usage(playerid, "/mute <playerid/name> <minutes> <reason>");
		
		if (time > 15)
		    return SendClientMessage(playerid, c_red, "* You cannot mute for more than 10 minutes.");
		
		if (strlen(params) > MAX_REASON)
			return SendClientMessage(playerid, c_red, "* Reason length exceeds the maximum characters limit. Limit: 35 chars");
		
		if (IsValidTargetPlayer(playerid, id))
		{
            if (IsCommandUsable(playerid, id))
			{
				if (Player(id, Muted) != 0)
					return SendClientMessage(playerid, c_red, "* Specified player is already muted.");

				admin_CommandMessage(playerid, "mute", id, time);
				SendClientMessageToAll(c_tomato, sprintf("* Administrator %s[%i] has muted player %s[%i] for %i minute(s).", playerName(playerid), playerid, playerName(id), id, time));
				SendClientMessageToAll(c_tomato, sprintf("* Reason: %s", params));

				IRC_Echo(g_IRC_Conn[IRC_MAIN_CHANNEL], sprintf("4* Administrator %s[%i] has muted player %s[%i] for %i minute(s). Reason: %s", playerName(playerid), playerid, playerName(id), id, time, params));

				SendClientMessage(id, c_red, sprintf("You have been muted by admin %s for %i minute(s) - Reason: %s", playerName(playerid), time, params));
				SendClientMessage(playerid, ac_cmd1, sprintf("You have muted %s for %i minute(s) - Reason: %s", playerName(id), time, params));

				Player(id, Muted) = gettime() + (time * 60);

				new query[100];

				Query("UPDATE `users` SET `mute_time`='%i' WHERE `id`='%i'", Player(id, UserID));
				mysql_tquery(connection, query, "ExecuteQuery", "i", res_none);
				log(sprintf("Admin %s has muted player %s for %i minutes. Reason: %s", playerName(playerid), playerName(id), time, params));
			}
		}
	}

	return 1;
}

CMD:unmute(playerid, params[])
{
	if (IsAuthorizedLevel(playerid, 1))
	{
		new id;

		if (sscanf(params, "u", id))
			return error:_usage(playerid, "/unmute <playerid/name>");

		if (IsValidTargetPlayer(playerid, id))
		{
			if (!Player(id, Muted))
				return SendClientMessage(playerid, c_red, "* Specified player is not muted.");

			admin_CommandMessage(playerid, "unmute", id);
			SendClientMessageToAll(c_green, sprintf("* Administrator %s[%i] has un-muted player %s[%i].", playerName(playerid), playerid, playerName(id), id));
            IRC_Echo(g_IRC_Conn[IRC_MAIN_CHANNEL], sprintf("10* Administrator %s[%i] has un-muted player %s[%i].", playerName(playerid), playerid, playerName(id), id));

			SendClientMessage(playerid, ac_cmd1, sprintf("You have un-muted %s.", playerName(id)));
			SendClientMessage(id, ac_cmd2, sprintf("You have been un-muted by admin %s.", playerName(playerid)));

			UnmutePlayer(id);
			log(sprintf("Admin %s has unmuted player %s.", playerName(playerid), playerName(id)));
		}
	}

	return 1;
}

CMD:freeze(playerid, params[])
{
	if (IsAuthorizedLevel(playerid, 1))
	{
		new id;

		if (sscanf(params, "us[80]", id))
			return error:_usage(playerid, "/freeze <playerid/name>");

		if (IsValidTargetPlayer(playerid, id))
		{
            if (IsCommandUsable(playerid, id))
			{
                if (IsTargetPlayerSpawned(playerid, id))
				{
					if (Var(id, Frozen))
						return SendClientMessage(playerid, c_red, "* Specified player is already frozen.");
					
					if (GetPlayerState(id) == PLAYER_STATE_SPECTATING)
					    return SendClientMessage(playerid, c_red, "* Specified player is currently spectating.");

					Var(id, Frozen) = true;

					TogglePlayerControllable(id, 0);

					admin_CommandMessage(playerid, "freeze", id);
					SendClientMessageToAll(c_tomato, sprintf("* Administrator %s[%i] has frozen player %s[%i].", playerName(playerid), playerid, playerName(id), id));
		            IRC_Echo(g_IRC_Conn[IRC_MAIN_CHANNEL], sprintf("4* Administrator %s[%i] has frozen player %s[%i].", playerName(playerid), playerid, playerName(id), id));

					SendClientMessage(playerid, ac_cmd1, sprintf("You have frozen %s.", playerName(id)));
					SendClientMessage(id, c_red, sprintf("You have been frozen by admin %s.", playerName(playerid)));
                    log(sprintf("Admin %s has frozzen player %s.", playerName(playerid), playerName(id)));
				}
			}
		}
	}

	return 1;
}

CMD:unfreeze(playerid, params[])
{
	if (IsAuthorizedLevel(playerid, 1))
	{
		new id;

		if (sscanf(params, "u", id))
			return error:_usage(playerid, "/unfreeze <playerid/name>");

		if (IsValidTargetPlayer(playerid, id))
		{
			if (Var(id, Frozen))
				Var(id, Frozen) = false;
			
            TogglePlayerControllable(id, 1);
			admin_CommandMessage(playerid, "unmute", id);
			SendClientMessageToAll(c_green, sprintf("* Administrator %s[%i] has un-frozen player %s[%i].", playerName(playerid), playerid, playerName(id), id));
            IRC_Echo(g_IRC_Conn[IRC_MAIN_CHANNEL], sprintf("10* Administrator %s[%i] has un-frozen player %s[%i].", playerName(playerid), playerid, playerName(id), id));

			SendClientMessage(playerid, ac_cmd1, sprintf("You have un-frozen %s.", playerName(id)));
			SendClientMessage(id, ac_cmd2, sprintf("You have been un-frozen by admin %s.", playerName(playerid)));
            log(sprintf("Admin %s has unfrozen player %s.", playerName(playerid), playerName(id)));
		}
	}

	return 1;
}

CMD:slap(playerid, params[])
{
	if (IsAuthorizedLevel(playerid, 1))
	{
		new id;

		if (sscanf(params, "u", id))
			return error:_usage(playerid, "/slap <playerid/name>");

	 	if (IsValidTargetPlayer(playerid, id))
 		{
	 	    if (IsCommandUsable(playerid, id))
		 	{
	 	        if (IsTargetPlayerSpawned(playerid, id))
			 	{
					if (Player(playerid, Jailed) != 0)
						return SendClientMessage(playerid, c_red, "* Specified player is currently in jail.");
					
					if (Var(playerid, Frozen))
						return SendClientMessage(playerid, c_red, "* Specified player is currently frozen.");
					
					if (GetPlayerState(id) == PLAYER_STATE_SPECTATING)
					    return SendClientMessage(playerid, c_red, "* Specified player is currently spectating.");
	
					SlapPlayer(id, 5.0);
					SendClientMessage(playerid, ac_cmd1, sprintf("You have slapped %s.", playerName(id)));
					admin_CommandMessage(playerid, "slap", id);
				}
			}
		}
	}

	return 1;
}

CMD:tcsync(playerid, params[])
{
	if (IsAuthorizedLevel(playerid, 1))
	{
		foreach(new i : Teams)
		{
		    Team(i, Players) = 0;
		}

		foreach(new i : Player)
		{
		    if (Player(i, PlayingTeam) != 0)
			{
		        ++Team(Player(i, PlayingTeam), Players);
		    }
		}

		SendClientMessage(playerid, ac_cmd1, "Team counter has been synchronized.");
		admin_CommandMessage(playerid, "tcsync");
	}

	return 1;
}

CMD:weaps(playerid, params[])
{
	if (IsAuthorizedLevel(playerid, 1))
	{
		new id;

		if (sscanf(params, "u", id))
		    return error:_usage(playerid, "/weaps [playerid/name]");

		if (IsValidTargetPlayer(playerid, id))
		{
		    if (!Var(id, Spawned))
		        return SendClientMessage(playerid, c_red, "* Specified player is not spawned.");

			SendClientMessage(playerid, ac_cmd1, sprintf("Showing %s's weapons", playerName(id)));
			SendClientMessage(playerid, ac_cmd1, return_WepList(id));
			admin_CommandMessage(playerid, "weaps", id);
		}
	}

	return 1;
}

CMD:rsv(playerid, params[])
{
	if (IsAuthorizedLevel(playerid, 1))
	{
	    new vid;

		if (sscanf(params, "i", vid))
		    return error:_usage(playerid, "/rsv <vehicleid>");
		
		if (!IsValidVehicle(vid))
		    return SendClientMessage(playerid, c_red, "* Invalid vehicleid.");
		
		SetVehicleToRespawn(vid);
		SendClientMessage(playerid, ac_cmd1, sprintf("You have re-spawned vehicle ID %i.", vid));
		admin_CommandMessage(playerid, "rsv", vid);
	}

	return 1;
}

CMD:rsvall(playerid, params[])
{
	if (IsAuthorizedLevel(playerid, 1))
	{
        for(new i, j = MAX_VEHICLES; i < j; i++)
		{
            if (!Vehicle(i, BombingPlane))
			{
				if (!vehicle_IsOccupied(i) && IsValidVehicle(i))
				{
					SetVehicleToRespawn(i);
				}
			}
		}

		SendClientMessageToAll(ac_gcmd, sprintf("» Administrator %s[%i] has respawned all unused vehicles.", playerName(playerid), playerid));
        IRC_Echo(g_IRC_Conn[IRC_MAIN_CHANNEL], sprintf("10» Administrator %s[%i] has respawned all unused vehicles.", playerName(playerid), playerid));
		admin_CommandMessage(playerid, "rsvall");
	}

	return 1;
}

CMD:clearbox(playerid, params[])
{
	if (IsAuthorizedLevel(playerid, 1))
	{
	    for(new i = 0, j = MAX_NEWSBOX_CONTENTS; i < j; i++)
		{
			News(" ");
		}
	}

	admin_CommandMessage(playerid, "clearbox");
	
	return 1;
}

CMD:aheli(playerid, params[])
{
	if (IsAuthorizedLevel(playerid, 1))
	{
	    if (Player(playerid, Level) < 4 && !Var(playerid, Duty))
            return SendClientMessage(playerid, c_red, "* You need to be on admin duty to use this command.");
		
		if (Var(playerid, DM) != 0 || Var(playerid, DuelID) != -1)
            return SendClientMessage(playerid, c_red, "* You cannot use this command inside DM arena.");
		
		if (GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
		    return SendClientMessage(playerid, c_red, "* You must be on foot to spawn.");

        if (Var(playerid, Vehicle) != 0)
		{
			DestroyVehicle(Var(playerid, Vehicle));
			Var(playerid, Vehicle) = 0;
		}

		GiveVehicle(playerid, 487);
		Var(playerid, Vehicle) = GetPlayerVehicleID(playerid);
		SendClientMessage(playerid, ac_cmd1, "Admin helicopter spawned.");
		admin_CommandMessage(playerid, "aheli");
	}

	return 1;
}

CMD:acar(playerid, params[])
{
	if (IsAuthorizedLevel(playerid, 1))
	{
	    if (Player(playerid, Level) < 4 && !Var(playerid, Duty))
           	return SendClientMessage(playerid, c_red, "* You need to be on admin duty to use this command.");
	    
	    if (Var(playerid, DM) != 0 || Var(playerid, DuelID) != -1)
           	return SendClientMessage(playerid, c_red, "* You cannot use this command inside DM arena.");
		
		if (GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
		   	return SendClientMessage(playerid, c_red, "* You must be on foot to spawn.");

		if (Var(playerid, Vehicle) != 0)
		{
			DestroyVehicle(Var(playerid, Vehicle));
			Var(playerid, Vehicle) = 0;
		}

		GiveVehicle(playerid, 560);
		Var(playerid, Vehicle) = GetPlayerVehicleID(playerid);
		SendClientMessage(playerid, ac_cmd1, "Admin car spawned.");
		admin_CommandMessage(playerid, "acar");
	}

	return 1;
}

CMD:aboat(playerid, params[])
{
	if (IsAuthorizedLevel(playerid, 1))
	{
	    if (Player(playerid, Level) < 4 && !Var(playerid, Duty))
            return SendClientMessage(playerid, c_red, "* You need to be on admin duty to use this command.");
		
		if (Var(playerid, DM) != 0 || Var(playerid, DuelID) != -1)
            return SendClientMessage(playerid, c_red, "* You cannot use this command inside DM arena.");
		
		if (GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
		    return SendClientMessage(playerid, c_red, "* You must be on foot to spawn.");

        if (Var(playerid, Vehicle) != 0)
		{
			DestroyVehicle(Var(playerid, Vehicle));
			Var(playerid, Vehicle) = 0;
		}

		GiveVehicle(playerid, 446);
		Var(playerid, Vehicle) = GetPlayerVehicleID(playerid);
		SendClientMessage(playerid, ac_cmd1, "Admin boat spawned.");
		admin_CommandMessage(playerid, "aboat");
	}

	return 1;
}

CMD:abike(playerid, params[])
{
	if (IsAuthorizedLevel(playerid, 1))
	{
		if (Var(playerid, DM) != 0 || Var(playerid, DuelID) != -1)
            return SendClientMessage(playerid, c_red, "* You cannot use this command inside DM arena.");
		
		if (GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
		    return SendClientMessage(playerid, c_red, "* You must be on foot to spawn.");
		
		if (Var(playerid, VSpawned))
			return SendClientMessage(playerid, c_red, "* You can use this command once after spawning.");
		

        if (Var(playerid, Vehicle) != 0)
		{
			DestroyVehicle(Var(playerid, Vehicle));
			Var(playerid, Vehicle) = 0;
		}

		GiveVehicle(playerid, 522);
		Var(playerid, Vehicle) = GetPlayerVehicleID(playerid);
		SendClientMessage(playerid, ac_cmd1, "Admin bike spawned.");
		
		if (Player(playerid, Level) < 4 && !Var(playerid, Duty))
		{
			Var(playerid, VSpawned) = 1;
		}

		admin_CommandMessage(playerid, "abike");
	}

	return 1;
}

CMD:site(playerid, params[])
{
    if (IsAuthorizedLevel(playerid, 1))
	{
        SendClientMessageToAll(-1, "");
		SendClientMessageToAll(c_lightyellow, "    Visit our server website at: www.teamdss.com");
		SendClientMessageToAll(-1, "");
		GameTextForAll("~n~~n~~g~~h~~h~server website~n~~w~http://www.teamdss.com", 6000, 3);
	    admin_CommandMessage(playerid, "site");
	}

    return 1;
}

/*******************************************************************************
								Level 2 commands
*******************************************************************************/
CMD:flip(playerid, params[])
{
	if (IsAuthorizedLevel(playerid, 2))
	{
		if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
			return SendClientMessage(playerid, c_red, "* You are not driving a vehicle.");

		new Float:x = 0.0, Float:y = 0.0, Float:z = 0.0, Float:a = 0.0;
		
		SetCameraBehindPlayer(playerid);
		GetPlayerPos(playerid, x, y, z);
		GetPlayerFacingAngle(playerid, a);
		SetVehiclePos(GetPlayerVehicleID(playerid), x, y, z+2.0);
		SetVehicleZAngle(GetPlayerVehicleID(playerid), a);

		SendClientMessage(playerid, ac_cmd1, "Vehicle flipped.");
		admin_CommandMessage(playerid, "flip");
	}

	return 1;
}

CMD:async(playerid, params[])
{
	if (IsAuthorizedLevel(playerid, 2))
	{
		new id;

		if (sscanf(params, "u", id))
			return error:_usage(playerid, "/async <playerid/name>");
		
		if (Player(id, Protected) != 0)
			return SendClientMessage(playerid, c_red, "Please wait...");
		
		if (Var(id, Duty) || GetPlayerState(id) == PLAYER_STATE_SPECTATING)
		    return SendClientMessage(playerid, c_red, "* Specified player cannot be synchronized.");
 		
 		if (GetPlayerState(playerid) == PLAYER_STATE_WASTED)
			return SendClientMessage(playerid, c_red, "Please wait...");

		if (IsValidTargetPlayer(playerid, id))
		{
			if (IsTargetPlayerSpawned(playerid, id))
			{
				SendClientMessage(id, ac_cmd2, sprintf("Admin %s has synchronized you.", playerName(playerid)));
				SendClientMessage(playerid, ac_cmd1, sprintf("You have synchronized %s.", playerName(id)));
				admin_CommandMessage(playerid, "async", id);
				Synchronize(id, 1);
			}
		}
	}

	return 1;
}

CMD:astats(playerid, params[])
{
	if (IsAuthorizedLevel(playerid, 1))
	{
		new id;

		if (sscanf(params, "u", id))
		    return error:_usage(playerid, "/astats <playerid/name>");

		if (IsValidTargetPlayer(playerid, id))
		{
		    if (IsTargetPlayerSpawned(playerid, id))
			{
				new clanid = Player(id, ClanID);

				SendClientMessage(playerid, ac_cmd1, "AStats:");

				SendClientMessage(playerid, ac_cmd1, sprintf("  Name: %s | Player ID: %i | IP: %s | Account ID: %i | Registered date: %s",
					playerName(id), id, Player(id, Ip), Player(id, UserID), Player(id, RegDate)));

				SendClientMessage(playerid, ac_cmd1, sprintf("  Admin level: %i | VIP: %s | Is a clan member: %s",
			        Player(id, Level), g_VIPName[Player(id, VIP)], (clanid == -1) ? ("No") : sprintf("Yes, member of %s", Clan(clanid, Name))));

				admin_CommandMessage(playerid, "astats", id);
			}
		}
	}

	return 1;
}

CMD:eject(playerid, params[])
{
    if (IsAuthorizedLevel(playerid, 2))
    {
		new id;

		if (sscanf(params, "u", id))
			return SendClientMessage(playerid, c_grey, "/eject <playerid/name>");

		if (IsValidTargetPlayer(playerid, id))
		{
			if (!IsPlayerInAnyVehicle(id))
				return SendClientMessage(playerid, c_red, "* Specified player is not inside a vehicle.");

			SendClientMessage(playerid, ac_cmd1, sprintf("You ejected %s from a vehicle.", playerName(id)));
			SendClientMessage(id, c_red, sprintf("Admin %s ejected you from this vehicle.", playerName(playerid)));

			SlapPlayer(id, 3.0);
			admin_CommandMessage(playerid, "eject", id);
		}
	}

	return 1;
}

CMD:apm(playerid, params[])
{
	if (IsAuthorizedLevel(playerid, 2))
	{
		new id;

	 	if (sscanf(params, "us[128]", id, params))
		 	return error:_usage(playerid, "/apm <playerid/name> <message>");

		if (IsValidTargetPlayer(playerid, id))
		{
			SendClientMessage(id, c_red, sprintf("- PM from Admin: {%06x}%s", (-1 >>> 8), params));
			SendClientMessage(playerid, ac_cmd1, sprintf("APM > %s: {%06x}%s", playerName(id), (-1 >>> 8), params));

            IRC_Echo(g_IRC_Conn[IRC_ADMIN_CHANNEL], sprintf("14[APM] %s > %s: %s", playerName(playerid), playerName(id), params));
			admin_SendMessage(1, c_grey, sprintf("[APM] %s > %s: %s", playerName(playerid), playerName(id), params));
		}
	}

	return 1;
}

CMD:disarm(playerid, params[])
{
	if (IsAuthorizedLevel(playerid, 2))
	{
		new id;

		if (sscanf(params, "u", id))
			return error:_usage(playerid, "/disarm <playerid/name>");

		if (IsValidTargetPlayer(playerid, id))
		{
		    if (IsCommandUsable(playerid, id))
		    {
		        if (IsTargetPlayerSpawned(playerid, id)) 
		        {
					if (Var(id, Duty))
				    	return SendClientMessage(playerid, c_red, "* You cannot use this command on specified player.");
					
					if (GetPlayerState(id) == PLAYER_STATE_SPECTATING)
					    return SendClientMessage(playerid, c_red, "* Specified player is currently spectating.");

					ResetPlayerWeapons(id);
					SendClientMessage(playerid, ac_cmd1, sprintf("You have disarmed %s.", playerName(id)));
					SendClientMessage(id, ac_cmd2, sprintf("Admin %s has disarmed you.", playerName(playerid)));

					admin_CommandMessage(playerid, "disarm", id);
				}
			}
		}
	}

	return 1;
}

CMD:lockveh(playerid, params[])
{
	if (IsAuthorizedLevel(playerid, 2))
	{
		if (!IsPlayerInAnyVehicle(playerid))
			return SendClientMessage(playerid, c_red, "* You need to be inside a vehicle to use this command.");
		
		foreach(new i : Player) 
		{
			if (i != playerid) 
			{
				SetVehicleParamsForPlayer(GetPlayerVehicleID(playerid), i, 0, 1);
			}
		}

		SendClientMessage(playerid, ac_cmd1, "You have locked the vehicle's door.");
		admin_CommandMessage(playerid, "lockveh");
	}

	return 1;
}

CMD:unlockveh(playerid, params[])
{
	if (IsAuthorizedLevel(playerid, 2)) 
	{
		if (!IsPlayerInAnyVehicle(playerid))
			return SendClientMessage(playerid, c_red, "* You need to be inside a vehicle to use this command.");

		foreach(new i : Player)
		{
			if (i != playerid)
			{
				SetVehicleParamsForPlayer(GetPlayerVehicleID(playerid), i, 0, 0);
			}
		}

		SendClientMessage(playerid, ac_cmd1, "You have unlocked the vehicle's door.");
		admin_CommandMessage(playerid, "unlockveh");
	}

	return 1;
}

CMD:get(playerid, params[])
{
	if (IsAuthorizedLevel(playerid, 2))
	{
	    if (Var(playerid, DM) != 0 || Var(playerid, DuelID) != -1)
            return SendClientMessage(playerid, c_red, "* You cannot use this command inside DM arena.");

		new id;

		if (sscanf(params, "u", id))
			error:_usage(playerid, "/get <playerid/name>");

		if (IsValidTargetPlayer(playerid, id))
		{
		    if (IsTargetPlayerSpawned(playerid, id))
		    {
			    if (Var(id, DM) != 0 || Var(id, DuelID) != -1)
		            return SendClientMessage(playerid, c_red, "* Specified player is in DM arena.");
				
				if (id == playerid)
					return SendClientMessage(playerid, c_red, "* You cannot use this command on yourself.");
				
				if (GetPlayerState(id) == PLAYER_STATE_SPECTATING)
 					return SendClientMessage(playerid, c_red, "* Specified player is currently spectating.");

				new Float:x, Float:y, Float:z, int, world;

				GetPlayerPos(playerid, x, y, z);
				int = GetPlayerInterior(playerid);
				world = GetPlayerVirtualWorld(playerid);

				SetPlayerVirtualWorld(id, world);
				SetPlayerInterior(id, int);
				SetPlayerPos(id, x, y + 3.0, z);

				SendClientMessage(playerid, ac_cmd1, sprintf("You have teleported player %s at your location.", playerName(id)));
				SendClientMessage(id, ac_cmd2, sprintf("You have been teleported to admin %s's location.", playerName(playerid)));
				admin_CommandMessage(playerid, "get", id);
			}
		}
	}

	return 1;
}

CMD:goto(playerid, params[])
{
	if (IsAuthorizedLevel(playerid, 2))
	{
	    if (Var(playerid, DM) != 0 || Var(playerid, DuelID) != -1)
            return SendClientMessage(playerid, c_red, "* You cannot use this command inside DM arena.");
		
		if (!Var(playerid, Duty) && Player(playerid, Level) < 4)
			return SendClientMessage(playerid, c_red, "* You need to be on admin duty to use this command.");
		
		if (Player(playerid, Jailed) != 0)
			return SendClientMessage(playerid, c_red, "* You cannot use this command inside jail.");
		
		if (GetPlayerState(playerid) == PLAYER_STATE_SPECTATING)
		    return SendClientMessage(playerid, c_red, "* You cannot use this command while spectating.");

		new id;

		if (sscanf(params, "u", id))
			return error:_usage(playerid, "/goto <playerid/name>");

	 	if (IsValidTargetPlayer(playerid, id))
	 	{
	 	    if (IsTargetPlayerSpawned(playerid, id))
	 	    {
				if (id == playerid)
					return SendClientMessage(playerid, c_red, "* You cannot use this command on yourself.");
				
				if (Var(id, DM) != 0 || Var(id, DuelID) != -1)
		            return SendClientMessage(playerid, c_red, "* Specified player is inside DM arena.");
				
				if (GetPlayerState(id) == PLAYER_STATE_SPECTATING)
				    return SendClientMessage(playerid, c_red, "* Specified player is currently spectating.");

				new int, world, Float:x, Float:y, Float:z;

				GetPlayerPos(id, x, y, z);
				int = GetPlayerInterior(id);
				world = GetPlayerVirtualWorld(id);

				SetPlayerVirtualWorld(playerid, world);
				SetPlayerInterior(playerid, int);
				SetPlayerPos(playerid, x, y + 3.0, z);

				SendClientMessage(playerid, ac_cmd1, sprintf("You have been teleported to %s.",playerName(id)));
				admin_CommandMessage(playerid, "goto", id);
			}
		}
	}

	return 1;
}

CMD:getveh(playerid, params[])
{
	if (IsAuthorizedLevel(playerid, 2))
	{
	    if (Player(playerid, Jailed) != 0)
			return SendClientMessage(playerid, c_red, "* You cannot use this command inside jail.");
		if (Var(playerid, DM) != 0 || Var(playerid, DuelID) != -1)
            return SendClientMessage(playerid, c_red, "* You cannot use this command inside DM arena.");

		new vehicleid;

		if (sscanf(params, "i", vehicleid))
			return SendClientMessage(playerid, c_grey, "/getveh <vehicleid>");
		
		if (vehicleid > MAX_VEHICLES || !IsValidVehicle(vehicleid))
			return SendClientMessage(playerid, c_red, "* Invalid vehicle ID.");
		
		if (GetPlayerState(playerid) == PLAYER_STATE_SPECTATING)
		    return SendClientMessage(playerid, c_red, "* You cannot use this command while spectating.");

		new Float:x, Float:y, Float:z, vw;

		GetPlayerPos(playerid, x, y, z);

		vw = GetPlayerVirtualWorld(playerid);

		SetVehiclePos(vehicleid, x, y, z);
		SetVehicleVirtualWorld(vehicleid, vw);

		PutPlayerInVehicle(playerid, vehicleid, 0);
	 	SendClientMessage(playerid, ac_cmd1, sprintf("You have teleported vehicel ID %i.", vehicleid));
	 	admin_CommandMessage(playerid, "getveh", vehicleid);
	}

	return 1;
}

CMD:gotoveh(playerid, params[])
{
	if (IsAuthorizedLevel(playerid, 2))
	{
		if (Player(playerid, Jailed) != 0)
			return SendClientMessage(playerid, c_red, "* You cannot use this command inside jail.");
		
		if (Var(playerid, DM) != 0 || Var(playerid, DuelID) != -1)
            return SendClientMessage(playerid, c_red, "* You cannot use this command inside DM arena.");
		
		new vehicleid;

		if (sscanf(params, "i", vehicleid))
			return error:_usage(playerid, "/gotoveh <vehicleid>");
		
		if (!Var(playerid, Duty) && Player(playerid, Level) < 6)
		    return SendClientMessage(playerid, c_red, "* You need to be on admin duty to use this command.");
		
		if (Player(playerid, Jailed) != 0)
		    return SendClientMessage(playerid, c_red, "* You cannot use this command inside jail.");
		
		if (!IsValidVehicle(vehicleid))
			return SendClientMessage(playerid, c_red, "* Invalid vehicleid.");
		
		if (GetPlayerState(playerid) == PLAYER_STATE_SPECTATING)
		    return SendClientMessage(playerid, c_red, "* You cannot use this command while spectating.");

		new Float:x, Float:y, Float:z, Float:a, vw;

		GetVehiclePos(vehicleid, x, y, z);
		GetVehicleZAngle(vehicleid, a);
		vw = GetVehicleVirtualWorld(vehicleid);

		SetPlayerPos(playerid, x, y, z + 2.0);
		SetPlayerFacingAngle(playerid, a);
		SetPlayerVirtualWorld(playerid, vw);
		SetCameraBehindPlayer(playerid);

		SendClientMessage(playerid, ac_cmd1, sprintf("You have been teleported to vehicle ID %i.", vehicleid));
		admin_CommandMessage(playerid, "gotoveh", vehicleid);
	}

	return 1;
}

CMD:bancheck(playerid, params[])
{
    if (IsAuthorizedLevel(playerid, 2))
    {
        if (sscanf(params, "s[24]", params))
            return error:_usage(playerid, "/bancheck <username/ip>");

		new query[300];

		Query("SELECT * FROM `bans` WHERE `nick` LIKE '##%e##' OR `ip` LIKE '##%s##' ORDER BY `id` DESC LIMIT 5", params, params);
		mysql_tquery(connection, ret_strreplace(query, "##", "%"), "result_CheckBan", "is", playerid, params);
	}

    return 1;
}

CMD:explode(playerid, params[])
{
	if (IsAuthorizedLevel(playerid, 2))
	{
		new id;

		if (sscanf(params, "u", id))
			return SendClientMessage(playerid, c_grey, "/explode <playerid/name>");

		if (IsValidTargetPlayer(playerid, id))
		{
		    if (IsCommandUsable(playerid, id))
		    {
		        if (IsTargetPlayerSpawned(playerid, id))
		        {
					if (Var(id, Frozen))
						return SendClientMessage(playerid, c_red, "* Specified player is currently frozen.");
					
					if (GetPlayerState(id) == PLAYER_STATE_SPECTATING)
					    return SendClientMessage(playerid, c_red, "* Specified player is currently spectating.");

					new Float:x, Float:y, Float:z;

					GetPlayerPos(id, x, y, z);
					CreateExplosion(x, y, z, 4, 2.0);

				 	SendClientMessage(playerid, ac_cmd1, sprintf("You exploded %s.", playerName(id)));
				 	admin_CommandMessage(playerid, "explode", id);
				}
			}
		}
	}

	return 1;
}

CMD:fps(playerid, params[])
{
	if (IsAuthorizedLevel(playerid, 2))
	{
	    new id;

		if (sscanf(params, "u", id))
		    return error:_usage(playerid, "/fps <playerid/name>");
		
		if (IsValidTargetPlayer(playerid, id))
		{
			SendClientMessage(playerid, ac_cmd1, sprintf("%s's current FPS: %i", playerName(id), Var(id, FPS)));
			admin_CommandMessage(playerid, "fps", id);
		}
	}

	return 1;
}

CMD:pl(playerid, params[])
{
	if (IsAuthorizedLevel(playerid, 2))
	{
	    new id;

	    if (sscanf(params, "u", id))
	        return error:_usage(playerid, "/pl <playerid/name>");

		if (IsValidTargetPlayer(playerid, id))
		{
			SendClientMessage(playerid, ac_cmd1, sprintf("%s's current packet loss: %0.2f", playerName(id), NetStats_PacketLossPercent(id)));
            admin_CommandMessage(playerid, "pl", id);
		}
	}

	return 1;
}

CMD:ban(playerid, params[])
{
	if (IsAuthorizedLevel(playerid, 2))
	{
		new id;

		if (sscanf(params, "us[128]", id, params))
			return error:_usage(playerid, "/ban <playerid/name> <reason>");
		
		if (strlen(params) > MAX_REASON)
			return SendClientMessage(playerid, c_red, "* Reason length exceeds the maximum characters limit. Limit: 35 chars");
		
		if (IsValidTargetPlayer(playerid, id))
		{
		    if (IsCommandUsable(playerid, id))
		    {
		 		BanPlayer(id, "Permanent", params, playerName(playerid), false, playerid);

				SendClientMessage(playerid, ac_cmd1, sprintf("You have banned %s - Reason: %s", playerName(id), params));
				admin_CommandMessage(playerid, "ban", id);

				log(sprintf("Admin %s has banned player %s. Reason: %s", playerName(playerid), playerName(id), params));
			}
		}
	}

	return 1;
}

CMD:unban(playerid, params[])
{
	if (IsAuthorizedLevel(playerid, 2))
	{
	    if (sscanf(params, "s[24]", params))
			return error:_usage(playerid, "/unban <username/IP>");
	
		new query[128];

		Query("SELECT * FROM `bans` WHERE `nick`='%e' OR `ip`='%e' ORDER BY `id`", params, params);
		mysql_tquery(connection, query, "IRC_Offline_Unban", "si", params, playerid);

		admin_CommandMessage(playerid, "unban");
	}

	return 1;
}

CMD:tban(playerid, params[])
{
    if (IsAuthorizedLevel(playerid, 2))
    {
		new id, hours, minutes;

		if (sscanf(params, "uiis[128]", id, hours, minutes, params))
			return error:_usage(playerid, "/tban <playerid/name> <hours> <minutes> <reason>");
		
		if (strlen(params) > MAX_REASON)
			return SendClientMessage(playerid, c_red, "* Reason length exceeds the maximum characters limit. Limit: 35 chars");

		if (IsValidTargetPlayer(playerid, id))
		{
		    if (IsCommandUsable(playerid, id))
		    {
				SendClientMessageToAll(c_tomato, sprintf("* Administrator %s[%i] has temporarily banned %s[%i], time: %iH and %iM.", playerName(playerid), playerid, playerName(id), id, hours, minutes));
				SendClientMessageToAll(c_tomato, sprintf("* Reason: %s", params));

				SendClientMessage(playerid, ac_cmd1, sprintf("You have temporarily banned %s - Reason: %s", playerName(id), params));

				new stamp = (hours * 3600) + (minutes * 60) + gettime(), query[200];

				Query("INSERT INTO `bans` (id,nick,bannedby,date,ip,type,time,reason) VALUES ('%i','%e','%e',UTC_TIMESTAMP(),'%e','%e','%i','%e')", Player(id, UserID), playerName(id), playerName(playerid), Player(id, Ip), "Temporary", stamp, params);
			    mysql_tquery(connection, query, "ExecuteQuery", "i", res_none);

				KickEx(id, c_red, "You have been banned.");
				admin_CommandMessage(playerid, "tban", id);

				log(sprintf("Admin %s has temporarily banned player %s. Time: %i hours and %i minutes, reason: %s", playerName(playerid), playerName(id), hours, minutes, params));
			}
		}
	}

	return 1;
}

/*******************************************************************************
								Level 3 commands
*******************************************************************************/
CMD:ip(playerid, params[])
{
	if (IsAuthorizedLevel(playerid, 3))
	{
		new id;

	 	if (sscanf(params, "u", id))
		 	return SendClientMessage(playerid, c_grey, "/ip <playerid/name>");

		if (IsValidTargetPlayer(playerid, id))
		{
			admin_CommandMessage(playerid, "ip", id);
			SendClientMessage(playerid, ac_cmd1, sprintf(" %s's IP: %s", playerName(id), Player(id, Ip)));
		}
	}

	return 1;
}

CMD:aka(playerid, params[])
{
	if (IsAuthorizedLevel(playerid, 3))
	{
		new id;

		if (sscanf(params, "u", id))
			return error:_usage(playerid, "/aka <playerid/name>");

		if (IsValidTargetPlayer(playerid, id))
		{
			new query[146];

			Query("SELECT `nick` FROM `users` WHERE `new_ip`='%e' ORDER BY `id` DESC LIMIT 10", Player(id, Ip));
			mysql_tquery(connection, query, "result_FetchAKA", "iii", playerid, id, 0);

			admin_CommandMessage(playerid, "aka", id);
		}
	}

	return 1;
}

CMD:setmotd(playerid, params[])
{
	if (IsAuthorizedLevel(playerid, 3))
	{
		if (sscanf(params, "s[128", params))
			return error:_usage(playerid, "/setmotd <message>");

	    if (strlen(params) > 120)
	        return SendClientMessage(playerid, c_red, "Message should not be higher than 120 characters.");

		format(Server(MOTD), sizeof(Server(MOTD)), params);
		SendClientMessage(playerid, ac_cmd1, "Message of the day has been set to:");
		SendClientMessage(playerid, ac_cmd1, params);
	}

	return 1;
}

CMD:ints(playerid, params[])
{
	if (IsAuthorizedLevel(playerid, 3))
	{

		new list[1000];

		for(new i = 1, j = 26; i < j; i++)
		{
			Format:list("%s"#sc_white"%s - ID: %i\n", list, g_AdminInteriors[i][int_Name], i);
		}

		ShowPlayerDialog(playerid, D_MSG, DIALOG_STYLE_MSGBOX, "Interiors:", list, "Close", "");
		admin_CommandMessage(playerid, "ints");
	}

	return 1;
}

CMD:int(playerid, params[])
{
	if (IsAuthorizedLevel(playerid, 3))
	{
        if (Var(playerid, DM) != 0 || Var(playerid, DuelID) != -1)
            return SendClientMessage(playerid, c_red, "* You cannot use this command inside DM arena.");
		
		if (!Var(playerid, Duty) && (Player(playerid, Level) < 5))
			return SendClientMessage(playerid, c_red, "* You need to be on admin duty to use this command.");
		
		if (GetPlayerState(playerid) == PLAYER_STATE_SPECTATING)
		    return SendClientMessage(playerid, c_red, "* You cannot use this command while spectating.");
	
		if (sscanf(params, "s[35]", params))
			return error:_usage(playerid, "/int <interior name>");

		new int = interior_ReturnIDByName(params);

		if (int == 0 || int > 25)
		    return SendClientMessage(playerid, c_red, "Invalid interior name. Type '/ints' to get the list of available interiors.");

		SetPlayerPos(playerid, g_AdminInteriors[int][int_X], g_AdminInteriors[int][int_Y], g_AdminInteriors[int][int_Z] + 1.0);
		SetPlayerInterior(playerid, g_AdminInteriors[int][int_ID]);
		SetPlayerVirtualWorld(playerid, int + 8888);

		SetCameraBehindPlayer(playerid);

		SendClientMessage(playerid, ac_cmd1, sprintf("You have been teleported to the interior '%s' ID: %i.", g_AdminInteriors[int][int_Name], g_AdminInteriors[int][int_ID]));
		SendClientMessage(playerid, c_grey, "* Type '/exitint' to exit from this interior.");
        admin_SendMessage(1, ac_cmd1, sprintf("Administrator %s has teleported to the interior '%s' ID: %i.", playerName(playerid), g_AdminInteriors[int][int_Name], int));
        IRC_Echo(g_IRC_Conn[IRC_ADMIN_CHANNEL], sprintf("6Administrator %s has teleported to the interior '%s', ID: %i.", playerName(playerid), g_AdminInteriors[int][int_Name], int));

		admin_CommandMessage(playerid, "int", int);
	}

	return 1;
}

CMD:exitint(playerid, params[])
{
    if (IsAuthorizedLevel(playerid, 3))
    {
		if (GetPlayerInterior(playerid) == 0 || Var(playerid, DM) != 0)
			return SendClientMessage(playerid, c_red, "* You are not inside an interior.");

		SendClientMessage(playerid, ac_cmd1, "You left the interior.");
		RandomBaseSpawn(playerid, Player(playerid, Team));
   		SetPlayerInterior(playerid, 0);
   		SetPlayerVirtualWorld(playerid, 0);

   		SetCameraBehindPlayer(playerid);

		admin_CommandMessage(playerid, "exitint");
	}

	return 1;
}

CMD:world(playerid, params[])
{
	if (IsAuthorizedLevel(playerid, 3))
	{
	    if (!Var(playerid, Duty) && (Player(playerid, Level) < 5))
			return SendClientMessage(playerid, c_red, "* You need to be on admin duty to use this command.");
		if (GetPlayerState(playerid) == PLAYER_STATE_SPECTATING)
		    return SendClientMessage(playerid, c_red, "* You cannot use this command while spectating.");

		new world;

		if (sscanf(params, "i", world))
			return error:_usage(playerid, "/world <worldid 1 - 5000>");
		
		if (world > 5000)
		    return SendClientMessage(playerid, c_red, "* Invalid world ID.");

		SetPlayerVirtualWorld(playerid, world);
		SendClientMessage(playerid, ac_cmd1, sprintf("You have set your virtal world to woorld id %i.", world));
		SendClientMessage(playerid, c_grey, "* Use world id 0 to set your world back to the default one.");
        IRC_Echo(g_IRC_Conn[IRC_ADMIN_CHANNEL], sprintf("6Administrator %s has set his world to %i.", playerName(playerid), world));

		admin_CommandMessage(playerid, "world", world);
	}

	return 1;
}

CMD:sethp(playerid, params[])
{
    if (IsAuthorizedLevel(playerid, 3))
    {
	    if (!Var(playerid, Duty) && (Player(playerid, Level) < 5))
			return SendClientMessage(playerid, c_red, "* You need to be on admin duty to use this command.");

		new id, Float:value;
		
		if (sscanf(params, "uf", id, value))
		    return error:_usage(playerid, "/sethp <playerid/nname> <value>");

		if (IsValidTargetPlayer(playerid, id))
		{
		    if (IsTargetPlayerSpawned(playerid, id))
		    {
				if (Player(id, Protected) != 0)
				    return SendClientMessage(playerid, c_red, "Please wait...");
				
				if (value > 100.0)
				    return SendClientMessage(playerid, c_red, "* Value cannot be higher than 100.");
				
				if (GetPlayerState(id) == PLAYER_STATE_SPECTATING)
				    return SendClientMessage(playerid, c_red, "* Specified player is currently spectating.");
                
                if (Var(id, Duty))
				    return SendClientMessage(playerid, c_red, "* You cannot set health on specified player because they are on duty.");

				SetPlayerHealth(id, value);

				SendClientMessage(playerid, ac_cmd1, sprintf("You have set %s's health to %0.2f.", playerName(id), value));
	            SendClientMessage(id, ac_cmd2, sprintf("Admin %s has set your health to %0.2f.", playerName(playerid), value));

				admin_CommandMessage(playerid, "sethp", id);
			}
		}
	}

	return 1;
}

CMD:setarmour(playerid, params[])
{
    if (IsAuthorizedLevel(playerid, 3))
    {
	    if (!Var(playerid, Duty) && (Player(playerid, Level) < 5))
			return SendClientMessage(playerid, c_red, "* You need to be on admin duty to use this command.");

		new id, Float:value;

		if (sscanf(params, "uf", id, value))
		    error:_usage(playerid, "/setarmour <playerid/nname> <value>");

		if (IsValidTargetPlayer(playerid, id))
		{
		    if (IsTargetPlayerSpawned(playerid, id))
		    {
				if (value > 100.0)
				    return SendClientMessage(playerid, c_red, "* Value cannot be higher than 100.");

				SetPlayerArmour(id, value);

				SendClientMessage(playerid, ac_cmd1, sprintf("You have set %s's armour to %0.2f.", playerName(id), value));
	            SendClientMessage(id, ac_cmd2, sprintf("Admin %s has set your armour to %0.2f.", playerName(playerid), value));

				admin_CommandMessage(playerid, "setarmour", id);
			}
		}
	}

	return 1;
}

CMD:healall(playerid, params[])
{
	if (IsAuthorizedLevel(playerid, 3))
	{
	    if (!Var(playerid, Duty) && (Player(playerid, Level) < 5))
			return SendClientMessage(playerid, c_red, "* You need to be on admin duty to use this command.");

		foreach(new i : Player)
		{
		    if (Var(i, Spawned))
		    {
				if (i != playerid && !Var(i, Duty))
				{
					SetPlayerHealth(i, 100.0);
				}
			}
		}

		SendClientMessageToAll(ac_gcmd, sprintf("» Administrator %s[%i] has healed all the players.", playerName(playerid), playerid));
        IRC_Echo(g_IRC_Conn[IRC_MAIN_CHANNEL], sprintf("10» Administrator %s[%i] has healed all the players.", playerName(playerid), playerid));

		admin_CommandMessage(playerid, "healall");
	}

	return 1;
}

CMD:armourall(playerid, params[])
{
	if (IsAuthorizedLevel(playerid, 3))
	{
		if (!Var(playerid, Duty) && Player(playerid, Level) < 5)
			return SendClientMessage(playerid, c_red, "* You need to be on admin duty to use this command.");

		foreach(new i : Player)
		{
		    if (Var(i, Spawned))
		    {
				if (i != playerid)
				{
					SetPlayerArmour(i, 100.0);
				}
			}
		}

		SendClientMessageToAll(ac_gcmd, sprintf("» Administrator %s[%i] has armoured all the players.", playerName(playerid), playerid));
        IRC_Echo(g_IRC_Conn[IRC_MAIN_CHANNEL], sprintf("10» Administrator %s[%i] has healed all the players.", playerName(playerid), playerid));

		admin_CommandMessage(playerid, "armourall");
	}

	return 1;
}

CMD:freezeall(playerid, params[])
{
	if (IsAuthorizedLevel(playerid, 3))
	{
	    if (!Var(playerid, Duty) && (Player(playerid, Level) < 5))
			return SendClientMessage(playerid, c_red, "* You need to be on admin duty to use this command.");

		foreach(new i : Player)
		{
		    if (Var(i, Spawned) && i != playerid)
		    {
		        if (GetPlayerState(i) == PLAYER_STATE_SPECTATING)
					continue;

				TogglePlayerControllable(i, 0);
			}
		}

		SendClientMessageToAll(ac_gcmd, sprintf("» Administrator %s[%i] has frozen all the players.", playerName(playerid), playerid));
        IRC_Echo(g_IRC_Conn[IRC_MAIN_CHANNEL], sprintf("10» Administrator %s[%i] has frozen all the players.", playerName(playerid), playerid));

		admin_CommandMessage(playerid, "freezeall");
	}

	return 1;
}

CMD:unfreezeall(playerid, params[])
{
	if (IsAuthorizedLevel(playerid, 3))
	{
	    if (!Var(playerid, Duty) && (Player(playerid, Level) < 5))
			return SendClientMessage(playerid, c_red, "* You need to be on admin duty to use this command.");

		foreach(new i : Player)
		{
		    if (Var(i, Spawned) && i != playerid)
		    {
				TogglePlayerControllable(i, 1);
			}
		}

		SendClientMessageToAll(ac_gcmd, sprintf("» Administrator %s[%i] has unfrozen all the players.", playerName(playerid), playerid));
        IRC_Echo(g_IRC_Conn[IRC_MAIN_CHANNEL], sprintf("10» Administrator %s[%i] has unfrozen all the players.", playerName(playerid), playerid));

		admin_CommandMessage(playerid, "unfreezeall");
	}

	return 1;
}

CMD:skin(playerid, params[])
{
    if (IsAuthorizedLevel(playerid, 3))
    {
		if (IsPlayerInAnyVehicle(playerid))
			return SendClientMessage(playerid, c_red, "* Set your skin on foot to avoid glitch.");
		
		if (GetPlayerState(playerid) == PLAYER_STATE_SPECTATING)
		    return SendClientMessage(playerid, c_red, "* You cannot use this command while spectating.");

		new skin;

		if (sscanf(params, "i", skin))
			return error:_usage(playerid, "/skin <skinid>");

		if (IsValidSkin(playerid, skin))
		{
			SendClientMessage(playerid, ac_cmd1, sprintf("Skin changed, ID: %i.", skin));
			SetSkin(playerid, skin);

			Var(playerid, Skin) = skin;
			admin_CommandMessage(playerid, "skin", skin);
		}
	}

	return 1;
}

CMD:setskin(playerid, params[])
{
	if (IsAuthorizedLevel(playerid, 3))
	{
		new skin, id;

		if (sscanf(params, "ui", id, skin))
			return SendClientMessage(playerid, c_grey, "/setskin <playerid/name> <skinid>");

		if (IsValidTargetPlayer(playerid, id))
		{
			if (IsTargetPlayerSpawned(playerid, id))
			{
				if (IsPlayerInAnyVehicle(id))
					return SendClientMessage(playerid, c_red, "* Specified player is inside a vehicle.");
				
				if (GetPlayerState(id) == PLAYER_STATE_SPECTATING)
				    return SendClientMessage(playerid, c_red, "* Specified player is currently spectating.");

				if (IsValidSkin(playerid, skin)) {
					admin_CommandMessage(playerid, "setskin", id, skin);

					SetSkin(id, skin);

					SendClientMessage(playerid, ac_cmd1, sprintf("You set %s's skin, ID: %i.", playerName(id), skin));
					SendClientMessage(id, ac_cmd2, sprintf("Admin %s has set your skin, ID: %i.", playerName(playerid), skin));
				}
			}
		}
	}

	return 1;
}

CMD:v(playerid, params[])
{
	if (IsAuthorizedLevel(playerid, 3))
	{
	    if (Var(playerid, DM) != 0 || Var(playerid, DuelID) != -1)
            return SendClientMessage(playerid, c_red, "* You cannot use this command inside DM arena.");
		
		if (GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
		    return SendClientMessage(playerid, c_red, "* You must be on foot to spawn.");

		new name[30];

		if (sscanf(params, "s[30]", name))
			return error:_usage(playerid, "/v <vehicle name>");
		
		new modelid = vehicle_ReturnModelFromName(name);

		if (modelid < 400 || modelid > 611)
			return SendClientMessage(playerid, c_red, "* Invalid vehicle name.");

		GiveVehicle(playerid, modelid);

		new vehicleid = GetPlayerVehicleID(playerid);

		SendClientMessage(playerid, ac_cmd1, sprintf("Vehicle spawned, name: %s, model: %i, ID: %i", g_VehicleNames[GetVehicleModel(vehicleid) - 400], GetVehicleModel(vehicleid), vehicleid));
		admin_CommandMessage(playerid, "v");
	}

	return 1;
}

CMD:cleancars(playerid, params[])
{
	if (IsAuthorizedLevel(playerid, 3))
	{
	    new count = 0;

		for(new i, j = MAX_VEHICLES; i < j; i++)
		{
		    if (!vehicle_IsOccupied(i) && IsValidVehicle(i))
		    {
		        if (Vehicle(i, Type))
					continue;

				if (!Vehicle(i, Static) && !Vehicle(i, BombingPlane))
				{
			        DestroyVehicle(i);
			  		count++;

                    new _x[E_VEHICLE_DATA];

			  		g_Vehicle[i] = _x;

			  		foreach(new x : Player)
			  		{
						if (Var(x, Vehicle) == i)
						{
                            Var(x, Vehicle) = 0;
				  		}
					}
				}
			}
		}

		if (!count)
			return SendClientMessage(playerid, c_red, "* There are no vehicles spawned.");

	    admin_CommandMessage(playerid, "cleancars");
		admin_SendMessage(1, ac_cmd1, sprintf("Admin %s has removed total of '%i' spawned vehicles.", playerName(playerid), count));
        IRC_Echo(g_IRC_Conn[IRC_ADMIN_CHANNEL], sprintf("6Admin %s has removed total of '%i' spawned vehicles.", playerName(playerid), count));
	}

	return 1;
}

CMD:giveveh(playerid, params[])
{
	if (IsAuthorizedLevel(playerid, 3))
	{
		new name[30], id;

		if (sscanf(params, "us[30]", id, name))
			return SendClientMessage(playerid, c_grey, "/giveveh <playerid/name> <vehiclename>");

		if (IsValidTargetPlayer(playerid, id))
		{
            if (IsTargetPlayerSpawned(playerid, id))
            {
			    if (Var(id, DM) != 0 || Var(id, DuelID) != -1)
		            return SendClientMessage(playerid, c_red, "* Specified player is in DM arena.");
				
				if (GetPlayerState(id) != PLAYER_STATE_ONFOOT)
					return SendClientMessage(playerid, c_red, "* Specified player must be on foot.");
				
				if (Player(id, Jailed) != 0 || Var(id, Frozen))
				    return SendClientMessage(playerid, c_red, "* Specified player is either jailed or frozen.");

				new modelid = vehicle_ReturnModelFromName(name);

				if (modelid < 400 || modelid > 611)
					return SendClientMessage(playerid, c_red, "Invalid vehicle name.");

				GiveVehicle(id, modelid);

				new vehicleid = GetPlayerVehicleID(id);

				SendClientMessage(playerid, ac_cmd1, sprintf("You have given a vehicle, %s to player %s.", g_VehicleNames[GetVehicleModel(vehicleid) - 400], playerName(id)));
				SendClientMessage(id, ac_cmd2, sprintf("Admin %s has given you a vehicle, %s.", playerName(playerid), g_VehicleNames[GetVehicleModel(vehicleid) - 400]));

				admin_CommandMessage(playerid, "giveveh", id, vehicleid);
			}
		}
	}

	return 1;
}

CMD:vcol(playerid, params[])
{
	if (IsAuthorizedLevel(playerid, 3))
	{
		new c1, c2;

		if (sscanf(params, "ii", c1, c2))
			return SendClientMessage(playerid, c_grey, "/vcol <color1> <color2>");
		
		if (c1 > 255 || c2 > 255)
			return SendClientMessage(playerid, c_red, "* Invalid primary or secondary color.");
		
		if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
			return SendClientMessage(playerid, c_red, "* You are not driving a vehicle.");

		new vehicleid = GetPlayerVehicleID(playerid);

		ChangeVehicleColor(vehicleid,  c1, c2);
		admin_CommandMessage(playerid, "vcol", c1, c2);

		SendClientMessage(playerid, ac_cmd1, sprintf("Vehicle color changed. Primary: %i, secondary: %i", c1, c2));
	}

	return 1;
}

CMD:fixall(playerid, params[])
{
	if (IsAuthorizedLevel(playerid, 3))
	{
		admin_CommandMessage(playerid, "fixall");

		for(new i, j = MAX_VEHICLES; i < j; i++)
		{
		    if (IsValidVehicle(i))
		    {
				RepairVehicle(i);
			}
		}

		SendClientMessageToAll(ac_gcmd, sprintf("» Administrator %s[%i] has fixed all the vehicles.",playerName(playerid), playerid));
		IRC_Echo(g_IRC_Conn[IRC_MAIN_CHANNEL], sprintf("10» Administrator %s[%i] has fixed all the vehicles.",playerName(playerid), playerid));
	}

	return 1;
}

CMD:fix(playerid, params[])
{
	if (IsAuthorizedLevel(playerid, 3))
	{
		new id = (sscanf(params, "u", id)) ? playerid : strval(params);;

		if (IsValidTargetPlayer(playerid, id))
		{
			if (id == playerid)
			{
				if (!IsPlayerInAnyVehicle(playerid))
					return SendClientMessage(playerid, c_red, "* You must be inside a vehicle to use this command.");
	
				admin_CommandMessage(playerid, "fix");
				RepairVehicle(GetPlayerVehicleID(playerid));

				SendClientMessage(playerid, ac_cmd1, "You have fixed your vehicle.");
				return SendClientMessage(playerid, c_grey, "* You can also use /fix <playerid/name> to repair other player's vehicle.");
			}
	
		    if (GetPlayerState(id) != PLAYER_STATE_DRIVER)
				return SendClientMessage(playerid, c_red, "* Specified player is not driving a vehicle.");

			admin_CommandMessage(playerid, "fix", id);

			SendClientMessage(playerid, ac_cmd1, sprintf("You have fixed %s's vehicle.", playerName(id)));
	        SendClientMessage(id, ac_cmd2, sprintf("Administrator %s has fixed your vehicle.", playerName(playerid)));

			RepairVehicle(GetPlayerVehicleID(id));
		}
	}

	return 1;
}

CMD:delv(playerid,params[])
{
	if (IsAuthorizedLevel(playerid, 3))
	{
		new vehicleid;

		if (sscanf(params, "d", vehicleid))
			return SendClientMessage(playerid, c_grey, "/delv <vehicleid>");
		
		if (!IsValidVehicle(vehicleid))
			return SendClientMessage(playerid, c_red, "* Invalid vehicleid.");
		
		if (Vehicle(vehicleid, Static) || Vehicle(vehicleid, BombingPlane))
			return SendClientMessage(playerid, c_red, "* You cannot delete this vehicle.");

		admin_CommandMessage(playerid, "delv", vehicleid);
		DestroyVehicle(vehicleid);

		new _x[E_VEHICLE_DATA];
  		g_Vehicle[vehicleid] = _x;

		SendClientMessage(playerid, ac_cmd1, sprintf("Specified vehicle has been deleted. Vehicle ID: %i.", vehicleid));
	}

	return 1;
}

CMD:ajp(playerid, params[])
{
	if (IsAuthorizedLevel(playerid, 3))
	{
	    if (!Var(playerid, Duty) && Player(playerid, Level) < 5)
			return SendClientMessage(playerid, c_red, "* You need to be on admin duty to use this command.");

		if (GetPlayerState(playerid) == PLAYER_STATE_SPECTATING)
		    return SendClientMessage(playerid, c_red, "* You cannot use this command while spectating.");

		GiveJetpack(playerid);
	    SendClientMessage(playerid, ac_cmd1, "You got a jetpack.");

    	admin_CommandMessage(playerid, "ajp");
	}

	return 1;
}

CMD:rsp(playerid,params[])
{
	if (IsAuthorizedLevel(playerid, 3))
	{
		new id;

		if (sscanf(params, "u", id))
			return error:_usage(playerid, "/rsp <playerid/name>");

		if (IsValidTargetPlayer(playerid, id))
		{
		    if (IsTargetPlayerSpawned(playerid, id))
		    {
			    if (Var(id, DM) != 0 || Var(id, DuelID) != -1)
		            return SendClientMessage(playerid, c_red, "* Specified player is in DM arena.");
				
				if (Player(id, Protected) != 0)
					return SendClientMessage(playerid, c_red, "Please wait...");
				
				if (GetPlayerState(id) != PLAYER_STATE_ONFOOT)
				    return SendClientMessage(playerid, c_red, "* Specified player must be on foot.");
				
				if (Var(id, Duty))
				    return SendClientMessage(playerid, c_red, "* Specified player cannot be respawned.");
				
				if (Var(id, CapturingFlag) != -1)
		            return SendClientMessage(playerid, c_red, "* Specified player is currently holding a zone flag.");

				if (Var(id, PlayerStatus) != PLAYER_STATUS_NONE)
					Var(id, PlayerStatus) = PLAYER_STATUS_NONE;

				SendClientMessage(playerid, ac_cmd1, sprintf("You have re-spawned %s.", playerName(id)));
				SendClientMessage(id, ac_cmd2, sprintf("You have been re-spawned by admin %s.", playerName(playerid)));

				admin_CommandMessage(playerid, "rsp", id);
				ProtectedSpawn(id);
			}
		}
	}

	return 1;
}

/*******************************************************************************
								Level 4 commands
*******************************************************************************/
CMD:settime(playerid, params[])
{
	if (IsAuthorizedLevel(playerid, 4))
	{
	    new hour;

	    if (sscanf(params, "i", hour))
	        return error:_usage(playerid, "/settime <hour 0-23>");
		
		if (hour > 23)
		    return SendClientMessage(playerid, c_red, "* Invalid hour format. Max: 23H.");
		
		admin_CommandMessage(playerid, "settime", hour);
		SetWorldTime(hour);

		Server(Time) = hour;

		SendClientMessageToAll(ac_gcmd, sprintf("» Administrator %s[%i] has set the server time to %02d:00.", playerName(playerid), playerid, hour));
        IRC_Echo(g_IRC_Conn[IRC_MAIN_CHANNEL], sprintf("10» Administrator %s[%i] has set the server time to %02d:00.", playerName(playerid), playerid, hour));
		SendClientMessage(playerid, ac_cmd1, sprintf("You have set the server time to %02d:00.", hour));
	}

	return 1;
}

CMD:setweather(playerid, params[])
{
	if (IsAuthorizedLevel(playerid, 4))
	{
	    new weatherid;

	    if (sscanf(params, "i", weatherid))
	        return error:_usage(playerid, "/setweather <weatherid>");
		
		if (weatherid > 50)
		    return SendClientMessage(playerid, c_red, "* Invalid weather.");

		admin_CommandMessage(playerid, "setweather", weatherid);
		SetWeather(weatherid);

		Server(Weather) = weatherid;

		SendClientMessageToAll(ac_gcmd, sprintf("» Administrator %s[%i] has set the weather to %i.", playerName(playerid), playerid, weatherid));
        IRC_Echo(g_IRC_Conn[IRC_MAIN_CHANNEL], sprintf("10» Administrator %s[%i] has set the weather to %i.", playerName(playerid), playerid, weatherid));
		SendClientMessage(playerid, ac_cmd1, sprintf("You have set the weather to %i.", weatherid));
	}

	return 1;
}

CMD:rban(playerid, params[])
{
	if (IsAuthorizedLevel(playerid, 4))
	{
		new id;

		if (sscanf(params, "u", id))
			return error:_usage(playerid, "/rban <playerid/name>");

		if (IsValidTargetPlayer(playerid, id))
		{
			new r_ip[16];

			r_ip = return_RangeIP(Player(id, Ip));

			for (new i = 0, j = 256; i < j; i++)
			{
                SendRconCommand(sprintf("banip %s%i", r_ip, i));
			}

			KickEx(id, c_red, "You have been kicked.");
			SendClientMessage(playerid, ac_cmd1, sprintf("You have range banned %s.", playerName(id)));

			admin_SendMessage(1, ac_cmd1, sprintf("Admin %s has range banned %s.", playerName(playerid), playerName(id)));
            IRC_Echo(g_IRC_Conn[IRC_ADMIN_CHANNEL], sprintf("6Admin %s has range banned %s.", playerName(playerid), playerName(id)));
		}
	}

	return 1;
}

CMD:getteam(playerid, params[])
{
	if (IsAuthorizedLevel(playerid, 4))
	{
	    if (Var(playerid, DM) != 0 || Var(playerid, DuelID) != -1)
			return SendClientMessage(playerid, c_red, "* You cannot use this command inside DM arena.");
		
		if (!Var(playerid, Duty) && Player(playerid, Level) < 5)
			return SendClientMessage(playerid, c_red, "* You need to be on admin duty to use this command.");
	
	    if (sscanf(params, "s[50]", params))
	        return error:_usage(playerid, "/getteam <team name>");
		
		new teamid = team_ReturnIDByName(params);

		if (teamid == 0 || teamid >= MAX_TEAMS)
			return SendClientMessage(playerid, c_red, "Invalid team.");
		
		if (!Team(teamid, Players))
		    return SendClientMessage(playerid, c_red, "This team is empty.");
		
		new Float:x, Float:y, Float:z, world, int;

		GetPlayerPos(playerid, x, y, z);

		world = GetPlayerVirtualWorld(playerid);
		int = GetPlayerInterior(playerid);

		foreach(new i : Player)
		{
		    if (i == playerid)
		    	continue;
		    
	        if (Var(i, Spawned) && Player(i, Team) == teamid)
	        {
	            if (Var(i, DM) == 0 && Var(i, DuelID) == -1)
	            {
	                if (GetPlayerState(i) == PLAYER_STATE_SPECTATING)
	                	continue;

		            SetPlayerPos(i, x, y, z + 2.0);
		            SetPlayerInterior(i, int);
		            SetPlayerVirtualWorld(i, world);

		            TogglePlayerControllable(i, 0);
				}
			}
		}

		SendClientMessageToAll(ac_gcmd, sprintf("» Administrator %s[%i] has teleported team %s.", playerName(playerid), playerid, Team(teamid, Name)));
		IRC_Echo(g_IRC_Conn[IRC_MAIN_CHANNEL], sprintf("10» Administrator %s[%i] has teleported team %s.", playerName(playerid), playerid, Team(teamid, Name)));

		SendClientMessage(playerid, ac_cmd1, sprintf("You have teleported team %s.", Team(teamid, Name)));
		admin_CommandMessage(playerid, "getteam", teamid);
	}

	return 1;
}

CMD:disarmteam(playerid, params[])
{
	if (IsAuthorizedLevel(playerid, 4))
	{
	    if (Var(playerid, DM) != 0 || Var(playerid, DuelID) != -1)
			return SendClientMessage(playerid, c_red, "* You cannot use this command inside DM arena.");
		
		if (!Var(playerid, Duty) && Player(playerid, Level) < 5)
			return SendClientMessage(playerid, c_red, "* You need to be on admin duty to use this command.");
		
	    if (sscanf(params, "s[50]", params))
	        return error:_usage(playerid, "/disarmteam <team name>");

		new teamid = team_ReturnIDByName(params);

		if (teamid == 0 || teamid >= MAX_TEAMS)
		    return SendClientMessage(playerid, c_red, "* Invalid team.");
		
		if (!Team(teamid, Players))
		    return SendClientMessage(playerid, c_red, "* This team is empty.");
	
		foreach(new i : Player)
		{
		    if (i == playerid)
		    	continue;

	        if (Var(i, Spawned) && Player(i, Team) == teamid)
	        {
	            if (Var(i, DM) == 0 && Var(i, DuelID) == -1)
	            {
	                if (GetPlayerState(i) == PLAYER_STATE_SPECTATING)
	                	continue;
		            
		            ResetPlayerWeapons(i);
				}
			}
		}

		SendClientMessageToAll(ac_gcmd, sprintf("» Administrator %s[%i] has disarmed team %s.", playerName(playerid), playerid, Team(teamid, Name)));
        IRC_Echo(g_IRC_Conn[IRC_MAIN_CHANNEL], sprintf("10» Administrator %s[%i] has disarmed team %s.", playerName(playerid), playerid, Team(teamid, Name)));

		SendClientMessage(playerid, ac_cmd1, sprintf("You have disarmed team %s.", Team(teamid, Name)));
		admin_CommandMessage(playerid, "getteam", teamid);
	}

	return 1;
}

CMD:freezeteam(playerid, params[]) {
	if (IsAuthorizedLevel(playerid, 4))
	{
	    if (!Var(playerid, Duty) && Player(playerid, Level) < 5)
			return SendClientMessage(playerid, c_red, "* You need to be on admin duty to use this command.");

	    if (sscanf(params, "s[50]", params))
	        return error:_usage(playerid, "/freezeteam <team name>");

		new teamid = team_ReturnIDByName(params);

		if (teamid == 0 || teamid >= MAX_TEAMS)
		    return SendClientMessage(playerid, c_red, "Invalid team.");
		
		if (!Team(teamid, Players))
		    return SendClientMessage(playerid, c_red, "This team is empty.");
		
		foreach(new i : Player)
		{
		    if (i != playerid)
		    {
		        if (Var(i, Spawned) && Player(i, Team) == teamid)
		        {
		            if (Var(i, DM) == 0 && Var(i, DuelID) == -1)
		            {
		                if (GetPlayerState(i) == PLAYER_STATE_SPECTATING)
		                	continue;
            			
            			TogglePlayerControllable(i, 0);
					}
				}
			}
		}

		SendClientMessageToAll(ac_gcmd, sprintf("» Administrator %s[%i] has frozen team %s.", playerName(playerid), playerid, Team(teamid, Name)));
        IRC_Echo(g_IRC_Conn[IRC_MAIN_CHANNEL], sprintf("10» Administrator %s[%i] has frozen team %s.", playerName(playerid), playerid, Team(teamid, Name)));

		SendClientMessage(playerid, ac_cmd1, sprintf("You have frozen team %s.", Team(teamid, Name)));
		admin_CommandMessage(playerid, "freezeteam", teamid);
	}

	return 1;
}

CMD:unfreezeteam(playerid, params[])
{
	if (IsAuthorizedLevel(playerid, 4))
	{
	    if (!Var(playerid, Duty) && Player(playerid, Level) < 5)
			return SendClientMessage(playerid, c_red, "* You need to be on admin duty to use this command.");


	    if (sscanf(params, "s[50]", params))
	        return error:_usage(playerid, "/unfreezeteam <team name>");

		new teamid = team_ReturnIDByName(params);

		if (teamid == 0 || teamid >= MAX_TEAMS)
		    return SendClientMessage(playerid, c_red, "Invalid team.");

		if (!Team(teamid, Players))
		    return SendClientMessage(playerid, c_red, "This team is empty.");

			foreach(new i : Player)
			{
			    if (i != playerid)
			    {
			        if (Var(i, Spawned) && Player(i, Team) == teamid)
			        {
						if (Var(i, DM) == 0 && Var(i, DuelID) == -1)
						{
							TogglePlayerControllable(i, 1);
						}
					}
				}
			}

			SendClientMessageToAll(ac_gcmd, sprintf("» Administrator %s[%i] has unfrozen team %s.", playerName(playerid), playerid, Team(teamid, Name)));
	        IRC_Echo(g_IRC_Conn[IRC_MAIN_CHANNEL], sprintf("10» Administrator %s[%i] has unfrozen team %s.", playerName(playerid), playerid, Team(teamid, Name)));

			SendClientMessage(playerid, ac_cmd1, sprintf("You have unfrozen team %s.", Team(teamid, Name)));
			admin_CommandMessage(playerid, "unfreezeteam", teamid);
		}
	}

	return 1;
}

CMD:weapteam(playerid, params[])
{
	if (IsAuthorizedLevel(playerid, 4))
	{
	    if (!Var(playerid, Duty) && Player(playerid, Level) < 5)
			return SendClientMessage(playerid, c_red, "* You need to be on admin duty to use this command.");

		new model[50], ammo;

		if (sscanf(params, "s[50]s[50]i", params, model, ammo))
			return error:_usage(playerid, "/weapteam <team name> <weapon name> <ammo>");

		new teamid = team_ReturnIDByName(params);

		if (teamid == 0 || teamid >= MAX_TEAMS)
		    return SendClientMessage(playerid, c_red, "* Invalid team.");
		
		if (!Team(teamid, Players))
		    return SendClientMessage(playerid, c_red, "* This team is empty.");

		new weaponid = weapon_ReturnModelFromName(model);

		if (weaponid == -1 || weaponid == 38)
			return SendClientMessage(playerid, c_red, "* Invalid weapon name.");

		if (ammo > 1000)
			return SendClientMessage(playerid, c_red, "* Ammo cannot be higher than 1000.");

			foreach(new i : Player)
			{
			    if (i != playerid)
			    {
			        if (Var(i, Spawned) && Player(i, Team) == teamid)
			        {
			            if (Var(i, DM) == 0 && Var(i, DuelID) == -1)
			            {
			                if (GetPlayerState(i) == PLAYER_STATE_SPECTATING)
			                	continue;
							
							GivePlayerWeapon(i, weaponid, ammo);
						}
					}
				}
			}

			SendClientMessageToAll(ac_gcmd, sprintf("» Administrator %s[%i] has given team %s a weapon %s[%i], ammo: %i.", playerName(playerid), playerid, Team(teamid, Name), aWeaponNames[weaponid], weaponid, ammo));
	        IRC_Echo(g_IRC_Conn[IRC_MAIN_CHANNEL], sprintf("10» Administrator %s[%i] has given team %s a weapon %s[%i] with %i rounds of ammo.", playerName(playerid), playerid, Team(teamid, Name), aWeaponNames[weaponid], weaponid, ammo));

			SendClientMessage(playerid, ac_cmd1, sprintf("You have given team %s a weapon %s[%i], ammo: %i.", Team(teamid, Name), aWeaponNames[weaponid], weaponid, ammo));
			admin_CommandMessage(playerid, "weapteam");
		}
	}

	return 1;
}

CMD:armteam(playerid, params[])
{
	if (IsAuthorizedLevel(playerid, 4))
	{
	    if (!Var(playerid, Duty) && Player(playerid, Level) < 5)
			return SendClientMessage(playerid, c_red, "* You need to be on admin duty to use this command.");

	    if (sscanf(params, "s[50]", params))
	        return error:_usage(playerid, "/armteam <team name>");

		new teamid = team_ReturnIDByName(params);

		if (teamid == 0 || teamid >= MAX_TEAMS)
		    return SendClientMessage(playerid, c_red, "Invalid team.");

		if (!Team(teamid, Players))
		    return SendClientMessage(playerid, c_red, "This team is empty.");
		
		foreach(new i : Player)
		{
		    if (i != playerid)
		    {
		        if (Var(i, Spawned) && Player(i, Team) == teamid)
		        {
		            if (Var(i, DM) == 0 && Var(i, DuelID) == -1)
		            {
		            	SetPlayerArmour(i, 100.0);
					}
				}
			}
		}

		SendClientMessageToAll(ac_gcmd, sprintf("» Administrator %s[%i] has armoured team %s.", playerName(playerid), playerid, Team(teamid, Name)));
        IRC_Echo(g_IRC_Conn[IRC_MAIN_CHANNEL], sprintf("10» Administrator %s[%i] has armoured team %s.", playerName(playerid), playerid, Team(teamid, Name)));

		SendClientMessage(playerid, ac_cmd1, sprintf("You have armoured team %s.", Team(teamid, Name)));
		admin_CommandMessage(playerid, "armteam", teamid);
	}

	return 1;
}

CMD:hteam(playerid, params[])
{
	if (IsAuthorizedLevel(playerid, 4))
	{
	    if (!Var(playerid, Duty) && Player(playerid, Level) < 5)
			return SendClientMessage(playerid, c_red, "* You need to be on admin duty to use this command.");

	    if (sscanf(params, "s[50]", params))
	        return error:_usage(playerid, "/hteam <team name>");

		new teamid = team_ReturnIDByName(params);

		if (teamid == 0 || teamid >= MAX_TEAMS)
		    return SendClientMessage(playerid, c_red, "* Invalid team.");
		
		if (!Team(teamid, Players))
		    return SendClientMessage(playerid, c_red, "* This team is empty.");

		foreach(new i : Player)
		{
		    if (i != playerid)
		    {
		        if (Var(i, Spawned) && Player(i, Team) == teamid)
		        {
			        if (Var(i, DM) == 0 && Var(i, DuelID) == -1)
			        {
        				SetPlayerHealth(i, 100.0);
					}
				}
			}
		}

		SendClientMessageToAll(ac_gcmd, sprintf("» Administrator %s[%i] has healed team %s.", playerName(playerid), playerid, Team(teamid, Name)));
        IRC_Echo(g_IRC_Conn[IRC_MAIN_CHANNEL], sprintf("10» Administrator %s[%i] has healed team %s.", playerName(playerid), playerid, Team(teamid, Name)));

		SendClientMessage(playerid, ac_cmd1, sprintf("You have healed team %s.", Team(teamid, Name)));
		admin_CommandMessage(playerid, "hteam", teamid);
	}

	return 1;
}

CMD:scoreteam(playerid, params[])
{
	if (IsAuthorizedLevel(playerid, 4))
	{
	    if (!Var(playerid, Duty) && Player(playerid, Level) < 5)
			return SendClientMessage(playerid, c_red, "* You need to be on admin duty to use this command.");

		new amount;

	    if (sscanf(params, "s[50]i", params, amount))
	        return error:_usage(playerid, "/scoreteam <team name> <amount>");

		new teamid = team_ReturnIDByName(params);

		if (teamid == 0 || teamid >= MAX_TEAMS)
		    return SendClientMessage(playerid, c_red, "* Invalid team.");
		
		if (!Team(teamid, Players))
		    return SendClientMessage(playerid, c_red, "* This team is empty.");
		
		if (amount > 50)
		    return SendClientMessage(playerid, c_red, "* Cannot give more than 50 score.");

		foreach(new i : Player)
		{
		    if (i != playerid)
		    {
		        if (Var(i, Spawned) && Player(i, Team) == teamid)
		        {
    				RewardPlayer(i, 0, amount);
				}
			}
		}

		SendClientMessageToAll(ac_gcmd, sprintf("» Administrator %s[%i] has given team %s %i score.", playerName(playerid), playerid, Team(teamid, Name), amount));
        IRC_Echo(g_IRC_Conn[IRC_MAIN_CHANNEL], sprintf("10» Administrator %s[%i] has given team %s %i score.", playerName(playerid), playerid, Team(teamid, Name), amount));

		SendClientMessage(playerid, ac_cmd1, sprintf("You have given team %s %i score.", Team(teamid, Name), amount));
		admin_CommandMessage(playerid, "scoreteam", teamid, amount);
	}

	return 1;
}

CMD:moneyteam(playerid, params[])
{
	if (IsAuthorizedLevel(playerid, 4))
	{
	    if (!Var(playerid, Duty) && Player(playerid, Level) < 5)
			return SendClientMessage(playerid, c_red, "* You need to be on admin duty to use this command.");

		new amount;

	    if (sscanf(params, "s[50]i", params, amount))
	        return error:_usage(playerid, "/moneyteam <team name> <amount>");

		new teamid = team_ReturnIDByName(params);

		if (teamid == 0 || teamid >= MAX_TEAMS)
		    return SendClientMessage(playerid, c_red, "* Invalid team.");
		
		if (!Team(teamid, Players))
		    return SendClientMessage(playerid, c_red, "* This team is empty.");
		
		if (amount > 50000)
		    return SendClientMessage(playerid, c_red, "* Cannot give more than $50000.");

		foreach(new i : Player)
		{
		    if (i != playerid)
		    {
		        if (Var(i, Spawned) && Player(i, Team) == teamid)
		        {
    				RewardPlayer(i, amount, 0);
				}
			}
		}

		SendClientMessageToAll(ac_gcmd, sprintf("» Administrator %s[%i] has given team %s $%i.", playerName(playerid), playerid, Team(teamid, Name), amount));
        IRC_Echo(g_IRC_Conn[IRC_MAIN_CHANNEL], sprintf("10» Administrator %s[%i] has given team %s $%i.", playerName(playerid), playerid, Team(teamid, Name), amount));

		SendClientMessage(playerid, ac_cmd1, sprintf("You have given team %s $%i.", Team(teamid, Name), amount));
		admin_CommandMessage(playerid, "moneyteam", teamid, amount);
	}

	return 1;
}

CMD:gotozone(playerid, params[])
{
	if (IsAuthorizedLevel(playerid, 4))
	{
	    if (Var(playerid, DM) != 0 || Var(playerid, DuelID) != -1)
	        return SendClientMessage(playerid, c_red, "* You cannot use this command inside DM arena.");
		
		if (!Var(playerid, Duty) && Player(playerid, Level) < 5)
			return SendClientMessage(playerid, c_red, "* You need to be on admin duty to use this command.");
		
		if (Player(playerid, Jailed) != 0)
		    return SendClientMessage(playerid, c_red, "* You cannot use this command inside jail.");
		
		if (GetPlayerState(playerid) == PLAYER_STATE_SPECTATING)
		    return SendClientMessage(playerid, c_red, "* You cannot use this command while spectating.");

	    if (sscanf(params, "s[50]", params))
	        return error:_usage(playerid, "/gotozone <zone name>");

		new zoneid = zone_ReturnIDByName(params);

		if (zoneid == 0 || zoneid >= MAX_CZ)
		    return SendClientMessage(playerid, c_red, "Invalid zone name.");

		new Float:x, Float:y, Float:z;

		x = Zone(zoneid, PointX);
		y = Zone(zoneid, PointY);
		z = Zone(zoneid, PointZ);

		switch (GetPlayerState(playerid))
		{
		    case PLAYER_STATE_DRIVER: SetVehiclePos(GetPlayerVehicleID(playerid), x, y, z + 1.0);
			case PLAYER_STATE_ONFOOT: SetPlayerPos(playerid, x, y, z + 1.0);
		}

		SetCameraBehindPlayer(playerid);

		SendClientMessage(playerid, ac_cmd1, sprintf("You have been teleported to %s.", Zone(zoneid, Name)));
		admin_SendMessage(1, ac_cmd1, sprintf("Admin %s has teleported to %s.", playerName(playerid), Zone(zoneid, Name)));
        IRC_Echo(g_IRC_Conn[IRC_ADMIN_CHANNEL], sprintf("6Admin %s has teleported to %s.", playerName(playerid), Zone(zoneid, Name)));
	}

	return 1;
}

CMD:gotobase(playerid, params[])
{
	if (IsAuthorizedLevel(playerid, 4))
	{
	    if (Var(playerid, DM) != 0 || Var(playerid, DuelID) != -1)
	        return SendClientMessage(playerid, c_red, "* You cannot use this command inside DM arena.");
		
		if (!Var(playerid, Duty) && Player(playerid, Level) < 5)
			return SendClientMessage(playerid, c_red, "* You need to be on admin duty to use this command.");
		
		if (Player(playerid, Jailed) != 0)
  			return SendClientMessage(playerid, c_red, "* You cannot use this command inside jail.");
		
		if (GetPlayerState(playerid) == PLAYER_STATE_SPECTATING)
		    return SendClientMessage(playerid, c_red, "* You cannot use this command while spectating.");

	    if (sscanf(params, "s[50]", params))
	        return error:_usage(playerid, "/gotobase <team name>");

		new teamid = team_ReturnIDByName(params);

		if (teamid == 0 || teamid >= MAX_TEAMS)
		    return SendClientMessage(playerid, c_red, "* Invalid team name.");
		
		if (teamid == MERCENARY)
		    return SendClientMessage(playerid, c_red, "* Specified team does not have a base.");

		RandomBaseSpawn(playerid, teamid);
		SetCameraBehindPlayer(playerid);

		SendClientMessage(playerid, ac_cmd1, sprintf("You have been teleported to team %s's base.", Team(teamid, Name)));
		admin_SendMessage(1, ac_cmd1, sprintf("Admin %s has teleported to team %s's base.", playerName(playerid), Team(teamid, Name)));
        IRC_Echo(g_IRC_Conn[IRC_ADMIN_CHANNEL], sprintf("6Admin %s has teleported to team %s's base.", playerName(playerid), Team(teamid, Name)));
	}

	return 1;
}

CMD:forceteam(playerid, params[])
{
	if (IsAuthorizedLevel(playerid, 4))
	{
	    new id;

	    if (sscanf(params, "us[24]", id, params))
	        return error:_usage(playerid, "/forceteam <playerid/name> <team name>");

		if (IsValidTargetPlayer(playerid, id))
		{
		    if (IsTargetPlayerSpawned(playerid, id))
		    {
				new teamid = team_ReturnIDByName(params);

				if (teamid == 0 || teamid >= MAX_TEAMS)
					return SendClientMessage(playerid, c_red, "* Invalid team.");
				
				if (Var(id, DM) != 0 || Var(id, DuelID) != -1)
			        return SendClientMessage(playerid, c_red, "* Specified player is in DM arena.");
				
				if (Var(id, Duty))
			        return SendClientMessage(playerid, c_red, "* Specified player cannot be forced.");
				
				if (Player(id, Protected) != 0)
    				return SendClientMessage(playerid, c_red, "Please wait...");
				
				if (Player(id, Jailed) != 0 || Var(id, Frozen))
					return SendClientMessage(playerid, c_red, "* Specified player is either jailed or frozen.");
				
				if (Player(id, Team) == teamid)
				    return SendClientMessage(playerid, c_red, "* Specified player is already playing in this team.");
				
				if (Var(id, CapturingFlag) != -1)
		            return SendClientMessage(playerid, c_red, "* Specified player is currently holding a zone flag.");
				
				if (GetPlayerState(id) == PLAYER_STATE_SPECTATING)
				    return SendClientMessage(playerid, c_red, "* Specified player is currently spectating.");

				if (Var(id, PlayerStatus) != PLAYER_STATUS_NONE)
				{
					Var(id, PlayerStatus) = PLAYER_STATUS_NONE;
				}

				Team(Player(id, Team), Players)--;

				SetPlayerTeam(id, teamid);
				SetPlayerColor(id, Team(teamid, Color));
				SetSpawnInfo(id, teamid, Team(teamid, Skin), 0.0, 0.0, 0.0, 0.0, 0, 0, 0, 0, 0, 0);

				switch (teamid)
				{
				   	case TERRORIST:
				   	{
					   	Player(id, Class) = ASSAULT;
					}

					case MERCENARY:
					{
					    Player(id, Class) = C_NAN;
					    SetPlayerTeam(id, id + 1000);
					}

					default:
					{
						Player(id, Class) = SOLDIER;
					}
				}

				Team(teamid, Players)++;
				Player(id, Team) = teamid;
				Player(id, PlayingTeam) = teamid;

				SendClientMessage(playerid, ac_cmd1, sprintf("You have forced player %s to team %s.", playerName(id), Team(teamid, Name)));
				SendClientMessage(id, ac_cmd2, sprintf("Admin %s has forced you to team %s.", playerName(playerid), Team(teamid, Name)));

				admin_CommandMessage(playerid, "forceteam", id, teamid);
				ProtectedSpawn(id);
			}
		}
	}

	return 1;
}

CMD:forceclass(playerid, params[])
{
	if (IsAuthorizedLevel(playerid, 4))
	{
	    new id;

	    if (sscanf(params, "us[24]", id, params))
	        return error:_usage(playerid, "/forceclass <playerid/name> <class name>");

		if (IsValidTargetPlayer(playerid, id))
		{
		    if (IsTargetPlayerSpawned(playerid, id))
		    {
				new class = class_ReturnIDByName(params);

				if (class == -1 || class >= MAX_CLASSES)
					return SendClientMessage(playerid, c_red, "* Invalid class.");
                
                if (Player(id, Team) == MERCENARY)
                    return SendClientMessage(playerid, c_red, "* Specified player's team has no class.");
				
				if (Var(id, DM) != 0 || Var(id, DuelID) != -1)
			        return SendClientMessage(playerid, c_red, "* Specified player is in DM arena.");
				
				if (Var(id, Duty))
			        return SendClientMessage(playerid, c_red, "* Specified player cannot be forced.");
				
				if (Player(id, Class) == class)
				    return SendClientMessage(playerid, c_red, "* Specified player is already playing as this class.");
                
                if (Player(id, Rank) < Class(class, RequiredRank))
                    return SendClientMessage(playerid, c_red, "* Specified player has not unlocked this class yet.");
				
				if (Player(playerid, Team) != TERRORIST && class >= ASSAULT)
			        return SendClientMessage(playerid, c_red, "* Specified class is not available in the player's team.");
				
				if (Player(playerid, Team) == TERRORIST && class < ASSAULT)
			        return SendClientMessage(playerid, c_red, "* Specified class is not available in the player's team.");
				
				if (Player(id, VIP) < 2 && class == VIPCLASS)
					return SendClientMessage(playerid, c_red, "* Specified player is not a VIP Silver and above.");
	
			    Player(id, Class) = class;

    			UpdateMap(id);
				UpdateBoard(id);
				UpdateLabel(id);

				SendClientMessage(playerid, ac_cmd1, sprintf("You have forced player %s to class %s.", playerName(id), Class(class, Name)));
				SendClientMessage(id, ac_cmd2, sprintf("Admin %s has forced you to class %s.", playerName(playerid), Class(class, Name)));

				admin_CommandMessage(playerid, "forceclass", id, class);
			}
		}
	}

	return 1;
}

CMD:dischat(playerid, params[])
{
	if (IsAuthorizedLevel(playerid, 4))
	{
		if (Server(ChatDisabled))
			return SendClientMessage(playerid, c_red, "* Chat is already disabled.");

		SendClientMessageToAll(c_red, sprintf("» Administrator %s[%i] has disabled the chat.", playerName(playerid), playerid));
		IRC_Echo(g_IRC_Conn[IRC_MAIN_CHANNEL], sprintf("4» Administrator %s[%i] has disabled the chat.", playerName(playerid), playerid));

		Server(ChatDisabled) = true;
	}

	return 1;
}

CMD:enchat(playerid, params[])
{
	if (IsAuthorizedLevel(playerid, 4))
	{
		if (!Server(ChatDisabled))
			return SendClientMessage(playerid, c_red, "* Chat is already enabled.");

		SendClientMessageToAll(ac_gcmd, sprintf("» Administrator %s[%i] has enabled the chat.", playerName(playerid), playerid));
        IRC_Echo(g_IRC_Conn[IRC_MAIN_CHANNEL], sprintf("10» Administrator %s[%i] has enabled the chat.", playerName(playerid), playerid));

		Server(ChatDisabled) = false;
	}

	return 1;
}

CMD:msg(playerid, params[])
{
	if (IsAuthorizedLevel(playerid, 4))
	{
	    if (sscanf(params, "s[128]", params))
	        return error:_usage(playerid, "/msg <message>");

		admin_CommandMessage(playerid, "msg");
	 	SendClientMessageToAll(c_yellow, sprintf("*** %s", params));
	}

 	return 1;
}

CMD:weaponall(playerid, params[])
{
    if (IsAuthorizedLevel(playerid, 4))
    {
		if (!Var(playerid, Duty) && Player(playerid, Level) < 5)
			return SendClientMessage(playerid, c_red, "* You need to be on admin duty to use this command.");

		new model[50], ammo;

		if (sscanf(params, "s[50]i", model, ammo))
			return error:_usage(playerid, "/weaponall <weapon name> <ammo>");

		new weaponid = weapon_ReturnModelFromName(model);

		if (ammo > 1000)
			return SendClientMessage(playerid, c_red, "* Ammo cannot be higher than 1000.");
		
		if (weaponid == -1 || weaponid == 38)
			return SendClientMessage(playerid, c_red, "* Invalid weapon name.");

		foreach(new i : Player)
		{
		    if (Var(i, Spawned))
		    {
				if (Var(i, DM) == 0 && Var(i, DuelID) == -1)
				{
				    if (GetPlayerState(i) == PLAYER_STATE_SPECTATING)
				    	continue;
					
					GivePlayerWeapon(i, weaponid, ammo);
				}
			}
		}

		admin_CommandMessage(playerid, "weaponall", weaponid, ammo);
 		SendClientMessageToAll(ac_gcmd, sprintf("» Administrator %s[%i] has given all players a weapon %s[%d] with %i ammo.", playerName(playerid), playerid, aWeaponNames[weaponid], weaponid, ammo));
 		IRC_Echo(g_IRC_Conn[IRC_MAIN_CHANNEL], sprintf("10» Administrator %s[%i] has given all players a weapon %s[%d] with %i ammo.", playerName(playerid), playerid, aWeaponNames[weaponid], weaponid, ammo));
	}

	return 1;
}

CMD:moneyall(playerid, params[])
{
	if (IsAuthorizedLevel(playerid, 4))
	{
	    if (!Var(playerid, Duty) && Player(playerid, Level) < 5)
			return SendClientMessage(playerid, c_red, "* You need to be on admin duty to use this command.");

		new amount;

		if (sscanf(params, "i", amount))
			return error:_usage(playerid, "/moneyall <amount>");

		foreach(new i : Player)
		{
		    if (i != playerid)
		    {
				RewardPlayer(i, amount, 0);
			}
		}

		SendClientMessageToAll(ac_gcmd, sprintf("» Administrator %s[%i] has given all players $%i.", playerName(playerid), playerid, amount));
        IRC_Echo(g_IRC_Conn[IRC_MAIN_CHANNEL], sprintf("10» Administrator %s[%i] has given all players $%i.", playerName(playerid), playerid, amount));

		admin_CommandMessage(playerid, "moneyall", amount);
	}

	return 1;
}

CMD:scoreall(playerid, params[])
{
	if (IsAuthorizedLevel(playerid, 4))
	{
		if (!Var(playerid, Duty) && Player(playerid, Level) < 5)
			return SendClientMessage(playerid, c_red, "* You need to be on admin duty to use this command.");

		new amount;

	    if (sscanf(params, "i", amount))
			return error:_usage(playerid, "/scoreall <amount>");
		
		if (Player(playerid, Level) < 7 && amount > Player(playerid, Level))
		    return SendClientMessage(playerid, c_red, sprintf("* You can only give %i score max.", Player(playerid, Level)));

		foreach(new i : Player)
		{
		    if (i != playerid)
		    {
				RewardPlayer(i, 0, amount);

				if (Var(i, Spawned))
				{
					UpdateRank(i);
				}
			}
		}

		SendClientMessageToAll(ac_gcmd, sprintf("» Administrator %s[%i] has given all players %i score.", playerName(playerid), playerid, amount));
        IRC_Echo(g_IRC_Conn[IRC_MAIN_CHANNEL], sprintf("10» Administrator %s[%i] has given all players %i score.", playerName(playerid), playerid, amount));

		admin_CommandMessage(playerid, "scoreall", amount);
	}

	return 1;
}

CMD:helmetall(playerid, params[])
{
	if (IsAuthorizedLevel(playerid, 4))
	{
		if (!Var(playerid, Duty) && Player(playerid, Level) < 5)
			return SendClientMessage(playerid, c_red, "* You need to be on admin duty to use this command.");

		foreach(new i : Player)
		{
		    if (i != playerid)
		    {
		        if (Var(i, HasHelmet))
					continue;

				if (Var(i, DM) == 0 && Var(i, DuelID) == -1)
				{
					ToggleHelmet(i, 1);
					Var(i, HasHelmet) = 1;
				}
			}
		}

		SendClientMessageToAll(ac_gcmd, sprintf("» Administrator %s[%i] has given a helmet to all the players.", playerName(playerid), playerid));
        IRC_Echo(g_IRC_Conn[IRC_MAIN_CHANNEL], sprintf("10» Administrator %s[%i] has given a helmet to all the players.", playerName(playerid), playerid));

		admin_CommandMessage(playerid, "helmetall");
	}

	return 1;
}

CMD:maskall(playerid, params[])
{
	if (IsAuthorizedLevel(playerid, 4))
	{
		if (!Var(playerid, Duty) && Player(playerid, Level) < 5)
			return SendClientMessage(playerid, c_red, "* You need to be on admin duty to use this command.");

		foreach(new i : Player)
		{
		    if (i != playerid)
		    {
		        if (Var(i, HasMask))
					continue;

				if (Var(i, DM) == 0 && Var(i, DuelID) == -1)
				{
					ToggleMask(i, 1);
					Var(i, HasMask) = 1;
				}
			}
		}

		SendClientMessageToAll(ac_gcmd, sprintf("» Administrator %s[%i] has given an anti teargas mask to all the players.", playerName(playerid), playerid));
        IRC_Echo(g_IRC_Conn[IRC_MAIN_CHANNEL], sprintf("10» Administrator %s[%i] has given an anti teargas mask to all the players.", playerName(playerid), playerid));

		admin_CommandMessage(playerid, "maskall");
	}

	return 1;
}

CMD:ann(playerid, params[])
{
	if (IsAuthorizedLevel(playerid, 4))
	{
		new time, text[128];

		if (sscanf(params, "is[128]", time, text))
			return error:_usage(playerid, "/ann <time> <text>");
		
		if (time == 0 || time > 5)
			return SendClientMessage(playerid, c_red, "* Invalid time format. Use 1 to 5 seconds.");
		
		if (strlen(text) > 119)
		    return SendClientMessage(playerid, c_red, "* Message length exceeds the maximum characters limit. Limit: 120 chars.");

		Announce(text, (time * 1000));
		admin_CommandMessage(playerid, "ann");
	}

	return 1;
}

CMD:givescore(playerid, params[])
{
	if (IsAuthorizedLevel(playerid, 4))
	{
		new id, score;

		if (sscanf(params, "ud", id, score))
			return error:_usage(playerid, "/givescore <playerid/name> <score>");

		if (IsValidTargetPlayer(playerid, id))
		{
			SendClientMessage(playerid, ac_cmd1, sprintf("You have given %i score to player %s.", score, playerName(id)));
			SendClientMessage(id, ac_cmd2, sprintf("You have received %i score from admin %s.", score, playerName(playerid)));

			RewardPlayer(id, 0, score, true);
			admin_CommandMessage(playerid, "givescore", id, score);

			UpdateRank(id);
		}
	}

	return 1;
}

CMD:giveweapon(playerid, params[])
{
    if (IsAuthorizedLevel(playerid, 4))
    {
		new model[50], ammo, id;

		if (sscanf(params, "us[50]i", id, model, ammo))
			return error:_usage(playerid, "/giveweapon <playerid/name> <weapon name> <ammo>");

		if (IsValidTargetPlayer(playerid, id))
		{
			if (IsTargetPlayerSpawned(playerid, id))
			{
			    if (Var(id, DM) != 0 || Var(id, DuelID) != -1)
			        return SendClientMessage(playerid, c_red, "* Specified player is in DM arena.");
				
				if (GetPlayerState(id) == PLAYER_STATE_SPECTATING)
				    return SendClientMessage(playerid, c_red, "* Specified player is currently spectating.");

				new weaponid = weapon_ReturnModelFromName(model);

				if (ammo > 1000)
					return SendClientMessage(playerid, c_red, "* Ammo cannot be higher than 1000.");
				
				if (weaponid == -1 || weaponid == 38)
					return SendClientMessage(playerid, c_red, "* Invalid weaponid.");

				GivePlayerWeapon(id, weaponid, ammo);

				SendClientMessage(playerid, ac_cmd1, sprintf("You have given a weapon %s[%d] with %i ammo to %s.", aWeaponNames[weaponid], weaponid, ammo, playerName(id)));
		 		SendClientMessage(id, ac_cmd2, sprintf("Admin %s gave you a weapon %s[%d] with %i ammo.", playerName(playerid), aWeaponNames[weaponid], weaponid, ammo));

				admin_CommandMessage(playerid, "giveweapon", id, weaponid);
			}
		}
	}

	return 1;
}

CMD:weapon(playerid, params[])
{
    if (IsAuthorizedLevel(playerid, 4))
    {
        if (Var(playerid, DM) != 0 || Var(playerid, DuelID) != -1)
	        return SendClientMessage(playerid, c_red, "* You cannot use this command inside DM arena.");
		
		if (GetPlayerState(playerid) == PLAYER_STATE_SPECTATING)
		    return SendClientMessage(playerid, c_red, "* You cannot use this command while spectating.");

		new model[50], ammo;

		if (sscanf(params, "s[50]i", model, ammo))
			return error:_usage(playerid, "/weapon <weapon name> <ammo>");

		new weaponid = weapon_ReturnModelFromName(model);

		if (ammo > 1000)
			return SendClientMessage(playerid, c_red, "* Ammo cannot be higher than 1000.");
		
		if (weaponid == -1 || weaponid == 38)
			return SendClientMessage(playerid, c_red, "* Invalid weapon.");
		
		GivePlayerWeapon(playerid, weaponid, ammo);
 		SendClientMessage(playerid, ac_cmd1, sprintf("You got a weapon %s[%d] with %d ammo.", aWeaponNames[weaponid], weaponid, ammo));

		admin_CommandMessage(playerid, "weapon", weaponid);
	}

	return 1;
}

CMD:setping(playerid, params[])
{
	if (IsAuthorizedLevel(playerid, 4))
	{
		new ping;

		if (sscanf(params, "d", ping))
			return error:_usage(playerid, "/setping <max limit>");

		if (ping > 1000)
			return SendClientMessage(playerid, c_red, "* Maximum limit is 1000.");

		new string[128], string2[128];

		if (ping != 0)
		{
			Format:string("» Administrator %s[%i] has set the ping limit to %d.", playerName(playerid), playerid, ping);
			Format:string2("10» Administrator %s[%i] has set the ping limit to %d.", playerName(playerid), playerid, ping);

			SendClientMessage(playerid, c_grey, "You can disable the ping limit by setting its value to 0.");
		}
		else
		{
			Format:string("» Administrator %s[%i] has disabled the ping limit.", playerName(playerid), playerid);
			Format:string2("10» Administrator %s[%i] has disabled the ping limit", playerName(playerid), playerid);
		}

		SendClientMessageToAll(ac_gcmd, string);
		IRC_Echo(g_IRC_Conn[IRC_MAIN_CHANNEL], string2);

		Server(MaxPing) = ping;
		admin_CommandMessage(playerid, "setping", ping);
	}

	return 1;
}

CMD:armour(playerid, params[])
{
	if (IsAuthorizedLevel(playerid, 4))
	{
		new id = (sscanf(params, "u", id)) ? playerid : strval(params);

		if (IsValidTargetPlayer(playerid, id))
		{
		    if (id == playerid)
		    {
		        SendClientMessage(playerid, ac_cmd1, "You have armoured yourself.");
		        SendClientMessage(playerid, c_grey, "* You can also use '/armour <playerid/name>' to armour other players.");

				SetPlayerArmour(playerid, 100.0);
				admin_CommandMessage(playerid, "armour");
			}
			else
			{
				SendClientMessage(id, ac_cmd2, sprintf("Admin %s has armoured you.", playerName(playerid)));
				SendClientMessage(playerid, ac_cmd1, sprintf("You have armoured %s.", playerName(id)));

				SetPlayerArmour(id, 100.0);
				admin_CommandMessage(playerid, "armour", id);
			}
		}
	}

	return 1;
}

CMD:heal(playerid, params[])
{
	if (IsAuthorizedLevel(playerid, 4))
	{
		new id = (sscanf(params, "u", id)) ? playerid : strval(params);

		if (IsValidTargetPlayer(playerid, id))
		{
		    if (id == playerid)
		    {
		        if (Var(playerid, Duty))
		    		return SendClientMessage(playerid, c_red, "* You cannot use this command while on duty.");

		        SendClientMessage(playerid, ac_cmd1, "You have healed yourself.");
		        SendClientMessage(playerid, c_grey, "* You can also use '/heal - /h <playerid/name>' to heal other players.");

				SetPlayerHealth(playerid, 100.0);
				admin_CommandMessage(playerid, "heal");
			}
			else
			{
			    if (Var(id, Duty))
   					return SendClientMessage(playerid, c_red, "* Specified player cannot be healed.");

				SendClientMessage(id, ac_cmd2, sprintf("Admin %s has healed you.", playerName(playerid)));
				SendClientMessage(playerid, ac_cmd1, sprintf("You have healed %s.", playerName(id)));

				SetPlayerHealth(id, 100.0);
				admin_CommandMessage(playerid, "heal", id);
			}
		}
	}

	return 1;
}

CMD:givecash(playerid, params[])
{
	if (IsAuthorizedLevel(playerid, 4))
	{
		new id, cash;

		if (sscanf(params, "ud", id, cash))
	 		return error:_usage(playerid, "/givecash <playerid/name> <amount>");

		if (IsValidTargetPlayer(playerid, id))
		{
		    if (id == playerid)
		        return SendClientMessage(playerid, c_red, "* You cannot give yourself.");
		    
		    if (cash > 50000)
		        return SendClientMessage(playerid, c_red, "* You cannot give more than $50000");
		
			SendClientMessage(playerid, ac_cmd1, sprintf("You have given $%i to %s.", cash, playerName(id)));
			SendClientMessage(id, ac_cmd2, sprintf("You have received $%i from admin %s.", cash, playerName(playerid)));

			RewardPlayer(id, cash, 0, true);
			admin_CommandMessage(playerid, "givecash", id, cash);
		}
	}

	return 1;
}

/*******************************************************************************
								Level 5 commands
*******************************************************************************/
CMD:botsay(playerid, params[])
{
	if (IsAuthorizedLevel(playerid, 5))
	{
	    if (sscanf(params, "s[128]", params))
			return error:_usage(playerid, "/botsay <message>");

	    new message[128];

	    Format:message("%s: "#sc_white"%s", bot, params);

	    SendClientMessageToAll(ac_duty, message);
	}

	return 1;
}

CMD:pos(playerid, params[])
{
	if (IsAuthorizedLevel(playerid, 5))
	{
		new Float:x, Float:y, Float:z, Float:rot, int, world;

		GetPlayerPos(playerid, x, y, z);

		if (GetPlayerVehicleSeat(playerid) == -1)
			GetPlayerFacingAngle(playerid, rot);
		else
			GetVehicleZAngle(GetPlayerVehicleID(playerid), rot);

		int = GetPlayerInterior(playerid);
		world = GetPlayerVirtualWorld(playerid);

	 	SendClientMessage(playerid, ac_cmd1, sprintf("Position: X: %4.2f - Y: %4.2f - Z: %4.2f - Rotation: %4.2f - Interior ID: %i - World ID: %i", x, y, z, rot, int, world));
	}

	return 1;
}

CMD:gotopos(playerid, params[])
{
	if (IsAuthorizedLevel(playerid, 5))
	{
	    if (Var(playerid, DM) != 0 || Var(playerid, DuelID) != -1)
     		return SendClientMessage(playerid, c_red, "* You cannot use this command inside DM arena.");
		
		if (GetPlayerState(playerid) == PLAYER_STATE_SPECTATING)
		    return SendClientMessage(playerid, c_red, "* You cannot use this command while spectating.");
		
		new Float:x, Float:y, Float:z, Float:r;

		if (sscanf(params, "ffff", x, y, z, r))
			return error:_usage(playerid, "/gotopos <x> <y> <z> <rotation>");

		SetPlayerPos(playerid, x, y, z);
		SetPlayerFacingAngle(playerid, r);

		SendClientMessage(playerid, ac_cmd1, "Your position has been set to the following coordinates:");
		SendClientMessage(playerid, ac_cmd1, sprintf("X: %4.2f | Y: %4.2f | Z: %4.2f | Rotation: %4.2f", x, y, z, r));
	}

	return 1;
}

CMD:setdeaths(playerid, params[])
{
	if (IsAuthorizedLevel(playerid, 5))
	{
	    new id, amount;

	    if (sscanf(params, "ui", id, amount))
	        return error:_usage(playerid, "/setdeaths <playerid/name> <amount>");

		if (IsValidTargetPlayer(playerid, id))
		{
		    if (amount < 0 || amount > 200000)
		        return SendClientMessage(playerid, c_red, "Invalid amount.");

			Player(id, Deaths) = amount;

			new query[100];

			Query("UPDATE `users` SET `deaths`='%i' WHERE `id`='%i'", Player(id, Deaths), Player(id, UserID));
			mysql_tquery(connection, query, "ExecuteQuery", "i", res_none);

			SendClientMessage(playerid, ac_cmd1, sprintf("You have set %s's deaths to %i.", playerName(id), amount));
			SendClientMessage(id, ac_cmd2, sprintf("Admin %s has set your deaths to %i.", playerName(playerid), amount));

			admin_CommandMessage(playerid, "setdeath", id, amount);
			UpdateBoard(id);

			log(sprintf("Admin %s has set player %s's deaths to %i.", playerName(playerid), playerName(id), amount));
		}
	}

	return 1;
}

CMD:setkills(playerid, params[])
{
	if (IsAuthorizedLevel(playerid, 5))
	{
	    new id, amount;

	    if (sscanf(params, "ui", id, amount))
	        return error:_usage(playerid, "/setkills <playerid/name> <amount>");

		if (IsValidTargetPlayer(playerid, id))
		{
		    if (amount < 0 || amount > 200000)
   				return SendClientMessage(playerid, c_red, "* Invalid amount.");

			Player(id, Kills) = amount;

			new query[100];

			Query("UPDATE `users` SET `kills`='%i' WHERE `id`='%i'", Player(id, Kills), Player(id, UserID));
			mysql_tquery(connection, query, "ExecuteQuery", "i", res_none);

			SendClientMessage(playerid, ac_cmd1, sprintf("You have set %s's kills to %i.", playerName(id), amount));
			SendClientMessage(id, ac_cmd2, sprintf("Admin %s has set your kills to %i.", playerName(playerid), amount));
			admin_CommandMessage(playerid, "setkills", id, amount);

			UpdateBoard(id);

			log(sprintf("Admin %s has set player %s's kills to %i.", playerName(playerid), playerName(id), amount));
		}
	}

	return 1;
}

CMD:setscore(playerid, params[])
{
	if (IsAuthorizedLevel(playerid, 5))
	{
	    new id, amount;

	    if (sscanf(params, "ui", id, amount))
     		return error:_usage(playerid, "/setscore <playerid/name> <amount>");

		if (IsValidTargetPlayer(playerid, id))
		{
		    if (amount < 0 || amount > 200000)
		        return SendClientMessage(playerid, c_red, "* Invalid amount.");

			Player(id, Score) = amount;

			new query[100];

			Query("UPDATE `users` SET `score`='%i' WHERE `id`='%i'", Player(id, Score), Player(id, UserID));
			mysql_tquery(connection, query, "ExecuteQuery", "i", res_none);

			SendClientMessage(playerid, ac_cmd1, sprintf("You have set %s's score to %i.", playerName(id), amount));
			SendClientMessage(id, ac_cmd2, sprintf("Admin %s has set your score to %i.", playerName(playerid), amount));

			admin_CommandMessage(playerid, "setscore", id, amount);

			UpdateRank(id);

			log(sprintf("Admin %s has set player %s's score to %i.", playerName(playerid), playerName(id), amount));
		}
	}

	return 1;
}

CMD:setcash(playerid, params[])
{
	if (IsAuthorizedLevel(playerid, 5))
	{
	    new id, amount;

	    if (sscanf(params, "ui", id, amount))
	        return error:_usage(playerid, "/setcash <playerid/name> <amount>");

		if (IsValidTargetPlayer(playerid, id))
		{
		    if (amount < 0 || amount > 500000)
		        return SendClientMessage(playerid, c_red, "* Invalid amount.");

			Player(id, Money) = amount;

			new query[100];

			Query("UPDATE `users` SET `cash`='%i' WHERE `id`='%i'", Player(id, Money), Player(id, UserID));
			mysql_tquery(connection, query, "ExecuteQuery", "i", res_none);

			SendClientMessage(playerid, ac_cmd1, sprintf("You have set %s's money to $%i.", playerName(id), amount));
			SendClientMessage(id, ac_cmd2, sprintf("Admin %s has set your money to $%i.", playerName(playerid), amount));

			admin_CommandMessage(playerid, "setcash", id, amount);

			log(sprintf("Admin %s has set player %s's cash to.", playerName(playerid), playerName(id), amount));
		}
	}

	return 1;
}

CMD:addshop(playerid, params[])
{
    if (IsAuthorizedLevel(playerid, 5))
    {
    	if (GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
			return SendClientMessage(playerid, c_red, "* You must be on foot to use this command.");

		new shopid = Iter_Free(Shops);

		if (shopid >= MAX_SHOPS)
		    return SendClientMessage(playerid, c_red, "* Server exceeeds maximum number of shops.");

		new Float:x, Float:y, Float:z, query[200];

		GetPlayerPos(playerid, x, y, z);
		shop_Create(shopid, x, y, z, 0);
		admin_CommandMessage(playerid, "addshop");

		Query("INSERT INTO `shops` (shopid,teamid,shop_x,shop_y,shop_z) VALUES('%d','%d','%f','%f','%f')", shopid, 0, x, y, z);
		mysql_tquery(connection, query, "ExecuteQuery", "i", res_none);

		SendClientMessage(playerid, ac_cmd1, sprintf("Weapon shop created. | ID: %d |", shopid));
	}

    return 1;
}

CMD:delshop(playerid, params[])
{
	if (IsAuthorizedLevel(playerid, 5))
	{
		if (GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
			return SendClientMessage(playerid, c_red, "* You must be on foot to use this command.");

		new shopid = shop_ReturnClosestID(playerid);

		if (shopid == -1)
		    return SendClientMessage(playerid, c_red, "* No shops found near you.");

	    if (Shop(shopid, TeamID) != 0)
	        return SendClientMessage(playerid, c_red, "* You cannot delete team's shop.");
	
	    new query[100];

		admin_CommandMessage(playerid, "delshop");

	    Query("DELETE FROM `shops` WHERE `shopid`='%d'", shopid);
		mysql_tquery(connection, query, "ExecuteQuery", "i", res_none);

		DestroyPickup(Shop(shopid, ID));
		DestroyDynamicMapIcon(Shop(shopid, Icon));
		DestroyDynamicArea(Shop(shopid, Area));
		DestroyDynamic3DTextLabel(Shop(shopid, Label));

		Iter_Remove(Shops, shopid);

		for(new i; i <_: E_SHOP_DATA; ++i)
		{
			Shop(shopid, E_SHOP_DATA: i) = 0;
		}

		SendClientMessage(playerid, ac_cmd1, sprintf("Weapon shop deleted, ID: %i.", shopid));
	}

	return 1;
}

CMD:delflag(playerid, params[])
{
    if (IsAuthorizedLevel(playerid, 5))
    {
    	if (GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
			return SendClientMessage(playerid, c_red, "* You must be on foot to use this command.");

		new zoneid = zone_ReturnIDByArea(playerid);

		if (zoneid == -1)
		    return SendClientMessage(playerid, c_red, "* You must be inside a zone area to delete a flag.");

		if (!IsPlayerInRangeOfPoint(playerid, 2.0, Flag(zoneid, FlagX), Flag(zoneid, FlagY), Flag(zoneid, FlagZ)))
            return SendClientMessage(playerid, c_red, "You must be near the flag in order to delete.");
		
		if (Flag(zoneid, CapturingPlayer) != -1 || Flag(zoneid, Captured))
			return SendClientMessage(playerid, c_red, "The flag is not ready yet, you cannot delete it.");
	
		new query[130];

		zone_DeleteFlag(zoneid);
		admin_CommandMessage(playerid, "delflag");

		Query("UPDATE `zones` SET `flag_x`='0.0',`flag_y`='0.0',`flag_z`='0.0' WHERE `zone_id`='%i'", zoneid);
		mysql_tquery(connection, query, "ExecuteQuery", "i", res_none);

		SendClientMessage(playerid, ac_cmd1, sprintf("Zone flag deleted, ID: %i.", zoneid));
	}

    return 1;
}

CMD:addflag(playerid, params[])
{
    if (IsAuthorizedLevel(playerid, 5))
    {
    	if (GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
			return SendClientMessage(playerid, c_red, "* You must be on foot to use this command.");

		new zoneid = zone_ReturnIDByArea(playerid);

		if (zoneid == -1)
            return SendClientMessage(playerid, c_red, "* You must be inside a zone area to add a flag.");

	    if (Zone(zoneid, HasFlag) == true)
	    {
			zone_DeleteFlag(zoneid);
		}

		new Float:x, Float:y, Float:z, query[130];

		GetPlayerPos(playerid, x, y, z);

		Flag(zoneid, HoldingObj) = CreateDynamicObject(3885, x, y, z - 1.0, 0.0, 0.0, 0.0, -1, -1, -1, 300.00, 300.00);
        Flag(zoneid, Pickup) = CreateDynamicPickup(2993, 1, x, y, z);
		Flag(zoneid, FlagLabel) = CreateDynamic3DTextLabel(sprintf("%s flag\nFlag score: +%i\n\nPress 'Y' to pick up this flag", Zone(zoneid, Name), Zone(zoneid, Score) - 1), c_lightgrey, x, y, z, 50.0);
	    Flag(zoneid, CapturingPlayer) = -1;

	    Flag(zoneid, FlagX) = x;
	    Flag(zoneid, FlagY) = y;
	    Flag(zoneid, FlagZ) = z;

	    Zone(zoneid, HasFlag) = true;

	    SetPlayerPos(playerid, x, y, z + 2.0);

		admin_CommandMessage(playerid, "addflag");

		Query("UPDATE `zones` SET `flag_x`='%f',`flag_y`='%f',`flag_z`='%f' WHERE `zone_id`='%i'", x, y, z, zoneid);
		mysql_tquery(connection, query, "ExecuteQuery", "i", res_none);

		SendClientMessage(playerid, ac_cmd1, sprintf("Zone flag created. Zone ID: %i, zone name: %s.", zoneid, Zone(zoneid, Name)));
	}

    return 1;
}

/*CMD:setvip(playerid, params[]) {
	if (Player(playerid, Level) >= 5 || IsPlayerAdmin(playerid)) {
	    new id, level;

		if (sscanf(params, "ui", id, level)) {
			error:_usage(playerid, "/setvip <playerid/name> <level>");
		}
		else {
			if (IsValidTargetPlayer(playerid, id)) {
				if (level > 3) {
	                SendClientMessage(playerid, c_red, "* Invalid level.");
				}
				else {
					new oldlevel = Player(id, VIP);

			        if (oldlevel == level) {
		                SendClientMessage(playerid, c_red, "* Specified player's VIP level has not been changed.");
					}
					else {
					    new credits[][] = {
							{0}, {100}, {200}, {300}
						};

						Player(id, Credits) += credits[level][0];
						Player(id, VIP) = level;

						if (oldlevel < level) {
					       	SendClientMessage(id, ac_cmd2, sprintf("%s has set your VIP level to %s.", playerName(playerid), g_VIPName[level]));
				           	SendClientMessage(playerid, ac_cmd1, sprintf("You have set %s's VIP level to %s.", playerName(id), g_VIPName[level]));
						}

						if (oldlevel > level) {
				           	SendClientMessage(id, ac_cmd2, sprintf("%s has set your VIP level to %s.", playerName(playerid), g_VIPName[level]));
				           	SendClientMessage(playerid, ac_cmd1, sprintf("You have set %s's VIP level to %s.", playerName(id), g_VIPName[level]));
						}

						new query[138];

						Player(id, VIP_Time) = gettime() + 2592000;

						Query("UPDATE `users` SET `vip`='%i',`credits`='%i',`vip_time`='%i' WHERE `id`='%i'", Player(id, VIP), Player(id, Credits), Player(id, VIP_Time), Player(id, UserID));
						mysql_tquery(connection, query, "ExecuteQuery", "i", res_none);

						log(sprintf("Admin %s has set player %s's VIP status to %1 (%s).", playerName(playerid), playerName(id), level, g_VIPName[level]));
					}
				}
			}
		}
	}
	else
		return 0;

	return 1;
}*/

CMD:setadmin(playerid, params[])
{
    if (Player(playerid, Level) < 5 && !IsPlayerAdmin(playerid))
    	return 0;

    new id, newlevel;

	if (sscanf(params, "ui", id, newlevel))
		return error:_usage(playerid, "/setadmin <playerid/name> <level>");

	if (IsValidTargetPlayer(playerid, id))
	{
	    if (Player(playerid, Level) < 7 && !IsPlayerAdmin(playerid) && newlevel > 5)
			return SendClientMessage(playerid, c_red, "* You cannot set higher than level 5.");
		
		if (newlevel > 7)
            return SendClientMessage(playerid, c_red, "* Invalid level.");
		
		if (Player(id, Level) > Player(playerid, Level))
		    return SendClientMessage(playerid, c_red, "* Specified player's level cannot be changed.");

	 	new oldlevel = Player(id, Level);

	 	Player(id, Level) = newlevel;

		if (oldlevel == newlevel)
            return SendClientMessage(playerid, c_red, "* Specified player's level hasn't been changed.");

		if (oldlevel < newlevel)
		{
	       	SendClientMessage(id, ac_cmd2, sprintf("%s has set your admin level to %i.", playerName(playerid), newlevel));
           	SendClientMessage(playerid, ac_cmd1, sprintf("You have set %s's Admin level to %i.", playerName(id), newlevel));
            GameTextForPlayer(id, "~g~promoted", 2000, 5);
		}

		if (oldlevel > newlevel)
		{
           	SendClientMessage(id, ac_cmd2, sprintf("%s has set your Admin level to %i.", playerName(playerid), newlevel));
           	SendClientMessage(playerid, ac_cmd1, sprintf("You have set %s's Admin level to %i.", playerName(id), newlevel));
			GameTextForPlayer(id, "~r~demoted", 2000, 5);
		}

		new query[100];

		Query("UPDATE `users` SET `level`='%d' WHERE `id`='%d'", Player(id, Level), Player(id, UserID));
		mysql_tquery(connection, query, "ExecuteQuery", "i", res_none);

		log(sprintf("Admin %s has set player %s's admin level to %i.", playerName(playerid), playerName(id), newlevel));
	}

	return 1;
}

CMD:savevehicle(playerid, params[])
{
    if (IsAuthorizedLevel(playerid, 5))
    {
	    if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
			return SendClientMessage(playerid, c_red, "* You need to be driving a vehicle to use this command.");

		new vehicleid = GetPlayerVehicleID(playerid);

		if (Vehicle(vehicleid, BombingPlane) || Vehicle(vehicleid, Static) || vehicleid == Var(playerid, Vehicle))
		    return SendClientMessage(playerid, c_red, "* You cannot save this vehicle.");

		new Float:x, Float:y, Float:z, Float:a, model;

	   	GetVehiclePos(vehicleid, x, y, z);
	   	GetVehicleZAngle(vehicleid, a);
  		model = GetVehicleModel(vehicleid);

		switch (model)
		{
	        case 520: Vehicle(vehicleid, Type) = VEHICLE_TYPE_HYDRA;
			case 425: Vehicle(vehicleid, Type) = VEHICLE_TYPE_HUNTER;
			case 432: Vehicle(vehicleid, Type) = VEHICLE_TYPE_RHINO;
			case 447: Vehicle(vehicleid, Type) = VEHICLE_TYPE_SPARROW;
			default:  Vehicle(vehicleid, Type) = 0;
		}

		DestroyVehicle(vehicleid);

		vehicleid = AddServerVehicle(model, Vehicle(vehicleid, Type), x, y, z, a, random(128), random(128), 120);
		PutPlayerInVehicle(playerid, vehicleid, 0);

		new query[150];

		Query("INSERT INTO `serverVehicles` (model,type,x,y,z,a) VALUES('%i','%i','%f','%f','%f','%f')", model, Vehicle(vehicleid, Type), x, y, z, a);
		mysql_tquery(connection, query, "ExecuteQuery", "ii", res_insert_sv, vehicleid);

		SendClientMessage(playerid, ac_cmd1, "Vehicle has been saved to the database.");
		SendClientMessage(playerid, ac_cmd1, sprintf("Model: %d, X: %4.2f, Y: %4.2f, Z: %4.2f, Rotation: %4.2f", model, x, y, z, a));
	}

    return 1;
}

CMD:delvehicle(playerid, params[])
{
	if (IsAuthorizedLevel(playerid, 5))
	{
		new vehicleid;

		if (sscanf(params, "i", vehicleid))
			return error:_usage(playerid, "/delvehicle <vehicleid>");

		if (!IsValidVehicle(vehicleid))
			return SendClientMessage(playerid, c_red, "* Vehicle with this ID does not exist.");
		
		if (!Vehicle(vehicleid, Static) || Vehicle(vehicleid, BombingPlane))
		    return SendClientMessage(playerid, c_red, "* You cannot delete this vehicle.");

		DestroyVehicle(vehicleid);

		new query[100];

		Query("DELETE FROM `serverVehicles` WHERE `id`='%i'", Vehicle(vehicleid, dbID));
		mysql_tquery(connection, query, "QueryExecute", "i", res_none);

		SendClientMessage(playerid, ac_cmd1, sprintf("Vehicle has been deleted from the database, database ID: %i.", Vehicle(vehicleid, dbID)));

		new _x[E_VEHICLE_DATA];

		g_Vehicle[vehicleid] = _x;
	}

	return 1;
}

CMD:cregister(playerid, params[])
{
    if (IsAuthorizedLevel(playerid, 5))
    {
		ShowDialog(playerid, D_CLAN_NAME);
	}

	return 1;
}

CMD:cdelete(playerid, params[])
{
    if (IsAuthorizedLevel(playerid, 5))
	{
		if (sscanf(params, "s[45]", params))
		    return error:_usage(playerid, "/cdelete <clan name>");

		new query[128];

		Query("SELECT * FROM `clans` WHERE `clan_name`='%e'", params);
		mysql_tquery(connection, query, "ClanQuery", "iis", clan_res_delete, playerid, params);
	}

	return 1;
}

/*Player commands*/
// VIP
CMD:vfeat(playerid, params[])
{
	new id = (sscanf(params, "u", id)) ? playerid : strval(params);

	if (IsValidTargetPlayer(playerid, id))
	{
		if (id == playerid)
		{
			ShowVIPFeatures(playerid, playerid);
			admin_CommandMessage(playerid, "vfeat");

			SendClientMessage(playerid, c_lightgrey, "You can also use '/vfeat <playerid/name>' to view other player's VIP features.");
		}
		else
		{
		    if (IsTargetPlayerSpawned(playerid, id))
		    {
				ShowVIPFeatures(id, playerid);

				admin_CommandMessage(playerid, "vfeat", id);
			}
		}
	}

	return 1;
}

CMD:vcmds(playerid, params[])
{
	new level;

	if (sscanf(params, "i", level))
		return error:_usage(playerid, "/vcmds <level: 1-3>");

	SendClientMessage(playerid, c_vcmd, sprintf("VIP %s commands:", g_VIPName[level]));

	switch (level)
	{
		case 1: SendClientMessage(playerid, c_vcmd, "  /vbike, /vtime, /vweather, /vfeat, /vvc, /vnos, /vammo, /vweaps, /vskin, /vdefault");
		case 2: SendClientMessage(playerid, c_vcmd, "  VIP Silver commands + /vbt, /vcar and /vfr");
		case 3: SendClientMessage(playerid, c_vcmd, "  VIP Bronze and Silver commands + /var, /vplane, /vheli and /vboat");
		default: SendClientMessage(playerid, c_red, "Invalid level.");
	}

	SendClientMessage(playerid, c_lightyellow, "* Use '$ <text>' to chat in VIP chat.");
	admin_CommandMessage(playerid, "vcmds", level);
	
	return 1;
}

CMD:vtime(playerid, params[] )
{
	if (Player(playerid, VIP) < 1)
		return 0;

    new hour;

	if (sscanf(params, "i", hour))
        return error:_usage(playerid, "/vtime <hour 0-23>");

	if (hour > 23)
	    return SendClientMessage(playerid, c_red, "* Invalid hour format, max: 23H.");

	admin_CommandMessage(playerid, "vtime", hour);

	SetPlayerTime(playerid, hour, 0);
	SendClientMessage(playerid, c_vcmd, sprintf("* Your world time has been set to %02d:00.", hour));

	return 1;
}

CMD:vweather(playerid, params[])
{
	if (Player(playerid, VIP) < 1)
		return 0;
	
    new weatherid;

    if (sscanf(params, "i", weatherid))
        return error:_usage(playerid, "/vweather <weatherid>");
	
	if(weatherid > 50)
	    return SendClientMessage(playerid, c_red, "* Invalid weather.");

	admin_CommandMessage(playerid, "vweather", weatherid);

	SetPlayerWeather(playerid, weatherid);
	SendClientMessage(playerid, c_vcmd, sprintf("* Your game weather has been changed to %i.", weatherid));

	return 1;
}

CMD:vvc(playerid, params[])
{
	if (Player(playerid, VIP) < 1)
		return 0;

	new c1, c2;

	if (sscanf(params, "ii", c1, c2))
		return SendClientMessage(playerid, c_grey, "/vvc <color1> <color2>");
	
	if (c1 > 255 || c2 > 255)
		return SendClientMessage(playerid, c_red, "* Invalid primary or secondary color.");
	
	if (!IsPlayerInAnyVehicle(playerid))
		return SendClientMessage(playerid, c_red, "* You must be inside a vehicle to use this command.");

	new vehicleid = GetPlayerVehicleID(playerid);

	ChangeVehicleColor(vehicleid, c1, c2);

	admin_CommandMessage(playerid, "vvc", c1, c2);
	SendClientMessage(playerid, c_vcmd, sprintf("* Vehicle color changed, primary: %i, secondary: %i.", c1, c2));

	return 1;
}

CMD:vnos(playerid, params[])
{
	if (Player(playerid, VIP) < 1)
		return 0;

	if (!IsPlayerInAnyVehicle(playerid))
		return SendClientMessage(playerid, c_red, "* You must be inside a vehicle to use this command.");

	new vehicleid = GetPlayerVehicleID(playerid);

	AddVehicleComponent(vehicleid, 1009);
	admin_CommandMessage(playerid, "vnos");

	SendClientMessage(playerid, c_vcmd, "* x2 nitro has been added to your vehicle.");

	return 1;
}

CMD:vammo(playerid, params[])
{
	if (Player(playerid, VIP) < 1)
		return 0;

	if (Var(playerid, VIPAmmoTime) > gettime())
	    return SendClientMessage(playerid, c_red, "* You can only use this command once every 2 minutes.");

	GiveAllWeaponAmmo(playerid, 100);

	SendClientMessage(playerid, c_vcmd, "* You received +100 ammo for all of your weapons (except explosives).");
	admin_CommandMessage(playerid, "vammo");

	Var(playerid, VIPAmmoTime) = gettime() + 120;

	return 1;
}

CMD:vweaps(playerid, params[])
{
    if (Player(playerid, VIP) < 1)
		return 0;

	if (Var(playerid, DM) != 0 || Var(playerid, DuelID) != -1)
        return SendClientMessage(playerid, c_red, "* You cannot use this command inside DM arena.");
	
	if (Var(playerid, VIPWepsUsed) == 1)
		return SendClientMessage(playerid, c_red, "* You can only use this command once after spawn.");
	
	new pack;

	if (sscanf(params, "i", pack))
	    return error:_usage(playerid, "/vweaps <Pack: 1-3>");
	
	if (pack == 0 || pack > 3)
	    return SendClientMessage(playerid, c_red, "Invalid pack. [1-3]");

	new w[4][4] = {
	    {0, 0, 0, 0},
		{27, 24, 31, 34},
		{25, 24, 29, 30},
		{33, 23, 28, 25}
	};

	for(new i = 0; i < 4; i++)
	{
		GivePlayerWeapon(playerid, w[pack][i], 100);
	}

	SendClientMessage(playerid, c_vcmd, sprintf("* You received a weapon pack %i containing following weapons with 100 rounds of ammo:", pack));
	SendClientMessage(playerid, c_vcmd, sprintf("  %s, %s, %s, %s", aWeaponNames[w[pack][0]], aWeaponNames[w[pack][1]], aWeaponNames[w[pack][2]], aWeaponNames[w[pack][3]]));
	admin_CommandMessage(playerid, "vweaps", pack);

	Var(playerid, VIPWepsUsed) = 1;

	return 1;
}

CMD:vskin(playerid, params[])
{
    if (Player(playerid, VIP) < 1)
		return 0;

	if (IsPlayerInAnyVehicle(playerid))
		return SendClientMessage(playerid, c_red, "* Set your skin on foot to avoid glitch.");

	new skin;

	if (sscanf(params, "i", skin))
		return error:_usage(playerid, "/vskin <skinid>");

	if (IsValidSkin(playerid, skin))
	{
		SendClientMessage(playerid, c_vcmd, sprintf("* Your skin has been set to ID %i.", skin));

		SetSkin(playerid, skin);
		Var(playerid, Skin) = skin;
		admin_CommandMessage(playerid, "vskin", skin);
	}

	return 1;
}

CMD:vdefault(playerid, params[])
{
	if (Player(playerid, VIP) < 1)
		return 0;

	if (!IsPlayerInAnyVehicle(playerid))
		return SendClientMessage(playerid, c_red, "* You must be inside a vehicle to use this command.");

	new vehicleid = GetPlayerVehicleID(playerid);

	if (vehicleid != Var(playerid, Vehicle))
	    return SendClientMessage(playerid, c_red, "* You can only use this command on a vehicle spawned with a VIP command.");

	new teamid, color1, color2;

	teamid = Player(playerid, Team);
	color1 = g_TeamVehicleColors[teamid][0];
	color2 = g_TeamVehicleColors[teamid][1];

	ChangeVehicleColor(vehicleid, color1, color2);

	admin_CommandMessage(playerid, "vdefault");
	SendClientMessage(playerid, c_vcmd, "* Vehicle color has been changed to the default one.");

	return 1;
}

CMD:vbike(playerid, params[])
{
    if (Player(playerid, VIP) < 1)
		return 0;

    if (Var(playerid, DM) != 0 || Var(playerid, DuelID) != -1)
        return SendClientMessage(playerid, c_red, "* You cannot use this command inside DM arena.");
	
	if (GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
		return SendClientMessage(playerid, c_red, "* You must be on foot to use this command.");
	
	if (!IsEnemyNear(playerid, 30.0))
	{
		if (Var(playerid, Vehicle) != 0)
		{
			DestroyVehicle(Var(playerid, Vehicle));
			Var(playerid, Vehicle) = 0;
		}

		switch (Player(playerid, VIP))
		{
			case 1: GiveVehicle(playerid, 463, 1);
			case 2: GiveVehicle(playerid, 468, 1);
			case 3: GiveVehicle(playerid, 522, 1);
		}

		SendClientMessage(playerid, c_vcmd, "* VIP bike spawned, enjoy!");
		admin_CommandMessage(playerid, "vbike");
	}

	return 1;
}

CMD:vbt(playerid, params[])
{
    if (Player(playerid, VIP) < 2)
		return 0;

	if (Var(playerid, Duty))
        return SendClientMessage(playerid, c_red, "* You cannot use this command while on duty.");
	
	if (Var(playerid, DM) != 0 || Var(playerid, DuelID) != -1)
        return SendClientMessage(playerid, c_red, "* You cannot use this command inside DM arena.");
	
	if (gettime() < Var(playerid, BT_Used))
		return SendClientMessage(playerid, c_red, "* You can use this command once every 5 minutes.");

	foreach(new i : Player)
	{
		if (i != playerid && Var(i, Spawned) && !Var(i, Duty)) 
		{
			if (Player(i, Team) == Player(playerid, Team)){
				GivePlayerWeapon(i, 35, 1);

				SetPlayerHealth(i, 100.0);
				SetPlayerArmour(i, 100.0);
			}
		}
	}

	SendClientMessageToAll(0xFFFF00FF, sprintf("- VIP %s has boosted their teammates.", playerName(playerid)));

	SendClientMessage(playerid, c_vcmd, "* Your team has been boosted with +1 rocket launcher, full health and armour.");
	admin_CommandMessage(playerid, "vbt");

	Var(playerid, BT_Used) = gettime() + 300;

	return 1;
}

CMD:vcar(playerid, params[])
{
    if (Player(playerid, VIP) < 2)
		return 0;

	if (Var(playerid, DM) != 0 || Var(playerid, DuelID) != -1)
        return SendClientMessage(playerid, c_red, "* You cannot use this command inside DM arena.");
	
	if (GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
		return SendClientMessage(playerid, c_red, "* You must be on foot to use this command.");

    if (!IsEnemyNear(playerid, 30.0))
    {
		if (Var(playerid, Vehicle) != 0)
		{
			new vehicleid, model;

			vehicleid = Var(playerid, Vehicle);
			model = GetVehicleModel(vehicleid);

			switch (model)
			{
			    case 560, 565:
			    {
			        for (new i = 0, j = 14; i < j; i++)
			        {
			            RemoveVehicleComponent(vehicleid, GetVehicleComponentInSlot(vehicleid, i));
			        }
			    }
			}

			DestroyVehicle(vehicleid);
			Var(playerid, Vehicle) = 0;
		}

		switch (Player(playerid, VIP))
		{
			case 2: GiveVehicle(playerid, 560, 1);
			case 3: GiveVehicle(playerid, 565, 1);
		}

		SendClientMessage(playerid, c_vcmd, "* VIP car spawned, enjoy!");
		admin_CommandMessage(playerid, "vcar");
	}

	return 1;
}

CMD:vfr(playerid, params[])
{
    if (Player(playerid, VIP) < 2)
		return 0;
	
	if (Player(playerid, VIP) < 3 && Player(playerid, Class) != VIPCLASS)
	    return SendClientMessage(playerid, c_red, "* Only VIP class can use this command.");
	
	if (Var(playerid, DFR_Used) > gettime())
	    return SendClientMessage(playerid, c_red, "* You can only use this command once every 5 minutes.");

	foreach(new i : Player)
	{
	    if (GetPlayerState(i) == PLAYER_STATE_DRIVER)
	    {
	        if (Player(playerid, Team) != Player(i, Team))
	        {
				if (RangeBetween(playerid, i) < 30.0)
				{
				    SetVehicleHealth(GetPlayerVehicleID(i), 0.0);
				    SendClientMessage(i, c_red, sprintf("%s has set fire to your vehicle.", playerName(playerid)));
				}
			}
		}
	}

	Var(playerid, DFR_Used) = gettime() + 300;
	SendClientMessage(playerid, c_vcmd, "* You have successfully set fire to enemy player's vehicle.");
	RewardPlayer(playerid, -5000, 0);

	admin_CommandMessage(playerid, "vfr");

	return 1;
}

CMD:var(playerid, params[])
{
	if (Player(playerid, VIP) < 3)
	    return 0;
	
	new id;

	if (sscanf(params, "u", id))
	    return error:_usage(playerid, "/var <playerid/name>");

	if (IsValidTargetPlayer(playerid, id))
	{
	    if (id == playerid)
	        return SendClientMessage(playerid, c_red, "* You cannot use this command on yourself.");
		
		if (RangeBetween(playerid, id) > 4.0)
	        return SendClientMessage(playerid, c_red, "* You must be near the specified player in order to give armour.");
		
		if (Player(id, Team) != Player(playerid, Team))
	        return SendClientMessage(playerid, c_red, "* You cannot give armour to an enemy player.");
 		
 		if (Var(id, JustArmoured) > gettime())
  			return SendClientMessage(playerid, c_red, "* Specified player was armoured recently, please wait 60 seconds.");

		new Float:ar;

		GetPlayerArmour(id, ar);

		if (ar == 100.0)
		    return SendClientMessage(playerid, c_red, "* Specified player does not need to be armoured.");
		
		SetPlayerArmour(id, 100.0);

		Var(id, JustArmoured) = gettime() + 60;

		RewardPlayer(playerid, 4000, 1, true);
		SendClientMessage(playerid, c_vcmd, sprintf("* You have armoured %s, received $4000 and +1 score.", playerName(id)));
		SendClientMessage(id, c_lightyellow, sprintf("%s has armoured you.", playerName(playerid)));

		admin_CommandMessage(playerid, "var", id);
	}

	return 1;
}

CMD:vplane(playerid, params[])
{
    if (Player(playerid, VIP) < 3)
		return 0;

	if (Var(playerid, DM) != 0 || Var(playerid, DuelID) != -1)
        return SendClientMessage(playerid, c_red, "* You cannot use this command inside DM arena.");
	
	if (GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
		return SendClientMessage(playerid, c_red, "* You must be on foot to use this command.");

    if (!IsEnemyNear(playerid, 30.0))
	{
		if (Var(playerid, Vehicle) != 0)
		{
			DestroyVehicle(Var(playerid, Vehicle));
			Var(playerid, Vehicle) = 0;
		}
		GiveVehicle(playerid, 513, 1);
		SendClientMessage(playerid, c_vcmd, "* VIP plane spawned, enjoy!");
		admin_CommandMessage(playerid, "vplane");
	}

	return 1;
}

CMD:vheli(playerid, params[])
{
    if (Player(playerid, VIP) < 3)
		return 0;
		
	if (Var(playerid, DM) != 0 || Var(playerid, DuelID) != -1)
        return SendClientMessage(playerid, c_red, "* You cannot use this command inside DM arena.");
	
	if (GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
		return SendClientMessage(playerid, c_red, "* You must be on foot to use this command.");

    if (!IsEnemyNear(playerid, 30.0))
	{
		if (Var(playerid, Vehicle) != 0)
		{
			DestroyVehicle(Var(playerid, Vehicle));
			Var(playerid, Vehicle) = 0;
		}
		GiveVehicle(playerid, 487, 1);
		SendClientMessage(playerid, c_vcmd, "* VIP helicopter spawned, enjoy!");
		admin_CommandMessage(playerid, "vheli");
	}

	return 1;
}

CMD:vboat(playerid, params[])
{
    if (Player(playerid, VIP) < 3)
		return 0;

	if (Var(playerid, DM) != 0 || Var(playerid, DuelID) != -1)
       return SendClientMessage(playerid, c_red, "* You cannot use this command inside DM arena.");
	
	if (GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
		return SendClientMessage(playerid, c_red, "* You must be on foot to use this command.");
	
    if (!IsEnemyNear(playerid, 30.0))
	{
		if (Var(playerid, Vehicle) != 0)
		{
			DestroyVehicle(Var(playerid, Vehicle));
			Var(playerid, Vehicle) = 0;
		}
		GiveVehicle(playerid, 446, 1);
		SendClientMessage(playerid, c_vcmd, "* VIP boat spawned, enjoy!");
		admin_CommandMessage(playerid, "vboat");
	}

	return 1;
}

// Normal players
CMD:help(playerid, params[])
{
    admin_CommandMessage(playerid, "help");
	
	new d_text[1300];
	
	strcat(d_text, ""#sc_grey"Introduction:\n");
	strcat(d_text, "\t"#sc_lightgrey"This is a TDM (Team DeathMatch) server. You can act as a soldier to fight against your team's enemies.\n");
	strcat(d_text, "\n");
	strcat(d_text, ""#sc_grey"Teams & classes:\n");
	strcat(d_text, "\t"#sc_lightgrey"There are several teams available for which you can choose to play on, along with classes that have its own abilities of which you can choose\n");
	strcat(d_text, "\tupon reaching the required rank to choose a specfic class. Type '/teams' to see list of all teams and '/chelp' to know basics of your class.\n");
	strcat(d_text, "\n");
	strcat(d_text, ""#sc_grey"Tasks:\n");
	strcat(d_text, "\t"#sc_lightgrey"You can do certain tasks to earn score and money such as capturing zones, stealing flags, repairing collapsed bridges, and many more tasks.\n");
	strcat(d_text, "\n");
	strcat(d_text, ""#sc_grey"Ranks:\n");
	strcat(d_text, "\t"#sc_lightgrey"There are up to 15 ranks and each has its own perks such as unlocking armed vehicles and classes. Type '/ranks' for the list of all ranks.\n");
	strcat(d_text, "\n");
    strcat(d_text, ""#sc_grey"Other features:\n");
    strcat(d_text, "\t"#sc_lightgrey"There are some features which you can use to gain rewards such as nuclear bomb, andromada bombing, base SAM etc...\n");
    strcat(d_text, "\tYou can find commands for the info of these features in the commands list.\n");
    strcat(d_text, "\n");
    strcat(d_text, ""#sc_grey"Other help commands: "#sc_lightgrey"/zonehelp, /flaghelp, /chelp, /bdhelp, /bridgehelp, /nukehelp, /abhelp, /invhelp\n\n");
    strcat(d_text, "To get the full list of server commands, type '/commands' or '/cmds'");
    ShowPlayerDialog(playerid, D_MSG, DIALOG_STYLE_MSGBOX, "Help:", d_text, "Close", "");
	
	return 1;
}

CMD:donate(playerid, params[])
{
    admin_CommandMessage(playerid, "donate");
	ShowDialog(playerid, D_DONATE);

	return 1;
}

CMD:zonehelp(playerid, params[])
{
    admin_CommandMessage(playerid, "zonehelp");
	
	new d_str[1000];

	strcat(d_str, ""#sc_lightgrey"The server has many zones available for capture. You can earn score and money upon capturing a zone.\n");
	strcat(d_str, "To capture, go to the zone's pickup (a yellow arrow pointing down) once you pick its pickup, capture process\n");
	strcat(d_str, "will start. Stay in the zone until the capture process ends. Each zone have set amount of capture time and score\n");
	strcat(d_str, "but the money you receive is random. example; Area 51's capture\n");
	strcat(d_str, "time is 60 seconds, score it gives is 7. You can see the zone's name, its capture time, and score near\n");
	strcat(d_str, "its capture point. The reward and capture time also depends on how big the zone is. Means, smaller zones can be captured\n");
	strcat(d_str, "faster but gives low rewards whereas bigger zones take longer to capture but gives high rewards as well.\n");
    strcat(d_str, "\n");
	strcat(d_str, "Some of the zones can provide you with extra bonuses. For example, if your team has the Ammunation captured, your team will receive\n");
	strcat(d_str, "+10 ammo every 60 seconds until your team loses it.");
	ShowPlayerDialog(playerid, D_MSG, DIALOG_STYLE_MSGBOX, "Help about 'Capture the Zone' feature:", d_str, "Close", "");
	
	return 1;
}

CMD:flaghelp(playerid, params[])
{
    admin_CommandMessage(playerid, "flaghelp");

	new d_str[700];

	strcat(d_str, ""#sc_lightgrey"There are flags in all the zones that are available for capture. You can steal the flag and drop at your\n");
	strcat(d_str, "home base to gain rewards. To steal a flag, go to a zone and find the flag pickup, stand near the flag and\n");
	strcat(d_str, "press 'Y' key to pick it up. Once you pick the flag up, you will see a red marker on your radar, it is the\n");
	strcat(d_str, "checkpoint where you need to drop the flag. After you have successfully dropped the flag in your base, it will\n");
	strcat(d_str, "re-appear on its spot after 5 minutes. If you get killed by an enemy player, you will lose 1 score but\n");
	strcat(d_str, "the killer will be rewarded for stopping you from stealing the flag.");
	ShowPlayerDialog(playerid, D_MSG, DIALOG_STYLE_MSGBOX, "Help about 'Steal the Flag' feature:", d_str, "Close", "");
	
	return 1;
}

CMD:invhelp(playerid, params[])
{
    admin_CommandMessage(playerid, "invhelp");
	
	new d_str[700];

	strcat(d_str, ""#sc_lightgrey"This system allows you to buy inventory items from your base's shop in order to use them when needed.\n");
	strcat(d_str, "You can buy items such as medikits, ammo packs etc... To buy the items, go to your base's shop and click\n");
	strcat(d_str, "on 'Inventory items' then select the item you want to buy. Every item has its own limit, for example; you\n");
	strcat(d_str, "cannot buy more than 3 medikits. You can also give your inventory items to your teammates. Note that the\n");
	strcat(d_str, "inventory items do not save, means, your items will be gone when you disconnect from the server.\n");
	strcat(d_str, "\n");
	strcat(d_str, ""#sc_grey"Commands: "#sc_lightgrey"/inventory (/inv), /usekit, /givekit, /ammopack (/ap), /giveap\n");
	strcat(d_str, ""#sc_grey"Side note: "#sc_lightgrey"More inventory items will be added in the future update of the server.\n");
	ShowPlayerDialog(playerid, D_MSG, DIALOG_STYLE_MSGBOX, "Help about 'Inventory' feature:", d_str, "Close", "");
	
	return 1;
}

CMD:chelp(playerid, params[])
{
    admin_CommandMessage(playerid, "chelp");
    Var(playerid, FromCommand) = 1;
	ShowClassInfo(playerid, Player(playerid, Class), true);
	
	return 1;
}

CMD:bshelp(playerid, params[])
{
    admin_CommandMessage(playerid, "bshelp");

    new d_str[500];

    strcat(d_str, ""#sc_lightgrey"This feature allows you to destroy the enemy players' aircraft in your base's airspace.\n");
	strcat(d_str, "Every team, excluding Mercenary and Terrorist, have their own base SAM missile launcher\n");
	strcat(d_str, "in their home base. In order to launch, go to the base SAM launcher and pick its pickup,\n");
	strcat(d_str, "you need to be rank 2+ and have $20000. You will receive score, money and kills depending\n");
	strcat(d_str, "on how many aircraft you destroy. The missile launcher takes 2 minutes to be fully charged once used.");
	ShowPlayerDialog(playerid, D_MSG, DIALOG_STYLE_MSGBOX, "Help about 'Base SAM' feature:", d_str, "Close", "");

	return 1;
}

CMD:mhelp(playerid, params[])
{
	admin_CommandMessage(playerid, "mhelp");
    
    new d_str[500];
    
    strcat(d_str, ""#sc_lightgrey"This is a feature that lets you launch a toxic bomb from the Ground Zero Island.\n");
	strcat(d_str, "In order to launch, you must have $500,000 and be rank 5. The bomb decreases 50% from all players\n");
	strcat(d_str, "health in the server. Players that are having below 50% will die and you will get the amount of kills\n");
	strcat(d_str, "depending on how many players die. Note that only players that are on-foot will he affected.\n");
	ShowPlayerDialog(playerid, D_MSG, DIALOG_STYLE_MSGBOX, "Help about 'MOAB' feature:", d_str, "Close", "");
	
	return 1;
}

CMD:rhelp(playerid, params[])
{
    admin_CommandMessage(playerid, "rhelp");
    
    new d_str[700];
    
    strcat(d_str, ""#sc_lightgrey"There are currently two features that you can use at the Radio Station.\n");
	strcat(d_str, "\n");
	strcat(d_str, "Radio Hack: This feature can be used to hack enemy team's radio, allowing your team\n");
	strcat(d_str, "to see the radio communication of the affected team.\n");
	strcat(d_str, "\n");
	strcat(d_str, "Radio Damage: This feature damages the selected team's radio, making the team unable\n");
 	strcat(d_str, "to use their radio for 5 minutes.\n");
 	strcat(d_str, "\n");
 	strcat(d_str, "Both features have a cooldown time of 5 minutes. You can check the time in /times.\n");
	strcat(d_str, "You must be rank 4 to use either feature. The cost can be found on its dialog.");
	ShowPlayerDialog(playerid, D_MSG, DIALOG_STYLE_MSGBOX, "Help about 'Radio Station' feature:", d_str, "Close", "");
	
	return 1;
}

CMD:abhelp(playerid, params[])
{
    admin_CommandMessage(playerid, "abhelp");
    
    new d_str[600];
    
    strcat(d_str, ""#sc_lightgrey"With this feature, you can drop bombs at the targeted enemy's base using the Andromada from Las Venturas Airport.\n");
	strcat(d_str, "In order to use this feature, your team must have the Las Venturas Airport captured. You must fly the plane\n");
	strcat(d_str, "on the target's airspace and press the 'spacebar' key to drop. Only Pilot and VIP classes are authorized\n");
	strcat(d_str, "to fly this plane. When you drop the bombs at the selected base, it will kill all the players in it. You will receive\n");
	strcat(d_str, "the reward depending on the amount of players you kill. Once bombed, the plane takes some time to be fully loaded again.");
	ShowPlayerDialog(playerid, D_MSG, DIALOG_STYLE_MSGBOX, "Help about 'Andromada Bombing' feature:", d_str, "Close", "");
	
	return 1;
}

CMD:nukehelp(playerid, params[]) 
{
    admin_CommandMessage(playerid, "nukehelp");
    
    new d_str[1000];
    
    strcat(d_str, ""#sc_lightgrey"The nuclear feature allows you to kill enemy players in certain zones/bases. In order to launch, you must be rank 5+,\n");
	strcat(d_str, "have Area51 captured and have $200000. The bomb kills all the enemy players in the targeted area, you will earn score,\n");
	strcat(d_str, "money and kills depending on the amount of players you kill. Once the nuclear bomb has been launched, it will take 10 minutes\n");
	strcat(d_str, "to be fully charged again. You can see the remaining time by typing '/times'. Nuclear effect will remain in the targeted\n");
	strcat(d_str, "area and players in that area will lose -5 health every 30 seconds. However, players with anti teargas mask will not be\n");
	strcat(d_str, "affected. To see which area is affected, type '/affected'. The effect will last until the bomb is ready to be used again\n");
	strcat(d_str, "i.e 10 minutes but if your team has Abandoned Airport captured, you can wipe out the effect which will cost you $20000\n");
	strcat(d_str, "but you will also get some score. You also need to be rank 2+ to wipe the effect out.");
    ShowPlayerDialog(playerid, D_MSG, DIALOG_STYLE_MSGBOX, "Help about 'Nuclear' feature:", d_str, "Close", "");
	
	return 1;
}

CMD:bridgehelp(playerid, params[])
{
    admin_CommandMessage(playerid, "bridgehelp");

    new d_str[500];

    strcat(d_str, ""#sc_lightgrey"This is a system in which the Demolisher class from Terrorist team can demolish the bridges using bombs to earn score and money.\n");
	strcat(d_str, "Similarly, players from other teams can repair the damaged bridges to earn the reward. The team must capture the zone of the damaged\n");
	strcat(d_str, "bridge in order to repair. Any class can repair the damaged bridges but Engineers can repair 2x faster.\n");
    strcat(d_str, "\n");
	strcat(d_str, ""#sc_grey"Associated commands: "#sc_lightgrey"/rbridge, /plant, /bridges");
	ShowPlayerDialog(playerid, D_MSG, DIALOG_STYLE_MSGBOX, "Help about 'Bridge' system:", d_str, "Close", "");

	return 1;
}

CMD:commands(playerid, params[])
{
	ShowCommandPage(playerid);
	admin_CommandMessage(playerid, "commands - /cmds");

	return 1;
}

CMD:cmds(playerid, params[])
{
	return cmd_commands(playerid, params);
}

CMD:rules(playerid, params[])
{
	new text[800];

	strcat(text, ""#sc_grey"1: "#sc_lightgrey"Do not spam/flood the main chat.\n");
	strcat(text, ""#sc_grey"2: "#sc_lightgrey"Do not team attack.\n");
	strcat(text, ""#sc_grey"3: "#sc_lightgrey"Do not use illegal mods.\n");
	strcat(text, ""#sc_grey"4: "#sc_lightgrey"Do not insult, flame or provoke other players/staffs.\n");
	strcat(text, ""#sc_grey"5: "#sc_lightgrey"Do not use c-bug or slide-bug outside of deathmatch arena.\n");
	strcat(text, ""#sc_grey"6: "#sc_lightgrey"No farming of score or money.\n");
	strcat(text, ""#sc_grey"7: "#sc_lightgrey"Do not abuse any kind of bugs.\n");
	strcat(text, ""#sc_grey"8: "#sc_lightgrey"Do not use CAPSLOCK in the main chat.\n");
	strcat(text, ""#sc_grey"9: "#sc_lightgrey"Any kind of weapon bug is strictly foridden.\n");
	strcat(text, ""#sc_grey"10: "#sc_lightgrey"Committing suicide to avoid being killed by enemy players is forbidden.\n");
	strcat(text, "\n");
	strcat(text, ""#sc_grey"* For detailed list of rules, visit: "#sc_lightgrey"www.teamdss.com/server-rules");
	ShowPlayerDialog(playerid, D_MSG, DIALOG_STYLE_MSGBOX, "Rules", text, "Close", "");
    admin_CommandMessage(playerid, "rules");

	return 1;
}

/******************************************************************************/
/*                          Clan commands                                     */
/******************************************************************************/
CMD:csettings(playerid, params[])
{
	new clanid = Player(playerid, ClanID);

	if (clanid == -1)
	    return SendClientMessage(playerid, c_red, "* You are not a member of any clan.");
	
	if (!clan_IsPlayerLeader(playerid, clanid))
	    return SendClientMessage(playerid, c_red, "* You are not a leader of this clan.");

	ShowDialog(playerid, D_CLAN_SETTINGS);

	return 1;
}

CMD:ccmds(playerid, parms[])
{
	new text[700];
	
	strcat(text, ""#sc_green"/cettings"#sc_lightgrey" - Open clan settings.\n");
	strcat(text, ""#sc_green"/topclans"#sc_lightgrey" - Display a list of top 10 clans.\n");
	strcat(text, ""#sc_green"/cmembers"#sc_lightgrey" - Display a list of online clan members.\n");
	strcat(text, ""#sc_green"/cinvite"#sc_lightgrey" - Add a player to the clan. (For leaders only)\n");
	strcat(text, ""#sc_green"/cremove"#sc_lightgrey" - Remove a member from the clan. (For leaders only)\n");
	strcat(text, ""#sc_green"/cjoin"#sc_lightgrey" - Accept clan invitation.\n");
	strcat(text, ""#sc_green"/crefuse"#sc_lightgrey" - Refuse clan invitation.\n");
 	strcat(text, ""#sc_green"/csetleader"#sc_lightgrey" - Make a clan member a leader. (For founder only)\n");
	strcat(text, ""#sc_green"/cremleader"#sc_lightgrey" - Unset leader status of a member. (For founder only)\n");
 	strcat(text, ""#sc_green"/cinfo"#sc_lightgrey" - Display clan information.");
 	ShowPlayerDialog(playerid, D_MSG, DIALOG_STYLE_MSGBOX, "Clan commands", text, "Close", "");
 	admin_CommandMessage(playerid, "ccmds");
	
	return 1;
}

CMD:cw(playerid, params[])
{
    new clanid = Player(playerid, ClanID);

	if (clanid == -1)
	    return SendClientMessage(playerid, c_red, "* You are not a member of any clan.");
	
	if (!clan_IsPlayerLeader(playerid, clanid))
		return SendClientMessage(playerid, c_red, "* You are not a leader of this clan.");
	
	if (Var(playerid, DM) != 0 || Var(playerid, DuelID) != -1)
	    return SendClientMessage(playerid, c_red, "* You must be outside of DM stadium to send.");
	
	if (g_SpecID[playerid] != INVALID_PLAYER_ID)
		return SendClientMessage(playerid, c_red, "* You cannot send while on spectating mode.");
    
    if (Clan(clanid, CW_Invited))
    	return SendClientMessage(playerid, c_red, "* Your clan already has a clan war invitation received, accept or deny before sending.");
    
    if (clan_IsPlayingCW(clanid))
    	return SendClientMessage(playerid, c_red, "* Your clan is already playing a clan war.");
	
	if (Clan(clanid, CW_Requested) != -1)
	    return SendClientMessage(playerid, c_red, "* Your clan has already requested for a clan war, wait for them to accept or deny.");

    switch (Player(playerid, Team))
    {
        case TERRORIST, MERCENARY:
            return SendClientMessage(playerid, c_red, "* You must be in other team than Terrorist and Mercenary to send.");
		
		default:
		{
		    new clan, members, bet, rounds;

		    if (sscanf(params, "iiii", clan, members, bet, rounds))
		        return error:_usage(playerid, "/cw <against clanid> <max members> <bet clan point> <max rounds>");

		    if (!Clan(clan, Exist))
				return SendClientMessage(playerid, c_red, "* Specified clan does not exist, type /clans for the valid IDs.");
			
			if (clan == clanid)
			    return SendClientMessage(playerid, c_red, "* You cannot send a clan war request to your own clan.");
			
			if (!clan_CountLeaders(clan))
			    return SendClientMessage(playerid, c_red, "* No leaders online from the specified clan.");
			
			if (Clan(clan, CW_Invited))
			    return SendClientMessage(playerid, c_red, "* Specified clan already has a clan war invitation received.");
			
			if (clan_IsPlayingCW(clan))
			    return SendClientMessage(playerid, c_red, "* Specified clan is currently playing a clan war.");
			
			if (members < 1 || members > 5)
			    return SendClientMessage(playerid, c_red, "* Max members cannot be lower than 3 and higher than 5.");
			
			if (bet < 10)
			    return SendClientMessage(playerid, c_red, "* Minium of 10 clan points needed for bet.");
			
			if (bet > 100)
			    return SendClientMessage(playerid, c_red, "* Bet cannot be higher than 100.");
            
            if (rounds == 0 || rounds > 5)
			    return SendClientMessage(playerid, c_red, "* Max rounds cannot be lower than 1 or higher than 5.");

		    new slot = CW_ReturnFreeSlot();

			Clan(clanid, CW_Requested) = clan;
		    Clan(clan, CW_InvitingPlayer) = playerid;
		    Clan(clan, CW_Invited) = true;
		    Var(playerid, PlayingCW) = slot;

		    CW(slot, Members) = members;
		    CW(slot, Bet) = bet;
		    CW(slot, Interior) = 1;
		    CW(slot, Clan1) = clanid;
		    CW(slot, Clan2) = clan;
		    CW(slot, MaxRounds) = rounds;
		    CW(slot, Rounds) = 1;
		    SendClientMessage(playerid, c_green, sprintf("You have sent a clan war invitation to %s.", Clan(clan, Name)));
		    SendClientMessage(playerid, c_green, sprintf("Max members slot: %i, Interior: %s, Bet points: %i, Max rounds: %i.", members, g_CWInteriorName[1], bet, rounds));
            GameTextForPlayer(playerid, ""#TXT_LINE"~y~~h~Clan War~n~~w~invitation sent", 4000, 3);
			
			foreach(new i : Player)
			{
			    if (Player(i, ClanID) == clan && Player(i, ClanLeader))
			    {
			        SendClientMessage(i, c_green, sprintf("CLAN WAR: %s wants to have a clan war with %s, requested by leader %s.", Clan(clanid, Name), Clan(clanid, Name), playerName(playerid)));
		            SendClientMessage(i, c_green, sprintf("Max members slot: %i, Interior: %s, Bet points: %i, Max rounds: %i.", members, g_CWInteriorName[1], bet, rounds));
					SendClientMessage(i, c_green, "* Type /cwaccept to accept the clan war request.");
					GameTextForPlayer(i, ""#TXT_LINE"~g~~h~Clan War~n~~w~invitation received", 4000, 3);
			    }
			}
		}
	}

	return 1;
}

CMD:cwaccept(playerid, params[])
{
    new clanid = Player(playerid, ClanID);
    
    if (clanid == -1)
	    return SendClientMessage(playerid, c_red, "* You are not a member of any clan.");
	
	if (!clan_IsPlayerLeader(playerid, clanid))
		return SendClientMessage(playerid, c_red, "* You are not a leader of this clan.");
	
	if (!Clan(clanid, CW_Invited))
		return SendClientMessage(playerid, c_red, "* Your clan has no clan war invitation received.");
 	
 	if (Var(playerid, DM) != 0 || Var(playerid, DuelID) != -1)
	    return SendClientMessage(playerid, c_red, "* You must be outside of DM stadium to accept.");
	
	if (g_SpecID[playerid] != INVALID_PLAYER_ID)
		return SendClientMessage(playerid, c_red, "* You cannot accept while on spectating.");

    switch (Player(playerid, Team))
    {
        case TERRORIST, MERCENARY: SendClientMessage(playerid, c_red, "* You must be in other team than Terrorist and Mercenary to accept.");
		default: CW_AcceptInvitation(clanid, playerid);
	}

	return 1;
}

CMD:cwstart(playerid, params[])
{
	new cwid = Var(playerid, PlayingCW);
	
	if (cwid == -1)
		return SendClientMessage(playerid, c_red, "* You don't have a clan war started.");
 
	new clanid = Player(playerid, ClanID);

	if (clanid == -1)
		return SendClientMessage(playerid, c_red, "* You are not a member of any clan.");
	
	if (!clan_IsPlayerLeader(playerid, clanid))
		return SendClientMessage(playerid, c_red, "* You are not a leader of this clan.");
	
	if (CW(cwid, Started))
	    return SendClientMessage(playerid, c_red, "* A round has already been started.");
	
	if (CW(cwid, Clan1) == -1 || CW(cwid, Clan2) == -1)
 		return SendClientMessage(playerid, c_red, "* The clan war request has not been accepted yet.");
	
	if (CW(cwid, Clan1_Members) != CW(cwid, Clan2_Members))
		return SendClientMessage(playerid, c_red, "* Members are not balanced, clan war cannot be started.");
    
    if (!CW_CanRoundStart(cwid))
    	return SendClientMessage(playerid, c_red, "* Please wait...");

	CW_StartRound(cwid);

	return 1;
}

CMD:cwadd(playerid, params[])
{
    new cwid = Var(playerid, PlayingCW);
	
	if (cwid == -1)
		return SendClientMessage(playerid, c_red, "* You don't have a clan war started.");
	
	new clanid = Player(playerid, ClanID);

	if (clanid == -1)
		return SendClientMessage(playerid, c_red, "* You are not a member of any clan.");
	
	if (!clan_IsPlayerLeader(playerid, clanid))
		return SendClientMessage(playerid, c_red, "* You are not a leader of this clan.");
	
	if (CW(cwid, Started))
	    return SendClientMessage(playerid, c_red, "* A round has already been started, you cannot add.");

    new id;

	if (sscanf(params, "u", id))
		return error:_usage(playerid, "/cwadd <playerid/name>");

    if (IsValidTargetPlayer(playerid, id))
    {
        if (IsTargetPlayerSpawned(playerid, id))
        {
            if (id == playerid)
                return SendClientMessage(playerid, c_red, "* You cannot add yourself.");
	        
	        if (Player(id, ClanID) != clanid)
	            return SendClientMessage(playerid, c_red, "* Specified player is not a member of your clan.");
			
			if (Var(id, PlayingCW) != -1)
			    return SendClientMessage(playerid, c_red, "* Specified player has already been added.");
            
            if (Player(id, Jailed) != 0)
                return SendClientMessage(playerid, c_red, "* Specified player is currently in jail.");
			
			if (Var(id, DM) != 0 || Var(id, DuelID) != -1)
			    return SendClientMessage(playerid, c_red, "* Specified player is currently in DM stadium.");
			
			if (g_SpecID[id] != INVALID_PLAYER_ID)
			    return SendClientMessage(playerid, c_red, "* Specified player is currently spectating.");
			
			if (Player(id, Team) != Player(playerid, Team))
			    return SendClientMessage(playerid, c_red, "* Specified player must be in your team.");
			
			if (Player(id, Class) != SOLDIER)
			    return SendClientMessage(playerid, c_red, "* Specified player must be soldier class.");

		    if (Player(id, Protected) != 0)
				PlayerProtection(id, PROTECTION_END);

			if (Var(id, CapturingFlag) != -1)
		        zone_StopFlagCapture(id);

			CW_AddPlayer(cwid, id);
			SendClientMessage(playerid, c_green, sprintf("You have added %s to the clan war list.", playerName(id)));
			SendClientMessage(id, c_green, sprintf("Leader %s has added you to the clan war list.", playerName(playerid)));
		}
	}

	return 1;
}

CMD:cwmembers(playerid, params[])
{
    new cwid = Var(playerid, PlayingCW);
    
	if (cwid == -1)
		return SendClientMessage(playerid, c_red, "* You don't have a clan war started.");

    SendClientMessage(playerid, c_lightyellow, "Your clan war members:");

    foreach(new i : Player)
    {
        if (Var(i, PlayingCW) == cwid && Player(i, ClanID) == Player(playerid, ClanID))
        {
            SendClientMessage(playerid, c_lightyellow, sprintf("  %s[%i]", playerName(i), i));
        }
    }

	return 1;
}

CMD:cwremove(playerid, params[])
{
    new cwid = Var(playerid, PlayingCW);

	if (cwid == -1)
		return SendClientMessage(playerid, c_red, "* You don't have a clan war started.");

    new clanid = Player(playerid, ClanID);

	if (clanid == -1)
		return SendClientMessage(playerid, c_red, "* You are not a member of any clan.");
	
	if (!clan_IsPlayerLeader(playerid, clanid))
		return SendClientMessage(playerid, c_red, "* You are not a leader of this clan.");
	
	if (CW(cwid, Started))
	    return SendClientMessage(playerid, c_red, "* A round has already been started, you cannot remove.");

    new id;

	if (sscanf(params, "u", id))
		return error:_usage(playerid, "/cwremove <playerid/name>");

    if (IsValidTargetPlayer(playerid, id))
    {
        if (IsTargetPlayerSpawned(playerid, id))
        {
            if (id == playerid)
                return SendClientMessage(playerid, c_red, "* You cannot remove yourself.");
	        
	        if (Player(id, ClanID) != clanid)
	            return SendClientMessage(playerid, c_red, "* Specified player is not a member of your clan.");
			
			if (Var(id, PlayingCW) == -1)
			    return SendClientMessage(playerid, c_red, "* Specified player has not been added to the list.");
            
            if (Player(id, Jailed) != 0)
                return SendClientMessage(playerid, c_red, "* Specified player is currently in jail.");
			
			if (Var(id, DM) != 0 || Var(id, DuelID) != -1)
			    return SendClientMessage(playerid, c_red, "* Specified player is currently in DM stadium.");
			
			if (g_SpecID[id] != INVALID_PLAYER_ID)
			    return SendClientMessage(playerid, c_red, "* Specified player is currently spectating.");

			CW_RemovePlayer(id);
			ProtectedSpawn(id);
			SendClientMessage(playerid, c_red, sprintf("You have removed %s from the clan war list.", playerName(id)));
			SendClientMessage(id, c_red, sprintf("Leader %s has removed you from the clan war list.", playerName(playerid)));
		}
	}

	return 1;
}

CMD:cwdeny(playerid, params[])
{
    new clanid = Player(playerid, ClanID);

	if (clanid == -1)
		return SendClientMessage(playerid, c_red, "* You are not a member of any clan.");
	
	if (!clan_IsPlayerLeader(playerid, clanid))
		return SendClientMessage(playerid, c_red, "* You are not a leader of this clan.");
	
	if (!Clan(clanid, CW_Invited))
		return SendClientMessage(playerid, c_red, "* Your clan has no clan war invitation received.");

    new leaderid, slot;
    
    leaderid = Clan(clanid, CW_InvitingPlayer);
	slot = Var(leaderid, PlayingCW);
	
	if (CW(slot, Started))
	    return SendClientMessage(playerid, c_red, "* A round has already been started.");

    SendClientMessage(leaderid, c_red, sprintf("Leader %s has denied your clan war invitation.", playerName(playerid)));
    SendClientMessage(playerid, c_red, sprintf("You have denied the clan war invitation from %s", Clan(Player(leaderid, ClanID), Name)));

    CW(slot, Members) = 0;
    CW(slot, Bet) = 0;
    CW(slot, Interior) = 0;
    CW(slot, Clan1) = -1;
    CW(slot, Clan2) = -1;
    CW(slot, MaxRounds) = 0;
	Var(leaderid, PlayingCW) = -1;
	Clan(clanid, CW_InvitingPlayer) = INVALID_PLAYER_ID;
	Clan(clanid, CW_Invited) = false;
	Clan(Player(leaderid, ClanID), CW_Requested) = -1;

	return 1;
}

CMD:cwcancel(playerid, params[])
{
	new cwid = Var(playerid, PlayingCW);

	if (cwid == -1)
		return SendClientMessage(playerid, c_red, "* No clan war has been started.");

	new clanid = Player(playerid, ClanID);

    if (clanid == -1)
	    return SendClientMessage(playerid, c_red, "* You are not a member of any clan.");
	
	if (!clan_IsPlayerLeader(playerid, clanid))
	    return SendClientMessage(playerid, c_red, "* You are not a leader of this clan.");
    
    if (CW(cwid, Started))
	    return SendClientMessage(playerid, c_red, "* A round has already been started.");

    CW_Cancel(cwid, sprintf("%s has canceled the clan war.", playerName(playerid)));

	return 1;
}

CMD:topclans(playerid, params[])
{
	new id[10], pts[10], clan_points;

    admin_CommandMessage(playerid, "topclans");
	SendClientMessage(playerid, -1, "Top 10 clans:");
	
	for (new i = 0; i < 10; i++)
	{
	    id[i] = -1;
	    pts[i] = -500000;
	}
	
	foreach(new i : Clans)
	{
	    clan_points = Clan(i, Points);

		for (new j = 0; j < 10; ++j)
		{
	        if (clan_points > pts[j])
			{
	            if (j != 9)
				{
	            	for (new k = 8; k >= j; k--)
					{
	            	    pts[k + 1] = pts[k];
	            	    id[k + 1] = id[k];
	            	}
	            }
	            pts[j] = clan_points;
	            id[j] = i;
				break;
	        }
	    }
	}

	for (new i = 0; i < 10; i++)
	{
	    if (id[i] < 0)
			break;
		
		SendClientMessage(playerid, -1, sprintf("   %i: %s - %s [CPoints: %i]", i + 1, Clan(id[i], Tag), Clan(id[i], Name), pts[i]));
	}

	return 1;
}

CMD:cmembers(playerid, params[])
{
	new clanid = Player(playerid, ClanID);

	if (clanid == -1)
	    return SendClientMessage(playerid, c_red, "* You are not a member of any clan.");

    admin_CommandMessage(playerid, "cmembers");
    SendClientMessage(playerid, c_lightyellow, sprintf("Online members of clan %s:", Clan(clanid, Name)));

	new count = 0;

	foreach(new i : Player)
	{
	    if (Player(i, ClanID) == clanid)
		{
	        count++;
			SendClientMessage(playerid, c_lightyellow, sprintf("   %s (ID: %i)%s", playerName(i), i, (Player(i, ClanLeader)) ? (" (Leader)") : ("")));
	    }
	}

	return 1;
}

CMD:cremove(playerid, params[])
{
	new clanid = Player(playerid, ClanID);
	
	if (clanid == -1)
	    return SendClientMessage(playerid, c_red, "* You are not a leader of any clan.");

	if (clan_IsPlayerLeader(playerid, clanid))
	{
	    if (sscanf(params, "s[24]", params))
			return error:_usage(playerid, "/cremove <member name>");

		new id = return_IDByName(params);

		if (id != -1 && id == playerid)
		    return SendClientMessage(playerid, c_red, "* You cannot use this command on yourself.");
		
		if (!strcmp(Clan(clanid, Founder), params))
		    return SendClientMessage(playerid, c_red, "* You cannot remove the clan founder.");

		new query[135];

		Query("SELECT `id`,`nick`,`clanid`,`clan_leader` FROM `users` WHERE `nick`='%e'", params);
		mysql_tquery(connection, query, "ClanQuery", "iisi", clan_res_removemember, playerid, params, id);
		admin_CommandMessage(playerid, "cremove");
	}

	return 1;
}

CMD:cinvite(playerid, params[])
{
	new clanid = Player(playerid, ClanID);

	if (clanid == -1)
	    return SendClientMessage(playerid, c_red, "* You are not a leader of any clan.");

	if (clan_IsPlayerLeader(playerid, clanid))
	{
	    new id;

	    if (sscanf(params, "u", id))
			return error:_usage(playerid, "/cinvite <playerid/name>");

	    if (IsValidTargetPlayer(playerid, id))
	    {
	        if (id == playerid)
			    return SendClientMessage(playerid, c_red, "* You cannot use this command on yourself.");

	        if (Player(id, ClanID) == clanid)
	            return SendClientMessage(playerid, c_red, "* Sepcified player is already a member of this clan.");
			
			if (Player(id, ClanID) != -1)
			    return SendClientMessage(playerid, c_red, "* Specified player is already a member of another clan.");

			SendClientMessage(playerid, c_green, sprintf("You have sent %s an invitation to join %s.", playerName(id), Clan(clanid, Name)));
			SendClientMessage(id, c_green, sprintf("You have received an invitation from %s to join %s.", playerName(playerid), Clan(clanid, Name)));
			SendClientMessage(id, c_green, "Type /cjoin to join the clan, /crefuse to refuse the invitation.");
			Var(id, InvitedClan) = clanid;
			Var(id, ClanInvitePlayer) = playerid;
			admin_CommandMessage(playerid, "cinvite", id);
		}
	}

	return 1;
}

CMD:cjoin(playerid, params[])
{
    new clanid = Var(playerid, InvitedClan);

    if (clanid == -1)
		return SendClientMessage(playerid, c_red, "* You do not have any invitation received.");

    new query[133];
    
    ++Clan(clanid, MemberCount);
    Query("UPDATE `users` SET `clanid`='%i' WHERE `id`='%i'", clanid, Player(playerid, UserID));
	mysql_tquery(connection, query, "ExecuteQuery", "i", res_none);
	Query("UPDATE `clans` SET `clan_members`='%i' WHERE `clan_id`='%i'", Clan(clanid, MemberCount), clanid);
	mysql_tquery(connection, query, "ExecuteQuery", "i", res_none);
	
	Player(playerid, ClanID) = clanid;
	SendClientMessage(playerid, c_green, sprintf("Congratulations on joining the clan "#sc_white"%s", Clan(clanid, Name)));
   	SendClientMessage(playerid, c_green, sprintf("Make sure to post a request to change your name for the %s tag.", Clan(clanid, Tag)));
	SendClientMessage(playerid, c_grey, "Type '/cinfo' to display the information of this clan.");
	clan_SendMessage(clanid, c_clan, sprintf("Player %s has joined the clan.", playerName(playerid)));
	Var(playerid, ClanInvitePlayer) = INVALID_PLAYER_ID;
	admin_CommandMessage(playerid, "cjoin");
	
	return 1;
}

CMD:crefuse(playerid, params[])
{
    new clanid = Var(playerid, InvitedClan);

    if (clanid == -1)
		return SendClientMessage(playerid, c_red, "* You do not have any invitation received.");

    Var(playerid, InvitedClan) = -1;
	SendClientMessage(playerid, c_green, sprintf("You refused to join the clan "#sc_white"%s", Clan(clanid, Name)));
	SendClientMessage(Var(playerid, ClanInvitePlayer), c_red, sprintf("* %s has refused the invitation to join the clan.", playerName(playerid)));
	Var(playerid, ClanInvitePlayer) = INVALID_PLAYER_ID;
	admin_CommandMessage(playerid, "crefuse");
}

CMD:clans(playerid, params[])
{
    admin_CommandMessage(playerid, "clans");
    ShowDialog(playerid, D_CLANS);

    return 1;
}

CMD:csetleader(playerid, params[])
{
	new clanid = Player(playerid, ClanID);

	if (clanid == -1)
	    return SendClientMessage(playerid, c_red, "* You are not a leader of any clan.");

	if (clan_IsPlayerLeader(playerid, clanid))
	{
	    if (sscanf(params, "s[24]", params))
			return error:_usage(playerid, "/csetleader <username>");

		new id = return_IDByName(params);

		if (id != -1 && id == playerid)
		    return SendClientMessage(playerid, c_red, "* You cannot use this command on yourself.");

		new query[135];

		Query("SELECT `id`,`nick`,`clanid`,`clan_leader` FROM `users` WHERE `nick`='%e'", params);
		mysql_tquery(connection, query, "ClanQuery", "iisii", clan_res_setleader, playerid, params, id, 1);
		admin_CommandMessage(playerid, "csetleader");
	}

	return 1;
}

CMD:cremleader(playerid, params[])
{
	new clanid = Player(playerid, ClanID);

	if (clanid == -1)
	    return SendClientMessage(playerid, c_red, "* You are not a leader of any clan.");

	if (clan_IsPlayerLeader(playerid, clanid))
	{
	    if (sscanf(params, "s[24]", params))
			return error:_usage(playerid, "/cremleader <username>");

		new id = return_IDByName(params);
		
		if (id != -1 && id == playerid)
		    return SendClientMessage(playerid, c_red, "* You cannot use this command on yourself.");
		
		if (!strcmp(Clan(clanid, Founder), params))
		    return SendClientMessage(playerid, c_red, "* You cannot remove the clan founder.");

		new query[135];

		Query("SELECT `id`,`nick`,`clanid`,`clan_leader` FROM `users` WHERE `nick`='%e'", params);
		mysql_tquery(connection, query, "ClanQuery", "iisii", clan_res_setleader, playerid, params, id, 0);
		admin_CommandMessage(playerid, "cremleader");
	}

	return 1;
}

CMD:cinfo(playerid, params[])
{
	new clanid = (sscanf(params, "i", clanid)) ? Player(playerid, ClanID) : strval(params);
	    
	if (clanid == Player(playerid, ClanID))
	{
	    if (clanid == -1)
	        return SendClientMessage(playerid, c_red, "* You are not in any clan.");

		clan_ShowInfo(playerid, clanid);
		SendClientMessage(playerid, c_grey, "* You can also use /cinfo <clanid> to view other clan's information.");
		admin_CommandMessage(playerid, "cinfo");
	}
	else
	{
	    if (clanid == -1)
	        return SendClientMessage(playerid, c_red, "* Specified clan does not exist");

		clan_ShowInfo(playerid, clanid);
		admin_CommandMessage(playerid, "cinfo", clanid);
	}

	return 1;
}

/******************************************************************************/

CMD:getid(playerid, params[])
{
	if (sscanf(params, "s[24]", params))
		return error:_usage(playerid, "/getid <part of name>");

	new count = 0;

	SendClientMessage(playerid, c_orange, sprintf("Showing ID for: %s", params));

	foreach(new i : Player)
	{
	    if (strfind(playerName(i), params, true) != -1)
	    {
			SendClientMessage(playerid, c_orange, sprintf("   %s's ID: %i", playerName(i), i));
			count++;
		}
	}

	admin_CommandMessage(playerid, "getid");

	if (!count)
	{
		SendClientMessage(playerid, c_red, "* Could not find ID for this name.");
	}

	return 1;
}

CMD:affected(playerid, params[])
{
	if (Nuke(AffectedArea) == -1)
	    return SendClientMessage(playerid, c_red, "* None of the area is affected by the nuclear bomb.");

	SendClientMessage(playerid, c_green, sprintf("* Area currently affected by the nuclear bomb: %s.", nuke_ReturnAffectedAreaName()));
	admin_CommandMessage(playerid, "affected");

	return 1;
}

CMD:sync(playerid, params[])
{
    if (GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
		return SendClientMessage(playerid, c_red, "* You must be on foot to use this command.");
	
	if (Player(playerid, Protected) != 0)
		return SendClientMessage(playerid, c_red, "Please wait...");
	
	if (Var(playerid, Duty))
		return SendClientMessage(playerid, c_red, "* You cannot use this command while on admin duty.");

	if (!IsEnemyNear(playerid, 30.0))
	{
	    if (gettime() < Sync(playerid, Time))
			return SendClientMessage(playerid, c_red, "* You can only sync once every 2 minutes.");

		Synchronize(playerid, 1);

		SendClientMessage(playerid, c_green, "Synchronized.");

		Sync(playerid, Time) = gettime() + 120;
		admin_CommandMessage(playerid, "sync");
	}

	return 1;
}

CMD:rpm(playerid, params[])
{
	if (sscanf(params, "s[128]", params))
		return error:_usage(playerid, "/rpm <message>");
	
	if (Player(playerid, Muted) >= gettime())
	    return MuteWarn(playerid);
	
	if (strlen(params) > 110)
		return SendClientMessage(playerid, c_red, "* Your message is too long.");

	new id = Var(playerid, LastPM);

	if (IsValidTargetPlayer(playerid, id))
	{
	    if (Var(id, DND))
			return SendClientMessage(playerid, c_red, "* Specified player is currently on DND mode.");

	    if (CheckIP(playerid, params))
	    {
	        Var(id, LastPM) = playerid;

			SendClientMessage(playerid, c_yellow, sprintf("PM > %s[%i]: %s", playerName(id), id, params));
			SendClientMessage(id, c_yellow, sprintf("PM < %s[%i]: %s", playerName(playerid), playerid, params));
            SendClientMessage(id, c_grey, sprintf("Type '/rpm' to reply to %s's PM.", playerName(playerid)));

            IRC_Echo(g_IRC_Conn[IRC_ADMIN_CHANNEL], sprintf("14PM: %s[%i] to %s[%i]: %s", playerName(playerid), playerid, playerName(id), id, params));
			admin_SendPM(playerid, id, sprintf("PM: %s > %s: %s", playerName(playerid), playerName(id), params));

            PlayerPlaySound(id, 1085, 0.0, 0.0, 0.0);
            GameTextForPlayer(playerid, ""#TXT_LINE"~y~~h~pm sent", 2000, 3);
			GameTextForPlayer(id, ""#TXT_LINE"~g~~h~~h~pm received", 3000, 3);
		}
	}

	return 1;
}

CMD:para(playerid, params[])
{
	GivePlayerWeapon(playerid, 46, 1);

	SendClientMessage(playerid, c_green, "You got a parachute. Cost: $500.");
	RewardPlayer(playerid, -500, 0);

	admin_CommandMessage(playerid, "para");

	return 1;
}

CMD:changepass(playerid, params[])
{
	return ShowDialog(playerid, D_CHANGEPASS_1);
}

CMD:pm(playerid, params[])
{
	new id;

	if (sscanf(params, "us[128]", id, params))
		return error:_usage(playerid, "/pm <id/name> <message>");

	if (Player(playerid, Muted) >= gettime())
	    return MuteWarn(playerid);
	
	if (strlen(params) > 110)
		return SendClientMessage(playerid, c_red, "* Your message is too long.");
	
	if (IsValidTargetPlayer(playerid, id))
	{
		if (id == playerid)
			return SendClientMessage(playerid, c_red, "* You cannot PM yourself.");
		
		if (Var(id, DND))
			return SendClientMessage(playerid, c_red, "* Specified player is currently on DND mode.");
	
		if (CheckIP(playerid, params))
		{
			PlayerPlaySound(id, 1085, 0.0, 0.0, 0.0);
			Var(id, LastPM) = playerid;

			SendClientMessage(playerid, c_yellow, sprintf("PM > %s[%i]: %s", playerName(id), id, params));
			
			if (IsPlayerPaused(id))
			{
			    SendClientMessage(playerid, c_tomato, "Specified player is currently paused, they might miss your private message.");
			}
			
			SendClientMessage(id, c_yellow, sprintf("PM < %s[%i]: %s", playerName(playerid), playerid, params));
			SendClientMessage(id, c_grey, sprintf("* Type '/rpm' to reply to %s's PM.", playerName(playerid)));

			GameTextForPlayer(playerid, ""#TXT_LINE"~y~~h~pm sent", 2000, 3);
			GameTextForPlayer(id, ""#TXT_LINE"~g~~h~~h~pm received", 3000, 3);

			IRC_Echo(g_IRC_Conn[IRC_ADMIN_CHANNEL], sprintf("14PM: %s[%i] to %s[%i]: %s", playerName(playerid), playerid, playerName(id), id, params));
			admin_SendPM(playerid, id, sprintf("PM: %s > %s: %s", playerName(playerid), playerName(id), params));
		}
	}

	return 1;
}

CMD:vips(playerid, params[])
{
	admin_CommandMessage(playerid, "vips");
    SendClientMessage(playerid, c_purple, "Online VIPs:");

	new count = 0;

	foreach(new i : Player)
	{
	    if (Player(i, VIP) >= 1)
	    {
		    SendClientMessage(playerid, c_purple, sprintf("   %s[%d] - VIP %s", playerName(i), i, g_VIPName[Player(i, VIP)]));
			count++;
		}
	}

	if (!count)
	{
	 	SendClientMessage(playerid, c_red, "- None -");
	}

	return 1;
}

CMD:repair(playerid, params[])
{
	if (Player(playerid, Class) != ENGINEER)
		return SendClientMessage(playerid, c_red, "* Only engineer class is authorized to use this command.");
	
	if (Var(playerid, JustRepaired) > gettime())
	    return SendClientMessage(playerid, c_red, "* You can only use this command once every 2 minutes.");

		new id;

	if (sscanf(params, "u", id))
	    return error:_usage(playerid, "/repair <playerid/name>");

	if (IsValidTargetPlayer(playerid, id))
	{
	    if (id == playerid)
				return SendClientMessage(playerid, c_red, "* You cannot use this command on yourself.");
		
		if (RangeBetween(playerid, id) > 4.0)
	        return SendClientMessage(playerid, c_red, "* You must be near the specified player in order to repair.");
		
		if (Player(id, Team) != Player(playerid, Team))
	        return SendClientMessage(playerid, c_red, "* You cannot repair enemy player's vehicle.");
		
		if (GetPlayerState(id) != PLAYER_STATE_DRIVER)
 		    return SendClientMessage(playerid, c_red, "* Specified player is not driving any vehicle.");

		new vehicleid = GetPlayerVehicleID(id);

		RepairVehicle(vehicleid);

		if (Vehicle(vehicleid, Type) != 0)
		{
			SetVehicleHealth(vehicleid, g_ArmedVehicle[Vehicle(vehicleid, Type)][av_Health]);
		}

		SendClientMessage(playerid, c_green, sprintf("You have fixed %s's vehicle. Received $4500 and +1 score.", playerName(id)));
		SendClientMessage(id, c_lightyellow, sprintf("Engineer %s has fixed your vehicle.", playerName(playerid)));
		RewardPlayer(playerid, 4500, 1, true);

		Var(playerid, JustRepaired) = gettime() + 120;

		admin_CommandMessage(playerid, "repair", id);
	}

	return 1;
}

CMD:h(playerid, params[])
{
	if (Player(playerid, Class) != MEDIC && Player(playerid, VIP) < 2)
		return SendClientMessage(playerid, c_red, "* Only VIP Silver and paramedic are authorized to use this command.");

	new id;

	if (sscanf(params, "u", id))
	    return error:_usage(playerid, "/h <playerid/name>");

	if (IsValidTargetPlayer(playerid, id))
	{
	    if (id == playerid)
	        return SendClientMessage(playerid, c_red, "* You cannot use this command on yourself.");
		
		if (RangeBetween(playerid, id) > 4.0)
	        return SendClientMessage(playerid, c_red, "* You must be near the specified player in order to heal.");
		
		if (Player(id, Team) != Player(playerid, Team))
	        return SendClientMessage(playerid, c_red, "* You cannot heal an enemy player.");
 		
 		if (Var(id, JustHealed) > gettime())
  			return SendClientMessage(playerid, c_red, "* Specified player was healed recently, please wait 60 seconds.");

		new Float:hp;

		GetPlayerHealth(id, hp);

		if (hp == 100.0)
		    return SendClientMessage(playerid, c_red, "* Specified player does not need to be healed.");

		SetPlayerHealth(id, 100.0);

		Var(id, JustHealed) = gettime() + 60;

		RewardPlayer(playerid, 4000, 1, true);
		SendClientMessage(playerid, c_green, sprintf("You have healed %s, received $4000 and +1 score.", playerName(id)));
		SendClientMessage(id, c_lightyellow, sprintf("%s has healed you.", playerName(playerid)));

		admin_CommandMessage(playerid, "h", id);
	}

	return 1;
}

CMD:serverstats(playerid, params[])
{
	SendClientMessage(playerid, 0xA9C4E4FF, "[DSS] Call of Duty - Warground, TDM. Version: "#server_version"");
	SendClientMessage(playerid, 0xA9C4E4FF, sprintf("   Players: %i/100 | Vehicles: %i/2000 | Time: %i:00 | Weather ID: %i | Max ping: %s",
		Server(Players), GetVehiclePoolSize(), Server(Time), Server(Weather), (Server(MaxPing)) ? (sprintf("%i", Server(MaxPing))) : ("Disabled")));
	SendClientMessage(playerid, 0xA9C4E4FF, sprintf("   Total zones: %i", Server(Zones)));
	admin_CommandMessage(playerid, "serverstats");
	
	return 1;
}

CMD:inventory(playerid, params[])
{
	SendClientMessage(playerid, c_lightyellow, "Your inventory items:");
	SendClientMessage(playerid, c_lightyellow, sprintf("   Medikits: %i/3", Var(playerid, MediKits)));
	SendClientMessage(playerid, c_lightyellow, sprintf("   Ammo packs: %i/3", Var(playerid, AmmoPack)));
	SendClientMessage(playerid, c_lightyellow, sprintf("   Has bombs: %s", Var(playerid, HasBombs) ? ("Yes") : ("No")));
	SendClientMessage(playerid, c_lightyellow, sprintf("   Disguise Kits: %i/3", Var(playerid, DisKit)));
	admin_CommandMessage(playerid, "inventory - /inv");
	
	return 1;
}

CMD:inv(playerid, params[])
{
	return cmd_inventory(playerid, params);
}

CMD:disguise(playerid, params[])
{
	if (Player(playerid, Class) != SPY)
	    return SendClientMessage(playerid, c_red, "* Only spy class can use this command.");
	
	if (Var(playerid, DM) != 0 || Var(playerid, DuelID) != -1)
        return SendClientMessage(playerid, c_red, "* You cannot use this command inside DM arena.");
	
	if (Player(playerid, Protected) != 0)
 		return SendClientMessage(playerid, c_red, "Please wait...");
	
	if (Var(playerid, DisKit) == 0)
 		return SendClientMessage(playerid, c_red, "* You are out of disguise kit.");

	if (sscanf(params, "s[24]", params))
	    return error:_usage(playerid, "/disguise - /dis <part of team name>");

	new teamid = team_ReturnIDByName(params);

	if (teamid == 0 || teamid >= MAX_TEAMS)
		return SendClientMessage(playerid, c_red, "* Invalid team, type '/teams' to see the full list of available teams.");
	
	if (teamid == Player(playerid, Team))
	    return SendClientMessage(playerid, c_red, "* You are currently playing in this team.");

	Var(playerid, DisKit)--;

	new col = Team(teamid, Color), c_name[24];

	switch (teamid)
	{
	    case TERRORIST: c_name = "Assault";
		case MERCENARY: c_name = "";
		default: c_name = "Soldier";
	}

	SetSkin(playerid, Team(teamid, Skin));
	SetPlayerColor(playerid, col);

	Update3DTextLabelText(Player(playerid, RankText), col, sprintf("%s\n%s\n%s",
		Rank(Player(playerid, Rank), Name),
		Team(teamid, Name), c_name));

	SendClientMessage(playerid, -1, sprintf("You have been disguised as {%06x}%s{FFFFFF}, total disguise kit left: %i", (col >>> 8), Team(teamid, Name), Var(playerid, DisKit)));
	Var(playerid, Disguised) = teamid;

	admin_CommandMessage(playerid, "disguise - /dis", teamid);

	return 1;
}

CMD:dis(playerid, params[])
{
	return cmd_disguise(playerid, params);
}

CMD:undis(playerid, params[])
{
	if (Player(playerid, Class) != SPY)
	    return SendClientMessage(playerid, c_red, "* Only spy class is authorized to use this command.");
	
	if (!Var(playerid, Disguised))
	    return SendClientMessage(playerid, c_red, "* You are not disguised.");

	new teamid = Player(playerid, Team);

	SetSkin(playerid, Team(teamid, Skin));
	SetPlayerColor(playerid, Team(teamid, Color));
	UpdateLabel(playerid);

	SendClientMessage(playerid, c_green, "You have been un-disguised.");
	Var(playerid, Disguised) = 0;

	admin_CommandMessage(playerid, "undis");

	return 1;
}

CMD:duel(playerid, params[])
{
	if (GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
	    return SendClientMessage(playerid, c_red, "* You must be on foot to use this command.");
	
	if (Var(playerid, Duty))
	    return SendClientMessage(playerid, c_red, "* You cannot use this command while on duty.");
	
	if (Var(playerid, DM) != 0)
	    return SendClientMessage(playerid, c_red, "* You cannot use this command inside DM arena.");
	
	if (Var(playerid, DuelID) != -1)
	    return SendClientMessage(playerid, c_red, "* You are already dueling.");
	
	if (Player(playerid, Protected) != 0)
	    return SendClientMessage(playerid, c_red, "Please wait...");
	
	if (Var(playerid, DuelInvitePlayer) != INVALID_PLAYER_ID)
	    return SendClientMessage(playerid, c_red, "* You have a duel request, deny before inviting other player.");

	new id, weapon1[24], weapon2[24], bet;

	if (sscanf(params, "us[24]s[24]i", id, weapon1, weapon2, bet))
	    return error:_usage(playerid, "/duel <playerid/name> <weapon 1> <weapon 2> <bet>");

	if (IsValidTargetPlayer(playerid, id))
	{
	    if (IsTargetPlayerSpawned(playerid, id))
	    {
		    if (id == playerid)
		        return SendClientMessage(playerid, c_red, "* You cannot use this command on yourself.");

			switch (GetPlayerState(id))
			{
			    case PLAYER_STATE_WASTED, PLAYER_STATE_SPECTATING:
			        return SendClientMessage(playerid, c_red, "Specified player is not spawned.");

				default:
				{
					if (Var(id, Duty))
						return SendClientMessage(playerid, c_red, "* Specified player is currently on admin duty.");
					
					if (Var(id, DM) != 0 || Var(id, DuelID) != -1)
					    return SendClientMessage(playerid, c_red, "* Specified player is inside DM arena.");
					
					if (Var(id, DuelInvitePlayer) != INVALID_PLAYER_ID)
					    return SendClientMessage(playerid, c_red, "* Specified player has already received a duel invitation.");
					
					if (Var(id, DND))
					    return SendClientMessage(playerid, c_red, "* Specified player is currently on DND mode.");
					
					if (Player(id, Protected) != 0)
					    return SendClientMessage(playerid, c_red, "Please wait...");

					new w1 = weapon_ReturnModelFromName(weapon1);

					if (w1 < 22 || w1 > 34)
					    return SendClientMessage(playerid, c_red, "* Invalid primary weapon.");

					new w2 = weapon_ReturnModelFromName(weapon2);

					if (w2 < 22 || w2 > 34)
					    return SendClientMessage(playerid, c_red, "* Invalid primary weapon.");
					
					if (bet < 1 || bet > 20000)
					    return SendClientMessage(playerid, c_red, "* Invalid bet amount. Use ammount between $1 to $20000.");
					
					new duelid = duel_ReturnFreeSlot();

					if (duelid == -1)
						return SendClientMessage(playerid, c_red, "* Sorry, there are no duel slots left.");
	
					Duel(duelid, Weapon1) = w1;
		            Duel(duelid, Weapon2) = w2;
		            Duel(duelid, Bet) = bet;

		            Var(playerid, DuelID) = duelid;
					Var(playerid, RequestedPlayer) = id;

					Var(id, DuelInvitePlayer) = playerid;

		            SendClientMessage(id, c_purple, sprintf("*** %s wants to duel with you using %s and %s. Duel bet: $%i", playerName(playerid), aWeaponNames[w1], aWeaponNames[w2], bet));
					SendClientMessage(id, c_purple, "*** Press 'Y' to accept or 'N' to reject the duel request.");
					GameTextForPlayer(id, "~y~~h~duel invitation~n~~y~~h~received", 4000, 3);

					GameTextForPlayer(playerid, "~g~~h~duel invitation~n~~g~~h~sent", 4000, 3);
					SendClientMessage(playerid, c_green, sprintf("You have sent a duel request to %s. Weapon 1: %s | Weapon 2: %s | Bet: $%i", playerName(id), aWeaponNames[w1], aWeaponNames[w2], bet));
					SendClientMessage(playerid, c_grey, "* Type '/cduel' if you want to cancel the request.");
				}
			}
		}
	}

	return 1;
}

CMD:cduel(playerid, params[])
{
	new id = Var(playerid, RequestedPlayer);

	if (id == INVALID_PLAYER_ID)
		return SendClientMessage(playerid, c_red, "* You have no duel request sent.");

	new duelid = Var(playerid, DuelID);

	Duel(duelid, Weapon1) = -1;
    Duel(duelid, Weapon2) = -1;
    Duel(duelid, Bet) = 0;

	Var(id, DuelInvitePlayer) = INVALID_PLAYER_ID;
    Var(playerid, RequestedPlayer) = INVALID_PLAYER_ID;

	SendClientMessage(id, c_tomato, sprintf("%s has cancelled the duel request.", playerName(playerid)));
	SendClientMessage(playerid, c_green, sprintf("You have cancelled the duel request sent to %s.", playerName(id)));

	Var(playerid, DuelID) = -1;


	return 1;
}

CMD:ask(playerid, params[])
{
	if (sscanf(params, "s[128]", params))
	{
		error:_usage(playerid, "/ask <question>");
		return SendClientMessage(playerid, c_lightgrey, "Note: Do not abuse this command by asking random senseless questions or you may get warned.");
	}

    if (gettime() < Var(playerid, q_Asked))
        return SendClientMessage(playerid, c_red, "* You must wait 2 minutes before using this command again.");

    new message[128];

	Format:message("- [Q] %s asked: %s", playerName(playerid), params);

    foreach(new i : Player)
    {
        if (Player(i, Level) >= 1)
        {
            SendClientMessage(i, c_yellow, "");
            SendClientMessage(i, c_yellow, message);
            SendClientMessage(i, c_yellow, "");

            GameTextForPlayer(i, ""#TXT_LINE"~y~~h~Incoming question", 3000, 3);
		}
	}

    SendClientMessage(playerid, c_green, "Your question has been sent to online administrators.");
	Var(playerid, q_Asked) = gettime() + 120;

	return 1;
}

CMD:say(playerid, params[])
{
    if (sscanf(params, "s[128]", params))
		return error:_usage(playerid, "/say - /s <message>");

	if (Player(playerid, Muted) >= gettime())
	    return MuteWarn(playerid);
		
	if (CheckIP(playerid, params))
	{
		foreach(new i : Player)
		{
	 		if (RangeBetween(i, playerid) < 8.0)
	 		{
			    SendClientMessage(i, 0xD3E8FEFF, sprintf("[SAY] [%i]%s: %s", playerid, playerName(playerid), params));
			}
		}

		foreach(new i : Player)
		{
		    if (Player(i, Level) >= 1)
		    {
		        if (i != playerid)
		        {
					SendClientMessage(i, c_grey, sprintf("[SAY] [%i]%s: %s", playerid, playerName(playerid), params));
				}
			}
		}

		IRC_Echo(g_IRC_Conn[IRC_ADMIN_CHANNEL], sprintf("14[SAY] [%d]%s: %s", playerid, playerName(playerid), params));
	}

    return 1;
}

CMD:s(playerid, params[])
{
	return cmd_say(playerid, params);
}

CMD:givekit(playerid, params[])
{
    if (Var(playerid, MediKits) == 0)
		return SendClientMessage(playerid, c_red, "* You are out of medikits.");

	new id;

	if (sscanf(params, "u", id))
		return error:_usage(playerid, "/givekit <playerid/name>");

	if (RangeBetween(playerid, id) > 4.0)
	    return SendClientMessage(playerid, c_red, "* You must be near the specified player.");
	
	if (Player(id, Team) != Player(playerid, Team))
	    return SendClientMessage(playerid, c_red, "* You cannot give a medikit to an enemy player.");
	
	if (Var(id, MediKits) == 3)
		return SendClientMessage(playerid, c_red, "* Specified player has already reached the maximum amount of medikits.");

	++Var(id, MediKits);
	--Var(playerid, MediKits);

	SendClientMessage(playerid, c_green, sprintf("You have given a medikit to %s. Total medikits left: %i/3", playerName(id), Var(playerid, MediKits)));
	SendClientMessage(id, c_lightyellow, sprintf("You have received a medikit from %s. Total medikits: %i/3", playerName(playerid), Var(id, MediKits)));
	SendClientMessage(id, c_grey, "* Type '/usekit' to use your medikit.");

	admin_CommandMessage(playerid, "givekit", id);

	return 1;
}

CMD:usekit(playerid, params[])
{
	if (!IsEnemyNear(playerid, 8.0))
	{
	    if (Var(playerid, MediKits) == 0)
			return SendClientMessage(playerid, c_red, "* You are out of medikits.");
		
		new Float:hp, Float:armour;

		GetPlayerHealth(playerid, hp);
		GetPlayerArmour(playerid, armour);

		SetPlayerHealth(playerid, hp + 25.0);
		SetPlayerArmour(playerid, armour + 25.0);

		--Var(playerid, MediKits);

		SendClientMessage(playerid, c_green, sprintf("You have used the medikit for +25HP and +25 armour, total medikits left: %i/3", Var(playerid, MediKits)));

		admin_CommandMessage(playerid, "usekit");
	}

	return 1;
}

CMD:giveap(playerid, params[])
{
    if (Var(playerid, AmmoPack) == 0)
		return SendClientMessage(playerid, c_red, "* You are out of ammo packs.");

	new id;

	if (sscanf(params, "u", id))
		return error:_usage(playerid, "/giveap <playerid/name>");

	if (RangeBetween(playerid, id) > 4.0)
	    return SendClientMessage(playerid, c_red, "* You must be near the specified player.");
	
	if (Player(id, Team) != Player(playerid, Team))
	    return SendClientMessage(playerid, c_red, "* You cannot give an ammo pack to an enemy player.");
	
	if (Var(id, AmmoPack) == 3)
	    return SendClientMessage(playerid, c_red, "* Specified player has already reached the maximum amount of ammo packs");

	Var(id, AmmoPack)++;
	Var(playerid, AmmoPack)--;

	SendClientMessage(playerid, c_green, sprintf("You have given an ammo pack to %s, total ammo packs left: %i/3", playerName(id), Var(playerid, AmmoPack)));
	SendClientMessage(id, c_lightyellow, sprintf("You have received an ammo pack from %s, total ammo packs: %i/3", playerName(playerid), Var(id, AmmoPack)));
	SendClientMessage(id, c_grey, "* Type '/ammopack' or '/ap' to use your ammo pack.");

	admin_CommandMessage(playerid, "giveap", id);

	return 1;
}

CMD:ammopack(playerid, params[])
{
	if (Var(playerid, AmmoPack) == 0)
	    return SendClientMessage(playerid, c_red, "* You are out of ammo pack.");

	GiveAllWeaponAmmo(playerid, 50);
    Var(playerid, AmmoPack)--;

	SendClientMessage(playerid, c_green, sprintf("You received +50 ammo for all weapons from the ammo pack, total ammo packs left: %i/3", Var(playerid, AmmoPack)));

	admin_CommandMessage(playerid, "ammopack - /ap");

	return 1;
}

CMD:ap(playerid, params[])
{
	return cmd_ammopack(playerid, params);
}

CMD:givemoney(playerid, params[])
{
	if (Player(playerid, Rank) < 2)
	    return SendClientMessage(playerid, c_red, "* You need to be rank 2+ to use this command.");
	
		new id, amount;

    if (sscanf(params, "ui", id, amount))
	 	return error:_usage(playerid, "/givemoney - /gm <playerid/name> <amount>");

	if (IsValidTargetPlayer(playerid, id))
	{
		if (id == playerid)
			return SendClientMessage(playerid, c_red, "* You cannot give yourself.");
		
		if (amount <= 0)
			return SendClientMessage(playerid, c_red, "* Amount value cannot be 0.");
		
		if (Player(playerid, Money) < amount)
			return SendClientMessage(playerid, c_red, "* You do not have specified amount of money.");
		
		if (RangeBetween(playerid, id) > 5.0)
			return SendClientMessage(playerid, c_red, "* Specified player is not near you.");

		RewardPlayer(playerid, -amount, 0);
		RewardPlayer(id, amount, 0);

		SendClientMessage(id, c_lightyellow, sprintf("You have received '$%i' from %s.", amount, playerName(playerid)));
		SendClientMessage(playerid, c_green, sprintf("You sent '$%i' to %s.", amount, playerName(id)));

		new str1[144], str2[144];

		Format:str1("[MONEY TRANSFER] %s (IP: %s) has transfered '$%i' to %s (IP: %s)", playerName(playerid), Player(playerid, Ip), amount, playerName(id), Player(id, Ip));
		Format:str2("6[MONEY TRANSFER] %s (IP: %s) has transfered '$%i' to %s (IP: %s)", playerName(playerid), Player(playerid, Ip), amount, playerName(id), Player(id, Ip));

		IRC_Echo(g_IRC_Conn[IRC_ADMIN_CHANNEL], str2);
		admin_SendMessage(3, ac_cmd1, str1);
	}

	return 1;
}

CMD:gm(playerid, params[])
{
	return cmd_givemoney(playerid, params);
}

CMD:admins(playerid, params[])
{
   	admin_CommandMessage(playerid, "admins");
 	SendClientMessage(playerid, 0xA6D398FF, (Player(playerid, Level) > 0) ? ("Online admins:") : ("Admins on duty:"));

	new count = 0;

	foreach(new i : Player)
	{
		if (Player(i, Level) >= 1)
		{
		    if (Player(playerid, Level) > 0)
		    {
			    SendClientMessage(playerid, 0xA6D398FF, sprintf("  %s[%i] - Level %i", playerName(i),i, Player(i, Level)));
				count++;
			}
			else
			{
				if (Var(i, Duty))
				{
					SendClientMessage(playerid, 0xA6D398FF, sprintf("  %s[%i] - Level %i", playerName(i),i, Player(i, Level)));
					count++;
				}
				else
				{
				    break;
				}
			}
		}
	}

	if (!count)
	{
		SendClientMessage(playerid, c_red, "- None -");
	}

	return 1;

}

CMD:times(playerid, params[])
{
	new nuke_time, sam_time, radio_hack_time, radio_damage_time;

	nuke_time = ConvertTime(Nuke(Time), MINUTES);
	sam_time = ConvertTime(Server(SAMTime), MINUTES);
	radio_hack_time = ConvertTime(Server(RadioHackTime), MINUTES);
	radio_damage_time = ConvertTime(Server(RadioFixTime), MINUTES);

	SendClientMessage(playerid, c_blue, "Time until following super weapons are ready for launch:");
	SendClientMessage(playerid, c_blue, (!Nuke(Time)) ? ("   Nuclear is ready for launch.") : (sprintf("   Nuclear will be ready in %i minutes.", nuke_time)));
    SendClientMessage(playerid, c_blue, (!Server(SAMTime)) ? ("   SAM missiles are ready for launch.") : (sprintf("   SAM missiles will be ready in %i minutes.", sam_time)));
    SendClientMessage(playerid, c_blue, (!Server(RadioHackTime)) ? ("   Radio hack is ready for use.") : (sprintf("   Radio hack will be ready in %i minutes.", radio_hack_time)));
    SendClientMessage(playerid, c_blue, (!Server(RadioFixTime)) ? ("   Radio damage feature is ready for use.") : (sprintf("   Damaged radio will be fixed in %i minutes.", radio_damage_time)));

	admin_CommandMessage(playerid, "times");

    return 1;
}

CMD:report(playerid, params[])
{
	new id;

  	if (sscanf(params, "us[36]", id, params))
	  	return error:_usage(playerid, "/report <playerid/name> <reason>");
	
	if (strlen(params) > 30)
		return SendClientMessage(playerid, c_red, "* Reason length exceeds maximum characters limit. Limit: 30 chars.");
	
	if (IsValidTargetPlayer(playerid, id))
	{
	    if (gettime() < Var(playerid, ReportedTime))
	        return SendClientMessage(playerid, c_red, "* You must wait 2 minutes before reporting a player again.");
		
		if (id == playerid)
		    return SendClientMessage(playerid, c_red, "* You cannot use this command on yourself.");
		
		if (Var(playerid, JustReported) == id)
		    return SendClientMessage(playerid, c_red, "* You cannot report same person twice.");

		admin_SendReport(id, playerid, params);

		Var(playerid, ReportedTime) = gettime() + 120;
		Var(playerid, JustReported) = id;

	    SendClientMessage(playerid, -1, sprintf("   You have reported player %s, reason: %s", playerName(id), params));
	    SendClientMessage(playerid, -1, "   Please be patient until an admin checks your report.");
	}

    return 1;
}

CMD:radio(playerid, params[])
{
	if (Player(playerid, Team) == MERCENARY)
		return SendClientMessage(playerid, c_red, "* Your team cannot use this command.");

    if (Team(Player(playerid, Team), RadioBroken) == true)
		return SendClientMessage(playerid, c_red, "* Your team's radio is currently broken.");
	
	if (sscanf(params, "s[128]", params))
 		return error:_usage(playerid, "/r <text>");

 	if (Player(playerid, Muted) >= gettime())
	    return MuteWarn(playerid);

    if (CheckIP(playerid, params))
	{
	    new teamid;
	    
	    teamid = Player(playerid, Team);
	    
		team_SendMessage(teamid, 0xB3D0CCFF, sprintf("[RADIO] [%d]%s: %s", playerid, playerName(playerid), params));
        admin_SendMessage(2, c_grey, sprintf("[RADIO] [%d]%s: %s", playerid, playerName(playerid), params), playerid);
		
		if (Team(teamid, RadioHackingTeam) != 0)
		{
		    new team_2;
		    
		    team_2 = Team(teamid, RadioHackingTeam);
		    team_SendMessage(team_2, 0xB3D0CCFF, sprintf("* [R.HACK] [%d]%s: %s", playerid, playerName(playerid), params));
		}

		IRC_Echo(g_IRC_Conn[IRC_ADMIN_CHANNEL], sprintf("14[RADIO] [%d]%s: %s", playerid, playerName(playerid), params));
	}

	return 1;
}

CMD:r(playerid, params[])
{
	return cmd_radio(playerid, params);
}

CMD:teams(playerid, params[])
{
	foreach(new i : Teams)
	{
		SendClientMessage(playerid, -1, sprintf("Team: {%06x}%s {%06x}- Players: %d", (Team(i, Color) >>> 8), Team(i, Name), (-1 >>> 8), Team(i, Players)));
	}

	admin_CommandMessage(playerid, "teams");
	return 1;
}

CMD:ranks(playerid, params[])
{
	new text[800];

	for(new i = 0; i < MAX_RANKS; i++)
	{
	    Format:text("%s"#sc_white"Rank %i (%s), requires %i score\n", text, i, Rank(i, Name), Rank(i, Score));
	}

	ShowPlayerDialog(playerid, D_MSG, DIALOG_STYLE_MSGBOX, "Ranks", text, "Close", "");
	admin_CommandMessage(playerid, "ranks");
	return 1;
}

CMD:rank(playerid, params[])
{
    new id = (sscanf(params, "u", id)) ? playerid : strval(params);

	if (IsValidTargetPlayer(playerid, id))
	{
		if (id == playerid)
		{
			SendClientMessage(playerid, c_green, sprintf("Your current rank is %i (%s), score: %i", Player(playerid, Rank), Rank(Player(playerid, Rank), Name), Player(playerid, Score)));
			SendClientMessage(playerid, c_grey, "* You can also use '/rank <playerid/name>' to see other player's rank.");
			admin_CommandMessage(playerid, "rank");
		}
		else
		{
			SendClientMessage(playerid, c_green, sprintf("%s's rank is %i (%s), score: %i", playerName(id), Player(id, Rank), Rank(Player(id, Rank), Name), Player(id, Score)));
			admin_CommandMessage(playerid, "rank", id);
		}
	}

	return 1;
}

CMD:kill(playerid, params[])
{
    if (Var(playerid, DuelID) != -1)
        return SendClientMessage(playerid, c_red, "* You cannot use this command inside duel arena.");
	
	if (Player(playerid, Protected) != 0)
		return SendClientMessage(playerid, c_red, "Please wait...");
	
	if (Var(playerid, Duty))
		return SendClientMessage(playerid, c_red, "* You cannot use this command while on admin duty.");
	
	if (GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
		return SendClientMessage(playerid, c_red, "* You must be on foot to use this command.");

	if (!IsEnemyNear(playerid, 30.0))
	{
		admin_CommandMessage(playerid, "kill");
		SetPlayerHealth(playerid, 0.0);
	}

	return 1;
}

CMD:savestats(playerid, params[])
{
	if (Var(playerid, StatsSaved) > gettime())
	    return SendClientMessage(playerid, c_red, "* You can only use this command once every 5 minutes.");
	
    SaveStats(playerid);

	SendClientMessage(playerid, -1, "   Your stats have been saved.");
    Var(playerid, StatsSaved) = gettime() + 300;

    admin_CommandMessage(playerid, "savestats");

    return 1;
}

CMD:stats(playerid,params[])
{
	new id = (sscanf(params, "u", id)) ? playerid : strval(params);

	if (IsValidTargetPlayer(playerid, id))
	{
		if (id == playerid)
		{
			ShowPlayerStats(playerid, playerid);
			admin_CommandMessage(playerid, "stats");

			SendClientMessage(playerid, c_grey, "* You can also use '/stats <playerid/name>' to view other player's statistics.");
		}
		else
		{
		    if (IsTargetPlayerSpawned(playerid, id))
			{
				ShowPlayerStats(id, playerid);
				admin_CommandMessage(playerid, "stats", id);
			}
		}
	}

	return 1;
}

CMD:wepstats(playerid,params[])
{
	new id = (sscanf(params, "u", id)) ? playerid : strval(params);

	if (IsValidTargetPlayer(playerid, id))
	{
		if (id == playerid)
		{
			ShowWeaponStats(playerid, playerid);
			admin_CommandMessage(playerid, "wepstats");

			SendClientMessage(playerid, c_grey, "* You can also use '/wepstats <playerid/name>' to view other player's weapon statistics.");
		}
		else
		{
		    if (IsTargetPlayerSpawned(playerid, id)) {
				ShowWeaponStats(id, playerid);
				admin_CommandMessage(playerid, "wepstats", id);
			}
		}
	}

	return 1;
}

CMD:topstats(playerid, params[])
{
	admin_CommandMessage(playerid, "topstats");
	SendClientMessage(playerid, -1, "Players with top stats:");

	new
		id1 = -1, 			top_score = -500000,
		id2 = -1, 			top_money = -500000,
		id3 = -1, 			top_kills = -500000,
		id4 = -1, 			top_deaths = -500000,
		id5 = -1, 	Float:	top_ratio = -500000.00,
		id6 = -1, 			top_spree = -500000,
		id7 = -1, 			top_zspree = -500000,
					Float:	ratio;

	foreach(new i : Player)
	{
	    if (!Var(i, Spawned))
			continue;

		if (top_score < Player(i, Score))
		{
		    top_score = Player(i, Score);
			id1 = i;
		}
		if (top_money < Player(i, Money))
		{
		    top_money = Player(i, Money);
		    id2 = i;
		}
		if (top_kills < Player(i, Kills))
		{
		    top_kills = Player(i, Kills);
		    id3 = i;
		}
		if (top_deaths < Player(i, Deaths))
		{
		    top_deaths = Player(i, Deaths);
		    id4 = i;
		}
		ratio = return_Ratio(i);
		if (top_ratio < ratio)
		{
		    top_ratio = ratio;
		    id5 = i;
		}
		if (top_spree < Player(i, KillStreak))
		{
		    top_spree = Player(i, KillStreak);
		    id6 = i;
		}
		if (top_zspree < Player(i, ZoneStreak))
		{
		    top_zspree = Player(i, ZoneStreak);
		    id7 = i;
		}
	}

	SendClientMessage(playerid, -1, sprintf("   TOP SCORE: %s - %i", playerName(id1), top_score));
	SendClientMessage(playerid, -1, sprintf("   TOP MONEY: %s - $%i", playerName(id2), top_money));
	SendClientMessage(playerid, -1, sprintf("   TOP KILLS: %s - %i", playerName(id3), top_kills));
	SendClientMessage(playerid, -1, sprintf("   TOP DEATHS: %s - %i", playerName(id4), top_deaths));
	SendClientMessage(playerid, -1, sprintf("   TOP RATIO: %s - %.2f", playerName(id5), top_ratio));
	SendClientMessage(playerid, -1, sprintf("   TOP KILL SPREE: %s - %i", playerName(id6), top_spree));
	SendClientMessage(playerid, -1, sprintf("   TOP ZONE SPREE: %s - %i", playerName(id7), top_zspree));
	
	return 1;
}

CMD:sp(playerid, params[])
{
    switch (Player(playerid, Team))
	{
        case MERCENARY, TERRORIST:
		{
			SendClientMessage(playerid, c_red, "* Your team cannot use this command.");
		}
		default:
		{
			ShowDialog(playerid, D_SPAWNPOINT);
			admin_CommandMessage(playerid, "sp");
		}
	}

	return 1;
}

CMD:reclass(playerid, params[])
{
	if (Var(playerid, DM) != 0 || Var(playerid, DuelID) != -1)
	    return SendClientMessage(playerid, c_red, "* You cannot use this command inside DM arena.");
	
	if (Player(playerid, Team) == MERCENARY)
	    return SendClientMessage(playerid, c_red, "* Your team cannot use this command.");
	
	if (GetPlayerState(playerid) == PLAYER_STATE_SPECTATING && g_SpecID[playerid] != INVALID_PLAYER_ID)
	    return SendClientMessage(playerid, c_red, "* You cannot use this command while spectating.");

	SendClientMessage(playerid, 0xA9C4E4FF, "Returning to class selection after next death...");
    Var(playerid, PlayerStatus) = PLAYER_STATUS_SWITCHING_CLASS;

	admin_CommandMessage(playerid, "reclass - /rc");

	return 1;
}

CMD:squads(playerid, params[])
{
	squad_ShowList(playerid);
	admin_CommandMessage(playerid, "squads");

	return 1;
}

CMD:screate(playerid, params[])
{
    if (Player(playerid, Team) == MERCENARY)
	    return SendClientMessage(playerid, c_red, "* Your team cannot use this command.");
	
	if (Var(playerid, SquadID) != -1)
	    return SendClientMessage(playerid, c_red, "* You are already in a squad.");

	if (sscanf(params, "s[34]", params))
	    return error:_usage(playerid, "/screate <squad name>");
	
	if (strlen(params) > 15)
	    return SendClientMessage(playerid, c_red, "* Squad name exceeds the maximum characters limit. Limit: 15 chars.");
	
	if (squad_IsNameTaken(params))
	    return SendClientMessage(playerid, c_red, "* Squad with this name already exists.");

	squad_Create(playerid, params);
    admin_CommandMessage(playerid, "screate");

	return 1;
}

CMD:sinfo(playerid, params[])
{
	new squadid = (sscanf(params, "i", squadid)) ? Var(playerid, SquadID) : strval(params);

	if (squadid == Var(playerid, SquadID))
	{
	    if (squadid == -1)
	        return SendClientMessage(playerid, c_red, "* You are not in any squad.");

		SendClientMessage(playerid, c_grey, "* You can also use /sinfo <squadid> to see the information of other squads.");
		squad_ShowInfo(playerid, Var(playerid, SquadID));
		admin_CommandMessage(playerid, "sinfo", Var(playerid, SquadID));
	}
	else
	{
	    if (!squad_IsValid(squadid))
	        return SendClientMessage(playerid, c_red, "* Squad with this ID does not exist.");

	    squad_ShowInfo(playerid, squadid);
	    admin_CommandMessage(playerid, "sinfo", squadid);
	}

	return 1;
}

CMD:invite(playerid, params[])
{
    if (Var(playerid, SquadID) == -1)
        return SendClientMessage(playerid, c_red, "* You need to be a leader of a squad to use this command");

	new squadid = Var(playerid, SquadID);

	if (g_Squads[squadid][sq_Members][0] != playerid)
		return SendClientMessage(playerid, c_red, "* You need to ba leader of a squad to use this command");

	new id;

	if (sscanf(params, "u", id))
	    return error:_usage(playerid, "/invite <playerid/name>");

	if (IsValidTargetPlayer(playerid, id))
	{
	    if (Player(id, Team) != Player(playerid, Team))
	        return SendClientMessage(playerid, c_red, "* You cannot invite enemy players.");
		
		if (squad_CountMembers(squadid) == MAX_SQUAD_MEMBERS)
	        return SendClientMessage(playerid, c_red, "* This squad has reached the maximum amount of members.");
		
		if (Var(id, SquadID) != -1)
		    return SendClientMessage(playerid, c_red, "* Specified player is already in a squad.");
		
		if (Var(id, DND))
			return SendClientMessage(playerid, c_red, "* Specified player is currently on DND mode.");

		GameTextForPlayer(id, "~n~~n~~n~~w~squad invitation~n~~w~received", 4000, 3);
		SendClientMessage(playerid, c_green, sprintf("You have sent a squad invitation to %s.", playerName(id)));
		SendClientMessage(id, c_purple, sprintf("* You have received a squad invitation from %s, press 'Y' to accept and 'N' to reject the invitation.", playerName(playerid)));

		Var(id, InvitedSquadID) = squadid;
		admin_CommandMessage(playerid, "invite", id);
	}

	return 1;
}

CMD:qsquad(playerid, params[])
{
	if (Var(playerid, SquadID) == -1)
	    return SendClientMessage(playerid, c_red, "* You are not in any squad.");

	SendClientMessage(playerid, -1, "You left the squad.");

	squad_RemovePlayer(playerid);
	admin_CommandMessage(playerid, "qsquad");

	return 1;
}

CMD:skick(playerid, params[])
{
	if (Var(playerid, SquadID) == -1)
 		return SendClientMessage(playerid, c_red, "* You need to be a leader of a squad to use this command");

	new squadid = Var(playerid, SquadID);

	if (g_Squads[squadid][sq_Members][0] != playerid)
		return SendClientMessage(playerid, c_red, "* You need to ba leader of a squad to use this command");

	new id;

	if (sscanf(params, "u", id))
	    return error:_usage(playerid, "/skick <playerid/name>");

	if (IsValidTargetPlayer(playerid, id))
	{
	    if (Var(id, SquadID) != squadid)
	        return SendClientMessage(playerid, c_red, "* Specified player is not a member of this squad.");

		squad_RemovePlayer(id);
		squad_SendMessage(squadid, c_tomato, sprintf("[SQUAD] Leader %s has kicked %s.", playerName(playerid), playerName(id)));

		SendClientMessage(id, c_red, sprintf("You have been kicked out of this squad by leader %s.", playerName(playerid)));
        admin_CommandMessage(playerid, "skick", id);
	}

	return 1;
}

CMD:sname(playerid, params[])
{
	if (Var(playerid, SquadID) == -1)
	    return SendClientMessage(playerid, c_red, "* You need to be a leader of a squad to use this command");

	new squadid = Var(playerid, SquadID);

	if (g_Squads[squadid][sq_Members][0] != playerid)
		return SendClientMessage(playerid, c_red, "* You need to be a leader of a squad to use this command");
	
	if (sscanf(params, "s[15]", params))
	    return error:_usage(playerid, "/sname <new name>");
	
	if (strlen(params) > 15)
	    return SendClientMessage(playerid, c_red, "* Squad name exceeds the maximum characters limit. Limit: 15 chars.");
	
	if (squad_IsNameTaken(params))
	    return SendClientMessage(playerid, c_red, "* Squad with this name already exists");

	squad_SendMessage(squadid, c_lime, sprintf("Squad leader %s has changed the squad name from '%s' to '%s'.", playerName(playerid), g_Squads[squadid][sq_Name], params));
    format(g_Squads[squadid][sq_Name], 15, params);

	SendClientMessage(playerid, c_green, sprintf("You have changed this squad name to %s.", params));

	foreach(new i : SquadMembers[squadid])
	{
	    UpdateLabel(g_Squads[squadid][sq_Members][i]);
	}

    admin_CommandMessage(playerid, "sname");

	return 1;
}

CMD:sdrop(playerid, params[])
{
	if (Var(playerid, SquadID) == -1)
	    return SendClientMessage(playerid, c_red, "* You need to be a leader of a squad to use this command.");
	
	new squadid = Var(playerid, SquadID);

	if (g_Squads[squadid][sq_Members][0] != playerid)
		return SendClientMessage(playerid, c_red, "* You need to be a leader of a squad to use this command.");
	
	squad_Drop(squadid);
	admin_CommandMessage(playerid, "sdrop");

	return 1;
}

CMD:rc(playerid, params[])
{
	return cmd_reclass(playerid, params);
}

CMD:spree(playerid, params[])
{
	new id = (sscanf(params, "u", id)) : playerid : strval(params);

	if (IsValidTargetPlayer(playerid, id))
	{
		if (id == playerid)
		{
			SendClientMessage(playerid, c_green, sprintf("Your spree: Kills: %i (Session: %i) | Zones: %i (Session: %i)", Player(playerid, KillStreak), Player(playerid, SessionKills), Player(playerid, ZoneStreak), Player(playerid, SessionCaps)));
			admin_CommandMessage(playerid, "spree");
			SendClientMessage(playerid, c_grey, "* You can also use /spree <playerid/name> to see other player's spree.");
		}
		else
		{
            SendClientMessage(playerid, c_green, sprintf("%s's spree: Kills: %i (Session: %i) | Zones: %i (Session: %i)", playerName(id), Player(id, KillStreak), Player(id, SessionKills), Player(id, ZoneStreak), Player(id, SessionCaps)));
			admin_CommandMessage(playerid, "spree", id);
		}
	}

	return 1;
}

CMD:switchteam(playerid, params[])
{
    if (Var(playerid, Duty))
	    return SendClientMessage(playerid, c_red, "* You cannot use this command while on duty.");
	
	if (Var(playerid, DM) != 0 || Var(playerid, DuelID) != -1)
	    return SendClientMessage(playerid, c_red, "* You cannot use this command inside DM arena.");
	
	if (GetPlayerState(playerid) == PLAYER_STATE_SPECTATING && g_SpecID[playerid] != INVALID_PLAYER_ID)
	    return SendClientMessage(playerid, c_red, "* You cannot use this command while spectating.");

	SendClientMessage(playerid, 0xA9C4E4FF, "Returning to team selection after next death...");
    Var(playerid, PlayerStatus) = PLAYER_STATUS_SWITCHING_TEAM;

	admin_CommandMessage(playerid, "switchteam - /st");

	return 1;
}

CMD:st(playerid, params[])
{
	return cmd_switchteam(playerid, params);
}

CMD:settings(playerid, params[])
{
    ShowDialog(playerid, D_SETTINGS);
	admin_CommandMessage(playerid, "settings - /set");

	return 1;
}

CMD:set(playerid, params[])
{
	return cmd_settings(playerid, params);
}

CMD:suicide(playerid, params[])
{
	if (Player(playerid, Class) != SUICIDE_BOMBER)
	    return SendClientMessage(playerid, c_red, "* Your class cannot use this command.");
	
	if (Var(playerid, DM) != 0 || Var(playerid, DuelID) != -1)
        return SendClientMessage(playerid, c_red, "* You cannot use this command inside DM arena.");
	
	if (Player(playerid, Protected) != 0)
		return SendClientMessage(playerid, c_red, "Please wait...");
	
	if (Player(playerid, Team) != TERRORIST)
	    return SendClientMessage(playerid, c_red, "* Your team cannot use this command.");
	
	if (!Var(playerid, HasBombs))
		return SendClientMessage(playerid, c_red, "* You do not have bombs.");

	SuicideBomb(playerid);
	Var(playerid, HasBombs) = false;

	admin_CommandMessage(playerid, "suicide");

	return 1;
}

CMD:qdm(playerid, params[])
{
	if (Var(playerid, DM) == 0)
		return SendClientMessage(playerid, c_red, "* You are not inside the DM arena.");
	
	if (GetPlayerState(playerid) == PLAYER_STATE_WASTED)
		return SendClientMessage(playerid, c_red, "Please wait...");
	
	new teamid, dmid;

	teamid = Player(playerid, Team);
	dmid = Var(playerid, DM);

	Var(playerid, DM) = 0;

	Team(teamid, Players)++;
	SetPlayerTeam(playerid, teamid);

	SendClientMessage(playerid, c_red, "You left the DM arena.");
	News(sprintf("~w~~h~%s ~r~~h~~h~~h~has left the %s stadium", playerName(playerid), DM(dmid, Name)));
	IRC_Echo(g_IRC_Conn[IRC_MAIN_CHANNEL], sprintf("14* %s has left the %s stadium.", playerName(playerid), DM(dmid, Name)));

	ProtectedSpawn(playerid);

	admin_CommandMessage(playerid, "qdm");

	return 1;
}

CMD:givegun(playerid, params[] )
{
    if (GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
	    return SendClientMessage(playerid, c_red, "* You must be on foot to use this command.");

	new id, ammo;

	if (sscanf(params, "ui", id, ammo))
	    return error:_usage(playerid, "/givegun <playerid/name> <ammo>");

	if (IsValidTargetPlayer(playerid, id))
	{
	    if (RangeBetween(playerid, id) > 4.0)
	        return SendClientMessage(playerid, c_red, "* The player specified is not close to you.");
		
		if (Player(playerid, Team) != Player(id, Team))
		    return SendClientMessage(playerid, c_red, "* You cannot give your weapons to an enemy player.");

		new current_weapon = GetPlayerWeapon(playerid);

		if (!current_weapon)
		    return SendClientMessage(playerid, c_red, "* You are not holding any weapons.");
		
		if (ammo > GetPlayerAmmo(playerid))
		    return SendClientMessage(playerid, c_red, "* You do not have that much ammo.");

		GivePlayerWeapon(playerid, current_weapon, -ammo);
		GivePlayerWeapon(id, current_weapon, ammo);

		SendClientMessage(playerid, c_green, sprintf("You have given a weapon %s[%i] with %i rounds of ammo to player %s.", aWeaponNames[current_weapon], current_weapon, ammo, playerName(id)));
		SendClientMessage(id, c_lightyellow, sprintf("You have received a weapon %s[%i] with %i rounds of ammo from player %s.", aWeaponNames[current_weapon], current_weapon, ammo, playerName(playerid)));
		admin_CommandMessage(playerid, "givegun", id, ammo);
	}

	return 1;
}

CMD:plant(playerid, params[])
{
	if (Player(playerid, Team) != TERRORIST)
	    return SendClientMessage(playerid, c_red, "* Your team cannot use this command.");
	
	if (Player(playerid, Class) != DEMOLISHER)
	    return SendClientMessage(playerid, c_red, "* You must be a DEMOLISHER class to use this command.");
	
	if (GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
	    return SendClientMessage(playerid, c_red, "* You must on foot to use this command.");

	new id = bridge_ReturnClosestID(playerid);

	if (id == -1)
	    return SendClientMessage(playerid, c_red, "* You must be near the bridge's pickup in order to plant bombs.");

    new bool:already_planting = false;

	foreach(new i : Player)
	{
	    if (Var(i, BridgeID) == id && Var(i, BridgeTimer) != 0)
	    {
	        already_planting = true;
	        break;
		}
	}

	if (already_planting == true)
	    return SendClientMessage(playerid, c_red, "* Someone has already started planting the bombs at this bridge.");
	
	if (Bridge(id, Status) == BRIDGE_STATUS_COLLAPSED)
	    return SendClientMessage(playerid, c_red, "* This bridge is already collapsed.");
	
	if (!Var(playerid, HasBombs))
	    return SendClientMessage(playerid, c_red, "* You have no bombs to plant.");
	
	if (Bridge(id, Planted) == true)
        return SendClientMessage(playerid, c_red, "* The bombs have already been planted.");

    if (!Var(playerid, BridgeTimer))
    {
		Var(playerid, BridgeTimer) = gettime() + 5;
		Var(playerid, BridgeID) = id;

		GameTextForPlayer(playerid, "~n~~n~~w~planting~n~~w~please wait...", 7000, 3);
		ApplyAnimation(playerid, "BOMBER", "BOM_Plant_Loop", 1.1, 1, 0, 0, 0, 0);

		SendClientMessage(playerid, c_green, sprintf("You have started planting bombs at the %s.", Bridge(id, Name)));
        admin_CommandMessage(playerid, "plant");
	}

	return 1;
}

CMD:rbridge(playerid, params[])
{
	switch (Player(playerid, Team))
	{
		case TERRORIST, MERCENARY:
		{
			SendClientMessage(playerid, c_red, "* Your team cannot use this command.");
		}
		default:
		{
			if (GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
		    	return SendClientMessage(playerid, c_red, "* You must be on foot to use this command.");
	
		    new player_zone = zone_ReturnIDByArea(playerid);

		    if (player_zone == -1)
				return SendClientMessage(playerid, c_red, "* You need to be in the bridge zone in order to repair it.");

		    if (Zone(player_zone, Team) != Player(playerid, Team))
				return SendClientMessage(playerid, c_red, "* Your team must capture this bridge in order to repair.");

	        new bridgeid = bridge_ReturnIDByZone(player_zone), bool:already_repairing = false;

			switch (Bridge(bridgeid, Status))
			{
				case BRIDGE_STATUS_FIXED:
				{
	            	return SendClientMessage(playerid, c_red, "This bridge is not collapsed.");
				}
				case BRIDGE_STATUS_COLLAPSED:
				{
				    foreach(new i : Player)
					{
				        if (Var(i, BridgeID) == bridgeid && Var(i, BridgeTimer) != 0)
						{
							already_repairing = true;
						}
				    }
				}
			}

			if (already_repairing == true)
			    return SendClientMessage(playerid, c_red, "* Someone has already started repairing this bridge.");

			if (Var(playerid, BridgeTimer) == 0)
			{
			    new time = (Player(playerid, Class) == ENGINEER) ? 10 : 30;
			    
				Var(playerid, BridgeTimer) = gettime() + time;
				Var(playerid, BridgeID) = bridgeid;
				
				GameTextForPlayer(playerid, "~n~~n~~w~repairing~n~~w~please wait...", 99999, 3);
				ApplyAnimation(playerid, "BOMBER", "BOM_Plant_Loop", 1.1, 1, 0, 0, 0, 0);

				SendClientMessage(playerid, c_green, sprintf("You have started repairing the %s.", Bridge(bridgeid, Name)));

				Exceptional(playerid, c_orange, sprintf("*** %s from team %s is attempting to repair the %s.", playerName(playerid), Team(Player(playerid, Team), Name), Bridge(bridgeid, Name)));
                IRC_Echo(g_IRC_Conn[IRC_MAIN_CHANNEL], sprintf("10* %s from team %s is attempting to repair the %s.",  playerName(playerid), Team(Player(playerid, Team), Name), Bridge(bridgeid, Name)));

                admin_CommandMessage(playerid, "rbridge");
			}
		}
	}

	return 1;
}

CMD:bridges(playerid, params[])
{
	new text[200];

	foreach(new i : Bridges)
	{
	    Format:text("%s%s%s\n", text, (Bridge(i, Status) == BRIDGE_STATUS_FIXED) ? ("{63E26C}") : ("{B03C3F}"), Bridge(i, Name));
	}

	ShowPlayerDialog(playerid, D_MSG, DIALOG_STYLE_LIST, "Bridges", text, "Close", "");
    admin_CommandMessage(playerid, "bridges");

	return 1;
}

CMD:supply(playerid, params[])
{
	if (Player(playerid, Class) != SUPPORTER)
	    return SendClientMessage(playerid, c_red, "* Only supporter class is authorized to use this command.");
	
	if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
	    return SendClientMessage(playerid, c_red, "* You need to be inside a vehicle (Cargobob or Barracks) to use this command.");

	new vehicleid = GetPlayerVehicleID(playerid);

	if (Vehicle(vehicleid, SupplyingPlayer) != playerid)
	    return SendClientMessage(playerid, c_red, "* Someone else has already loaded this vehicle, you cannot supply with it.");

	switch (GetVehicleModel(vehicleid))
	{
		case CARGOBOB, BARRACKS:
		{
		    if (!Vehicle(vehicleid, Loaded))
		        return SendClientMessage(playerid, c_red, "* This vehicle is empty.");

			supporter_SupplyTeam(playerid);
			admin_CommandMessage(playerid, "supply");
		}

		default:
		{
		    SendClientMessage(playerid, c_red, "* You need to be inside a vehicle (Cargobob or Barracks) to use this command.");
		}
	}

	return 1;
}

CMD:richlist(playerid, params[])
{
    admin_CommandMessage(playerid, "richlist");

	new id[10], money[10], player_money;

	for(new i = 0; i < 10; i++)
	{
	    id[i] = -1;
	    money[i] = -500000;
	}

	SendClientMessage(playerid, -1, "Top richest players online:");

	foreach(new i : Player)
	{
	    if (!Var(i, Spawned))
			continue;

	    player_money = GetPlayerMoney(i);

	    for (new j = 0; j < 10; ++j)
		{
	        if (player_money > money[j])
			{
	            if (j != 9)
				{
	            	for(new k = 8; k >= j; k--)
					{
	            	    money[k+1] = money[k];
	            	    id[k+1] = id[k];
	            	}
	            }

	            money[j] = player_money;
	            id[j] = i;
				break;
	        }
	    }
	}

	for (new i = 0; i < 10; i++)
	{
	    if (id[i] < 0)
			break;

		SendClientMessage(playerid, -1, sprintf("   %d. %s[%d] - $%d", i + 1, playerName(id[i]), id[i], money[i]));
	}

	return 1;
}

CMD:load(playerid, params[])
{
    if (Player(playerid, Class) != SUPPORTER)
	    return SendClientMessage(playerid, c_red, "* Only supporter class is authorized to use this command.");
	
	if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
	    return SendClientMessage(playerid, c_red, "* You need to be inside a vehicle (Cargobob or Barracks) to use this command.");

	new zoneid = zone_ReturnIDByArea(playerid);

	if (zoneid == -1 || zoneid != 17)
 		return SendClientMessage(playerid, c_red, "* You need to be in the Ammunation zone to load.");

	new vehicleid = GetPlayerVehicleID(playerid);

	if (Vehicle(vehicleid, Loaded) && Vehicle(vehicleid, SupplyingPlayer) != playerid)
	    return SendClientMessage(playerid, c_red, "* Someone else has already loaded this vehicle, you cannot supply with it.");

	switch (GetVehicleModel(vehicleid))
	{
		case CARGOBOB, BARRACKS:
		{
		    if (!Var(playerid, SupplyTime))
			{
			    if (Vehicle(vehicleid, Loaded))
			        return SendClientMessage(playerid, c_red, "* This vehicle is already loaded.");

	 			TogglePlayerControllable(playerid, 0);
	 			GameTextForPlayer(playerid, ""#TXT_LINE"~w~loading...", 20000, 3);
	 			Var(playerid, SupplyTime) = gettime() + 7;
	 			admin_CommandMessage(playerid, "load");
			}
		}
		default:
		{
		    SendClientMessage(playerid, c_red, "* You need to be inside a vehicle (Cargobob or Barracks) to use this command.");
		}
	}

	return 1;
}

/******************************************************************************/
/*								IRC COMMANDS								  */
/******************************************************************************/
// Level 1 (Voice)

IRCCMD:acmds(botid, channel[], user[], host[], params[])
{
	if (!IRC_IsVoice(botid, channel, user))
        return IRC_Echo(channel, ""#IRC_PREFIX_ERROR"Access denied.");

		new level;

	if (sscanf(params, "i", level))
	    return IRC_Echo(channel, "0,14 USAGE  !acmds <level 1-5>");

    if (!level || level > 5)
       return IRC_Echo(channel, ""#IRC_PREFIX_ERROR"Invalid level.");

    switch (level)
	{
        case 1: IRC_Notice(botid, user, "<+> Level 1 voicecommands: !asay, !check, !muted, !miniguns, !reports, !kick, !warn, !cc, !mute, !unmute, !weaps, !rsvall, !site");
        case 2,3:
		{
			IRC_Notice(botid, user, "<%> Level 2 half-op commands: !astats, !apm, !bancheck, !ip, !fps, !pl, !ban, !tban, !unban");
			IRC_Notice(botid, user, "<%> Level 3 half-op commands: !aka, !cleancars, !fixall");
		}
		case 4: IRC_Notice(botid, user, "<@> Level 4 OP commands: !settime, !setweather, !rban, !changename, !dischat, !enchat, !ann, !setping, !givescore, !givecash");
		case 5: IRC_Notice(botid, user, "<&> Level 5 admin commands: !weaponall, !moneyall, !scoreall, !helmetall, !maskall, !getlevel, !getvip, !getcredits, !setadmin");
	}

	return 1;
}

IRCCMD:asay(botid, channel[], user[], host[], params[])
{
    if (!IRC_IsVoice(botid, channel, user))
        return IRC_Echo(channel, ""#IRC_PREFIX_ERROR"Access denied.");

	if (sscanf(params, "s[128]", params))
		return IRC_Echo(channel, "0,14 USAGE  !asay <message>");

	SendClientMessageToAll(-1, sprintf("[IRC] {BD9BC8}Admin %s said: "#sc_white"%s", user, params));
	IRC_Echo(channel, sprintf("[IRC] 6Admin %s said: %s", user, params));

	return 1;
}

IRCCMD:check(botid, channel[], user[], host[], params[])
{
	if (!IRC_IsVoice(botid, channel, user))
        return IRC_Echo(channel, ""#IRC_PREFIX_ERROR"Access denied.");

	new id;

	if (sscanf(params, "u", id))
	    return IRC_Echo(channel, "0,14 USAGE  !check <playerid/name>");

	if (IsValidTargetPlayer(-1, id, true, channel))
	{
	    new Float:hp, Float:armour, int, world, skin, p_state, state_name[20];

	    GetPlayerHealth(id, hp);
	    GetPlayerArmour(id, armour);

		int = GetPlayerInterior(id);
		world = GetPlayerVirtualWorld(id);
		p_state = GetPlayerState(id);
		skin = GetPlayerSkin(id);

		switch (p_state)
		{
		    case 1: state_name = "ON FOOT";
		    case 2: state_name = "DRIVER";
		    case 3: state_name = "PASSENGER";
		    case 9: state_name = "SPECTATING";
		}

		IRC_Echo(channel, sprintf("6Check on %s:", playerName(id)));
		IRC_Echo(channel, sprintf("  6Health: %0.2f | Armour: %0.2f | Skin: %i | World ID: %i | Interior ID: %i | State: %s (%i)", hp, armour, skin, world, int, state_name, p_state));
		IRC_Echo(channel, sprintf("  6Weapons: %s", return_WepList(id)));
	}

	return 1;
}

IRCCMD:muted(botid, channel[], user[], host[], params[])
{
	if (!IRC_IsVoice(botid, channel, user))
        return IRC_Echo(channel, ""#IRC_PREFIX_ERROR"Access denied.");

	new count = 0, list[300];

	foreach(new i : Player)
	{
		if (Player(i, Muted) != 0)
		{
		    Format:list("%s%s[%i], ", list, playerName(i));
		    ++count;
		}
	}

	if (count)
	{
	    Format:list("6 Muted players: %s", list);
		IRC_Echo(channel, list);
	}
	else
	{
	    IRC_Echo(channel, "5There are no muted players.");
	}

	return 1;
}

IRCCMD:miniguns(botid, channel[], user[], host[], params[])
{
	if (!IRC_IsVoice(botid, channel, user))
       return IRC_Echo(channel, ""#IRC_PREFIX_ERROR"Access denied.");

	new count = 0, list[300], wep;

	foreach(new i : Player)
	{
	    wep = GetPlayerWeapon(i);

		if (!Var(i, Duty) && wep == 38)
		{
		    Format:list("%s%s[%i], ", list, playerName(i));
		    ++count;
		}
	}

	if (count)
	{
	    Format:list("6 Players with minigun: %s", list);
		IRC_Echo(channel, list);
	}
	else
	{
	    IRC_Echo(channel, "5No one has a minigun.");
	}

	return 1;
}

IRCCMD:reports(botid, channel[], user[], host[], params[])
{
	if (!IRC_IsVoice(botid, channel, user))
        return IRC_Echo(channel, ""#IRC_PREFIX_ERROR"Access denied.");

	if (!Report(0, Used))
		return IRC_Echo(channel, "5There are no reports logged.");

	new text[144];

	IRC_Echo(channel, "6 Logged reports:");
	Format:text("6   1: %s - reported by %s", Report(0, Name), Report(0, Reason));
	IRC_Echo(channel, text);

	for (new i = 1, j = 10; i < j; i++)
	{
		if (Report(i, Used) == true)
		{
            Format:text("6   %i: %s - reported by %s", (i+1), Report(i, Name), Report(i, Reason));
            IRC_Echo(channel, text);
		}
	}

	return 1;
}

IRCCMD:kick(botid, channel[], user[], host[], params[])
{
	if (!IRC_IsVoice(botid, channel, user))
        return IRC_Echo(channel, ""#IRC_PREFIX_ERROR"Access denied.");

	new id;

	if (sscanf(params, "us[128]", id, params))
		return IRC_Echo(channel, "0,14 USAGE  !kick <playerid/name> <reason>");
	
	if (strlen(params) > 50)
	    return IRC_Echo(channel, ""#IRC_PREFIX_ERROR"Reason length exceeds maximum characters limit.");

	if (IsValidTargetPlayer(-1, id, true, channel))
	{
		SendClientMessageToAll(-1, sprintf("[IRC] "#sc_tomato"Administrator %s has kicked player %s. Reason: %s", user, playerName(id), params));
		IRC_Echo(channel, sprintf("0,5 KICK  Administrator %s has kicked  player %s. Reason: %s", user, playerName(id), params));
		KickEx(id, c_red, "You have been kicked.");
	}
	
	return 1;
}

IRCCMD:warn(botid, channel[], user[], host[], params[])
{
	if (!IRC_IsVoice(botid, channel, user))
        return IRC_Echo(channel, ""#IRC_PREFIX_ERROR"Access denied.");

    new id;

    if (sscanf(params, "us[50]", id, params))
        return IRC_Echo(channel, "0,14 USAGE  !warn <playerid/name> <reason>");

	if (IsValidTargetPlayer(-1, id, true, channel))
	{
        if (gettime() < Var(id, Warned))
            return IRC_Echo(channel, "5Please wait...");
		
		if (strlen(params) > MAX_REASON)
			return IRC_Echo(channel, ""#IRC_PREFIX_ERROR"Reason length exceeds the maximum characters limit. Limit: 35 chars");

	    ++Var(id, Warns);
	    SendClientMessageToAll(-1, sprintf("[IRC] {FF8000}Administrator %s has warned player %s[%i] - Warns: %i/5", user, playerName(id), id, Var(id, Warns)));
		SendClientMessageToAll(0xFF8000FF, sprintf("* Reason: %s", params));
        IRC_Echo(channel, sprintf("0,7 WARN  Administrator %s has warned player %s[%i] - Reason: %s | Warns: %i/5", user, playerName(id), id, params, Var(id, Warns)));
		WarnPlayer(id, user, params);
	}

	return 1;
}

IRCCMD:cc(botid, channel[], user[], host[], params[])
{
	if (!IRC_IsVoice(botid, channel, user))
        return IRC_Echo(channel, ""#IRC_PREFIX_ERROR"Access denied.");

	for(new i = 0, j = 50; i < j; ++i)
	{
		SendClientMessageToAll(-1, " ");
	}
	
	IRC_Echo(channel, ""#IRC_PREFIX_SUCCESS"In-game chat has been cleared.");

	return 1;
}

IRCCMD:mute(botid, channel[], user[], host[], params[])
{
	if (!IRC_IsVoice(botid, channel, user))
        return IRC_Echo(channel, ""#IRC_PREFIX_ERROR"Access denied.");

	new id, time;

	if (sscanf(params, "uds[80]", id, time, params))
		return IRC_Echo(channel, "0,14 USAGE  !mute <playerid/name> <minutes> <reason>");
	
	if (time > 15)
	    return IRC_Echo(channel, ""#IRC_PREFIX_ERROR"You cannot mute for more than 10 minutes.");
	
	if (strlen(params) > MAX_REASON)
		return IRC_Echo(channel, ""#IRC_PREFIX_ERROR"Reason length exceeds the maximum characters limit. Limit: 35 chars");

	if (IsValidTargetPlayer(-1, id, true, channel))
	{
		if (Player(id, Muted) != 0)
			return IRC_Echo(channel, ""#IRC_PREFIX_ERROR"Specified player is already muted.");

		SendClientMessageToAll(-1, sprintf("[IRC] "#sc_tomato"Administrator %s has muted player %s[%i] for %i minute(s).", user, playerName(id), id, time));
		SendClientMessageToAll(c_tomato, sprintf("* Reason: %s", params));

		IRC_Echo(channel, sprintf("0,5 MUTE  Administrator %s has muted player %s[%i] for %i minute(s). Reason: %s", user, playerName(id), id, time, params));
		SendClientMessage(id, c_red, sprintf("You have been muted by admin %s for %i minute(s) - Reason: %s", user, time, params));
		Player(id, Muted) = gettime() + (time * 60);

		new query[100];
		
		Query("UPDATE `users` SET `mute_time`='%i' WHERE `id`='%i'", Player(id, UserID));
		mysql_tquery(connection, query, "ExecuteQuery", "i", res_none);
	}

	return 1;
}

IRCCMD:unmute(botid, channel[], user[], host[], params[])
{
	if (!IRC_IsVoice(botid, channel, user))
        return IRC_Echo(channel, ""#IRC_PREFIX_ERROR"Access denied.");

	new id;

	if (sscanf(params, "u", id))
		return IRC_Echo(channel, "0,14 USAGE  !unmute <playerid/name>");

	if (IsValidTargetPlayer(-1, id, true, channel))
	{
		if (!Player(id, Muted))
			return IRC_Echo(channel, ""#IRC_PREFIX_ERROR"Specified player is not muted.");

		SendClientMessageToAll(-1, sprintf("[IRC] "#sc_green"Administrator %s has un-muted player %s[%i].", user, playerName(id), id));
        IRC_Echo(channel, sprintf("3* Administrator %s has un-muted player %s[%i].", user, playerName(id), id));
		SendClientMessage(id, ac_cmd2, sprintf("You have been un-muted by admin %s.", user));
		UnmutePlayer(id);
	}

	return 1;
}

IRCCMD:weaps(botid, channel[], user[], host[], params[])
{
	if (!IRC_IsVoice(botid, channel, user))
        return IRC_Echo(channel, ""#IRC_PREFIX_ERROR"Access denied.");

	new id;

	if (sscanf(params, "u", id))
	    return IRC_Echo(channel, "0,14 USAGE  !weaps <playerid/name>");

	if (IsValidTargetPlayer(-1, id, true, channel))
	{
	    if (!Var(id, Spawned))
	        return IRC_Echo(channel, ""#IRC_PREFIX_ERROR"Specified player is not spawned.");

		IRC_Echo(channel, sprintf("%s%s's weapons:", IRC_PREFIX_RESULT, playerName(id)));
		IRC_Echo(channel, return_WepList(id));
	}

	return 1;
}

IRCCMD:rsvall(botid, channel[], user[], host[], params[])
{
	if (!IRC_IsVoice(botid, channel, user))
        return IRC_Echo(channel, ""#IRC_PREFIX_ERROR"Access denied.");

    for (new i, j = MAX_VEHICLES; i < j; i++)
	{
        if (!Vehicle(i, BombingPlane))
		{
			if (!vehicle_IsOccupied(i) && IsValidVehicle(i))
			{
				SetVehicleToRespawn(i);
			}
		}
	}

	SendClientMessageToAll(-1, sprintf("» [IRC] "#sc_ac_gcmd"Administrator %s has respawned all unused vehicles.", user));
    IRC_Echo(channel, sprintf("» [IRC] 3Administrator %s has respawned all unused vehicles.", user));

	return 1;
}

IRCCMD:site(botid, channel[], user[], host[], params[])
{
    if (!IRC_IsVoice(botid, channel, user))
        return IRC_Echo(channel, ""#IRC_PREFIX_ERROR"Access denied.");

	SendClientMessageToAll(c_lightyellow, ">>> Visit our server website at: www.teamdss.com <<<");
	GameTextForAll("~n~~n~~g~~h~server website~n~~w~http://www.teamdss.com", 6000, 3);
	IRC_Echo(channel, "7>>> Visit our server website at: www.teamdss.com <<<");

    return 1;
}

/******************************************************************************/

// Level 2 (Half OP)

IRCCMD:astats(botid, channel[], user[], host[], params[])
{
	if (!IRC_IsHalfop(botid, channel, user))
        return IRC_Echo(channel, ""#IRC_PREFIX_ERROR"Access denied.");

	new id;

	if (sscanf(params, "u", id))
	    return IRC_Echo(channel, "0,14 USAGE  !astats <playerid/name>");

	if (IsValidTargetPlayer(-1, id, true, channel))
	{
	    if (IsTargetPlayerSpawned(-1, id, true, channel))
		{
			new clanid = Player(id, ClanID);

			IRC_Echo(channel, "6AStats:");
			IRC_Echo(channel, sprintf("  6Name: %s, Player ID: %i, IP: %s, Account ID: %i, Registered date: %s",
				playerName(id), id, Player(id, Ip), Player(id, UserID), Player(id, RegDate)));

			IRC_Echo(channel, sprintf("  6Admin level: %i, VIP: %s, Is a clan member: %s, member of %s",
		        Player(id, Level), g_VIPName[Player(id, VIP)], (clanid == -1) ? ("No") : ("Yes"), Clan(clanid, Name)));
		}
	}

	return 1;
}

IRCCMD:apm(botid, channel[], user[], host[], params[])
{
	if (!IRC_IsHalfop(botid, channel, user))
        return IRC_Echo(channel, ""#IRC_PREFIX_ERROR"Access denied.");

	new id;

 	if (sscanf(params, "us[128]", id, params))
	 	return IRC_Echo(channel, "0,14 USAGE  !apm <playerid/name> <message>");

	if (IsValidTargetPlayer(-1, id, true, channel))
	{
		SendClientMessage(id, c_red, sprintf("- IRC PM from Admin: {%06x}%s", (-1 >>> 8), params));
		IRC_Echo(channel, sprintf("4[APM] %s > %s: %s", user, playerName(id), params));
	}

	return 1;
}

IRCCMD:bancheck(botid, channel[], user[], host[], params[])
{
	if (!IRC_IsHalfop(botid, channel, user))
        return IRC_Echo(channel, ""#IRC_PREFIX_ERROR"Access denied.");
	
	if (sscanf(params, "s[24]", params))
	 	return IRC_Echo(channel, "0,14 USAGE  !bancheck <username/IP>");

	new query[128];

	Query("SELECT * FROM `bans` WHERE `nick`='%e' OR `ip`='%e' ORDER BY `id`", params, params);
	mysql_tquery(connection, query, "ExecuteQuery", "iis", res_search_ban, -1, channel);

	return 1;
}

IRCCMD:ip(botid, channel[], user[], host[], params[])
{
	if (!IRC_IsHalfop(botid, channel, user))
        return IRC_Echo(channel, ""#IRC_PREFIX_ERROR"Access denied.");

	new id;

 	if (sscanf(params, "u", id))
	 	return IRC_Echo(channel, "0,14 USAGE  !ip <playerid/name>");

	if (IsValidTargetPlayer(-1, id, true, channel))
	{
		IRC_Echo(channel, sprintf("%s%s's IP: %s", IRC_PREFIX_RESULT, playerName(id), Player(id, Ip)));
	}

	return 1;
}

IRCCMD:fps(botid, channel[], user[], host[], params[])
{
	if (!IRC_IsHalfop(botid, channel, user))
        return IRC_Echo(channel, ""#IRC_PREFIX_ERROR"Access denied.");

	new id;

 	if (sscanf(params, "u", id))
	 	return IRC_Echo(channel, "0,14 USAGE  !fps <playerid/name>");

	if (IsValidTargetPlayer(-1, id, true, channel))
	{
		IRC_Echo(channel, sprintf("%s%s's current FPS: %i", IRC_PREFIX_RESULT, playerName(id), Var(id, FPS)));
	}

	return 1;
}

IRCCMD:pl(botid, channel[], user[], host[], params[])
{
	if (!IRC_IsHalfop(botid, channel, user))
        return IRC_Echo(channel, ""#IRC_PREFIX_ERROR"Access denied.");

    new id;

    if (sscanf(params, "u", id))
        return IRC_Echo(channel, "0,14 USAGE  !pl <playerid/name>");

	if (IsValidTargetPlayer(-1, id, true, channel))
	{
		IRC_Echo(channel, sprintf("%s%s's current packet loss: %0.2f", IRC_PREFIX_RESULT, playerName(id), Var(id, FPS)));
	}

	return 1;
}

IRCCMD:ban(botid, channel[], user[], host[], params[])
{
	if (!IRC_IsHalfop(botid, channel, user))
        return IRC_Echo(channel, ""#IRC_PREFIX_ERROR"Access denied.");

	new reason[50];

	if (sscanf(params, "s[24]s[50]", params, reason))
		return IRC_Echo(channel, "0,14 USAGE  !ban <username> <reason>");
	
	if (strlen(reason) > 50)
	    return IRC_Echo(channel, ""#IRC_PREFIX_ERROR"Reason length exceeds maximum characters limit");

	new query[200], id = return_IDByName(params);

	if (id == -1)
	{
	    Query("SELECT `id`,`nick`,`ip` FROM `users` WHERE `nick`='%e' ORDER BY `id`", params);
		return mysql_tquery(connection, query, "IRC_Check_OfflineBan", "ssssi", channel, params, user, reason, 0);

	}

	Query("INSERT INTO `bans` (id,nick,bannedby,date,ip,type,reason) VALUES ('%d','%e','%e',UTC_TIMESTAMP(),'%e','%e','%e')", Player(id, UserID), playerName(id), user, Player(id, Ip), "Permanent", reason);
	mysql_tquery(connection, query, "ExecuteQuery", "i", res_none);

	SendClientMessageToAll(-1, sprintf("[IRC] "#sc_tomato"Administrator %s has banned player %s. Reason: %s", user, playerName(id), reason));
	IRC_Echo(channel, sprintf("%sAdministrator %s has banned player %s. Reason: %s", IRC_PREFIX_BAN, user, playerName(id), reason));
	KickEx(id, c_red, "You have been banned.");

	return 1;
}

IRCCMD:tban(botid, channel[], user[], host[], params[])
{
	if (!IRC_IsHalfop(botid, channel, user))
        return IRC_Echo(channel, ""#IRC_PREFIX_ERROR"Access denied.");

	new hours, minutes, reason[50];

	if (sscanf(params, "s[24]iis[50]", params, hours, minutes, reason))
		return IRC_Echo(channel, "0,14 USAGE  !tban <username> <hours> <minutes> <reason>");
	
	if (strlen(reason) > 50)
	    return IRC_Echo(channel, ""#IRC_PREFIX_ERROR"Reason length exceeds maximum characters limit.");

	new id = return_IDByName(params), query[250];

	if (id == -1)
	{
		Query("SELECT `id`,`nick`,`ip` FROM `users` WHERE `nick`='%e' ORDER BY `id`", params);
		return mysql_tquery(connection, query, "IRC_Check_OfflineBan", "ssssiii", channel, params, user, reason, 1, hours, minutes);
	}

 	new stamp = (hours * 3600) + (minutes * 60) + gettime();

	SendClientMessageToAll(-1, sprintf("[IRC] "#sc_tomato"Administrator %s has temporarily banned %s for %iH and %iM.", user, playerName(id), hours, minutes));
	SendClientMessageToAll(c_red, sprintf("Reason: %s", reason));
	IRC_Echo(channel, sprintf("%sAdministrator %s has temporarily banned %s for%iH and %iM. Reason: %s", IRC_PREFIX_BAN, user, playerName(id), hours, minutes, reason));

	Query("INSERT INTO `bans` (id,nick,bannedby,date,ip,type,time,reason) VALUES ('%i','%e','%e',UTC_TIMESTAMP(),'%e','%e','%i','%e')", Player(id, UserID), playerName(id), user, Player(id, Ip), "Temporary", stamp, reason);
    mysql_tquery(connection, query, "ExecuteQuery", "i", res_none);
    KickEx(id, c_red, "You have been banned.");

	return 1;
}

IRCCMD:unban(botid, channel[], user[], host[], params[])
{
	if (!IRC_IsHalfop(botid, channel, user))
        return IRC_Echo(channel, ""#IRC_PREFIX_ERROR"Access denied.");

    if (sscanf(params, "s[24]", params))
		return IRC_Echo(channel, "0,14 USAGE  !unban <username/IP>");

	new query[128];

	Query("SELECT * FROM `bans` WHERE `nick`='%e' OR `ip`='%e' ORDER BY `id`", params, params);
	mysql_tquery(connection, query, "IRC_Offline_Unban", "sis", params, INVALID_PLAYER_ID, channel);

	return 1;
}

/******************************************************************************/

// Level 3 (Half OP)

IRCCMD:aka(botid, channel[], user[], host[], params[])
{
	if (!IRC_IsHalfop(botid, channel, user))
        return IRC_Echo(channel, ""#IRC_PREFIX_ERROR"Access denied.");

	new id;

	if (sscanf(params, "u", id))
	    return IRC_Echo(channel, "0,14 USAGE  !aka <playerid/name>");

	if (IsValidTargetPlayer(-1, id, true, channel))
	{
		new query[146];

		Query("SELECT `nick` FROM `users` WHERE `ip`='%e' ORDER BY `id` DESC LIMIT 10", Player(id, Ip));
		mysql_tquery(connection, query, "result_FetchAKA", "iiis", -1, id, 1, channel);
	}

	return 1;
}

IRCCMD:cleancars(botid, channel[], user[], host[], params[])
{
	if (!IRC_IsHalfop(botid, channel, user))
        return IRC_Echo(channel, ""#IRC_PREFIX_ERROR"Access denied.");

    new count = 0;

	for(new i, j = MAX_VEHICLES; i < j; i++)
	{
	    if (!vehicle_IsOccupied(i) && IsValidVehicle(i))
	    {
	        if (Vehicle(i, Type))
				continue;

			if (!Vehicle(i, Static) && !Vehicle(i, BombingPlane))
			{
		        DestroyVehicle(i);
		  		count++;

                new _x[E_VEHICLE_DATA];

		  		g_Vehicle[i] = _x;

		  		foreach(new x : Player)
		  		{
					if (Var(x, Vehicle) == i)
					{
                        Var(x, Vehicle) = 0;
			  		}
				}
			}
		}
	}

	if (count)
	{
		admin_SendMessage(1, -1, sprintf("[IRC] {CCB3DD}Admin %s has removed total of '%i' spawned vehicles.", user, count));
        IRC_Echo(g_IRC_Conn[IRC_ADMIN_CHANNEL], sprintf("6Admin %s has removed total of '%i' spawned vehicles.", user, count));
	}
	else
	{
	    IRC_Echo(channel, "5There are no vehicles spawned.");
	}

	return 1;
}

IRCCMD:fixall(botid, channel[], user[], host[], params[])
{
	if (!IRC_IsHalfop(botid, channel, user))
        return IRC_Echo(channel, ""#IRC_PREFIX_ERROR"Access denied.");

	for (new i, j = MAX_VEHICLES; i < j; i++)
	{
	    if (IsValidVehicle(i))
	    {
			RepairVehicle(i);
		}
	}

    SendClientMessageToAll(-1, sprintf("» [IRC] "#sc_ac_gcmd"Administrator %s has fixed all the vehicles.", user));
	IRC_Echo(channel, sprintf("» [IRC] 10Administrator %s has fixed all the vehicles.", user));
	
	return 1;
}

/******************************************************************************/

// Level 4 (OP)

IRCCMD:settime(botid, channel[], user[], host[], params[])
{
	if (!IRC_IsOp(botid, channel, user))
        return IRC_Echo(channel, ""#IRC_PREFIX_ERROR"Access denied.");

    new hour;

    if (sscanf(params, "i", hour))
        return IRC_Echo(channel, "0,14 USAGE  !settime <hour 0-23>");
	
	if (hour > 23)
	    return IRC_Echo(channel, ""#IRC_PREFIX_ERROR"Invalid hour format. Max: 23H.");

	SetWorldTime(hour);

	Server(Time) = hour;

	SendClientMessageToAll(-1, sprintf("» [IRC] "#sc_ac_gcmd"Administrator %s has set the server time to %02d:00.", user, hour));
    IRC_Echo(channel, sprintf("» [IRC] 10Administrator %s has set the server time to %02d:00.", user, hour));

	return 1;
}

IRCCMD:setweather(botid, channel[], user[], host[], params[])
{
	if (!IRC_IsOp(botid, channel, user))
        return IRC_Echo(channel, ""#IRC_PREFIX_ERROR"Access denied.");

    new weatherid;

    if (sscanf(params, "i", weatherid))
        return IRC_Echo(channel, "0,14 USAGE  !setweather <weatherid>");
	
	if (weatherid > 50)
	    return IRC_Echo(channel, ""#IRC_PREFIX_ERROR"Invalid weather.");

	SetWeather(weatherid);

	Server(Weather) = weatherid;

	SendClientMessageToAll(-1, sprintf("» [IRC] "#sc_ac_gcmd"Administrator %s has set the weather to %i.", user, weatherid));
    IRC_Echo(channel, sprintf("» [IRC] 10Administrator %s has set the weather to %i.", user, weatherid));

	return 1;
}

IRCCMD:rban(botid, channel[], user[], host[], params[])
{
	if (!IRC_IsOp(botid, channel, user))
        return IRC_Echo(channel, ""#IRC_PREFIX_ERROR"Access denied.");

	new id;

	if (sscanf(params, "u", id))
		return IRC_Echo(channel, "0,14 USAGE  !rban <playerid/name>");

	if (IsValidTargetPlayer(-1, id, true, channel))
	{
		new r_ip[16];

		r_ip = return_RangeIP(Player(id, Ip));

		for (new i = 0, j = 256; i < j; i++)
		{
            SendRconCommand(sprintf("banip %s%i", r_ip, i));
		}

		KickEx(id, c_red, "You have been kicked.");

		admin_SendMessage(1, ac_cmd1, sprintf("[IRC] {CCB3DD]Admin %s has range banned %s.", user, playerName(id)));
        IRC_Echo(g_IRC_Conn[IRC_ADMIN_CHANNEL], sprintf("[IRC] 6Admin %s has range banned %s.", user, playerName(id)));
	}

	return 1;
}

IRCCMD:dischat(botid, channel[], user[], host[], params[])
{
	if (!IRC_IsOp(botid, channel, user))
        return IRC_Echo(channel, ""#IRC_PREFIX_ERROR"Access denied.");

	if (Server(ChatDisabled))
		return IRC_Echo(channel, ""#IRC_PREFIX_ERROR"Chat is already disabled.");

	SendClientMessageToAll(-1, sprintf("» [IRC] "#sc_red"Administrator %s has disabled the chat.", user));
	IRC_Echo(channel, sprintf("» [IRC] 4Administrator %s has disabled the chat.", user));

	Server(ChatDisabled) = true;

	return 1;
}

IRCCMD:enchat(botid, channel[], user[], host[], params[])
{
	if (!IRC_IsOp(botid, channel, user))
        return IRC_Echo(channel, ""#IRC_PREFIX_ERROR"Access denied.");

	if (!Server(ChatDisabled))
		return IRC_Echo(channel, ""#IRC_PREFIX_ERROR"Chat is already enabled.");

	SendClientMessageToAll(-1, sprintf("» [IRC] "#sc_ac_gcmd"Administrator %s has enabled the chat.", user));
    IRC_Echo(channel, sprintf("» [IRC] 10Administrator %s has enabled the chat.", user));

	Server(ChatDisabled) = false;

	return 1;
}

IRCCMD:changename(botid, channel[], user[], host[], params[])
{
	if (!IRC_IsOp(botid, channel, user))
	    return IRC_Echo(channel, ""#IRC_PREFIX_ERROR"Access denied.");

	new new_name[24];

	if (sscanf(params, "s[24]s[24]", params, new_name))
	    return IRC_Echo(channel, "0,14 USAGE  !changename <username> <newname>");
	
	if (strlen(new_name) > 20 || strlen(new_name) <= 3)
	    return IRC_Echo(channel, ""#IRC_PREFIX_ERROR"Characters should not be higher than 20 and lower than 3.");
	
	if (!IsValidName(new_name))
	    return IRC_Echo(channel, ""#IRC_PREFIX_ERROR"Invalid characters found.");
	
	if (!strcmp(params, new_name, true))
	    return IRC_Echo(channel, ""#IRC_PREFIX_ERROR"New name cannot be the same.");

	new query[128], id = return_IDByName(params);

 	if (id != -1)
        return IRC_Echo(channel, ""#IRC_PREFIX_ERROR"This user is currently online, name cannot be changed.");

	Query("SELECT `nick`,`id` FROM `bans` WHERE `nick`='%e' ORDER BY `id`", params);
    mysql_tquery(connection, query, "IRC_ChangeName", "sssi", params, new_name, channel, 0);

	return 1;
}

IRCCMD:ann(botid, channel[], user[], host[], params[])
{
    if (!IRC_IsOp(botid, channel, user))
        return IRC_Echo(channel, ""#IRC_PREFIX_ERROR"Access denied.");

	new time, text[128];

	if (sscanf(params, "is[128]", time, text))
		return IRC_Echo(channel, "0,14 USAGE  !ann <time> <text>");
	
	if (time == 0 || time > 5)
		return IRC_Echo(channel, ""#IRC_PREFIX_ERROR"Invalid time format. Use 1 to 5 seconds.");
	
	if (strlen(text) > 119)
	    return IRC_Echo(channel, ""#IRC_PREFIX_ERROR"Message length exceeds the maximum characters limit. Limit: 120 chars.");

	Announce(text, (time * 1000));
    IRC_Echo(channel, sprintf("14Announcement: %s", text));

	return 1;
}

IRCCMD:setping(botid, channel[], user[], host[], params[])
{
    if (!IRC_IsOp(botid, channel, user))
        return IRC_Echo(channel, ""#IRC_PREFIX_ERROR"Access denied.");

	new ping;

	if (sscanf(params, "d", ping))
		return IRC_Echo(channel, "0,14 USAGE  !setping <max limit>");

	if (ping > 1000)
		return IRC_Echo(channel, ""#IRC_PREFIX_ERROR"Maximum limit is 1000.");

	new string[128], string2[128];

	if (ping != 0)
	{
		Format:string("» [IRC] "#sc_ac_gcmd"Administrator %s has set the ping limit to %d.", user, ping);
		Format:string2("» [IRC] 10Administrator %s has set the ping limit to %d.", user, ping);
	}
	else
	{
		Format:string("» [IRC] "#sc_ac_gcmd"Administrator %s has disabled the ping limit.", user);
		Format:string2("» [IRC] 10Administrator %s has disabled the ping limit", user);
	}

	SendClientMessageToAll(-1, string);
	IRC_Echo(channel, string2);

	Server(MaxPing) = ping;

	return 1;
}

IRCCMD:givescore(botid, channel[], user[], host[], params[])
{
    if (!IRC_IsOp(botid, channel, user))
        return IRC_Echo(channel, ""#IRC_PREFIX_ERROR"Access denied.");

	new id, score;

	if (sscanf(params, "ud", id, score))
		return IRC_Echo(channel, "0,14 USAGE  !givescore <playerid/name> <score>");

	if (IsValidTargetPlayer(-1, id, true, channel))
	{
		IRC_Echo(channel, sprintf("6You have given %i score to player %s.", score, playerName(id)));
		SendClientMessage(id, ac_cmd2, sprintf("[IRC] You have received %i score from admin %s.", score, user));

		RewardPlayer(id, 0, score, true);
	}

	return 1;
}

IRCCMD:givecash(botid, channel[], user[], host[], params[])
{
    if (!IRC_IsOp(botid, channel, user))
        return IRC_Echo(channel, ""#IRC_PREFIX_ERROR"Access denied.");

	new id, cash;

	if (sscanf(params, "ud", id, cash))
 		return IRC_Echo(channel, "0,14 USAGE  !givecash <playerid/name> <amount>");

	if (IsValidTargetPlayer(-1, id, true, channel))
	{
	    if (cash > 50000)
	        return IRC_Echo(channel, ""#IRC_PREFIX_ERROR"You cannot give more than $50000");

		IRC_Echo(channel, sprintf("6You have given $%i to %s.", cash, playerName(id)));
		SendClientMessage(id, ac_cmd2, sprintf("[IRC] You have received $%i from admin %s.", cash, user));

		RewardPlayer(id, cash, 0, true);
	}

	return 1;
}

/******************************************************************************/

// Level 5 (Admin)
IRCCMD:weaponall(botid, channel[], user[], host[], params[])
{
	if (!IRC_IsAdmin(botid, channel, user))
	    return IRC_Echo(channel, ""#IRC_PREFIX_ERROR"Access denied.");

	new model[50], ammo;

	if (sscanf(params, "s[50]i", model, ammo))
		return IRC_Echo(channel, "0,14 USAGE  !weaponall <weapon name> <ammo>");

	new weaponid = weapon_ReturnModelFromName(model);

	if (ammo > 1000)
		return IRC_Echo(channel, ""#IRC_PREFIX_ERROR"Ammo cannot be higher than 1000.");
	
	if (weaponid == -1 || weaponid == 38)
		return IRC_Echo(channel, ""#IRC_PREFIX_ERROR"Invalid weapon name.");

	foreach(new i : Player)
	{
	    if (Var(i, Spawned))
	    {
			if (Var(i, DM) == 0 && Var(i, DuelID) == -1)
			{
			    if (GetPlayerState(i) == PLAYER_STATE_SPECTATING)
			    	continue;
				
				GivePlayerWeapon(i, weaponid, ammo);
			}
		}
	}

	SendClientMessageToAll(-1, sprintf("» [IRC] "#sc_ac_gcmd"Administrator %s has given all players a weapon %s[%d] with %i ammo.", user, aWeaponNames[weaponid], weaponid, ammo));
	IRC_Echo(channel, sprintf("» [IRC]10Administrator %s has given all players a weapon %s[%d] with %i ammo.", user, aWeaponNames[weaponid], weaponid, ammo));

	return 1;
}

IRCCMD:moneyall(botid, channel[], user[], host[], params[])
{
	if (!IRC_IsAdmin(botid, channel, user))
	    return IRC_Echo(channel, ""#IRC_PREFIX_ERROR"Access denied.");

	new amount;

	if (sscanf(params, "i", amount))
		return IRC_Echo(channel, "0,14 USAGE  !moneyall <amount>");

	foreach(new i : Player)
	{
		RewardPlayer(i, amount, 0);
	}

	SendClientMessageToAll(-1, sprintf("» [IRC] "#sc_ac_gcmd"Administrator %s has given all players $%i.", user, amount));
    IRC_Echo(channel, sprintf("» [IRC]10Administrator %s has given all players $%i.", user, amount));

	return 1;
}

IRCCMD:scoreall(botid, channel[], user[], host[], params[])
{
	if (!IRC_IsAdmin(botid, channel, user))
	    return IRC_Echo(channel, ""#IRC_PREFIX_ERROR"Access denied.");

	new amount;

    if (sscanf(params, "i", amount))
		return IRC_Echo(channel, "0,14 USAGE  !scoreall <amount>");

	foreach(new i : Player)
	{
		RewardPlayer(i, 0, amount);

		if (Var(i, Spawned))
		{
			UpdateRank(i);
		}
	}

	SendClientMessageToAll(-1, sprintf("» [IRC] "#sc_ac_gcmd"Administrator %s has given all players %i score.", user, amount));
    IRC_Echo(channel, sprintf("» [IRC]10Administrator %s has given all players %i score.", user, amount));

	return 1;
}

IRCCMD:helmetall(botid, channel[], user[], host[], params[])
{
	if (!IRC_IsAdmin(botid, channel, user))
	    return IRC_Echo(channel, ""#IRC_PREFIX_ERROR"Access denied.");

	foreach(new i : Player)
	{
        if (Var(i, HasHelmet))
			continue;

		if (Var(i, DM) == 0 && Var(i, DuelID) == -1)
		{
			ToggleHelmet(i, 1);
			Var(i, HasHelmet) = 1;
		}
	}

	SendClientMessageToAll(-1, sprintf("» [IRC] "#sc_ac_gcmd"Administrator %s has given a helmet to all the players.", user));
    IRC_Echo(channel, sprintf("» [IRC]10Administrator %s has given a helmet to all the players.", user));

	return 1;
}

IRCCMD:maskall(botid, channel[], user[], host[], params[])
{
	if (!IRC_IsAdmin(botid, channel, user))
	    return IRC_Echo(channel, ""#IRC_PREFIX_ERROR"Access denied.");

	foreach(new i : Player)
	{
        if (Var(i, HasMask))
			continue;

		if (Var(i, DM) == 0 && Var(i, DuelID) == -1)
		{
			ToggleMask(i, 1);
			Var(i, HasMask) = 1;
		}
	}

	SendClientMessageToAll(-1, sprintf("» [IRC] "#sc_ac_gcmd"Administrator %s[%i] has given an anti teargas mask to all the players.", user));
    IRC_Echo(channel, sprintf("» [IRC]10Administrator %s[%i] has given an anti teargas mask to all the players.", user));

	return 1;
}

IRCCMD:getlevel(botid, channel[], user[], host[], params[])
{
    if (!IRC_IsAdmin(botid, channel, user))
        return IRC_Echo(channel, ""#IRC_PREFIX_ERROR"Access denied.");

	if (sscanf(params, "s[24]", params))
		return IRC_Echo(channel, "0,14 USAGE  !getlevel <username>");

	new query[128];

	Query("SELECT `nick`,`level` FROM `users` WHERE `nick`='%e'", params);
	mysql_tquery(connection, query, "ExecuteQuery", "iis", res_fetch_level, 0, channel);

	return 1;
}

IRCCMD:getvip(botid, channel[], user[], host[], params[])
{
    if (!IRC_IsAdmin(botid, channel, user))
        return IRC_Echo(channel, ""#IRC_PREFIX_ERROR"Access denied.");

	if (sscanf(params, "s[24]", params))
		return IRC_Echo(channel, "0,14 USAGE  !getvip <username>");

	new query[128];

	Query("SELECT `nick`,`vip` FROM `users` WHERE `nick`='%e'", params);
	mysql_tquery(connection, query, "ExecuteQuery", "iis", res_fetch_vip, 0, channel);

	return 1;
}

IRCCMD:getcredits(botid, channel[], user[], host[], params[])
{
    if (!IRC_IsAdmin(botid, channel, user))
        return IRC_Echo(channel, ""#IRC_PREFIX_ERROR"Access denied.");

	if (sscanf(params, "s[24]", params))
		return IRC_Echo(channel, "0,14 USAGE  !getcredits <username>");

	new query[128];

	Query("SELECT `nick`,`credits` FROM `users` WHERE `nick`='%e'", params);
	mysql_tquery(connection, query, "ExecuteQuery", "iis", res_fetch_cr, 0, channel);

	return 1;
}

IRCCMD:setadmin(botid, channel[], user[], host[], params[])
{
    if (!IRC_IsAdmin(botid, channel, user))
        return IRC_Echo(channel, ""#IRC_PREFIX_ERROR"Access denied.");
	
	new newlevel;

	if (sscanf(params, "s[24]i", params, newlevel))
		return IRC_Echo(channel, "0,14 USAGE  !setadmin <username> <level>");
    
    if (!IRC_IsOwner(botid, channel, user) && newlevel > 6)
		return IRC_Echo(channel, ""#IRC_PREFIX_ERROR"Invalid level.");
	
	new query[128], id = return_IDByName(params);

	if (id == -1)
	{
        Query("SELECT `id`,`nick`,`level` FROM `users` WHERE `nick`='%e' ORDER BY `id`", params);
		return mysql_tquery(connection, query, "ExecuteQuery", "iis", res_set_level, newlevel, channel);
	}

	new oldlevel = Player(id, Level);

	Player(id, Level) = newlevel;

	if (oldlevel == newlevel)
		return IRC_Echo(channel, ""#IRC_PREFIX_ERROR"Specified user's level has not been changed.");

	if (oldlevel > newlevel || oldlevel < newlevel)
	{
       	IRC_Echo(channel, sprintf("%sUser %s's admin level has been set to %i. (Online)", IRC_PREFIX_SUCCESS, playerName(id), newlevel));
       	SendClientMessage(id, -1, sprintf("[IRC] {2ED1BD}%s has set your admin level to %i.", user, newlevel));
	}

	Query("UPDATE `users` SET `level`='%d' WHERE `id`='%d'", Player(id, Level), Player(id, UserID));
	mysql_tquery(connection, query, "ExecuteQuery", "i", res_none);

	return 1;
}

IRCCMD:webmotd(botid, channel[], user[], host[], params[])
{
	if (!IRC_IsOwner(botid, channel, user))
	    return IRC_Echo(channel, ""#IRC_PREFIX_ERROR"Access denied.");
	
	if (sscanf(params, "s[128]", params))
	    return IRC_Echo(channel, "0,14 USAGE  !webmotd <message>");

	if (strlen(params) > 120 || strlen(params) <= 3)
	    return IRC_Echo(channel, ""#IRC_PREFIX_ERROR"Characters should not be higher than 120 and lower than 3.");

	new query[500], str[156];

	Format:str("%sMOTD has been set to: %s", IRC_PREFIX_SUCCESS, params);
	IRC_Echo(channel, str);

	Query("UPDATE `motd` SET `motd_message`='%e',`set_by`='%e',`date`='%e' WHERE `motd_id`='1'", params, user, return_Stamp());
    mysql_tquery(connection, query, "ExecuteQuery", "i", res_none);

	return 1;
}

/*
                              IRC commands (Users)
*/

IRCCMD:cmds(botid, channel[], user[], host[], params[])
{
	return IRC_Notice(botid, user, "!teams, !rank, !msg, !pm, !getid, !score, !players, !vips, !admins, !lastseen, !stats");
}

IRCCMD:teams(botid, channel[], user[], host[], params[])
{
	foreach(new i : Teams)
	{
		IRC_Echo(channel, sprintf("Team: %s%s - Players: %i", g_Team_IRC_Color[i], Team(i, Name), Team(i, Players)));
	}

	return 1;
}

IRCCMD:lastseen(botid, channel[], user[], host[], params[])
{
	if (sscanf(params, "s[24]", params))
		return IRC_Echo(channel, "0,14 USAGE  !lastseen <username>");
	
	if (return_IDByName(params) != -1)
		return IRC_Echo(channel, ""#IRC_PREFIX_ERROR"Specified user is currently online.");
	
	new query[100];

	Query("SELECT `last_logged` FROM `users` WHERE `nick`='%e'", params);
	mysql_tquery(connection, query, "IRC_Check_LastSeen", "ss", channel, params);

	return 1;
}

IRCCMD:stats(botid, channel[], user[], host[], params[])
{
	new id;

	if (sscanf(params, "u", id))
		return IRC_Echo(channel, "0,14 USAGE  !stats <playerid/name>");
	
	if (IsValidTargetPlayer(-1, id, true, channel))
	{
	    if (IsTargetPlayerSpawned(-1, id, true, channel))
	    {
			ShowPlayerStats(id, -1, true, channel);
		}
	}

	return 1;
}

IRCCMD:rank(botid, channel[], user[], host[], params[])
{
	new id;

	if (sscanf(params, "u", id))
	 	return IRC_Echo(channel, "0,14 USAGE  !rank <playerid/name>");

	if (IsValidTargetPlayer(-1, id, true, channel))
	{
		IRC_Echo(channel, sprintf("%s%s's rank is %i (%s)", IRC_PREFIX_RESULT, playerName(id), Player(id, Rank), Rank(Player(id, Rank), Name)));
	}

	return 1;
}

IRCCMD:msg(botid, channel[], user[], host[], params[])
{
    if (sscanf(params, "s[128]", params))
		return IRC_Echo(channel, "0,14 USAGE  !msg <message>");
	
	if (strlen(params) > 100)
		return IRC_Echo(channel, ""#IRC_PREFIX_ERROR"Message length exceeds maximum characters limit.");

	IRC_Echo(channel, sprintf("3[IRC] %s: %s", user, params));
	SendClientMessageToAll(-1, sprintf("[IRC] {76BE95}%s {%06x}%s", user, (-1 >>> 8), params));

	return 1;
}

// This is in-game command to send a message on irc channel
CMD:irc(playerid, params[])
{
	if (sscanf(params, "s[120]", params))
		return error:_usage(playerid, "/irc <message>");

	if (!Player(playerid, Muted))
	{
	    if (strlen(params) > 120)
            return SendClientMessage(playerid, c_red, "Message length exceeds the maximum character limit.");
	
	    SendClientMessage(playerid, -1, sprintf("Message to IRC: %s", params));
    	IRC_Echo(g_IRC_Conn[IRC_MAIN_CHANNEL], sprintf("7,1 To IRC   %s[%i]: %s", playerName(playerid), playerid, params));
	}
	else
	{
		MuteWarn(playerid);
	}

	return 1;
}

IRCCMD:pm(botid, channel[], user[], host[], params[])
{
	new id;

	if (sscanf(params, "us[100]", id, params))
	    return IRC_Echo(channel, "0,14 USAGE  !pm <playerid/name> <message>");

	if (strlen(params) > 100)
	    return IRC_Echo(channel, ""#IRC_PREFIX_ERROR"Message length is too long.");
	
	if (IsValidTargetPlayer(-1, id, true, channel))
	{
		SendClientMessage(id, c_purple, sprintf("[IRC PM] %s {%06x}%s", user, (-1 >>> 8), params));
	    IRC_Echo(channel, sprintf("5[IRC PM] %s > %s: %s", user, playerName(id), params));
	}

	return 1;
}

IRCCMD:getid(botid, channel[], user[], host[], params[])
{
	if (sscanf(params, "s[24]", params))
		return IRC_Echo(channel, "0,14 USAGE  !getid <part of name>");

	new count = 0;

	foreach(new i : Player)
	{
	    if (strfind(playerName(i), params, true) != -1)
	    {
			count++;
			IRC_Echo(channel, sprintf("%s%s's ID is %i.", IRC_PREFIX_RESULT, playerName(i), i));
		}
	}

	if (!count)
	{
		IRC_Echo(channel, ""#IRC_PREFIX_ERROR"Cannot find ID for this name.");
	}

	return 1;
}

IRCCMD:score(botid, channel[], user[], host[], params[])
{
	new id;

	if (sscanf(params, "u", id))
		return IRC_Echo(channel, "0,14 USAGE  !score <playerid/name>");
	
	if (IsValidTargetPlayer(-1, id, true, channel))
	{
		IRC_Echo(channel, sprintf("%s%s's score is %i.", IRC_PREFIX_RESULT, playerName(id), Player(id, Score)));
	}

	return 1;
}

IRCCMD:players(botid, channel[], users[], host[], params[])
{
	new count = 0, list[500];

	foreach(new i : Player)
	{
		Format:list("%s%s[%i], ", list, playerName(i), i);
		count++;
	}

	if (count) {
		Format:list("2Players: [%i/100] - %s", count, list);
		IRC_Echo(channel, list);
	}
	else
	{
	    IRC_Echo(channel, "5There are no players online.");
	}

	return 1;
}

IRCCMD:vips(botid, channel[], users[], host[], params[])
{
	new count = 0, list[128];

	foreach(new i : Player)
	{
	    if (Player(i, VIP) > 0)
	    {
	        count++;
	        Format:list("%s%s, ", list, playerName(i));
		}
	}

	if (count)
	{
	    IRC_Echo(channel, sprintf("5Online VIPs: %s", list));
	}
	else
	{
	    IRC_Echo(channel, "5There are no VIPs online.");
	}

	return 1;
}

IRCCMD:admins(botid, channel[], users[], host[], params[])
{
	new count = 0, list[128];

	foreach(new i : Player)
	{
	    if (Player(i, Level) > 0)
	    {
	        count++;
	        Format:list("%s%s, ", list, playerName(i));
		}
	}

	if (count)
	{
	    IRC_Echo(channel, sprintf("12Online admins: %s", list));
	}
	else
	{
	    IRC_Echo(channel, "5There are no admins online.");
	}

	return 1;
}
