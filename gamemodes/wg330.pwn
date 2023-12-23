/*
	  * Gamemode details

	  * Mode: 					Deathmatch/Team-Deathmatch
	  * Created by:				Sjn
	  * Created date:			4/16/2015
	  * Saving system: 			MySQL
	  * Command processor: 		ZCMD

	  *	Plugin details

	  * MySQL:					R38
	  * Crashdetect:			v4.15.1
	  * Streamer:				v2.8.2
	  * Sscanf:					v2.8.2
	  * IRC:					v1.4.6
*/

#include <a_samp>
#include <a_mysql>
#include <sscanf2>
//#include <crashdetect>
#include <pbar>
#include <zcmd>
#include <foreach>
#include <streamer>
#include <strlib>
#include <irc>
#include <flood>

main()
{
	print("\n--------------------------------------------------------------");
	print(" Loaded: Call of Duty - Warground by Sjn");
	print("--------------------------------------------------------------\n");

	return 1;
}

#include <wg_vars.pwn>
#include <wg_dialogs.pwn>

public OnGameModeInit()
{
	SendRconCommand(sprintf("hostname %s", server_name));
	SetGameModeText("COD-WG DM/TDM v"#server_version"");

    MainConnection_Init();
    //mysql_log(LOG_ALL);
	Iter_Init(SquadMembers);

	ShowPlayerMarkers(1);
	ShowNameTags(1);
	EnableStuntBonusForAll(0);
	DisableInteriorEnterExits();
	UsePlayerPedAnims();
	EnableVehicleFriendlyFire();

	load_Teams();
	load_Classes();
	load_Vehicles();
	load_Zones();
	load_Bridges();
	load_Spawns();
	load_Clans();

    SetWeather(DEFAULT_WEATHER);

 	TD_Load(true);

	Server(MaxPing) = 1000;
	Server(Weather) = 0;
	Server(Time) = 12;
	Server(AnnTextTimer) = -1;
	Server(MOTD)[0] = '\0';

	SetTimer("timer_Global", 1000, true);
	SetTimer("timer_UpdatePlayers", 1000, true);
	SetTimer("timer_RandMsg", 1000 * 60 * 8, true);
	SetTimer("timer_GroundZero", 10000, true);
	SuperWeapons_Init();

    for (new i = 0, j = MAX_DUELS; i < j; i++)
    {
		duel_ClearData(i);
	}
	
	for (new i = 0, j = MAX_CLANS; i < j; i++)
	{
	    Clan(i, CW_Requested) = -1;
	    Clan(i, CW_InvitingPlayer) = INVALID_PLAYER_ID;
	    Clan(i, CW_Invited) = false;
	}
	
	for (new i = 0, j = MAX_CLANWAR; i < j; i++)
	{
     	CW(i, Clan1) = -1;
		CW(i, Clan2) = -1;
		CW(i, Members) = 0;
		CW(i, Bet) = 0;
		CW(i, Interior) = 0;
		CW(i, Clan1_Members) = 0;
	    CW(i, Clan2_Members) = 0;
	    CW(i, Clan1_Win) = 0;
	    CW(i, Timer) = -1;
	    CW(i, Clan2_Win) = 0;
	    CW(i, MaxRounds) = 0;
	    CW(i, Rounds) = 0;
		
		CW(i, TD_Main) = TextDrawCreate(87.0, 231.0, " ");
		TextDrawAlignment(CW(i, TD_Main), 2);
		TextDrawLetterSize(CW(i, TD_Main), 0.25, 1.099999);
		TextDrawSetOutline(CW(i, TD_Main), 1);

		CW(i, TD_Clan1) = TextDrawCreate(61.0, 247.0, " ");
		TextDrawAlignment(CW(i, TD_Clan1), 2);
		TextDrawLetterSize(CW(i, TD_Clan1), 0.23, 1.099999);
		TextDrawSetOutline(CW(i, TD_Clan1), 1);

		CW(i, TD_Clan2) = TextDrawCreate(113.0, 247.0, " ");
		TextDrawAlignment(CW(i, TD_Clan2), 2);
		TextDrawLetterSize(CW(i, TD_Clan2), 0.23, 1.099999);
		TextDrawSetOutline(CW(i, TD_Clan2), 1);
	}

	return 1;
}

public OnGameModeExit()
{
	IRC_Quit(IRC_BOT_1, "Client Exited/Server restart.");
	IRC_Quit(IRC_BOT_2, "Client Exited/Server restart.");
	IRC_DestroyGroup(IRC_GROUP_1);
	IRC_DestroyGroup(IRC_GROUP_2);

	return 1;
}

public OnPlayerEnterDynamicArea(playerid, areaid)
{
	if (Var(playerid, LoggedIn))
	{
		new _state = GetPlayerState(playerid);

		if (_state == PLAYER_STATE_ONFOOT && !Var(playerid, Duty))
		{
		 	new shopid = shop_ReturnIDByArea(areaid);

			if (shopid != -1)
			{
			    new teamid = Shop(shopid, TeamID);

				if (teamid == Player(playerid, Team) || !teamid)
				{
			    	ShowDialog(playerid, D_SHOP);
				}
				else
				{
					SendClientMessage(playerid, c_red, "* You cannot use enemy team's weapon shop.");
				}
			}
			new zoneid = zone_ReturnIDByPointArea(areaid);

			if (zoneid != 0)
			{
	  			zone_StartCapture(playerid, zoneid);
			}
		}
	}

	return 1;
}

public IRC_OnConnect(botid, ip[], port)
{
	printf("<IRC> Bot %i connected to %s:%d", botid, ip, port);

	if (botid == IRC_BOT_1)
	{
	    IRC_JoinChannel(IRC_BOT_1, g_IRC_Conn[IRC_MAIN_CHANNEL]);
  		IRC_SendRaw(botid, sprintf("identify %s", BOT_1_PASSWORD));
		IRC_AddToGroup(IRC_GROUP_1, botid);
	}
	
	if (botid == IRC_BOT_2)
	{
	    IRC_JoinChannel(IRC_BOT_2, g_IRC_Conn[IRC_ADMIN_CHANNEL]);
  		IRC_SendRaw(botid, sprintf("identify %s", BOT_2_PASSWORD));
		IRC_AddToGroup(IRC_GROUP_2, botid);
	}
	
	return 1;
}

public IRC_OnDisconnect(botid)
{
	if (botid == IRC_BOT_1)
	{
		IRC_BOT_1 = 0;
		SetTimerEx("IRC_ConnectDelay", 20000, 0, "d", 1);
	}
	else if (botid == IRC_BOT_2)
	{
		IRC_BOT_2 = 0;
		SetTimerEx("IRC_ConnectDelay", 25000, 0, "d", 2);
	}
	
	return 1;
}

public IRC_OnReceiveRaw(botid, message[])
{
	new File: file;

	if (!fexist("irc_log.txt"))
	{
 		file = fopen("irc_log.txt", io_write);
	}
	else
	{
		file = fopen("irc_log.txt", io_append);
	}
	
	if (file)
	{
		fwrite(file, message);
		fwrite(file, "\r\n");
		fclose(file);
	}
	
	return 1;
}

public IRC_OnUserSay(botid, recipient[], user[], host[], message[])
{
	if (botid == IRC_BOT_2 && message[0] != '!' && message[0] != '@')
	{
        new msg[144];

		Format:msg("[IRC] {%06x}<AChat> %s: %s", c_sub(ac_chat), user, message);
		admin_SendMessage(1, -1, msg);
	}

	return 1;
}
											
public OnPlayerRequestClass(playerid, classid)
{
	if (!IsPlayerNPC(playerid))
	{
	    if (Var(playerid, ViewingDialog))
	        return 0;

	    if (Var(playerid, DM))
	    {
		    SpawnPlayer(playerid);
		}
		else
		{
			new teamid = (classid + 1);

			if (teamid && teamid < MAX_TEAMS)
			{
				BG_TeamSelection(playerid)
				Player(playerid, Team) = teamid;
				SetPlayerTeam(playerid, (teamid == MERCENARY) ? (playerid + 1000) : teamid);
				PlayerTextDrawColor(playerid, TD(playerid, TeamSelection)[2], Team(teamid, Color));
				PlayerTextDrawSetString(playerid, TD(playerid, TeamSelection)[2], Team(teamid, Name));
				PlayerTextDrawSetString(playerid, TD(playerid, TeamSelection)[1], sprintf("~b~~h~~h~~h~PLAYERS ~w~%i", Team(teamid, Players)));
			}

			if (!Var(playerid, ClassSpawned))
				Var(playerid, ClassSpawned) = 1;
			
			if (Var(playerid, Spawned))
				Var(playerid, Spawned) = false;
   			
			for (new i = 0, j = 3; i != j; ++i)
			{
				PlayerTextDrawShow(playerid, TD(playerid, TeamSelection)[i]);
			}

			if (Player(playerid, PlayingTeam) != 0)
			{
				--Team(Player(playerid, PlayingTeam), Players);
				Player(playerid, PlayingTeam) = 0;
			}

			if (Var(playerid, SquadID) != -1)
			    squad_RemovePlayer(playerid);
			
			if (Var(playerid, Duty))
			    Var(playerid, Duty) = false;
		}
	}

	return 1;
}

public OnPlayerRequestSpawn(playerid)
{
	new teamid = Player(playerid, Team);

	if (teamid)
	{
	    if (team_IsFree(playerid, teamid))
		{
			Var(playerid, ViewingDialog) = true;

			if (teamid == MERCENARY)
			{
				ShowClassInfo(playerid, C_NAN);
			}
			else
			{
				ShowDialog(playerid, D_CLASS);
			}
		}
	}

	return 0;
}

// By Ryder to prevent the connection spam.
public OnPlayerFloodControl(playerid, iCount, iTimeSpan)
{
	if (iCount > 7 && iTimeSpan < 8000)
	{
		BanEx(playerid, "Connection bot");
	}

	return 1;
}

public OnPlayerConnect(playerid)
{
	reset_Var(playerid);

	if (!IsPlayerNPC(playerid))
	{
	    new query[128];

		++Server(Players);
		
		freeze_screen(playerid);
		SetPlayerColor(playerid, c_grey);
		TD_Load(false, playerid);

		Player(playerid, RankText) = Create3DTextLabel(" ", -1, 30.0, 40.0, 50.0, 30.0, 0, 1);
		Attach3DTextLabelToPlayer(Player(playerid, RankText), playerid, 0.0, 0.0, 0.8);

		GetPlayerIp(playerid, Player(playerid, Ip), 16);
		GetPlayerName(playerid, Player(playerid, Name), 24);

		JoinLeaveMessage(playerid);
		
		Query("SELECT `id`,`nick`,`ip`,`time` FROM `bans` WHERE `ip`='%e' OR `nick`='%e'",
			Player(playerid, Ip), Player(playerid, Name));

		mysql_tquery(connection, query, "ExecuteQuery", "ii", res_check_ban, playerid);

		#include <remove_objects.pwn>
	}

	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	if (IsPlayerNPC(playerid))
	    return 1;
	
	if (IsPlayerConnected(playerid))
	{
	    --Server(Players);
		JoinLeaveMessage(playerid, reason);

		if (Var(playerid, LoggedIn))
		{
			new teamid, vehicleid, clanid;
			
			clanid = Player(playerid, ClanID);
			teamid = Player(playerid, PlayingTeam);
			vehicleid = Var(playerid, Vehicle);

		    if (teamid != 0 && !Var(playerid, DM))
				--Team(teamid, Players);
			
			if (Var(playerid, Timeout))
		        TimeoutPlayer(playerid, false);
		    
		    if (vehicleid != 0)
			{
			    new model = GetVehicleModel(vehicleid);

				switch (model)
				{
				    case 560, 565:
					{
					    new slot;
					    
				        for (new i = 0, j = 14; i < j; i++)
						{
						    slot = GetVehicleComponentInSlot(vehicleid, i);
				            RemoveVehicleComponent(vehicleid, slot);
				        }
				    }
				}
				DestroyVehicle(vehicleid);
			}

			if (Var(playerid, CappingZone) != -1)
		    	zone_StopCapture(playerid);
			

			if (Var(playerid, CapturingFlag) != -1)
		        zone_StopFlagCapture(playerid);
			
			foreach(new i : Player)
			{
				if (admin_IsSpectating(i, playerid))
				    admin_AdvanceSpec(i);
				
				if (g_Reporter[i] == playerid)
					g_Reporter[i] = INVALID_PLAYER_ID;
			}

			if (clanid != -1)
			{
			    if (Clan(clanid, CW_Invited) && clan_CountLeaders(clanid) == 1)
			    {
			        if (Player(playerid, ClanLeader))
			        {
			            new leaderid, slot;

					    leaderid = Clan(clanid, CW_InvitingPlayer);
						slot = Var(leaderid, PlayingCW);
					    CW(slot, Members) = 0;
					    CW(slot, Bet) = 0;
					    CW(slot, Interior) = 0;
					    CW(slot, Clan1) = -1;
					    CW(slot, Clan2) = -1;
					    CW(slot, MaxRounds) = 0;
						Var(leaderid, PlayingCW) = -1;
						Clan(Player(leaderid, ClanID), CW_Requested) = -1;
						Clan(clanid, CW_InvitingPlayer) = INVALID_PLAYER_ID;
						Clan(clanid, CW_Invited) = false;
			        }
				}
			}

			CW_RemovePlayer(playerid);
			SaveStats(playerid);
			squad_RemovePlayer(playerid);
			weapon_RemovePickups(playerid);
			duel_ResetData(playerid);
		}
		TD_Destroy(playerid);
		Delete3DTextLabel(Player(playerid, RankText));
		
		if (Timer(playerid, Jail) != -1)
			KillTimer(Timer(playerid, Jail));
		
		if (Timer(playerid, Teargas) != -1)
			KillTimer(Timer(playerid, Teargas));
	}

	return 1;
}

public OnPlayerSpawn(playerid)
{
	if (IsPlayerNPC(playerid))
	    return 1;

	if (!Var(playerid, LoggedIn))
		return KickEx(playerid, c_red, "You have been kicked.");

    if (Var(playerid, ViewingDialog))
        Var(playerid, ViewingDialog) = false;

	for (new i = 0, j = 3; i != j; ++i)
	{
		PlayerTextDrawHide(playerid, TD(playerid, TeamSelection)[i]);
	}

	if (!Sync(playerid, Synced))
	{
		if (Var(playerid, PlayerStatus) == PLAYER_STATUS_SWITCHING_CLASS)
		{
			return SetPlayerClassSelection(playerid);
		}
	}

	new teamid = Player(playerid, Team);

	if (teamid != NO_TEAM)
	{
		new rank, skin, sp, clanid;

		rank = Player(playerid, Rank);
		skin = Var(playerid, Skin);
		sp = Var(playerid, SpawnPoint);
		clanid = Player(playerid, ClanID);

		if (!Player(playerid, PlayingTeam) && !Var(playerid, Duty))
		{
	    	++Team(teamid, Players);
	     	Player(playerid, PlayingTeam) = teamid;
		}

		if (clanid != -1 && Clan(clanid, Skin) != -1)
	    {
	        SetSkin(playerid, (skin) ? skin : Clan(clanid, Skin));
	    }
		else
		{
        	SetSkin(playerid, (skin) ? skin : Team(teamid, Skin));
		}

		if (Sync(playerid, Synced))
		    return Synchronize(playerid, 0);

		if (Timer(playerid, Teargas) != -1)
		{
			KillTimer(Timer(playerid, Teargas));
			Timer(playerid, Teargas) = -1;
		}

		SetPlayerVirtualWorld(playerid, 0);
		SetPlayerInterior(playerid, 0);
	    news_Show(playerid);
	    ResetPlayerWeapons(playerid);
	    PreloadAnimLib(playerid, "PED");
	    PreloadAnimLib(playerid, "BOMBER");
	    Var(playerid, Spawned) = true;

		if (sp != 0)
		{
			if (Zone(sp, Capturing) || Zone(sp, Team) != teamid)
			{
		    	if (!Var(playerid, DM) && !Var(playerid, Duty))
				{
				    if (Var(playerid, PlayingCW) == -1)
				    {
						SendClientMessage(playerid, c_red, sprintf("* %s is under attack, you have been spawned at your home base.", Zone(sp, Name)));
					}
				}
				Var(playerid, SpawnPoint) = 0;
			}
		}

		SetPlayerSkillLevel(playerid, WEAPONSKILL_SAWNOFF_SHOTGUN, 1);
		SetPlayerSkillLevel(playerid, WEAPONSKILL_MICRO_UZI, 1);

		if (Var(playerid, DM) != 0)
		{
		    SetPlayerInDM(playerid, Var(playerid, DM));
		}
		else
		{
		 	if (!Var(playerid, SpawnPoint))
	 		{
				RandomBaseSpawn(playerid, teamid);
			}
			else
			{
			    new zone, Float:x, Float:y, Float:z, Float:a;

				zone = Var(playerid, SpawnPoint);
				x = Zone(zone, SpawnX);
				y = Zone(zone, SpawnY);
				z = Zone(zone, SpawnZ);
				a = Zone(zone, SpawnA);
				SetPlayerPos(playerid, x, y, z + 1.0);
				SetPlayerFacingAngle(playerid, a);
			}

		   	SetCameraBehindPlayer(playerid);
		    UpdateRank(playerid);
		    UpdateBoard(playerid);
			TD_Update(playerid, true);

			if (rank < 2)
			{
			    SetPlayerArmour(playerid, 100.0);
				ToggleMask(playerid, 1);
				ToggleHelmet(playerid, 1);

				Var(playerid, HasHelmet) = 1;
				Var(playerid, HasMask) = 1;
			}
			else
			{
				switch (Player(playerid, VIP))
				{
					case 2:
					{
						GivePlayerWeapon(playerid, 16, 2);
						GivePlayerWeapon(playerid, 35, 1);
						SetPlayerArmour(playerid, 70.0);
					}
					case 3:
					{
						GivePlayerWeapon(playerid, 16, 4);
						GivePlayerWeapon(playerid, 35, 2);
						SetPlayerArmour(playerid, 100.0);
						Var(playerid, MediKits) = 3;
					}
					default:
					{
						SetPlayerArmour(playerid, Rank(rank, Armour));
					}
				}
			}

		    if (IsItemActivated(Player(playerid, HelmetActivated)))
			{
		        ToggleHelmet(playerid, 1);
				Var(playerid, HasHelmet) = 1;
			}

			if (IsItemActivated(Player(playerid, MaskActivated)))
			{
			    ToggleMask(playerid, 1);
				Var(playerid, HasMask) = 1;
			}

			if (Var(playerid, Duty))
			{
				admin_ToggleDuty(playerid, 1, true);
			}
			else
			{
				new class, color, weapon, ammo, point[35];

				class = Player(playerid, Class);
				color = Team(teamid, Color);

				if (sp)
				{
					Format:point(Zone(sp, Name));
				}
				else
				{
					point = "Base";
				}

				SetPlayerColor(playerid, color);
				SendClientMessage(playerid, -1, sprintf("Team: {%06x}%s{%06x}, Rank: %d (%s), Bonus armour: %i%s, Spawn point: %s",
					c_sub(color),
					Team(teamid, Name),
					c_sub(-1),
					rank,
					Rank(rank, Name),
					floatround(Rank(rank, Armour)), "%%",
					(teamid == MERCENARY) ? ("Random") : (point)));
				
				for (new i = 0, j = 8; i < j; ++i)
				{
					weapon = Class(class, Weapons)[i];
					ammo = Class(class, WeaponAmmo)[i];
				    GivePlayerWeapon(playerid, weapon, ammo);
				}

				switch (class)
				{
			 		case MEDIC:
			 		{
					    ToggleMask(playerid, 1);
						Var(playerid, HasMask) = 1;
						Var(playerid, MediKits) = 3;
					}
					case SPY:
					{
						Var(playerid, DisKit) = 3;
						
						if (Var(playerid, Disguised) != 0)
						{
						    Var(playerid, Disguised) = 0;
						}
					}
				}

				if (Var(playerid, PlayingCW) != -1)
				    CW_AddPlayer(Var(playerid, PlayingCW), playerid, true);

				if (Player(playerid, Jailed) != 0)
				    JailPlayer(playerid, Player(playerid, Jailed));

				if (Var(playerid, Headshot))
					Var(playerid, Headshot) = false;

				if (Var(playerid, ClassSpawned) == 1)
				{
			        Var(playerid, ClassSpawned) = 0;
					PlayerProtection(playerid, PROTECTION_START);
				}
			}
		}
	}

	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	if (!IsPlayerConnected(playerid))
		return 1;

	if (Var(playerid, LoggedIn))
	{
	    SaveStats(playerid);

		foreach(new i : Player)
		{
			if (admin_IsSpectating(i, playerid))
			{
			    admin_AdvanceSpec(i);
			}
		}

		remove_VarValues(playerid);

		if (!Var(playerid, DM))
			TD_Update(playerid, false);
		
		if (Var(playerid, SupplyingVehicle) != 0)
		{
			new vid = Var(playerid, SupplyingVehicle);
			
		    if (Vehicle(vid, Loaded))
			{
		        Vehicle(vid, Loaded) = false;
	            Vehicle(vid, SupplyingPlayer) = -1;
				Var(playerid, SupplyingVehicle) = 0;
			}
		}

		if (Var(playerid, HasHelmet) || Var(playerid, HasMask))
		{
			ToggleMask(playerid, 0);
			ToggleHelmet(playerid, 0);
	  		Var(playerid, HasHelmet) = 0;
			Var(playerid, HasMask) = 0;
		}

		++Player(playerid, Deaths);
		++Player(playerid, SessionDeaths);
		
		new cwid = Var(playerid, PlayingCW);
		
		if (cwid != -1)
		{
		    if (Var(playerid, PlayingInCW) == true)
		    {
				CW_UpdatePlayerStatus(playerid, cwid);
                Var(playerid, PlayingInCW) = false;
			}
		}

		if (killerid != INVALID_PLAYER_ID)
			PlayerKillPlayer(killerid, playerid, reason);
		
		remove_VarValues(playerid, true);
	}

	return 1;
}

public OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ)
{
    if (Var(playerid, LoggedIn) && Var(playerid, Spawned))
	{
 		if (!Player(playerid, Weapons)[weaponid])
		{
		    if (admin_IsOnline())
		    {
		        if (++Var(playerid, WeaponCheck) >= 5)
		        {
				    if (gettime() > Var(playerid, ReportTime))
				    {
					    admin_SendReport(playerid, -1, "possible hack, imbalanced weapons", true);
					}
				}
			}
			else
			{
			    TimeoutPlayer(playerid, true);
			}
		}

		if (GetPlayerState(playerid) == PLAYER_STATE_PASSENGER)
		{
			new vehicleid = GetPlayerVehicleID(playerid);

			if (Vehicle(vehicleid, DriverID) == INVALID_PLAYER_ID)
			{
				GameTextForPlayer(playerid, ""#TXT_LINE"~r~ejected", 1000, 3);
				SlapPlayer(playerid, 3.0);
			}
		}

		switch (weaponid)
  		{
		    case 22..34:
			{
		        ++Var(playerid, BulletsShot);
				switch (hittype)
				{
				    case BULLET_HIT_TYPE_PLAYER, BULLET_HIT_TYPE_VEHICLE:
					{
				        ++Var(playerid, BulletsHit);
					}
				}
			}
		}
	}

    return 1;
}

public OnPlayerGiveDamage(playerid, damagedid, Float:amount, weaponid, bodypart)
{
    if (Var(playerid, LoggedIn) && Var(damagedid, LoggedIn))
	{
        new team_1, team_2;
        
	    team_1 = Player(playerid, Team);
		team_2 = Player(damagedid, Team);
		
		if (Player(playerid, Protected) != 0 && team_1 != team_2)
		    PlayerProtection(playerid, PROTECTION_END);
		
		if (Var(damagedid, Duty) && !Var(playerid, Duty))
		{
	        switch (weaponid)
			{
				case 37, 18: { // Do nothing }
				default:
				{
					GameTextForPlayer(playerid, ""#TXT_LINE"~r~~h~please do not attack~n~~p~on duty admins!", 5000, 3);
					SlapPlayer(playerid, 3.0);
				}
			}
		}

		if (team_1 == team_2 && team_1 != MERCENARY)
		{
		    if (!Var(playerid, DM))
			{
				if (Var(playerid, DuelID) == -1)
				{
					GameTextForPlayer(playerid, ""#TXT_LINE"~r~do not attack~n~your team", 2000, 3);
				}
			}
		}

		if (!IsPlayerPaused(damagedid))
		{
			if (Var(playerid, HitSound))
			    PlayerPlaySound(playerid, 17802, 0, 0, 0);
			
			switch (weaponid)
			{
				case 33, 34:
				{
				    if (bodypart == BODYPART_HEAD && !Var(playerid, DM) && Var(playerid, DuelID) == -1)
					{
	                    if (team_1 != team_2)
	                    {
	                        PlayerHeadShotPlayer(playerid, damagedid, Var(damagedid, HasHelmet) ? HS_BREAKHELMET : HS_KILLPLAYER);
						}
					}
				}
			}
		}
	}

	return 1;
}

public OnPlayerCommandReceived(playerid, cmdtext[])
{
    if (Var(playerid, LoggedIn) && !Var(playerid, Spawned))
		return SendClientMessage(playerid, c_red, "* Please spawn first."), 0;
	}

	return 1;
}

public OnPlayerCommandPerformed(playerid, cmdtext[], success)
{
    if (Var(playerid, LoggedIn) && !success)
	{
		admin_SendMessage(6, c_grey, sprintf("[FAIL CMD] %s: %s", playerName(playerid), cmdtext));
		SendClientMessage(playerid, 0xA9C4E4FF, "You have tried to execute an invalid command.");
	}

	return 1;
}

public OnVehicleSpawn(vehicleid)
{
	if (Vehicle(vehicleid, BombingPlane))
	{
	    if (Vehicle(vehicleid, Bombed))
		{
	        Vehicle(vehicleid, Bombed) = false;

			if (Vehicle(vehicleid, BombLoadTimer) == -1)
			{
	    		Vehicle(vehicleid, BombLoadCounter) = 0;
				Vehicle(vehicleid, BombLoadTimer) = SetTimerEx("timer_AndromadaLoad", 10000, true, "i", vehicleid);
			}
		}
	}

	new type = Vehicle(vehicleid, Type);
	
	if (type)
	{
		SetVehicleHealth(vehicleid, g_ArmedVehicle[type][av_Health]);
	}

	return 1;
}

public OnVehicleDeath(vehicleid, killerid)
{
	if (Vehicle(vehicleid, Loaded))
	{
		Vehicle(vehicleid, Loaded) = false;
		Vehicle(vehicleid, SupplyingPlayer) = -1;
	}

	return 1;
}

public OnPlayerText(playerid, text[])
{
    if (Var(playerid, LoggedIn))
	{
		if (IsPlayerAllowedToChat(playerid, text))
		{
			new message[144];
			
			if (text[0] == '#' && Player(playerid, Level) >= 5)
			{
				admin_SendMessage(5, 0x80FF00FF, sprintf("<HChat> [%i]%s: %s", playerid, playerName(playerid), text[1]));
			 	return 0;
			}

			if (text[0] == '$' && Player(playerid, VIP) > 0)
			{
			    if (CheckIP(playerid, text))
				{
				    foreach(new i : Player)
					{
				        if (Player(i, VIP) > 0)
						{
				        	SendClientMessage(i, c_purple, sprintf("<VChat> [%i]%s: %s", playerid, playerName(playerid), text[1]));
				        	IRC_Echo(g_IRC_Conn[IRC_ADMIN_CHANNEL], sprintf("6<VChat> [%i]%s: %s", playerid, playerName(playerid), text[1]));
						}
					}
				}
				return 0;
			}

			if (text[0] == '@' && Var(playerid, SquadID) != -1)
			{
		        if (CheckIP(playerid, text[1]))
				{
					squad_SendMessage(Var(playerid, SquadID), 0xCCFBFFFF, sprintf("<Squad> [%i]%s: %s", playerid, playerName(playerid), text[1]));
					IRC_Echo(g_IRC_Conn[IRC_ADMIN_CHANNEL], sprintf("14<Squad> [%i]%s: %s", playerid, playerName(playerid), text[1]));
				}
				return 0;
			}

			if (text[0] == '!' && Player(playerid, ClanID) != -1)
			{
		 		clan_SendMessage(Player(playerid, ClanID), 0xDFE197FF, sprintf("<ClanChat> [%i]%s: %s", playerid, playerName(playerid), text[1]));

				IRC_Echo(g_IRC_Conn[IRC_ADMIN_CHANNEL], sprintf("14<ClanChat> [%i]%s: %s", playerid, playerName(playerid), text[1]));
                admin_SendMessage(1, c_grey, sprintf("<ClanChat> [%i]%s: %s", playerid, playerName(playerid), text[1]));

				return 0;
			}

			if (text[0] == '.' && Player(playerid, Level) > 0)
			{
				admin_SendMessage(1, ac_chat, sprintf("<AChat> [%i]%s: %s", playerid, playerName(playerid), text[1]));
				IRC_Echo(g_IRC_Conn[IRC_ADMIN_CHANNEL], sprintf("7<AChat> [%i]%s: %s", playerid, playerName(playerid), text[1]));

				return 0;
			}

			new
			 	bool:	is_onduty,
				 		in_dm;
			is_onduty = Var(playerid, Duty);
			in_dm = Var(playerid, DM);
			
			if (is_onduty == true)
			{
				Format:message("Admin %s[%i] {%06x}%s", playerName(playerid), playerid, c_sub(-1), text);
				IRC_Echo(g_IRC_Conn[IRC_MAIN_CHANNEL], sprintf("3Admin %s[%i]: %s", playerName(playerid), playerid, text));
			}
			else
			{
			    if (!Server(ChatDisabled))
				{
				    if (strlen(text) == strlen(Player(playerid, ChatMessage)) && (!strcmp(text, Player(playerid, ChatMessage))))
					{
				        SendClientMessage(playerid, c_red, "* Please do not repeat your message.");
				        format(Player(playerid, ChatMessage), 128, "%s", text);
						return 0;
					}
					Format:message("%s%s[%d] {%06x}%s", (in_dm) ? ("[DM] ") : (Player(playerid, VIP)) ? ("[VIP] ") : (""), playerName(playerid), playerid, c_sub(-1), text);
					format(Player(playerid, ChatMessage), 128, "%s", text);
					Player(playerid, ChatTime) = gettime() + 2;
				}
				else
				{
					return SendClientMessage(playerid, c_red, "* The chat is currently disabled."), 0;
				}
			}

			if (CheckIP(playerid, text))
			{
			    new teamid = Player(playerid, Team);
				SendClientMessageToAll((is_onduty) ? (ac_duty) : (in_dm) ? (c_lightyellow) : (Team(teamid, Color)), message);
			
				if (is_onduty == false)
				{
					IRC_Echo(g_IRC_Conn[IRC_MAIN_CHANNEL], sprintf("%s%s[%i]: %s", g_Team_IRC_Color[teamid], playerName(playerid), playerid, text));
				}
			}
		}
	}

	return 0;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
    if (Var(playerid, LoggedIn) && !ispassenger)
	{
	    new _state;

		foreach(new i : Player)
		{
		    _state = GetPlayerState(i);

		    if (IsPlayerInVehicle(i, vehicleid) && _state == PLAYER_STATE_DRIVER && Player(i, Team) == Player(playerid, Team))
			{
		        SlapPlayer(playerid, 1.0);
				GameTextForPlayer(playerid, ""#TXT_LINE"~r~do not carjack your team", 2000, 3);
			}
		}
	}

	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
    if (Var(playerid, LoggedIn))
	{
		new vehicleid = GetPlayerVehicleID(playerid);

		switch (newstate)
		{
		    case PLAYER_STATE_DRIVER:
			{
		        new class, type, required_rank;
		        
				class = Player(playerid, Class);
				type = Vehicle(vehicleid, Type);
				required_rank = g_ArmedVehicle[type][av_RequiredRank];
		        Vehicle(vehicleid, DriverID) = playerid;
				Var(playerid, CurrentVehicle) = vehicleid;
		        SetPlayerArmedWeapon(playerid, 0);

				if (Player(playerid, VIP) < 3 && Player(playerid, Rank) < required_rank)
				{
					SendClientMessage(playerid, c_red, sprintf("* You must be rank %i+ to use this vehicle.", required_rank));
					SlapPlayer(playerid, 2.0);
				}
				else
				{
					switch (type)
					{
					    case VEHICLE_TYPE_HYDRA, VEHICLE_TYPE_HUNTER, VEHICLE_TYPE_SPARROW:
						{
	        				if (class != PILOT && class != VIPCLASS)
							{
								SendClientMessage(playerid, c_red, "* Only pilot and VIP classes are authorized to fly this aircraft.");
								SlapPlayer(playerid, 2.0);
							}
						}
						case VEHICLE_TYPE_RHINO:
						{
	                     	switch (class)
					 		{
							 	case SNIPER, PILOT, MEDIC, SPY, SUPPORTER, DEMOLISHER, SUICIDE_BOMBER:
							 	{
									SendClientMessage(playerid, c_red, "* Only soldier, engineer, VIP and assault classes are authorized to drive tanks.");
									SlapPlayer(playerid, 2.0);
								}
							}
						}
					}
				}

				if (Vehicle(vehicleid, BombingPlane))
				{
					switch (class)
					{
						case PILOT, VIPCLASS:
						{
						    if (Player(playerid, Team) != Zone(7, Team))
							{
						    	SendClientMessage(playerid, c_red, "* Your team must have the 'Las Venturas Airport' captured before you can fly this aircraft.");
								SlapPlayer(playerid, 5.0);
							}
							else if (Vehicle(vehicleid, BombLoadCounter) != 0)
							{
								SendClientMessage(playerid, c_red, "* The aircraft is currently loading.");
								SlapPlayer(playerid, 5.0);
							}
						}
						default:
						{
							SendClientMessage(playerid, c_red, "* Only pilot and VIP classes are authorized to fly this aircraft.");
							SlapPlayer(playerid, 5.0);
						}
					}
				}

				foreach(new i : Player)
				{
				    if (admin_IsSpectating(i, playerid))
					{
				        TogglePlayerSpectating(i, 1);
				        PlayerSpectateVehicle(i, vehicleid);
						Var(i, SpecType) = SPEC_TYPE_VEHICLE;
					}
				}
			}
			case PLAYER_STATE_ONFOOT:
			{
			    new current_vehicle = Var(playerid, CurrentVehicle);
			    
				if (current_vehicle != 0)
				{
					Vehicle(current_vehicle, DriverID) = INVALID_PLAYER_ID;
					Var(playerid, CurrentVehicle) = 0;
				}

				foreach(new i : Player)
				{
			    	if (admin_IsSpectating(i, playerid))
					{
						if (Var(i, SpecType) == SPEC_TYPE_VEHICLE)
						{
			        		TogglePlayerSpectating(i, 1);
				        	PlayerSpectatePlayer(i, playerid);
			    	    	Var(i, SpecType) = SPEC_TYPE_PLAYER;
						}
					}
				}
			}
			case PLAYER_STATE_PASSENGER:
			{
				new driverid = Vehicle(vehicleid, DriverID);

				if (driverid != INVALID_PLAYER_ID)
				{
				    if (Player(playerid, Team) != Player(driverid, Team))
					{
				        SetPlayerArmedWeapon(playerid, 0);
					}
				}
			}
		}
	}

	return 1;
}

public OnPlayerLeaveCheckpoint(playerid)
{
    if (Var(playerid, LoggedIn))
	{
		if (GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
		{
			if (Var(playerid, CappingZone) != -1 && !Var(playerid, Assisting))
			{
				SendClientMessage(playerid, c_red, "* You left the checkpoint.");
				GameTextForPlayer(playerid, ""#TXT_LINE"~r~capture failed", 1000, 3);
			}
	  		zone_StopCapture(playerid);
		}
	}

	return 1;
}

public OnPlayerEnterRaceCheckpoint(playerid)
{
    if (Var(playerid, LoggedIn))
	{
	    zone_DropFlag(playerid);
	}
	return 1;
}

public OnPlayerClickMap(playerid, Float:fX, Float:fY, Float:fZ)
{
    if (Var(playerid, LoggedIn) && Var(playerid, Duty))
	{
        SetPlayerPosFindZ(playerid, fX, fY, fZ);
	}
	return 1;
}

public OnPlayerPickUpDynamicPickup(playerid, pickupid)
{
    if (Var(playerid, LoggedIn))
	{
		new bsid, team;
		
		bsid = basesam_ReturnClosestID(playerid);
		team = Player(playerid, Team);
		if (bsid != 0)
		{
			if (pickupid == BaseSam(bsid, Pickup))
			{
			    if (BaseSam(bsid, Time) > gettime())
				{
			        SendClientMessage(playerid, c_red, "* This base SAM has not been fully charged.");
				}
				else
				{
				    switch (team)
					{
				        case TERRORIST, MERCENARY:
						{
							return 1;
						}
						default:
						{
						    if (team != BaseSam(bsid, Team))
							{
						        SendClientMessage(playerid, c_red, "* You cannot use enemy team's base SAM.");
							}
							else
							{
						        if (Player(playerid, Rank) < 2)
								{
						            SendClientMessage(playerid, c_red, "* You must be rank 2+ to use base SAM.");
								}
								else
								{
									ShowDialog(playerid, D_BASESAM);
									Var(playerid, CurrentBaseSAM) = bsid;
								}
							}
						}
					}
				}
			}
		}
		if (!Var(playerid, Duty))
		{
		    if (pickupid == Server(SAMPickup))
			{
		        switch (team)
				{
					case MERCENARY, TERRORIST:
					{
		            	SendClientMessage(playerid, c_red, sprintf("* %s cannot use SAM.", Team(team, Name)));
					}
					default:
					{
						if (Server(SAMTime) != 0 && gettime() < Server(SAMTime))
						{
    						SendClientMessage(playerid, c_red, "* The SAM missile is not ready yet, type '/times' to see the remaining time.");
						}
						else if (Zone(2, Team) != team)
						{
						    SendClientMessage(playerid, c_red, "* Your team must have the 'Area 51' captured before you can launch.");
						}
						else
						{
							ShowDialog(playerid, D_SAM_MAIN);
						}
					}
				}
			}
			if (pickupid == Server(RadioPickup))
			{
			 	switch (team)
				{
					case MERCENARY, TERRORIST:
					{
		            	return 1;
					}
					default:
					{
						if (Zone(1, Team) != team)
						{
						    SendClientMessage(playerid, c_red, "* Your team must have the 'Radio Station' captured before you can use its weapons.");
						}
						else
						{
							ShowDialog(playerid, D_RADIO_MAIN);
						}
					}
				}
			}
			if (pickupid == Server(AbandonedAirportPickup))
			{
			    switch (team)
				{
					case MERCENARY, TERRORIST:
					{
		            	SendClientMessage(playerid, c_red, sprintf("* Terrorist cannot use this feature.", Team(team, Name)));
					}
					default:
					{
						ShowDialog(playerid, D_ABANDONEDAIRPORT);
					}
				}
			}
			foreach(new i : Player)
			{
				if (pickupid == g_HealthPickup[i] && !Player(playerid, Protected))
				{
					new Float: hp;

					GetPlayerHealth(playerid, hp);
					if (hp < 99.0)
					{
						SetPlayerHealth(playerid, hp + 10.0);
						DestroyDynamicPickup(g_HealthPickup[i]);
						g_HealthPickup[i] = -1;
					}
				}
				if (pickupid == g_ArmourPickup[i])
				{
				    new Float: armour;

					GetPlayerArmour(playerid, armour);
					if (armour < 99.0)
					{
					    SetPlayerArmour(playerid, armour + 10.0);
						DestroyDynamicPickup(g_ArmourPickup[i]);
						g_ArmourPickup[i] = -1;
					}
				}
			}
		}
	}
	return 1;
}

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
    if (Var(playerid, LoggedIn))
	{
	    foreach(new i : Player)
		{
		    if (admin_IsSpectating(i, playerid))
			{
				if (Var(i, SpecType) == SPEC_TYPE_PLAYER)
				{
			  		SetPlayerInterior(i, newinteriorid);
				}
			}
		}
	}
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if (Var(playerid, LoggedIn))
	{
	 	switch (GetPlayerState(playerid))
 		{
		 	case PLAYER_STATE_ONFOOT:
		 	{
		 	    new weaponid = GetPlayerWeapon(playerid);

				switch (weaponid)
				{
				 	case 34, 35:
			 		{
						/*
							Remove the helmet and when players are aiming with
							sniper or rocket launcher, to avoid distraction.
						*/
						if (pressed(KEY_HANDBRAKE))
						{
				    	    if (Var(playerid, HasHelmet))
							{
								REMOVEHELMET(playerid);
							}
							if (Var(playerid, HasMask))
							{
								REMOVEMASK(playerid);
							}
						}
						/*
							Restore the helmet and mask when they release the
							aim button.
						*/
						else if (released(KEY_HANDBRAKE))
						{
							if (Var(playerid, HasHelmet) && Var(playerid, Helmet))
							{
								PUTHELMET(playerid);
							}
							if (Var(playerid, HasMask) && Var(playerid, Mask))
							{
								PUTMASK(playerid);
							}
						}
					}
				}
				if ((pressed(KEY_FIRE)) && (weaponid == 17))
				{
					// Checking if the player is running
		  		    new keys, ud, lr;

					GetPlayerKeys(playerid, keys, ud, lr);
					if (keys & KEY_SPRINT)
					{
						return 1;
					}
					/*
						If the player is already affected by other player's
						teargas, we will stop him/her from throwing a teargas
					*/
		  		    if (IsPlayerUsingAnimation(playerid, "IDLE_tired")
					  	|| IsPlayerUsingAnimation(playerid, "gas_cwr")
			  			&& IsPlayerInAnyVehicle(playerid))
					{
						return 1;
					}
					foreach(new i : Player)
					{
					    if (!IsPlayerPaused(i))
						{
					        if (i != playerid
								&& RangeBetween(playerid, i) < 7.0
								&& Player(i, Team) != Player(playerid, Team))
							{
				                if (!Var(i, Duty) && !Var(i, Mask))
								{
					                ApplyAnimation(i, "ped", "gas_cwr", 1.1, 1, 1, 1, 0, 0);
									KillTimer(Timer(i, Teargas));
								    Timer(i, Teargas) = -1;
									if (Timer(i, Teargas) == -1)
									{
										Timer(i, Teargas) = SetTimerEx("StopEffect", 3000, 0, "i", i);
									}
								}
							}
						}
					}
				}
				if (pressed(KEY_YES))
				{
					if (!Var(playerid, Duty))
					{
						new zoneid = zone_ReturnClosestFlagID(playerid);

						if (zoneid != -1)
						{
			        		zone_StartFlagCapture(playerid, zoneid);
						}
					}
				}
				if (pressed(KEY_CROUCH) && !Var(playerid, DM))
				{
				    new Float:x, Float:y, Float:z, weapon, ammo, world;
				    
                    world = GetPlayerVirtualWorld(playerid);
					foreach(new i : Player)
					{
						for(new a = 0, b = MAX_WEAPON_SLOT; a < b; a++)
						{
							x = g_WD_DroppedX[i][a];
							y = g_WD_DroppedY[i][a];
							z = g_WD_DroppedZ[i][a];
							if (IsPlayerInRangeOfPoint(playerid, 2.0, x, y, z))
							{
								if (g_WD_Pickup[i][a] != -1)
								{
									if (g_WD_Data[i][a][2] == world)
									{
									    weapon = g_WD_Data[i][a][0];
										ammo = g_WD_Data[i][a][1];
										DestroyDynamicPickup(g_WD_Pickup[i][a]);
										GivePlayerWeapon(playerid, weapon, ammo);
										g_WD_Pickup[i][a] = -1;
									}
								}
							}
						}
					}
				}
			}
			case PLAYER_STATE_DRIVER:
			{
			    new vehicleid = GetPlayerVehicleID(playerid);

				if (pressed(KEY_HANDBRAKE) && Vehicle(vehicleid, BombingPlane))
				{
					if (!Vehicle(vehicleid, Bombed))
					{
						if (Player(playerid, Team) != Zone(7, Team))
						{
							SendClientMessage(playerid, c_red, "* Your team does not own the Las Venturas Airport.");
						}
						else
						{
							foreach(new i : Teams)
							{
								if (IsPlayerInDynamicArea(playerid, Team(i, ZoneArea)) && Player(playerid, Team) != i)
								{
									Exceptional(playerid, c_lightyellow, sprintf("*** Pilot %s just dropped few bombs at the %s's base.", playerName(playerid), Team(i, Name)));
									SendClientMessage(playerid, c_green, sprintf("You have dropped bombs at the %s's base.", Team(i, Name)));
									GameTextForPlayer(playerid, ""#TXT_LINE"~g~~h~bombs dropped", 2000, 3);
									SetTimerEx("Andromada_BombDrop", 5000, false, "iii", playerid, vehicleid, i);
									Vehicle(vehicleid, Bombed) = true;
									break;
								}
							}
						}
					}
				}
				if (pressed(KEY_SECONDARY_ATTACK) && vehicle_IsAircraft(vehicleid))
				{
					new Float: health;

					GetVehicleHealth(vehicleid, health);
					if (health < 280.0)
					{
						GameTextForPlayer(playerid, ""#TXT_LINE"~r~ejected!", 3000, 3);
						GivePlayerWeapon(playerid, 46, 1);
						SlapPlayer(playerid, 40.0);
					}
				}
			}
			case PLAYER_STATE_SPECTATING:
			{
			    if (g_SpecID[playerid] == INVALID_PLAYER_ID)
				{
				    admin_AdvanceSpec(playerid);
				}
				else
				{
			        if (Var(g_SpecID[playerid], Spawned))
					{
						if (pressed(KEY_FIRE))
						{
						 	admin_AdvanceSpec(playerid);
						}
						else if (pressed(KEY_HANDBRAKE))
						{
						    admin_ReverseSpec(playerid);
						}
						else if (pressed(KEY_CROUCH))
						{
							admin_StopSpec(playerid);
						}
					}
				}
			}
		}
		if (pressed(KEY_YES))
		{
			if (Var(playerid, InvitedSquadID) != -1)
			{
				squad_Join(playerid, Var(playerid, InvitedSquadID));
				Var(playerid, InvitedSquadID) = -1;
			}
			else if (IsPlayerInRangeOfPoint(playerid, 2.5, nuke_x, nuke_y, nuke_z))
			{
			    switch (Player(playerid, Team))
				{
			        case MERCENARY, TERRORIST:
					{
						return 1;
			        }
			        default:
					{
					    if (Nuke(Time) != 0 && gettime() < Nuke(Time))
					    {
					        SendClientMessage(playerid, c_red, "* The nuclear bomb is not ready yet, type '/times' to see the remaining time.");
						}
						else if (Zone(2, Team) != Player(playerid, Team))
						{
						    SendClientMessage(playerid, c_red, "* Your team must have the 'Area 51' captured before you can launch.");
						}
						else if (Player(playerid, Rank) < 5)
						{
						    SendClientMessage(playerid, c_red, "* You must be rank 5+ to launch.");
						}
						else
						{
							ShowDialog(playerid, D_NUKEMAIN);
						}
					}
				}
			}
			else if (IsPlayerInRangeOfPoint(playerid, 3.0, gz_x, gz_y, gz_z))
			{
			    switch (Player(playerid, Team))
				{
			        case MERCENARY, TERRORIST:
					{
						return 1;
			        }
			        default:
					{
					    if (Server(GroundZeroTime) < 100)
					    {
					        SendClientMessage(playerid, c_red, "* Ground Zero's weapons are not fully charged yet.");
						}
						else if (Zone(9, Team) != Player(playerid, Team))
						{
						    SendClientMessage(playerid, c_red, "* Your team must have the 'Ground Zero' captured before you can use its weapons.");
						}
						else
						{
							ShowDialog(playerid, D_GZ_MAIN);
						}
					}
				}
			}
			else
			{
				if (Var(playerid, DuelInvitePlayer) != INVALID_PLAYER_ID)
				{
				    new id = Var(playerid, DuelInvitePlayer);

					duel_AcceptInvitation(playerid, id);
				}
			}
		}
	    if (pressed(KEY_NO))
		{
		 	if (Var(playerid, InvitedSquadID) != -1)
	 		{
				SendClientMessage(playerid, c_orange, "* You have rejected the squad invitation.");
		        SendClientMessage(g_Squads[Var(playerid, InvitedSquadID)][sq_Members][0], c_tomato, sprintf("* %s has rejected your squad invitation.", playerName(playerid)));
		        Var(playerid, InvitedSquadID) = -1;
			}
			else
			{
			    if (Var(playerid, DuelInvitePlayer) != INVALID_PLAYER_ID)
				{
					new id = Var(playerid, DuelInvitePlayer);

					SendClientMessage(playerid, c_orange, sprintf("* You have rejected the duel request of %s.", playerName(id)));
					SendClientMessage(id, c_tomato, sprintf("* %s has rejected your duel request.", playerName(playerid)));
				    duel_RejectInvitation(playerid, id);
				}
			}
		}
	}
	return 1;
}

public OnRconLoginAttempt(ip[], password[], success)
{
    if (!success)
	{
	    foreach(new i : Player)
		{
			if (++g_RconAttempts[i] >= 3)
			{
				if (!strcmp(ip, Player(i, Ip), true))
				{
				    BanPlayer(i, "Permanent", "Fail RCON login", bot, true);
				}
			}
			else
			{
				// Fail login++
			}
		}
    }
	return 1;
}

public OnPlayerUpdate(playerid)
{
    if (Var(playerid, LoggedIn) && Var(playerid, Spawned))
	{
    	Var(playerid, PauseCheck) = GetTickCount();
	}
	return 1;
}

public OnPlayerStreamIn(playerid, forplayerid)
{
    if (Var(playerid, LoggedIn) && Var(playerid, Spawned))
	{
		if (Var(playerid, Duty))
		{
		    new color = GetPlayerColor(playerid);
			SetPlayerMarkerForPlayer(forplayerid, playerid, color);
		}
		else
		{
			switch (Player(playerid, Class))
			{
				case SNIPER, ASSAULT:
				{
					HideMarker(forplayerid, playerid);
				}
				default:
				{
					ShowMarker(forplayerid, playerid);
				}
			}
		}
	}
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	switch (dialogid)
	{
	    case D_REGISTER1: dialog_Register_1(playerid, response, inputtext);
		case D_REGISTER2: dialog_Register_2(playerid, response, inputtext);
		case D_LOGIN: dialog_Login(playerid, response, inputtext);
		case D_SHOP: dialog_Shop(playerid, response, listitem);
		case D_CLASS: dialog_Class(playerid, response, listitem);
		case D_WEAPONS: dialog_Weapons(playerid, response, listitem);
		case D_AMMO: dialog_Ammo(playerid, response, listitem);
		case D_SPAWNPOINT: dialog_SpawnPoint(playerid, response, listitem);
		case D_SETTINGS: dialog_Settings(playerid, response, listitem);
		case D_CHANGEPASS_1: dialog_ChangePass_1(playerid, response, inputtext);
		case D_CHANGEPASS_2: dialog_ChangePass_2(playerid, response, inputtext);
		case D_BASESAM: dialog_BaseSAM(playerid, response);
		case D_CLASSINFO: dialog_ClassInfo(playerid, response);
		case D_DMLIST: dialog_DM_List(playerid, response, listitem);
		case D_NUKEMAIN: dialog_NukeMain(playerid, response, listitem);
		case D_NUKEZONES: dialog_NukeZones(playerid, response, listitem);
		case D_NUKEBASES: dialog_NukeBases(playerid, response, listitem);
		case D_ABANDONEDAIRPORT: dialog_AbandonedAirport(playerid, response);
		case D_WIPENUKE: dialog_WipeNuke(playerid, response);
		case D_INVENTORY: dialog_Inventory(playerid, response, listitem);
		case D_SAM_MAIN: dialog_SAM(playerid, response, listitem);
		case D_SAM_ZONES: dialog_SAM_Zones(playerid, response, listitem);
		case D_SAM_BASES: dialog_SAM_Bases(playerid, response, listitem);
		case D_CLANS: dialog_Clans(playerid, response, listitem);
		case D_CLAN_INFO: dialog_ClanInfo(playerid, response);
		case D_CLAN_NAME: dialog_ClanName(playerid, response, inputtext);
		case D_CLAN_TAG: dialog_ClanTag(playerid, response, inputtext);
		case D_CLAN_FOUNDER: dialog_ClanFounder(playerid, response, inputtext);
		case D_CLAN_SKIN: dialog_ClanSkin(playerid, response, inputtext);
		case D_CLAN_SETTINGS: dialog_ClanSettings(playerid, response, listitem);
		case D_CWCMDS: dialog_CWCmds(playerid, response);
		case D_CLAN_MOTTO: dialog_ClanMotto(playerid, response, inputtext);
		case D_CLAN_MEMBERS: dialog_ClanMembers(playerid, response);
		case D_CLAN_SKIN_CONFIRM: dialog_ClanSkinConfirm(playerid, response);
		case D_CMD_TITLE: dialog_CmdTitle(playerid, response, listitem);
		case D_CMD: dialog_Cmd(playerid, response);
		case D_RADIO_MAIN: dialog_RadioMain(playerid, response, listitem);
		case D_RADIO_HACK_TEAM: dialog_HackRadioTeam(playerid, response, listitem);
		case D_DONATE: dialog_Donate(playerid, response);
		case D_VIPFEAT: dialog_VIPFeat(playerid, response);
		case D_RADIO_HACK_CONFIRM: dialog_HackRadioConfirm(playerid, response);
		case D_RADIO_BREAK_TEAM: dialog_BreakRadioTeam(playerid, response, listitem);
		case D_RADIO_BREAK_CONFIRM: dialog_BreakRadioConfirm(playerid, response);
		case D_GZ_MAIN: dialog_GroundZeroMain(playerid, response, listitem);
		case D_GZ_MOAB: dialog_MOAB(playerid, response);
	}
	return 1;
}

public OnDynamicObjectMoved(objectid)
{
    if (objectid == Nuke(Object))
    {
		nuke_Blast();
	}
	return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	if (Var(clickedplayerid, LoggedIn) && Var(clickedplayerid, Spawned))
	{
		ShowPlayerStats(clickedplayerid, playerid);
	}
	return 1;
}

#include <wg_functions.pwn>
#include <wg_td.pwn>
#include <wg_sql.pwn>
#include <wg_timers.pwn>
#include <wg_superweapons.pwn>
#include <wg_cmds.pwn>
