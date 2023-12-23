function IRC_ChangeName(user[], new_name[], channel[], steps)
{
	new query[128], row = cache_num_rows();

	switch (steps)
	{
	    // Step 0, checking if user is banned
		case 0:
		{
		    if (row)
				return IRC_Echo(channel, ""#IRC_PREFIX_ERROR"Specified user is currently banned.");

		    Query("SELECT `nick` FROM `users` WHERE `nick`='%e' LIMIT 1", new_name);
 	    	mysql_tquery(connection, query, "IRC_ChangeName", "sssi", user, new_name, channel, 1);
			return 1;
		}
		// Step 1, checking if new name is already in use
		case 1:
		{
		    if (row)
				return IRC_Echo(channel, ""#IRC_PREFIX_ERROR"New name is already used by another user.");
	
            Query("SELECT `id`,`nick`,`cash` FROM `users` WHERE `nick`='%e' LIMIT 1", user);
 	    	mysql_tquery(connection, query, "IRC_ChangeName", "sssi", user, new_name, channel, 2);
			return 1;
		}
		// Step 2, changing the name
		case 2:
		{
		    if (!row)
				return IRC_Echo(channel, ""#IRC_PREFIX_ERROR"Account with this username does not exist.");

			new money = cache_get_field_content_int(0, "cash");

			if (money < 300000)
				return IRC_Echo(channel, ""#IRC_PREFIX_ERROR"Specified user does not have enough money. Requires: $300,000.");

			new userid;

			userid = cache_get_field_content_int(0, "id");
			money -= 300000;

			Query("UPDATE `users` SET `nick`='%e',`cash`='%i' WHERE `id`='%i'", new_name, money, userid);
			mysql_tquery(connection, query, "ExecuteQuery", "i", res_none);
			IRC_Echo(channel, sprintf("%sUser %s's name has been changed to %s.", IRC_PREFIX_SUCCESS, user, new_name));
		}
	}

	return 1;
}

function ClanQuery(result, playerid, extrastr[], extraid, other)
{
	new row = cache_num_rows();

	switch (result)
	{
		case clan_res_checkname:
		{
		    if (row)
			{
	            SendClientMessage(playerid, c_red, "* Clan with this name already exists, please choose another name.");
			    return ShowDialog(playerid, D_CLAN_NAME);
			}
	
   			format(g_RegisteringClan[playerid], 45, "%s", extrastr);
			ShowDialog(playerid, D_CLAN_TAG);
		}
		case clan_res_checktag:
		{
		    if (row)
			{
		        SendClientMessage(playerid, c_red, "* Clan with this tag already exists, please choose another tag.");
		        return ShowDialog(playerid, D_CLAN_TAG);
		    }
	
		    format(g_RegisteringClanTag[playerid], 10, "%s", extrastr);
			ShowDialog(playerid, D_CLAN_FOUNDER);
		}
		case clan_res_assignfounder:
		{
            if (!row)
			{
				SendClientMessage(playerid, c_red, "Account with this username does not exist.");
				return ShowDialog(playerid, D_CLAN_FOUNDER);
			}

			new p_clan = cache_get_field_content_int(0, "clanid");

			if (p_clan != -1)
			{
			    SendClientMessage(playerid, c_red, "* Specified user is already a member of a clan.");
				return ShowDialog(playerid, D_CLAN_FOUNDER);
			}

	        new query[200], clanid, id, founder;

	        id = cache_get_field_content_int(0, "id");
	        founder = return_IDByName(extrastr);
			clanid = Iter_Free(Clans);
			Iter_Add(Clans, clanid);

			format(Clan(clanid, Name), 45, "%s", g_RegisteringClan[playerid]);
			format(Clan(clanid, Tag), 10, "%s", g_RegisteringClanTag[playerid]);
			format(Clan(clanid, Founder), 24, "%s", extrastr);
			format(Clan(clanid, Registered), 24, "%s", return_Stamp());
			++Clan(clanid, MemberCount);

			if (founder != -1)
			{
				Player(founder, ClanID) = clanid;
				Player(founder, ClanLeader) = 1;
			}

			strcat(query, "INSERT INTO `clans` ");
			strcat(query, "(clan_id,clan_name,clan_tag,clan_founder,clan_members,clan_registered) ");
			strcat(query, "VALUES ('%i','%e','%e','%e','%i',UTC_TIMESTAMP())");
			Query(query, clanid, g_RegisteringClan[playerid], g_RegisteringClanTag[playerid], extrastr, Clan(clanid, MemberCount));
			mysql_tquery(connection, query, "ExecuteQuery", "i", res_none);

			new d_str[256];

			strcat(d_str, ""#sc_blue"ID: "#sc_white"%i\n");
            strcat(d_str, ""#sc_blue"Name: "#sc_white"%s\n");
            strcat(d_str, ""#sc_blue"Tag: "#sc_white"%s\n");
            strcat(d_str, ""#sc_blue"Founder: "#sc_white"%s\n");
			strcat(d_str, ""#sc_blue"Created date: "#sc_white"%s");

			Format:d_str(d_str, clanid, g_RegisteringClan[playerid], g_RegisteringClanTag[playerid], extrastr, Clan(clanid, Registered));
			ShowPlayerDialog(playerid, D_MSG, DIALOG_STYLE_MSGBOX, "Clan registered!", d_str, "Close", "");
			Query("UPDATE `users` SET `clanid`='%i',`clan_leader`='1' WHERE `id`='%i'", clanid, id);
			mysql_tquery(connection, query, "ExecuteQuery", "i", res_none);

			g_RegisteringClan[playerid][0] = '\0';
			g_RegisteringClanTag[playerid][0] = '\0';
			Clan(clanid, Skin) = -1;
		}
		case clan_res_memlist:
		{
		    if (row)
		    {
		        new name[24], list[1000];

		        for (new i, j = row; i < j; i++)
		        {
		            cache_get_field_content(i, "nick", name);
		            Format:list("%s"#sc_white"%s\n", list, name);
				}
				ShowPlayerDialog(playerid, D_CLAN_MEMBERS, DIALOG_STYLE_MSGBOX, sprintf("Members of %s", Clan(Player(playerid, ClanID), Name)), list, "Back", "");
		    }
		}
		case clan_res_removemember:
		{
		    if (!row)
				return SendClientMessage(playerid, c_red, "* Account with this username does not exist.");
	
	        new clanid = Player(playerid, ClanID), tmp_clan = cache_get_field_content_int(0, "clanid");

		    if (tmp_clan == -1)
		        return SendClientMessage(playerid, c_red, "* Specified user is not a member of any clan.");
			
			if (tmp_clan != clanid)
			    return SendClientMessage(playerid, c_red, "* Specified user is not a member of your clan.");
		
			new leader = cache_get_field_content_int(0, "clan_leader");

			if (leader == 1 && !clan_IsPlayerFounder(playerid, clanid))
			    return SendClientMessage(playerid, c_red, "* Specified user is a leader of this clan, only founder can remove them.");
			}

			new userid, query[135];

			userid = cache_get_field_content_int(0, "id");
			--Clan(clanid, MemberCount);
		    Query("UPDATE `clans` SET `clan_members`='%i' WHERE `clan_id`='%i'", Clan(clanid, MemberCount), clanid);
		    mysql_tquery(connection, query, "ExecuteQuery", "i", res_none);
		    Query("UPDATE `users` SET `clanid`='-1',`clan_leader`='0' WHERE `id`='%i'", userid);
		    mysql_tquery(connection, query, "ExecuteQuery", "i", res_none);
		    SendClientMessage(playerid, c_green, sprintf("You have successfully removed player %s from this clan.", extrastr));
			
			if (extraid != -1)
			{
				Player(extraid, ClanID) = -1;
				SendClientMessage(extraid, c_tomato, sprintf("Clan leader %s has removed you from %s.", playerName(playerid), Clan(clanid, Name)));
				
				if (Player(extraid, ClanLeader) == 1)
				{
				    Player(extraid, ClanLeader) = 0;
				}
			}
		}
		case clan_res_setleader:
		{
		    if (!row)
				return SendClientMessage(playerid, c_red, "* Account with this username does not exist.");

	        new clanid = Player(playerid, ClanID), tmp_clan = cache_get_field_content_int(0, "clanid");

		    if (tmp_clan == -1)
		        return SendClientMessage(playerid, c_red, "* Specified user is not a member of any clan.");
			
			if (tmp_clan != clanid)
			    return SendClientMessage(playerid, c_red, "* Specified user is not a member of your clan.");

			new leader = cache_get_field_content_int(0, "clan_leader");

			switch (other)
			{
				case 0:
				{
					switch (leader)
					{
						case 0: return SendClientMessage(playerid, c_red, "* Specified user is note a leader of this clan.");
						case 1:
						{
							if (!clan_IsPlayerFounder(playerid, clanid))
							{
							    return SendClientMessage(playerid, c_red, "* Specified user is a leader of this clan, only founder can remove them.");
							}
						}
					}
				}
				case 1:
				{
				    if (leader == 1)
					{
				        return SendClientMessage(playerid, c_red, "* Specified user is already a leader of this clan.");
    				}
				}
			}

			new userid, query[128];

			userid = cache_get_field_content_int(0, "id");
		    Query("UPDATE `users` SET `clan_leader`='%i' WHERE `id`='%i'", other, userid);
		    mysql_tquery(connection, query, "ExecuteQuery", "i", res_none);
		    SendClientMessage(playerid, c_green, sprintf("You have successfully %s %s's leader status.", (other) ? ("set") : ("removed"), extrastr));
			
			if (extraid != -1)
			{
				Player(extraid, ClanLeader) = other;
				SendClientMessage(extraid, -1, sprintf("%s has %s your leader status for the clan %s.", playerName(playerid), (other) ? ("set") : ("removed"), Clan(clanid, Name)));
			}
		}
		case clan_res_delete:
		{
		    if (!row)
				return SendClientMessage(playerid, c_red, "* Clan with this name does not exist.");

			new clanid, query[128];

			clanid = cache_get_field_content_int(0, "clan_id");
			Query("DELETE FROM `clans` WHERE `clan_id`='%i'", clanid);
			mysql_tquery(connection, query, "ExecuteQuery", "i", res_none);

			Iter_Remove(Clans, clanid);
			SendClientMessage(playerid, ac_cmd1, sprintf("You have successfull deleted the clan: %s", Clan(clanid, Name)));

			Query("UPDATE `users` SET `clanid`='-1',`clan_leader`='0' WHERE `clanid`='%i'", clanid);
			mysql_tquery(connection, query, "ExecuteQuery", "i", res_none);
			
			foreach(new i : Player)
			{
				if (Player(i, ClanID) == clanid)
				{
					Player(i, ClanID) = -1;

					if (Player(i, ClanLeader) == 1)
					{
					    Player(i, ClanLeader) = 0;
					}
				}
			}

			new _x[E_CLAN_DATA];
			g_Clans[clanid] = _x;
		}
	}

	return 1;
}

function IRC_Offline_Unban(user[], playerid, channel[])
{
	if (cache_num_rows())
	{
		new query[100], id, nick[24];

		cache_get_field_content(0, "nick", nick);
		id = cache_get_field_content_int(0, "id");
		Query("DELETE FROM `bans` WHERE `id`='%i'", id);
		mysql_tquery(connection, query, "ExecuteQuery", "i", res_none);
		
		if (playerid == INVALID_PLAYER_ID)
		{
			IRC_Echo(channel, sprintf("%sUser %s has been unbanned.", IRC_PREFIX_SUCCESS, nick));
		}
		else
		{
		    SendClientMessage(playerid, ac_cmd1, sprintf("User %s has been unbanned.", nick));
		}
	}
	else
 	{
	    if (playerid == INVALID_PLAYER_ID)
	    {
	    	IRC_Echo(channel, ""#IRC_PREFIX_ERROR"Specified username or IP is not banned.");
		}
		else
		{
			SendClientMessage(playerid, c_red, "* Specified username or IP is not banned.");

		}
	}

	return 1;
}

function IRC_Check_OfflineBan(channel[], user[], bannedby[], reason[], istemp, hours, minutes)
{
    new row;

	row = cache_num_rows();

	if (!row)
		return IRC_Echo(channel, ""#IRC_PREFIX_ERROR"Account with this username does not exist.");

	new id, ip[16], query[100];

	id = cache_get_field_content_int(0, "id");
	cache_get_field_content(0, "ip", ip);
	Query("SELECT * FROM `bans` WHERE `id`='%i'", id);
	
	if (istemp)
	{
		mysql_tquery(connection, query, "IRC_Ban_Offline", "ssssisiii", channel, user, bannedby, reason, id, ip, istemp, hours, minutes);
	}
	else
	{
	    mysql_tquery(connection, query, "IRC_Ban_Offline", "ssssisi", channel, user, bannedby, reason, id, ip, istemp);
	}

	return 1;
}

function IRC_Ban_Offline(channel[], user[], bannedby[], reason[], id, ip[], istemp, hours, minutes)
{
    new row = cache_num_rows();

	if (row)
		return IRC_Echo(channel, ""#IRC_PREFIX_ERROR"Specified user is already banned.");
	
	new admin[36], query[250];

 	Format:admin("%s %s", bannedby, "from IRC");

	if (istemp)
	{
	    new stamp;

		stamp = (hours * 3600) + (minutes * 60) + gettime();
		IRC_Echo(channel, sprintf("%sUser %s has been temporarily banned for %iH and %iM. Reason: %s", IRC_PREFIX_SUCCESS, user, hours, minutes, reason));
		Query("INSERT INTO `bans` (id,nick,bannedby,date,ip,type,time,reason) VALUES ('%i','%e','%e',UTC_TIMESTAMP(),'%e','%e','%i','%e')", id, user, admin, ip, "Temporary", stamp, reason);
	    return mysql_tquery(connection, query, "ExecuteQuery", "i", res_none);
	}

    #pragma unused hours
    #pragma unused minutes
	Query("INSERT INTO `bans` (id,nick,bannedby,date,ip,type,reason) VALUES ('%d','%e','%e',UTC_TIMESTAMP(),'%e','%e','%e')", id, user, admin, ip, "Permanent", reason);
	mysql_tquery(connection, query, "ExecuteQuery", "i", res_none);
	IRC_Echo(channel, sprintf("%sUser %s has been banned. Reason: %s", IRC_PREFIX_SUCCESS, user, reason));

	return 1;
}

function result_FetchAKA(playerid, id, type, channel[])
{
	new row = cache_num_rows();

	if (!row)
	{
		 return (!type) ? 	(SendClientMessage(playerid, c_red, "No results found for this user.")) :
							(IRC_Echo(channel, ""#IRC_PREFIX_ERROR"No results found for this user."));
	}

	new user[24], result[138], count = 0;

	for (new i = 0, j = row; i < j; i++)
	{
		cache_get_field_content(i, "nick", user);
		Format:result("%s%s | ", result, user);
		++count;
	}

	if (!type && playerid != -1)
	{
	    #pragma unused channel
		SendClientMessage(playerid, ac_cmd1, sprintf("Users that connected from %s's IP: (Showing: %i/10)", playerName(id), count));
		SendClientMessage(playerid, ac_cmd1, result);
	}
	else
	{
        IRC_Echo(channel, sprintf("%sUsers that connected from %s's IP: (Showing: %i/10)", IRC_PREFIX_RESULT, playerName(id), count));
        IRC_Echo(channel, result);
	}

	return 1;
}

function IRC_Check_LastSeen(channel[], user[])
{
    new row =cache_num_rows();

	if (!row)
	    return IRC_Echo(channel, ""#IRC_PREFIX_ERROR"Account with this username does not exist.");

	new date[24];

	cache_get_field_content(0, "last_logged", date);
	IRC_Echo(channel, sprintf("%sUser %s was last seen in-game on %s.", IRC_PREFIX_RESULT, user, date));

	return 1;
}

function ExecuteQuery(res, int, str[])
{
	new rows;

	if (res != res_none)
		rows = cache_num_rows();

	switch (res)
	{
	    case res_check_useracc:
		{
	        clear_Chat(int);

			SetPlayerCameraPos(int, 78.1762, 1762.0693, 30.2059);
			SetPlayerCameraLookAt(int, 78.9072, 1761.3792, 30.0434);

	        SendClientMessage(int, c_yellow, "              Hello and welcome to TeamDSS");
			SendClientMessage(int, c_yellow, "     Call of Duty - Warground. Current version: "#server_version"");
			SendClientMessage(int, c_grey, "* If this is your first visit, please take a few minutes to read '/help' and '/rules' to understand this server better.");
			
			if (Server(MOTD) != '\0')
			{
				SendClientMessage(int, c_tomato, sprintf("> MOTD: %s", Server(MOTD)));
			}
			
			if (rows)
			{
			    cache_get_field_content(0, "pass", Player(int, Pass), connection, 129);
				Player(int, UserID) = cache_get_field_content_int(0, "id");
				ShowDialog(int, D_LOGIN);
			}
			else
			{
			    if (!Player(int, Level) && strfind(playerName(int), "[DSS]") != -1)
				{
					KickEx(int, c_red, "* You are not authorized to hold [DSS] tag.");
				}
				else
				{
					SendClientMessage(int, c_tomato, "- This is not a registered account. Please enter your desired password below to register.");
					ShowDialog(int, D_REGISTER1);
				}
			}
		}
		case res_load_useracc:
		{
			new weapkills[100];

			Player(int, Level) = cache_get_field_content_int(0, "level");
			Player(int, Kills) = cache_get_field_content_int(0, "kills");
			Player(int, Deaths) = cache_get_field_content_int(0, "deaths");
			Player(int, Score) = cache_get_field_content_int(0, "score");
		 	Player(int, Money) = cache_get_field_content_int(0, "cash");
		 	Player(int, Credits) = cache_get_field_content_int(0, "credits");
		 	Player(int, HelmetActivated) = cache_get_field_content_int(0, "item_helmet");
		 	Player(int, MaskActivated) = cache_get_field_content_int(0, "item_mask");
		 	Player(int, BoostActivated) = cache_get_field_content_int(0, "item_boost");
		 	Player(int, ClanID) = cache_get_field_content_int(0, "clanid");
		 	Player(int, ClanLeader) = cache_get_field_content_int(0, "clan_leader");
		 	Player(int, Headshots) = cache_get_field_content_int(0, "headshots");
		 	Player(int, CapturedZones) = cache_get_field_content_int(0, "capped_zones");
		 	Player(int, CapturedFlags) = cache_get_field_content_int(0, "capped_flags");
		 	Player(int, Jailed) = cache_get_field_content_int(0, "jail_time");
		 	Player(int, Muted) = cache_get_field_content_int(0, "mute_time");
		 	Player(int, VIP) = cache_get_field_content_int(0, "vip");
		 	Player(int, VIP_Time) = cache_get_field_content_int(0, "vip_time");
			
			cache_get_field_content(0, "weapkills", weapkills);
			cache_get_field_content(0, "registered_date", Player(int, RegDate), connection, 24);

			sscanf(weapkills, "p<:>a<i>[100]", Player(int, WeaponKills));
			
			if (!Player(int, Level) && strfind(playerName(int), "[DSS]") != -1)
			{
				KickEx(int, c_red, "* You are not authorized to hold [DSS] tag.");
			}
			else
			{
				new query[130], clanid;

				Var(int, HitSound) = true;
				UpdateRank(int);
				Query("UPDATE `users` SET `new_ip`='%e',`last_logged`='%e' WHERE `id`='%i'", Player(int, Ip), return_Stamp(), Player(int, UserID));
				mysql_tquery(connection, query, "ExecuteQuery", "i", res_none);

				clanid = Player(int, ClanID);
				query[0] = '\0';
				
				if (clanid != -1)
				{
					clan_SendMessage(clanid, c_clan, sprintf("%s - %s %s has logged-in.", Clan(clanid, Name), (Player(int, ClanLeader)) ? ("Leader") : ("Member"), playerName(int)));
				}
				
				new vip_time = Player(int, VIP_Time);

				if (gettime() < vip_time)
				{
				    new days, vip;

				    vip = Player(int, VIP);
				    days = ConvertTime(vip_time, DAYS);
				    SendClientMessage(int, c_green, sprintf("- You have been logged-in as VIP %s (%i), expires in %i days.", g_VIPName[vip], vip, days));
				}
				else
				{
				    SendClientMessage(int, c_green, "- You have been successfully logged-in, welcome back!");
				    
				    if (Player(int, VIP))
					{
						Player(int, VIP_Time) = 0;
						Player(int, VIP) = 0;
						Query("UPDATE `users` SET `vip`='0',`vip_time`='0' WHERE `id`='%i'", Player(int, UserID));
						mysql_tquery(connection, query, "ExecuteQuery", "i", res_none);

						SendClientMessage(int, c_tomato, "* Your VIP status has expired, thank you for purchasing.");
					}
				}
			}
		}
		case res_register_user:
		{
            Player(int, UserID) = cache_insert_id();
			RewardPlayer(int, 25000, 10);
			UpdateRank(int);

			SendClientMessage(int, c_green, "- Thank you for registering, you received +10 score and $25000.");
			SendClientMessage(int, c_green, sprintf("User: %s, Account ID: %i, Registered on: %s", playerName(int), Player(int, UserID), return_Stamp()));
			format(Player(int, RegDate), 24, "%s", return_Stamp());

			g_RegisteringPassword[int][0] = '\0';
            Var(int, HitSound) = true;
		}
		case res_check_ban:
		{
      		new query[200];

		    if (rows)
			{
			    new time, db_id, ip[16], name[24];

				time = cache_get_field_content_int(0, "time");
				db_id = cache_get_field_content_int(0, "id");
			  	cache_get_field_content(0, "ip", ip);
				cache_get_field_content(0, "nick", name);
				
				if (time != 0 && gettime() >= time)
				{
				    Query("DELETE FROM `bans` WHERE `id`='%i'", db_id);
					mysql_tquery(connection, query, "ExecuteQuery", "i", res_none);
				}
				else if (strcmp(name, playerName(int), true) == 0 || strcmp(ip, Player(int, Ip)) == 0 || time > gettime())
				{
                    SendClientMessage(int, c_red, "This user's account is currently banned from this server.");
                    SendClientMessage(int, c_red, "Note: Do NOT attempt to reconnect as this is considered join flooding which may lead you to a permanent ban.");
					return KickEx(int, c_red, "If you think this ban was invalid, post an appeal on our forum at www.teamdss.com/forum");
				}
			}
			Query("SELECT `pass`,`id` FROM `users` WHERE `nick`='%e' LIMIT 1", playerName(int));
			mysql_tquery(connection, query, "ExecuteQuery", "ii", res_check_useracc, int);
		}
		case res_fetch_level:
		{
		    if (!rows)
		        return IRC_Echo(str, ""#IRC_PREFIX_ERROR"Account with this username does not exist.");
				
			new lvl, name[24];

			lvl = cache_get_field_content_int(0, "level");
			cache_get_field_content(0, "nick", name);
			IRC_Echo(str, sprintf("%sUser %s's current level is %i.", IRC_PREFIX_RESULT, name, lvl));
		}
		case res_fetch_vip:
		{
		    if (!rows)
		        return IRC_Echo(str, ""#IRC_PREFIX_ERROR"Account with this username does not exist.");
	
			new vip, name[24];

			vip = cache_get_field_content_int(0, "vip");
			cache_get_field_content(0, "nick", name);
			IRC_Echo(str, sprintf("%sUser %s's current VIP level is %i (%s).", IRC_PREFIX_RESULT, name, vip, g_VIPName[vip]));
		}
		case res_fetch_cr:
		{
		    if (!rows)
		        return IRC_Echo(str, ""#IRC_PREFIX_ERROR"Account with this username does not exist.");

			new credits, name[24];

			credits = cache_get_field_content_int(0, "credits");
			cache_get_field_content(0, "nick", name);
			IRC_Echo(str, sprintf("%sUser %s's current VIP credits: %i.", IRC_PREFIX_RESULT, name, credits));
		}
		case res_set_level:
		{
		    if (!rows)
				return IRC_Echo(str, ""#IRC_PREFIX_ERROR"Account with this username does not exist.");
		
			new lvl = cache_get_field_content_int(0, "level");
			
			if (int == lvl)
				return IRC_Echo(str, ""#IRC_PREFIX_ERROR"Specified user's level has not been changed.");
	
		    new name[24], id, query[128];

			cache_get_field_content(0, "nick", name);
			id = cache_get_field_content_int(0, "id");

			Query("UPDATE `users` SET `level`='%i' WHERE `id`='%i'", int, id);
		    mysql_tquery(connection, query, "ExecuteQuery", "i", res_none);
			IRC_Echo(str, sprintf("%sUser %s's admin level has been set to %i. (Offline)", IRC_PREFIX_SUCCESS, name, int));
		}
        case res_search_ban:
		{
		    if (!rows)
		        return IRC_Echo(str, ""#IRC_PREFIX_ERROR"No bans found under this username/IP.");
		
			new string[256], reason[64], by[24], date[20], nick[24], ip[16], type[16];

			cache_get_field_content(0, "nick", nick);
			cache_get_field_content(0, "ip", ip);
			cache_get_field_content(0, "bannedby", by);
			cache_get_field_content(0, "date", date);
		    cache_get_field_content(0, "reason", reason);
		    cache_get_field_content(0, "type", type);

			strcat(string, "%sUsername: %s,");
			strcat(string, " IP: %s, Banned by: %s,");
			strcat(string, " Type: %s, Banned on: %s, Reason: %s");
			Format:string(string, IRC_PREFIX_RESULT, nick, ip, by, type, date, reason);
			IRC_Echo(str, string);
		}
		case res_insert_sv:
		{
			Vehicle(int, dbID) = cache_insert_id();
		}
		case res_load_sv:
		{
		    if (rows)
			{
		        new
							vehicleid,
							vid,
							model,
							type,
							loaded = 0,
					Float:	x,
					Float:	y,
					Float:	z,
					Float:	a;

				for (new i, j = rows; i < j; ++i)
				{
		            vid = cache_get_field_content_int(i, "id");
			        model = cache_get_field_content_int(i, "model");
			        type = cache_get_field_content_int(i, "type");
			        x = cache_get_field_content_float(i, "x");
			        y =cache_get_field_content_float(i, "y");
	          		z = cache_get_field_content_float(i, "z");
	          		a = cache_get_field_content_float(i, "a");
					vehicleid = AddServerVehicle(model, type, x, y, z, a, random(128), random(128), 120);
					Vehicle(vehicleid, dbID) = vid;
		   			++loaded;
				}
		        printf("----> Loadad %i server vehicles", loaded);
			}
		}
		case res_load_zones:
		{
		    if (rows)
			{
		        new zoneid;

				for (new i, j = rows; i < j; i++)
				{
		            zoneid = cache_get_field_content_int(i, "zone_id");
					Zone(zoneid, Score) = cache_get_field_content_int(i, "zone_score");
		            cache_get_field_content(i, "zone_name", Zone(zoneid, Name), connection, 50);
	             	Zone(zoneid, PointX) = cache_get_field_content_float(i, "cap_x");
	             	Zone(zoneid, PointY) = cache_get_field_content_float(i, "cap_y");
	             	Zone(zoneid, PointZ) = cache_get_field_content_float(i, "cap_z");
	             	Zone(zoneid, ZoneMinX) = cache_get_field_content_float(i, "zone_minx");
	             	Zone(zoneid, ZoneMinY) = cache_get_field_content_float(i, "zone_miny");
	             	Zone(zoneid, ZoneMaxX) = cache_get_field_content_float(i, "zone_maxx");
	             	Zone(zoneid, ZoneMaxY) = cache_get_field_content_float(i, "zone_maxy");
	             	Zone(zoneid, SpawnX) = cache_get_field_content_float(i, "spawn_x");
	             	Zone(zoneid, SpawnY) = cache_get_field_content_float(i, "spawn_y");
	             	Zone(zoneid, SpawnZ) = cache_get_field_content_float(i, "spawn_z");
	             	Zone(zoneid, SpawnA) = cache_get_field_content_float(i, "spawn_angle");
	             	Zone(zoneid, TotalCapTime) = cache_get_field_content_float(i, "zone_time");
					Flag(zoneid, FlagX) = cache_get_field_content_float(i, "flag_x");
					Flag(zoneid, FlagY) = cache_get_field_content_float(i, "flag_y");
					Flag(zoneid, FlagZ) = cache_get_field_content_float(i, "flag_z");

					if (zoneid != 0)
					{
						zone_Create(zoneid, Zone(zoneid, Name),
											Zone(zoneid, PointX),
											Zone(zoneid, PointY),
											Zone(zoneid, PointZ),
											Zone(zoneid, ZoneMinX),
											Zone(zoneid, ZoneMinY),
											Zone(zoneid, ZoneMaxX),
											Zone(zoneid, ZoneMaxY),
											Flag(zoneid, FlagX),
											Flag(zoneid, FlagY),
											Flag(zoneid, FlagZ));
						++Server(Zones);
		        	}
				}
		        printf("----> Loadad %i capturable zones", Server(Zones));
		    }
		}
		case res_load_teams:
		{
		    if (rows)
			{
				Server(Background) = TextDrawCreate(320.0, 2.0, "~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~");
				TextDrawAlignment(Server(Background), 2);
				TextDrawBackgroundColor(Server(Background), 68);
				TextDrawLetterSize(Server(Background), 0.73, 2.2);
				TextDrawSetOutline(Server(Background), 1);
				TextDrawUseBox(Server(Background), 1);
				TextDrawBoxColor(Server(Background), 0x47542CFF);
				TextDrawTextSize(Server(Background), 0.0, 640.0);

		        new teamid, loaded = 0;

				for (new i, j = rows; i < j; i++)
				{
		            teamid = cache_get_field_content_int(i, "team_id");
					cache_get_field_content(i, "team_name", Team(teamid, Name), connection, 50);
				 	Team(teamid, Skin) = cache_get_field_content_int(i, "team_skin");
			     	Team(teamid, Color) = cache_get_field_content_int(i, "team_color");
			     	Team(teamid, base_MinX) = cache_get_field_content_float(i, "base_MinX");
			     	Team(teamid, base_MinY) = cache_get_field_content_float(i, "base_MinY");
			     	Team(teamid, base_MaxX) = cache_get_field_content_float(i, "base_MaxX");
			     	Team(teamid, base_MaxY) = cache_get_field_content_float(i, "base_MaxY");
					Team(teamid, FlagX) = cache_get_field_content_float(i, "flag_X");
     				Team(teamid, FlagY) = cache_get_field_content_float(i, "flag_Y");
         			Team(teamid, FlagZ) = cache_get_field_content_float(i, "flag_Z");

					if (teamid != 0)
					{
						team_Add(teamid);
						++loaded;
					}
				}
				printf("----> Loadad %i teams", loaded);
			}
			team_CreateBaseSAM(EUROPE, -156.3053,1081.2070,23.7323);
			team_CreateBaseSAM(ARABIA, -826.4974,1511.8972,24.0161);
			team_CreateBaseSAM(RUSSIA, -310.6331,2667.4221,66.3362);
			team_CreateBaseSAM(AMERICA, -1447.7589,2631.3008,59.7117);
			team_CreateBaseSAM(ASIA, 1503.5951,763.3275,23.4341);
			team_CreateBaseSAM(AUSTRALIA, 1086.3160,2412.8542,14.9337);
			load_Shops();
		}
		case res_load_classes:
		{
		    if (rows)
			{
		        new classid, weapons[20], ammo[25], loaded = 0;

				for (new i, j = rows; i < j; i++)
				{
		            classid = cache_get_field_content_int(i, "classid");
		            cache_get_field_content(i, "c_name", Class(classid, Name), connection, 30);
		            cache_get_field_content(i, "c_weapons", weapons);
		            cache_get_field_content(i, "c_ammo", ammo);
		            cache_get_field_content(i, "c_desc", Class(classid, Desc), connection, 200);
		            cache_get_field_content(i, "c_ability", Class(classid, Ability), connection, 128);
					Class(classid, RequiredRank) = cache_get_field_content_int(i, "c_requiredrank");
		            sscanf(weapons, "p<:>a<i>[20]", Class(classid, Weapons));
		            sscanf(ammo, "p<:>a<i>[25]", Class(classid, WeaponAmmo));
		            Iter_Add(Classes, classid);

					if (classid != 0)
						++loaded;
				}
				printf("----> Loadad %i classes", loaded);
			}
			return 1;
		}
		case res_load_bridges:
		{
		    if (rows)
			{
		        new
							bridgeid,
							loaded = 0,
							groupid,
							objectid,
		        	Float:	fx,
					Float:	fy,
					Float:	fz,
					Float:	frx,
					Float:	fry,
					Float:	frz,
					Float:	dx,
					Float:	dy,
					Float:	dz,
					Float:	drx,
					Float:	dry,
					Float:	drz;

				for (new i, j = rows; i < j; i++)
				{
		            bridgeid = cache_get_field_content_int(i, "bridge_id");
		            objectid = cache_get_field_content_int(i, "object_id");
		            fx = cache_get_field_content_float(i, "fixed_x");
		            fy = cache_get_field_content_float(i, "fixed_y");
		            fz = cache_get_field_content_float(i, "fixed_z");
		            frx = cache_get_field_content_float(i, "fixed_rx");
		           	fry = cache_get_field_content_float(i, "fixed_ry");
		            frz = cache_get_field_content_float(i, "fixed_rz");
		            dx = cache_get_field_content_float(i, "damaged_x");
		            dy = cache_get_field_content_float(i, "damaged_y");
		           	dz = cache_get_field_content_float(i, "damaged_z");
		            drx = cache_get_field_content_float(i, "damaged_rx");
		           	dry = cache_get_field_content_float(i, "damaged_ry");
		            drz = cache_get_field_content_float(i, "damaged_rz");
		            groupid = cache_get_field_content_int(i, "group_id");

					if (bridgeid != -1)
					{
						bridge_Create(bridgeid, objectid, fx, fy, fz, frx, fry, frz, dx, dy, dz, drx, dry, drz, groupid);
						++loaded;
					}
				}
				printf("----> Loadad %i bridges", loaded);
			}
		}
		case res_load_shops:
		{
		    if (rows)
			{
		        new
							shopid,
							teamid,
					Float:	x,
					Float:	y,
					Float:	z,
							loaded = 0;

				for (new i, j = rows; i < j; i++)
				{
    				shopid = cache_get_field_content_int(i, "shopid");
		            teamid = cache_get_field_content_int(i, "teamid");
            		x = cache_get_field_content_float(i, "shop_x");
		            y = cache_get_field_content_float(i, "shop_y");
		            z = cache_get_field_content_float(i, "shop_z");
		            shop_Create(shopid, x, y, z, teamid);
					++loaded;
				}
				printf("----> Loadad %i shops", loaded);
			}
		}
		case res_load_spawns:
		{
		    if (rows)
			{
		        new spawnid;

				for (new i, j = rows; i < j; i++)
				{
    				spawnid = cache_get_field_content_int(i, "spawnid", spawnid);
					Spawn(spawnid, TeamID) = cache_get_field_content_int(i, "teamid");
			     	Spawn(spawnid, DM) = cache_get_field_content_int(i, "dmid");
			     	Spawn(spawnid, X) = cache_get_field_content_float(i, "spawn_x");
			     	Spawn(spawnid, Y) = cache_get_field_content_float(i, "spawn_y");
			     	Spawn(spawnid, Z) = cache_get_field_content_float(i, "spawn_z");
			     	Spawn(spawnid, A) = cache_get_field_content_float(i, "spawn_a");
					++Server(SpawnPoints);
				}
				printf("----> Loadad %i spawn points", Server(SpawnPoints) - 1);
			}
		}
		case res_load_clans:
		{
		    if (rows)
			{
		        new clanid, loaded = 0;

				for (new i, j = rows; i < j; i++)
				{
		            clanid = cache_get_field_content_int(i, "clan_id", clanid);
					cache_get_field_content(i, "clan_name", Clan(clanid, Name), connection, 36);
		            cache_get_field_content(i, "clan_tag", Clan(clanid, Tag), connection, 10);
		            cache_get_field_content(i, "clan_founder", Clan(clanid, Founder), connection, 24);
		            cache_get_field_content(i, "clan_registered", Clan(clanid, Registered), connection, 24);
		            cache_get_field_content(i, "motto", Clan(clanid, Motto), connection, 100);
					Clan(clanid, Points) = cache_get_field_content_int(i, "clan_points");
					Clan(clanid, CW_Win) = cache_get_field_content_int(i, "cw_won");
					Clan(clanid, CW_Lost) = cache_get_field_content_int(i, "cw_lost");
					Clan(clanid, Skin) = cache_get_field_content_int(i, "clan_skin");
					Clan(clanid, MemberCount) = cache_get_field_content_int(i, "clan_members");
		            ++loaded;
		            Iter_Add(Clans, clanid);
		            Clan(clanid, Exist) = true;
				}
				printf("----> Loadad %i clans", loaded);
			}
		}
	}
	return 1;
}

function result_CheckBan(admin, user[])
{
	new rows = cache_num_rows();

	if (!rows)
	    return SendClientMessage(admin, c_red, "* No ban results found for the specified username/ip.");

	new count, string[1000], tmp_user[24], tmp_ip[16], tmp_bannedby[24], tmp_reason[MAX_REASON], tmp_date[20], tmp_type[20];

	for (new i, j = rows; i < j; i++)
	{
		cache_get_field_content(i, "nick", tmp_user);
		cache_get_field_content(i, "ip", tmp_ip);
		cache_get_field_content(i, "bannedby", tmp_bannedby);
		cache_get_field_content(i, "reason", tmp_reason);
		cache_get_field_content(i, "date", tmp_date);
		cache_get_field_content(i, "type", tmp_type);
		Format:string("%s%i: %s (%s)\t%s\t%s\t%s (%s)\n", string, (i+1), tmp_user, tmp_ip, tmp_bannedby, tmp_reason, tmp_date, tmp_type);
		++count;
	}

	Format:string("#   User (IP)\tBanned by\tReason\tDate (type)\n%s", string);
	ShowPlayerDialog(admin, D_MSG, DIALOG_STYLE_TABLIST_HEADERS, sprintf(""#sc_lightgrey"Most relevant ban results: \"%s\"   (%i/5)", user, count), string, "Close", "");

	return 1;
}

load_Teams()
{
	new query[26];

	Query("SELECT * FROM `teams`");
	mysql_tquery(connection, query, "ExecuteQuery", "i", res_load_teams);
}

load_Classes()
{
	new query[26];

	Query("SELECT * FROM `classes`");
	mysql_tquery(connection, query, "ExecuteQuery", "i", res_load_classes);
}

load_Bridges()
{
	new Float:x, Float:y, Float:z, query[26];

 	for (new i, j = sizeof(g_Bridge); i < j; i++)
 	{
	    x = Bridge(i, PointX);
		y = Bridge(i, PointY);
		z = Bridge(i, PointZ);

        CreateDynamic3DTextLabel("Type "#sc_grey"'/plant' "#sc_lightgrey"to plant\nbombs here", c_lightgrey, x, y, z, 30.0);
        CreateDynamicMapIcon(x, y, z, 23, 0);
	}
	
    Query("SELECT * FROM `bridges`");
	mysql_tquery(connection, query, "ExecuteQuery", "i", res_load_bridges);
}

load_Vehicles()
{
	new query[35];

    Query("SELECT * FROM `server_vehicles`");
	mysql_tquery(connection, query, "ExecuteQuery", "i", res_load_sv);
}

load_Zones()
{
    new query[26];

    Query("SELECT * FROM `zones`");
	mysql_tquery(connection, query, "ExecuteQuery", "i", res_load_zones);
}

load_Spawns()
{
    new query[30];

    Query("SELECT * FROM `spawn_points`");
	mysql_tquery(connection, query, "ExecuteQuery", "i", res_load_spawns);
}

load_Shops()
{
    new query[26];

    Query("SELECT * FROM `shops`");
	mysql_tquery(connection, query, "ExecuteQuery", "i", res_load_shops);
}

load_Clans()
{
    new query[26];

    Query("SELECT * FROM `clans`");
	mysql_tquery(connection, query, "ExecuteQuery", "i", res_load_clans);
}
