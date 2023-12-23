/*Admin commands*/

/*******************************************************************************
								Level 1 commands
*******************************************************************************/
CMD:site(playerid, params[]) {
	GameTextForAll("~n~~n~~n~~w~server website at~n~~g~www.teamdss.com", 5000, 3);
	SendClientMessageToAll(light_yellow, ">>>> Visit our server website at: www.teamdss.com <<<<");
	admin_CommandMessage(playerid, "site");
	return 1;
}

CMD:afk(playerid, params[]) {
	if (IsAuthorizedLevel(playerid, 2)) {
		new id;
		if (sscanf(params, "u", id)) {
		    return SendClientMessage(playerid, grey, "Usage: /afk <playerid/name>");
		}

		if (IsValidTargetPlayer(playerid, id)) {
		    if (!IsPlayerPaused(id)) {
				return SendClientMessage(playerid, red, "Specified player is not AFK.");
			}

			SendClientMessage(playerid, acolor, sprintf("You have kicked %s for being AFK.", g_Player[id][p_Name]));
			SendClientMessageToAll(red, sprintf("Player %s has been kicked from the server for being AFK [Away From Keyboard].", g_Player[id][p_Name]));

			KickEx(id, red, "You have been kicked for being AFK [Away From Keyboard]");
			admin_CommandMessage(playerid, "afk", id);
		}
	}
	return 1;
}

CMD:afklist(playerid, params[]) {
	if (IsAuthorizedLevel(playerid, 2)) {
		SendClientMessage(playerid, red, "Paused players:");
		new count = 0;
		foreach(new i : Player) {
		    if (g_Player[i][p_Spawned]) {
				if (IsPlayerPaused(i)) {
				    SendClientMessage(playerid, -1, sprintf("  %s[%i]", g_Player[i][p_Name]));
				    count++;
				}
			}
		}
		
		if (!count) {
		    SendClientMessage(playerid, red, "None");
		}
	}
	return 1;
}

CMD:acmds(playerid, params[]) {
	if(IsAuthorizedLevel(playerid, 1)) {
	    new level;
	    
	    if (sscanf(params, "i", level)) {
	        return SendClientMessage(playerid, grey, "Usage: /acmds <level>");
		}
		
		if (g_Player[playerid][p_Level] < 5 && level > 4) {
		    return SendClientMessage(playerid, red, "You can only view up to level 4.");
		}
		
		SendClientMessage(playerid, aqua, sprintf("Level %i admin commands:", level));
		for (new i = 0, j = sizeof(g_AdminCmds); i < j; i++) {
		    if (level == g_AdminCmds[i][acmd_Level]) {
				SendClientMessage(playerid, aqua, g_AdminCmds[i][acmd_Msg]);
			}
		}

	    admin_CommandMessage(playerid, "acmds", level);
	}
	return 1;
}

CMD:reports(playerid, params[]) {
	if(IsAuthorizedLevel(playerid, 1)) {
		admin_CommandMessage(playerid, "reports");

		if(g_Report[0][r_Used] == false) {
			return SendClientMessage(playerid, red, "There are no reports logged.");
		}
		new text[144];
        SendClientMessage(playerid, acolor, "Logged reports:");
		Format:text("  1: %s was reported by %s", g_Report[0][r_Name], g_Report[0][r_Reason]);
		SendClientMessage(playerid, acolor, text);

		for(new i = 1, j = 10; i < j; i++) {
			if(g_Report[i][r_Used] == true) {
	            Format:text("  %i: %s was reported by %s", (i+1), g_Report[i][r_Name], g_Report[i][r_Reason]);
	            SendClientMessage(playerid, acolor, text);
			}
		}
	}
	return 1;
}

CMD:kick(playerid, params[]) {
	if(IsAuthorizedLevel(playerid, 1)) {
		new id;
		if(sscanf(params, "us[80]", id, params)) {
			return SendClientMessage(playerid, grey, "Usage: /kick <playerid/name> <reason>");
		}

		if(strlen(params) > MAX_REASON) {
			return SendClientMessage(playerid, red, "Reason length exceeds the maximum characters limit. Limit: 35 chars");
		}

		if(IsValidTargetPlayer(playerid, id)) {
		    if(g_Player[id][p_Level] > g_Player[playerid][p_Level]) {
		    	return SendClientMessage(playerid, red, "You cannot use this command on specified player.");
			}
			
			SendClientMessageToAll(red, sprintf("Administrator %s has kicked player %s from the server. | Reason: %s |", g_Player[playerid][p_Name], g_Player[id][p_Name], params));
			SendClientMessage(playerid, acolor, sprintf("You have kicked %s from the server. | Reason: %s |", g_Player[id][p_Name], params));
			KickEx(id, red, sprintf("You have been kicked by admin %s. | Reason: %s |", g_Player[playerid][p_Name], params));
			admin_CommandMessage(playerid, "kick", id);
		}
	}
	return 1;
}

CMD:spec(playerid,params[]) {
    if(IsAuthorizedLevel(playerid, 1)) {
        if (g_Player[playerid][p_DM_ID] != 0) {
            return SendClientMessage(playerid, red, "You cannot use this command inside DM arena.");
		}
		
		new id;
	    if(sscanf(params, "u", id)) {
			return SendClientMessage(playerid, grey, "Usage: /spec <playerid/name>");
		}

		if(IsValidTargetPlayer(playerid, id)) {
			if(GetPlayerState(id) == PLAYER_STATE_SPECTATING && g_Player[playerid][p_SpecType] != SPEC_TYPE_NONE) {
				return SendClientMessage(playerid, red, "Specified player is currently on spectate mode.");
			}

	  		if(!g_Player[id][p_Spawned]) {
			  	return SendClientMessage(playerid, red, "Specified player is not spawned.");
			}

	  		if(id == playerid) {
			  	return SendClientMessage(playerid, red, "You cannot spec yourself.");
			}

			if(g_Reporter[id] != INVALID_PLAYER_ID) {
			 	SendClientMessage(g_Reporter[id], yellow, "An admin is checking your report.");
			 	g_Reporter[id] = INVALID_PLAYER_ID;
			}

			if(GetPlayerState(playerid) != PLAYER_STATE_SPECTATING) {
				GetPlayerPos(playerid, g_PrevX[playerid], g_PrevY[playerid], g_PrevZ[playerid]);
				GetPlayerFacingAngle(playerid, g_PrevA[playerid]);
			}
			admin_StartSpec(playerid, id);
			GameTextForPlayer(playerid, "~n~~n~~n~~n~~w~now spectating", 3000, 3);
			admin_SendMessage(acolor, sprintf("Admin %s used /spec on id %d.", g_Player[playerid][p_Name], id));
			SendClientMessage(playerid, acolor, sprintf("You are spectating %s.", g_Player[id][p_Name]));
		}
	}
	return 1;
}

CMD:specoff(playerid,params[]) {
    if(IsAuthorizedLevel(playerid, 1)) {
		if(g_Player[playerid][p_SpecType] == SPEC_TYPE_NONE) {
			return SendClientMessage(playerid, red, "You are not spectating.");
		}

		admin_StopSpec(playerid);
		SendClientMessage(playerid, acolor, "You are no longer spectating.");
	    admin_CommandMessage(playerid, "specoff");
	}
	return 1;
}

CMD:warn(playerid, params[]) {
	if(IsAuthorizedLevel(playerid, 1)) {
	    new id;
	    if(sscanf(params, "us[50]", id, params)) {
	        return SendClientMessage(playerid, grey, "Usage: /warn <playerid/name> <reason>");
		}

		if(IsValidTargetPlayer(playerid, id)) {
	      	if(strlen(params) > MAX_REASON) {
				return SendClientMessage(playerid, red, "Reason length exceeds the maximum characters limit. Limit: 35 chars");
			}

			if(g_Player[id][p_Level] > g_Player[playerid][p_Level]) {
		    	return SendClientMessage(playerid, red, "You cannot use this command on specified player.");
			}

			SetPVarInt(id, "WARN", GetPVarInt(id, "WARN") + 1);

			new d_string[800];
			strcat(d_string, "{C82B0F}You have received a warning from admin {C0C0C0}%s\n\n");
			strcat(d_string, "{C82B0F}Reason: {C0C0C0}%s\n{C82B0F}Warns: {C0C0C0}%i/5\n\n");
			strcat(d_string, ""#COL_DIALOG"Please avoid such incident in the future and follow all the server rules.\n");
			strcat(d_string, "Further warnings may lead you to a punishment.");

			Format:d_string(d_string, g_Player[playerid][p_Name], params, GetPVarInt(id, "WARN"));
			ShowPlayerDialog(id, D_MSG, DIALOG_STYLE_MSGBOX, "WARNING", d_string, "Close", "");

			SendClientMessageToAll(0xFF8040FF, sprintf("Administrator %s has warned player %s. (W: %i/5)", g_Player[playerid][p_Name], g_Player[id][p_Name], GetPVarInt(id, "WARN")));
			SendClientMessageToAll(0xFF8040FF, sprintf("Reason: %s", params));
			SendClientMessage(playerid, acolor, sprintf("You have warned %s. | Reason: %s |", g_Player[id][p_Name], params));

			if(GetPVarInt(id, "WARN") == 5) {
				SendClientMessageToAll(red, sprintf("Administrator %s has kicked player %s. (W: 5/5)", g_Player[id][p_Name]));
				SendClientMessageToAll(red, sprintf("Reason: %s", params));
				KickEx(id, red, "You have been kicked for exceeding admin warns!");
			}
		}
	}
	return 1;
}

CMD:async(playerid, params[]) {
	if(IsAuthorizedLevel(playerid, 1)) {
		new id;
		if (sscanf(params, "u", id)) {
			return SendClientMessage(playerid, grey, "Usage: /async <playerid/name>");
		}

		if (g_Player[id][p_Protected] != 0) {
			return SendClientMessage(playerid, red, "Please wait...");
		}

		if(GetPVarInt(id, "DUTY") == 1) {
		    return SendClientMessage(playerid, red, "Specified player cannot be synchronized.");
		}

		if (IsValidTargetPlayer(playerid, id)) {
			if (g_Player[id][p_Spawned] == 0) {
				return SendClientMessage(playerid, red, "Specified player is not spawned.");
			}

			SendClientMessage(id, acolor2, sprintf("Admin %s has synchronized you.", g_Player[playerid][p_Name]));
			SendClientMessage(playerid, acolor, sprintf("You have synchronized %s.", g_Player[id][p_Name]));
			admin_CommandMessage(playerid, "async", id);
			Synchronize(id);
		}
	}
	return 1;
}

CMD:aduty(playerid, params[]) {
	if(IsAuthorizedLevel(playerid, 1)) {
	    if (g_Player[playerid][p_DM_ID] != 0) {
            return SendClientMessage(playerid, red, "You cannot use this command inside DM arena.");
		}
		
		if (g_Player[playerid][p_Protected] != 0) {
			return SendClientMessage(playerid, red, "Please wait...");
		}
		
		if(g_Player[playerid][p_Jailed] != 0) {
		    return SendClientMessage(playerid, red, "You cannot go on duty while in jail.");
		}

		admin_CommandMessage(playerid, "aduty");
		admin_ToggleDuty(playerid, (GetPVarInt(playerid, "DUTY") == 1) ? 0 : 1);
	}
	return 1;
}

CMD:cc(playerid, params[]) {
	if(IsAuthorizedLevel(playerid, 1)) {
	    for (new i = 0, j = 50; i < j; ++i) {
			SendClientMessageToAll(-1, " ");
		}
		
		admin_CommandMessage(playerid, "cc");
	}
	return 1;
}

CMD:jail(playerid, params[]) {
	if(IsAuthorizedLevel(playerid, 1)) {
		new id, time;
		if(sscanf(params, "uis[80]", id, time, params)) {
			return SendClientMessage(playerid, grey, "Usage: /jail <playerid/name> <minutes> <reason>");
		}

		if(time > 10) {
		    return SendClientMessage(playerid, red, "You cannot jail for more than 10 minutes.");
		}

		if(strlen(params) > MAX_REASON) {
			return SendClientMessage(playerid, red, "Reason length exceeds the maximum characters limit. Limit: 35 chars");
		}

		if(IsValidTargetPlayer(playerid, id)) {
		    if (g_Player[playerid][p_DM_ID] != 0) {
	            return SendClientMessage(playerid, red, "Specified player is in DM arena.");
			}
		
		    if(!g_Player[id][p_Spawned]) {
		        return SendClientMessage(playerid, red, "Specified player is not spawned.");
			}
			
			if(g_Player[id][p_Level] > g_Player[playerid][p_Level]) {
		    	return SendClientMessage(playerid, red, "You cannot use this command on specified player.");
			}

			if(g_Player[id][p_Jailed] != 0) {
				return SendClientMessage(playerid, red, "Specified player is already in jail.");
			}

		    new stamp = (time * 60);
			JailPlayer(id, stamp);
			SendClientMessageToAll(red, sprintf("Administrator %s has jailed player %s for %i minute(s).", g_Player[playerid][p_Name], g_Player[id][p_Name], time));
			SendClientMessageToAll(red, sprintf("Reason: %s", params));
			SendClientMessage(playerid, acolor, sprintf("You have jailed %s for %i minute(s). | Reason: %s |", g_Player[id][p_Name], time, params));
			SendClientMessage(id, red, sprintf("You have been jailed by admin %s for %i minute(s). | Reason: %s |", g_Player[playerid][p_Name], time, params));
			admin_CommandMessage(playerid, "jail", id, time);

			new query[100];
			Query("UPDATE `users` SET `jail_time`='%i' WHERE `id`='%i'", g_Player[id][p_Jailed], g_Player[id][p_UserID]);
			mysql_tquery(mysql, query, "ExecuteQuery", "i", res_none);
			return 1;
		}
	}
	return 1;
}

CMD:unjail(playerid, params[]) {
	if(IsAuthorizedLevel(playerid, 1)) {
		new id;
		if(sscanf(params, "u", id)) {
			return SendClientMessage(playerid, grey, "Usage: /unjail <playerid/name>");
		}

		if(strlen(params) > MAX_REASON) {
			return SendClientMessage(playerid, red, "Reason length exceeds the maximum characters limit. Limit: 35 chars");
		}

		if(IsValidTargetPlayer(playerid, id)) {
		    if(!g_Player[id][p_Spawned]) {
				return SendClientMessage(playerid, red, "Specified player is not spawned.");
			}

			if(!g_Player[id][p_Jailed]) {
				return SendClientMessage(playerid, red, "Specified player is not in jail.");
			}

			SendClientMessageToAll(admin_action, sprintf("Administrator %s has un-jailed player %s.", g_Player[playerid][p_Name], g_Player[id][p_Name]));
			SendClientMessage(playerid, acolor, sprintf("You have un-jailed %s.", g_Player[id][p_Name]));
            g_Player[id][p_Jailed] = 0;
			admin_CommandMessage(playerid, "unjail", id);

			new query[100];
			Query("UPDATE `users` SET `jail_time`='0' WHERE `id`='%i'", g_Player[id][p_Jailed], g_Player[id][p_UserID]);
			mysql_tquery(mysql, query, "ExecuteQuery", "i", res_none);
			return 1;
		}
	}
	return 1;
}

CMD:mute(playerid, params[]) {
	if(IsAuthorizedLevel(playerid, 1)) {
		new id, time;
		if (sscanf(params, "uds[80]", id, time, params)) {
			return SendClientMessage(playerid, grey, "Usage: /mute <playerid/name> <minutes> <reason>");
		}

		if(time > 15) {
		    return SendClientMessage(playerid, red, "You cannot mute for more than 10 minutes.");
		}

		if(strlen(params) > MAX_REASON) {
			return SendClientMessage(playerid, red, "Reason length exceeds the maximum characters limit. Limit: 35 chars");
		}

		if (IsValidTargetPlayer(playerid, id)) {
		    if(g_Player[id][p_Level] > g_Player[playerid][p_Level]) {
		    	return SendClientMessage(playerid, red, "You cannot use this command on specified player.");
			}
		
			if (g_Player[id][p_Muted] != 0) {
				return SendClientMessage(playerid, red, "Specified player is already muted.");
			}

			admin_CommandMessage(playerid, "mute", id, time);
			SendClientMessageToAll(red, sprintf("Administrator %s has muted player %s for %d minute(s).", g_Player[playerid][p_Name], g_Player[id][p_Name], time));
			SendClientMessageToAll(red, sprintf("Reason: %s", params));
			SendClientMessage(id, red, sprintf("You have been muted by admin %s for %d minute(s). | Reason: %s |", g_Player[playerid][p_Name], time, params));
			SendClientMessage(playerid, acolor, sprintf("You have muted %s for %d minutes. | Reason: %s |", g_Player[id][p_Name], time, params));
			g_Player[id][p_Muted] = gettime() + (time * 60);

			new query[100];
			Query("UPDATE `users` SET `mute_time`='%i' WHERE `id`='%i'", g_Player[id][p_UserID]);
			mysql_tquery(mysql, query, "ExecuteQuery", "i", res_none);
		}
	}
	return 1;
}

CMD:unmute(playerid, params[]) {
	if(IsAuthorizedLevel(playerid, 1)) {
		new id;
		if (sscanf(params, "u", id)) {
			return SendClientMessage(playerid, grey, "Usage: /unmute <playerid/name>");
		}

		if (IsValidTargetPlayer(playerid, id)) {
			if (!g_Player[id][p_Muted]) {
				return SendClientMessage(playerid, red, "Specified player is not muted.");
			}

			admin_CommandMessage(playerid, "unmute", id);
			SendClientMessageToAll(admin_action, sprintf("Administrator %s has un-muted player %s.", g_Player[playerid][p_Name], g_Player[id][p_Name]));
			SendClientMessage(playerid, acolor, sprintf("You have un-muted %s.", g_Player[id][p_Name]));
			SendClientMessage(playerid, acolor2, sprintf("You have been un-muted by admin %s.", g_Player[playerid][p_Name]));
            UnmutePlayer(id);
		}
	}
	return 1;
}

CMD:freeze(playerid, params[]) {
	if(IsAuthorizedLevel(playerid, 1)) {
		new id;
		if (sscanf(params, "us[80]", id, params)) {
			return SendClientMessage(playerid, grey, "Usage: /freeze <playerid/name> <reason>");
		}

		if (IsValidTargetPlayer(playerid, id)) {
		    if(g_Player[id][p_Level] > g_Player[playerid][p_Level]) {
		    	return SendClientMessage(playerid, red, "You cannot use this command on specified player.");
			}
		
			if (g_Player[id][p_Frozen] == 1) {
				return SendClientMessage(playerid, red, "Specified player is already frozen.");
			}

			g_Player[id][p_Frozen] = 1;
			TogglePlayerControllable(id, 0);

			admin_CommandMessage(playerid, "freeze", id);
			SendClientMessageToAll(red, sprintf("Administrator %s has frozen player %s. | Reason: %s |", g_Player[playerid][p_Name], g_Player[id][p_Name], params));
			SendClientMessage(playerid, acolor, sprintf("You have frozen %s. | Reason: %s |", g_Player[id][p_Name], params));
			SendClientMessage(id, red, sprintf("You have been frozen by admin %s. | Reason: %s |", g_Player[playerid][p_Name], params));
		}
	}
	return 1;
}

CMD:unfreeze(playerid, params[]) {
	if(IsAuthorizedLevel(playerid, 1)) {
		new id;
		if (sscanf(params, "u", id)) {
			return SendClientMessage(playerid, grey, "Usage: /unfreeze <playerid/name>");
		}

		if (IsValidTargetPlayer(playerid, id)) {
			if(g_Player[id][p_Frozen] == 1) {
				g_Player[id][p_Frozen] = 0;
			}
			
            TogglePlayerControllable(id, 1);
            
			admin_CommandMessage(playerid, "unmute", id);
			SendClientMessageToAll(admin_action, sprintf("Administrator %s has un-frozen player %s.", g_Player[playerid][p_Name], g_Player[id][p_Name]));
			SendClientMessage(playerid, acolor, sprintf("You have un-frozen %s.", g_Player[id][p_Name]));
			SendClientMessage(id, acolor2, sprintf("You have been un-frozen by admin %s.", g_Player[playerid][p_Name]));
		}
	}
	return 1;
}

CMD:goto(playerid, params[]) {
	if(IsAuthorizedLevel(playerid, 1)) {
	    if (g_Player[playerid][p_DM_ID] != 0) {
            return SendClientMessage(playerid, red, "You cannot use this command inside DM arena.");
		}
		
	    if (GetPVarInt(playerid, "DUTY") == 0 && g_Player[playerid][p_Level] < 4) {
			return SendClientMessage(playerid, red, "You need to be on admin duty to use this command.");
		}
		
		if(g_Player[playerid][p_Jailed] != 0) {
			return SendClientMessage(playerid, red, "You cannot use this command inside jail.");
		}

		new id;
		if (sscanf(params, "u", id)) {
			return SendClientMessage(playerid, grey, "Usage: /goto <playerid/name>");
		}

	 	if (IsValidTargetPlayer(playerid, id)) {
			if (id == playerid) {
				return SendClientMessage(playerid, red, "You cannot use this command on yourself.");
			}

			if (!g_Player[id][p_Spawned]) {
				return SendClientMessage(playerid, red, "Specified player is not spawned.");
			}

			new int, world, Float:x, Float:y, Float:z;
			GetPlayerPos(id, x, y, z);
			int = GetPlayerInterior(id);
			world = GetPlayerVirtualWorld(id);

			SetPlayerVirtualWorld(playerid, world);
			SetPlayerInterior(playerid, int);
			SetPlayerPos(playerid, x, y + 3.0, z);

			SendClientMessage(playerid, acolor, sprintf("You have been teleported to %s.",g_Player[id][p_Name]));
			admin_CommandMessage(playerid, "goto", id);
		}
	}
	return 1;
}

CMD:slap(playerid, params[]) {
	if(IsAuthorizedLevel(playerid, 1)) {
		new id;
		if (sscanf(params, "u", id)) {
			return SendClientMessage(playerid, grey, "Usage: /slap <playerid/name>");
		}

	 	if (IsValidTargetPlayer(playerid, id)) {
			if(g_Player[playerid][p_Jailed] != 0) {
				return SendClientMessage(playerid, red, "Specified player is currently in jail.");
			}
			
			if(g_Player[playerid][p_Frozen] == 1) {
				return SendClientMessage(playerid, red, "Specified player is currently frozen.");
			}

			if (!g_Player[id][p_Spawned]) {
				return SendClientMessage(playerid, red, "Specified player is not spawned.");
			}

			SlapPlayer(id, 5.0);

			SendClientMessage(playerid, acolor, sprintf("You have slapped %s.",g_Player[id][p_Name]));
			admin_CommandMessage(playerid, "slap", id);
		}
	}
	return 1;
}

CMD:get(playerid, params[]) {
	if(IsAuthorizedLevel(playerid, 3)) {
	    if (g_Player[playerid][p_DM_ID] != 0) {
            return SendClientMessage(playerid, red, "You cannot use this command inside DM arena.");
		}
		
		new id;
		if (sscanf(params, "u", id)) {
			return SendClientMessage(playerid, grey, "Usage: /get <playerid/name>");
		}

		if (IsValidTargetPlayer(playerid, id)) {
		    if (g_Player[id][p_DM_ID] != 0) {
	            return SendClientMessage(playerid, red, "Specified player is in DM arena.");
			}
			
			if (id == playerid) {
				return SendClientMessage(playerid, red, "You cannot use this command on yourself.");
			}

			if (!g_Player[id][p_Spawned]) {
				return SendClientMessage(playerid, red, "Specified player is not spawned.");
			}

			new Float:x, Float:y, Float:z, int, world;
			GetPlayerPos(playerid, x, y, z);
			int = GetPlayerInterior(playerid);
			world = GetPlayerVirtualWorld(playerid);

			SetPlayerVirtualWorld(id, world);
			SetPlayerInterior(id, int);
			SetPlayerPos(id, x, y + 3.0, z);

			SendClientMessage(playerid, acolor, sprintf("You have teleported player %s at your location.", g_Player[id][p_Name]));
			SendClientMessage(id, acolor2, sprintf("You have been teleported to admin %s's location.", g_Player[playerid][p_Name]));
			admin_CommandMessage(playerid, "get", id);
		}
	}
	return 1;
}

CMD:weaps(playerid, params[]) {
	if(IsAuthorizedLevel(playerid, 1)) {
		new id;
		if(sscanf(params, "u", id)) {
		    return SendClientMessage(playerid, grey, "Usage: /weaps [playerid/name]");
		}
		
		if(IsValidTargetPlayer(playerid, id)) {
		    if(!g_Player[id][p_Spawned]) {
		        return SendClientMessage(playerid, red, "Specified player is not spawned.");
			}
			
			SendClientMessage(playerid, acolor, sprintf("Showing %s's weapons", g_Player[id][p_Name]));
			admin_CommandMessage(playerid, "weaps", id);
			
			new str[128], weaponid, ammo, slot, i;
			for(slot = 0; slot < MAX_WEAPON_SLOT; ++slot) {
			    GetPlayerWeaponData(id, slot, weaponid, ammo);
			    
			    if(weaponid != 0) {
			        i++;
	                if (strlen(str) + strlen(aWeaponNames[weaponid]) + 10 > 128) {
					    SendClientMessage(playerid, acolor, str);
					    str[0] = '\0';
					}

					if (str[0] == '\0') {
						Format:str("%s[%i]", aWeaponNames[weaponid], ammo);
					}
			 	    else
					 	Format:str("%s, %s[%i]", str, aWeaponNames[weaponid], ammo);
				}
			}
			if(str[0] != '\0') {
				SendClientMessage(playerid, acolor, str);
			}
			
			if(!i) {
				SendClientMessage(playerid, red, "None");
			}
		}
	}
	return 1;
}

CMD:rsv(playerid, params[]) {
	if(IsAuthorizedLevel(playerid, 1)) {
	    new vid;
		if(sscanf(params, "i", vid)) {
		    return SendClientMessage(playerid, grey, "Usage: /rsv <vehicleid>");
		}
		
		if(IsValidVehicle(vid)) {
		    return SendClientMessage(playerid, red, "Invalid vehicleid.");
		}
		
		SetVehicleToRespawn(vid);
		SendClientMessage(playerid, acolor, sprintf("Specified vehicle has been respawned. (%d)", vid));
		admin_CommandMessage(playerid, "rsv", vid);
	}
	return 1;
}

CMD:rsvall(playerid, params[]) {
	if(IsAuthorizedLevel(playerid, 1)) {
        for(new i, j = MAX_VEHICLES; i < j; i++) {
            if(g_Vehicle[i][v_BombingPlane] == false) {
				if(!vehicle_IsOccupied(i) && IsValidVehicle(i)) {
					SetVehicleToRespawn(i);
				}
			}
		}

		SendClientMessage(playerid, admin_action, sprintf("Admin %s has respawned all unused vehicles.", g_Player[playerid][p_Name]));
		admin_CommandMessage(playerid, "rsvall");
	}
	return 1;
}

CMD:clearbox(playerid, params[]) {
	if(IsAuthorizedLevel(playerid, 1)) {
	    for (new i = 0; i < 6; i++) {
			News(" ");
		}
	}
	admin_CommandMessage(playerid, "cbox");
	return 1;
}

/*******************************************************************************
								Level 2 commands
*******************************************************************************/
CMD:apm(playerid, params[]) {
	if(IsAuthorizedLevel(playerid, 2)) {
		new id;
	 	if(sscanf(params, "us[128]", id, params)) {
		 	return SendClientMessage(playerid, grey, "Usage: /apm <playerid/name> <message>");
		}

		if(IsValidTargetPlayer(playerid, id)) {
			SendClientMessage(id, red, sprintf("- PM from Admin: {%06x}%s", (-1 >>> 8), params));
			SendClientMessage(playerid, acolor, sprintf("A.PM > %s: {%06x}%s", g_Player[id][p_Name], (-1 >>> 8), params));
			admin_SendMessage(grey, sprintf("[A.PM] %s > %s: %s", g_Player[playerid][p_Name], g_Player[id][p_Name], params));
		}
	}
	return 1;
}

CMD:disarm(playerid, params[]) {
	if(IsAuthorizedLevel(playerid, 2)) {
		new id;
		if(sscanf(params, "u", id)) {
			return SendClientMessage(playerid, grey, "Usage: /disarm <playerid/name>");
		}

		if(IsValidTargetPlayer(playerid, id)) {
			if(g_Player[id][p_Level] > g_Player[playerid][p_Level] || GetPVarInt(id, "DUTY") == 1) {
		    	return SendClientMessage(playerid, red, "You cannot use this command on specified player.");
			}
			
			if(g_Player[id][p_Spawned] == 0) {
				return SendClientMessage(playerid, red, "Specified player is not spawned.");
			}

			ResetPlayerWeapons(id);
			SendClientMessage(playerid, acolor, sprintf("You have disarmed %s.", g_Player[id][p_Name]));
			SendClientMessage(id, acolor2, sprintf("Admin %s has disarmed you.", g_Player[playerid][p_Name]));

			admin_CommandMessage(playerid, "disarm", id);
		}
	}
	return 1;
}

CMD:lockveh(playerid, params[]) {
	if(IsAuthorizedLevel(playerid, 2)) {
		if(!IsPlayerInAnyVehicle(playerid)) {
			return SendClientMessage(playerid, red, "You need to be inside a vehicle to use this command.");
		}

		foreach(new i : Player) {
			if(i != playerid) {
				SetVehicleParamsForPlayer(GetPlayerVehicleID(playerid), i, 0, 1);
			}
		}
		SendClientMessage(playerid, acolor, "You have locked the vehicle's door.");
		admin_CommandMessage(playerid, "lockveh");
	}
	return 1;
}

CMD:unlockveh(playerid, params[]) {
	if(IsAuthorizedLevel(playerid, 2)) {
		if(!IsPlayerInAnyVehicle(playerid)) {
			return SendClientMessage(playerid, red, "You need to be inside a vehicle to use this command.");
		}

		foreach(new i : Player) {
			if(i != playerid) {
				SetVehicleParamsForPlayer(GetPlayerVehicleID(playerid), i, 0, 0);
			}
		}
		SendClientMessage(playerid, acolor, "You have unlocked the vehicle's door.");
		admin_CommandMessage(playerid, "unlockveh");
	}
	return 1;
}

CMD:getveh(playerid, params[]) {
	if(IsAuthorizedLevel(playerid, 2)) {
	    if(g_Player[playerid][p_Jailed] != 0) {
			return SendClientMessage(playerid, red, "You cannot use this command inside jail.");
		}
		
		new vehicleid;
		if(sscanf(params, "i", vehicleid)) {
			return SendClientMessage(playerid, grey, "/getveh <vehicleid>");
		}
		
		if(vehicleid > MAX_VEHICLES || !IsValidVehicle(vehicleid)) {
			return SendClientMessage(playerid, red, "Invalid vehicle ID.");
		}

		admin_CommandMessage(playerid, "getveh", vehicleid);

		new Float:x, Float:y, Float:z, vw;
		GetPlayerPos(playerid, x, y, z);
		vw = GetPlayerVirtualWorld(playerid);
		SetVehiclePos(vehicleid, x, y, z);
		SetVehicleVirtualWorld(vehicleid, vw);
		PutPlayerInVehicle(playerid, vehicleid, 0);
	 	SendClientMessage(playerid, acolor, sprintf("Vehicle has been teleported. (%d)", vehicleid));
	}
	return 1;
}


CMD:gotoveh(playerid, params[]) {
	if(IsAuthorizedLevel(playerid, 2)) {
	    if (g_Player[playerid][p_DM_ID] != 0) {
            return SendClientMessage(playerid, red, "You cannot use this command inside DM arena.");
		}
		
		new vehicleid;
		if(sscanf(params, "i", vehicleid)) {
			return SendClientMessage(playerid, grey, "Usage: /gotoveh <vehicleid>");
		}
		
		if(GetPVarInt(playerid, "DUTY") == 0 && g_Player[playerid][p_Level] < 6) {
		    return SendClientMessage(playerid, red, "You need to be on admin duty to use this command.");
		}
		
		if(g_Player[playerid][p_Jailed] != 0) {
		    return SendClientMessage(playerid, red, "You cannot use this command inside jail.");
		}

		if(!IsValidVehicle(vehicleid)) {
			return SendClientMessage(playerid, red, "Invalid vehicleid.");
		}

		new Float:x, Float:y, Float:z, Float:a, vw;
		GetVehiclePos(vehicleid, x, y, z);
		GetVehicleZAngle(vehicleid, a);
		vw = GetVehicleVirtualWorld(vehicleid);

		SetPlayerPos(playerid, x, y, z + 2.0);
		SetPlayerFacingAngle(playerid, a);
		SetPlayerVirtualWorld(playerid, vw);
		SetCameraBehindPlayer(playerid);

		SendClientMessage(playerid, acolor, sprintf("You have been teleported to the selected vehicle. (%d)", vehicleid));
		admin_CommandMessage(playerid, "gotoveh", vehicleid);
	}
	return 1;
}

CMD:explode(playerid, params[]) {
	if(IsAuthorizedLevel(playerid, 2)) {
		new id;
		if(sscanf(params, "u", id)) {
			return SendClientMessage(playerid, grey, "/explode <playerid/name>");
		}
		
		if(IsValidTargetPlayer(playerid, id)) {
			if(!g_Player[id][p_Spawned]) {
				return SendClientMessage(playerid, red, "Specified player is not spawned.");
			}

			if(g_Player[id][p_Frozen] == 1) {
				return  SendClientMessage(playerid, red, "Specified player is currently frozen.");
			}
			
			admin_CommandMessage(playerid, "explode", id);

			new Float:x, Float:y, Float:z;
			GetPlayerPos(id, x, y, z);
			CreateExplosion(x, y, z, 4, 2.0);
		 	SendClientMessage(playerid, acolor, sprintf("You exploded %s.", g_Player[id][p_Name]));
		}
	}
	return 1;
}

CMD:getip(playerid, params[]) {
	if(IsAuthorizedLevel(playerid, 2)) {
		new id;
	 	if(sscanf(params, "u", id)) {
		 	return SendClientMessage(playerid, grey, "/getip <playerid/name>");
		}
		
		if(IsValidTargetPlayer(playerid, id)) {
			admin_CommandMessage(playerid, "getip", id);
			SendClientMessage(playerid, acolor, sprintf(" %s's IP: %s", g_Player[id][p_Name], g_Player[id][p_Ip]));
		}
	}
	return 1;
}

/*******************************************************************************
								Level 3 commands
*******************************************************************************/
CMD:searchban(playerid, params[]) {
    if(IsAuthorizedLevel(playerid, 3)) {
        if(sscanf(params, "s[24]", params)) {
            return SendClientMessage(playerid, grey, "Usage: /bancheck <username/ip>");
		}

		new query[300];
		Query("SELECT * FROM `bans` WHERE `nick` LIKE '##%e##' OR `ip` LIKE '##%s##' ORDER BY `id` DESC LIMIT 5", params, params);
		mysql_tquery(mysql, ret_strreplace(query, "##", "%"), "result_CheckBan", "is", playerid, params);
    }
    return 1;
}

CMD:ban(playerid, params[]) {
	if(IsAuthorizedLevel(playerid, 3)) {
		new id;
		if(sscanf(params, "us[128]", id, params)) {
			return SendClientMessage(playerid, grey, "Usage: /ban <playerid/name> <reason>");
		}
		
		if(g_Player[id][p_Level] > g_Player[playerid][p_Level]) {
	    	return SendClientMessage(playerid, red, "You cannot use this command on specified player.");
		}

		if(strlen(params) > MAX_REASON) {
			return SendClientMessage(playerid, red, "Reason length exceeds the maximum characters limit. Limit: 35 chars");
		}

		if(IsValidTargetPlayer(playerid, id)) {
	 		BanPlayer(id, "Permanent", params, g_Player[playerid][p_Name]);
			SendClientMessage(playerid, acolor, sprintf("You have banned %s. | Reason: %s |", g_Player[id][p_Name], params));
			admin_CommandMessage(playerid, "ban", id);
		}
	}
	return 1;
}

CMD:getfps(playerid, params[]) {
	if (IsAuthorizedLevel(playerid, 3)) {
	    new id;

		if (sscanf(params, "u", id)) {
		    return SendClientMessage(playerid, grey, "Usage: /getfps <playerid/name>");
		}
		
		if (IsValidTargetPlayer(playerid, id)) {
			SendClientMessage(playerid, acolor, sprintf("%s's current FPS: %i", g_Player[id][p_Name], g_Player[id][p_FPS]));
			admin_CommandMessage(playerid, "/getfps", id);
		}
	}
	return 1;
}

CMD:getpl(playerid, params[]) {
	if (IsAuthorizedLevel(playerid, 3)) {
	    new id;
	    
	    if (sscanf(params, "u", id)) {
	        return SendClientMessage(playerid, grey, "Usage: /getpl <playerid/name>");
		}

		if (IsValidTargetPlayer(playerid, id)) {
			SendClientMessage(playerid, acolor, sprintf("%s's current packet loss: %0.2f", g_Player[id][p_Name], NetStats_PacketLossPercent(id)));
            admin_CommandMessage(playerid, "/getpl", id);
		}
	}
	return 1;
}

CMD:tban(playerid, params[]) {
    if(IsAuthorizedLevel(playerid, 3)) {
		new id, hours, minutes;
		if(sscanf(params, "uiis[128]", id, hours, minutes, params)) {
			return SendClientMessage(playerid, grey, "Usage: /tban <playerid/name> <hours> <minutes> <reason>");
		}
		
		if(g_Player[id][p_Level] > g_Player[playerid][p_Level]) {
	    	return SendClientMessage(playerid, red, "You cannot use this command on specified player.");
		}

		if(strlen(params) > MAX_REASON) {
			return SendClientMessage(playerid, red, "Reason length exceeds the maximum characters limit. Limit: 35 chars");
		}

		if(IsValidTargetPlayer(playerid, id)) {
			SendClientMessageToAll(red, sprintf("Administrator %s has temporarily banned %s. [Time: %iH, %iM]", g_Player[playerid][p_Name], g_Player[id][p_Name], hours, minutes));
			SendClientMessageToAll(red, sprintf("Reason: %s", params));
			SendClientMessage(playerid, acolor, sprintf("You have temporarily banned %s. | Reason: %s |", g_Player[id][p_Name], params));

			new stamp = (hours * 3600) + (minutes * 60) + gettime(), query[200];
			Query("INSERT INTO `bans` (id,nick,bannedby,date,ip,type,time,reason) VALUES ('%i','%e','%e',UTC_TIMESTAMP(),'%e','%e','%i','%e')", g_Player[id][p_UserID], g_Player[id][p_Name], g_Player[playerid][p_Name], g_Player[id][p_Ip], "Temporary", stamp, params);
		    mysql_tquery(mysql, query, "ExecuteQuery", "i", res_none);

			KickEx(id, red, "You have been banned.");
			admin_CommandMessage(playerid, "tban", id);
		}
	}
	return 1;
}

CMD:healall(playerid, params[]) {
	if(IsAuthorizedLevel(playerid, 3)) {
	    if ((GetPVarInt(playerid, "DUTY") == 0) && (g_Player[playerid][p_Level] < 5)) {
			return SendClientMessage(playerid, red, "You need to be on admin duty to use this command.");
		}
		foreach(new i : Player) {
		    if (g_Player[i][p_Spawned]) {
				if (i != playerid) {
					SetPlayerHealth(i, 100.0);
				}
			}
		}
		SendClientMessageToAll(admin_action, sprintf("*** All the players have been healed by admin %s.", g_Player[playerid][p_Name]));
		admin_CommandMessage(playerid, "healall");
	}
	return 1;
}

CMD:armourall(playerid, params[]) {
	if(IsAuthorizedLevel(playerid, 3)) {
		if ((GetPVarInt(playerid, "DUTY") == 0) && (g_Player[playerid][p_Level] < 5)) {
			return SendClientMessage(playerid, red, "You need to be on admin duty to use this command.");
		}
		foreach(new i : Player) {
		    if (g_Player[i][p_Spawned]) {
				if (i != playerid) {
					SetPlayerArmour(i, 100.0);
				}
			}
		}
		SendClientMessageToAll(admin_action, sprintf("*** All the players have been armoured by admin %s.", g_Player[playerid][p_Name]));
		admin_CommandMessage(playerid, "armourall");
	}
	return 1;
}

CMD:skin(playerid, params[]) {
    if(IsAuthorizedLevel(playerid, 3)) {
		if (IsPlayerInAnyVehicle(playerid)) {
			return SendClientMessage(playerid, red, "Set your skin on foot to avoid glitch.");
		}

		new skin;
		if (sscanf(params, "i", skin)) {
			return SendClientMessage(playerid, grey, "Usage: /skin <skinid>");
		}
		
		if (skin < 0 || skin > 311) {
			return SendClientMessage(playerid, red, "Invalid skinid.");
		}

		switch (skin) {
			case 287, 285, 73, 206, 100, 200: {
				return SendClientMessage(playerid, red, "Invalid skinid.");
			}
		}

		SendClientMessage(playerid, acolor, sprintf("Skin changed. (%i)", skin));
		SetSkin(playerid, skin);
		g_Player[playerid][p_Skin] = skin;
		admin_CommandMessage(playerid, "skin", skin);
	}
	return 1;
}

CMD:setskin(playerid, params[]) {
	if(IsAuthorizedLevel(playerid, 3)) {
		new skin, id;
		if(sscanf(params, "ui", id, skin)) {
			return SendClientMessage(playerid, grey, "/setskin <playerid/name> <skinid>");
		}

		if(IsValidTargetPlayer(playerid, id)) {
			if(!g_Player[id][p_Spawned])
				return SendClientMessage(playerid, red, "Specified player is not spawned.");

			if(IsPlayerInAnyVehicle(id)) {
				return SendClientMessage(playerid, red, "Specified player is inside a vehicle.");
			}

			if(skin < 0 && skin > 311) {
				return SendClientMessage(playerid, red, "Invalid skin.");
			}

			admin_CommandMessage(playerid, "setskin", id, skin);
	   		SetSkin(id, skin);
			SendClientMessage(playerid, acolor, sprintf("You set %s's skin. (%i)", g_Player[id][p_Name], skin));
			SendClientMessage(id, acolor2, sprintf("Admin %s has set your skin. (%i)", g_Player[playerid][p_Name], skin));
		}
	}
	return 1;
}

CMD:v(playerid, params[]) {
	if(IsAuthorizedLevel(playerid, 3)) {
	    if (g_Player[playerid][p_DM_ID] != 0) {
            return SendClientMessage(playerid, red, "You cannot use this command inside DM arena.");
		}
		
		new name[30];
		if (sscanf(params, "s[30]", name)) {
			return SendClientMessage(playerid, grey, "Usage: /v <vehicle name>");
		}
		new int_id = GetPlayerInterior(playerid);
		new world_id = GetPlayerVirtualWorld(playerid);

		if (IsPlayerInAnyVehicle(playerid)) {
			return SendClientMessage(playerid, red, "You must be on foot to use this command.");
		}

		new modelid = vehicle_ReturnModelFromName(name);
		if(modelid < 400 || modelid > 611) {
			return SendClientMessage(playerid, red, "Invalid vehicle name.");
		}

		new Float:x, Float:y, Float:z, Float:a, vehicleid;
		GetPlayerPos(playerid, x, y, z);
		GetPlayerFacingAngle(playerid, a);
		PutPlayerInVehicle(playerid, CreateVehicle(modelid, x, y, z, a, 1, 0, 600), 0);
		vehicleid = GetPlayerVehicleID(playerid);

		new engine, lights, alarm, doors, bonnet, boot, objective;
		GetVehicleParamsEx(vehicleid,engine, lights, alarm, doors, bonnet, boot, objective);
	 	SetVehicleParamsEx(vehicleid, 1, 1, alarm, doors, bonnet, boot, objective);
		LinkVehicleToInterior(vehicleid, int_id);
		SetVehicleVirtualWorld(vehicleid, world_id);
			
		SendClientMessage(playerid, acolor, sprintf("Vehicle spawned. Name: %s | Model: %i | ID: %i", g_VehicleNames[GetVehicleModel(vehicleid) - 400], GetVehicleModel(vehicleid), vehicleid));
		admin_CommandMessage(playerid, "v");
	}
	return 1;
}

CMD:cleancars(playerid, params[]) {
	if (IsAuthorizedLevel(playerid, 3)) {
	    new count = 0;

		for (new i, j = MAX_VEHICLES; i < j; i++) {
		    if (!vehicle_IsOccupied(i) && IsValidVehicle(i)) {
		        if (g_Vehicle[i][v_Type]) continue;
				if (g_Vehicle[i][v_Static] != true) {
					if (g_Vehicle[i][v_BombingPlane] != true) {
				        DestroyVehicle(i);
				  		count++;

	                    new _x[E_VEHICLE_DATA];
				  		g_Vehicle[i] = _x;
				  		
				  		foreach(new x : Player) {
							if (g_Player[x][p_Vehicle] == i) {
                                g_Player[x][p_Vehicle] = 0;
					  		}
						}
					}
				}
			}
		}
		
		if (count) {
		    admin_CommandMessage(playerid, "cleancars");
			admin_SendMessage(acolor, sprintf("Admin %s has removed total of '%i' spawned vehicles.", g_Player[playerid][p_Name], count));
		}
		else {
		    SendClientMessage(playerid, red, "There are no vehicles spawned.");
		}
	}
	return 1;
}

CMD:giveveh(playerid, params[]) {
	if(IsAuthorizedLevel(playerid, 3)) {
		new name[30], id;
		if(sscanf(params, "us[30]", id, name)) {
			return SendClientMessage(playerid, grey, "/giveveh <playerid/name> <vehiclename>");
		}
		
		if(IsValidTargetPlayer(playerid, id)) {
		    if (g_Player[id][p_DM_ID] != 0) {
	            return SendClientMessage(playerid, red, "Specified player is in DM arena.");
			}
		
			if(!g_Player[id][p_Spawned]) {
				return SendClientMessage(playerid, red, "Specified player is not spawned.");
			}
			
			if(IsPlayerInAnyVehicle(id)) {
				return SendClientMessage(playerid, red, "Specified player is already driving a vehicle.");
			}
			
			if(g_Player[id][p_Jailed] != 0) {
			    return SendClientMessage(playerid, red, "Specified player is currently in jail.");
			}
			
			if(g_Player[id][p_Frozen] == 1) {
			    return SendClientMessage(playerid, red, "Specified player is currently frozen.");
			}
			
			new modelid = vehicle_ReturnModelFromName(name);
			if(modelid < 400 || modelid > 611)
				return SendClientMessage(playerid, red, "Invalid vehicle name.");

			new Float:x, Float:y, Float:z, Float:a;
			GetPlayerPos(id, x, y, z);
			GetPlayerFacingAngle(id, a);
			PutPlayerInVehicle(id, CreateVehicle(modelid,  x, y, z+2.0, a, 0, 0, 600), 0);

			new vehicleid = GetPlayerVehicleID(id);
	        
	        new engine, lights, alarm, doors, bonnet, boot, objective;
			GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
		 	SetVehicleParamsEx(vehicleid, 1, 1, alarm, doors, bonnet, boot, objective);
	 	
			LinkVehicleToInterior(vehicleid, GetPlayerInterior(id));
			SetVehicleVirtualWorld(vehicleid, GetPlayerVirtualWorld(id));
			SendClientMessage(playerid, acolor, sprintf("You have given a vehicle %s to player %s.", g_VehicleNames[GetVehicleModel(GetPlayerVehicleID(id)) - 400], g_Player[id][p_Name]));
			SendClientMessage(id, acolor2, sprintf("Admin %s has given you a vehicle. (%s)", g_Player[playerid][p_Name], g_VehicleNames[GetVehicleModel(GetPlayerVehicleID(id)) - 400]));
			admin_CommandMessage(playerid, "giveveh", id, vehicleid);
		}
	}
	return 1;
}

CMD:vcol(playerid, params[]) {
	if(IsAuthorizedLevel(playerid, 3)) {
		new c1, c2;
		if(sscanf(params, "ii", c1, c2)) {
			return SendClientMessage(playerid, grey, "/vcol <color1> <color2>");
		}
		
	    if(c1 > 255 || c2 > 255) {
			return SendClientMessage(playerid, red, "Invalid primary or secondary color.");
		}
		
		if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) {
			return SendClientMessage(playerid, red, "You are not driving a vehicle.");
		}
		
		new vehicleid = GetPlayerVehicleID(playerid);
		ChangeVehicleColor(vehicleid,  c1, c2);
		admin_CommandMessage(playerid, "vcol", c1, c2);
		SendClientMessage(playerid, acolor, sprintf("Vehicle color changed. Primary: %i, secondary: %i", c1, c2));
	}
	return 1;
}

CMD:fixall(playerid, params[]) {
	if(IsAuthorizedLevel(playerid, 3)) {
		admin_CommandMessage(playerid, "fixall");
		for(new i, j = MAX_VEHICLES; i < j; i++) {
		    if(IsValidVehicle(i)) {
				RepairVehicle(i);
			}
		}
		SendClientMessageToAll(admin_action, sprintf("Admin %s has fixed all the vehicles.",g_Player[playerid][p_Name]));
	}
	return 1;
}

CMD:fix(playerid, params[]) {
	if(IsAuthorizedLevel(playerid, 3)) {
		new id;
		if(sscanf(params, "u", id))
			id = playerid;
		else
			id = strval(params);
		if(IsValidTargetPlayer(playerid, id)) {
			if(id == playerid) {
				if(!IsPlayerInAnyVehicle(playerid)) {
					return SendClientMessage(playerid, red, "You must be inside a vehicle to use this command.");
				}
				
				admin_CommandMessage(playerid, "fix");
				RepairVehicle(GetPlayerVehicleID(playerid));
				SendClientMessage(playerid, acolor, "You have fixed your vehicle.");
				return SendClientMessage(playerid, grey, "* You can also use /fix <playerid/name> to repair other player's vehicle.");
			}
			else {
			    if(GetPlayerState(id) != PLAYER_STATE_DRIVER) {
					return SendClientMessage(playerid, red, "Specified player is not driving a vehicle.");
				}
				
				admin_CommandMessage(playerid, "fix", id);
				SendClientMessage(playerid, acolor, sprintf("You have fixed %s's vehicle.", g_Player[id][p_Name]));
		        SendClientMessage(id, acolor2, sprintf("Admin %s has fixed your vehicle.", g_Player[playerid][p_Name]));
		        RepairVehicle(GetPlayerVehicleID(id));
			}
		}
	}
	return 1;
}

CMD:delv(playerid,params[]) {
	if(IsAuthorizedLevel(playerid, 3)) {
		new vehicleid;
		if(sscanf(params, "d", vehicleid)) {
			return SendClientMessage(playerid, grey, "/delv <vehicleid>");
		}
		
		if(!IsValidVehicle(vehicleid)) {
			return SendClientMessage(playerid, red, "Invalid vehicleid.");
		}
		
		if(g_Vehicle[vehicleid][v_Static] == true || g_Vehicle[vehicleid][v_BombingPlane] == true) {
			return SendClientMessage(playerid, red, "You cannot delete this vehicle.");
		}
		
		admin_CommandMessage(playerid, "delv", vehicleid);
		DestroyVehicle(vehicleid);

		new _x[E_VEHICLE_DATA];
  		g_Vehicle[vehicleid] = _x;
		SendClientMessage(playerid, acolor, sprintf("Specified vehicle has been deleted. (%d)", vehicleid));
	}
	return 1;
}

CMD:ajp(playerid, params[]) {
	if(IsAuthorizedLevel(playerid, 3)) {
	    if (GetPVarInt(playerid, "DUTY") == 0) {
			return SendClientMessage(playerid, red, "You need to be on admin duty to use this command.");
		}

		SetPlayerSpecialAction(playerid, 2);
	    SendClientMessage(playerid, acolor, "You got a jetpack.");
    	admin_CommandMessage(playerid, "ajp");
	}
	return 1;
}

CMD:rsp(playerid,params[]) {
	if(IsAuthorizedLevel(playerid, 3)) {
		new id;
		if (sscanf(params, "u", id)) {
			return SendClientMessage(playerid, grey, "Usage: /rsp <playerid/name>");
		}

		if (IsValidTargetPlayer(playerid, id)) {
		    if (g_Player[id][p_DM_ID] != 0) {
	            return SendClientMessage(playerid, red, "Specified player is in DM arena.");
			}
		
		    if (g_Player[id][p_Protected] != 0) {
				return SendClientMessage(playerid, red, "Please wait...");
			}

			if(GetPVarInt(id, "DUTY") == 1) {
			    return SendClientMessage(playerid, red, "Specified player cannot be respawned.");
			}

			if (!g_Player[playerid][p_Spawned]) {
				return SendClientMessage(playerid, red, "Specified player is not spawned.");
			}

			SendClientMessage(playerid, acolor, sprintf("You have re-spawned %s.", g_Player[id][p_Name]));
			SendClientMessage(id, acolor2, sprintf("You have been re-spawned by admin %s.", g_Player[playerid][p_Name]));

			SetPVarInt(id, "CLASSSPAWN", 1);
			SpawnPlayer(id);
			admin_CommandMessage(playerid, "rsp", id);
		}
	}
	return 1;
}

/*******************************************************************************
								Level 4 commands
*******************************************************************************/
CMD:settime(playerid, params[] ) {
	if (IsAuthorizedLevel(playerid, 4)) {
	    new hour;
	    if (sscanf(params, "i", hour)) {
	        return SendClientMessage(playerid, grey, "Usage: /settime <hour 0-23>");
		}
		
		if (hour > 23) {
		    return SendClientMessage(playerid, red, "Invalid hour format. Max: 23H.");
		}
		
		admin_CommandMessage(playerid, "/settime", hour);
		SetWorldTime(hour);

		SendClientMessageToAll(admin_action, sprintf("Administrator %s has set the server time to %02d:00.", g_Player[playerid][p_Name], hour));
		SendClientMessage(playerid, acolor, sprintf("You have set the server time to %02d:00.", hour));
	}
	return 1;
}

CMD:setweather(playerid, params[] ) {
	if (IsAuthorizedLevel(playerid, 4)) {
	    new weatherid;
	    if (sscanf(params, "i", weatherid)) {
	        return SendClientMessage(playerid, grey, "Usage: /setweather <weatherid>");
		}
		
		if (weatherid > 50) {
		    return SendClientMessage(playerid, red, "Invalid weather.");
		}
		
		admin_CommandMessage(playerid, "/setweather", weatherid);
		SetWeather(weatherid);
		
		SendClientMessageToAll(admin_action, sprintf("Administrator %s has set the weather to %i.", g_Player[playerid][p_Name], weatherid));
		SendClientMessage(playerid, acolor, sprintf("You have set the weather to %i.", weatherid));
	}
	return 1;
}

CMD:getteam(playerid, params[]) {
	if (IsAuthorizedLevel(playerid, 4)) {
	    if (g_Player[playerid][p_DM_ID] != 0) {
			return SendClientMessage(playerid, red, "You cannot use this command inside DM arena.");
		}
		
	    if (GetPVarInt(playerid, "DUTY") == 0 && g_Player[playerid][p_Level] < 6) {
			return SendClientMessage(playerid, red, "You need to be on admin duty to use this command.");
		}
		
	    if (sscanf(params, "s[50]", params)) {
	        return SendClientMessage(playerid, grey, "Usage: /getteam <team name>");
		}
		
		new teamid = team_ReturnIDByName(params);
		if (teamid == 0 || teamid >= MAX_TEAMS) {
		    return SendClientMessage(playerid, red, "Invalid team.");
		}
		
		if (g_TeamInfo[teamid][t_Players] == 0) {
		    return SendClientMessage(playerid, red, "This team is empty.");
		}
		
		new Float:x, Float:y, Float:z, world, int;
		GetPlayerPos(playerid, x, y, z);

		world = GetPlayerVirtualWorld(playerid);
		int = GetPlayerInterior(playerid);
		
		foreach(new i : Player) {
		    if (i != playerid) {
		        if (g_Player[i][p_Spawned] == 1 && g_Player[i][p_Team] == teamid) {
		            if (g_Player[i][p_DM_ID] == 0) {
			            SetPlayerPos(i, x, y + 2.0, z + 3.0);
			            SetPlayerInterior(i, int);
			            SetPlayerVirtualWorld(i, world);

			            TogglePlayerControllable(i, 0);
					}
				}
			}
		}
		
		SendClientMessageToAll(admin_action, sprintf("Administrator %s has teleported team %s.", g_Player[playerid][p_Name], g_TeamInfo[teamid][t_Name]));
		SendClientMessage(playerid, acolor, sprintf("You have teleported team %s.", g_TeamInfo[teamid][t_Name]));
		admin_CommandMessage(playerid, "getteam", teamid);
	}
	return 1;
}

CMD:freezeteam(playerid, params[]) {
	if (IsAuthorizedLevel(playerid, 4)) {
	    if (GetPVarInt(playerid, "DUTY") == 0 && g_Player[playerid][p_Level] < 6) {
			return SendClientMessage(playerid, red, "You need to be on admin duty to use this command.");
		}

	    if (sscanf(params, "s[50]", params)) {
	        return SendClientMessage(playerid, grey, "Usage: /freezeteam <team name>");
		}

		new teamid = team_ReturnIDByName(params);
		if (teamid == 0 || teamid >= MAX_TEAMS) {
		    return SendClientMessage(playerid, red, "Invalid team.");
		}
		
		if (g_TeamInfo[teamid][t_Players] == 0) {
		    return SendClientMessage(playerid, red, "This team is empty.");
		}
		
		foreach(new i : Player) {
		    if (i != playerid) {
		        if (g_Player[i][p_Spawned] == 1 && g_Player[i][p_Team] == teamid) {
		            if (g_Player[i][p_DM_ID] == 0) {
			            TogglePlayerControllable(i, 0);
					}
				}
			}
		}

		SendClientMessageToAll(admin_action, sprintf("Administrator %s has frozen team %s.", g_Player[playerid][p_Name], g_TeamInfo[teamid][t_Name]));
		SendClientMessage(playerid, acolor, sprintf("You have frozen team %s.", g_TeamInfo[teamid][t_Name]));
		admin_CommandMessage(playerid, "freezeteam", teamid);
	}
	return 1;
}

CMD:unfreezeteam(playerid, params[]) {
	if (IsAuthorizedLevel(playerid, 4)) {
	    if (GetPVarInt(playerid, "DUTY") == 0 && g_Player[playerid][p_Level] < 6) {
			return SendClientMessage(playerid, red, "You need to be on admin duty to use this command.");
		}

	    if (sscanf(params, "s[50]", params)) {
	        return SendClientMessage(playerid, grey, "Usage: /unfreezeteam <team name>");
		}

		new teamid = team_ReturnIDByName(params);
		if (teamid == 0 || teamid >= MAX_TEAMS) {
		    return SendClientMessage(playerid, red, "Invalid team.");
		}
		
		if (g_TeamInfo[teamid][t_Players] == 0) {
		    return SendClientMessage(playerid, red, "This team is empty.");
		}

		foreach(new i : Player) {
		    if (i != playerid) {
		        if (g_Player[i][p_Spawned] == 1 && g_Player[i][p_Team] == teamid) {
					if (g_Player[i][p_DM_ID] == 0) {
			            TogglePlayerControllable(i, 1);
					}
				}
			}
		}

		SendClientMessageToAll(admin_action, sprintf("Administrator %s has unfrozen team %s.", g_Player[playerid][p_Name], g_TeamInfo[teamid][t_Name]));
		SendClientMessage(playerid, acolor, sprintf("You have unfrozen team %s.", g_TeamInfo[teamid][t_Name]));
		admin_CommandMessage(playerid, "unfreezeteam", teamid);
	}
	return 1;
}

CMD:weapteam(playerid, params[]) {
	if (IsAuthorizedLevel(playerid, 4)) {
	    if (GetPVarInt(playerid, "DUTY") == 0 && g_Player[playerid][p_Level] < 6) {
			return SendClientMessage(playerid, red, "You need to be on admin duty to use this command.");
		}
		
		new model[50], ammo;
		if (sscanf(params, "s[50]s[50]i", params, model, ammo)) {
			return SendClientMessage(playerid, grey, "Usage: /weapteam <team name> <weapon name> <ammo>");
		}
		
		new teamid = team_ReturnIDByName(params);
		if (teamid == 0 || teamid >= MAX_TEAMS) {
		    return SendClientMessage(playerid, red, "Invalid team.");
		}
		
		if (g_TeamInfo[teamid][t_Players] == 0) {
		    return SendClientMessage(playerid, red, "This team is empty.");
		}

		new weaponid = weapon_ReturnModelFromName(model);
		if (weaponid == -1 || weaponid == 38) {
			return SendClientMessage(playerid, red, "Invalid weapon name.");
		}
		
		if (ammo > 1000) {
			return SendClientMessage(playerid, red, "Ammo cannot be higher than 1000.");
		}

		foreach(new i : Player) {
		    if (i != playerid) {
		        if (g_Player[i][p_Spawned] == 1 && g_Player[i][p_Team] == teamid) {
		            if (g_Player[i][p_DM_ID] == 0) {
						GivePlayerWeapon(i, weaponid, ammo);
					}
				}
			}
		}

		SendClientMessageToAll(admin_action, sprintf("Administrator %s has given team %s a weapon %s[%i] with %i rounds of ammo.", g_Player[playerid][p_Name], g_TeamInfo[teamid][t_Name], aWeaponNames[weaponid], weaponid, ammo));
		SendClientMessage(playerid, acolor, sprintf("You have frozen team %s a weapon %s[%i] with %i rounds of ammo.", g_TeamInfo[teamid][t_Name], aWeaponNames[weaponid], weaponid, ammo));
		admin_CommandMessage(playerid, "weapteam");
	}
	return 1;
}

CMD:armteam(playerid, params[]) {
	if (IsAuthorizedLevel(playerid, 4)) {
	    if (GetPVarInt(playerid, "DUTY") == 0 && g_Player[playerid][p_Level] < 6) {
			return SendClientMessage(playerid, red, "You need to be on admin duty to use this command.");
		}

	    if (sscanf(params, "s[50]", params)) {
	        return SendClientMessage(playerid, grey, "Usage: /armteam <team name>");
		}

		new teamid = team_ReturnIDByName(params);
		if (teamid == 0 || teamid >= MAX_TEAMS) {
		    return SendClientMessage(playerid, red, "Invalid team.");
		}
		
		if (g_TeamInfo[teamid][t_Players] == 0) {
		    return SendClientMessage(playerid, red, "This team is empty.");
		}

		foreach(new i : Player) {
		    if (i != playerid) {
		        if (g_Player[i][p_Spawned] == 1 && g_Player[i][p_Team] == teamid) {
		            if (g_Player[i][p_DM_ID] == 0) {
			            SetPlayerArmour(i, 100.0);
					}
				}
			}
		}

		SendClientMessageToAll(admin_action, sprintf("Administrator %s has armoured team %s.", g_Player[playerid][p_Name], g_TeamInfo[teamid][t_Name]));
		SendClientMessage(playerid, acolor, sprintf("You have armoured team %s.", g_TeamInfo[teamid][t_Name]));
		admin_CommandMessage(playerid, "armteam", teamid);
	}
	return 1;
}

CMD:hteam(playerid, params[]) {
	if (IsAuthorizedLevel(playerid, 4)) {
	    if (GetPVarInt(playerid, "DUTY") == 0 && g_Player[playerid][p_Level] < 6) {
			return SendClientMessage(playerid, red, "You need to be on admin duty to use this command.");
		}

	    if (sscanf(params, "s[50]", params)) {
	        return SendClientMessage(playerid, grey, "Usage: /hteam <team name>");
		}

		new teamid = team_ReturnIDByName(params);
		if (teamid == 0 || teamid >= MAX_TEAMS) {
		    return SendClientMessage(playerid, red, "Invalid team.");
		}
		
		if (g_TeamInfo[teamid][t_Players] == 0) {
		    return SendClientMessage(playerid, red, "This team is empty.");
		}

		foreach(new i : Player) {
		    if (i != playerid) {
		        if (g_Player[i][p_Spawned] == 1 && g_Player[i][p_Team] == teamid) {
			        if (g_Player[i][p_DM_ID] == 0) {
			            SetPlayerHealth(i, 100.0);
					}
				}
			}
		}

		SendClientMessageToAll(admin_action, sprintf("Administrator %s has healed team %s.", g_Player[playerid][p_Name], g_TeamInfo[teamid][t_Name]));
		SendClientMessage(playerid, acolor, sprintf("You have healed team %s.", g_TeamInfo[teamid][t_Name]));
		admin_CommandMessage(playerid, "hteam", teamid);
	}
	return 1;
}

CMD:scoreteam(playerid, params[]) {
	if (IsAuthorizedLevel(playerid, 4)) {
	    if (GetPVarInt(playerid, "DUTY") == 0 && g_Player[playerid][p_Level] < 6) {
			return SendClientMessage(playerid, red, "You need to be on admin duty to use this command.");
		}

		new amount;
	    if (sscanf(params, "s[50]i", params, amount)) {
	        return SendClientMessage(playerid, grey, "Usage: /scoreteam <team name> <amount>");
		}

		new teamid = team_ReturnIDByName(params);
		if (teamid == 0 || teamid >= MAX_TEAMS) {
		    return SendClientMessage(playerid, red, "Invalid team.");
		}
		
		if (g_TeamInfo[teamid][t_Players] == 0) {
		    return SendClientMessage(playerid, red, "This team is empty.");
		}
		
		if (amount > 50) {
		    return SendClientMessage(playerid, red, "Cannot give more than 50 score.");
		}

		foreach(new i : Player) {
		    if (i != playerid) {
		        if (g_Player[i][p_Spawned] == 1 && g_Player[i][p_Team] == teamid) {
			        if (g_Player[i][p_DM_ID] == 0) {
			            RewardPlayer(i, 0, amount, 0);
					}
				}
			}
		}

		SendClientMessageToAll(admin_action, sprintf("Administrator %s has given team %s %i score.", g_Player[playerid][p_Name], g_TeamInfo[teamid][t_Name], amount));
		SendClientMessage(playerid, acolor, sprintf("You have given team %s %i score.", g_TeamInfo[teamid][t_Name], amount));
		admin_CommandMessage(playerid, "scoreteam", teamid, amount);
	}
	return 1;
}

CMD:moneyteam(playerid, params[]) {
	if (IsAuthorizedLevel(playerid, 4)) {
	    if (GetPVarInt(playerid, "DUTY") == 0 && g_Player[playerid][p_Level] < 6) {
			return SendClientMessage(playerid, red, "You need to be on admin duty to use this command.");
		}

		new amount;
	    if (sscanf(params, "s[50]i", params, amount)) {
	        return SendClientMessage(playerid, grey, "Usage: /moneyteam <team name> <amount>");
		}

		new teamid = team_ReturnIDByName(params);
		if (teamid == 0 || teamid >= MAX_TEAMS) {
		    return SendClientMessage(playerid, red, "Invalid team.");
		}
		
		if (g_TeamInfo[teamid][t_Players] == 0) {
		    return SendClientMessage(playerid, red, "This team is empty.");
		}
		
		if (amount > 50000) {
		    return SendClientMessage(playerid, red, "Cannot give more than $50000.");
		}

		foreach(new i : Player) {
		    if (i != playerid) {
		        if (g_Player[i][p_Spawned] == 1 && g_Player[i][p_Team] == teamid) {
			        if (g_Player[i][p_DM_ID] == 0) {
			            RewardPlayer(i, amount, 0, 0);
					}
				}
			}
		}

		SendClientMessageToAll(admin_action, sprintf("Administrator %s has given team %s $%i.", g_Player[playerid][p_Name], g_TeamInfo[teamid][t_Name], amount));
		SendClientMessage(playerid, acolor, sprintf("You have given team %s $%i.", g_TeamInfo[teamid][t_Name], amount));
		admin_CommandMessage(playerid, "moneyteam", teamid, amount);
	}
	return 1;
}

CMD:gotozone(playerid, params[]) {
	if (IsAuthorizedLevel(playerid, 4)) {
	    if (g_Player[playerid][p_DM_ID] != 0) {
	        return SendClientMessage(playerid, red, "You cannot use this command inside DM arena.");
		}
		
	    if (GetPVarInt(playerid, "DUTY") == 0 && g_Player[playerid][p_Level] < 6) {
			return SendClientMessage(playerid, red, "You need to be on admin duty to use this command.");
		}
		
		if (g_Player[playerid][p_Jailed] != 0) {
		    return SendClientMessage(playerid, red, "You cannot use this command inside jail.");
		}
		
	    if (sscanf(params, "s[50]", params)) {
	        return SendClientMessage(playerid, grey, "Usage: /gotozone <zone name>");
		}
		
		new zoneid = zone_ReturnIDByName(params);
		if (zoneid == 0 || zoneid >= MAX_CZ) {
		    return SendClientMessage(playerid, red, "Invalid zone name.");
		}
		new Float:x, Float:y, Float:z;
		x = g_CapZone[zoneid][cz_PointX];
		y = g_CapZone[zoneid][cz_PointY];
		z = g_CapZone[zoneid][cz_PointZ];
		
		switch (GetPlayerState(playerid)) {
		    case PLAYER_STATE_DRIVER: {
				SetVehiclePos(GetPlayerVehicleID(playerid), x, y, z + 1.0);
			}
			
			case PLAYER_STATE_ONFOOT: {
			    SetPlayerPos(playerid, x, y, z + 1.0);
			}
		}
		SetCameraBehindPlayer(playerid);
		
		SendClientMessage(playerid, acolor, sprintf("You have been teleported to %s.", g_CapZone[zoneid][cz_Name]));
		admin_SendMessage(acolor, sprintf("Admin %s has teleported to %s.", g_Player[playerid][p_Name], g_CapZone[zoneid][cz_Name]));
	}
	return 1;
}

CMD:gotobase(playerid, params[]) {
	if (IsAuthorizedLevel(playerid, 4)) {
	    if (g_Player[playerid][p_DM_ID] != 0) {
	        return SendClientMessage(playerid, red, "You cannot use this command inside DM arena.");
		}
		
	    if (GetPVarInt(playerid, "DUTY") == 0 && g_Player[playerid][p_Level] < 6) {
			return SendClientMessage(playerid, red, "You need to be on admin duty to use this command.");
		}

		if (g_Player[playerid][p_Jailed] != 0) {
		    return SendClientMessage(playerid, red, "You cannot use this command inside jail.");
		}

	    if (sscanf(params, "s[50]", params)) {
	        return SendClientMessage(playerid, grey, "Usage: /gotobase <team name>");
		}

		new teamid = team_ReturnIDByName(params);
		if (teamid == 0 || teamid >= MAX_TEAMS) {
		    return SendClientMessage(playerid, red, "Invalid team name.");
		}
		
		if (teamid == 6) {
		    return SendClientMessage(playerid, red, "This team does not have a base.");
		}
		new Float:x, Float:y, Float:z, Float:a, idx;
		
		switch (teamid) {
	        // US National Guard
			case 1: {
			    idx = random(sizeof(g_SpawnInfoUSNG));
				x = g_SpawnInfoUSNG[idx][sX];
				y = g_SpawnInfoUSNG[idx][sY];
				z = g_SpawnInfoUSNG[idx][sZ];
				a = g_SpawnInfoUSNG[idx][sA];
			}

			// Confederation Army
			case 2: {
			    idx = random(sizeof(g_SpawnInfoConfArmy));
				x = g_SpawnInfoConfArmy[idx][sX];
				y = g_SpawnInfoConfArmy[idx][sY];
				z = g_SpawnInfoConfArmy[idx][sZ];
				a = g_SpawnInfoConfArmy[idx][sA];
			}

			// Fourth Reich
			case 3: {
			    idx = random(sizeof(g_SpawnInfoFourthReich));
				x = g_SpawnInfoFourthReich[idx][sX];
				y = g_SpawnInfoFourthReich[idx][sY];
				z = g_SpawnInfoFourthReich[idx][sZ];
				a = g_SpawnInfoFourthReich[idx][sA];
			}

			// Unionist
			case 4: {
			    idx = random(sizeof(g_SpawnInfoUnionist));
				x = g_SpawnInfoUnionist[idx][sX];
				y = g_SpawnInfoUnionist[idx][sY];
				z = g_SpawnInfoUnionist[idx][sZ];
				a = g_SpawnInfoUnionist[idx][sA];
			}

			// Terrorists
			case 5: {
			    idx = random(sizeof(g_SpawnInfoTerrorist));
				x = g_SpawnInfoTerrorist[idx][sX];
				y = g_SpawnInfoTerrorist[idx][sY];
				z = g_SpawnInfoTerrorist[idx][sZ];
				a = g_SpawnInfoTerrorist[idx][sA];
			}
	   	}

		switch (GetPlayerState(playerid)) {
		    case PLAYER_STATE_DRIVER: {
				new vehicleid = GetPlayerVehicleID(playerid);
				
				SetVehiclePos(vehicleid, x, y, z + 1.0);
				SetVehicleZAngle(vehicleid, a);
			}

			case PLAYER_STATE_ONFOOT: {
			    SetPlayerPos(playerid, x, y, z + 1.0);
			    SetPlayerFacingAngle(playerid, a);
			}
		}
		SetCameraBehindPlayer(playerid);

		SendClientMessage(playerid, acolor, sprintf("You have been teleported to team %s's base.", g_TeamInfo[teamid][t_Name]));
		admin_SendMessage(acolor, sprintf("Admin %s has teleported to team %s's base.", g_Player[playerid][p_Name], g_TeamInfo[teamid][t_Name]));
	}
	return 1;
}

CMD:forceteam(playerid, params[]) {
	if (IsAuthorizedLevel(playerid, 4)) {
	    new id;
	    if (sscanf(params, "us[24]", id, params)) {
	        return SendClientMessage(playerid, grey, "Usage: /forceteam <playerod/name> <team name>");
		}
		
		new teamid = team_ReturnIDByName(params);
		
		if (teamid == 0 || teamid >= MAX_TEAMS) {
			return SendClientMessage(playerid, red, "Invalid team.");
		}
		
		if (IsValidTargetPlayer(playerid, id)) {
		    if (g_Player[id][p_DM_ID] != 0) {
		        return SendClientMessage(playerid, red, "Specified player is in DM arena.");
			}
			
		    if (g_Player[id][p_Protected] != 0) {
			    return SendClientMessage(playerid, red, "Please wait...");
			}
			
			if (!g_Player[id][p_Spawned]) {
			    return SendClientMessage(playerid, red, "Specified player is not spawned.");
			}
			
			if (g_Player[id][p_Jailed] != 0) {
				return SendClientMessage(playerid, red, "Specified player is in jail.");
			}
			
			if (g_Player[id][p_Frozen] == 1) {
				return SendClientMessage(playerid, red, "Specified player is in frozen.");
			}
			
			if (g_Player[id][p_Team] == teamid) {
			    return SendClientMessage(playerid, red, "Specified player is already playing in this team.");
			}
			
			g_TeamInfo[g_Player[id][p_Team]][t_Players] -= 1;
			
			g_Player[id][p_Team] = teamid;
			g_Player[id][p_PlayingTeam] = teamid;

			SetPlayerTeam(id, teamid);
			SetPlayerColor(id, g_TeamInfo[teamid][t_Color]);
			SetSpawnInfo(id, teamid, g_TeamInfo[teamid][t_Skin], 0.0, 0.0, 0.0, 0.0, 0, 0, 0, 0, 0, 0);
			
			switch (teamid) {
			   	case 5: {
				   	g_Player[id][p_Class] = ASSAULT;
				}
				
				case 6: {
				    g_Player[id][p_Class] = 0;
				    SetPlayerTeam(id, id + 1000);
				}
			}
			g_TeamInfo[teamid][t_Players] += 1;
			SetPVarInt(id, "CLASSSPAWN", 1);
			SpawnPlayer(id);
			
			SendClientMessage(playerid, acolor, sprintf("You have forced player %s to team %s.", g_Player[id][p_Name], g_TeamInfo[teamid][t_Name]));
			SendClientMessage(id, acolor2, sprintf("Admin %s has forced you to team %s.", g_Player[playerid][p_Name], g_TeamInfo[teamid][t_Name]));

			admin_CommandMessage(playerid, "forceteam", id, teamid);
		}
	}
	return 1;
}

CMD:dischat(playerid, params[]) {
	if(IsAuthorizedLevel(playerid, 4)) {
		if(g_ServerData[server_ChatDisabled] == true) {
			return SendClientMessage(playerid, red, "Chat is already disabled.");
		}
		
		SendClientMessageToAll(red, sprintf("Admin %s has disabled the chat.", g_Player[playerid][p_Name]));
		g_ServerData[server_ChatDisabled] = true;
	}
	return 1;
}

CMD:enchat(playerid, params[]) {
	if(IsAuthorizedLevel(playerid, 6)) {
		if(g_ServerData[server_ChatDisabled] == false) {
			return SendClientMessage(playerid, red, "Chat is already enabled.");
		}
		
		SendClientMessageToAll(admin_action, sprintf("Admin %s has enabled the chat.", g_Player[playerid][p_Name]));
		g_ServerData[server_ChatDisabled] = false;
	}
	return 1;
}

CMD:msg(playerid, params[]) {
	if(IsAuthorizedLevel(playerid, 4)) {
		admin_CommandMessage(playerid, "msg");
	 	SendClientMessageToAll(yellow, sprintf("*** %s", params));
	}
 	return 1;
}

CMD:weaponall(playerid, params[]) {
    if(IsAuthorizedLevel(playerid, 4)) {
		if (GetPVarInt(playerid, "DUTY") == 0 && g_Player[playerid][p_Level] < 5) {
			return SendClientMessage(playerid, red, "You need to be on admin duty to use this command.");
		}

		new model[50], ammo;
		if (sscanf(params, "s[50]i", model, ammo)) {
			return SendClientMessage(playerid, grey, "Usage: /weaponall <weapon name> <ammo>");
		}

		new weaponid = weapon_ReturnModelFromName(model);
		if (ammo > 1000) {
			return SendClientMessage(playerid, red, "Ammo cannot be higher than 1000.");
		}

		if (weaponid == -1 || weaponid == 38) {
			return SendClientMessage(playerid, red, "Invalid weapon name.");
		}

		foreach(new i : Player) {
		    if (g_Player[i][p_Spawned] == 1) {
				if (g_Player[i][p_DM_ID] == 0) {
					GivePlayerWeapon(i, weaponid, ammo);
				}
			}
		}

		admin_CommandMessage(playerid, "weaponall", weaponid, ammo);
 		SendClientMessageToAll(admin_action, sprintf("Administrator %s has given all players a weapon %s[%d] with %d ammo.", g_Player[playerid][p_Name], aWeaponNames[weaponid], weaponid, ammo));
	}
	return 1;
}

CMD:moneyall(playerid, params[]) {
	if(IsAuthorizedLevel(playerid, 4)) {
	    if (GetPVarInt(playerid, "DUTY") == 0 && g_Player[playerid][p_Level] < 5) {
			return SendClientMessage(playerid, red, "You need to be on admin duty to use this command.");
		}

		new amount;
		if (sscanf(params, "i", amount)) {
			return SendClientMessage(playerid, grey, "Usage: /moneyall <amount>");
		}
		foreach(new i : Player) {
		    if (i != playerid) {
				RewardPlayer(i, amount, 0, 0);
			}
		}
		SendClientMessageToAll(admin_action, sprintf("Administrator %s has given all players $%i.", g_Player[playerid][p_Name], amount));
		admin_CommandMessage(playerid, "moneyall", amount);
	}
	return 1;
}

CMD:scoreall(playerid, params[]) {
	if(IsAuthorizedLevel(playerid, 4)) {
		if (GetPVarInt(playerid, "DUTY") == 0 && g_Player[playerid][p_Level] < 5) {
			return SendClientMessage(playerid, red, "You need to be on admin duty to use this command.");
		}

		new amount;
	    if (sscanf(params, "i", amount)) {
			return SendClientMessage(playerid, grey, "Usage: /scoreall <amount>");
		}
		
		if (g_Player[playerid][p_Level] < 7 && amount > g_Player[playerid][p_Level]) {
		    return SendClientMessage(playerid, red, sprintf("You can only give %i score max.", g_Player[playerid][p_Level]));
		}

		foreach(new i : Player) {
		    if (i != playerid) {
				RewardPlayer(i, 0, amount, 0);
			}
		}
		SendClientMessageToAll(admin_action, sprintf("Administrator %s has given all players %i score.", g_Player[playerid][p_Name], amount));
		admin_CommandMessage(playerid, "scoreall", amount);
	}
	return 1;
}

CMD:xpall(playerid, params[]) {
	if(IsAuthorizedLevel(playerid, 4)) {
		if (GetPVarInt(playerid, "DUTY") == 0 && g_Player[playerid][p_Level] < 5) {
			return SendClientMessage(playerid, red, "You need to be on admin duty to use this command.");
		}

		new amount;
	    if (sscanf(params, "i", amount)) {
			return SendClientMessage(playerid, grey, "Usage: /xpall <amount>");
		}

		foreach(new i : Player) {
		    if (i != playerid) {
				RewardPlayer(i, 0, 0, amount);
			}
		}
		SendClientMessageToAll(admin_action, sprintf("Administrator %s has given all players %iXP.", g_Player[playerid][p_Name], amount));
		admin_CommandMessage(playerid, "scoreall", amount);
	}
	return 1;
}

CMD:helmetall(playerid, params[]) {
	if(IsAuthorizedLevel(playerid, 4)) {
		if (GetPVarInt(playerid, "DUTY") == 0 && g_Player[playerid][p_Level] < 5) {
			return SendClientMessage(playerid, red, "You need to be on admin duty to use this command.");
		}

		foreach(new i : Player) {
		    if (i != playerid) {
		        if (g_Player[i][p_HasHelmet]) continue;
		        if (g_Player[i][p_DM_ID] == 0) {
					ToggleHelmet(i, 1);
					g_Player[i][p_HasHelmet] = 1;
				}
			}
		}
		SendClientMessageToAll(admin_action, sprintf("Administrator %s has given a helmet to all the players.", g_Player[playerid][p_Name]));
		admin_CommandMessage(playerid, "helmetall");
	}
	return 1;
}

CMD:maskall(playerid, params[]) {
	if(IsAuthorizedLevel(playerid, 4)) {
		if (GetPVarInt(playerid, "DUTY") == 0 && g_Player[playerid][p_Level] < 5) {
			return SendClientMessage(playerid, red, "You need to be on admin duty to use this command.");
		}

		foreach(new i : Player) {
		    if (i != playerid) {
		        if (g_Player[i][p_HasMask]) continue;
		        if (g_Player[i][p_DM_ID] == 0) {
					ToggleMask(i, 1);
					g_Player[i][p_HasMask] = 1;
				}
			}
		}
		SendClientMessageToAll(admin_action, sprintf("Administrator %s has given an anti teargas mask to all the players.", g_Player[playerid][p_Name]));
		admin_CommandMessage(playerid, "maskall");
	}
	return 1;
}

CMD:ann(playerid, params[]) {
	if(IsAuthorizedLevel(playerid, 4)) {
		new time, text[128];
		if (sscanf(params, "is[128]", time, text)) {
			return SendClientMessage( playerid, grey, "Usage: /ann <time> <text>");
		}

		if (time == 0 || time > 5) {
			return SendClientMessage(playerid, red, "Invalid time format. Use 1 to 5 seconds.");
		}
		
		if (strlen(text) > 119) {
		    return SendClientMessage(playerid, red, "Message length exceeds the maximum characters limit. Limit: 120 chars.");
		}
		
		Announce(text, (time * 1000));
		admin_CommandMessage(playerid, "ann");
	}
	return 1;
}

CMD:givescore(playerid, params[]) {
	if(IsAuthorizedLevel(playerid, 4)) {
		new id, score;
		if (sscanf(params, "ud", id, score)) {
			return SendClientMessage(playerid, grey, "Usage: /givescore <playerid/name> <score>");
		}

		if (IsValidTargetPlayer(playerid, id)) {
			if (!g_Player[id][p_ReggedAcc]) {
				return SendClientMessage(playerid, red, "Specified player is not registered.");
			}

			SendClientMessage(playerid, acolor, sprintf("You have given %i score to player %s.", score, g_Player[id][p_Name]));
			SendClientMessage(id, acolor2, sprintf("You have received %i score from admin %s.", score, g_Player[playerid][p_Name]));

			RewardPlayer(id, 0, score, 0, true);
			admin_CommandMessage(playerid, "givescore", id, score);
		}
	}
	return 1;
}

CMD:setping(playerid, params[]) {
	if(IsAuthorizedLevel(playerid, 4)) {
		new ping;
		if (sscanf(params, "d", ping)) {
			return SendClientMessage(playerid, grey, "Usage: /setping <max limit>");
		}

		if (ping > 1000) {
			return SendClientMessage(playerid, red, "Maximum limit is 1000.");
		}

		new string[128];
		if (ping != 0) {
			Format:string("Administrator %s has set the ping limit to %d.", g_Player[playerid][p_Name], ping);
			SendClientMessage(playerid, grey, "You can disable the ping limit by setting its value to 0.");
		}
		else {
			Format:string("Administrator %s has disabled the ping limit.", g_Player[playerid][p_Name]);
		}

		SendClientMessageToAll(admin_action, string);
		g_ServerData[server_MaxPing] = ping;
		admin_CommandMessage(playerid, "setping", ping);
	}
	return 1;
}

CMD:armour(playerid, params[]) {
	if(IsAuthorizedLevel(playerid, 4)) {
		new id;
		if(sscanf(params, "u", id))
			id = playerid;
		else
			id = strval(params);
		if(IsValidTargetPlayer(playerid, id)) {
		    if(id == playerid) {
		        SendClientMessage(playerid, acolor, "You have armoured yourself.");
		        SendClientMessage(playerid, grey, "You can also use '/armour <playerid/name>' to armour other players.");

				SetPlayerArmour(playerid, 100.0);
				admin_CommandMessage(playerid, "armour - /a");
			}
			else {
				SendClientMessage(id, acolor2, sprintf("Admin %s has armoured you.", g_Player[playerid][p_Name]));
				SendClientMessage(playerid, acolor, sprintf("You have armoured %s.", g_Player[id][p_Name]));

				SetPlayerArmour(id, 100.0);
				admin_CommandMessage(playerid, "armour - /a", id);
			}
		}
	}
	return 1;
}

CMD:a(playerid, params[]) {
	return cmd_armour(playerid, params);
}

CMD:heal(playerid, params[]) {
	if(IsAuthorizedLevel(playerid, 4)) {
		new id;
		if(sscanf(params, "u", id))
			id = playerid;
		else
			id = strval(params);
		if(IsValidTargetPlayer(playerid, id)) {
		    if(id == playerid) {
		        SendClientMessage(playerid, acolor, "You have healed yourself.");
		        SendClientMessage(playerid, grey, "You can also use '/heal - /h <playerid/name>' to heal other players.");

				SetPlayerHealth(playerid, 100.0);
				admin_CommandMessage(playerid, "heal - /h");
			}
			else {
				SendClientMessage(id, acolor2, sprintf("Admin %s has healed you.", g_Player[playerid][p_Name]));
				SendClientMessage(playerid, acolor, sprintf("You have healed %s.", g_Player[id][p_Name]));

				SetPlayerHealth(id, 100.0);
				admin_CommandMessage(playerid, "heal - /h", id);
			}
		}
	}
	return 1;
}

CMD:h(playerid, params[]) {
	return cmd_heal(playerid, params);
}

CMD:givecash(playerid, params[]) {
	if(IsAuthorizedLevel(playerid, 4)) {
		new id, cash;
		if (sscanf(params, "ud", id, cash)) {
			return SendClientMessage(playerid, grey, "Usage: /givecash <playerid/name> <amount>");
		}

		if (IsValidTargetPlayer(playerid, id)) {
			if (!g_Player[id][p_ReggedAcc]) {
				return SendClientMessage(playerid, red, "Specified player is not registered.");
			}

			SendClientMessage(playerid, acolor, sprintf("You have given $%i to %s.", cash, g_Player[id][p_Name]));
			SendClientMessage(id, acolor2, sprintf("You have received $%i from admin %s.", cash, g_Player[playerid][p_Name]));

			RewardPlayer(id, cash, 0, 0, true);
			admin_CommandMessage(playerid, "givecash", id, cash);
		}
	}
	return 1;
}

CMD:givexp(playerid, params[]) {
	if(IsAuthorizedLevel(playerid, 4)) {
		new id, xp;
		if (sscanf(params, "ui", id, xp)) {
			return SendClientMessage(playerid, grey, "Usage: /givexp <playerid/name> <amount>");
		}

		if (IsValidTargetPlayer(playerid, id)) {
			if (!g_Player[id][p_ReggedAcc]) {
				return SendClientMessage(playerid, red, "Specified player is not registered.");
			}

			SendClientMessage(playerid, acolor, sprintf("You have given %iXP to %s.", xp, g_Player[id][p_Name]));
			SendClientMessage(id, acolor2, sprintf("You have received %iXP from admin %s.", xp, g_Player[playerid][p_Name]));

			RewardPlayer(id, 0, 0, xp, true);
			admin_CommandMessage(playerid, "givexp", id, xp);
		}
	}
	return 1;
}
/*******************************************************************************
								Level 5 commands
*******************************************************************************/
CMD:pos(playerid, params[]) {
	if(IsAuthorizedLevel(playerid, 5)) {
		new Float:x, Float:y, Float:z, Float:rot, int, world;
		GetPlayerPos(playerid, x, y, z);
		if(GetPlayerVehicleSeat(playerid) == -1)
			GetPlayerFacingAngle(playerid, rot);
		else
			GetVehicleZAngle(GetPlayerVehicleID(playerid), rot);

		int = GetPlayerInterior(playerid);
		world = GetPlayerVirtualWorld(playerid);
	 	SendClientMessage(playerid, acolor, sprintf("Position: X: %4.2f - Y: %4.2f - Z: %4.2f - Rotation: %4.2f - Interior ID: %i - World ID: %i", x, y, z, rot, int, world));
	}
	return 1;
}

CMD:gotopos(playerid, params[]) {
	if(IsAuthorizedLevel(playerid, 5)) {
	    if (g_Player[playerid][p_DM_ID] != 0) {
	        return SendClientMessage(playerid, red, "You cannot use this command inside DM arena.");
		}
		
		new Float:x, Float:y, Float:z, Float:r;
		if(sscanf(params, "ffff", x, y, z, r)) {
			return SendClientMessage(playerid, grey, "/gotopos <x> <y> <z> <rotation>");
		}
		
		SetPlayerPos(playerid, x, y, z);
		SetPlayerFacingAngle(playerid, r);
		SendClientMessage(playerid, acolor, "Your position has been set to the following coordinates:");
		SendClientMessage(playerid, acolor, sprintf("X: %4.2f | Y: %4.2f | Z: %4.2f | Rotation: %4.2f", x, y, z, r));
	}
	return 1;
}

CMD:setdeaths(playerid, params[]) {
	if(IsAuthorizedLevel(playerid, 5)) {
	    new id, amount;
	    if(sscanf(params, "ui", id, amount)) {
	        return SendClientMessage(playerid, grey, "Usage: /setdeaths <playerid/name> <amount>");
		}

		if(IsValidTargetPlayer(playerid, id)) {
		    if (!g_Player[id][p_ReggedAcc]) {
		        return SendClientMessage(playerid, red, "Specified player is not registered.");
			}

			g_Player[id][p_Deaths] = amount;

			new query[100];
			Query("UPDATE `users` SET `deaths`='%i' WHERE `id`='%i'", g_Player[id][p_Deaths], g_Player[id][p_UserID]);
			mysql_tquery(mysql, query, "ExecuteQuery", "i", res_none);

			SendClientMessage(playerid, acolor, sprintf("You have set %s's deaths to %i.", g_Player[id][p_Name], amount));
			SendClientMessage(id, acolor2, sprintf("Admin %s has set your deaths to %i.", g_Player[playerid][p_Name], amount));
			admin_CommandMessage(playerid, "setdeath", id, amount);
			UpdateScoreBoard(id);
		}
	}
	return 1;
}

CMD:setkills(playerid, params[]) {
	if(IsAuthorizedLevel(playerid, 5)) {
	    new id, amount;
	    if(sscanf(params, "ui", id, amount)) {
	        return SendClientMessage(playerid, grey, "Usage: /setkills <playerid/name> <amount>");
		}

		if(IsValidTargetPlayer(playerid, id)) {
		    if (!g_Player[id][p_ReggedAcc]) {
		        return SendClientMessage(playerid, red, "Specified player is not registered.");
			}

			g_Player[id][p_Kills] = amount;

			new query[100];
			Query("UPDATE `users` SET `kills`='%i' WHERE `id`='%i'", g_Player[id][p_Deaths], g_Player[id][p_UserID]);
			mysql_tquery(mysql, query, "ExecuteQuery", "i", res_none);

			SendClientMessage(playerid, acolor, sprintf("You have set %s's kills to %i.", g_Player[id][p_Name], amount));
			SendClientMessage(id, acolor2, sprintf("Admin %s has set your kills to %i.", g_Player[playerid][p_Name], amount));
			admin_CommandMessage(playerid, "setkills", id, amount);

			UpdateScoreBoard(id);
		}
	}
	return 1;
}

CMD:giveweapon(playerid, params[]) {
    if(IsAuthorizedLevel(playerid, 5)) {
		new model[50], ammo, id;
		if (sscanf(params, "us[50]i", id, model, ammo)) {
			return SendClientMessage(playerid, grey, "Usage: /giveweapon <playerid/name> <weapon name> <ammo>");
		}

		if(IsValidTargetPlayer(playerid, id)) {
		    if (g_Player[id][p_DM_ID] != 0) {
		        return SendClientMessage(playerid, red, "Specified player is in DM arena.");
			}
			
		    if(!g_Player[playerid][p_Spawned]) {
		        return SendClientMessage(playerid, red, "Specified player is not spawned.");
			}

			new weaponid = weapon_ReturnModelFromName(model);
			if (ammo > 1000) {
				return SendClientMessage(playerid, red, "Ammo cannot be higher than 1000.");
			}

			if (weaponid == -1 || weaponid == 38) {
				return SendClientMessage(playerid, red, "Invalid weaponid.");
			}

			GivePlayerWeapon(id, weaponid, ammo);

			SendClientMessage(playerid, acolor, sprintf("You have given a weapon %s[%d] with %d ammo to %s.", aWeaponNames[weaponid], weaponid, ammo, g_Player[id][p_Name]));
	 		SendClientMessage(id, acolor2, sprintf("Admin %s gave you a weapon %s[%d] with %d ammo.", g_Player[playerid][p_Name], aWeaponNames[weaponid], weaponid, ammo));

			admin_CommandMessage(playerid, "giveweapon", id, weaponid);
		}
	}
	return 1;
}

CMD:weapon(playerid, params[]) {
    if(IsAuthorizedLevel(playerid, 5)) {
        if (g_Player[playerid][p_DM_ID] != 0) {
	        return SendClientMessage(playerid, red, "You cannot use this command inside DM arena.");
		}
		
		new model[50], ammo;
		if (sscanf(params, "s[50]i", model, ammo)) {
			return SendClientMessage(playerid, grey, "Usage: /weapon <weapon name> <ammo>");
		}

		new weaponid = weapon_ReturnModelFromName(model);
		if (ammo > 1000) {
			return SendClientMessage(playerid, red, "Ammo cannot be higher than 1000.");
		}

		if (weaponid == -1 || weaponid == 38) {
			return SendClientMessage(playerid, red, "Invalid weapon.");
		}

		GivePlayerWeapon(playerid, weaponid, ammo);
 		SendClientMessage(playerid, acolor, sprintf("You got a weapon %s[%d] with %d ammo.", aWeaponNames[weaponid], weaponid, ammo));

		admin_CommandMessage(playerid, "weapon", weaponid);
	}
	return 1;
}

CMD:setdonor(playerid, params[]) {
	if (g_Player[playerid][p_Level] >= 5 || IsPlayerAdmin(playerid)) {
	    new id, newrank;
		if (sscanf(params, "ui", id, newrank)) {
			return SendClientMessage(playerid, grey, "Usage: /setdonor <playerid/name> <rank>");
		}

		if (IsValidTargetPlayer(playerid, id)) {
		    if (g_Player[id][p_ReggedAcc] == 0) {
				return SendClientMessage(playerid, red, "Specified player is not registered.");
			}

			if (newrank > 5) {
                return SendClientMessage(playerid, red, "Invalid rank.");
			}
			new oldrank = g_Player[id][p_Donor];
	        g_Player[id][p_Donor] = newrank;
	        if (oldrank == newrank) {
                return SendClientMessage(playerid, red, "Specified player's donor rank has not been changed.");
			}

			if (oldrank < newrank) {
		       	SendClientMessage(id, acolor2, sprintf("%s has set your donor rank to %i.", g_Player[playerid][p_Name], newrank));
	           	SendClientMessage(playerid, acolor, sprintf("You have set %s's donor rank to %i.", g_Player[id][p_Name], newrank));
			}

			if (oldrank > newrank) {
	           	SendClientMessage(id, acolor2, sprintf("%s has set your donor rank to %i.", g_Player[playerid][p_Name], newrank));
	           	SendClientMessage(playerid, acolor, sprintf("You have set %s's donor rank to %i.", g_Player[id][p_Name], newrank));
			}
			new query[100];
			Query("UPDATE `users` SET `donor`='%d' WHERE `id`='%d'", g_Player[id][p_Donor], g_Player[id][p_UserID]);
			mysql_tquery(mysql, query, "ExecuteQuery", "i", res_none);
		}
	}
	else
		return 0;
	return 1;
}

CMD:setadmin(playerid, params[]) {
    if (g_Player[playerid][p_Level] >= 5 || IsPlayerAdmin(playerid)) {
        new id, newlevel;
		if (sscanf(params, "ui", id, newlevel)) {
			return SendClientMessage(playerid, grey, "Usage: /setadmin <playerid/name> <level>");
		}

		if (IsValidTargetPlayer(playerid, id)) {
			if (g_Player[id][p_ReggedAcc] == 0) {
				return SendClientMessage(playerid, red, "Specified player is not registered.");
			}

		    if (g_Player[playerid][p_Level] < 7 && !IsPlayerAdmin(playerid) && newlevel > 5) {
				return SendClientMessage(playerid, red, "You cannot set higher than level 5.");
			}

			if (newlevel > 7) {
                return SendClientMessage(playerid, red, "Invalid level.");
			}

			if(g_Player[id][p_Level] > g_Player[playerid][p_Level]) {
			    return SendClientMessage(playerid, red, "Specified player's level cannot be changed.");
			}

		 	new oldlevel = g_Player[id][p_Level];
		 	g_Player[id][p_Level] = newlevel;
			if (oldlevel == newlevel) {
                return SendClientMessage(playerid, red, "Specified player's level hasn't been changed.");
			}

			if (oldlevel < newlevel) {
		       	SendClientMessage(id, acolor2, sprintf("%s has set your admin level to %i.", g_Player[playerid][p_Name], newlevel));
	           	SendClientMessage(playerid, acolor, sprintf("You have set %s's Admin level to %i.", g_Player[id][p_Name], newlevel));
                GameTextForPlayer(id, "~g~promoted", 2000, 5);
			}

			if (oldlevel > newlevel) {
	           	SendClientMessage(id, acolor2, sprintf("%s has set your Admin level to %i.", g_Player[playerid][p_Name], newlevel));
	           	SendClientMessage(playerid, acolor, sprintf("You have set %s's Admin level to %i.", g_Player[id][p_Name], newlevel));
				GameTextForPlayer(id, "~r~demoted", 2000, 5);
			}
			new query[100];
			Query("UPDATE `users` SET `level`='%d' WHERE `id`='%d'", g_Player[id][p_Level], g_Player[id][p_UserID]);
			mysql_tquery(mysql, query, "ExecuteQuery", "i", res_none);
		}
	}
	else
		return 0;
	return 1;
}

CMD:savevehicle(playerid, params[]) {
    if(IsAuthorizedLevel(playerid, 5)) {
        if (g_Player[playerid][p_DM_ID] != 0) {
	        return SendClientMessage(playerid, red, "You cannot use this command inside DM arena.");
		}
		
	    if(!IsPlayerInAnyVehicle(playerid)) {
			return SendClientMessage(playerid, red, "You need to be inside a vehicle to use this command.");
		}

		new Float:x, Float:y, Float:z, Float:a, vehicleid = GetPlayerVehicleID(playerid);
	   	GetVehiclePos(vehicleid, x, y, z);
	   	GetVehicleZAngle(vehicleid, a);

		new model = GetVehicleModel(vehicleid);
	    DestroyVehicle(vehicleid);

		vehicleid = AddServerVehicle(model, x, y, z, a, random(128), random(128), 120);
		PutPlayerInVehicle(playerid, vehicleid, 0);
	    g_Vehicle[vehicleid][v_Static] = true;

		new query[150];
		Query("INSERT INTO `server_vehicles` (model,x,y,z,a) VALUES('%i','%f','%f','%f','%f')", model, x, y, z, a);
		mysql_tquery(mysql, query, "ExecuteQuery", "ii", res_insert_sv, vehicleid);

		SendClientMessage(playerid, acolor, "Vehicle has been saved to the database.");
		SendClientMessage(playerid, acolor, sprintf("Model: %d, X: %4.2f, Y: %4.2f, Z: %4.2f, Rotation: %4.2f", model, x, y, z, a));
	}
    return 1;
}

CMD:delvehicle(playerid, params[]) {
	if(IsAuthorizedLevel(playerid, 5)) {
		new vehicleid;
		if(sscanf(params, "i", vehicleid)) {
			return SendClientMessage(playerid, grey, "Usage: /delvehicle <vehicleid>");
		}

		if(!IsValidVehicle(vehicleid)) {
			return SendClientMessage(playerid, red, "Vehicle with this ID does not exist.");
		}

		if (g_Vehicle[vehicleid][v_Static] == false || g_Vehicle[vehicleid][v_BombingPlane] == true) {
		    return SendClientMessage(playerid, red, "You cannot delete this vehicle.");
		}

		DestroyVehicle(vehicleid);

		new query[100];
		Query("DELETE FROM `server_vehicles` WHERE `id`='%i'", g_Vehicle[vehicleid][v_dbID]);
		mysql_tquery(mysql, query, "QueryExecute", "i", res_none);
		SendClientMessage(playerid, acolor, sprintf("Vehicle has been deleted from the database. DBID: %i", g_Vehicle[vehicleid][v_dbID]));

		new _x[E_VEHICLE_DATA];
		g_Vehicle[vehicleid] = _x;
	}
	return 1;
}



/*Player commands*/
// Donors
CMD:dcmds(playerid, params[]) {
	switch (g_Player[playerid][p_Donor]) {
		case 1: {
		    SendClientMessage(playerid, light_green, "Donor rank 1 commands:");
		    SendClientMessage(playerid, light_green, "/dtime, /dweather, /dvc, /ddefault, /dnos");
		}
		
		case 2: {
		    SendClientMessage(playerid, light_green, "Donor rank 2 commands:");
		    SendClientMessage(playerid, light_green, "/dammo, /dweaps");
		}
		
		case 3: {
		    SendClientMessage(playerid, light_green, "Donor rank 3 commands:");
		    SendClientMessage(playerid, light_green, "/dskin, /dbike");
		}
		
		case 4: {
		    SendClientMessage(playerid, light_green, "Donor rank 4 commands:");
		    SendClientMessage(playerid, light_green, "/dbike");
		}
		
		case 5: {
		    SendClientMessage(playerid, light_green, "Donor rank 5 commands:");
		    SendClientMessage(playerid, light_green, "/dcar");
		}
		
		default: return 1;
	}
	SendClientMessage(playerid, grey, "Use '$ <text>' to chat in donor chat.");
	admin_CommandMessage(playerid, "dcmds");
	return 1;
}

CMD:dtime(playerid, params[] ) {
	if(g_Player[playerid][p_Donor] < 1) {
		return 0;
	}
	
    new hour;
    if (sscanf(params, "i", hour)) {
        return SendClientMessage(playerid, grey, "Usage: /dtime <hour 0-23>");
	}

	if (hour > 23) {
	    return SendClientMessage(playerid, red, "Invalid hour format. Max: 23H.");
	}

	admin_CommandMessage(playerid, "/dtime", hour);
	SetPlayerTime(playerid, hour, 0);
	SendClientMessage(playerid, acolor, sprintf("Your world time has been set to %02d:00.", hour));
	return 1;
}

CMD:dweather(playerid, params[] ) {
	if (IsAuthorizedLevel(playerid, 4)) {
	    new weatherid;
	    if (sscanf(params, "i", weatherid)) {
	        return SendClientMessage(playerid, grey, "Usage: /dweather <weatherid>");
		}

		if (weatherid > 50) {
		    return SendClientMessage(playerid, red, "Invalid weather.");
		}

		admin_CommandMessage(playerid, "/dweather", weatherid);
		SetPlayerWeather(playerid, weatherid);
		SendClientMessage(playerid, acolor, sprintf("Your game weather has been changed to %i.", weatherid));
	}
	return 1;
}

CMD:dvc(playerid, params[]) {
	if(g_Player[playerid][p_Donor] < 1) {
		return 0;
	}
	
	new c1, c2;
	if(sscanf(params, "ii", c1, c2)) {
		return SendClientMessage(playerid, grey, "/dvc <color1> <color2>");
	}

    if(c1 > 255 || c2 > 255) {
		return SendClientMessage(playerid, red, "Invalid primary or secondary color.");
	}

	if(!IsPlayerInAnyVehicle(playerid)) {
		return SendClientMessage(playerid, red, "You must be inside a vehicle to use this command.");
	}

	new vehicleid = GetPlayerVehicleID(playerid);
	ChangeVehicleColor(vehicleid, c1, c2);
	admin_CommandMessage(playerid, "dvc", c1, c2);
	SendClientMessage(playerid, light_green, sprintf("Vehicle color changed. Primary: %i, secondary: %i", c1, c2));
	return 1;
}

CMD:ddefault(playerid, params[]) {
	if(g_Player[playerid][p_Donor] < 1) {
		return 0;
	}

	if(!IsPlayerInAnyVehicle(playerid)) {
		return SendClientMessage(playerid, red, "You must be inside a vehicle to use this command.");
	}

	new vehicleid = GetPlayerVehicleID(playerid);
	
	if (vehicleid != g_Player[playerid][p_Vehicle]) {
	    return SendClientMessage(playerid, red, "You can only use this command on a donor vehicle.");
	}
	
	ChangeVehicleColor(vehicleid, g_TeamVehicleColors[g_Player[playerid][p_Team]][0], g_TeamVehicleColors[g_Player[playerid][p_Team]][1]);
	admin_CommandMessage(playerid, "ddefault");
	SendClientMessage(playerid, light_green, "Vehicle color has been changed to the default one.");
	return 1;
}

CMD:dnos(playerid, params[]) {
	if(g_Player[playerid][p_Donor] < 1) {
		return 0;
	}

	if(!IsPlayerInAnyVehicle(playerid)) {
		return SendClientMessage(playerid, red, "You must be inside a vehicle to use this command.");
	}

	new vehicleid = GetPlayerVehicleID(playerid);
	AddVehicleComponent(vehicleid, 1009);
	admin_CommandMessage(playerid, "dnos");
	SendClientMessage(playerid, light_green, "x2 nitro has been added for $1500.");
	RewardPlayer(playerid, -1500, 0, 0);
	return 1;
}

CMD:dammo(playerid, params[]) {
	if(g_Player[playerid][p_Donor] < 2) {
		return 0;
	}
	
	if (g_Player[playerid][p_DM_ID] != 0) {
        return SendClientMessage(playerid, red, "You cannot use this command inside DM arena.");
	}
	
	if (GetPVarInt(playerid, "DAMMO_TIME") > gettime()) {
	    return SendClientMessage(playerid, red, "You can only use this command once every 2 minutes.");
	}
	
	new weapons[MAX_WEAPON_SLOT][2];

	for (new i = 0, j = MAX_WEAPON_SLOT; i < j; i++) {
		GetPlayerWeaponData(playerid, i, weapons[i][0], weapons[i][1]);
		
		switch (weapons[i][0]) {
		    case 22..34: {
				GivePlayerWeapon(playerid, weapons[i][0], 50);
			}
		}
	}
	
	SendClientMessage(playerid, light_green, "You received +50 ammo for all of your weapons except explosives.");
	admin_CommandMessage(playerid, "dammo");
	
	SetPVarInt(playerid, "DAMMO_TIME", gettime() + 120);
	return 1;
}

CMD:dweaps(playerid, params[]) {
    if (g_Player[playerid][p_Donor] < 2) {
		return 0;
	}
	
	if (g_Player[playerid][p_DM_ID] != 0) {
        return SendClientMessage(playerid, red, "You cannot use this command inside DM arena.");
	}

	if (GetPVarInt(playerid, "DWEAPS_USED") == 1) {
		return SendClientMessage(playerid, red, "You can only use this command once after spawn.");
	}

	new pack;
	if (sscanf(params, "i", pack)) {
	    return SendClientMessage(playerid, grey, "Usage: /dweaps <Pack: 1-3>");
	}
	
	if (pack == 0 || pack > 3) {
	    return SendClientMessage(playerid, red, "Invalid pack. [1-3]");
	}
	
	new w[4][5] = {
	    {0, 0, 0, 0},
		{27, 24, 31, 34},
		{25, 24, 29, 30},
		{33, 23, 28, 25}
	};

	for (new i = 0; i < 5; i++) {
		GivePlayerWeapon(playerid, w[pack][i], 100);
	}

	SendClientMessage(playerid, light_green, sprintf("You have received a weapon pack %i containing the following weapons with 100 rounds of ammo:", pack));
	SendClientMessage(playerid, light_green, sprintf("  %s, %s, %s, %s, %s", aWeaponNames[w[pack][0]], aWeaponNames[w[pack][1]], aWeaponNames[w[pack][2]], aWeaponNames[w[pack][3]], aWeaponNames[w[pack][4]]));
	admin_CommandMessage(playerid, "dweaps", pack);

	SetPVarInt(playerid, "DWEAPS_USED", 1);
	return 1;
}

CMD:dskin(playerid, params[]) {
    if (g_Player[playerid][p_Donor] < 3) {
		return 0;
	}

	if (IsPlayerInAnyVehicle(playerid)) {
		return SendClientMessage(playerid, red, "Set your skin on foot to avoid glitch.");
	}

	new skin;
	if (sscanf(params, "i", skin)) {
		return SendClientMessage(playerid, grey, "Usage: /dskin <skinid>");
	}

	if (skin < 0 || skin > 311) {
		return SendClientMessage(playerid, red, "Invalid skinid.");
	}

	switch (skin) {
		case 287, 285, 73, 206, 100, 200: {
			return SendClientMessage(playerid, red, "Invalid skinid.");
		}
	}

	SendClientMessage(playerid, light_green, sprintf("Skin %i set.", skin));
	SetSkin(playerid, skin);

	admin_CommandMessage(playerid, "dskin", skin);
	g_Player[playerid][p_Skin] = skin;
	return 1;
}

CMD:dbike(playerid, params[]) {
    if (g_Player[playerid][p_Donor] < 3) {
		return 0;
	}

    if (g_Player[playerid][p_DM_ID] != 0) {
        return SendClientMessage(playerid, red, "You cannot use this command inside DM arena.");
	}
	
	if (IsPlayerInAnyVehicle(playerid)) {
		return SendClientMessage(playerid, red, "You must be on foot to use this command.");
	}
	
	if (!IsEnemyNear(playerid, 30.0)) {
		if(g_Player[playerid][p_Vehicle] != 0) {
			DestroyVehicle(g_Player[playerid][p_Vehicle]);
			g_Player[playerid][p_Vehicle] = 0;
		}

		new Float:x, Float:y, Float:z, Float:a, int, world;

		GetPlayerPos(playerid, x, y, z);
		GetPlayerFacingAngle(playerid, a);

		int = GetPlayerInterior(playerid);
		world = GetPlayerVirtualWorld(playerid);

		switch (g_Player[playerid][p_Donor]) {
			case 3: {
				g_Player[playerid][p_Vehicle] = CreateVehicle(468, x, y, z, a, g_TeamVehicleColors[g_Player[playerid][p_Team]][0], g_TeamVehicleColors[g_Player[playerid][p_Team]][1], 60);
			}

			case 4, 5: {
	            g_Player[playerid][p_Vehicle] = CreateVehicle(522, x, y, z, a, g_TeamVehicleColors[g_Player[playerid][p_Team]][0], g_TeamVehicleColors[g_Player[playerid][p_Team]][1], 60);
			}
		}

		PutPlayerInVehicle(playerid, g_Player[playerid][p_Vehicle], 0);

		new engine, lights, alarm, doors, bonnet, boot, objective, vehicleid;
		vehicleid = g_Player[playerid][p_Vehicle];

		GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
	 	SetVehicleParamsEx(vehicleid, 1, 1, alarm, doors, bonnet, boot, objective);

		LinkVehicleToInterior(vehicleid, int);
		SetVehicleVirtualWorld(vehicleid, world);

		SendClientMessage(playerid, light_green, "Donor bike spawned.");
		admin_CommandMessage(playerid, "dbike");
	}
	return 1;
}

CMD:dcar(playerid, params[]) {
    if (g_Player[playerid][p_Donor] < 5) {
		return 0;
	}
	
	if (g_Player[playerid][p_DM_ID] != 0) {
        return SendClientMessage(playerid, red, "You cannot use this command inside DM arena.");
	}

	if (IsPlayerInAnyVehicle(playerid)) {
		return SendClientMessage(playerid, red, "You must be on foot to use this command.");
	}

    if (!IsEnemyNear(playerid, 30.0)) {
		if(g_Player[playerid][p_Vehicle] != 0) {
			DestroyVehicle(g_Player[playerid][p_Vehicle]);
			g_Player[playerid][p_Vehicle] = 0;
		}

		new Float:x, Float:y, Float:z, Float:a, int, world;

		GetPlayerPos(playerid, x, y, z);
		GetPlayerFacingAngle(playerid, a);

		int = GetPlayerInterior(playerid);
		world = GetPlayerVirtualWorld(playerid);

		g_Player[playerid][p_Vehicle] = CreateVehicle(541, x, y, z, a, g_TeamVehicleColors[g_Player[playerid][p_Team]][0], g_TeamVehicleColors[g_Player[playerid][p_Team]][1], 60);
		PutPlayerInVehicle(playerid, g_Player[playerid][p_Vehicle], 0);

		new engine, lights, alarm, doors, bonnet, boot, objective, vehicleid;
		vehicleid = g_Player[playerid][p_Vehicle];

		GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
	 	SetVehicleParamsEx(vehicleid, 1, 1, alarm, doors, bonnet, boot, objective);

		LinkVehicleToInterior(vehicleid, int);
		SetVehicleVirtualWorld(vehicleid, world);

		SendClientMessage(playerid, light_green, "Donor car spawned.");
		admin_CommandMessage(playerid, "dcar");
	}
	return 1;
}

// Normal players
CMD:help(playerid, params[]) {
	SendClientMessage(playerid, light_yellow, "Server description:");
	SendClientMessage(playerid, light_yellow, "  This is a TDM (Team DeathMatch) server. You can act as a soldier to fight against your team's enemies. There are several");
	SendClientMessage(playerid, light_yellow, "  teams available for which you can choose to play on, along with classes that have its own abilities of which you can choose");
	SendClientMessage(playerid, light_yellow, "  upon reaching the required rank to choose a specfic class. You can do certain tasks to earn score, money, and EXP such as");
	SendClientMessage(playerid, light_yellow, "  capturing zones, repairing collapsed bridges, and many more tasks. There are up to 15 ranks and each has its own perks!");
	SendClientMessage(playerid, light_yellow, "");
    SendClientMessage(playerid, light_yellow, "* Type /commands or /cmds to get the full list of server commands.");
	return 1;
}

CMD:chelp(playerid, params[]) {
	switch (g_Player[playerid][p_Class]) {
	    case SOLDIER: {
	        SendClientMessage(playerid, light_yellow, "Help about SOLDIER class:");
			SendClientMessage(playerid, light_yellow, "  As a soldier, your primary task is to fight against enemy players, defend your base/zones and so on.");
			SendClientMessage(playerid, light_yellow, "  Soldier is a good class against on-foot infantry but weak against armed vehicles. The class is always");
			SendClientMessage(playerid, light_yellow, "  visible on radar and can drive a tank once you reach rank 5.");
			SendClientMessage(playerid, light_yellow, "");
			SendClientMessage(playerid, light_yellow, "Weapons: Combat Shotgun, M4, Desert Eagle and Teargas.");
	    }

	    case SNIPER: {
	        SendClientMessage(playerid, light_yellow, "Help about SNIPER class:");
	        SendClientMessage(playerid, light_yellow, "  Sniper is a stealthed class. Good against aircraft, weak against on-foot infantry such as soldier. This");
			SendClientMessage(playerid, light_yellow, "  class is always invisble on radar. One good thing about the class is that, you can take enemy players");
			SendClientMessage(playerid, light_yellow, "  down from a far distance using the sniper rifle.");
			SendClientMessage(playerid, light_yellow, "");
			SendClientMessage(playerid, light_yellow, "Weapons: Sniper Rifle, Silenced 9mm, MP5, Knife and Teargas.");
	    }

	    case ENGINEER: {
	        SendClientMessage(playerid, light_yellow, "Help about ENGINEER class:");
            SendClientMessage(playerid, light_yellow, "  As an engineer, you can repair team players' vehicle. Engineers can repair the collapsed bridges 2x faster than other");
			SendClientMessage(playerid, light_yellow, "  classes. This class is weak against on-foot infantry but good against armed vehicles. As the soldier class, engineers");
			SendClientMessage(playerid, light_yellow, "  are also visible on radar and can drive a tank once you reach rank 5.");
			SendClientMessage(playerid, light_yellow, "");
            SendClientMessage(playerid, light_yellow, "Weapons: Shotgun, Desert Eagle, Grenades, and Rocket Launcher.");
            SendClientMessage(playerid, light_yellow, "Weapons: /bridges, /rbridge, /fix.");
		}

		case PILOT: {
		    SendClientMessage(playerid, light_yellow, "Help about PILOT class:");
		    SendClientMessage(playerid, light_yellow, "  Pilot class can fly armed aircraft. It is a weak class on-foot but powerful with an aircraft. Each armed aircraft requires");
			SendClientMessage(playerid, light_yellow, "  a special rank meaning you must reach that rank in order to fly. This class is also visible on radar.");
			SendClientMessage(playerid, light_yellow, "");
			SendClientMessage(playerid, light_yellow, "Weapons: Shotgun, 9mm, MP5 and Teargas.");
		}

		case SUPPORTER: {
            SendClientMessage(playerid, light_yellow, "Help about SUPPORTER class:");
			SendClientMessage(playerid, light_yellow, "  As a supporter, you can earn rewards by supplying your team mates with weapons, armour and health in the selected zone. In order to");
			SendClientMessage(playerid, light_yellow, "  supply, you need a Cargobob or Barracks, you must load the supplies from Ammunation first. Head to the Ammunation zone then type '/load'");
			SendClientMessage(playerid, light_yellow, "  start loading. Once loaded, head to the selected zone and use '/supply' to supply. This is a medium skilled class meaning it is good against");
			SendClientMessage(playerid, light_yellow, "  both armed vehicles and on-foot infantry. Supporters can be invisble on radar by using '/stealth' but only for a minute.");
			SendClientMessage(playerid, light_yellow, "");
			SendClientMessage(playerid, light_yellow, "Weapons: Combat Shotgun, Desert Eagle, MP5, Rocket Launcher and Grenades.");
			SendClientMessage(playerid, light_yellow, "Commands: /load, /supply");
		}

		case ASSAULT: {
            SendClientMessage(playerid, light_yellow, "Help about ASSAULT class:");
			SendClientMessage(playerid, light_yellow, "  Assaults are like a combination of both Soldier and Sniper class. Means that the class is invisble on radar, having a");
			SendClientMessage(playerid, light_yellow, "  sniper rifle and can drive a tank at rank 5. This class is powerful against both on-foot infantry and armed vehicles.");
			SendClientMessage(playerid, light_yellow, "");
			SendClientMessage(playerid, light_yellow, "Weapons: Combat Shotgun, Desert Eagle, AK-47, Sniper Rifle, MP5 and Knife.");
		}

		case DEMOLISHER: {
			SendClientMessage(playerid, light_yellow, "Help about DEMOLISHER class:");
			SendClientMessage(playerid, light_yellow, "  A class specially made to destroy the bridges at certain zones. You can buy bombs from your base weapon shops and plant");
			SendClientMessage(playerid, light_yellow, "  them at the targeted bridge. You will be rewarded with score and money after the targeted bridge collapses. This class is");
			SendClientMessage(playerid, light_yellow, "  very weak against on-foot infantry but good against armed vehicles.");
			SendClientMessage(playerid, light_yellow, "");
			SendClientMessage(playerid, light_yellow, "Weapons: AK-47, 9mm, Rocket Launcher and Grenades.");
			SendClientMessage(playerid, light_yellow, "Commands: /plant");
		}

		case SUICIDE_BOMBER: {
		    SendClientMessage(playerid, light_yellow, "Help about SUICIDE BOMBER class:");
			SendClientMessage(playerid, light_yellow, "  Purpose of this class is to kill enemy players by committing suicide near them. The reward depends on how many enemy players");
			SendClientMessage(playerid, light_yellow, "  you kill. If you get killed by an enemy player and there are some enemies around you, they will also die and you will get the");
			SendClientMessage(playerid, light_yellow, "  reward. However, you will also get your deaths increased upon committing suicide. This class is very weak against both on-foot");
			SendClientMessage(playerid, light_yellow, "  infantry and armed vehicles and is visible on radar.");
			SendClientMessage(playerid, light_yellow, "");
			SendClientMessage(playerid, light_yellow, "Weapons: Country Rifle, 9mm, Chainsaw and Molotov Cocktails.");
			SendClientMessage(playerid, light_yellow, "Commands: /suicide");
		}

		case DONOR: {
		    SendClientMessage(playerid, light_yellow, "Help about DONOR class:");
		    SendClientMessage(playerid, light_yellow, "  Donor class is a global class meaning that this class can do everything such as flying armed aircrafts, armed vehicles, invisible");
			SendClientMessage(playerid, light_yellow, "  on radar like the Sniper class and such. This class is powerful against both armed vehicles and on-foot infantry.");
			SendClientMessage(playerid, light_yellow, "");
			SendClientMessage(playerid, light_yellow, "Weapons: Combat Shotgun, Desert Eagle, Sniper Rifle, M4 and Micro UZI.");
		}
		default: return 1;
	}
	return 1;
}

CMD:bdhelp(playerid, params[]) {
    SendClientMessage(playerid, light_yellow, "Help about 'Base Defense' feature:");
    SendClientMessage(playerid, light_yellow, "  This feature allows you to destroy the enemy players' aircraft in your base's airspace. Every team, excluding Mercenary and");
	SendClientMessage(playerid, light_yellow, "  Terrorist, have their own base defense missile launcher in their home base. In order to launch, go to the base defense launcher");
	SendClientMessage(playerid, light_yellow, "  and pick its pickup, you need to be rank 2+ and have $20000. You will receive score, money, XP and kills depending on how many");
	SendClientMessage(playerid, light_yellow, "  aircraft you destroy. The missile launcher takes 2 minutes to fully charge once used.");
	return 1;
}

CMD:abhelp(playerid, params[]) {
    SendClientMessage(playerid, light_yellow, "Help about 'Andromada Bombing' feature:");
    SendClientMessage(playerid, light_yellow, "  With this feature, you can drop bombs at the targeted base using the Andromada from Las Venturas Airport. In order to use this");
	SendClientMessage(playerid, light_yellow, "  feature, your team must have the Las Venturas Airport captured. You must fly the plane on the targeted base's airspace and press");
	SendClientMessage(playerid, light_yellow, "  the 'spacebar' key to drop. Only Pilot and Donor classes are authorized to fly this plane. When you drop the bombs at the selected");
	SendClientMessage(playerid, light_yellow, "  base, it will kill all the players in it. You will receive the reward depending on the amount of players you kill. Once bombed, the");
	SendClientMessage(playerid, light_yellow, "  plane takes some time to be fully loaded again.");
	return 1;
}

CMD:nukehelp(playerid, params[]) {
    SendClientMessage(playerid, light_yellow, "Help about 'Nuclear' feature:");
    SendClientMessage(playerid, light_yellow, "  The nuclear feature allows you to kill enemy players in certain zones/bases. In order to launch, you must be rank 8+, have Area51 captured");
	SendClientMessage(playerid, light_yellow, "  and have $200000. The bomb kills all the enemy players in the targeted area, you will earn XP, score, money and kills depending on the amount of");
	SendClientMessage(playerid, light_yellow, "  players you kill. Once the nuclear bomb has been launched, it will take 10 minutes to be fully charged again. You can see the remaining time");
	SendClientMessage(playerid, light_yellow, "  by typing '/nuketime'. Nuclear effect will remain in the targeted area and players in that area will lose -5 health every 30 seconds. However,");
	SendClientMessage(playerid, light_yellow, "  players with anti teargas mask will not be affected. To see which area is affected, type '/affected'. The effect will last until the bomb is");
	SendClientMessage(playerid, light_yellow, "  ready to be used again i.e 10 minutes but if your team has Abandoned Airport captured, you can wipe out the effect which will cost you $20000");
	SendClientMessage(playerid, light_yellow, "  but you will also get some XP and score. You also need to be rank 2+ to wipe the effect out.");
	return 1;
}

CMD:bridgehelp(playerid, params[]) {
    SendClientMessage(playerid, light_yellow, "Help about 'Bridge' system:");
    SendClientMessage(playerid, light_yellow, "  This is a system in which the Demolisher class from Terrorist team can demolish the bridges using bombs to earn score, money and XP.");
	SendClientMessage(playerid, light_yellow, "  Similarly, players from other teams can repair the damaged bridges to earn the reward. The team must capture the zone of the damaged");
	SendClientMessage(playerid, light_yellow, "  bridge in order to repair. Any class can repair the damaged bridges but Engineers can repair 2x faster.");
    SendClientMessage(playerid, light_yellow, "");
	SendClientMessage(playerid, light_yellow, "Associated commands: /rbridge, /plant, /bridges");
	return 1;
}

CMD:commands(playerid, params[]) {
	SendClientMessage(playerid, blue, "General server commands:");
	SendClientMessage(playerid, blue, "  /sync, /rpm, /pm, /donors, /admins, /report, /radio (/r), /teams, /ranks, /rank, /kill, /stats, /sp");
	SendClientMessage(playerid, blue, "  /reclass (/rc), /scmds, /spree, /switchteam (/st), /notes, /settings (/set), /qdm, /chelp, /bdhelp, /abhelp");
	SendClientMessage(playerid, blue, "  /bridgehelp, /rbridge, /bridges, /nukehelp, /plant, /load, /supply, /nuketime, /affected, /richlist, /savestats");
    SendClientMessage(playerid, blue, "  /dnd, /irc");
	admin_CommandMessage(playerid, "commands - /cmds");
	return 1;
}

CMD:scmds(playerid, params[]) {
	SendClientMessage(playerid, lime, "Squad commands:");
	SendClientMessage(playerid, lime, "  /squads, /screate, /sinfo, /invite, /quitsquad, /skick, /sname, /sdrop");
    admin_CommandMessage(playerid, "scmds");
	return 1;
}

CMD:cmds(playerid, params[]) {
	return cmd_commands(playerid, params);
}

CMD:affected(playerid, params[]) {
	if (g_Nuke[nuke_AffectedArea] != -1) {
 		SendClientMessage(playerid, light_green, sprintf("* Area currently affected by the nuclear bomb: %s.", nuke_ReturnAffectedAreaName()));
		admin_CommandMessage(playerid, "affected");
	}
	else
		SendClientMessage(playerid, red, "None of the area is affected by the nuclear bomb.");
	return 1;
}

CMD:sync(playerid, params[]) {
    if (IsPlayerInAnyVehicle(playerid)) {
		return SendClientMessage(playerid, red, "You cannot sync inside a vehicle.");
	}

	if (g_Player[playerid][p_Protected] != 0) {
		return SendClientMessage(playerid, red, "Please wait...");
	}

	if (GetPVarInt(playerid, "DUTY") == 1) {
		return SendClientMessage(playerid, red, "You cannot use this command while on admin duty.");
	}

	if (!IsEnemyNear(playerid, 30.0)) {
	    if (gettime() < g_SyncInfo[playerid][s_Time]) {
			return SendClientMessage(playerid, red, "You can only sync once every 2 minutes.");
		}

		Synchronize(playerid);
		SendClientMessage(playerid,light_yellow, "Synchronized.");
		g_SyncInfo[playerid][s_Time] = gettime() + 120;
		admin_CommandMessage(playerid, "sync");
	}
	return 1;
}

CMD:rpm(playerid, params[]) {
	if (sscanf(params, "s[128]", params)) {
		return SendClientMessage(playerid, grey, "Usage: /rpm <message>");
	}
	
	if(g_Player[playerid][p_Muted] >= gettime()) {
	    return MuteWarn(playerid), 0;
	}
	
	if (strlen(params) > 110) {
		return SendClientMessage(playerid, red, "Your message is too long.");
	}

	if (IsValidTargetPlayer(playerid, g_Player[playerid][p_LastPM])) {
	    if(GetPVarInt(g_Player[playerid][p_LastPM], "var_DND") == 1) {
			return SendClientMessage(playerid, red, "Specified player is currently on DND mode.");
		}
	
	    if (CheckIP(playerid, params)) {
			SendClientMessage(playerid, yellow, sprintf("R.PM sent to %s[%i]: %s", g_Player[g_Player[playerid][p_LastPM]][p_Name], g_Player[playerid][p_LastPM], params));
			SendClientMessage(g_Player[playerid][p_LastPM], yellow, sprintf("PM from %s[%i]: %s", g_Player[playerid][p_Name], playerid, params));
			admin_SendMessage(grey, sprintf("PM: %s > %s: %s", g_Player[playerid][p_Name], g_Player[g_Player[playerid][p_LastPM]][p_Name], params));
		}
	}
	return 1;
}

CMD:pm(playerid, params[]) {
	new id;
	if (sscanf(params, "us[128]", id, params)) {
		return SendClientMessage(playerid, grey, "Usage: /pm <id/name> <message>");
	}
	
	if(g_Player[playerid][p_Muted] >= gettime()) {
	    return MuteWarn(playerid), 0;
	}
	
	if (strlen(params) > 110) {
		return SendClientMessage(playerid, red, "Your message is too long.");
	}
	
	if(GetPVarInt(id, "var_DND") == 1) {
		return SendClientMessage(playerid, red, "Specified player is currently on DND mode.");
	}
	
	if (IsValidTargetPlayer(playerid, id)) {
		if (id == playerid) {
			return SendClientMessage(playerid, red, "You cannot PM yourself.");
		}
		if (CheckIP(playerid, params)) {
			PlayerPlaySound(id, 1085, 0.0, 0.0, 0.0);
			g_Player[playerid][p_LastPM] = id;

			SendClientMessage(playerid, yellow, sprintf("PM sent to %s[%i]: %s", g_Player[id][p_Name], id, params));
			SendClientMessage(id, yellow, sprintf("PM from %s[%i]: %s", g_Player[playerid][p_Name], playerid, params));

			admin_SendMessage(grey, sprintf("PM: %s > %s: %s", g_Player[playerid][p_Name], g_Player[id][p_Name], params));
		}
	}
	return 1;
}

CMD:donors(playerid, params[]) {
    new count=0;
    admin_CommandMessage(playerid, "donors");
    SendClientMessage(playerid, purple, "Online donors:");
	foreach(new i : Player) {
	    if (g_Player[i][p_Donor] >= 1) {
		    SendClientMessage(playerid, purple, sprintf("  Donor %s[%d] - Rank %i", g_Player[i][p_Name], i, g_Player[i][p_Donor]));
		    count++;
		}
	}
	if (!count) {
	 	return SendClientMessage(playerid, red, "- None -");
	}
	return 1;
}

CMD:admins(playerid, params[]) {
   	new count=0;
   	admin_CommandMessage(playerid,"admins");
 	SendClientMessage(playerid, 0xA6D398FF, "Admins:");
	foreach(new i : Player) {
		if (g_Player[i][p_Level] >= 1) {
		    if (g_Player[playerid][p_Level] > 0) {
			    SendClientMessage(playerid, 0xA6D398FF, sprintf("  %s[%i] - Level %i", g_Player[i][p_Name],i, g_Player[i][p_Level]));
				count++;
			}
			else {
				if (GetPVarInt(i, "DUTY") == 1) {
					SendClientMessage(playerid, 0xA6D398FF, sprintf("  %s[%i] - Level %i", g_Player[i][p_Name],i, g_Player[i][p_Level]));
					count++;
				}
				else
				    break;
			}
		}
	}
	if (!count) {
		return SendClientMessage(playerid, red, "- None -");
	}
	return 1;
}

CMD:nuketime(playerid, params[]) {
	SendClientMessage(playerid, light_grey, sprintf("* The nuclear bomb will be ready in %i minutes.", ConvertTime(g_Nuke[nuke_Time], MINUTES)));
	admin_CommandMessage(playerid, "nuketime");
	return 1;
}

CMD:report(playerid, params[]) {
	new id;
  	if(sscanf(params, "us[36]", id, params)) {
	  	return SendClientMessage(playerid, grey, "Usage: /report <playerid/name> <reason>");
	}

	if(strlen(params) > 30) {
		return SendClientMessage(playerid, red, "Reason length exceeds maximum characters limit. Limit: 30 chars.");
	}

	if(IsValidTargetPlayer(playerid, id)) {
		admin_SendReport(id, playerid, params);
	    SendClientMessage(playerid, yellow, sprintf("You have reported %s. | Reason: %s |", g_Player[id][p_Name], params));
	    SendClientMessage(playerid, yellow, "Please be patient until an admin checks your report.");
	}
    return 1;
}

CMD:radio(playerid, params[]) {
	if (g_Player[playerid][p_Team] == 6) {
		return 0;
	}

	if (sscanf(params, "s[128]", params)) {
		return SendClientMessage(playerid, grey, "Usage: /r <text>");
	}
	
 	if(g_Player[playerid][p_Muted] >= gettime()) {
	    return MuteWarn(playerid), 0;
	}
    if (CheckIP(playerid, params)) {
		team_SendMessage(g_Player[playerid][p_Team], 0xBADCDCFF, sprintf("[R] [%d]%s: %s", playerid, g_Player[playerid][p_Name], params));
		foreach(new i : Player) {
			if (g_Player[i][p_Level] > 0) {
				if (i != playerid) {
					SendClientMessage(i, grey, sprintf("[R] [%d]%s: %s", playerid, g_Player[playerid][p_Name], params));
				}
			}
		}
	}
	return 1;
}

CMD:r(playerid, params[]) {
	return cmd_radio(playerid, params);
}

CMD:teams(playerid, params[]) {
	foreach(new i : Teams) {
		SendClientMessage(playerid, -1, sprintf("Team: {%06x}%s {%06x}- Players: %d", (g_TeamInfo[i][t_Color] >>> 8), g_TeamInfo[i][t_Name], (-1 >>> 8), g_TeamInfo[i][t_Players]));
	}

	admin_CommandMessage(playerid, "teams");
	return 1;
}

CMD:ranks(playerid, params[]) {
	SendClientMessage(playerid, -red, "Ranks:");
	for(new i = 0; i < MAX_RANKS; i++) {
	    SendClientMessage(playerid, -1, sprintf("   Rank %i (%s) | Requires %i XP", i, g_RankInfo[i][r_Name], g_RankInfo[i][r_Exp]));
	}

	admin_CommandMessage(playerid, "ranks");
	return 1;
}

CMD:rank(playerid, params[]) {
    new id;
	if (sscanf(params, "u", id))
		id = playerid;
	else
		id = strval(params);
	if (IsValidTargetPlayer(playerid, id)) {
		if (id == playerid) {
			SendClientMessage(playerid, light_green, sprintf("Your current rank is %i (%s) - EXP: %i", g_Player[playerid][p_Rank], g_RankInfo[g_Player[playerid][p_Rank]][r_Name], g_Player[playerid][p_EXP]));
			SendClientMessage(playerid, grey, "* You can also use '/rank <playerid/name>' to see other player's rank.");
			admin_CommandMessage(playerid, "stats");
		}
		else {
			SendClientMessage(playerid, light_green, sprintf("%s's rank is %i (%s) - EXP: %i", g_Player[id][p_Name], g_Player[id][p_Rank], g_RankInfo[g_Player[id][p_Rank]][r_Name], g_Player[id][p_EXP]));
			admin_CommandMessage(playerid, "stats", id);
		}
	}
	return 1;
}

CMD:kill(playerid, params[]) {
	if (g_Player[playerid][p_Protected] != 0) {
		return SendClientMessage(playerid, red, "Please wait...");
	}

	if (GetPVarInt(playerid, "DUTY") == 1) {
		return SendClientMessage(playerid, red, "You cannot use this command while on admin duty.");
	}

	if (IsPlayerInAnyVehicle(playerid)) {
		return SendClientMessage(playerid, red, "Cannot use this command inside a vehicle.");
	}

	if (!IsEnemyNear(playerid, 30.0)) {
		admin_CommandMessage(playerid, "kill");
		SetPlayerHealth(playerid,0.0);
	}
	return 1;
}

CMD:savestats(playerid, params[]) {
	if (GetPVarInt(playerid, "stats_Saved") > gettime()) {
	    return SendClientMessage(playerid, red, "You can only use this command once every 5 minutes.");
	}
	
    SaveStats(playerid);

	SendClientMessage(playerid, -1, "* Your stats have been saved.");
    SetPVarInt(playerid, "stats_Saved", gettime() + 300);
    return 1;
}

CMD:stats(playerid,params[]) {
	new id;
	if (sscanf(params, "u", id))
		id = playerid;
	else
		id = strval(params);
	if (IsValidTargetPlayer(playerid, id)) {
		if (id == playerid) {
			ShowPlayerStats(playerid, playerid);
			admin_CommandMessage(playerid, "stats");
		}
		else {
			ShowPlayerStats(id, playerid);
			admin_CommandMessage(playerid, "stats", id);
		}
	}
	return 1;
}

CMD:topstats(playerid, params[]) {
	SendClientMessage(playerid, -1, "Top stats:");
	admin_CommandMessage(playerid, "topstats");
	
	new
		id1 = -1, top_score = -500000,
		id2 = -1, top_money = -500000,
		id3 = -1, top_kills = -500000,
		id4 = -1, top_deaths = -500000,
		id5 = -1, Float:top_ratio = -500000.00,
		id6 = -1, top_xp = -500000;
		
	foreach(new i : Player) {
		if (top_score < g_Player[i][p_Score]) {
		    top_score = g_Player[i][p_Score];
			id1 = i;
		}
		
		if (top_money < g_Player[i][p_Money]) {
		    top_money = g_Player[i][p_Money];
		    id2 = i;
		}
		
		if (top_kills < g_Player[i][p_Kills]) {
		    top_kills = g_Player[i][p_Kills];
		    id3 = i;
		}
		
		if (top_deaths < g_Player[i][p_Deaths]) {
		    top_deaths = g_Player[i][p_Deaths];
		    id4 = i;
		}
		
		if (top_ratio < (Float:g_Player[i][p_Kills] / Float:g_Player[i][p_Deaths])) {
		    top_ratio = (Float:g_Player[i][p_Kills] / Float:g_Player[i][p_Deaths]);
		    id5 = i;
		}
		
		if (top_xp < g_Player[i][p_EXP]) {
		    top_xp = g_Player[i][p_EXP];
		    id6 = i;
		}
	}
	
	SendClientMessage(playerid, -1, sprintf("   TOP SCORE: %s - %i", g_Player[id1][p_Name], top_score));
	SendClientMessage(playerid, -1, sprintf("   TOP MONEY: %s - $%i", g_Player[id2][p_Name], top_money));
	SendClientMessage(playerid, -1, sprintf("   TOP KILLS: %s - %i", g_Player[id3][p_Name], top_kills));
	SendClientMessage(playerid, -1, sprintf("   TOP DEATHS: %s - %i", g_Player[id4][p_Name], top_deaths));
	SendClientMessage(playerid, -1, sprintf("   TOP RATIO: %s - %0.2f", g_Player[id5][p_Name], top_ratio));
	SendClientMessage(playerid, -1, sprintf("   TOP XP: %s - %i", g_Player[id6][p_Name], top_xp));
	return 1;
}

CMD:sp(playerid, params[]) {
	if (GetPVarInt(playerid, "DUTY") == 1) {
		return 1;
	}
	
    switch(g_Player[playerid][p_Team]) {
        case 0, 5, 6: {
			return 1;
		}
		
		default: {
			ShowSpawnPointList(playerid);
			admin_CommandMessage(playerid, "sp");
		}
	}
	return 1;
}

CMD:reclass(playerid, params[]) {
	if(g_Player[playerid][p_Team] == 6) {
	    return 0;
	}
	
	g_Player[playerid][p_SwitchClass] = 1;
	SendClientMessage(playerid, light_grey, "Reclassing after next death...");

	if (g_Player[playerid][p_SwitchTeam] == 1) {
        g_Player[playerid][p_SwitchTeam] = 0;
	}

	admin_CommandMessage(playerid, "reclass - /rc");
	return 1;
}

CMD:squads(playerid, params[]) {
	squad_ShowList(playerid);
	admin_CommandMessage(playerid, "squads");
	return 1;
}

CMD:screate(playerid, params[]) {
    if(g_Player[playerid][p_Team] == 6) {
	    return 0;
	}

    if(g_Player[playerid][p_SquadID] != -1) {
	    return SendClientMessage(playerid, red, "You are already in a squad.");
	}

	if(sscanf(params, "s[34]", params)) {
	    return SendClientMessage(playerid, grey, "Usage: /screate <squad name>");
	}
	
	if (strlen(params) > 15) {
	    return SendClientMessage(playerid, red, "Squad name exceeds the maximum characters limit. Limit: 15 chars.");
	}
	
	if (squad_IsNameTaken(params)) {
	    return SendClientMessage(playerid, red, "Squad with this name already exists.");
	}

	squad_Create(playerid, params);
    admin_CommandMessage(playerid, "createsquad");
	return 1;
}

CMD:sinfo(playerid, params[]) {
	new squadid;
	
	if (sscanf(params, "i", squadid))
	    squadid = g_Player[playerid][p_SquadID];
	else
	    squadid = strval(params);
	if (squadid == g_Player[playerid][p_SquadID]) {
	    if(squadid == -1) {
	        return SendClientMessage(playerid, red, "You are not in any squad.");
		}
		
		SendClientMessage(playerid, grey, "* You can also use /sinfo <squadid> to see the information of other squads.");
		squad_ShowInfo(playerid, g_Player[playerid][p_SquadID]);
	}
	else {
	    if (!squad_IsValid(squadid)) {
	        return SendClientMessage(playerid, red, "Squad with this ID does not exist.");
		}
		
	    squad_ShowInfo(playerid, squadid);
	}
	return 1;
}

CMD:invite(playerid, params[]) {
    if(g_Player[playerid][p_SquadID] == -1) {
        return SendClientMessage(playerid, red, "You need to be a leader of a squad to use this command");
	}

	new squadid = g_Player[playerid][p_SquadID];
	if(g_Squads[squadid][sq_Members][0] != playerid) {
		return SendClientMessage(playerid, red, "You need to ba leader of a squad to use this command");
	}

	new id;
	if(sscanf(params, "u", id)) {
	    return SendClientMessage(playerid, grey, "Usage: /invite <playerid/name>");
	}

	if(IsValidTargetPlayer(playerid, id)) {
	    if(g_Player[id][p_Team] != g_Player[playerid][p_Team]) {
	        return SendClientMessage(playerid, red, "You cannot invite enemy players.");
		}

		if(squad_CountMembers(squadid) == MAX_SQUAD_MEMBERS) {
	        return SendClientMessage(playerid, red, "This squad has reached the maximum amount of members.");
		}

		if(g_Player[id][p_SquadID] != -1) {
		    return SendClientMessage(playerid, red, "Specified player is already in a squad.");
		}
		
		if(GetPVarInt(id, "var_DND") == 1) {
			return SendClientMessage(playerid, red, "Specified player is currently on DND mode.");
		}

		GameTextForPlayer(id, "~n~~n~~n~~w~squad invitation~n~~w~received", 4000, 3);
		SendClientMessage(playerid, lime, sprintf("You sent a squad invitation to %s.", g_Player[id][p_Name]));
		SendClientMessage(id, aqua, sprintf("* You have received a squad invitation from %s. Press 'Y' to accept and 'N' to reject the invitation.", g_Player[playerid][p_Name]));

		SetPVarInt(id, "INVITED_SQUAD", squadid);
		SetPVarInt(id, "INVITED", 1);
		admin_CommandMessage(playerid, "invite", id);
	}
	return 1;
}

CMD:quitsquad(playerid, params[]) {
	if(g_Player[playerid][p_SquadID] == -1) {
	    return SendClientMessage(playerid, red, "You are not in any squad.");
	}

	SendClientMessage(playerid, -1, "You left the squad.");
	squad_RemovePlayer(playerid);
	admin_CommandMessage(playerid, "quitsquad");
	return 1;
}

CMD:skick(playerid, params[]) {
	if(g_Player[playerid][p_SquadID] == -1) {
	    return SendClientMessage(playerid, red, "You need to be a leader of a squad to use this command");
	}

	new squadid = g_Player[playerid][p_SquadID];
	if(g_Squads[squadid][sq_Members][0] != playerid) {
		return SendClientMessage(playerid, red, "You need to ba leader of a squad to use this command");
	}

	new id;
	if(sscanf(params, "u", id)) {
	    return SendClientMessage(playerid, grey, "Usage: /skick <playerid/name>");
	}

	if(IsValidTargetPlayer(playerid, id)) {
	    if(g_Player[id][p_SquadID] != squadid) {
	        return SendClientMessage(playerid, red, "Specified player is not a member of this squad.");
		}
		squad_RemovePlayer(id);
		squad_SendMessage(squadid, tomato, sprintf("[SQUAD] Leader %s has kicked %s.", g_Player[playerid][p_Name], g_Player[id][p_Name]));

		SendClientMessage(id, red, sprintf("You have been kicked out of this squad by leader %s.", g_Player[playerid][p_Name]));
        admin_CommandMessage(playerid, "skick", id);
	}
	return 1;
}

CMD:sname(playerid, params[]) {
	if(g_Player[playerid][p_SquadID] == -1) {
	    return SendClientMessage(playerid, red, "You need to be a leader of a squad to use this command");
	}

	new squadid = g_Player[playerid][p_SquadID];
	if(g_Squads[squadid][sq_Members][0] != playerid) {
		return SendClientMessage(playerid, red, "You need to be a leader of a squad to use this command");
	}

	if(sscanf(params, "s[15]", params)) {
	    return SendClientMessage(playerid, grey, "Usage: /sname <new name>");
	}
	
	if (strlen(params) > 15) {
	    return SendClientMessage(playerid, red, "Squad name exceeds the maximum characters limit. Limit: 15 chars.");
	}

	if (squad_IsNameTaken(params)) {
	    return SendClientMessage(playerid, red, "Squad with this name already exists");
	}
	
	squad_SendMessage(squadid, lime, sprintf("[SQUAD] The leader has changed the squad name from '%s' to '%s'.", g_Squads[squadid][sq_Name], params));
    format(g_Squads[squadid][sq_Name], 15, params);
    
	SendClientMessage(playerid, light_green, sprintf("You have changed this squad name to %s.", params));
	
	foreach(new i : SquadMembers[squadid]) {
	    UpdateLabel(g_Squads[squadid][sq_Members][i]);
	}
    admin_CommandMessage(playerid, "sname");
	return 1;
}

CMD:sdrop(playerid, params[]) {
	if(g_Player[playerid][p_SquadID] == -1) {
	    return SendClientMessage(playerid, red, "You need to be a leader of a squad to use this command.");
	}

	new squadid = g_Player[playerid][p_SquadID];
	if(g_Squads[squadid][sq_Members][0] != playerid) {
		return SendClientMessage(playerid, red, "You need to be a leader of a squad to use this command.");
	}

	squad_Drop(squadid);
	admin_CommandMessage(playerid, "sdrop");
	return 1;
}

CMD:rc(playerid, params[]) {
	return cmd_reclass(playerid, params);
}

CMD:spree(playerid, params[]) {
	new id;
	if (sscanf(params, "u", id))
		id = playerid;
	else
		id = strval(params);
	if (IsValidTargetPlayer(playerid, id)) {
		if (id == playerid) {
			SendClientMessage(playerid, orange, sprintf("You are currently on a killing spree with %i kills. (Session kills: %i)", g_Player[playerid][p_Streak], g_Player[playerid][p_SessionKills]));
			admin_CommandMessage(playerid, "spree");
			SendClientMessage(playerid, grey, "* You can also use /spree <playerid/name> to see other player's killing spree.");
		}
		else {
            SendClientMessage(playerid, orange, sprintf("%s is currently on a killing spree with %i kills. (Session kills: %i)", g_Player[id][p_Name], g_Player[id][p_Streak], g_Player[id][p_SessionKills]));
			admin_CommandMessage(playerid, "spree", id);
		}
	}
	return 1;
}

CMD:switchteam(playerid, params[]) {
	SendClientMessage(playerid, light_grey, "Returning to team selection after next death...");
    g_Player[playerid][p_SwitchTeam] = 1;
    ForceClassSelection(playerid);

	if (g_Player[playerid][p_SwitchClass] == 1) {
	    g_Player[playerid][p_SwitchClass] = 0;
	}

	admin_CommandMessage(playerid, "switchteam - /st");
	return 1;
}

CMD:st(playerid, params[]) {
	return cmd_switchteam(playerid, params);
}

CMD:notes(playerid, params[]) {
	SendClientMessage(playerid, -1, "[DSS] Call of Duty - Warground, TDM.");
	SendClientMessage(playerid, -1, "   Current version: 1.0 BETA 2 (Seecond Update)");
	SendClientMessage(playerid, -1, "Changelogs:");
	SendClientMessage(playerid, -1, "- We are up on IRC now! To join, connect to irc.avrintech.net. Channel: #codwg.");
    SendClientMessage(playerid, -1, "- Removed /register command. Now, new users can instantly register upon connecting to the server.");
	SendClientMessage(playerid, -1, "- Added the following commands: /savestats, /givegun, /irc, /dnd.");
    SendClientMessage(playerid, -1, "- Increased cash for newly registered players from $5000 to $25000.");
    SendClientMessage(playerid, -1, "- Fixed minor bugs.");
	return 1;
}

CMD:settings(playerid, params[]) {
    ShowPlayerDialog(playerid, D_SETTINGS, DIALOG_STYLE_LIST, "Settings", "Toggle helmet\nToggle mask\nToggle hit sound", "Select", "Close");
	admin_CommandMessage(playerid, "settings - /set");
	return 1;
}

CMD:set(playerid, params[]) {
	return cmd_settings(playerid, params);
}

CMD:suicide(playerid, params[]) {
    if (g_Player[playerid][p_Protected] != 0) {
		return SendClientMessage(playerid, red, "Please wait...");
	}
	
	if(g_Player[playerid][p_Team] != 5) {
	    return SendClientMessage(playerid, red, "Your team cannot use this command.");
	}
	
	if(g_Player[playerid][p_Class] != SUICIDE_BOMBER) {
	    return SendClientMessage(playerid, red, "Your class cannot use this command.");
	}
	
	SuicideBomb(playerid);
	return 1;
}

CMD:qdm(playerid, params[]) {
	if (g_Player[playerid][p_DM_ID] == 0) {
		return SendClientMessage(playerid, red, "You are not inside the DM arena.");
	}
	News(sprintf("~w~%s ~r~~h~~h~~h~has left the %s stadium", g_Player[playerid][p_Name], g_DM[g_Player[playerid][p_DM_ID]]));
	IRC_Echo(g_IRC_Conn[IRC_MAIN_CHANNEL], sprintf("14* %s has left the %s stadium.", g_Player[playerid][p_Name], g_DM[g_Player[playerid][p_DM_ID]]));
	
	g_Player[playerid][p_DM_ID] = 0;
	SetPlayerTeam(playerid, g_Player[playerid][p_Team]);
	SetPlayerColor(playerid, g_TeamInfo[g_Player[playerid][p_Team]][t_Color]);
	SetSpawnInfo(playerid, g_Player[playerid][p_Team], g_TeamInfo[g_Player[playerid][p_Team]][t_Skin], 0.0, 0.0, 0.0, 0.0, 0, 0, 0, 0, 0, 0);
	g_TeamInfo[g_Player[playerid][p_Team]][t_Players] += 1;
	
	SendClientMessage(playerid, red, "You left the DM arena.");
	SetPVarInt(playerid, "CLASSSPAWN", 1);
	SpawnPlayer(playerid);
	return 1;
}

CMD:dnd(playerid, params[]) {
	if(GetPVarInt(playerid, "var_DND") == 0) {
		SetPVarInt(playerid, "var_DND", 1);
		SendClientMessage(playerid, red, "DND mode enabled. You are no longer receiving private messages from other players.");
		SendClientMessage(playerid, grey, "Type /dnd again to disable.");
	}
	else {
 		SetPVarInt(playerid, "var_DND", 0);
		SendClientMessage(playerid, light_green, "DND mode disabled.");
	}
	admin_CommandMessage(playerid, "dnd");
	return 1;
}

CMD:givegun( playerid, params[] ) {
	new id, ammo;
	if (sscanf(params, "ui", id, ammo)) {
	    return SendClientMessage(playerid, grey, "Usage: /givegun <playerid/name> <ammo>");
	}
	
	if (IsValidTargetPlayer(playerid, id)) {
		if (IsPlayerInAnyVehicle(playerid)) {
		    return SendClientMessage(playerid, red, "You must be on foot to use this command.");
		}
		
	    if (RangeBetween(playerid, id) > 4.0) {
	        return SendClientMessage(playerid, red, "The player specified is not close to you.");
		}
		
		if (g_Player[playerid][p_Team] != g_Player[id][p_Team]) {
		    return SendClientMessage(playerid, red, "You cannot give your weapons to an enemy player.");
		}
		
		new current_weapon = GetPlayerWeapon(playerid);
		if (!current_weapon) {
		    return SendClientMessage(playerid, red, "You are not holding any weapons.");
		}
		
		if (ammo > GetPlayerAmmo(playerid)) {
		    return SendClientMessage(playerid, red, "You do not have that much ammo.");
		}
		
		GivePlayerWeapon(playerid, current_weapon, -ammo);
		GivePlayerWeapon(id, current_weapon, ammo);
		
		SendClientMessage(playerid, light_green, sprintf("You have given a weapon %s[%i] with %i rounds of ammo to player %s.", aWeaponNames[current_weapon], current_weapon, ammo, g_Player[id][p_Name]));
		SendClientMessage(id, light_green, sprintf("You have received a weapon %s[%i] with %i rounds of ammo from player %s.", aWeaponNames[current_weapon], current_weapon, ammo, g_Player[playerid][p_Name]));
		admin_CommandMessage(playerid, "givegun", id, ammo);
	}
	return 1;
}

CMD:plant(playerid, params[]) {
	if (g_Player[playerid][p_Team] != 5) {
	    return SendClientMessage(playerid, red, "Your team cannot use this command.");
	}

	if (g_Player[playerid][p_Class] != DEMOLISHER) {
	    return SendClientMessage(playerid, red, "Your class cannot use this command.");
	}

	if (IsPlayerInAnyVehicle(playerid)) {
	    return SendClientMessage(playerid, red, "You must on foot to use this command.");
	}

	new id = bridge_ReturnClosestID(playerid);
	if (id != -1) {
	    new already_planting = 0;
		foreach(new i : Player) {
		    if (g_Player[i][p_BridgeID] == id && g_Player[i][p_BridgeTimer] != 0) {
		        already_planting = 1;
		        break;
			}
		}

		if (already_planting == 1) {
		    return SendClientMessage(playerid, red, "Someone has already started planting the bombs at this bridge.");
		}

		if (g_Bridge[id][b_Status] == BRIDGE_COLLAPSED) {
		    return SendClientMessage(playerid, red, "This bridge is already collapsed.");
		}

		if (g_Player[playerid][p_HasBombs] == 0) {
		    return SendClientMessage(playerid, red, "You have no bombs to plant.");
		}

		if (g_Bridge[id][b_Planted] == true) {
	        return SendClientMessage(playerid, red, "The bombs have already been planted.");
		}

        if (g_Player[playerid][p_BridgeTimer] == 0) {
			g_Player[playerid][p_BridgeTimer] = gettime() + 5;
			g_Player[playerid][p_BridgeID] = id;

			GameTextForPlayer(playerid, "~n~~n~~w~planting~n~~w~please wait...", 7000, 3);
			ApplyAnimation(playerid, "BOMBER", "BOM_Plant_Loop", 1.1, 1, 0, 0, 0, 0);
			SendClientMessage(playerid, light_green, sprintf("You have started planting bombs at the %s.", g_Bridge[id][b_Name]));
		}
	}
	else
	    SendClientMessage(playerid, red, "You must be near the bridge's pickup in order to plant bombs.");
	return 1;
}

CMD:rbridge(playerid, params[]) {
	switch (g_Player[playerid][p_Team]) {
		case 5, 6: {
			return SendClientMessage(playerid, red, "Your team cannot use this command.");
		}

		default: {
		    if (IsPlayerInAnyVehicle(playerid)) {
		        return SendClientMessage(playerid, red, "You must be on foot to use this command.");
			}

		    new player_zone = zone_ReturnID(playerid), already_repairing = 0;
		    if (player_zone != -1) {
		        if (g_CapZone[player_zone][cz_Team] != g_Player[playerid][p_Team]) {
					return SendClientMessage(playerid, red, "Your team must capture this bridge in order to repair.");
				}

		        new bridgeid = bridge_ReturnIDByZone(player_zone);
				switch(g_Bridge[bridgeid][b_Status]) {
					case BRIDGE_FIXED: {
		            	return SendClientMessage(playerid, red, "This bridge is not collapsed.");
					}

					case BRIDGE_COLLAPSED: {
					    foreach(new i : Player) {
					        if (g_Player[i][p_BridgeID] == bridgeid && g_Player[i][p_BridgeTimer] != 0) {
								already_repairing = 1;
							}
					    }
					}
				}

				if (already_repairing == 1) {
				    return SendClientMessage(playerid, red, "Someone has already started repairing this bridge.");
				}

				if (g_Player[playerid][p_BridgeTimer] == 0) {
					switch (g_Player[playerid][p_Class]) {
					    case ENGINEER:
							g_Player[playerid][p_BridgeTimer] = gettime() + 10;

					    default:
							g_Player[playerid][p_BridgeTimer] = gettime() + 30;
					}

					g_Player[playerid][p_BridgeID] = bridgeid;
					GameTextForPlayer(playerid, "~n~~n~~w~repairing~n~~w~please wait...", 99999, 3);
					ApplyAnimation(playerid, "BOMBER", "BOM_Plant_Loop", 1.1, 1, 0, 0, 0, 0);

					SendClientMessage(playerid, light_green, sprintf("You have started repairing the %s.", g_Bridge[bridgeid][b_Name]));
					SendClientMessageToAll(light_yellow, sprintf("* %s from team %s is attempting to repair the %s.", g_Player[playerid][p_Name], g_TeamInfo[g_Player[playerid][p_Team]][t_Name], g_Bridge[bridgeid][b_Name]));
                    IRC_Echo(g_IRC_Conn[IRC_MAIN_CHANNEL], sprintf("10* %s from team %s is attempting to repair the %s.",  g_Player[playerid][p_Name], g_TeamInfo[g_Player[playerid][p_Team]][t_Name], g_Bridge[bridgeid][b_Name]));
				}
		    }
		    else
		        SendClientMessage(playerid, red, "You need to be in the bridge zone in order to repair it.");
		}
	}
	return 1;
}

CMD:bridges(playerid, params[]) {
	if (g_Player[playerid][p_Class] != ENGINEER) {
	    return SendClientMessage(playerid, red, "Only engineer class is authorized to use this command.");
	}
	new text[200];
	foreach(new i : Bridges) {
	    Format:text("%s%s%s\n", text, (g_Bridge[i][b_Status] == BRIDGE_FIXED) ? ("{BB2922}") : ("{8ABE63}"), g_Bridge[i][b_Name]);
	}
	ShowPlayerDialog(playerid, D_MSG, DIALOG_STYLE_LIST, "Collapsed bridges: green", text, "Close", "");
	return 1;
}

CMD:supply(playerid, params[]) {
	if (g_Player[playerid][p_Class] != SUPPORTER) {
	    return SendClientMessage(playerid, red, "Only supporter class is authorized to use this command.");
	}
	
	if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER) {
	    return SendClientMessage(playerid, red, "You need to be inside a vehicle (Cargobob or Barracks) to use this command.");
	}
	
	new vehicleid = GetPlayerVehicleID(playerid);
	switch (GetVehicleModel(vehicleid)) {
		case CARGOBOB, BARRACKS: {
		    if (g_Vehicle[vehicleid][v_Loaded] == false) {
		        return SendClientMessage(playerid, red, "This vehicle is empty.");
			}
			supporter_SupplyTeam(playerid);
		}
		
		default: {
		    return SendClientMessage(playerid, red, "You need to be inside a vehicle (Cargobob or Barracks) to use this command.");
		}
	}
	return 1;
}

CMD:richlist(playerid, params[]) {
    admin_CommandMessage(playerid, "richlist");

	new id[10], money[10], player_money;
	for(new i = 0; i < 10; i++) {
	    id[i] = -1;
	    money[i] = -500000;
	}
	SendClientMessage(playerid, -1, "Top richest players online:");
	foreach(new i : Player) {
	    player_money = GetPlayerMoney(i);
	    for(new j = 0; j < 10; ++j) {
	        if(player_money > money[j]) {
	            if(j != 9) {
	            	for(new k = 8; k >= j; k--) {
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
	for(new i = 0; i < 10; i++) {
	    if(id[i] < 0)
			break;

		SendClientMessage(playerid, -1, sprintf("   %d. %s(%d) - $%d", i + 1, g_Player[id[i]][p_Name], id[i], money[i]));
	}
	return 1;
}

CMD:load(playerid, params[]) {
    if (g_Player[playerid][p_Class] != SUPPORTER) {
	    return SendClientMessage(playerid, red, "Only supporter class is authorized to use this command.");
	}

	if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER) {
	    return SendClientMessage(playerid, red, "You need to be inside a vehicle (Cargobob or Barracks) to use this command.");
	}
	
	new zoneid = zone_ReturnID(playerid);
	
	if (zoneid == -1 || zoneid != 17) {
 		return SendClientMessage(playerid, red, "You need to be in the Ammunation zone to load.");
	}
	new vehicleid = GetPlayerVehicleID(playerid);
	switch (GetVehicleModel(vehicleid)) {
		case CARGOBOB, BARRACKS: {
		    if (g_Player[playerid][p_SupplyTime] != 0) {
		        return 1;
			}
			
		    if (g_Vehicle[vehicleid][v_Loaded] == true) {
		        return SendClientMessage(playerid, red, "This vehicle is already loaded.");
			}
			
 			TogglePlayerControllable(playerid, 0);
 			GameTextForPlayer(playerid, ""#TXT_LINE"~w~loading...", 20000, 3);
 			g_Player[playerid][p_SupplyTime] = gettime()+7;
		}

		default: {
		    return SendClientMessage(playerid, red, "You need to be inside a vehicle (Cargobob or Barracks) to use this command.");
		}
	}
	return 1;
}


/*
							   IRC commands (Admins)
*/
IRCCMD:ban(botid, channel[], user[], host[], params[])
{
	if(!IRC_IsOp(botid, channel, user))
        return IRC_Echo(channel, "5Error: Access denied.");

	new reason[50];
	if(sscanf(params, "s[24]s[50]", params, reason))
		return IRC_Echo(channel, "5Syntax: $ban <username> <reason>");

	if(strlen(reason) > 50)
	    return IRC_Echo(channel, "5Error: Reason length is too long.");

	new query[200], id = return_IDByName(params);
	if(id == -1) {
	    Query("SELECT `id`,`nick`,`ip` FROM `users` WHERE `nick`='%e' ORDER BY `id`", params);
		mysql_tquery(mysql, query, "IRC_Check_OfflineBan", "ssssi", channel, params, user, reason, 0);
		return 1;
	}
	else
	{
    	Query("INSERT INTO `bans` (id,nick,bannedby,date,ip,type,reason) VALUES ('%d','%e','%e',UTC_TIMESTAMP(),'%e','%e','%e')", g_Player[id][p_UserID], g_Player[id][p_Name], user, g_Player[id][p_Ip], "Permanent", reason);
		mysql_tquery(mysql, query, "ExecuteQuery", "i", res_none);
		SendClientMessageToAll(-1, sprintf("[IRC] {C52E32}Admin %s on IRC has banned player %s. | Reason: %s |", user, g_Player[id][p_Name], reason));
		IRC_Echo(channel, sprintf("5[Ban] Admin %s on IRC has banned player %s. | Reason: %s |", user, g_Player[id][p_Name], reason));
		KickEx(id, red, "You have been banned.");
	}
	return 1;
}

IRCCMD:tban(botid, channel[], user[], host[], params[]) {
    if(!IRC_IsOp(botid, channel, user)) {
        return IRC_Echo(channel, "5Error: Access denied.");
	}
	
	new hours, minutes, reason[50];
	if(sscanf(params, "s[24]iis[50]", params, hours, minutes, reason)) {
		return IRC_Echo(channel, "5Syntax: $tban <username> <hours> <minutes> <reason>");
	}
	
    if(strlen(reason) > 50) {
	    return IRC_Echo(channel, "5Error: Reason length is too long.");
	}
	
	new id = return_IDByName(params), query[250];
	if(id == -1) {
		Query("SELECT `id`,`nick`,`ip` FROM `users` WHERE `nick`='%e' ORDER BY `id`", params);
		mysql_tquery(mysql, query, "IRC_Check_OfflineBan", "ssssiii", channel, params, user, reason, 1, hours, minutes);
		return 1;
	}
	else
	{
     	new stamp = (hours * 3600) + (minutes * 60) + gettime();
		SendClientMessageToAll(-1, sprintf("[IRC] {C52E32}Admin %s on IRC has temporarily banned %s for %iH and %iM.", user, g_Player[id][p_Name], hours, minutes));
		SendClientMessageToAll(red, sprintf("Reason: %s", reason));
		IRC_Echo(channel, sprintf("5[Temp Ban] Admin %s on IRC has temporarily banned %s for%iH and %iM. | Reason: %s |", user, g_Player[id][p_Name], hours, minutes, reason));

		Query("INSERT INTO `bans` (id,nick,bannedby,date,ip,type,time,reason) VALUES ('%i','%e','%e',UTC_TIMESTAMP(),'%e','%e','%i','%e')", g_Player[id][p_UserID], g_Player[id][p_Name], user, g_Player[id][p_Ip], "Temporary", stamp, reason);
	    mysql_tquery(mysql, query, "ExecuteQuery", "i", res_none);
	    KickEx(id, red, "You have been banned.");
	}
	return 1;
}

IRCCMD:changename(botid, channel[], user[], host[], params[])
{
	if(!IRC_IsAdmin(botid, channel, user))
	    return IRC_Echo(channel, "5Error: Access denied.");

	new new_name[24];
	if(sscanf(params, "s[24]s[24]", params, new_name))
	    return IRC_Echo(channel, "5Syntax: $changename <username> <newname>");

	if(strlen(new_name) > 20 || strlen(new_name) <= 3)
	    return IRC_Echo(channel, "5Error: Characters should not be higher than 20 and lower than 3.");

 	if(!IsValidName(new_name))
	    return IRC_Echo(channel, "5Error: Invalid characters found.");

	if(!strcmp(params, new_name, true))
	    return IRC_Echo(channel, "5Error: New name cannot be the same.");

	new query[128], id = return_IDByName(params);
 	if(id != -1)
        return IRC_Echo(channel, "5Error: This user is currently online, name cannot be changed.");

	Query("SELECT `nick`,`id` FROM `bans` WHERE `nick`='%e' ORDER BY `id`", params);
    mysql_tquery(mysql, query, "IRC_ChangeName_Process1", "sssi", params, new_name, channel, 0);
	return 1;
}

IRCCMD:setadmin(botid, channel[], user[], host[], params[]) {
    if(!IRC_IsAdmin(botid, channel, user))
        return IRC_Echo(channel, "5Error: Access denied.");

	new newlevel;
	if(sscanf(params, "s[24]i", params, newlevel))
		return IRC_Echo(channel, "5Syntax: $setadmin <username> <level>");

    if(newlevel > 6)
		return IRC_Echo(channel, "5Error: Invalid level.");

	new query[128], id = return_IDByName(params);
	if(id == -1) {
        Query("SELECT `id`,`nick`,`level` FROM `users` WHERE `nick`='%e' ORDER BY `id`", params);
		mysql_tquery(mysql, query, "ExecuteQuery", "iis", res_set_level, newlevel, channel);
		return 1;
	}
	else
	{
		new oldlevel = g_Player[id][p_Level];
	 	g_Player[id][p_Level] = newlevel;

		if(oldlevel == newlevel)
			return IRC_Echo(channel, "5Error: Specified user's level has not been changed.");

		if(oldlevel > newlevel || oldlevel < newlevel) {
	       	IRC_Echo(channel, sprintf("10[Success] User %s's admin level has been set to %i. (Online)", g_Player[id][p_Name], newlevel));
	       	SendClientMessage(id, -1, sprintf("[IRC] {2ED1BD}%s has set your admin level to %i.", user, newlevel));
		}
		
		Query("UPDATE `users` SET `level`='%d' WHERE `id`='%d'", g_Player[id][p_Level], g_Player[id][p_UserID]);
		mysql_tquery(mysql, query, "ExecuteQuery", "i", res_none);
	}
	return 1;
}

IRCCMD:unban(botid, channel[], user[], host[], params[])
{
	if(!IRC_IsOp(botid, channel, user))
        return IRC_Echo(channel, "5Error: Access denied.");

    if(sscanf(params, "s[24]", params))
		return IRC_Echo(channel, "5Syntax: $unban <username/IP>");

	new query[128];
	Query("SELECT * FROM `bans` WHERE `nick`='%e' OR `ip`='%e' ORDER BY `id`", params, params);
	mysql_tquery(mysql, query, "IRC_Offline_Unban", "ss", channel, params);
	return 1;
}

IRCCMD:kick(botid, channel[], user[], host[], params[]) {
	if(!IRC_IsVoice(botid, channel, user))
        return IRC_Echo(channel, "5Error: Access denied.");

	new id;
	if(sscanf(params, "us[128]", id, params))
		return IRC_Echo(channel, "5Syntax: $kick <playerid/name> <reason>");

	if(IsValidTargetPlayer(-1, id, true, channel))
    {
		SendClientMessageToAll(-1, sprintf("[IRC] {C52E32}Admin %s on IRC has kicked player %s. | Reason: %s |", user, g_Player[id][p_Name], params));
		IRC_Echo(channel, sprintf("5[Kick] Admin %s has kicked  player %s. | Reason: %s |", user, g_Player[id][p_Name], params));
		KickEx(id, red, "You have been kicked.");
	}
	return 1;
}

/*
                              IRC commands (Users)
*/

IRCCMD:cmds(botid, channel[], user[], host[], params[]) {
	return IRC_Notice(botid, user, "Channel commands: $msg, $getid, $players, $getscore, $admins, $donors, $getrank");
}

IRCCMD:getrank(botid, channel[], user[], host[], params[]) {
	new id;
	if(sscanf(params, "u", id))
	 	return IRC_Echo(channel, "5Syntax: $getrank <playerid/name>");

	if(IsValidTargetPlayer(-1, id, true, channel)) {
		IRC_Echo(channel, sprintf("** %s's rank is %i (%s)", g_Player[id][p_Name], g_Player[id][p_Rank], g_RankInfo[g_Player[id][p_Rank]][r_Name]));
	}
	return 1;
}

/*IRCCMD:lastseen(botid, channel[], user[], host[], params[]) {
	if(sscanf(params, "s[24]", params)) {
		return IRC_Echo(channel, "5Syntax: $lastseen <username>");
	}
	
	if(return_PlayeridByName(params) != -1) {
		return IRC_Echo(channel, "5Error: Specified user is currently online.");
	}
	
	new query[128];
	Query("SELECT `lastonline` FROM `users` WHERE `nick`='%e'", params);
	mysql_tquery(mysql, query, "IRC_Check_LastSeen", "ss", channel, params);
	return 1;
}*/

IRCCMD:msg(botid, channel[], user[], host[], params[]) {
    if(sscanf(params, "s[128]", params)) {
		return IRC_Echo(channel, "5Syntax: $msg <message>");
	}
	
	if(strlen(params) > 100) {
		return IRC_Echo(channel, "5Error: Message length is too long.");
	}
	
	IRC_Echo(channel, sprintf("3[IRC] %s: %s", user, params));
	SendClientMessageToAll(-1, sprintf("[IRC] {76BE95}%s {%06x}%s", user, (-1 >>> 8), params));
	return 1;
}

// This is in-game command to send a message on irc channel
CMD:irc(playerid, params[]) {
	if(sscanf(params, "s[120]", params)) {
		return SendClientMessage(playerid, grey, "Usage: /irc <message>");
	}
	
	if(g_Player[playerid][p_Muted] == 0) {
	    if(strlen(params) > 120) {
            return SendClientMessage(playerid, red, "Message length exceeds the maximum character limit.");
		}
		
	    SendClientMessage(playerid, -1, sprintf("[To IRC] {%06x}%s", (-1 >>> 8), params));
    	IRC_Echo(g_IRC_Conn[IRC_MAIN_CHANNEL], sprintf("7[To IRC] %s[%i]: %s", g_Player[playerid][p_Name], playerid, params));
	}
	else {
		MuteWarn(playerid);
		return 1;
	}
	return 1;
}

IRCCMD:pm(botid, channel[], user[], host[], params[]) {
	new id;
	if(sscanf(params, "us[100]", id, params)) {
	    return IRC_Echo(channel, "5Syntax: $pm <playerid/name> <message>");
	}
	
	if(strlen(params) > 100) {
	    return IRC_Echo(channel, "5Error: Message length is too long.");
	}
	
	if(IsValidTargetPlayer(-1, id, true, channel)) {
		SendClientMessage(id, -1, sprintf("[IRC PM] {C60054}%s {%06x}%s", user, (-1 >>> 8), params));
	    IRC_Echo(channel, sprintf("5[IRC PM] %s > %s: %s", user, g_Player[id][p_Name], params));
	}
	return 1;
}

IRCCMD:getid(botid, channel[], user[], host[], params[]) {
	if(sscanf(params, "s[24]", params)) {
		return IRC_Echo(channel, "5Syntax: $getid <part of name>");
	}
	
	new count = 0;
	foreach(new i : Player) {
	    if(strfind(g_Player[i][p_Name], params, true) != -1) {
			count++;
			IRC_Echo(channel, sprintf("** %s's ID is %i", g_Player[i][p_Name], i));
		}
	}
	if(!count) {
		return IRC_Echo(channel, "5Error: Cannot find ID for this name.");
	}
	return 1;
}

IRCCMD:getscore(botid, channel[], user[], host[], params[]) {
	new id;
	if(sscanf(params, "u", id)) {
		return IRC_Echo(channel, "5Syntax: $getscore <playerid/name>");
	}
	
	if(IsValidTargetPlayer(-1, id, true, channel)) {
		IRC_Echo(channel, sprintf("** %s's score is %i", g_Player[id][p_Name], g_Player[id][p_Score]));
	}
	return 1;
}

IRCCMD:players(botid, channel[], users[], host[], params[]) {
	new count = 0, list[128];
	foreach(new i : Player) {
		Format:list("%s%s, ", list, g_Player[i][p_Name]);
		count++;
	}
	if(count)
		IRC_Echo(channel, sprintf("3Players:[%i/100] - %s", count, list));
	else
	    IRC_Echo(channel, "5There are no players online.");
	return 1;
}

IRCCMD:donors(botid, channel[], users[], host[], params[]) {
	new count = 0, list[128];
	foreach(new i : Player) {
	    if(g_Player[i][p_Donor] == 1) {
	        count++;
	        Format:list("%s%s, ", list, g_Player[i][p_Name]);
		}
	}
	if(count)
	    IRC_Echo(channel, sprintf("7Online donors: %s", list));
	else
	    IRC_Echo(channel, "5There are no donors online.");
	return 1;
}

IRCCMD:admins(botid, channel[], users[], host[], params[]) {
	new count = 0, list[128];
	foreach(new i : Player) {
	    if(g_Player[i][p_Level] > 0) {
	        count++;
	        Format:list("%s%s, ", list, g_Player[i][p_Name]);
		}
	}
	if(count)
	    IRC_Echo(channel, sprintf("3Online admins: %s", list));
	else
	    IRC_Echo(channel, "5There are no admins online.");
	return 1;
}
