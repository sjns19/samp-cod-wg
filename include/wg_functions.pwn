/******************************************************************************/
/*							 Player functions	  							  */
/******************************************************************************/
ShowCommandPage(playerid)
{
	new list[144];

	for (new i; i < sizeof(g_CmdTitle); i++)
	{
		Format:list("%s%s\n", list, g_CmdTitle[i]);
	}

	return ShowPlayerDialog(playerid, D_CMD_TITLE, DIALOG_STYLE_LIST, "Commands", list, "Select", "Cancel");
}

ShowCommands(playerid, cmd_id)
{
    new title[36], string[1300] = '\0';

	Format:title(g_CmdTitle[cmd_id]);

	for (new i; i < sizeof(g_Cmd); i++)
	{
		if (g_Cmd[i][cmd_ID] == cmd_id) 
		{
			Format:string("%s%s\n", string, g_Cmd[i][cmd_Text]);
		}
	}

	return ShowPlayerDialog(playerid, D_CMD, DIALOG_STYLE_TABLIST_HEADERS, title, string, "", "Back");
}


BuyableWeaponsList()
{
	new str[400], weaponid, price[2][7] = {{5000}, {10000}};

	for (new i = 0, j = 18; i < j; ++i)
	{
	    weaponid = g_BuyableWeaponID[i][0];
     	Format:str("%s"#sc_green"%s\t%s\n", str, aWeaponNames[weaponid], (i <= 1) ? (sprintf("$%i", price[i])) : ("_"));

	}
	
	Format:str(""#sc_white"Weapon\t"#sc_white"Price\n%s", str);
	
	return str;
}

Exceptional(exceptid, color, const string[])
{
	foreach(new i : Player)
	{
	    if (i == exceptid)
			continue;

		SendClientMessage(i, color, string);
	}
}

function return_Kick(playerid)
{
	return Kick(playerid);
}

KickEx(playerid, col, const string[])
{
	if (playerid != INVALID_PLAYER_ID)
	{
		SendClientMessage(playerid, col, string);
		SetTimerEx("return_Kick", 100, false, "i", playerid);
	}

	return 1;
}

log(text[])
{
	new query[300];
	
	strcat(query, "INSERT INTO `game_log` (log_date,log_text)");
	strcat(query, " VALUES(UTC_TIMESTAMP(),'%e')");
	Query(query, text);
	mysql_tquery(connection, query, "ExecuteQuery", "i", res_none);
	
	return 1;
}

UnmutePlayer(playerid)
{
    new query[100];

	Query("UPDATE `users` SET `mute_time`='0' WHERE `id`='%i'", Player(playerid, UserID));
	mysql_tquery(connection, query, "ExecuteQuery", "i", res_none);
    Var(playerid, MuteWarns) = 0;
	Player(playerid, Muted) = 0;
}

ProtectedSpawn(playerid)
{
    Var(playerid, ClassSpawned) = 1;
    SpawnPlayer(playerid);
}

JailPlayer(playerid, time)
{
    Player(playerid, Jailed) = time;
	SetPlayerVirtualWorld(playerid, playerid + 1995);
	SetPlayerPos(playerid, JAIL_X, JAIL_Y, JAIL_Z);
	SetPlayerInterior(playerid, INTERIOR_JAIL);
	ResetPlayerWeapons(playerid);

	if (Timer(playerid, Jail) == -1)
	{
		Timer(playerid, Jail) = SetTimerEx("timer_Jail", 1000, true, "i", playerid);
	}
}

WarnPlayer(id, admin[], params[])
{
	if (Var(id, Warns) >= 5)
	{
	    SendClientMessageToAll(c_tomato, sprintf("* Player %s[%i] has been kicked for exceeding the maximum admin warns.", playerName(id), id));
		IRC_Echo(g_IRC_Conn[IRC_MAIN_CHANNEL], sprintf("4* Player %s[%i] has been kicked for exceeding admin warns.", playerName(id), id));
		KickEx(id, c_red, "You have been kicked for exceeding admin warns.");
	}
	else
	{
	    new d_string[800];

		strcat(d_string, ""#sc_tomato"You have received a warning from admin "#sc_white"%s\n\n");
		strcat(d_string, ""#sc_tomato"Reason: "#sc_white"%s\n"#sc_tomato"Warns: "#sc_white"%i/5\n\n");
		strcat(d_string, "Please avoid such incident in the future and follow all the server rules.\n");
		strcat(d_string, "Further warnings may lead you to a punishment.");
		Format:d_string(d_string, admin, params, Var(id, Warns));
		ShowPlayerDialog(id, D_MSG, DIALOG_STYLE_MSGBOX, "WARNING", d_string, "Close", "");
		Var(id, Warned) = (gettime() + 10);
	}
}

return_WeaponSlotFromID(weaponid)
{
	new slot;
	
	switch (weaponid)
	{
		case 0: slot = W_FIST;
		case 4: slot = W_KNIFE;
		case 23: slot = W_SILENCED;
		case 24: slot = W_DESERT_EAGLE;
		case 25: slot = W_NORMAL_SHOTGUN;
		case 27: slot = W_COMBAT_SHOTGUN;
		case 28: slot = W_UZI;
		case 29: slot = W_MP5;
		case 30: slot = W_AK47;
		case 31: slot = W_M4;
		case 32: slot = W_TEC9;
		case 33: slot = W_RIFLE;
		case 34: slot = W_SNIPER;
		case 16, 35: slot = W_EXPLOSIVES;
		default: slot = -1;
	}
	
	return slot;
}

CountWeaponKills(playerid, weaponid)
{
	new slot;
	
	slot = return_WeaponSlotFromID(weaponid);

	if (slot != -1)
	{
		new query[100], output[128];

		++Player(playerid, WeaponKills)[slot];

		for (new i = 0, j = MAX_WEAPON_TYPE; i < j; i++)
		{
			Format:output("%s%i%s", output, Player(playerid, WeaponKills)[i], (i != MAX_WEAPON_TYPE - 1) ? (":") : (""));
		}
		
		Query("UPDATE `users` SET `weapkills`='%e' WHERE `id`='%i'", output, Player(playerid, UserID));
		mysql_tquery(connection, query, "ExecuteQuery", "i", res_none);
	}
}

weapon_Drop(playerid)
{
	new Float:x, Float:y, Float:z, dropped, world, weapon, ammo, model;

	weapon_RemovePickups(playerid);
	GetPlayerPos(playerid, x, y, z);
	world = GetPlayerVirtualWorld(playerid);

	for(new i = 0, j = MAX_WEAPON_SLOT; i < j; i++)
	{
	    GetPlayerWeaponData(playerid, i, weapon, ammo);

	    if (ammo > 0 || weapon == 1 && weapon != 0)
		{
			model = weapon_ReturnModel(weapon);

			if (model != -1)
			{
  				g_WD_Data[playerid][i][0] = weapon;
  				g_WD_Data[playerid][i][1] = ammo;
	        	g_WD_Data[playerid][i][2] = world;
				++dropped;
			}
	    }
	}

	if (dropped > 0)
	{
	    new radius;

	    if (dropped < 3)
			radius = 1;
		
		if (dropped < 6)
			radius = 2;
		
		if (dropped < 9)
			radius = 3;
		
		if (dropped > 8)
			radius = 4;

		new Float:degree, Float:tmp;

		degree = 360.0 / (float(dropped));
		tmp = degree;
		Var(playerid, WeapTime) = gettime() + 20;
		
		for(new i = 0, j = MAX_WEAPON_SLOT; i < j; i++)
		{
		    if (g_WD_Data[playerid][i][1] > 0 || g_WD_Data[playerid][i][0] == 1 && g_WD_Data[playerid][i][0] > 0)
			{
				model = weapon_ReturnModel(g_WD_Data[playerid][i][0]);
				
				if (model != -1)
				{
				    g_WD_DroppedX[playerid][i] = x + (floatsin(degree, degrees) * radius);
				    g_WD_DroppedY[playerid][i] = y + (floatcos(degree, degrees) * radius);
				    g_WD_DroppedZ[playerid][i] = z;
				    g_WD_Pickup[playerid][i] = CreateDynamicPickup(model, 1, g_WD_DroppedX[playerid][i], g_WD_DroppedY[playerid][i], g_WD_DroppedZ[playerid][i], world);
					degree = degree + tmp;
				}
		    }
		}

		g_HealthPickup[playerid] = CreateDynamicPickup(1240, 1, x + 3.0, y + 3.0, z, world);
		g_ArmourPickup[playerid] = CreateDynamicPickup(1242, 1, x - 3.0, y - 3.0, z, world);
	}

	return 1;
}

weapon_RemovePickups(playerid)
{
	Var(playerid, WeapTime) = 0;

    for(new i = 0, j = MAX_WEAPON_SLOT; i < j; i++)
	{
	    if (g_WD_Pickup[playerid][i] != -1)
		{
	        DestroyDynamicPickup(g_WD_Pickup[playerid][i]);
	        g_WD_Pickup[playerid][i] = -1;
	 		g_WD_Data[playerid][i][0] = -1;
	    	g_WD_Data[playerid][i][1] = -1;
	    	g_WD_Data[playerid][i][2] = -1;
	    	g_WD_DroppedX[playerid][i] = 0.0;
	    	g_WD_DroppedY[playerid][i] = 0.0;
	    	g_WD_DroppedZ[playerid][i] = 0.0;
	    }
	}

	if (g_HealthPickup[playerid] != -1 || g_ArmourPickup[playerid] != -1)
	{
		DestroyDynamicPickup(g_HealthPickup[playerid]);
		DestroyDynamicPickup(g_ArmourPickup[playerid]);
		g_HealthPickup[playerid] = -1;
		g_ArmourPickup[playerid] = -1;
	}
}

GiveVehicle(playerid, model, isvip = 0)
{
    new Float:x, Float:y, Float:z, Float:a, vehicleid, world, int, teamid;
	new engine, lights, alarm, doors, bonnet, boot, objective;

	GetPlayerPos(playerid, x, y, z);
	GetPlayerFacingAngle(playerid, a);
	PutPlayerInVehicle(playerid, CreateVehicle(model, x, y, z, a, 1, 0, 120), 0);

	vehicleid = GetPlayerVehicleID(playerid);
    int = GetPlayerInterior(playerid);
	world = GetPlayerVirtualWorld(playerid);
	
	GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
 	SetVehicleParamsEx(vehicleid, 1, 1, alarm, doors, bonnet, boot, objective);
	LinkVehicleToInterior(vehicleid, int);
	SetVehicleVirtualWorld(vehicleid, world);
	teamid = Player(playerid, Team);

	if (isvip)
	{
		new slot = 8;

		Var(playerid, Vehicle) = vehicleid;
		ChangeVehicleColor(vehicleid, g_TeamVehicleColors[teamid][0], g_TeamVehicleColors[teamid][1]);

		switch (model)
		{
	        case 560:
			{
				for (new i = 0; i != slot; i++)
				{
					AddVehicleComponent(vehicleid, g_VehicleMods[i][0]);
				}

				ChangeVehiclePaintjob(vehicleid, 2);
	        }
	        case 565:
			{
	            for (new i = 0; i != slot; i++)
				{
					AddVehicleComponent(vehicleid, g_VehicleMods[i][1]);
				}
				
				ChangeVehiclePaintjob(vehicleid, 2);
	        }
	    }
	}

	return 1;
}

update_fps(playerid)
{
    new p_drunklevel, fps;

	p_drunklevel = GetPlayerDrunkLevel(playerid);

    if (p_drunklevel < 100)
	{
        SetPlayerDrunkLevel(playerid, 2000);
    }
	else
	{
        if (Var(playerid, DrunkLevel) != p_drunklevel)
		{
            fps = (Var(playerid, DrunkLevel) - p_drunklevel);
			Var(playerid, DrunkLevel) = p_drunklevel;

            if (fps > 0 && fps < 256)
			{
                Var(playerid, FPS) = (fps - 1);
			}
		}
	}
}

SlapPlayer(playerid, Float:height)
{
	new Float:x, Float:y, Float:z, Float:a;

	GetPlayerPos(playerid, x, y, z);
	GetPlayerFacingAngle(playerid, a);
	SetPlayerPos(playerid, x, y, z + height);
	SetPlayerFacingAngle(playerid, a);
	SetCameraBehindPlayer(playerid);

	if (IsPlayerInAnyVehicle(playerid))
	{
	    RemovePlayerFromVehicle(playerid);
	}

	return 1;
}

UpdateLabel(playerid)
{
	new label[128], rank, teamid, class, squad;

	rank = Player(playerid, Rank);
	teamid = Player(playerid, Team);
	class = Player(playerid, Class);
	squad = Var(playerid, SquadID);
	Format:	label("%s\n%s\n%s%s", Rank(rank, Name), Team(teamid, Name), Class(class, Name),
	(squad == -1) ? ("") : (sprintf("\nS: %s", g_Squads[squad][sq_Name])));
	
	Update3DTextLabelText(Player(playerid, RankText), GetPlayerColor(playerid), label);
}

SetSkin(playerid, skinid)
{
	SetPlayerSkin(playerid, skinid);
	return TogglePlayerControllable(playerid, 1);
}

BanPlayer(playerid, type[], reason[], banby[], bool:auto = false, adminid = INVALID_PLAYER_ID)
{
	new query[220];

    Query("INSERT INTO `bans` (id,nick,bannedby,date,ip,type,reason,time) VALUES ('%d','%e','%e',UTC_TIMESTAMP(),'%e','%e','%e','0')",
		Player(playerid, UserID),
		Player(playerid, Name),
		banby,
		Player(playerid, Ip),
		type,
		reason);
	mysql_tquery(connection, query, "ExecuteQuery", "i", res_none);
	
	if (auto == true && adminid == INVALID_PLAYER_ID)
	{
		SendClientMessageToAll(c_tomato, sprintf("* Player %s[%i] has been banned by %s. <%s>", playerName(playerid), playerid, banby, reason));
        IRC_Echo(g_IRC_Conn[IRC_MAIN_CHANNEL], sprintf("4* Player %s has been banned by %s. <%s>", playerName(playerid), banby, reason));
	}
	else
	{
		SendClientMessageToAll(c_tomato, sprintf("* Administrator %s[%i] has banned player %s[%i].", banby, adminid, playerName(playerid), playerid));
		SendClientMessageToAll(c_tomato, sprintf("* Reason: %s", reason));
		IRC_Echo(g_IRC_Conn[IRC_MAIN_CHANNEL], sprintf("4* Administrator %s[%i] has banned player %s[%i]. Reason: %s", banby, adminid, playerName(playerid), playerid, reason));
	}

	KickEx(playerid, c_red, "You have been banned.");
	return 1;
}

ScreenMessage(playerid, title[], score[])
{
	Var(playerid, ScreenMsgTime) = gettime() + 2;
	PlayerTextDrawSetString(playerid, TD(playerid, ScreenMsg)[1], title);
    PlayerTextDrawSetString(playerid, TD(playerid, ScreenMsg)[2], score);
	
	for (new i = 0, j = 3; i != j; ++i)
	{
		PlayerTextDrawShow(playerid, TD(playerid, ScreenMsg)[i]);
	}
}

UpdateMap(playerid)
{
	new color, color2;

	color = GetPlayerColor(playerid);

    if (Var(playerid, Duty))
	{
	    foreach(new i : Player)
		{
		    if (i != playerid)
			{
		        color2 = GetPlayerColor(i);
				SetPlayerMarkerForPlayer(i, playerid, color);
				SetPlayerMarkerForPlayer(playerid, i, color2);
			}
		}
		return;
	}

	foreach(new i : Player)
	{
	    if (i != playerid)
		{
	        switch (Player(playerid, Class))
			{
	        	case SNIPER, ASSAULT: HideMarker(i, playerid);
				default: ShowMarker(i, playerid);
			}

			switch (Player(i, Class))
			{
		 		case SNIPER, ASSAULT: HideMarker(playerid, i);
				default: ShowMarker(playerid, i);
			}
		}
	}
}

SetPlayerClassSelection(playerid)
{
    TextDrawShowForPlayer(playerid, Server(Background));
    SetPlayerPos(playerid, cs_X, cs_Y, cs_Z);
    SetPlayerCameraPos(playerid, cs_CamX, cs_CamY, cs_CamZ);
    SetPlayerCameraLookAt(playerid, -1033.0557, 419.3903, 8.5120);
	ShowDialog(playerid, D_CLASS);

	return SetPlayerVirtualWorld(playerid, playerid + 7000);
}

return_NextScore(playerid)
{
	new ret, score, rank;
	
	score = Player(playerid, Score);
	rank = Player(playerid, Rank);
	ret = (score >= 100000) ? (100000) : Rank((rank + 1), Score);

	return ret;
}

UpdateRank(playerid)
{
    if (Player(playerid, Score) >= 0)
	{
		new r;

		for (r = MAX_RANKS - 1; r >= 0; r--)
		{
			if (Player(playerid, Score) >= Rank(r, Score))
				break;
		}

		Player(playerid, Rank) = r;
		PlayerTextDrawSetString(playerid, TD(playerid, Rank), sprintf("~l~%i", r));
		PlayerTextDrawSetString(playerid, TD(playerid, ScoreRank), sprintf("~y~~h~Score %i/%i~n~~y~~h~%s", Player(playerid, Score), return_NextScore(playerid), Rank(r, Name)));
	}
}

IsPlayerAllowedToChat(playerid, text[])
{
    if (Player(playerid, Muted))
		return MuteWarn(playerid), 0;
		
	if (!Var(playerid, Spawned))
		return SendClientMessage(playerid, c_red, "* You must spawn before sending a message."), 0;

	if (strlen(text) > 110)
		return SendClientMessage(playerid, c_red, "* Message exceeds the maximum character length."), 0;

	if (Player(playerid, ChatTime) > gettime())
		return SendClientMessage(playerid, c_red, "* Please do not spam."), 0;

	return 1;
}

SetPlayerInDM(playerid, dmid)
{
	new idx, skin, Float:x, Float:y, Float:z, Float:a;

	skin = Var(playerid, Skin);
	SetPlayerTeam(playerid, playerid + 1000);
	SetSkin(playerid, (skin) ? skin : 176);
	SetPlayerColor(playerid, c_lightyellow);
	Var(playerid, DM) = dmid;

    do idx = random(Server(SpawnPoints));
	while (Spawn(idx, DM) != dmid);

	x = Spawn(idx, X);
	y = Spawn(idx, Y);
	z = Spawn(idx, Z);
	
	SetPlayerPos(playerid, x, y, z + 1.0);
	SetPlayerFacingAngle(playerid, a);
	SetPlayerInterior(playerid, DM(dmid, Interior));
	SetPlayerVirtualWorld(playerid, DM(dmid, World));
	SetPlayerHealth(playerid, 100.0);
	SetPlayerArmour(playerid, 100.0);
	SetCameraBehindPlayer(playerid);
	Update3DTextLabelText(Player(playerid, RankText), 0xFFFFFF00, "");

	for (new i = 0, j = 3; i != j; i++)
	{
		GivePlayerWeapon(playerid, DM(dmid, Weapons)[i], 5000);
	}

	return 1;
}

RewardPlayer(playerid, _money, _score, bool:updateboard = false)
{
	Player(playerid, Money) += _money;

	if (_score)
	{
		Player(playerid, Score) += _score;
		UpdateRank(playerid);
	}

	if (updateboard == true)
	{
		UpdateBoard(playerid);
	}
}

Float:return_Ratio(playerid)
{
	new deaths;

	deaths = Player(playerid, Deaths);

	if (deaths < 1)
	{
		deaths = 1;
	}

	return floatdiv(Player(playerid, Kills), deaths);
}

ShowWeaponStats(id, playerid, bool:irc = false, channel[] = '\0')
{
	new str_1[128], str_2[128], w_name[22];
	
	for (new i = W_FIST, j = W_UZI; i < j; i++)
	{
	    Format:w_name("%s", g_WeaponKillsInName[i]);
		Format:str_1("%s%s: %i ", str_1, w_name, Player(id, WeaponKills)[i]);
	}

	for (new i = W_MP5, j = MAX_WEAPON_TYPE; i < j; i++)
	{
	    Format:w_name("%s", g_WeaponKillsInName[i]);
		Format:str_2("%s%s: %i ", str_2, w_name, Player(id, WeaponKills)[i]);
	}

	if (playerid != -1 && irc == false && channel[0] == '\0')
	{
		SendClientMessage(playerid, -1, "");
		SendClientMessage(playerid, 0x31C160FF, sprintf("* %s's kills with following weapons:", playerName(id)));
		SendClientMessage(playerid, 0x46D073FF, str_1);
		SendClientMessage(playerid, 0x5ED785FF, str_2);
		SendClientMessage(playerid, -1, "");
	}
	else
	{
		IRC_Echo(channel, sprintf("3* %s's kills with following weapons:", playerName(id)));
		IRC_Echo(channel, str_1);
		IRC_Echo(channel, str_2);
	}
}

ShowPlayerStats(id, playerid, bool: irc = false, channel[] = '\0')
{
	new tmp_class[25], rank, teamid, class, str[144];

	rank = Player(id, Rank);
	teamid = Player(id, Team);
	class = Player(id, Class);
	Format:tmp_class((!class) ? ("N/A") : (sprintf("%s", Class(class, Name))));

	if (playerid != -1 && irc == false && channel[0] == '\0')
	{
		SendClientMessage(playerid, -1, "");
  		Format:str("Name: %s, Team: %s, Class: %s, Score: %i/%i, Money: $%i", playerName(id), Team(teamid, Name), tmp_class, Player(id, Score), return_NextScore(id), Player(id, Money));
		SendClientMessage(playerid, 0x31C160FF, str);
		
		Format:str("Rank: %i %s, Kills: %i, Deaths: %i, Ratio: %.2f, Session kills: %i, Session deaths: %i Connected time: %s", rank, Rank(rank, Name), Player(id, Kills), Player(id, Deaths), return_Ratio(id), Player(id, SessionKills), Player(id, SessionDeaths), ReturnConnectedTime(id));
  		SendClientMessage(playerid, 0x46D073FF, str);
		
		Format:str("Captures: %i, Session captures: %i, Flags stolen: %i, Bullets shot: %i, Bullets hit: %i, Headshots: %i", Player(id, CapturedZones), Player(id, SessionCaps), Player(id, CapturedFlags), Var(id, BulletsShot), Var(id, BulletsHit), Player(id, Headshots));
  		SendClientMessage(playerid, 0x5ED785FF, str);
		SendClientMessage(playerid, -1, "");
	}
	else
	{
	    IRC_Echo(channel, sprintf("7Statistics of player: %s", playerName(id)));
		IRC_Echo(channel, sprintf("7Team: %s, Class: %s, Score: %i/%i, Money: $%i, Rank: %i (%s)", Team(teamid, Name), tmp_class, Player(id, Score), return_NextScore(id), Player(id, Money), rank, Rank(rank, Name)));
		IRC_Echo(channel, sprintf("7Kills: %i, Deaths: %i, Ratio: %.2f, Session kills: %d, Session deaths: %d, Connected time: %s", Player(id, Kills), Player(id, Deaths), return_Ratio(id), Player(id, SessionKills), Player(id, SessionDeaths), ReturnConnectedTime(id)));
		IRC_Echo(channel, sprintf("7Captures: %i, Session captures: %i, Flags stolen: %i, Bullets shot: %i, Bullets hit: %i, Headshots", Player(id, CapturedZones), Player(id, SessionCaps), Player(id, CapturedFlags), Var(id, BulletsShot), Var(id, BulletsHit), Player(id, Headshots)));
	}
}

ShowVIPFeatures(id, playerid)
{
	new boost, helmet, mask;
	
	boost = Player(id, BoostActivated);
	helmet = Player(id, HelmetActivated);
	mask = Player(id, MaskActivated);
	SendClientMessage(playerid, c_lightyellow, sprintf("%s's VIP features:", playerName(id)));
	SendClientMessage(playerid, c_lightyellow, sprintf("   VIP level: %i (%s) - Expires in %i days", Player(id, VIP), g_VIPName[Player(id, VIP)], ConvertTime(Player(id, VIP_Time), DAYS)));
	SendClientMessage(playerid, c_lightyellow, sprintf("   VIP boost activated: %s", return_ItemStatus(boost)));
	SendClientMessage(playerid, c_lightyellow, sprintf("   Helmet activated: %s", return_ItemStatus(helmet)));
	SendClientMessage(playerid, c_lightyellow, sprintf("   Mask activated: %s", return_ItemStatus(mask)));
}

function StopEffect(playerid)
{
	return ApplyAnimation(playerid, "ped", "IDLE_tired", 4.1, 0, 0, 0, 0, 0);
}

MuteWarn(playerid)
{
    if (++Var(playerid, MuteWarns) >= 5)
	{
     	SendClientMessageToAll(c_red, sprintf("* Player %s has been kicked by %s. <Exceeding mute warns>", playerName(playerid), bot));
        IRC_Echo(g_IRC_Conn[IRC_MAIN_CHANNEL], sprintf("4* Player %s has been kicked by %s. <Exceeding mute warns>", playerName(playerid), bot));
		return KickEx(playerid, c_red, "You have been kicked for exceeding mute warns.");
	}

	SendClientMessage(playerid, c_red, sprintf("WARNING: You are currently muted, repeated chat attempts will be result in kick. (Warnings: %i/5)", Var(playerid, MuteWarns)));
	return 1;
}

TimeoutPlayer(playerid, bool:step)
{
	Var(playerid, Timeout) = step;
	SendRconCommand(sprintf("%s %s", (step) ? ("banip") : ("unbanip"), Player(playerid, Ip)));
	
	if (!step)
	{
		IRC_Echo(g_IRC_Conn[IRC_ADMIN_CHANNEL], sprintf("0,5 SERVER NOTICE  Timeout on player %s (ID: %i) (Possible cheat detected)", playerName(playerid), playerid));
	}
}

UpdateBoard(playerid)
{
	new tmp_class[25], class;

	class = Player(playerid, Class);
	Format:tmp_class((!class) ? ("N/A") : (sprintf("%s", Class(class, Name))));
	PlayerTextDrawSetString(playerid, TD(playerid, Board_Contents), sprintf("~w~~h~%s~n~%i~n~%i~n~%.2f", tmp_class, Player(playerid, Kills), Player(playerid, Deaths), return_Ratio(playerid)));
    PlayerTextDrawShow(playerid, TD(playerid, Board_Contents));
}

ToggleMask(playerid, toggle)
{
    Var(playerid, Mask) = toggle;

	switch (toggle)
	{
	    case 0: REMOVEMASK(playerid);
		case 1: PUTMASK(playerid);
	}

	return 1;
}

ToggleHelmet(playerid, toggle)
{
    Var(playerid, Helmet) = toggle;

	switch (toggle)
	{
	    case 0: REMOVEHELMET(playerid);
		case 1: PUTHELMET(playerid);
	}

	return 1;
}

SuicideBomb(playerid)
{
	new Float:x, Float:y, Float:z, count = 0;

	GetPlayerPos(playerid, x, y, z);
	SetPlayerHealth(playerid, 0.0);
	CreateExplosion(x, y, z, 3, 10.0);

	foreach(new i : Player)
	{
	    if (IsPlayerInRangeOfPoint(i, 7.0, x, y, z))
		{
			if (Player(i, Team) != Player(playerid, Team) && !Var(i, Duty))
			{
			    SetPlayerHealth(i, 0.0);
			    SendDeathMessage(playerid, i, 53);
				SendClientMessage(playerid, -1, sprintf("* You received $2000 and +1 score for killing %s.", playerName(i)));
				SendClientMessage(i, c_red, sprintf("You have been killed by suicide bomber %s.", playerName(playerid)));
				++count;
			}
		}
	}

	if (count)
	{
	    RewardPlayer(playerid, 0, count, true);
		Player(playerid, Kills) += count;
		News(sprintf("~r~~h~Suicide bomber ~w~~h~%s ~r~~h~killed %i people", playerName(playerid), count));
	}
}

remove_VarValues(playerid, bool:before = false)
{
	if (before == false)
	{
		if (Timer(playerid, Teargas) != -1)
		{
			KillTimer(Timer(playerid, Teargas));
			Timer(playerid, Teargas) = -1;
		}

		if (Var(playerid, WaitingRound) == true)
		{
		    Var(playerid, WaitingRound) = false;
		}

		if (Var(playerid, HasBombs))
		{
			Var(playerid, HasBombs) = false;
		}

		if (Var(playerid, MediKits) != 0)
		{
			Var(playerid, MediKits) = 0;
		}

		if (Var(playerid, VSpawned) != 0)
		{
			Var(playerid, VSpawned) = 0;
		}

		Var(playerid, ClassSpawned) = 1;
		Var(playerid, RecentZone) = -1;
		Var(playerid, VIPWepsUsed) = 0;

		if (Var(playerid, PlayerStatus) == PLAYER_STATUS_SWITCHING_TEAM)
		{
		    ForceClassSelection(playerid);
  			Var(playerid, PlayerStatus) = PLAYER_STATUS_NONE;
		}
	}
	else
	{
		if (Player(playerid, KillStreak) != 0)
		{
			Player(playerid, KillStreak) = 0;
		}

		if (Player(playerid, ZoneStreak) != 0)
		{
			Player(playerid, ZoneStreak) = 0;
		}
		
		if (Var(playerid, CappingZone) != -1)
		{
		    SendClientMessage(playerid, c_red, "* You failed to capture this zone.");
		    GameTextForPlayer(playerid, ""#TXT_LINE"~r~capture failed", 1000, 3);
			zone_StopCapture(playerid);
		}
	    
	    if (Var(playerid, CapturingFlag) != -1)
		{
	  		SendClientMessage(playerid, c_red, "* You failed to steal this flag.");
	        zone_StopFlagCapture(playerid);
		}
		
		if (Var(playerid, BridgeTimer) != 0)
		{
			SendClientMessage(playerid, c_red, (Player(playerid, Class) == DEMOLISHER) ?
												("* You failed to plant the bombs.") :
												("* You failed to repair this bridge."));
	        Var(playerid, BridgeTimer) = 0;
	        Var(playerid, BridgeID) = -1;
	        GameTextForPlayer(playerid, "", 1000, 3);
	        ClearAnimations(playerid);
		}
		
		if (Var(playerid, SupplyTime) != 0)
		{
  			Var(playerid, SupplyTime) = 0;
	 		GameTextForPlayer(playerid, "", 100, 3);
	   		TogglePlayerControllable(playerid, 1);
		}
	}
}

interrupt_Mission(playerid, killerid)
{
	new reward;

	if (Player(playerid, KillStreak) >= 3)
	{
		reward = RandomEx(1000, 1500);
		RewardPlayer(killerid, reward, 1);
		SendClientMessage(killerid, c_green, sprintf("[BONUS] You received +$%i and +1 score for stopping %s's killing spree.", reward, playerName(playerid)));
		SendClientMessage(playerid, c_red, sprintf("* %s has stopped your killing spree.", playerName(killerid)));
		IRC_Echo(g_IRC_Conn[IRC_MAIN_CHANNEL], sprintf("4* %s stopped %s's killing spree.", playerName(killerid), playerName(playerid)));
		News(sprintf("~r~~h~~h~%s stopped %s's killing spree", playerName(killerid), playerName(playerid)));
	}

	if (Player(playerid, ZoneStreak) >= 3)
	{
		reward = RandomEx(1000, 1500);
		RewardPlayer(killerid, reward, 1);
		SendClientMessage(killerid, c_green, sprintf("[BONUS] You received +$%i and +1 score for stopping %s's capture spree.", reward, playerName(playerid)));
		SendClientMessage(playerid, c_red, sprintf("* %s has stopped your capture spree.", playerName(killerid)));
		IRC_Echo(g_IRC_Conn[IRC_MAIN_CHANNEL], sprintf("4* %s stopped %s's capture spree.", playerName(killerid), playerName(playerid)));
		News(sprintf("~r~~h~~h~%s stopped %s's capture spree", playerName(killerid), playerName(playerid)));
	}

	if (Var(playerid, CapturingFlag) != -1)
	{
		new flag;

		reward = RandomEx(2000, 4000);
		flag = Var(playerid, CapturingFlag);
		RewardPlayer(killerid, reward, 3);
		RewardPlayer(playerid, 0, -1);

		SendClientMessage(killerid, c_green, sprintf("[BONUS] You received +$%i and +3 score for stopping %s from stealing the flag of %s.", reward, playerName(playerid), Zone(flag, Name)));
		News(sprintf("~r~~h~~h~%s stopped %s from stealing the flag of %s.", playerName(killerid), playerName(playerid), Zone(flag, Name)));
		SendClientMessage(playerid, c_red, sprintf("* %s stopped you from stealing the flag, you lost 1 score.", playerName(killerid)));
		IRC_Echo(g_IRC_Conn[IRC_MAIN_CHANNEL], sprintf("5*** %s stopped %s from stealing the flag of %s.", playerName(killerid), playerName(playerid), Zone(flag, Name)));
	}
}

reset_Var(playerid)
{
	new
		x1[E_PLAYER_DATA],
		x2[E_SYNC_DATA],
		x3[E_TEXT_DRAWS],
		x4[E_VAR_DATA],
		x5[E_SPEC_DATA];

    g_Player[playerid] = x1;
    g_SyncData[playerid] = x2;
    g_TextDraw[playerid] = x3;
    g_Var[playerid] = x4;
    g_SpecData[playerid] = x5;
	g_SpecID[playerid] = INVALID_PLAYER_ID;
	g_Reporter[playerid] = INVALID_PLAYER_ID;
	
	Var(playerid, DuelInvitePlayer) = INVALID_PLAYER_ID;
	Var(playerid, RequestedPlayer) = INVALID_PLAYER_ID;
	Var(playerid, ClanInvitePlayer) = INVALID_PLAYER_ID;
	Var(playerid, JustReported) = INVALID_PLAYER_ID;

	for (new i = 0, j = MAX_WEAPON_TYPE; i < j; i++)
	{
		Player(playerid, WeaponKills)[i] = 0;
	}

	g_pLastCBCall[playerid] = 0;
    g_pCBSpamWarns[playerid] = 0;

 	Player(playerid, Team) = NO_TEAM;
	Player(playerid, Class) = 0;
	Player(playerid, ClanID) = -1;
	g_RconAttempts[playerid] = 0;

	Var(playerid, LastPM) = -1;
	Var(playerid, SquadID) = -1;
	Var(playerid, BridgeID) = -1;
	Var(playerid, CappingZone) = -1;
	Var(playerid, CapturingFlag) = -1;
	Var(playerid, InvitedSquadID) = -1;
	Var(playerid, InvitedClan) = -1;
	Var(playerid, DuelID) = -1;
	Var(playerid, ViewingCmd) = -1;
	Var(playerid, TempClanSkin) = -1;
	Var(playerid, PlayingCW) = -1;

	for (new i = 0, j = MAX_WEAPON_SLOT; i < j; i++)
	{
        g_WD_Pickup[playerid][i] = -1;
        g_WD_DroppedX[playerid][i] = 0.0;
        g_WD_DroppedY[playerid][i] = 0.0;
        g_WD_DroppedZ[playerid][i] = 0.0;
		
		for (new x = 0, z = 3; x < z; x++)
		{
			g_WD_Data[playerid][i][x] = -1;
		}
	}

	for (new i = 0, j = MAX_WEAPONS; i < j; i++)
	{
	    Player(playerid, Weapons)[i] = 0;
	}
	
	Timer(playerid, Jail) = -1;
	Timer(playerid, Teargas) = -1;

	g_HealthPickup[playerid] = -1;
	g_ArmourPickup[playerid] = -1;
	g_RegisteringPassword[playerid][0] = '\0';
	g_RegisteringClan[playerid][0] = '\0';
	g_RegisteringClanTag[playerid][0] = '\0';
	
	Player(playerid, ChatMessage)[0] = '\0';
	Player(playerid, RankText) = INVALID_3DTEXT_ID;
	
	ToggleHelmet(playerid, 0);
	ToggleMask(playerid, 0);
	DetachFlag(playerid);
}

PreloadAnimLib(playerid, animlib[])
{
	ApplyAnimation(playerid, animlib, "null", 0.0, 0, 0, 0, 0, 0);
}

RangeBetween(player1, player2)
{
	new
		Float:pX,
		Float:pY,
		Float:pZ,
		Float:cX,
		Float:cY,
		Float:cZ,
		Float:distance;

	GetPlayerPos(player1, pX, pY, pZ);
	GetPlayerPos(player2, cX, cY, cZ);
	distance = floatsqroot(floatpower(floatabs(floatsub(cX, pX)), 2)
		+ floatpower(floatabs(floatsub(cY, pY)), 2)
		+ floatpower(floatabs(floatsub(cZ, pZ)), 2));

	return floatround(distance);
}

GiveJetpack(playerid)
{
	Var(playerid, UsingJetpack) = 1;
	SetPlayerSpecialAction(playerid, 2);
}

//Indicates that the player is paused or not, depending on the tick variable
//that is being checked in the player update callback.

IsPlayerPaused(playerid)
{
	return (GetTickCount() > (Var(playerid, PauseCheck) + 2000)) ? 1 : 0;
}

PlayerProtection(playerid, protection_type)
{
	if (protection_type == PROTECTION_START)
	{
	    Player(playerid, Protected) = gettime() + 10;
		SetPlayerHealth(playerid, FLOAT_INFINITE);
		SendClientMessage(playerid, c_grey, "[PROTECTION] "#sc_lightgrey"You are protected by anti spawn-kill protection for '10' seconds.");
		SendClientMessage(playerid, c_lightgrey, "* The protection will stop instantly if you shoot an enemy player.");
		Update3DTextLabelText(Player(playerid, RankText), c_red, "Protected by Anti Spawn-Kill");
		
		PlayerTextDrawShow(playerid, TD(playerid, ASK)[0]);
		PlayerTextDrawSetString(playerid, TD(playerid, ASK)[1], "~w~~h~YOU ARE CURRENTLY PROTECTED BY THE ~r~~h~~h~ANTI SPAWN KILL ~w~~h~PROTECTION");
		PlayerTextDrawShow(playerid, TD(playerid, ASK)[1]);
	}
	else if (protection_type == PROTECTION_END)
	{
		Player(playerid, Protected) = 0;

		SendClientMessage(playerid, c_grey, "[PROTECTION] "#sc_lightgrey"Ended.");
		SetPlayerHealth(playerid, 100.0);
		UpdateLabel(playerid);
		UpdateMap(playerid);

		PlayerTextDrawHide(playerid, TD(playerid, ASK)[0]);
		PlayerTextDrawSetString(playerid, TD(playerid, ASK)[1], " ");
		PlayerTextDrawHide(playerid, TD(playerid, ASK)[1]);
	}
}

AntiHack_Init(playerid)
{
    if (Var(playerid, Money) != 0)
	{
		Player(playerid, Money) += Var(playerid, Money);
		Var(playerid, Money) = 0;
	}

	if (Var(playerid, Score) != 0)
	{
		Player(playerid, Score) += Var(playerid, Score);
		Var(playerid, Score) = 0;
	}
 	
 	ResetPlayerMoney(playerid);
	GivePlayerMoney(playerid, Player(playerid, Money));
	SetPlayerScore(playerid, Player(playerid, Score));
	
	if (Player(playerid, Money) > 999000000)
	{
		Player(playerid, Money) = 999000000;
	}
	
	if (Player(playerid, Score) < -1000000)
	{
		Player(playerid, Score) = -1000000;
	}
	
	if (!IsPlayerPaused(playerid))
	{
        if (GetPlayerSpecialAction(playerid) == 2 && !Var(playerid, UsingJetpack) && Player(playerid, Level) < 3)
        {
		    BanPlayer(playerid, "Permanent", "Jetpack-Hack", bot, true);
		}
	}
	
	if (gettime() > Var(playerid, ReportTime))
	{
		if (GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
		{
			new vehicleid, speed, Float:x, Float:y, Float:z, Float:final;
			vehicleid = GetPlayerVehicleID(playerid);
			GetVehicleVelocity(vehicleid, x, y, z);
			final = floatsqroot(((x * x) + (y * y)) + (z * z)) * 158.179;
			speed = floatround(final);

			if (speed > 240 && z > -1.2)
			{
			    if (admin_IsOnline())
			    {
			    	admin_SendReport(playerid, -1, sprintf("possible speed hack (%i KPH)", speed), true);
				}
				else
				{
				    TimeoutPlayer(playerid, true);
				}
			}
		}
	}

	if (Server(MaxPing))
	{
	    new ping, max_ping;
		ping = GetPlayerPing(playerid);
		max_ping = Server(MaxPing);
		
		if (Player(playerid, Level) < 1 && ping >= max_ping && ping != 65535)
		{
			SendClientMessageToAll(c_tomato, sprintf("* Player %s has been kicked by %s. <High ping: %d/%d>", playerName(playerid), bot, ping, max_ping));
			IRC_Echo(g_IRC_Conn[IRC_MAIN_CHANNEL], sprintf("4* Player %s has been kicked by %s. <High ping: %d/%d>", playerName(playerid), bot, ping, max_ping));
			KickEx(playerid, c_red, "You have been kicked for high ping.");
		}
	}

	update_fps(playerid);
	return 1;
}

UpdatePlayer(playerid)
{
	if (Player(playerid, Money) < 5000 || Player(playerid, Money) < 0)
	{
		RewardPlayer(playerid, 5000, 0);
	}

	if (Var(playerid, Spawned))
	{
	    AntiHack_Init(playerid);
		
		if (Player(playerid, Muted) != 0 && gettime() > Player(playerid, Muted))
		{
			UnmutePlayer(playerid);
		 	SendClientMessage(playerid, c_green, "You have been un-muted.");
		}

		if (Player(playerid, Protected) != 0 && gettime() > Player(playerid, Protected))
		{
		    PlayerProtection(playerid, PROTECTION_END);
		}
		
		new weaponid = GetPlayerWeapon(playerid);
		
		if (weaponid != -1)
		{
			if (Var(playerid, WeaponCheck) != 0 && Player(playerid, Weapons)[weaponid])
			{
			    Var(playerid, WeaponCheck) = 0;
			}
		}
		
		if (IsPlayerPaused(playerid))
		{
			++Var(playerid, PausedFor);
	    }
	    else
		{
	        if (Var(playerid, PausedFor) != 0)
			{
	            Var(playerid, PausedFor) = 0;
			}
	    }
		
		if (GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
		{
		    if (Var(playerid, Duty))
			{
		        RepairVehicle(Var(playerid, CurrentVehicle));
		    }
		}
	    
	    if (Var(playerid, SupplyTime) != 0 && gettime() > Var(playerid, SupplyTime))
		{
		    new vehicleid = GetPlayerVehicleID(playerid);
			
			Vehicle(vehicleid, Loaded) = true;
			Vehicle(vehicleid, SupplyingPlayer) = playerid;
			Var(playerid, SupplyTime) = 0;
	        Var(playerid, SupplyingVehicle) = vehicleid;
			TogglePlayerControllable(playerid, 1);

			GameTextForPlayer(playerid, ""#TXT_LINE"~g~loaded", 2000, 3);
			SendClientMessage(playerid, c_green, "* Supplies have been successfully loaded. Head over the zone and use '/supply' to supply your teammates.");
		}
		
		if (Var(playerid, LastKillTime) != 0 && gettime() > Var(playerid, LastKillTime))
		{
		    Var(playerid, LastKillTime) = 0;
		    Var(playerid, DeathCount) = 0;
		}
		
		if (Var(playerid, BridgeTimer) != 0 && gettime() > Var(playerid, BridgeTimer))
		{
			new bridgeid = Var(playerid, BridgeID);
			Var(playerid, BridgeID) = -1;
			Var(playerid, BridgeTimer) = 0;
			ClearAnimations(playerid);
			
			switch (Player(playerid, Class))
			{
			    case DEMOLISHER:
				{
					Var(playerid, HasBombs) = false;
					Bridge(bridgeid, ExplodeTime) = 11;
			        Bridge(bridgeid, Planted) = true;
			        Bridge(bridgeid, PlantingPlayer) = playerid;

			        Exceptional(playerid, c_red, sprintf("*** %s has planted few bombs at the %s, the bombs will explode in 10 seconds.", playerName(playerid), Bridge(bridgeid, Name)));
					IRC_Echo(g_IRC_Conn[IRC_MAIN_CHANNEL], sprintf("5 * %s has planted few bombs at the %s. The bombs will explode in 10 seconds.", playerName(playerid), Bridge(bridgeid, Name)));
					SendClientMessage(playerid, c_green, sprintf("Bombs have been successfully planted at the %s.", Bridge(bridgeid, Name)));

                    GameTextForPlayer(playerid, ""#TXT_LINE"~g~planted", 2000, 3);
				}
				default:
				{
					new teamid = Player(playerid, Team);
					bridge_ChangeState(bridgeid, BRIDGE_STATUS_FIXED); // Repairing
				    Bridge(bridgeid, Planted) = false;
					RewardPlayer(playerid, 10000, 5, true);

				    GameTextForPlayer(playerid, ""#TXT_LINE"~g~repaired", 2000, 3);
				    News(sprintf("~w~~h~%s ~g~~h~~h~from team %s has repaired the %s", playerName(playerid), Team(teamid, Name), Bridge(bridgeid, Name)));
	                IRC_Echo(g_IRC_Conn[IRC_MAIN_CHANNEL], sprintf("10* %s from team %s has repaired the %s.", playerName(playerid), Team(teamid, Name), Bridge(bridgeid, Name)));
					SendClientMessage(playerid, c_green, sprintf("You received +$10000 and +5 score for repairing the %s.", Bridge(bridgeid, Name)));
				}
			}
		}
	}
	
	if (Var(playerid, ScreenMsgTime) != 0 && gettime() > Var(playerid, ScreenMsgTime))
	{
        PlayerTextDrawSetString(playerid, TD(playerid, ScreenMsg)[1], " ");
        PlayerTextDrawSetString(playerid, TD(playerid, ScreenMsg)[2], " ");
        
        for (new i = 0, j = 3; i != j; ++i)
        {
	    	PlayerTextDrawHide(playerid, TD(playerid, ScreenMsg)[i]);
		}
	    
	    Var(playerid, ScreenMsgTime) = 0;
	}
	
	if (Var(playerid, WeapTime) != 0 && gettime() > Var(playerid, WeapTime))
	{
        weapon_RemovePickups(playerid);
	}
}

FakeDeaths_Check(playerid, killerid)
{
	if (Var(killerid, LastKilled) == playerid)
	{
     	if (!Var(playerid, LastKillTime))
     	{
			Var(playerid, LastKillTime) = gettime() + 5;
		}
		++Var(playerid, DeathCount);
	}
	else
	{
	    Var(playerid, DeathCount) = 0;
	    Var(playerid, LastKillTime) = 0;
	}
	
	Var(killerid, LastKilled) = playerid;
	
	if (Var(playerid, LastKillTime) != 0 && Var(playerid, DeathCount) == 4)
	{
		BanPlayer(playerid, "Permanent", "Fake-Deaths", bot, true);
	}
	
	return 1;
}

PlayerKillPlayer(killerid, playerid, reason)
{
    FakeDeaths_Check(playerid, killerid);
	
	if (!Var(playerid, Duty))
	{
		if (!Var(playerid, Headshot))
		{
		    SendDeathMessage(killerid, playerid, reason);
			IRC_Echo(g_IRC_Conn[IRC_MAIN_CHANNEL], sprintf("5* %s killed %s. (%s)", playerName(killerid), playerName(playerid), aWeaponNames[reason]));
			
			if (!Var(killerid, DM))
			{
 				if (Var(killerid, DuelID) != -1)
				{
			        duel_Result(killerid, playerid);
			    }
				else
				{
				    new fee, killreward, boost_active;
					
					boost_active = IsItemActivated(Player(killerid, BoostActivated));
					CountWeaponKills(killerid, reason);
					
					++Player(killerid, KillStreak);
					++Player(killerid, SessionKills);
					
					Player(killerid, Kills) += (boost_active) ? 2 : 1;

					fee = RandomEx(500, 2000);
					RewardPlayer(playerid, -fee, 0);
					SendClientMessage(playerid, c_red, sprintf("* Death fee: -$%i", fee));
					
					if (Var(playerid, PlayingCW) == -1)
					{
  						weapon_Drop(playerid);
					}
  					
  					if (Player(killerid, ClanID) != -1)
					{
					    new clanid = Player(killerid, ClanID);
					
						if (Player(playerid, ClanID) != clanid)
						{
						    clan_GivePoints(clanid, 1);
						    clan_SendMessage(clanid, c_clan, sprintf("Clan '%s' received +1 point from %s's kill.", Clan(clanid, Name), playerName(killerid)));
						}
						else
						{
						    clan_GivePoints(clanid, -1);
							clan_SendMessage(clanid, c_red, sprintf("Clan '%s' lost 1 point because of %s killing a clan member %s.", Clan(clanid, Name), playerName(killerid), playerName(playerid)));
						}
					}
                    
                    interrupt_Mission(playerid, killerid);
					killreward = RandomEx(500, 3000);
					SendClientMessage(killerid, c_green, sprintf("You received +$%i and +1 score for killing enemy %s.", killreward, playerName(playerid)));
					ScreenMessage(killerid, "ENEMY KILLED", "~y~~h~+2 SCORE");
					RewardPlayer(killerid, killreward, 1);
					
					if (boost_active)
					{
					    SendClientMessage(killerid, c_darkgreen, sprintf("VIP Boost: "#sc_white"You received extra 1 score, $%i and 1 kill.", killreward));
					    RewardPlayer(killerid, killreward, 1);
					}
					
					SendClientMessage(killerid, c_grey, "The enemy has dropped their weapons, press 'crouch' key near the weapons to pick them up.");
					
					if (Var(killerid, SquadID) != -1)
					{
					    new sq_reward = RandomEx(100, 1000);
						squad_Reward(killerid, sq_reward, 1, sprintf("The squad received +$%i and +1 score from %s's kill.", sq_reward, playerName(killerid)));
					}
					
					if (Player(killerid, KillStreak) >= 3)
					{
						SpreeMessage(killerid);
					}
					
					if (Player(playerid, Class) == SUICIDE_BOMBER)
					{
				        SuicideBomb(playerid);
					}
				}
			}
			else
			{
				SetPlayerHealth(killerid, 100.0);
				SetPlayerArmour(killerid, 100.0);
			}
		}
	}
}

PlayerHeadShotPlayer(playerid, target, type)
{
	if (type == HS_BREAKHELMET)
	{
 		ToggleHelmet(target, 0);
		Var(target, HasHelmet) = 0;

		SendClientMessage(playerid, c_green, sprintf("You broke %s's helmet.", playerName(target)));
		SendClientMessage(target, c_red, sprintf("* %s broke your helmet, watch out!.", playerName(playerid)));
        GameTextForPlayer(target, ""#TXT_LINE"~r~your helmet is~n~broken!", 2000, 3);
	}
	else if (type == HS_KILLPLAYER)
	{
	    if (!Player(target, Protected))
		{
			if (!Var(target, Duty))
			{
			    if (!Var(target, Headshot))
				{
					new boost_active = IsItemActivated(Player(playerid, BoostActivated));

		            Var(target, Headshot) = true;
		            
		            if (Player(playerid, ClanID) != -1)
					{
					    new clanid = Player(playerid, ClanID);

						if (Player(target, ClanID) != clanid)
						{
						    clan_GivePoints(clanid, 1);
						    clan_SendMessage(clanid, c_clan, sprintf("Clan '%s' received +1 point from %s's kill.", Clan(clanid, Name), playerName(playerid)));
						}
						else
						{
						    clan_GivePoints(clanid, -1);
							clan_SendMessage(clanid, c_red, sprintf("%s killed %s. Clan %s lost 1 point.", playerName(playerid), playerName(target), Clan(clanid, Name)));
						}
					}
		            
		            SendClientMessage(playerid, c_green, "That's an amazing headshot! You received +2 score.");

					SetPlayerHealth(target, 0.0);
		            RewardPlayer(playerid, 0, 2, true);
	             	GameTextForPlayer(target, ""#TXT_LINE"~r~headshot", 2000, 3);
	             	ScreenMessage(playerid, "HEADSHOT", "~y~~h~+2 SCORE");
	             	PlayerPlaySound(playerid, 5201, 0.0, 0.0, 0.0);
	             	PlayerPlaySound(target, 5201, 0.0, 0.0, 0.0);
	             	
	             	if (boost_active)
					{
					    SendClientMessage(playerid, c_darkgreen, "VIP Boost: "#sc_white"You received extra 2 score, 1 kill and 1 headshot.");
					    RewardPlayer(playerid, 0, 2);
					}
					
					Player(playerid, Kills) += (boost_active) ? 2 : 1;
					Player(playerid, Headshots) += (boost_active) ? 2 : 1;

					++Player(playerid, KillStreak);
					++Player(playerid, WeaponKills)[W_SNIPER];
					SpreeMessage(playerid);
	             	SendDeathMessage(playerid, target, GetPlayerWeapon(playerid));
					
					if (Var(playerid, SquadID) != -1)
					{
					    new sq_reward;

						sq_reward = RandomEx(100, 1000);
						squad_Reward(playerid, sq_reward, 1, sprintf("The squad received +$%i and +1 score from %s's headshot.", sq_reward, playerName(playerid)));
					}

					new query[84];

					Query("UPDATE `users` SET `headshots`='%i' WHERE `id`='%i'", Player(playerid, Headshots), Player(playerid, UserID));
					mysql_tquery(connection, query, "ExecuteQuery", "i", res_none);
				}
			}
		}
	}

	return 1;
}

JoinLeaveMessage(playerid, reason = -1)
{
	if (reason == -1)
	{
	    News(sprintf("~w~~h~Player %s (ID: %i) has ~g~~h~~h~joined ~w~~h~the game", playerName(playerid), playerid));
		admin_SendMessage(3, c_lightgrey, sprintf(">> Incoming connection: %s (ID: %i), IP: %s", playerName(playerid), playerid, Player(playerid, Ip)));

		IRC_Echo(g_IRC_Conn[IRC_MAIN_CHANNEL], sprintf("3*** %s (ID: %i) has joined the game. Total players online: %i", playerName(playerid), playerid, Server(Players)));
		IRC_Echo(g_IRC_Conn[IRC_ADMIN_CHANNEL], sprintf("3>> Incoming connection: %s (ID: %i), IP: %s", playerName(playerid), playerid, Player(playerid, Ip)));
	}
	else
	{
		new
			quit_string[128],
			quit_Reasons[3][10] = {
				{"Timeout"},
				{"Quit"},
				{"Kicked"}
			};
		
		News(sprintf("~w~~h~Player %s has ~r~~h~~h~left ~w~~h~the game <%s>", playerName(playerid), quit_Reasons[reason]));
		Format:quit_string("14*** %s[%i] has left the game. (%s) Total players online: %i", playerName(playerid), playerid, quit_Reasons[reason], Server(Players));

		IRC_Echo(g_IRC_Conn[IRC_MAIN_CHANNEL], quit_string);
		IRC_Echo(g_IRC_Conn[IRC_ADMIN_CHANNEL], quit_string);
	}
}
		
SpreeMessage(playerid, zone = 0)
{
	new streak;

	if (!zone)
	{
		streak = Player(playerid, KillStreak);
		
		if (streak >= 3)
		{
	        News(sprintf("~w~~h~%s ~g~~h~~h~~h~is on a killing spree with %d kills", playerName(playerid), streak));
	        IRC_Echo(g_IRC_Conn[IRC_MAIN_CHANNEL], sprintf("3[KILL SPREE] %s is on a killing spree with %d kills.", playerName(playerid), streak));
		}
		
		if (streak <= 20)
		{
			switch (streak)
			{
			    case 5:
				{
				    RewardPlayer(playerid, 5000, 2);
					SendClientMessage(playerid, c_yellow, "* You received +2 score and $5000 bonus for 5 kills killing spree.");
			    }
				case 10:
				{
					RewardPlayer(playerid, 7000, 5);
					SendClientMessage(playerid, c_yellow, "* You received +5 score and $7000 bonus for 10 kills killing spree.");
			    }
				case 15:
				{
					GiveAllWeaponAmmo(playerid, 50);
	                RewardPlayer(playerid, 10000, 7);
					
					SendClientMessage(playerid, c_yellow, "* You received +50 ammo, +7 score and $10000 bonus for 15 kills killing spree.");
			    }
				case 20:
				{
				    GiveAllWeaponAmmo(playerid, 100);
					RewardPlayer(playerid, 15000, 10);
					
					SendClientMessage(playerid, c_yellow, "* You received +100 ammo, +10 score and $15000 bonus for 20 kills killing spree.");
				}
			}
		}
		else
		{
		    RewardPlayer(playerid, 5000, 2);
			SendClientMessage(playerid, c_yellow, "* You now have a 20+ kills killing spree. +2 score and $5000 has been rewarded.");
		}
	}
	else
	{
	    streak = Player(playerid, ZoneStreak);
		
		if (streak >= 3)
		{
	        News(sprintf("~w~~h~%s ~y~is on a capture spree with %d captures", playerName(playerid), streak));
	        IRC_Echo(g_IRC_Conn[IRC_MAIN_CHANNEL], sprintf("7[ZONE SPREE] %s is on a capture spree with %d captures.", playerName(playerid), streak));
		}
		
		if (streak <= 20)
		{
			switch (streak)
			{
			    case 5:
				{
				    RewardPlayer(playerid, 5000, 5);
					
					SendClientMessage(playerid, -1, "*** You received +5 score and $5000 bonus for your 5 captures long capturing spree.");
					SendClientMessage(playerid, -1, "*** Capture 5 more zones without dying to receive a Sanchez bike.");
			    }
				case 10:
				{
					GiveVehicle(playerid, 468);
					
					SendClientMessage(playerid, -1, "*** You received a Sanchez bike for your 10 captures long capturing spree.");
                    SendClientMessage(playerid, -1, "*** Capture 10 more zones without dying to receive a character skin.");
				}
				case 20:
				{
			 		new skin = RandomEx(1, 311);
			 		
                    switch (skin)
					{
						case 287, 285, 73, 206, 100, 200:
						{
							// Do nothing...
						}
						default:
						{
							SetSkin(playerid, skin);
							Var(playerid, Skin) = skin;
		                }
					}
					SendClientMessage(playerid, -1, sprintf("*** You received a skin (%i) for your 20 captures long capturing spree.", skin));
				}
			}
		}
		else
		{
		    RewardPlayer(playerid, 10000, 5);
			SendClientMessage(playerid, c_yellow, "* You now have a 20+ captures long capturing spree, +5 score and $10000 has been rewarded.");
		}
	}
	
	UpdateBoard(playerid);
}

IsAuthorizedLevel(playerid,level)
{
	if (Player(playerid, Level) >= level)
	{
	    return 1;
	}
	
	return SendClientMessage(playerid, c_red, "* You are not authorized to use this command."), 0;
}

IsPlayerUsingAnimation(playerid, animation[])
{
	new idx = GetPlayerAnimationIndex(playerid);

	if (idx)
	{
	    new lib[32], anim[32];

		GetAnimationName(idx, lib, 32, anim, 32);
		
		#pragma unused lib

	    if (!strcmp(anim, animation, true))
	    {
			return true;
		}
	}

	return false;
}

IsPlayerAtShop(playerid)
{
	if (shop_ReturnClosestID(playerid) == -1)
	    return SendClientMessage(playerid, c_red, "* You are not at the shop area."), 0;
	else
		return 1;
}

ShowClassInfo(playerid, class, bool:iscmd = false)
{
	new text[500];

	Format:	text(""#sc_white""#sc_lightgrey"Description:\n\t%s\n\nWeapons:\n\n%s\nAbilities:\n\t%s",
				Class(class, Desc),
				class_ReturnWeaponsList(class),
				Class(class, Ability));

	return ShowPlayerDialog(playerid, D_CLASSINFO, DIALOG_STYLE_MSGBOX,
				sprintf(""#sc_orange"%s",
					(Player(playerid, Team) == MERCENARY) ? ("Mercenary") :
					(sprintf("%s", Class(class, Name)))),
					text,
					(iscmd == true) ? ("Close") : ("Continue"),
					(iscmd == true) ? ("") : ("Back"));
}

ReturnConnectedTime(playerid)
{
    new string[20], h, m;

	m = (NetStats_GetConnectedTime(playerid) / 1000 / 60);
	h = (m / 60);
	Format:string("%02i:%02i", h, m);

	return string;
}

SaveStats(playerid)
{
	new query[350];

	strcat(query, "UPDATE `users` SET `kills`='%i',");
	strcat(query, "`deaths`='%i',`jail_time`='%i',");
	strcat(query, "`mute_time`='%i',`score`='%i',");
	strcat(query, "`cash`='%i',`capped_zones`='%i',");
	strcat(query, "`capped_flags`='%i' WHERE `id`='%i'");
	Query(query,
		Player(playerid, Kills),
		Player(playerid, Deaths),
		Player(playerid, Jailed),
		Player(playerid, Muted),
		Player(playerid, Score),
		Player(playerid, Money),
		Player(playerid, CapturedZones),
		Player(playerid, CapturedFlags),
		Player(playerid, UserID));
	mysql_tquery(connection, query, "ExecuteQuery", "i", res_none);
}

IsValidTargetPlayer(playerid, id, bool:irc = false, channel[] = EOS)
{
    if (!IsPlayerConnected(id) || id == INVALID_PLAYER_ID)
	{
        if (irc == true && playerid == -1)
		{
            #pragma unused id
			return IRC_Echo(channel, ""#IRC_PREFIX_ERROR"Specified player is not connected."), 0;
		}
		else
		{
		    #pragma unused channel
			return SendClientMessage(playerid, c_red, "* Specified player is not connected."), 0;
		}
	}

	return 1;
}

IsTargetPlayerSpawned(playerid, id, bool:irc = false, channel[] = EOS)
{
    if (!Var(id, Spawned))
	{
		if (irc == true && playerid == -1)
		{
            #pragma unused id
			return IRC_Echo(channel, ""#IRC_PREFIX_ERROR"Specified player is not spawned."), 0;
		}
		else
		{
		    #pragma unused channel
			return SendClientMessage(playerid, c_red, "* Specified player is not spawned."), 0;
		}
	}

	return 1;
}

IsValidSkin(playerid, skinid)
{
	new bool:is_valid = true;

	if (skinid < 0 || skinid > 311)
	{
	    is_valid = false;
	}
	else
	{
	    foreach(new i : Teams)
		{
		    if (skinid == Team(i, Skin))
			{
		        is_valid = false;
		        break;
			}
		}
	}

	switch (is_valid)
	{
	    case false: return SendClientMessage(playerid, c_red, "* Invalid skin."), 0;
		case true: return 1;
	}
	
	return -1;
}

IsCommandUsable(playerid, id)
{
	if (Player(id, Level) > Player(playerid, Level))
	{
	    return SendClientMessage(playerid, c_red, "* You cannot use this command on specified player."), 0;
	}

	return 1;
}

IsEnemyNear(playerid, Float:range)
{
	foreach(new i : Player)
	{
	    if (Player(playerid, Team) != Player(i, Team) && GetPlayerState(i) != PLAYER_STATE_SPECTATING)
		{
			if (RangeBetween(playerid, i) < range)
			{
				return SendClientMessage(playerid, c_red, "* You cannot use this command while enemy player is near you.");
			}
		}
	}

	return 0;
}

RandomBaseSpawn(playerid, teamid, bool:setdata = false)
{
    new idx, Float:x, Float:y, Float:z, Float:a;

    do idx = random(Server(SpawnPoints));
	while (Spawn(idx, TeamID) != teamid);

	x = Spawn(idx, X);
	y = Spawn(idx, Y);
	z = Spawn(idx, Z);
	a = Spawn(idx, A);

	switch (setdata)
	{
	    case true:
	    {
			SetSpawnInfo(playerid, teamid, Team(teamid, Skin), x, y, z, 0, 0, 0, 0, 0, 0, 0);
		}
		case false:
		{
			SetPlayerPos(playerid, x, y, z + 1.0);
			SetPlayerFacingAngle(playerid, a);
		}
	}
}

GiveAllWeaponAmmo(playerid, ammo)
{
    new weapons[MAX_WEAPON_SLOT][2];

    for(new i = 0, j = MAX_WEAPON_SLOT; i < j; i++)
	{
		GetPlayerWeaponData(playerid, i, weapons[i][0], weapons[i][1]);

		switch (weapons[i][0])
		{
		    case 22..34:
		    {
				GivePlayerWeapon(playerid, weapons[i][0], ammo);
			}
		}
	}

	return 1;
}

supporter_SupplyTeam(playerid)
{
	new zoneid = zone_ReturnIDByArea(playerid);

	if (zoneid != -1)
	{
		if (Zone(zoneid, Team) != Player(playerid, Team))
		{
		    SendClientMessage(playerid, c_red, "* Your team does not own this zone.");
		}
		else
		{
			new bool:is_close = false;
			
			foreach(new i : Player)
			{
			    if (RangeBetween(playerid, i) < 10.0)
				{
			        is_close = true;
			        break;
				}
			}

			if (!is_close)
			{
				SendClientMessage(playerid, c_red, "* You must be near your teammates in order to supply.");
			}
			else
			{
			    new count = 0, Float:armour, Float:hp, teamid;

				teamid = Player(playerid, Team);

			    foreach(new i : Player)
				{
			        if (i != playerid && IsPlayerInDynamicArea(i, Zone(zoneid, Area)))
					{
						if (Var(i, Spawned) && Player(i, Team) == teamid)
						{
							GetPlayerHealth(i, hp);
							GetPlayerArmour(i, armour);
							GiveAllWeaponAmmo(i, 100);
							SetPlayerArmour(i, armour + 30.0);
							SetPlayerHealth(i, hp + 30.0);
							SendClientMessage(playerid, -1, sprintf("* You supplied %s with +100 ammo, +30HP and +30 armour, you have been rewarded with $5000 and +1 score.", playerName(i)));
							SendClientMessage(i, c_orange, sprintf("* %s supporter %s has supplied you with +100 ammo, +30HP and +30 armour.", Team(teamid, Name), playerName(playerid)));
							++count;
						}
					}
				}
				
				Vehicle(GetPlayerVehicleID(playerid), Loaded) = false;
				
				if (count)
				{
        			RewardPlayer(playerid, (count * 1000), count, true);
				}
 				else
 				{
				  	SendClientMessage(playerid, c_red, "* You have successfully dropped the supplies but there were no teammates in this zone.");
				}
			}
		}
	}
	else
	{
		SendClientMessage(playerid, c_red, "* You are not in the zone area.");
	}
	
	return 1;
}

Synchronize(playerid, step)
{
	if (step == 1)
	{
	    Sync(playerid, Synced) = step;

		GetPlayerPos(playerid, Sync(playerid, X), Sync(playerid, Y), Sync(playerid, Z));
		GetPlayerFacingAngle(playerid, Sync(playerid, A));
		GetPlayerHealth(playerid, Sync(playerid, Health));
		GetPlayerArmour(playerid, Sync(playerid, Armour));
		Sync(playerid, World) = GetPlayerVirtualWorld(playerid);
		Sync(playerid, Int) = GetPlayerInterior(playerid);
		
		for(new i = 0, j = MAX_WEAPON_SLOT; i < j; i++)
		{
			GetPlayerWeaponData(playerid, i, g_SyncWeaponData[playerid][i][0], g_SyncWeaponData[playerid][i][1]);
		}
		
		SpawnPlayer(playerid);
		return 1;
	}
	
    new Float:x, Float:y, Float:z, Float:a, Float:health, Float:armour;
 	new int, world, weapon, ammo;
                
    Sync(playerid, Synced) = step;
    x = Sync(playerid, X);
	y = Sync(playerid, Y);
	z = Sync(playerid, Z);
	a = Sync(playerid, A);
	health = Sync(playerid, Health);
	armour = Sync(playerid, Armour);
	world = Sync(playerid, World);
	int = Sync(playerid, Int);

	SetPlayerPos(playerid, x, y, z + 2.0);
	SetPlayerFacingAngle(playerid, a);
	SetPlayerHealth(playerid, health);
	SetPlayerArmour(playerid, armour);
	SetPlayerVirtualWorld(playerid, world);
	SetPlayerInterior(playerid, int);
	SetCameraBehindPlayer(playerid);

	UpdateRank(playerid);
	UpdateBoard(playerid);

	for(new i = 0, j = MAX_WEAPON_SLOT; i < j; i++)
	{
	    weapon = g_SyncWeaponData[playerid][i][0];
		ammo = g_SyncWeaponData[playerid][i][1];
		GivePlayerWeapon(playerid, weapon, ammo);
	}

	if (Var(playerid, CapturingFlag) != -1)
	{
		AttachFlag(playerid);
	}
	
	if (Var(playerid, HasMask) == 1)
	{
		ToggleMask(playerid, 1);
	}
	
	if (Var(playerid, HasHelmet) == 1)
	{
		ToggleHelmet(playerid, 1);
	}
	
	if (Var(playerid, Disguised) != 0)
	{
	    SetSkin(playerid, Team(Var(playerid, Disguised), Skin));
	}
	else
	{
    	UpdateLabel(playerid);
	}

	return 1;
}

/******************************************************************************/
/*							 Duel functions	    							  */
/******************************************************************************/
#define duel_X1	974.7603
#define duel_Y1	-1445.8909
#define duel_Z1	13.4982
#define duel_A1	268.6658

#define duel_X2 1028.1334
#define duel_Y2 -1442.6152
#define duel_Z2 13.5546
#define duel_A2 88.6946

duel_Start(playerid, id, duelid)
{
	SetPlayerPos(playerid, duel_X1, duel_Y1, duel_Z1);
	SetPlayerFacingAngle(playerid, duel_A1);
	SetPlayerPos(id, duel_X2, duel_Y2, duel_Z2);
	SetPlayerFacingAngle(id, duel_A2);

	duel_SetData(playerid, duelid);
	duel_SetData(id, duelid);

    Duel(duelid, Player1) = id;
	Duel(duelid, Player2) = playerid;
	Duel(duelid, Count) = 4;
	Duel(duelid, Timer) = SetTimerEx("duel_CountDown", 1000, true, "i", duelid);
	Duel(duelid, Started) = true;
}

duel_SetData(playerid, duelid)
{
	ResetPlayerWeapons(playerid);

	SetPlayerColor(playerid, c_lightyellow);
	SetPlayerTeam(playerid, playerid + 1000);
	SetSkin(playerid, (Var(playerid, Skin)) ? Var(playerid, Skin) : 176);
	SetPlayerVirtualWorld(playerid, duelid + 666);
	SetPlayerHealth(playerid, 100.0);
	SetPlayerArmour(playerid, 100.0);
	SetCameraBehindPlayer(playerid);

	GivePlayerWeapon(playerid, Duel(duelid, Weapon1), 999);
    GivePlayerWeapon(playerid, Duel(duelid, Weapon2), 999);
	
	Update3DTextLabelText(Player(playerid, RankText), 0xFFFFFF00, "");
	TogglePlayerControllable(playerid, 0);
}

function duel_CountDown(duelid)
{
	new p1, p2;

	p1 = Duel(duelid, Player1);
	p2 = Duel(duelid, Player2);

	if (--Duel(duelid, Count) < 1)
	{
		KillTimer(Duel(duelid, Timer));

		Duel(duelid, Count) = 0;
		Duel(duelid, Timer) = -1;

		GameTextForPlayer(p1, "~g~~h~Go!", 2000, 3);
		GameTextForPlayer(p2, "~g~~h~Go!", 2000, 3);
		TogglePlayerControllable(p1, 1);
		TogglePlayerControllable(p2, 1);
	}
	else
	{
	    GameTextForPlayer(p1, sprintf("~w~%i", Duel(duelid, Count)), 2000, 3);
		GameTextForPlayer(p2, sprintf("~w~%i", Duel(duelid, Count)), 2000, 3);
	}
}

duel_ClearData(duelid)
{
    Duel(duelid, Started) = false;
	Duel(duelid, Player1) = INVALID_PLAYER_ID;
    Duel(duelid, Player2) = INVALID_PLAYER_ID;
    Duel(duelid, Weapon1) = -1;
    Duel(duelid, Weapon2) = -1;
    Duel(duelid, Bet) = 0;
    Duel(duelid, Timer) = -1;
    Duel(duelid, Count) = 0;
}

duel_AcceptInvitation(playerid, id)
{
	Var(playerid, DuelID) = Var(id, DuelID);
	Var(playerid, DuelInvitePlayer) = INVALID_PLAYER_ID;
	Var(id, RequestedPlayer) = INVALID_PLAYER_ID;

	duel_Start(playerid, id, Var(id, DuelID));

	SendClientMessage(id, c_darkgreen, sprintf("%s has accepted the duel request.", playerName(playerid)));
	SendClientMessage(playerid, c_green, "You have accepted the duel request.");
	SendClientMessage(playerid, -1, "Starting duel in 3 seconds...");
	SendClientMessage(id, -1, "Starting the duel in 5 seconds...");
	SendClientMessageToAll(c_blue, sprintf("[DUEL] %s[%i] vs %s[%i], bet: $%i", playerName(playerid), playerid, playerName(id), id, Duel(Var(id, DuelID), Bet)));
}

duel_ReturnFreeSlot()
{
    for (new i = 0, j = MAX_DUELS; i < j; i++)
	{
        if (!Duel(i, Bet) && Duel(i, Weapon1) == -1 && Duel(i, Weapon2) == -1)
		{
            return i;
		}
	}

	return -1;
}

duel_RejectInvitation(playerid, id)
{
	new duelid;

	duelid = Var(id, DuelID);
	
	Var(playerid, DuelInvitePlayer) = INVALID_PLAYER_ID;
	Var(id, DuelID) = -1;
	Var(id, RequestedPlayer) = INVALID_PLAYER_ID;
	Duel(duelid, Weapon1) = -1;
	Duel(duelid, Weapon2) = -1;
    Duel(duelid, Bet) = 0;
}
												
duel_Result(killerid, playerid)
{
	new duelid;

	duelid = Var(killerid, DuelID);

	if (Duel(duelid, Started))
	{
	    new bet;
	    
	    bet = Duel(duelid, Bet);

        GameTextForPlayer(playerid, "~r~duel lost", 3000, 3);
        GameTextForPlayer(killerid, "~g~~h~~h~duel won", 3000, 3);

		SendClientMessage(playerid, c_red, sprintf("* You lost '$%i' for losing the duel.", bet));
		SendClientMessageToAll(c_lightyellow, sprintf("[DUEL] %s[%i] won the duel against %s[%i] and took the bet of $%i.", playerName(killerid), killerid, playerName(playerid), playerid, bet));

		RewardPlayer(killerid, bet, 0);
		RewardPlayer(playerid, -bet, 0);

		Var(killerid, DuelID) = -1;
		Var(playerid, DuelID) = -1;

		SetPlayerTeam(killerid, Player(killerid, Team));
		SetPlayerTeam(playerid, Player(playerid, Team));
		SetPlayerHealth(playerid, 0.0); // Just to be sure they won't get stuck inside.

		ProtectedSpawn(killerid);
		duel_ClearData(duelid);
	}
}


duel_ResetData(playerid)
{
	if (Var(playerid, DuelID) != -1)
	{
		new duelid = Var(playerid, DuelID);

		if (Duel(duelid, Started))
		{
			new otherid;

		    if (Duel(duelid, Player1) == playerid)
			{
				otherid = Duel(duelid, Player2);
			}
			else
			{
				if (Duel(duelid, Player2) == playerid)
				{
					otherid = Duel(duelid, Player1);
				}
			}
			
			TogglePlayerControllable(otherid, 1);
			ProtectedSpawn(otherid);
			SetPlayerTeam(otherid, Player(otherid, Team));

			KillTimer(Duel(duelid, Timer));
			SendClientMessage(otherid, c_tomato, sprintf("* %s has disconnected, the duel has been cancelled.", playerName(playerid)));
			duel_ClearData(duelid);
			Var(otherid, DuelID) = -1;
		}
		else
		{
			if (Var(playerid, RequestedPlayer) != INVALID_PLAYER_ID)
			{
				new id = Var(playerid, RequestedPlayer);
				duel_RejectInvitation(id, playerid);
			}
		}
	}
	else
	{
		if (Var(playerid, DuelInvitePlayer) != INVALID_PLAYER_ID)
		{
			new id = Var(playerid, DuelInvitePlayer);
		    duel_RejectInvitation(playerid, id);
		}
	}
}

/******************************************************************************/
/*							 Team functions	    							  */
/******************************************************************************/

team_CreateBaseSAM(teamid, Float:x, Float:y, Float:z)
{
	for(new i = 1, j = TERRORIST; i < j; i++)
	{
		if (!BaseSam(i, Pickup))
		{
		    BaseSam(i, Pickup) = CreateDynamicPickup(1254, 2, x, y, z);
		    BaseSam(i, X) = x;
		    BaseSam(i, Y) = y;
		    BaseSam(i, Z) = z;
		    BaseSam(i, Team) = teamid;
		    CreateDynamic3DTextLabel(sprintf("%s\n"#sc_white"Base SAM", Team(teamid, Name)), Team(teamid, Color), x, y, z+1.0, 20.0);
			break;
		}
	}
}

team_Add(teamid)
{
	new Float:min_x, Float:min_y, Float:max_x, Float:max_y,
	    Float:flag_x, Float:flag_y, Float:flag_z;

	Iter_Add(Teams, teamid);
	min_x = Team(teamid, base_MinX);
	min_y = Team(teamid, base_MinY);
	max_x = Team(teamid, base_MaxX);
	max_y = Team(teamid, base_MaxY);
	flag_x = Team(teamid, FlagX);
	flag_y = Team(teamid, FlagY);
	flag_z = Team(teamid, FlagZ);
	
	AddPlayerClass(Team(teamid, Skin), 0.0, 0.0, 0.0, 0.0, 0, 0, 0, 0, 0, 0);
	Team(teamid, Zones) = GangZoneCreate(min_x, min_y, max_x, max_y);
	Team(teamid, ZoneArea) = CreateDynamicRectangle(min_x, min_y, max_x, max_y);
	
	CreateDynamic3DTextLabel(sprintf("{%06x}%s "#sc_white"flag vault\nDrop the stolen flag here", c_sub(Team(teamid, Color)), Team(teamid, Name)), c_lightgrey, flag_x, flag_y, flag_z, 30.0);
}

team_SendMessage(teamid, color, const string[])
{
	foreach(new i : Player)
	{
	    if (Player(i, Team) == teamid && !Var(i, DM))
		{
			SendClientMessage(i, color, string);
  		}
	}
}

team_ReturnIDByName(name[])
{
	foreach(new i : Teams)
	{
		if (strfind(Team(i, Name), name, true) != -1)
		{
			return i;
		}
	}

	return 0;
}

basesam_ReturnClosestID(playerid)
{
	new Float:x, Float:y, Float:z, Float:range;

	for (new i = 1, j = 6; i < j; i++)
	{
		x = BaseSam(i, X);
		y = BaseSam(i, Y);
		z = BaseSam(i, Z);
		range = GetPlayerDistanceFromPoint(playerid, x, y, z);

	    if (range < 3.5)
	    {
	        return i;
		}
	}
	return 0;
}


team_ReturnBaseList()
{
	new list[144];
	
	foreach(new i : Teams)
	{
		switch (i)
		{
		    case MERCENARY, TERRORIST: continue;
			default: Format:list("%s{%06x}%s\n", list, c_sub(Team(i, Color)), Team(i, Name));
		}
	}

	return list;
}

team_ReturnList()
{
    new list[144];
	
	foreach(new i : Teams)
	{
		if (i == MERCENARY)
			continue;
		
		Format:list("%s{%06x}%s\n", list, c_sub(Team(i, Color)), Team(i, Name));
	}

	return list;
}

team_IsFree(playerid, teamid)
{
    new team = -1, team_players = -1, team_players2 = -1;

    foreach(new i : Teams)
	{
		if (i != MERCENARY) // Mercenary has no balance
		{ 
	        if (Team(i, Players) > team_players)
			{
	        	team = i;
	        	team_players = Team(i, Players);
			}
		}
    }

    foreach(new i : Teams)
	{
        if (i != MERCENARY)
		{
	        if (i != team)
			{
		        if (Team(i, Players) > team_players2)
				{
		        	team_players2 = Team(i, Players);
				}
			}
		}
    }

    if (teamid == team)
	{
        if (team_players > floatround(float(team_players2) * 1.6, floatround_floor))
		{
            SendClientMessage(playerid, c_red, sprintf("* Team '%s' is full.", Team(team, Name))), 0;
        }
    }

    return 1;
}

/******************************************************************************/
/*							 Admin functions	    						  */
/******************************************************************************/

function admin_PosAfterSpec(playerid)
{
	new Float:x, Float:y, Float:z, Float:a;
	    
 	x = Spec(playerid, X);
	y = Spec(playerid, Y);
	z = Spec(playerid, Z);
	a = Spec(playerid, A);
    SetPlayerPos(playerid, x, y, z + 1.0);
	SetPlayerFacingAngle(playerid, a);

    if (!Var(playerid, Duty))
	{
	    new Float:health, Float:armour, int, world, weapon, ammo;

		health = Spec(playerid, Health);
		armour = Spec(playerid, Armour);
		world = Spec(playerid, World);
		int = Spec(playerid, Int);
		
		SetPlayerHealth(playerid, health);
		SetPlayerArmour(playerid, armour);
		SetPlayerVirtualWorld(playerid, world);
		SetPlayerInterior(playerid, int);

		ResetPlayerWeapons(playerid);

		for(new i = 0, j = MAX_WEAPON_SLOT; i < j; i++)
		{
		    weapon = Spec(playerid, Weapon)[i];
			ammo = Spec(playerid, Ammo)[i];
			GivePlayerWeapon(playerid, weapon, ammo);
		}
		
		if (Var(playerid, HasMask) == 1)
		{
			ToggleMask(playerid, 1);
		}
		
		if (Var(playerid, HasHelmet) == 1)
		{
			ToggleHelmet(playerid, 1);
		}
	}

	SetCameraBehindPlayer(playerid);
}

admin_StartSpec(playerid, specid)
{
	foreach(new i : Player)
	{
		if (GetPlayerState(i) == PLAYER_STATE_SPECTATING)
		{
			if (g_SpecID[i] == playerid)
			{
				admin_AdvanceSpec(i);
			}
		}
	}

	new interior, world;

	interior = GetPlayerInterior(specid);
	world = GetPlayerVirtualWorld(specid);
	SetPlayerInterior(playerid, interior);
	SetPlayerVirtualWorld(playerid, world);
	TogglePlayerSpectating(playerid, 1);

	if (IsPlayerInAnyVehicle(specid))
	{
		PlayerSpectateVehicle(playerid, GetPlayerVehicleID(specid));
		g_SpecID[playerid] = specid;
		Var(playerid, SpecType) = SPEC_TYPE_VEHICLE;
	}
	else
 	{
		PlayerSpectatePlayer(playerid, specid);
		g_SpecID[playerid] = specid;
		Var(playerid, SpecType) = SPEC_TYPE_PLAYER;
	}
}

admin_IsSpectating(playerid, otherid)
{
    return (Var(playerid, SpecType) != SPEC_TYPE_NONE
			&& g_SpecID[playerid] == otherid) ? 1 : 0;
}

admin_StopSpec(playerid)
{
	TogglePlayerSpectating(playerid, 0);

	g_SpecID[playerid] = INVALID_PLAYER_ID;
	Var(playerid, SpecType) = SPEC_TYPE_NONE;
	GameTextForPlayer(playerid, ""#TXT_LINE"~w~spectate mode ended", 1000, 3);
	SetTimerEx("admin_PosAfterSpec", 500, 0, "i", playerid);
}

admin_SendReport(id, id2, reason[], bool:auto = false)
{
    new text[200], log_reason[145];

	if (id2 != -1 && auto == false)
	{
		Format:text("[USER-REPORT] %s[%i] has reported player %s[%i]. Reason: %s", playerName(id2), id2, playerName(id), id, reason);
		IRC_Echo(g_IRC_Conn[IRC_ADMIN_CHANNEL], sprintf(" 0,5 REPORT  %s[%i] has reported player %s[%i]. Reason: %s", playerName(id2), id2, playerName(id), id, reason));
		Format:log_reason("%s[%i] on %s. (Reason: %s)", playerName(id2), id2, return_Stamp(), reason);
		LogReport(id2, id, log_reason);
		
		if (g_Reporter[id] == INVALID_PLAYER_ID)
		{
			g_Reporter[id] = id2;
		}
	}
	else
	{
		Format:text("[AUTO-REPORT] Reporting player %s (ID: %d), %s.", playerName(id), id, reason);
		IRC_Echo(g_IRC_Conn[IRC_ADMIN_CHANNEL], sprintf(" 0,5 AUTO REPORT  Player %s (ID: %d), possible %s.", playerName(id), id, reason));
	   	Format:log_reason("the server on %s. (Reason: %s)", return_Stamp(), reason);
		LogReport(-1, id, log_reason);
		Var(id, ReportTime) = gettime() + 15;
	}

	foreach(new i : Player)
	{
		if (Player(i, Level) >= 1)
		{
		    SendClientMessage(i, c_tomato, text);
		    GameTextForPlayer(i, (auto == false) ? (""#TXT_LINE"~r~incoming~n~user report") : (""#TXT_LINE"~r~incoming~n~auto report"), 6000, 3);
			PlayerPlaySound(i, 1084, 0.0, 0.0, 0.0);
		}
	}
}

LogReport(reporter, offender, reason[])
{
	new id = -1;

	for(new i; i < 5; i++)
	{
		if (!Report(i, Used))
		{
		    id = i;
		    break;
		}
	}

	if (id == -1)
	{
		for(new i = 1; i < 5; i++)
		{
			Report(i - 1, Used) = Report(i, Used);
			format(Report(i - 1, Name), 35, "%s", Report(i, Name));
			format(Report(i - 1, Reason), 128, "%s", Report(i, Reason));
		}

		id = 4;
	}

	Report(id, Used) = true;
	
	if (reporter != -1)
	{
		format(Report(id, By), 24, "%s", playerName(reporter));
	}
	
	format(Report(id, Name), 35, "%s[%i]", playerName(offender), offender);
	format(Report(id, Reason), 128, "%s", reason);
}

admin_AdvanceSpec(playerid)
{
	if (Server(Players) <= 2)
	    return admin_StopSpec(playerid);

	new _state1 = GetPlayerState(playerid);
	
	if (_state1 == PLAYER_STATE_SPECTATING && g_SpecID[playerid] != INVALID_PLAYER_ID)
	{
	    new _state2;
	    
	    for (new i = g_SpecID[playerid] + 1; i <= MAX_PLAYERS; ++i)
 		{
	    	if (i == MAX_PLAYERS)
	    	{
				i = 0;
			}

			if (IsPlayerConnected(i) && (i != playerid))
			{
			    _state2 = GetPlayerState(i);

				if (_state2 == PLAYER_STATE_SPECTATING && g_SpecID[i] != INVALID_PLAYER_ID || (_state2 != 1 && _state2 != 2 && _state2 != 3))
				{
					continue;
				}
				else
				{
					admin_StartSpec(playerid, i);
					break;
				}
			}
		}
	}

	return 1;
}

admin_ReverseSpec(playerid)
{
    if (Server(Players) <= 2)
	    return admin_StopSpec(playerid);

	new _state1 = GetPlayerState(playerid);
	
	if (_state1 == PLAYER_STATE_SPECTATING && g_SpecID[playerid] != INVALID_PLAYER_ID)
	{
	    new _state2;

	    for (new i = g_SpecID[playerid] - 1; i >= 0; --i)
		{
	    	if (!i)
	    	{
				i = MAX_PLAYERS;
			}

			if (IsPlayerConnected(i) && i != playerid)
			{
			    _state2 = GetPlayerState(i);

				if (_state2 == PLAYER_STATE_SPECTATING && g_SpecID[i] != INVALID_PLAYER_ID || (_state2 != 1 && _state2 != 2 && _state2 != 3))
				{
					continue;
				}
				else
				{
					admin_StartSpec(playerid, i);
					break;
				}
			}
		}
	}

	return 1;
}

admin_ToggleDuty(playerid, tog, bool:spawnupdate = false)
{
	switch (tog)
	{
	    case 0:
		{
	        SendClientMessageToAll(c_red, sprintf("- Administrator %s[%i] is no longer on duty.", playerName(playerid), playerid));
            IRC_Echo(g_IRC_Conn[IRC_MAIN_CHANNEL], sprintf("4- Administrator %s[%i] is no longer on duty.", playerName(playerid), playerid));
			SetPlayerHealth(playerid, 0.0);
			Var(playerid, PlayerStatus) = PLAYER_STATUS_SWITCHING_TEAM;
		}
		case 1:
		{
		    ResetPlayerWeapons(playerid);
		    
      		Var(playerid, Duty) = true;

			SetPlayerHealth(playerid, FLOAT_INFINITE);
			SetSkin(playerid, 217);
			SetPlayerColor(playerid, ac_duty);
			SetPlayerArmour(playerid, 100.0);
			SetPlayerTeam(playerid, playerid + 1000);

			Player(playerid, Class) = 0;
			GivePlayerWeapon(playerid, 38, 50000);

			if (Var(playerid, SpawnPoint) != 0)
			{
			    Var(playerid, SpawnPoint) = 0;
			}

			if (!spawnupdate)
			{
				if (Player(playerid, PlayingTeam) == Player(playerid, Team))
				{
					--Team(Player(playerid, Team), Players);
					Player(playerid, PlayingTeam) = 0;
					Player(playerid, Team) = MERCENARY;
    			}

				UpdateBoard(playerid);
				squad_RemovePlayer(playerid);
		    	SendClientMessageToAll(c_red, sprintf("- Administrator %s[%i] is now on duty.", playerName(playerid), playerid));
				IRC_Echo(g_IRC_Conn[IRC_MAIN_CHANNEL], sprintf("4- Administrator %s[%i] is now on duty.", playerName(playerid), playerid));
				SendClientMessage(playerid, c_grey, "* Type '/aduty' again to toggle admin duty off.");
			}

			Update3DTextLabelText(Player(playerid, RankText), ac_duty, "On duty Admin\nPlease do not attack");
		}
	}
}

admin_CommandMessage(playerid, cmd[], int1 = -1, int2 = -1)
{
	new string[100];

	if (int1 == -1 && int2 == -1)
	{
		Format:string("[CMD] %s: /%s", playerName(playerid), cmd);
		IRC_Echo(g_IRC_Conn[IRC_ADMIN_CHANNEL], sprintf("10[CMD] %s: /%s", playerName(playerid), cmd));
	}
	else if (int2 == -1)
	{
		Format:string("[CMD] %s: /%s %i", playerName(playerid), cmd, int1);
		IRC_Echo(g_IRC_Conn[IRC_ADMIN_CHANNEL], sprintf("10[CMD] %s: /%s %i", playerName(playerid), cmd, int1));
	}
	else
	{
		Format:string("[CMD] %s: /%s %i %i", playerName(playerid), cmd, int1, int2);
		IRC_Echo(g_IRC_Conn[IRC_ADMIN_CHANNEL], sprintf("10[CMD] %s: /%s", playerName(playerid), cmd, int1, int2));
	}

	admin_SendMessage(1, ac_cmd_usage, string, playerid);
}

admin_IsOnline()
{
	foreach(new i : Player)
	{
	    if (Player(i, Level) > 0)
		    return true;
	}

	return false;
}

admin_SendMessage(level, color, const string[], sender = INVALID_PLAYER_ID)
{
	foreach(new i : Player)
	{
		if (Player(i, Level) >= level)
		{
			if (sender != INVALID_PLAYER_ID)
			{
				if (sender == i)
					continue;
					
				SendClientMessage(i, color, string);
			}
			else
			{
				SendClientMessage(i, color, string);
			}
		}
	}
}

admin_SendPM(sender, receiver, msg[])
{
	foreach(new i : Player)
	{
		if (Player(i, Level) > 0 && i != sender && i != receiver)
		{
			if (Player(sender, Level) < Player(i, Level) && Player(receiver, Level) < Player(i, Level))
			{
				SendClientMessage(i, c_grey, msg);
			}
		}
	}
}

/******************************************************************************/
/*							 Squad functions	    						  */
/******************************************************************************/
squad_IsNameTaken(name[])
{
	foreach(new i : Squads)
	{
	    if (!strcmp(name, g_Squads[i][sq_Name]))
	        return 1;
	}
	return 0;
}

squad_IsValid(squadid)
{
	return (g_Squads[squadid][sq_Team]) ? 1 : 0;
}

squad_ShowList(playerid)
{
    new count = 0, list[128];

    SendClientMessage(playerid, -1, "Showing available squads:");

	foreach(new i : Squads)
	{
	    ++count;
 		Format:list("%i:  Squad: %s   (ID: %i)", count, g_Squads[i][sq_Name], i);
		SendClientMessage(playerid, -1, list);
	}

	if (!count)
	{
	    SendClientMessage(playerid, c_red, "None");
	}

	return 1;
}

squad_ShowInfo(playerid, squadid)
{
	new string[100], count = 0;

	SendClientMessage(playerid, c_lime, sprintf("Showing info of squad: '%s'", g_Squads[squadid][sq_Name]));
	SendClientMessage(playerid, c_lime, sprintf("ID: %i | Team: %s | Members: %i", squadid, Team(g_Squads[squadid][sq_Team], Name), squad_CountMembers(squadid)));
	
	foreach(new i : SquadMembers[squadid])
	{
		if (!i)
		{
		    Format:string("  Leader: %s[%i]", playerName(g_Squads[squadid][sq_Members][0]), g_Squads[squadid][sq_Members][0]);
            SendClientMessage(playerid, c_lime, string);
		}
		else
		{
			++count;
	        Format:string("  %s[%i]", playerName(g_Squads[squadid][sq_Members][i]), g_Squads[squadid][sq_Members][i]);
            SendClientMessage(playerid, c_lime, string);
		}
	}
}

squad_Create(playerid, name[])
{
    new squadid = Iter_Free(Squads);

	Iter_Add(Squads, squadid);
	Iter_Add(SquadMembers[squadid], 0);

	g_Squads[squadid][sq_Members][0] = playerid;

	Var(playerid, SquadID) = squadid;
    g_Squads[squadid][sq_Team] = Player(playerid, Team);

    format(g_Squads[squadid][sq_Name], 15, "%s", name);
	UpdateLabel(playerid);

	SendClientMessage(playerid, -1, sprintf("You have created a squad named '%s'.", g_Squads[squadid][sq_Name]));
	SendClientMessage(playerid, c_grey, "* To invite other teammates in your squad, type /invite <playerid/name>.");
}

squad_Join(playerid, squadid)
{
	new slot = Iter_Free(SquadMembers[squadid]);

    Iter_Add(SquadMembers[squadid], slot);

    g_Squads[squadid][sq_Members][slot] = playerid;
	Var(playerid, SquadID) = squadid;
    
	UpdateLabel(playerid);
	SendClientMessage(playerid, -1, sprintf("You have joined the squad '%s', ID: %i.", g_Squads[squadid][sq_Name], squadid));
	SendClientMessage(playerid, c_grey, "* Type '/sinfo' to see the information of this squad.");
	squad_SendMessage(squadid, c_lime, sprintf("%s has joined the squad.", playerName(playerid)));
}

squad_RemovePlayer(playerid)
{
	if (Var(playerid, SquadID) != -1)
	{
		new squadid = Var(playerid, SquadID);

		if (squad_CountMembers(squadid) == 1)
		{
	  		squad_Drop(squadid);
			return 1;
		}

		Var(playerid, SquadID) = -1;
		squad_SendMessage(squadid, c_tomato, sprintf("[SQUAD] %s has left.", playerName(playerid)));
		UpdateLabel(playerid);

		if (g_Squads[squadid][sq_Members][0] == playerid)
		{
		    new member;

			Iter_Remove(SquadMembers[squadid], 0);
	        g_Squads[squadid][sq_Members][0] = 0;

			foreach(new i : SquadMembers[squadid])
			{
				member = g_Squads[squadid][sq_Members][i];
	            Iter_Remove(SquadMembers[squadid], i);
	            g_Squads[squadid][sq_Members][i] = 0;
				break;
			}
			
			Iter_Add(SquadMembers[squadid], 0);
			g_Squads[squadid][sq_Members][0] = member;
			return 1;
		}

	    new slot;

		foreach(new i : SquadMembers[squadid])
		{
		    if (g_Squads[squadid][sq_Members][i] == playerid)
			{
		        slot = i;
		        break;
		    }
		}
		Iter_Remove(SquadMembers[squadid], slot);
		g_Squads[squadid][sq_Members][slot] = 0;
	}
	return 1;
}

squad_Drop(squadid)
{
	new members;

	foreach(new i : SquadMembers[squadid])
	{
	    members = g_Squads[squadid][sq_Members][i];
		Var(i, SquadID) = -1;
		SendClientMessage(members, c_red, "[SQUAD] The leader has dropped the squad.");
		UpdateLabel(members);
	}

	g_Squads[squadid][sq_Name][0] = '\0';
	g_Squads[squadid][sq_Team] = 0;
	Iter_Clear(SquadMembers[squadid]);
	Iter_Remove(Squads, squadid);
}

squad_CountMembers(squadid)
{
	return Iter_Count(SquadMembers[squadid]);
}

squad_Reward(playerid, cash, score, msg[])
{
	new squadid = Var(playerid, SquadID), members;

	foreach(new i : SquadMembers[squadid])
	{
	    members = g_Squads[squadid][sq_Members][i];

		if (members != playerid)
		{
	        RewardPlayer(members, cash, score);
	        SendClientMessage(members, c_lime, msg);
		}
	}
}

squad_SendMessage(squadid, color, msg[])
{
    foreach(new i : SquadMembers[squadid])
	{
		SendClientMessage(g_Squads[squadid][sq_Members][i], color, msg);
	}
}

/******************************************************************************/
/*							 Clan functions	    						  	  */
/******************************************************************************/
clan_GivePoints(clanid, amount)
{
	new query[100];
	
	Clan(clanid, Points) += amount;
	Query("UPDATE `clans` SET `clan_points`='%i' WHERE `clan_id`='%i'", Clan(clanid, Points), clanid);
	mysql_tquery(connection, query, "ExecuteQuery", "i", res_none);
	
	return 1;
}

clan_IsPlayerLeader(playerid, clanid)
{
	if (Player(playerid, ClanID) == clanid && !Player(playerid, ClanLeader))
 	{
	 	return 0;
 	}
	return 1;
}

clan_IsSkinTaken(skinid)
{
	foreach(new i : Clans)
	{
		if (Clan(i, Skin) == skinid)
		{
		    return true;
		}
	}
	return false;
}

clan_IsPlayerFounder(playerid, clanid)
{
	if (strcmp(playerName(playerid), Clan(clanid, Founder)))
	{
	    return 0;
	}
	return 1;
}

Float:clan_ReturnCWRatio(clanid)
{
	new lost;

	lost = Clan(clanid, CW_Lost);

	if (lost < 1)
	{
		lost = 1;
	}

	return floatdiv(Clan(clanid, CW_Win), lost);
}

clan_ShowInfo(playerid, clanid)
{
	new d_str[1000];

	strcat(d_str, ""#sc_green"%s\n\n\n");
    strcat(d_str, ""#sc_green"Founder: "#sc_white"%s\n");
	strcat(d_str, ""#sc_green"Tag: "#sc_white"%s\n");
	strcat(d_str, ""#sc_green"Points: "#sc_white"%i\n");
	strcat(d_str, ""#sc_green"Members: "#sc_white"%i\n");
	strcat(d_str, ""#sc_green"Formed On: "#sc_white"%s\n");
	strcat(d_str, "\n");
	strcat(d_str, ""#sc_green"ClanWar Won: "#sc_white"%i\n");
	strcat(d_str, ""#sc_green"ClanWar Lost: "#sc_white"%i\n");
	strcat(d_str, ""#sc_green"ClanWar Ratio: "#sc_white"%.2f");
	Format:d_str( 	d_str, Clan(clanid, Motto), Clan(clanid, Founder), Clan(clanid, Tag), Clan(clanid, Points), Clan(clanid, MemberCount), Clan(clanid, Registered), Clan(clanid, CW_Win), Clan(clanid, CW_Lost), clan_ReturnCWRatio(clanid));
	return ShowPlayerDialog(playerid, D_CLAN_INFO, DIALOG_STYLE_MSGBOX, sprintf("%s", Clan(clanid, Name)), d_str, (Var(playerid, ViewingDialog)) ? ("Back") : ("Close"), "");
}

clan_SendMessage(clanid, color, msg[])
{
	foreach(new i : Player)
	{
		if (Player(i, ClanID) == clanid)
		{
		    SendClientMessage(i, color, msg);
		}
	}
}

clan_CountLeaders(clanid)
{
	new count = 0;
	
	foreach(new i : Player)
	{
	    if (Player(i, ClanID) == clanid && Player(i, ClanLeader))
	    {
			count++;
		}
	}

	return count;
}

clan_IsPlayingCW(clanid)
{
	for (new i = 0, j = MAX_CLANWAR; i < j; i++)
	{
	    if (CW(i, Clan1) == clanid || CW(i, Clan2) == clanid)
	    {
	        return true;
		}
	}

	return false;
}

// Clan war functions
CW_ReturnFreeSlot()
{
	for (new i = 0, j = MAX_CLANWAR; i < j; i++)
	{
	    if (CW(i, Clan1) == -1 && CW(i, Clan2) == -1)
	    {
	        return i;
	    }
	}

	return -1;
}

CW_UpdateTextDraws(cwid)
{
	new clan1, clan2;
	
	foreach(new i : Player)
	{
	    if (Var(i, PlayingCW) == cwid)
	    {
	        clan1 = CW(cwid, Clan1);
	        clan2 = CW(cwid, Clan2);
			TextDrawSetString(CW(cwid, TD_Main), sprintf("~w~~h~CLAN WAR - ROUND: %i/%i~n~~n~~n~vs", CW(cwid, Rounds), CW(cwid, MaxRounds)));
			TextDrawSetString(CW(cwid, TD_Clan1), sprintf("~w~~h~%s~n~~w~~h~P: %i~n~~w~~h~WINS: %i", Clan(clan1, Tag), CW(cwid, Clan1_Members), CW(cwid, Clan1_Win)));
			TextDrawSetString(CW(cwid, TD_Clan2), sprintf("~w~~h~%s~n~~w~~h~P: %i~n~~w~~h~WINS: %i", Clan(clan2, Tag), CW(cwid, Clan2_Members), CW(cwid, Clan2_Win)));
			
			TextDrawShowForPlayer(i, CW(cwid, TD_Main));
			TextDrawShowForPlayer(i, CW(cwid, TD_Clan1));
			TextDrawShowForPlayer(i, CW(cwid, TD_Clan2));
	    }
	}

	return 1;
}

CW_AcceptInvitation(clanid, playerid)
{
    new leaderid, clan, slot, Float:x, Float:y, Float:z, Float:a, idx, int, world;

	leaderid = Clan(clanid, CW_InvitingPlayer);
	clan = Player(leaderid, ClanID);
	slot = Var(leaderid, PlayingCW);
	Var(playerid, PlayingCW) = slot;
	CW(slot, Clan1) = clan;
	CW(slot, Clan2) = clanid;
    CW(slot, Clan1_Members) = 1;
    CW(slot, Clan2_Members) = 1;
    CW(slot, Clan1_Win) = 0;
    CW(slot, Clan2_Win) = 0;
    idx = CW(slot, Interior);
    
    x = g_CWSpawns[idx][MainSpawnX];
    y = g_CWSpawns[idx][MainSpawnY];
    z = g_CWSpawns[idx][MainSpawnZ];
    a = g_CWSpawns[idx][MainSpawnA];
    int = g_CWSpawns[idx][Interior];
    world = slot + 8888;
    
	ResetPlayerWeapons(playerid);
	ResetPlayerWeapons(leaderid);
	
	Var(playerid, WaitingRound) = true;
    SetPlayerPos(playerid, x, y, z);
    SetPlayerFacingAngle(playerid, a);
    SetPlayerInterior(playerid, int);
    SetPlayerVirtualWorld(playerid, world);
    SetCameraBehindPlayer(playerid);
    
    Var(leaderid, WaitingRound) = true;
    SetPlayerPos(leaderid, x + 1.0, y + 1.0, z);
    SetPlayerFacingAngle(leaderid, a);
    SetPlayerInterior(leaderid, int);
    SetPlayerVirtualWorld(leaderid, world);
    SetCameraBehindPlayer(leaderid);

	Clan(clanid, CW_InvitingPlayer) = INVALID_PLAYER_ID;
    Clan(clanid, CW_Invited) = false;

    SendClientMessage(leaderid, c_green, sprintf("[CW] Leader %s has accepted your clan war invitation.", playerName(playerid)));
    SendClientMessage(playerid, c_green, sprintf("[CW] You have accepted the clan war invitation from %s", Clan(clan, Name)));

	SendClientMessage(leaderid, c_green, "[CW] Both leaders have been teleported to the selected arena, type /cwadd to add your members.");
    SendClientMessage(playerid, c_green, "[CW] Both leaders have been teleported to the selected arena, type /cwadd to add your members.");

	CW_UpdateTextDraws(slot);
	
	if (Player(playerid, Class) != SOLDIER)
	{
	    Player(playerid, Class) = SOLDIER;
		UpdateMap(playerid);
	}

	if (Player(leaderid, Class) != SOLDIER)
	{
	    Player(leaderid, Class) = SOLDIER;
		UpdateMap(leaderid);
	}
}

CW_StartRound(cwid)
{
	new clan1, clan2, Float:x1, Float:y1, Float:z1, Float:a1;
	new Float:x2, Float:y2, Float:z2, Float:a2, idx, int, world;
	
	CW(cwid, Counter) = 6;
	clan1 = CW(cwid, Clan1);
	clan2 = CW(cwid, Clan2);
	idx = CW(cwid, Interior);
    x1 = g_CWSpawns[idx][clan1_SX];
    y1 = g_CWSpawns[idx][clan1_SY];
    z1 = g_CWSpawns[idx][clan1_SZ];
    a1 = g_CWSpawns[idx][clan1_SA];
    x2 = g_CWSpawns[idx][clan2_SX];
    y2 = g_CWSpawns[idx][clan2_SY];
    z2 = g_CWSpawns[idx][clan2_SZ];
    a2 = g_CWSpawns[idx][clan2_SA];
    int = g_CWSpawns[idx][Interior];
    world = cwid + 8888;
    
    SendClientMessageToAll(c_orange, "");
    SendClientMessageToAll(c_orange, sprintf("  <ClanWar>  %s vs %s - round %i is about to start!", Clan(clan1, Name), Clan(clan2, Name), CW(cwid, Rounds)));
    SendClientMessageToAll(c_orange, "");
	
	foreach(new i : Player)
	{
	    if (Var(i, PlayingCW) == cwid)
	    {
	        if (Player(i, ClanID) == clan1)
	        {
	            SetPlayerPos(i, x1, y1, z1);
	            SetPlayerFacingAngle(i, a1);
	        }
	        else if (Player(i, ClanID) == clan2)
	        {
	            SetPlayerPos(i, x2, y2, z2);
	            SetPlayerFacingAngle(i, a2);
	        }

	        SetPlayerInterior(i, int);
	        SetPlayerVirtualWorld(i, world);
	        SetCameraBehindPlayer(i);
	        
	        GivePlayerWeapon(i, 24, 5000);
	        GivePlayerWeapon(i, 27, 5000);
	        GivePlayerWeapon(i, 31, 5000);
	        SetPlayerHealth(i, 100.0);
	        SetPlayerArmour(i, 100.0);
	        TogglePlayerControllable(i, 0);
	        Var(i, PlayingInCW) = true;
	        Var(i, WaitingRound) = false;
	    }
	}
	Clan(clan1, CW_Requested) = -1;
	CW(cwid, Started) = true;
	CW(cwid, Timer) = SetTimerEx("CW_CountDown", 1000, true, "i", cwid);
}

function CW_CountDown(cwid)
{
	if (--CW(cwid, Counter) <= 0)
	{
	    foreach(new i : Player)
		{
			if (Var(i, PlayingCW) == cwid)
			{
			    CW(cwid, Counter) = 0;
			    KillTimer(CW(cwid, Timer));
			    CW(cwid, Timer) = -1;
			    GameTextForPlayer(i, "~n~~g~~h~GO!", 2000, 3);
			    TogglePlayerControllable(i, 1);
			}
		}
	}
	else
	{
	    foreach(new i : Player)
		{
			if (Var(i, PlayingCW) == cwid)
			{
	    		GameTextForPlayer(i, sprintf("~w~round ~g~~h~%i ~w~is starting in~n~~n~~w~%i", CW(cwid, Rounds), CW(cwid, Counter)), 7000, 3);
			}
		}
	}
}

CW_AddPlayer(cwid, playerid, bool:spawn = false)
{
	new Float:x, Float:y, Float:z, Float:a, idx, int, world;
	
	idx = CW(cwid, Interior);
 	x = g_CWSpawns[idx][MainSpawnX];
    y = g_CWSpawns[idx][MainSpawnY];
    z = g_CWSpawns[idx][MainSpawnZ];
    a = g_CWSpawns[idx][MainSpawnA];
    int = g_CWSpawns[idx][Interior];
    world = cwid + 8888;
	ResetPlayerWeapons(playerid);
	
 	SetPlayerPos(playerid, x, y, z);
    SetPlayerFacingAngle(playerid, a);
    SetPlayerInterior(playerid, int);
    SetPlayerVirtualWorld(playerid, world);
    SetCameraBehindPlayer(playerid);
	Var(playerid, WaitingRound) = true;

    if (spawn == false)
    {
        new clanid = Player(playerid, ClanID);
        
	    Var(playerid, PlayingCW) = cwid;

	    if (clanid == CW(cwid, Clan1))
	    {
	        ++CW(cwid, Clan1_Members);
		}
		else if (clanid == CW(cwid, Clan2))
	    {
	        ++CW(cwid, Clan2_Members);
		}
		
		CW_UpdateTextDraws(cwid);
	}
}

CW_RemovePlayer(playerid)
{
	new cwid = Var(playerid, PlayingCW);

	if (cwid != -1)
	{
	    new p_clan, clan1, clan2;
	    
	    Var(playerid, PlayingCW) = -1;
	    p_clan = Player(playerid, ClanID);
	    Var(playerid, WaitingRound) = false;
	    clan1 = CW(cwid, Clan1);
	    clan2 = CW(cwid, Clan2);

	    if (p_clan == clan1)
	    {
	        --CW(cwid, Clan1_Members);
	        CW_UpdateTextDraws(cwid);
	        
	        if (CW(cwid, Clan1_Members) == 0)
	        {
	            CW_Cancel(cwid, sprintf("* Clan %s has no members connected, clan war has been canceled.", Clan(clan1, Name)));
	        }
	    }
	    else if (p_clan == clan2)
	    {
	        --CW(cwid, Clan2_Members);
			CW_UpdateTextDraws(cwid);
	        
	        if (CW(cwid, Clan2_Members) == 0)
	        {
	            CW_Cancel(cwid, sprintf("* Clan %s has no members connected, clan war has been canceled.", Clan(clan2, Name)));
	        }
	    }
	}
}

CW_IsDraw(cwid)
{
    if (CW(cwid, Rounds) == (CW(cwid, MaxRounds) + 1) && CW(cwid, Clan1_Win) == CW(cwid, Clan2_Win))
    {
        return true;
	}
	return false;
}

CW_UpdatePlayerStatus(playerid, cwid)
{
    new p_clan, clan1, clan2, max_rounds;

    p_clan = Player(playerid, ClanID);
    clan1 = CW(cwid, Clan1);
    clan2 = CW(cwid, Clan2);
    max_rounds = (CW(cwid, MaxRounds) + 1);

    if (p_clan == clan1)
    {
        --CW(cwid, Clan1_Members);
        CW_UpdateTextDraws(cwid);
        
        if (!CW(cwid, Clan1_Members))
        {
      		++CW(cwid, Rounds);
		  	++CW(cwid, Clan2_Win);
			
			if (CW_IsDraw(cwid))
      		{
      			CW_Draw(cwid, clan1, clan2);
				return 1;
			}
        }
    }
    else if (p_clan == clan2)
    {
        --CW(cwid, Clan2_Members);
		CW_UpdateTextDraws(cwid);
        if (!CW(cwid, Clan2_Members))
        {
            ++CW(cwid, Rounds);
			++CW(cwid, Clan1_Win);

            if (CW_IsDraw(cwid))
 			{
                CW_Draw(cwid, clan2, clan1);
                return 1;
			}
		}
    }

    if (CW(cwid, Clan2_Win) > CW(cwid, Clan1_Win))
    {
		CW_Winner(cwid, clan2, clan1, (CW(cwid, Rounds) == max_rounds) ? true : false);
	}
	else if (CW(cwid, Clan1_Win) > CW(cwid, Clan2_Win))
	{
		CW_Winner(cwid, clan1, clan2, (CW(cwid, Rounds) == max_rounds) ? true : false);
	}
	
	return 1;
}

CW_Draw(cwid, clan1, clan2)
{
    SendClientMessageToAll(c_red, "");
	SendClientMessageToAll(c_red, sprintf("  <ClanWar>  Final result: %s vs %s was a draw.", Clan(clan1, Name), Clan(clan2, Name)));
    SendClientMessageToAll(c_red, "");
	
	foreach(new i : Player)
	{
	    if (Var(i, PlayingCW) == cwid)
	    {
	        Var(i, PlayingCW) = -1;
	        TextDrawHideForPlayer(i, CW(cwid, TD_Main));
	        TextDrawHideForPlayer(i, CW(cwid, TD_Clan1));
	        TextDrawHideForPlayer(i, CW(cwid, TD_Clan2));
	        
	        if (GetPlayerState(i) != PLAYER_STATE_WASTED)
	        {
	            ProtectedSpawn(i);
	        }
	    }
	}

	CW_ClearData(cwid);
}

CW_Winner(cwid, winning_clan, losing_clan, bool:final = false)
{
	if (final == false)
	{
	    new round = CW(cwid, Rounds) - 1;
	    
	    SendClientMessageToAll(c_darkgreen, "");
	    SendClientMessageToAll(c_darkgreen, sprintf("  <ClanWar>  Result: %s won round %i against %s.", Clan(winning_clan, Name), round, Clan(losing_clan, Name)));
        SendClientMessageToAll(c_darkgreen, "");
		clan_SendMessage(winning_clan, c_green, sprintf("Your clan won round %i against %s.", round, Clan(losing_clan, Name)));
		clan_SendMessage(losing_clan, c_red, sprintf("Your clan lost round %i against %s.", round, Clan(winning_clan, Name)));
		
		CW(cwid, Clan1_Members) = CW(cwid, Members);
		CW(cwid, Clan2_Members) = CW(cwid, Members);
		CW_SpawnMembersInArena(cwid);
		CW_UpdateTextDraws(cwid);
		CW(cwid, Started) = false;
	}
	else
	{
	    new query[145];
	    
	    ++Clan(winning_clan, CW_Win);
		++Clan(losing_clan, CW_Lost);
		Clan(losing_clan, Points) -= CW(cwid, Bet);
		Clan(winning_clan, Points) += CW(cwid, Bet);
	    
	    SendClientMessageToAll(c_green, "");
		SendClientMessageToAll(c_green, sprintf("  <ClanWar>  Final result: %s won against %s.", Clan(winning_clan, Name), Clan(losing_clan, Name)));
        SendClientMessageToAll(c_green, "");
		clan_SendMessage(winning_clan, c_green, sprintf("Your clan won the war against %s and won %i points, congratulations!", Clan(losing_clan, Name), CW(cwid, Bet)));
		clan_SendMessage(losing_clan, c_red, sprintf("Your clan lost the war against %s and lost %i points.", Clan(winning_clan, Name), CW(cwid, Bet)));
		
		Query("UPDATE `clans` SET `cw_won`='%i',`clan_points`='%i' WHERE `clan_id`='%i'", Clan(winning_clan, CW_Win), Clan(winning_clan, Points), winning_clan);
		mysql_tquery(connection, query, "ExecuteQuery", "i", res_none);
		
		Query("UPDATE `clans` SET `cw_lost`='%i',`clan_points`='%i' WHERE `clan_id`='%i'", Clan(losing_clan, CW_Lost), Clan(losing_clan, Points), losing_clan);
		mysql_tquery(connection, query, "ExecuteQuery", "i", res_none);
		
		foreach(new i : Player)
		{
		    if (Var(i, PlayingCW) == cwid)
		    {
		        Var(i, PlayingCW) = -1;
		        TextDrawHideForPlayer(i, CW(cwid, TD_Main));
		        TextDrawHideForPlayer(i, CW(cwid, TD_Clan1));
		        TextDrawHideForPlayer(i, CW(cwid, TD_Clan2));
		        if (GetPlayerState(i) != PLAYER_STATE_WASTED)
		        {
		            ProtectedSpawn(i);
		        }
		    }
		}

		CW_ClearData(cwid);
	}
}

CW_SpawnMembersInArena(cwid)
{
	new Float:x, Float:y, Float:z, Float:a, idx, int, world;

    idx = CW(cwid, Interior);

    x = g_CWSpawns[idx][MainSpawnX];
    y = g_CWSpawns[idx][MainSpawnY];
    z = g_CWSpawns[idx][MainSpawnZ];
    a = g_CWSpawns[idx][MainSpawnA];
    int = g_CWSpawns[idx][Interior];
    world = cwid + 8888;

	foreach(new i : Player)
	{
	    if (Var(i, PlayingCW) == cwid)
	    {
	        if (GetPlayerState(i) != PLAYER_STATE_WASTED)
	        {
				ResetPlayerWeapons(i);

			    SetPlayerPos(i, x, y, z);
			    SetPlayerFacingAngle(i, a);
			    SetPlayerInterior(i, int);
			    SetPlayerVirtualWorld(i, world);
			    SetCameraBehindPlayer(i);
				Var(i, WaitingRound) = true;
			}
		}
	}
}

CW_Cancel(cwid, reason[])
{
	foreach(new i : Player)
	{
	    if (Var(i, PlayingCW) == cwid)
	    {
	        Var(i, PlayingCW) = -1;
	        ProtectedSpawn(i);
	        SendClientMessage(i, c_red, reason);
	        TextDrawHideForPlayer(i, CW(cwid, TD_Main));
	        TextDrawHideForPlayer(i, CW(cwid, TD_Clan1));
	        TextDrawHideForPlayer(i, CW(cwid, TD_Clan2));
	        TogglePlayerControllable(i, 1);
	        Var(i, WaitingRound) = false;
	    }
	}

	KillTimer(CW(cwid, Timer));
	CW_ClearData(cwid);
}

CW_CanRoundStart(cwid)
{
	foreach(new i : Player)
	{
	    if (Var(i, PlayingCW) == cwid && Var(i, WaitingRound) == false)
        {
            return false;
        }
	}

	return true;
}

CW_ClearData(cwid)
{
    CW(cwid, Clan1) = -1;
	CW(cwid, Clan2) = -1;
    CW(cwid, Clan1_Members) = 0;
    CW(cwid, Clan2_Members) = 0;
    CW(cwid, Clan1_Win) = 0;
    CW(cwid, Clan2_Win) = 0;
    CW(cwid, Members) = 0;
    CW(cwid, Bet) = 0;
    CW(cwid, Timer) = -1;
    CW(cwid, Interior) = 0;
    CW(cwid, MaxRounds) = 0;
    CW(cwid, Rounds) = 0;
    CW(cwid, Started) = false;
}
/******************************************************************************/
/*							 Vehicle functions	    						  */
/******************************************************************************/
vehicle_IsAircraft(vehicleid)
{
	switch (GetVehicleModel(vehicleid))
	{
 		case 417, 425, 447,
		 	460, 469, 476,
			487, 497, 511,
			512, 513, 519,
			520, 548, 553,
			563, 577, 592,
			593: return true;
	}

	return false;
}

vehicle_ReturnModelFromName(v_name[])
{
	for(new i = 0; i < 212; ++i)
	{
		if (strfind(g_VehicleNames[i], v_name, true) != -1)
		{
			return i + 400;
		}
	}

	return -1;
}

vehicle_IsOccupied(vehicleid)
{
	foreach(new i : Player)
	{
	    if (IsPlayerInVehicle(i, vehicleid))
		{
	        return 1;
		}
	}

	return 0;
}

/******************************************************************************/
/*        					Zone functions	  			  					  */
/******************************************************************************/

zone_Create(zoneid, zonename[], Float:pointX, Float:pointY, Float:pointZ, Float:minX, Float:minY, Float:maxX, Float:maxY, Float:flagX, Float:flag_Y, Float:flag_Z)
{
	Iter_Add(Zones, zoneid);
	Zone(zoneid, Pickup) = CreatePickup(19133, 1, pointX, pointY, pointZ);
	Zone(zoneid, Label) = CreateDynamic3DTextLabel(sprintf("%s\n\nCapture time: %is\nZone score: +%i", zonename, floatround(Zone(zoneid, TotalCapTime)), Zone(zoneid, Score)), -1, pointX, pointY, pointZ + 1.2, 50.0);
	Zone(zoneid, Icon) = CreateDynamicMapIcon(pointX, pointY, pointZ, 19, 0, -1, -1, -1, FLOAT_INFINITE);
	Zone(zoneid, Zone) = GangZoneCreate(minX, minY, maxX, maxY);
	Zone(zoneid, Area) = CreateDynamicRectangle(minX, minY, maxX, maxY);
	Zone(zoneid, PointArea) = CreateDynamicSphere(pointX, pointY, pointZ, 1.5);
	
	if (flagX != 0.0 && flag_Y != 0.0 && flag_Z != 0.0)
	{
	    Flag(zoneid, HoldingObj) = CreateDynamicObject(3885, flagX, flag_Y, flag_Z - 1.0, 0.0, 0.0, 0.0, -1, -1, -1, 300.00, 300.00);
	 	Flag(zoneid, Pickup) = CreateDynamicPickup(2993, 1, flagX, flag_Y, flag_Z);
		Flag(zoneid, FlagLabel) = CreateDynamic3DTextLabel(sprintf("%s flag\nFlag score: +%i\n\nPress 'Y' to pick up this flag", zonename, Zone(zoneid, Score) - 1), -1, flagX, flag_Y, flag_Z, 50.0);
     	Flag(zoneid, CapturingPlayer) = -1;
		Zone(zoneid, HasFlag) = true;
	}
}

zone_DropFlag(playerid)
{
    if (GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
	{
		if (Var(playerid, CapturingFlag) != -1)
		{
		    new zoneid, reward, score, team, boost_active;

			boost_active = IsItemActivated(Player(playerid, BoostActivated));
		    zoneid = Var(playerid, CapturingFlag);
		    team = Player(playerid, Team);
			Var(playerid, CapturingFlag) = -1;
			DetachFlag(playerid);
			DisablePlayerRaceCheckpoint(playerid);
			
			if (Player(playerid, ClanID) != -1)
			{
			    new clanid = Player(playerid, ClanID);

			    clan_GivePoints(clanid, 1);
			    clan_SendMessage(clanid, c_clan, sprintf("Clan '%s' received +1 point from the flag stolen by %s.", Clan(clanid, Name), playerName(playerid)));
			}
			
			score = Zone(zoneid, Score);
			reward = (score * 1000) - RandomEx(100, 500);
			SendClientMessage(playerid, c_green, sprintf("You received +%i score and $%i for stealing the flag of %s.", score, reward, Zone(zoneid, Name)));
            ScreenMessage(playerid, "FLAG STOLEN", sprintf("~y~~h~+%i SCORE", score));

			Player(playerid, CapturedFlags) += (boost_active) ? 2 : 1;
			RewardPlayer(playerid, reward, score, true);
			PlayerPlaySound(playerid, 1054, 0.0, 0.0, 0.0);
			
			if (boost_active)
			{
			    SendClientMessage(playerid, c_darkgreen, sprintf("VIP Boost: "#sc_white"You received extra %i score, 1 flag steal and $%i.", score, reward));
			    RewardPlayer(playerid, reward, score);
			}
			
			News(sprintf("~y~~h~%s has dropped the flag of %s at their base", playerName(playerid), Zone(zoneid, Name)));
            IRC_Echo(g_IRC_Conn[IRC_MAIN_CHANNEL], sprintf("7[FLAG] %s dropped the flag of %s at their base!", playerName(playerid), Zone(zoneid, Name)));
			
			if (Var(playerid, SquadID) != -1)
			{
			    new sq_reward;

				sq_reward = RandomEx(100, 1000);
				squad_Reward(playerid, sq_reward, 1, sprintf("The squad received +$%i and +1 score from flag stolen by %s.", sq_reward, playerName(playerid)));
			}
			
			foreach(new i : Player)
			{
				if (playerid != i && !Var(i, DM) && Player(i, Team) == team)
				{
					SendClientMessage(i, c_lightyellow, sprintf("Team %s received $2000 from the flag stolen by %s.", Team(team, Name), playerName(playerid)));
					RewardPlayer(i, 2000, 0);
				}
			}

			Flag(zoneid, Time) = gettime() + 310;
			Flag(zoneid, CapturedTeam) = Player(playerid, Team);
            Flag(zoneid, CapturingPlayer) = -1;
            Flag(zoneid, Captured) = true;
		}
	}
}

zone_StartCapture(playerid, zoneid)
{
	new teamid;

	teamid = Player(playerid, Team);
	
	if (teamid)
	{
		switch (teamid)
		{
		 	case MERCENARY, TERRORIST:
	 		{
		    	SendClientMessage(playerid, c_red, sprintf("* %s cannot capture zones.", Team(teamid, Name)));
			}
			default:
			{
				if (Zone(zoneid, Team) == teamid)
				{
					SendClientMessage(playerid, c_red, "* This zone is already captured by your team.");
				}
				else
				{
					if (Var(playerid, RecentZone) != zoneid && Var(playerid, CappingZone) == -1)
					{
					    new Float:x, Float:y, Float:z;

						x = Zone(zoneid, PointX);
						y = Zone(zoneid, PointY);
						z = Zone(zoneid, PointZ);

						if (Zone(zoneid, Capturing))
						{
						    if (Zone(zoneid, CapturingTeam) == teamid)
							{
								if (!Var(playerid, Assisting))
								{
								    SetPlayerProgressBarMaxValue(playerid, g_TextDraw[playerid][ZoneBar], Zone(zoneid, TotalCapTime));
									SetPlayerCheckpoint(playerid, x, y, z, 3.0);
									Var(playerid, CappingZone) = zoneid;
									Var(playerid, Assisting) = true;
									SendClientMessage(Zone(zoneid, CappingPlayer), c_green, "* Your teammate is assisting you to capture this zone.");
									SendClientMessage(playerid, c_green, sprintf("* You have started assisting your teammate to capture the %s.", Zone(zoneid, Name)));
								}
							}
						}
						else
						{
						    new z_team = Zone(zoneid, Team);

						    SetPlayerProgressBarMaxValue(playerid, g_TextDraw[playerid][ZoneBar], Zone(zoneid, TotalCapTime));

							Zone(zoneid, Capturing) = true;
					        Zone(zoneid, CapturingTeam) = teamid;
					        Zone(zoneid, CapTime) = 0;
							Zone(zoneid, CappingPlayer) = playerid;
							Var(playerid, CappingZone) = zoneid;
							SetPlayerCheckpoint(playerid, x, y, z, 3.0);

							if (Zone(zoneid, Team))
							{
					            SendClientMessage(playerid, -1, sprintf("* You have started capturing the %s, controlled by the {%06x}%s{%06x}.", Zone(zoneid, Name), c_sub(Team(z_team, Color)), Team(z_team, Name), c_sub(-1)));
								team_SendMessage(z_team, c_tomato, sprintf("[ALERT] %s is trying to capture the %s!", Team(teamid, Name), Zone(zoneid, Name)));
							}
							else
							{
								SendClientMessage(playerid, -1, sprintf("* You have started capturing the %s.", Zone(zoneid, Name)));
							}

							SendClientMessage(playerid, c_grey, sprintf("* Stay in the red checkpoint for %i seconds to capture this zone.", floatround(Zone(zoneid, TotalCapTime))));
							GangZoneFlashForAll(Zone(zoneid, Zone), (Team(teamid, Color) & opacity));
						}
					}
				}
			}
		}
	}

	return 1;
}

zone_StopCapture(playerid)
{
	new zoneid = Var(playerid, CappingZone);
	
    Var(playerid, CappingZone) = -1;
	SetPlayerProgressBarMaxValue(playerid, g_TextDraw[playerid][ZoneBar], 0.0);
	DisablePlayerCheckpoint(playerid);
	HidePlayerProgressBar(playerid, g_TextDraw[playerid][ZoneBar]);

	if (Var(playerid, Assisting))
	{
		Var(playerid, Assisting) = false;
	}
	else
	{
	    foreach(new i : Player)
		{
	        if (Var(i, CappingZone) != -1 && Var(i, CappingZone) == zoneid)
			{
				if (Var(i, Assisting) == true)
				{
					Var(i, Assisting) = false;
					Var(i, CappingZone) = -1;
					DisablePlayerCheckpoint(i);
					SetPlayerProgressBarMaxValue(i, g_TextDraw[i][ZoneBar], 0.0);
					HidePlayerProgressBar(i, g_TextDraw[i][ZoneBar]);
					SendClientMessage(i, c_red, "* Your teammate failed to capture this zone, capture process has been stopped.");
				}
			}
		}

	    Zone(zoneid, Capturing) = false;
		Zone(zoneid, CapturingTeam) = -1;
		Zone(zoneid, CappingPlayer) = -1;
		GangZoneStopFlashForAll(Zone(zoneid, Zone));
	}
}

zone_StartFlagCapture(playerid, zoneid)
{
	new teamid = Player(playerid, Team);

	if (teamid)
	{
		switch (teamid)
		{
			case MERCENARY, TERRORIST:
			{
		    	SendClientMessage(playerid, c_red, sprintf("* %s cannot pick zone flags.", Team(teamid, Name)));
			}
		}
		if (Flag(zoneid, CapturingPlayer) == -1 && !Flag(zoneid, Captured))
		{
			if (Var(playerid, CapturingFlag) != -1)
			{
			    SendClientMessage(playerid, c_red, "* You already have a flag.");
			}
			else
			{
		        DestroyDynamicPickup(Flag(zoneid, Pickup));
				AttachFlag(playerid);
				PlayerPlaySound(playerid, 6400, 0.0, 0.0, 0.0);
		        UpdateDynamic3DTextLabelText(Flag(zoneid, FlagLabel), -1, sprintf("This zone's flag is\ncurrently picked by "#sc_red"%s (ID: %i)", playerName(playerid), playerid));
				SetPlayerRaceCheckpoint(playerid, 2, Team(teamid, FlagX), Team(teamid, FlagY), Team(teamid, FlagZ), 0.0, 0.0, 0.0, 2.0);

				Flag(zoneid, Pickup) = -1;
			    Flag(zoneid, CapturingPlayer) = playerid;
				Var(playerid, CapturingFlag) = zoneid;

				Exceptional(playerid, c_yellow, sprintf("*** %s[%i] from %s is trying to steal the flag of %s!", playerName(playerid), playerid, Team(teamid, Name), Zone(zoneid, Name)));
				SendClientMessage(playerid, -1, sprintf("* You have picked the flag of %s, go to your base to drop it.", Zone(zoneid, Name)));
			    GameTextForPlayer(playerid, ""#TXT_LINE"~g~flag picked", 3000, 3);
			}
		}
	}
	return 1;
}

zone_StopFlagCapture(playerid)
{
	DetachFlag(playerid);
	DisablePlayerCheckpoint(playerid);
	DisablePlayerRaceCheckpoint(playerid);
	zone_RecreateFlag(Var(playerid, CapturingFlag));
    Var(playerid, CapturingFlag) = -1;
}

zone_RecreateFlag(zoneid)
{
	if (Flag(zoneid, Pickup) == -1)
	{
		Flag(zoneid, Pickup) = CreateDynamicPickup(2993, 1, Flag(zoneid, FlagX), Flag(zoneid, FlagY), Flag(zoneid, FlagZ));
	}

	UpdateDynamic3DTextLabelText(Flag(zoneid, FlagLabel), -1, sprintf("%s flag\nFlag score: +%i\n\nPress 'Y' to pick up this flag", Zone(zoneid, Name), Zone(zoneid, Score) - 1));
    Flag(zoneid, CapturingPlayer) = -1;
}

zone_DeleteFlag(zoneid)
{
    DestroyDynamicObject(Flag(zoneid, HoldingObj));
    DestroyDynamicPickup(Flag(zoneid, Pickup));
	DestroyDynamic3DTextLabel(Flag(zoneid, FlagLabel));
	Zone(zoneid, HasFlag) = false;

    new _x[E_ZONEFLAG_DATA];

	g_ZoneFlags[zoneid] = _x;

	return 1;
}

zone_ReturnClosestFlagID(playerid)
{
    new Float:x, Float:y, Float:z, Float:range;

	foreach(new i : Zones)
	{
	    x = Flag(i, FlagX);
		y = Flag(i, FlagY);
		z = Flag(i, FlagZ);
	    range = GetPlayerDistanceFromPoint(playerid, x, y, z);

	    if (range < 1.5)
	    {
	        return i;
		}
	}

	return -1;
}

zone_ReturnIDByArea(playerid)
{
	foreach(new i : Zones)
	{
	    if (IsPlayerInDynamicArea(playerid, Zone(i, Area)))
		{
	        return i;
	    }
	}

	return -1;
}

zone_ReturnIDByPointArea(areaid)
{
    foreach(new i : Zones)
	{
    	if (areaid == Zone(i, PointArea) && IsValidDynamicArea(Zone(i, PointArea)))
		{
    	    return i;
		}
	}
	return 0;
}

zone_ReturnIDByName(name[])
{
	foreach(new i : Zones)
	{
		if (strfind(Zone(i, Name), name, true) != -1)
		{
			return i;
		}
	}

	return 0;
}

zone_ShowForPlayer(playerid)
{
    foreach(new i : Teams)
	{
        if (Team(i, Zones) != INVALID_GANG_ZONE && Team(i, Zones) != MERCENARY)
		{
			GangZoneShowForPlayer(playerid, Team(i, Zones), (Team(i, Color) & opacity));
		}
	}

	foreach(new i : Zones)
	{
	    if (Zone(i, Zone) != INVALID_GANG_ZONE)
		{
			GangZoneShowForPlayer(playerid, Zone(i, Zone), (Zone(i, Team)) ? (Team(Zone(i, Team), Color) & opacity) : (0xFFFFFF66));
		}
	}
}

/******************************************************************************/
/*							 	  Miscs	    					  			  */
/******************************************************************************/
SuperWeapons_Init()
{
    new andromada, Float:global_range = (Float:0x7F800000);

	// Setting up andromada plane that is used for dropping bombs
	andromada = AddServerVehicle(592, 0, 1477.2413, 1801.1091, 12.0071, 180.2069, 24, 24, 5);

	Vehicle(andromada, BombingPlane) = true;
	Vehicle(andromada, Bombed) = false;
	Vehicle(andromada, BombLoadCounter) = 0;
	Vehicle(andromada, BombLoadTimer) = -1;
	Vehicle(andromada, TimeDisplayLabel) = CreateDynamic3DTextLabel("", -1, 1477.2413, 1801.1091, 12.0071, 50.0, INVALID_PLAYER_ID, andromada, -1, -1, -1, -1);

	// Andromada map icon
	CreateDynamicMapIcon(1478.8401, 1799.0884, 10.8125, 5, -1, -1, -1, -1, global_range, MAPICON_GLOBAL);

	// Setting up nuclear system
	Nuke(AffectedArea) = -1;
	Nuke(Object) = CreateDynamicObject(3258, nuke_X, nuke_Y, nuke_Z, 0.0, 0.0, 0.0, -1, -1, -1, 5000.0, 1000.0); // Main object
	CreateDynamic3DTextLabel("Nuclear\nPress 'Y' to open menu\nType '/nukehelp' for info", c_red, nuke_x, nuke_y, nuke_z + 0.5, 30.0); // Nuclear label
	CreateDynamicMapIcon(nuke_X, nuke_Y, nuke_Z, 23, -1, -1, -1, -1, global_range, MAPICON_GLOBAL); // Global map icon

	// Sam site
	Server(SAMPickup) = CreateDynamicPickup(1254, 2, 355.8903, 2029.5713, 23.8673); // Main pickup
	
	// Abandoned airport pickup to wipe nuclear effect
	Server(AbandonedAirportPickup) = CreateDynamicPickup(1254, 2, 414.2766,2531.6440,16.5886);
	
	// Setting up radio station
	Server(RadioPickup) = CreateDynamicPickup(1254, 2, -344.9333, 1583.1166, 76.2611); // Main pickup
	CreateDynamicMapIcon(-344.9333, 1583.1166, 76.2611, 34, -1, -1, -1, -1, global_range, MAPICON_GLOBAL); // Map icon

	// Setting up Ground Zero
	Server(GroundZeroTime) = 0;
	Server(GroundZeroTimeDisp) = CreateDynamic3DTextLabel("Ground Zero\nPress 'Y' to open menu", -1, gz_x, gz_y, gz_z, 100.0);
    CreateDynamicMapIcon(gz_x, gz_y, gz_z, 23, -1, -1, -1, -1, global_range, MAPICON_GLOBAL);
}

MainConnection_Init()
{
    if (fexist("sql.cfg"))
	{
	    enum E_SQL_DATA
		{
			SQL_HOST[30],
			SQL_USER[30],
			SQL_DATABASE[20],
			SQL_PASSWORD[50]
		}

		new _SQL_[E_SQL_DATA], File:sql, output[200];
		
		sql = fopen("sql.cfg", io_read);
		fread(sql, output);
		fclose(sql);
		sscanf(output, "p<|>e<s[30]s[30]s[20]s[50]>", _SQL_);
		connection = mysql_connect(_SQL_[SQL_HOST], _SQL_[SQL_USER], _SQL_[SQL_DATABASE], _SQL_[SQL_PASSWORD]);
	}
	else
	{
		print("--- WARNING! sql.cfg is missing from the server directory.");
	}

	print((mysql_errno()) ? ("Unable to connect to the database.") : ("Connection to the database was successfull."));

    if (fexist("irc.cfg"))
	{
	    new File:irc, output[150];

		irc = fopen("irc.cfg", io_read);

		fread(irc, output);
		fclose(irc);
		sscanf(output, "p<|>e<s[50]is[50]s[50]>", g_IRC_Conn);
		
		IRC_BOT_1 = IRC_Connect(g_IRC_Conn[IRC_HOST], g_IRC_Conn[IRC_PORT], BOT_1_NICKNAME, BOT_1_REALNAME, BOT_1_USERNAME);
		IRC_BOT_2 = IRC_Connect(g_IRC_Conn[IRC_HOST], g_IRC_Conn[IRC_PORT], BOT_2_NICKNAME, BOT_2_REALNAME, BOT_2_USERNAME);
        IRC_SetIntData(IRC_BOT_1, E_IRC_CONNECT_DELAY, 20);
        IRC_SetIntData(IRC_BOT_2, E_IRC_CONNECT_DELAY, 30);
		IRC_GROUP_1 = IRC_CreateGroup();
		IRC_GROUP_2 = IRC_CreateGroup();
	}
	else
	{
		print("ERROR: File 'irc.cfg' is missing from the server directory.");
	}
}

AddServerVehicle(Model, type, Float:vs_X, Float:vs_Y, Float:vs_Z, Float:vs_A, Color1, Color2, SpawnDelay)
{
	new vehicleid;

	vehicleid = AddStaticVehicleEx(Model, vs_X, vs_Y, vs_Z, vs_A, Color1, Color2, SpawnDelay);
	Vehicle(vehicleid, Static) = true;
	Vehicle(vehicleid, DriverID) = INVALID_PLAYER_ID;
	Vehicle(vehicleid, Type) = type;

	if (type)
	{
	    SetVehicleHealth(vehicleid, g_ArmedVehicle[type][av_Health]);
	}

	return vehicleid;
}

ConvertTime(time, in_format)
{
	new total, d, h, m;

	total = time - gettime();

	switch (in_format)
	{
	    case 0:
		{
			if (total >= 86400)
			{
				d = total / 86400;
				total = total - (d * 86400);
			}

			return d;
		}
		case 1:
		{
			if (total >= 3600)
			{
				h = total / 3600;
				total = total - (h * 3600);
			}

			return h;
		}
		case 2:
		{
			if (total >= 60)
			{
				m = total / 60;
				total = total - (m * 60);
			}

			return m;
		}
	}

	return -1;
}

return_Stamp()
{
	new d, m, y, s[11];

	getdate(y, m, d);
	Format:s("%i/%i/%i", d, m, y);

	return s;
}

News(msg[])
{
    format(g_NewsString[6], 128, g_NewsString[5]);
	format(g_NewsString[5], 128, g_NewsString[4]);
	format(g_NewsString[4], 128, g_NewsString[3]);
	format(g_NewsString[3], 128, g_NewsString[2]);
	format(g_NewsString[2], 128, g_NewsString[1]);
	format(g_NewsString[1], 128, msg);

	for (new i = 1; i < sizeof(g_NewsString); ++i)
	{
		TextDrawSetString(text_NewsBox[i], g_NewsString[i]);
	}
}

news_Show(playerid)
{
	for (new i = 0; i < sizeof(text_NewsBox); ++i)
	{
		TextDrawShowForPlayer(playerid, text_NewsBox[i]);
	}
}

news_Hide(playerid)
{
    for (new i = 0; i < sizeof(text_NewsBox); ++i)
    {
		TextDrawHideForPlayer(playerid, text_NewsBox[i]);
	}
}

// by Y_Less
RandomEx(min, max)
{
	return random(max - min) + min;
}

weapon_ReturnModelFromName(wname[])
{
    for(new i = 0; i < 47; i++)
	{
        if ((i != 19) || (i != 20) || (i != 21))
		{
			if (strfind(aWeaponNames[i], wname, true) != -1)
			{
				return i;
			}
		}
	}

	return -1;
}

shop_Create(shopid, Float:x, Float:y, Float:z, teamid)
{
	Iter_Add(Shops, shopid);
	Shop(shopid, ID) = CreatePickup(348, 1, x, y, z, 0);
	Shop(shopid, Icon) = CreateDynamicMapIcon(x, y, z, 6, 0);
	Streamer_SetFloatData(STREAMER_TYPE_MAP_ICON, Shop(shopid, Icon), E_STREAMER_STREAM_DISTANCE, 300.0);
	Shop(shopid, X) = x;
	Shop(shopid, Y) = y;
	Shop(shopid, Z) = z;
	Shop(shopid, Area) = CreateDynamicSphere(x, y, z, 1.5);
	Shop(shopid, TeamID) = teamid;
	Shop(shopid, Label) = CreateDynamic3DTextLabel(sprintf("%s\n"#sc_white"Shop", Team(teamid, Name)), Team(teamid, Color), x, y, z+0.5, 30.0);
}

shop_ReturnClosestID(playerid)
{
	foreach(new i : Shops)
	{
	    if (IsPlayerInDynamicArea(playerid, Shop(i, Area)))
		{
	        return i;
 		}
	}

	return -1;
}

shop_ReturnIDByArea(areaid)
{
	foreach(new i : Shops)
	{
	    if (areaid == Shop(i, Area) && IsValidDynamicArea(Shop(i, Area)))
		{
	        return i;
 		}
	}

	return -1;
}

function IRC_Echo(channel[], msg[])
{
    if (!strcmp(g_IRC_Conn[IRC_MAIN_CHANNEL], channel, false))
    {
		IRC_GroupSay(IRC_GROUP_1, channel, msg);
	}

	if (!strcmp(g_IRC_Conn[IRC_ADMIN_CHANNEL], channel, false))
	{
		IRC_GroupSay(IRC_GROUP_2, channel, msg);
	}

	return 1;
}

IsItemActivated(item)
{
    if (item != 0 && gettime() < item)
	{
        return 1;
	}

	return 0;
}

return_ItemStatus(item)
{
	new status[36], total_days;

    total_days = ConvertTime(item, DAYS);
	Format:status((IsItemActivated(item)) ? ("Yes (%i days left)") : ("No"), total_days);

	return status;
}

return_WepList(id)
{
    new str[128], weaponid, ammo, i, slot = MAX_WEAPON_SLOT;

	for (i = 0; i < slot; ++i)
	{
	    GetPlayerWeaponData(id, i, weaponid, ammo);

	    if (weaponid != 0)
		{
	 		Format:str("%s%s[%i] | ", str, aWeaponNames[weaponid], ammo);
		}
	}

	return (str[0] != '\0') ? (str) : ("None");
}


return_RangeIP(ip[])
{
	new c1, c2, c3, dot, str[16];

	c1 = strval(ip[0]);
	dot = strfind(ip, ".", false, 0);
	c2 = strval(ip[dot + 1]);
	dot = strfind(ip, ".", false, dot + 1);
	c3 = strval(ip[dot + 1]);
	Format:str("%i.%i.%i.", c1, c2, c3);

	return str;
}

class_ReturnWeaponsList(class)
{
	new list[128], w;

	for(new i = 0, j = 8; i < j; i++)
	{
		w = Class(class, Weapons)[i];

		if (w)
		{
			Format:list("%s\t• %s\n", list, aWeaponNames[w]);
		}
	}

	return list;
}

class_ReturnIDByName(name[])
{
	for (new i = 0, j = MAX_CLASSES; i < j; i++)
	{
		if (strfind(Class(i, Name), name, true) != -1)
		{
			return i;
		}
	}

	return -1;
}

return_IDByName(name[])
{
	foreach(new i : Player)
	{
		if (!strcmp(playerName(i), name, true))
		{
			return i;
		}
	}

	return -1;
}

IsValidName(const name[])
{
    for(new i, j = strlen(name); i != j; i++)
	{
        switch (name[i])
		{
            case '0'..'9', 'A'..'Z', 'a'..'z', '[', ']', '(', ')', '$', '@', '.', '_', '=':
           		continue;

			default:
				return 0;
		}
    }
    return 1;
}

FilterIP(text[])
{
	new dots = 0, bool:numbers = false;

	for(new i = 0, j = strlen(text); i < j; ++i)
	{
		if (text[i] == '.')
		{
			++dots;
		}
	}

	for(new i = 0, j = strlen(text); i < j; i++)
	{
        if ('0' <= text[i] <= '9')
		{
			numbers = true;
        }
    }

	if (strfind(text, "164.132.197.19", true) == -1 && dots >= 3 && numbers == true)
	{
		return true;
	}

  	return false;
}

CheckIP(playerid, message[])
{
    if (FilterIP(message))
	{
        return SendClientMessage(playerid, c_red, "* Your message cannot be sent. Possibly contains IP address."), 0;
	}

	return 1;
}

interior_ReturnIDByName(name[])
{
	for(new i = 1, j = 25; i < j; i++)
	{
		if (strfind(g_AdminInteriors[i][int_Name], name, true) != -1)
		{
			return i;
		}
	}

	return 0;
}

bridge_ReturnClosestID(playerid)
{
	new Float:x, Float:y, Float:z, Float:range, id;

	foreach(new i : BridgeObjects)
	{
	    id = BridgeObjects(i, GroupID);
	    x = Bridge(id, PointX);
		y = Bridge(id, PointY);
		z = Bridge(id, PointZ);
	    range = GetPlayerDistanceFromPoint(playerid, x, y, z);
		
		if (range < 2.5)
		{
	        return id;
		}
	}

	return -1;
}

bridge_Create(bridgeid, object, Float:fx, Float:fy, Float:fz, Float:frx, Float:fry, Float:frz, Float:dx, Float:dy, Float:dz, Float:drx, Float:dry, Float:drz, groupid)
{
	Iter_Add(BridgeObjects, bridgeid);
	BridgeObjects(bridgeid, Object) = CreateDynamicObject(object, fx, fy, fz, frx, fry, frz, -1, -1, -1, 400.0, 1000.0);
	BridgeObjects(bridgeid, Fixed_X) = fx;
	BridgeObjects(bridgeid, Fixed_Y) = fy;
	BridgeObjects(bridgeid, Fixed_Z) = fz;
	BridgeObjects(bridgeid, Fixed_RX) = frx;
	BridgeObjects(bridgeid, Fixed_RY) = fry;
	BridgeObjects(bridgeid, Fixed_RZ) = frz;
	BridgeObjects(bridgeid, Damaged_X) = dx;
	BridgeObjects(bridgeid, Damaged_Y) = dy;
	BridgeObjects(bridgeid, Damaged_Z) = dz;
	BridgeObjects(bridgeid, Damaged_RX) = drx;
	BridgeObjects(bridgeid, Damaged_RY) = dry;
	BridgeObjects(bridgeid, Damaged_RZ) = drz;
	BridgeObjects(bridgeid, GroupID) = groupid;
	Iter_Add(Bridges, groupid);
}

bridge_ChangeState(b_id, b_state)
{
	new oid, Float:d_x, Float:d_y, Float:d_z,
		Float:d_rx, Float:d_ry, Float:d_rz,
		Float:f_x, Float:f_y, Float:f_z,
		Float:f_rx, Float:f_ry, Float:f_rz;
		
    Bridge(b_id, Status) = b_state;
	foreach(new i : BridgeObjects)
	{
	    if (BridgeObjects(i, GroupID) == b_id)
		{
		    oid = BridgeObjects(i, Object);
		    f_x = BridgeObjects(i, Fixed_X);
			f_y = BridgeObjects(i, Fixed_Y);
			f_z = BridgeObjects(i, Fixed_Z);
	        
	        switch (b_state)
			{
				// Collapsing
				case BRIDGE_STATUS_COLLAPSED:
				{
				    oid = BridgeObjects(i, Object);
					d_x = BridgeObjects(i, Damaged_X);
					d_y = BridgeObjects(i, Damaged_Y);
					d_z = BridgeObjects(i, Damaged_Z);
					d_rx = BridgeObjects(i, Damaged_RX);
					d_ry = BridgeObjects(i, Damaged_RY);
					d_rz = BridgeObjects(i, Damaged_RZ);
					
					SetDynamicObjectPos(oid, d_x, d_y, d_z);
					SetDynamicObjectRot(oid, d_rx, d_ry, d_rz);
					CreateExplosion(f_x, f_y, f_z, 7, 200.0);
					CreateExplosion(d_x + 20.0, d_y + 20.0, d_z, 7, 200.0);
				}
				// Repairing
				case BRIDGE_STATUS_FIXED:
				{
					f_rx = BridgeObjects(i, Fixed_RX);
					f_ry = BridgeObjects(i, Fixed_RY);
					f_rz = BridgeObjects(i, Fixed_RZ);
					SetDynamicObjectPos(oid, f_x, f_y, f_z);
					SetDynamicObjectRot(oid, f_rx, f_ry, f_rz);
				}
			}
		}
	}
}

bridge_ReturnIDByZone(zoneid)
{
	switch (zoneid)
	{
	    case 15: return TIERRA_ROBADA_BRIDGE;
		case 19: return FALLOW_BRIDGE;
		case 28: return MARTIN_BRIDGE;
		case 30: return BONE_COUNTY_BRIDGE;
	}

	return -1;
}

bridge_Check()
{
	new playerid;
	
	foreach(new i : Bridges)
	{
		if (Bridge(i, ExplodeTime) != 0)
		{
		 	if (--Bridge(i, ExplodeTime) <= 0)
	 		{
	 		    playerid = Bridge(i, PlantingPlayer);
		 	    bridge_ChangeState(i, BRIDGE_STATUS_COLLAPSED); // Collapsing
				Bridge(i, ExplodeTime) = 0;

				News(sprintf("~r~~h~Bombs planted by ~w~~h~%s ~r~~h~at the %s has exploded", playerName(playerid), Bridge(i, Name)));
				News("~r~~h~The bridge has been collapsed");
				
                TextDrawSetString(Server(BombTime), " ");
                TextDrawHideForAll(Server(BombTime));

				IRC_Echo(g_IRC_Conn[IRC_MAIN_CHANNEL], sprintf("5* Bombs planted by %s at the %s has exploded. The bridge has been collapsed.", playerName(playerid), Bridge(i, Name)));
				SendClientMessage(playerid, c_green, sprintf("You received $20000 and +5 score for destroying the %s.", Bridge(i, Name)));

				RewardPlayer(playerid, 20000, 5, true);

				Bridge(i, PlantingPlayer) = INVALID_PLAYER_ID;
			}
			else
			{
				TextDrawSetString(Server(BombTime), sprintf("~r~~h~Bombs at the %s will explode in ~w~%i ~r~~h~seconds!", Bridge(i, Name), Bridge(i, ExplodeTime)));
			    TextDrawShowForAll(Server(BombTime));
			}
		}
	}
}

weapon_ReturnModel(weaponid)
{
	switch (weaponid)
	{
	    case 1: return 331;
	    case 2: return 333;
	    case 3: return 334;
	    case 4: return 335;
	    case 5: return 336;
	    case 6: return 337;
	    case 7: return 338;
	    case 8: return 339;
	    case 9: return 341;
	    case 10: return 321;
	    case 11: return 322;
	    case 12: return 323;
	    case 13: return 324;
	    case 14: return 325;
	    case 15: return 326;
	    case 16: return 342;
	    case 17: return 343;
	    case 18: return 344;
	    case 22: return 346;
	    case 23: return 347;
	    case 24: return 348;
	    case 25: return 349;
	    case 26: return 350;
	    case 27: return 351;
	    case 28: return 352;
	    case 29: return 353;
	    case 30: return 355;
	    case 31: return 356;
	    case 32: return 372;
	    case 33: return 357;
	    case 34: return 358;
	    case 35: return 359;
	    case 36: return 360;
	    case 37: return 361;
	    case 38: return 362;
	    case 39: return 363;
	    case 40: return 364;
	    case 41: return 365;
	    case 42: return 366;
	    case 43: return 367;
	    case 44: return 368;
	    case 45: return 369;
	    case 46: return 371;
		default: return -1;
	}
	return -1;
}

Announce(message[], time)
{
	new text[150];

	KillTimer(Server(AnnTextTimer));
	Server(AnnTextTimer) = -1;
	Format:text("~g~~h~ADMIN ANNOUNCEMENT~n~~n~~w~%s", message);
	TextDrawSetString(Server(AnnText), text);
	TextDrawShowForAll(Server(AnnText));
	Server(AnnTextTimer) = SetTimer("screentext_Collapse", time, false);
}

function screentext_Collapse(playerid)
{
	TextDrawHideForAll(Server(AnnText));
    KillTimer(Server(AnnTextTimer));
	Server(AnnTextTimer) = -1;
}

CountOnFootPlayers()
{
	new p_state, count = 0;

	foreach(new i : Player)
	{
		p_state = GetPlayerState(i);
		
		if (p_state == PLAYER_STATE_ONFOOT)
		{
		    ++count;
		}
	}

	return count;
}

CountInVehiclePlayers()
{
	new count = 0;

	foreach(new i : Player)
	{
	    if (IsPlayerInAnyVehicle(i))
	    {
	        ++count;
		}
	}
	
	return count;
}
