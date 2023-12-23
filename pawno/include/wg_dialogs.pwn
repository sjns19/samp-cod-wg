#define shoplist    ""#sc_white"Item\t"#sc_white"Price\n \
					"#sc_green"Full Armour\t"#sc_lightgrey"$5000\n \
					"#sc_green"Heal\t"#sc_lightgrey"$4500\n \
					"#sc_green"Helmet\t"#sc_lightgrey"$3500\n \
					"#sc_green"Anti-Teargas Mask\t"#sc_lightgrey"$3000\n \
					"#sc_green"Weapons List\n \
					"#sc_green"Inventory Items\n \
					"#sc_green"Deathmatch Stadium"

enum
{
	D_REGISTER1,
	D_REGISTER2,
	D_LOGIN,
	D_SHOP,
	D_CLASS,
	D_WEAPONS,
	D_AMMO,
	D_MSG,
	D_SPAWNPOINT,
	D_SETTINGS,
	D_CHANGEPASS_1,
	D_CHANGEPASS_2,
	D_BASESAM,
	D_CLASSINFO,
	D_DMLIST,
	D_NUKEMAIN,
	D_NUKEZONES,
	D_NUKEBASES,
	D_ABANDONEDAIRPORT,
	D_WIPENUKE,
	D_VIPFEAT,
	D_DONATE,
	D_INVENTORY,
	D_SAM_MAIN,
	D_SAM_ZONES,
	D_SAM_BASES,
	D_CLANS,
	D_CLAN_SETTINGS,
	D_CWCMDS,
	D_CLAN_RANKSLOT,
	D_CLAN_MOTTO,
	D_CLAN_MEMBERS,
	D_CLAN_INFO,
	D_CLAN_NAME,
	D_CLAN_TAG,
	D_CLAN_FOUNDER,
	D_CMD_TITLE,
	D_CLAN_SKIN,
	D_CLAN_SKIN_CONFIRM,
	D_CMD,
	D_RADIO_MAIN,
	D_RADIO_HACK_TEAM,
	D_RADIO_BREAK_TEAM,
	D_RADIO_HACK_CONFIRM,
	D_RADIO_BREAK_CONFIRM,
	D_GZ_MAIN,
	D_GZ_MOAB
}

ShowDialog(playerid, dialogid)
{
	switch (dialogid)
	{
	    case D_REGISTER1: ShowPlayerDialog(playerid, D_REGISTER1, DIALOG_STYLE_PASSWORD, "Account registration", sprintf(""#sc_lightgrey"Hello, "#sc_orange"%s\n\n"#sc_lightgrey"This account is not registered. Type your password below to register.", playerName(playerid)), "Next", "Back");
	    case D_REGISTER2: ShowPlayerDialog(playerid, D_REGISTER2, DIALOG_STYLE_PASSWORD, "Account registration", sprintf(""#sc_lightgrey"Hello, "#sc_orange"%s\n\n"#sc_lightgrey"This account is not registered. Type your password below to register.", playerName(playerid)), "Done", "Back");
	    case D_LOGIN: ShowPlayerDialog(playerid, D_LOGIN, DIALOG_STYLE_PASSWORD, "Account login", sprintf(""#sc_lightgrey"Welcome back, "#sc_orange"%s\n\n"#sc_lightgrey"This account is registered. Login by entering your password below.", playerName(playerid)), "Login", "Quit");
		case D_CHANGEPASS_1: ShowPlayerDialog(playerid, D_CHANGEPASS_1, DIALOG_STYLE_INPUT, "Password", ""#sc_white"Please type your old password below.", "Next", "Cancel");
		case D_CHANGEPASS_2: ShowPlayerDialog(playerid, D_CHANGEPASS_2, DIALOG_STYLE_INPUT, "Password", ""#sc_white"Please enter your new password to change.", "Done", "Back");
		case D_CLASS:
		{
            new text[250], rank;
            
		    foreach(new i : Classes)
			{
		        if (i)
				{
				    rank = Class(i, RequiredRank);
				    
		            if (Player(playerid, Team) != TERRORIST)
					{
		                switch (i)
						{
		                    case SOLDIER .. VIPCLASS:
							{
								Format:	text("%s%s\t%s%s\n",
										text,
										Class(i, Name),
										(i == VIPCLASS) ? (sc_lightyellow) : (Player(playerid, Rank) >= rank || Player(playerid, VIP)) ? (sc_green) : (sc_red),
										(i == VIPCLASS) ? ("VIP Silver+") : (sprintf("%i (%s)",
										rank,
										Rank(rank, Name))));
							}
						}
					}
					else
					{
					    switch (i)
						{
							case ASSAULT .. SUICIDE_BOMBER:
							{
								Format:	text("%s%s\t%s%i (%s)\n",
										text,
										Class(i, Name),
										(Player(playerid, Rank) >= rank) ? (sc_green) : (sc_red),
										rank,
										Rank(rank, Name));
							}
						}
					}

				}
			}
			Format:text(""#sc_white"Class\t"#sc_lightgrey"Required Rank\n%s", text);
		 	ShowPlayerDialog(playerid, D_CLASS, DIALOG_STYLE_TABLIST_HEADERS, "Select your class", text, "Select", "Back");
		}
        case D_SHOP: ShowPlayerDialog(playerid, D_SHOP, DIALOG_STYLE_TABLIST_HEADERS, "Shop", shoplist, "Select", "Close");
        case D_INVENTORY: ShowPlayerDialog(playerid, D_INVENTORY, DIALOG_STYLE_TABLIST_HEADERS, "Inventory Items", ""#sc_white"Item\t"#sc_white"Price\n"#sc_green"Medikits\t"#sc_lightgrey"$5000\n"#sc_green"Ammo Pack\t"#sc_lightgrey"$2000\n"#sc_green"Bombs\t"#sc_lightgrey"$10000\n"#sc_green"Disguise Kit\t"#sc_lightgrey"$5000", "Select", "Back");
        case D_DMLIST: ShowPlayerDialog(playerid, D_DMLIST, DIALOG_STYLE_LIST, "Select a deathmatch stadium", ""#sc_green"Normal\n"#sc_green"C-Bug\n"#sc_green"Sniper", "Select", "Back");
        case D_WEAPONS: ShowPlayerDialog(playerid, D_WEAPONS, DIALOG_STYLE_TABLIST_HEADERS, "Weapons", BuyableWeaponsList(), "Select", "Back");
		case D_SPAWNPOINT:
		{
            new text[400];

			foreach(new i : Zones)
			{
			    if (Zone(i, SpawnX) != 0.0 || Zone(i, SpawnY) != 0.0 || Zone(i, SpawnZ) != 0.0 || Zone(i, SpawnA) != 0.0)
				{
				    Format:text("%s%s%s\n", text, (Player(playerid, Team) == Zone(i, Team)) ? (sc_green) : (sc_red), Zone(i, Name));
				}
			}
			Format:text("Base\n%s", text);
			ShowPlayerDialog(playerid, D_SPAWNPOINT, DIALOG_STYLE_LIST, "Select a spawn point", text, "Select", "Back");
        }
        case D_SETTINGS:
		{
		    new text[200];

			Format:text("Toggle\tStatus\n"#sc_white"Helmet\t%s\n"#sc_white"Mask\t%s\n"#sc_white"Hit sound\t%s\n"#sc_white"DND\t%s",
	    		(Var(playerid, Helmet)) ? 	(""#sc_green"ON") : (""#sc_red"OFF"),
				(Var(playerid, Mask)) ? (""#sc_green"ON") : (""#sc_red"OFF"),
				(Var(playerid, HitSound)) ? (""#sc_green"ON") : (""#sc_red"OFF"),
				(Var(playerid, DND)) ? (""#sc_green"ON") : (""#sc_red"OFF"));
			ShowPlayerDialog(playerid, D_SETTINGS, DIALOG_STYLE_TABLIST_HEADERS, "Settings", text, "Select", "Close");
		}
		case D_NUKEMAIN: ShowPlayerDialog(playerid, D_NUKEMAIN, DIALOG_STYLE_LIST, "Nuclear: Select target", "Zones\nBases", "Select", "Cancel");
        case D_NUKEZONES: ShowPlayerDialog(playerid, D_NUKEZONES, DIALOG_STYLE_LIST, "Select a zone", "Abandoned Airport\nLas Venturas Airport\nRadio Station\nGround Zero\nHunter Quary", "Select", "Back");
        case D_NUKEBASES: ShowPlayerDialog(playerid, D_NUKEBASES, DIALOG_STYLE_LIST, "Select a base", team_ReturnBaseList(), "Select", "Back");
        case D_BASESAM: ShowPlayerDialog(playerid, D_BASESAM, DIALOG_STYLE_MSGBOX, "Base SAM", ""#sc_white"The base SAN will destroy all enemy aircrafts flying above this base.\n"#sc_white"Are you sure you want to launch?\n\n"#sc_white"Cost: $20000", "Launch", "Close");
        case D_SAM_MAIN: ShowPlayerDialog(playerid, D_SAM_MAIN, DIALOG_STYLE_LIST, "SAM - Target area", "Area 51\nOther zones\nBases", "Select", "Close");
        case D_SAM_ZONES: ShowPlayerDialog(playerid, D_SAM_ZONES, DIALOG_STYLE_LIST, "Select a zone", "Abandoned Airport\nLas Venturas Airport\nGround Zero\nRadio Station\nHunter Quary\nItalian Villa\nTierra Robada Bridge\nGreenglass College\nOil Refinery\nEasterboard Lumbermill", "Select", "Back");
        case D_SAM_BASES: ShowPlayerDialog(playerid, D_SAM_BASES, DIALOG_STYLE_LIST, "Select a base", team_ReturnBaseList(), "Select", "Back");
        case D_ABANDONEDAIRPORT: ShowPlayerDialog(playerid, D_ABANDONEDAIRPORT, DIALOG_STYLE_TABLIST_HEADERS, "Abandoned Airport", "_\t_\nWipe nuclear effect:\t$20000", "Select", "Close");
        case D_WIPENUKE: ShowPlayerDialog(playerid, D_WIPENUKE, DIALOG_STYLE_MSGBOX, "Wipe nuclear effect", sprintf(""#sc_white"Are you sure you want to wipe the nuclear effect at '%s' for $20000?", nuke_ReturnAffectedAreaName()), "Yes", "No");
		case D_CLANS:
		{
		    new text[3000];
			foreach(new i : Clans)
			{
			    Format:text("%s%i\t%s\t%s\t%i\n", text, i, Clan(i, Name), Clan(i, Tag), Clan(i, Points));
			}
			Format:text("ID\tsName\tTag\tPoints\n%s", text);
			ShowPlayerDialog(playerid, D_CLANS, DIALOG_STYLE_TABLIST_HEADERS, "Clans", text, "Select", "Close");
		}
		case D_CLAN_RANKSLOT: ShowPlayerDialog(playerid, D_CLAN_RANKSLOT, DIALOG_STYLE_INPUT, "Clan Rank", ""#sc_white"Enter the max ranks slot\nMin: 10, Max: 15", "Set", "Close");
		case D_CLAN_SKIN: ShowPlayerDialog(playerid, D_CLAN_SKIN, DIALOG_STYLE_INPUT, "Clan Skin", ""#sc_white"Enter the ID of the skin you want to set.\n\nNote: Changing the clan's skin costs 100 clan points.", "Select", "Back");
		case D_CLAN_SKIN_CONFIRM: ShowPlayerDialog(playerid, D_CLAN_SKIN_CONFIRM, DIALOG_STYLE_MSGBOX, "Clan Skin", sprintf(""#sc_white"Are you sure you want to change the clan's skin to skin ID %i for 100 clan points?", Var(playerid, TempClanSkin)), "Yes", "No");
		case D_CLAN_NAME: ShowPlayerDialog(playerid, D_CLAN_NAME, DIALOG_STYLE_INPUT, "Clan registration - Step: 1/3", ""#sc_white"Enter the clan name:", "Next", "Close");
		case D_CLAN_TAG: ShowPlayerDialog(playerid, D_CLAN_TAG, DIALOG_STYLE_INPUT, "Clan registration - Step: 2/3", ""#sc_white"Enter the clan tag, must be wrapped with [ ]", "Next", "Back");
		case D_CLAN_SETTINGS: ShowPlayerDialog(playerid, D_CLAN_SETTINGS, DIALOG_STYLE_LIST, "Clan Settings", "View members\nChange clan skin\nSet motto\nClan war commands", "Select", "Close");
		case D_CLAN_MOTTO: ShowPlayerDialog(playerid, D_CLAN_MOTTO, DIALOG_STYLE_INPUT, "Clan motto", ""#sc_white"Write a motto for this clan", "Done", "Back");
		case D_CLAN_FOUNDER: ShowPlayerDialog(playerid, D_CLAN_FOUNDER, DIALOG_STYLE_INPUT, "Clan registraton - Step: 3/3", ""#sc_white"Who is the founder of this clan? Enter their name:", "Create", "Back");
		case D_RADIO_MAIN: ShowPlayerDialog(playerid, D_RADIO_MAIN, DIALOG_STYLE_TABLIST_HEADERS, "Radio Station", "-\tPrice\nHack radio\t$10000\nDamage radio\t$20000", "Select", "Close");
		case D_RADIO_HACK_TEAM: ShowPlayerDialog(playerid, D_RADIO_HACK_TEAM, DIALOG_STYLE_LIST, "Select a team to hack the radio of", team_ReturnList(), "Select", "Back");
		case D_RADIO_BREAK_TEAM: ShowPlayerDialog(playerid, D_RADIO_BREAK_TEAM, DIALOG_STYLE_LIST, "Select a team to damage the radio of", team_ReturnList(), "Select", "Back");
		case D_GZ_MAIN: ShowPlayerDialog(playerid, D_GZ_MAIN, DIALOG_STYLE_TABLIST_HEADERS, "Ground Zero Weapons", "Weapon\tCost\nLaunch MOAB\t$500000", "Select", "Close");
		case D_DONATE:
		{
		    new d_text[1000];
			strcat(d_text, ""#sc_green"Thank you for playing on our server!\n");
			strcat(d_text, "\n");
			strcat(d_text, "You can help support the server by keeping it alive and running\n");
			strcat(d_text, "for a long time by donating small amount of money.\n");
		    strcat(d_text, "\n");
			strcat(d_text, "Players are the heart of the server, without your help,\n");
			strcat(d_text, "the server may not run for that long since the host\n");
			strcat(d_text, "needs to be renewed each month.\n");
			strcat(d_text, "In exchange, we provide you with VIP levels. Each has\n");
			strcat(d_text, "lots of features included.\n");
			strcat(d_text, "\n");
			strcat(d_text, "To donate, visit our website at www.teamdss.com. Login to\n");
			strcat(d_text, "the control panel, can be acccessed from the drop-down\n");
			strcat(d_text, "menu of COD-WG tab. Once logged-in, click the VIP Area\n");
			strcat(d_text, "then buy VIP credits. The credits can be used to active\n");
			strcat(d_text, "the VIP level along with side perks such as; helmet, mask\n");
			strcat(d_text, "VIP boost and many more! You can find all these features\n");
			strcat(d_text, "In the VIP Area tab in the control panel.\n");
			strcat(d_text, "\n");
			strcat(d_text, "For the detailed instruction on how to donate, visit our\n");
			strcat(d_text, "forum.\n");
			strcat(d_text, "\n");
			strcat(d_text, "Thank you for taking your time reading this!\n");
			strcat(d_text, "* Click on 'VIP Features' below to see the list of VIP features.");
		    ShowPlayerDialog(playerid, D_DONATE, DIALOG_STYLE_MSGBOX, "Donation", d_text, "Features", "Close");
		}
		case D_VIPFEAT:
		{
		    new text[1500];
		    strcat(text, ""#sc_green"VIP Bronze - €10\n");
			strcat(text, "- Can use VIP chat\n");
			strcat(text, "- Capture speed 1.5x faster\n");
			strcat(text, "- Can add nitro to vehicles - /vnos\n");
			strcat(text, "- Can change vehicle color - /vvc\n");
			strcat(text, "- Gets a VIP tag before their name in the chat\n");
			strcat(text, "- Immune from high ping kicker and nuclear effect\n");
			strcat(text, "- Can change own game time - /vtime\n");
			strcat(text, "- Can change own game weather - /vweather\n");
			strcat(text, "- Can use VIP weapon packs - /vweaps\n");
			strcat(text, "- Can spawn a bike (Freeway)\n");
			strcat(text, "- Can heal teammates - /h\n");
			strcat(text, "- Can change skin\n");
			strcat(text, "\n");

			strcat(text, "VIP Silver - €20\n");
			strcat(text, "- All classes unlocked, no ranks needed\n");
			strcat(text, "- Capture speed 2x faster\n");
			strcat(text, "- Can spawn a bike (Sanchez)\n");
			strcat(text, "- Can spawnn a tuned car (Sultan)\n");
			strcat(text, "- Can use VIP class\n");
			strcat(text, "- Spawns with 70 percent armour\n");
			strcat(text, "- Can boost teammates with 1 RPG and 100 armour/health - /vbt\n");
			strcat(text, "- Can set fire on eveny player's vehicle - /vfr (VIP class only)\n");
			strcat(text, "- Spawns with 1 RPG and 2 gernade\n");
			strcat(text, "\n");

			strcat(text, "VIP Gold - €30\n");
			strcat(text, "- Capture speed 2.5x faster\n");
			strcat(text, "- Spawns with full armour\n");
			strcat(text, "- Can spawn a helicopter (Maverick)\n");
			strcat(text, "- Can spawn a plane (Stunt Plane)\n");
			strcat(text, "- Can spawn a tuned car (Flash)\n");
			strcat(text, "- Can spawn a bike (NRG-500)\n");
			strcat(text, "- Can spawn a boat (Squalo)\n");
			strcat(text, "- Can armour teammates in any class - /var\n");
			strcat(text, "- Can use /vbt and /vfr in any class\n");
			strcat(text, "- Spawns with 3 medikits\n");
			strcat(text, "- Spawns with 2 rpg and 4 gernade");

			ShowPlayerDialog(playerid, D_VIPFEAT, DIALOG_STYLE_MSGBOX, "VIP Features", text, "Back", "");
		}
	}
	return 1;
}

dialog_Register_1(playerid, response, inputtext[])
{
	if (!response)
		return KickEx(playerid, c_red, "* You have been disconnected.");

	if (strlen(inputtext) >= 6)
	{
		ShowDialog(playerid, D_REGISTER2);
		format(g_RegisteringPassword[playerid], 128, inputtext);
	}
	else
	{
		SendClientMessage(playerid, c_red, "* Your password must contain at least 6 characters.");
		ShowDialog(playerid, D_REGISTER1);
	}

	return 1;
}

dialog_Register_2(playerid, response, inputtext[])
{
	if (!response)
		return ShowDialog(playerid, D_REGISTER1);

	if (strlen(inputtext) > 0 || !strcmp(inputtext, g_RegisteringPassword[playerid], false))
	{
		WP_Hash(Player(playerid, Pass), 129, g_RegisteringPassword[playerid]);
		Var(playerid, LoggedIn) = true;

		new query[500];

		strcat(query, "INSERT INTO `users` (nick,pass,ip,new_ip,registered_date)");
		strcat(query, " VALUES('%e','%e','%e','%e',UTC_TIMESTAMP())");
		Query	(query,
				Player(playerid, Name),
				Player(playerid, Pass),
				Player(playerid, Ip),
				Player(playerid, Ip));
		mysql_tquery(connection, query, "ExecuteQuery", "ii", res_register_user, playerid);
		TogglePlayerSpectating(playerid, 0);
		GameTextForPlayer(playerid, ""#TXT_LINE"~g~~h~~h~registered", 3000, 3);

		for (new i = 0, j = 4; i != j; ++i)
		{
			PlayerTextDrawHide(playerid, TD(playerid, BG)[i]);
		}
	}
	else
	{
		SendClientMessage(playerid, c_red, "* Your password did not match.");
		ShowDialog(playerid, D_REGISTER2);
	}

	return 1;
}

dialog_Login(playerid, response, inputtext[])
{
	if (!response)
		return KickEx(playerid, c_red, "* You have been disconnected.");
	
	new h_Pass[129];
		
	WP_Hash(h_Pass, 129, inputtext);

	if (!strcmp(h_Pass, Player(playerid, Pass)))
	{
		new query[128];

		Var(playerid, LoggedIn) = true;

		Query("SELECT * FROM `users` WHERE `nick`='%e' LIMIT 1", playerName(playerid));
		mysql_tquery(connection, query, "ExecuteQuery", "ii", res_load_useracc, playerid);
		zone_ShowForPlayer(playerid);
		TogglePlayerSpectating(playerid, 0);
		GameTextForPlayer(playerid, ""#TXT_LINE"~g~~h~~h~logged-in", 3000, 3);

		for(new i = 0, j = 4; i != j; ++i)
		{
			PlayerTextDrawHide(playerid, TD(playerid, BG)[i]);
		}
	}
	else
	{
		if (++Player(playerid, LoginAttempts) >= 5)
		{
			SendClientMessageToAll(c_tomato, sprintf("* %s has been kicked for exceeding the maximum login attempts.", playerName(playerid)));
			IRC_Echo(g_IRC_Conn[IRC_MAIN_CHANNEL], sprintf("4* %s has been kicked for exceeding the maximum login attempts.", playerName(playerid)));
			KickEx(playerid, c_red, "You failed to login.");
		}
		else
		{
			SendClientMessage(playerid, c_red, "* You have enter an incorrect password, please try again.");
			ShowDialog(playerid, D_LOGIN);
		}
	}

	return 1;
}

dialog_ChangePass_1(playerid, response, inputtext[])
{
	if (Var(playerid, LoggedIn) && response)
	{
		new hpass[129];

		WP_Hash(hpass, 129, inputtext);
		
		if (!strcmp(hpass, Player(playerid, Pass), false))
		{
			ShowDialog(playerid, D_CHANGEPASS_2);
		}
		else
		{
			SendClientMessage(playerid, c_red, "* Your old password did not match."),
			ShowDialog(playerid, D_CHANGEPASS_1);
		}
	}

	return 1;
}

dialog_ChangePass_2(playerid, response, inputtext[])
{
	if (Var(playerid, LoggedIn) && response)
	{
		if (strlen(inputtext) > 6)
		{
			new hpass[129];

			WP_Hash(hpass, 129, inputtext);
			
			if (!strcmp(hpass, Player(playerid, Pass), false))
			{
				SendClientMessage(playerid, c_red, "* Your new password cannot be the same as your old one.");
				ShowDialog(playerid, D_CHANGEPASS_2);
			}
			else
			{
				new query[400];

				SendClientMessage(playerid, c_green, "- Account: Your password has been successfully changed.");
				WP_Hash(Player(playerid, Pass), 129, inputtext);
				
				Query("UPDATE `users` SET `pass`='%e' WHERE `id`='%i'", Player(playerid, Pass), Player(playerid, UserID));
				mysql_tquery(connection, query, "ExecuteQuery", "i", res_none);
			}
		}
		else
		{
			SendClientMessage(playerid, c_red, "* Your new password must contain at least 6 characters.");
			ShowDialog(playerid, D_CHANGEPASS_2);
		}
	}

	return 1;
}

dialog_Class(playerid, response, listitem)
{
	if (Var(playerid, LoggedIn))
	{
		if (response)
		{
			new class = (Player(playerid, Team) == TERRORIST) ? (listitem + 9) : (listitem + 1);

			if (Player(playerid, Rank) < Class(class, RequiredRank) && Player(playerid, VIP) < 2)
			{
				SendClientMessage(playerid, c_red, sprintf("* You must be rank %i+ or VIP Silver and above to select this class.", Class(class, RequiredRank)));
				return ShowDialog(playerid, D_CLASS);
			}
			
			if (listitem == 7 && Player(playerid, VIP) < 2)
			{
				SendClientMessage(playerid, c_red, "* You must be VIP Silver and above to select this class.");
				return ShowDialog(playerid, D_CLASS);
			}

			Player(playerid, Class) = class;

			RandomBaseSpawn(playerid, Player(playerid, Team), true);
			ShowClassInfo(playerid, class);
		}
		else
		{
			if (Var(playerid, PlayerStatus) == PLAYER_STATUS_SWITCHING_CLASS)
				return ShowDialog(playerid, D_CLASS);

		    if (Var(playerid, ViewingDialog))
		    {
		        Var(playerid, ViewingDialog) = false;
			}
		}
	}

	return 1;
}

dialog_ClassInfo(playerid, response)
{
	if (Var(playerid, LoggedIn))
	{
		if (response)
		{
			if (Var(playerid, FromCommand))
			{
				Var(playerid, FromCommand) = 0;
			}
			else
			{
				switch (Player(playerid, Team))
				{
					case TERRORIST:
					{
						if (Var(playerid, PlayerStatus) == PLAYER_STATUS_SWITCHING_CLASS)
						{
							Var(playerid, PlayerStatus) = PLAYER_STATUS_NONE;
						}
						SendClientMessage(playerid, c_orange, sprintf("You have chosen %s class, type '/chelp' to understand the basics of your class.", Class(Player(playerid, Class), Name)));
						TextDrawHideForPlayer(playerid, Server(Background));
						SpawnPlayer(playerid);
					}
					case MERCENARY:
					{
						RandomBaseSpawn(playerid, MERCENARY, true);

						Player(playerid, Class) = C_NAN;

						TextDrawHideForPlayer(playerid, Server(Background));
						SpawnPlayer(playerid);
					}
					default:
					{
						Var(playerid, Spawning) = 1;
						ShowDialog(playerid, D_SPAWNPOINT);
					}
				}
			}
		}
		else
		{
			if (Var(playerid, FromCommand))
			{
				Var(playerid, FromCommand) = 0;
			}
			else
			{
			    if (Player(playerid, Team) != MERCENARY)
			    {
					ShowDialog(playerid, D_CLASS);
				}
				else
				{
					if (Var(playerid, ViewingDialog))
					{
					    Var(playerid, ViewingDialog) = false;
					}
				}
			}
		}
	}

	return 1;
}

dialog_Shop(playerid, response, listitem)
{
	if (Var(playerid, LoggedIn) && response)
	{
		if (IsPlayerAtShop(playerid))
		{
			switch (listitem)
			{
				// Armour
				case 0:
				{
					if (Player(playerid, Money) >= 5000)
					{
						SetPlayerArmour(playerid, 100.0);
						SendClientMessage(playerid, c_lightyellow, "Bought full armour for $5000.");
						RewardPlayer(playerid, -5000, 0);

						ShowDialog(playerid, D_SHOP);
					}
					else
					{
						SendClientMessage(playerid, c_red, "* You do not have enough money to buy this item.");
						ShowDialog(playerid, D_SHOP);
					}
				}
				// Health
				case 1:
				{
					if (Player(playerid, Money) >= 4500)
					{
						SetPlayerHealth(playerid, 100.00);
						SendClientMessage(playerid, c_lightyellow, "You have been healed for $4500.");
						RewardPlayer(playerid, -4500, 0);

						ShowDialog(playerid, D_SHOP);
					}
					else
					{
						SendClientMessage(playerid, c_red, "* You do not have enough money to heal.");
						ShowDialog(playerid, D_SHOP);
					}
				}
				// Helmet
				case 2:
				{
					if (Player(playerid, Money) >= 3500)
					{
						if (!Var(playerid, HasHelmet))
						{
							ToggleHelmet(playerid, 1);
							SendClientMessage(playerid, c_lightyellow, "Bought a helmet for $3500.");
							RewardPlayer(playerid, -3500, 0);
							Var(playerid, HasHelmet) = 1;
							ShowDialog(playerid, D_SHOP);
						}
						else
						{
							SendClientMessage(playerid, c_red, "* You already have a helmet.");
							ShowDialog(playerid, D_SHOP);
						}
					}
					else
					{
						SendClientMessage(playerid, c_red, "* You do not have enough money to buy this item.");
						ShowDialog(playerid, D_SHOP);
					}
				}
				// Mask
				case 3:
				{
					if (Player(playerid, Money) >= 3000)
					{
						if (!Var(playerid, HasMask))
						{
							ToggleMask(playerid, 1);
							SendClientMessage(playerid, c_lightyellow, "Bought a mask for $3000.");
							RewardPlayer(playerid, -3000, 0);
							Var(playerid, HasMask) = 1;
							ShowDialog(playerid, D_SHOP);
						}
						else
						{
							SendClientMessage(playerid, c_red, "* You already have a mask.");
							ShowDialog(playerid, D_SHOP);
						}
					}
					else
					{
						SendClientMessage(playerid, c_red, "* You do not have enough money to buy this item.");
						ShowDialog(playerid, D_SHOP);
					}
				}
				// Weapons
				case 4:
				{
					ShowDialog(playerid, D_WEAPONS);
				}
				// Inventory
				case 5:
				{
					new shopid = shop_ReturnClosestID(playerid);

					if (Shop(shopid, TeamID) == Player(playerid, Team))
					{
						ShowDialog(playerid, D_INVENTORY);
					}
					else
					{
						SendClientMessage(playerid, c_red, "* You can only buy inventory items from your base's shop.");
						ShowDialog(playerid, D_SHOP);
					}
				}
				// DM
				case 6:
				{
					ShowDialog(playerid, D_DMLIST);
				}
			}
		}
	}

	return 1;
}

dialog_Inventory(playerid, response, listitem)
{
	if (Var(playerid, LoggedIn))
	{
		if (!response)
			return ShowDialog(playerid, D_SHOP);

		switch (listitem)
		{
			// Medikits
			case 0:
			{
				if (Player(playerid, Money) >= 5000)
				{
					if (Var(playerid, MediKits) == 3)
					{
						SendClientMessage(playerid, c_red, "* You have reached the maximum limit.");
						ShowDialog(playerid, D_INVENTORY);
					}
					else
					{
						SendClientMessage(playerid, c_lightyellow, "Bought medikits for $5000.");
						SendClientMessage(playerid, c_grey, "* Type '/inventory' or '/inv' to display the list of your inventory items.");

						Var(playerid, MediKits)++;
						RewardPlayer(playerid, -5000, 0);
						ShowDialog(playerid, D_INVENTORY);
					}
				}
				else
				{
					SendClientMessage(playerid, c_red, "* You do not have enough money to buy this item.");
					ShowDialog(playerid, D_INVENTORY);
				}
			}
			// Ammo packs
			case 1:
			{
				if (Player(playerid, Money) >= 2000)
				{
					if (Var(playerid, AmmoPack) == 3)
					{
						SendClientMessage(playerid, c_red, "* You have reached the maximum limit.");
						ShowDialog(playerid, D_INVENTORY);
					}
					else
					{
						SendClientMessage(playerid, c_lightyellow, "Bought ammo pack for $2000.");
						SendClientMessage(playerid, c_grey, "* Type '/inventory' or '/inv' to display the list of your inventory items.");
						Var(playerid, AmmoPack)++;
						RewardPlayer(playerid, -2000, 0);
						ShowDialog(playerid, D_INVENTORY);
					}
				}
				else
				{
					SendClientMessage(playerid, c_red, "* You do not have enough money to buy this item.");
					ShowDialog(playerid, D_INVENTORY);
				}
			}
			// Bombs
			case 2:
			{
				switch (Player(playerid, Class))
				{
					case DEMOLISHER, SUICIDE_BOMBER:
					{
						if (Player(playerid, Money) >= 10000)
						{
							if (!Var(playerid, HasBombs))
							{
								Var(playerid, HasBombs) = true;
								SendClientMessage(playerid, c_lightyellow, "Bought bombs for $10000.");
								SendClientMessage(playerid, c_grey, "* Type '/inventory' or '/inv' to display the list of your inventory items.");
								RewardPlayer(playerid, -10000, 0);
								ShowDialog(playerid, D_INVENTORY);
							}
							else
							{
								SendClientMessage(playerid, c_red, "* You already have bombs.");
								ShowDialog(playerid, D_INVENTORY);
							}
						}
						else
						{
							SendClientMessage(playerid, c_red, "* You do not have enough money to buy this item.");
							ShowDialog(playerid, D_INVENTORY);
						}
					}

					default:
					{
						SendClientMessage(playerid, c_red, "* Only Demolisher or Suicide Bomber can buy this item.");
						ShowDialog(playerid, D_INVENTORY);
					}
				}
			}
			// Disguise kit
			case 3:
			{
				if (Player(playerid, Class) == SPY)
				{
					if (Player(playerid, Money) >= 5000)
					{
						if (Var(playerid, DisKit) == 3)
						{
							SendClientMessage(playerid, c_red, "* You have reached the maximum limit.");
							ShowDialog(playerid, D_INVENTORY);
						}
						else
						{
							SendClientMessage(playerid, c_lightyellow, "Bought a disguise kit for $5000.");
							SendClientMessage(playerid, c_grey, "* Type '/inventory' or '/inv' to display the list of your inventory items.");

							++Var(playerid, DisKit);
							RewardPlayer(playerid, -5000, 0);
							ShowDialog(playerid, D_INVENTORY);
						}
					}
					else
					{
						SendClientMessage(playerid, c_red, "* You do not have enough money to buy this item.");
						ShowDialog(playerid, D_INVENTORY);
					}
				}
				else
				{
					SendClientMessage(playerid, c_red, "* This item is for Spy class only.");
					ShowDialog(playerid, D_INVENTORY);
				}
			}
		}
	}

	return 1;
}

dialog_DM_List(playerid, response, listitem)
{
	if (Var(playerid, LoggedIn))
	{
		if (!response)
			return ShowDialog(playerid, D_SHOP);

		if (Player(playerid, Protected))
		{
			SendClientMessage(playerid, c_red, "Please wait...");
			return ShowDialog(playerid, D_DMLIST);
		}
		
		if (Var(playerid, CapturingFlag) != -1)
		{
			SendClientMessage(playerid, c_red, "* Please drop the flag first.");
			return ShowDialog(playerid, D_DMLIST);
		}

		new dmid = (listitem + 1);

		ResetPlayerWeapons(playerid);
		--Team(Player(playerid, Team), Players);

		News(sprintf("~w~~h~%s ~p~has entered the %s stadium", playerName(playerid), DM(dmid, Name)));
		IRC_Echo(g_IRC_Conn[IRC_MAIN_CHANNEL], sprintf("6* %s has entered the %s stadium.", playerName(playerid), DM(dmid, Name)));

		SendClientMessage(playerid, -1, sprintf("* You joined the %s stadium, type '/qdm' if you want to quit.", DM(dmid, Name)));
		GameTextForPlayer(playerid, ""#TXT_LINE"~w~type ~r~/qdm~n~~w~if you want to quit", 3000, 3);
		SetPlayerInDM(playerid, dmid);
	}

	return 1;
}

dialog_Weapons(playerid, response, listitem)
{
	if (Var(playerid, LoggedIn))
	{
		if (!response)
		{
			Var(playerid, WeaponClass) = 0;
			return ShowDialog(playerid, D_SHOP);
		}

		if (IsPlayerAtShop(playerid))
		{
			Var(playerid, WeaponClass) = listitem;

			switch (listitem)
			{
				case 0:
				{
					if (Player(playerid, Money) >= 5000)
					{
						GivePlayerWeapon(playerid, 4, 1);
						RewardPlayer(playerid, -5000, 0);
						SendClientMessage(playerid, c_lightyellow, "Bought a knife for $5000.");

						ShowDialog(playerid, D_WEAPONS);
					}
					else
					{
						SendClientMessage(playerid, c_red, "* You do not have enough cash to buy a knife.");
						ShowDialog(playerid, D_WEAPONS);
					}
				}
				case 1:
				{
					if (Player(playerid, Money) >= 10000)
					{
						GivePlayerWeapon(playerid, 9, 1);
						RewardPlayer(playerid, -10000, 0);
						SendClientMessage(playerid, c_lightyellow, "Bought a chainsaw for $10000.");

						ShowDialog(playerid, D_WEAPONS);
					}
					else
					{
						SendClientMessage(playerid, c_red, "* You do not have enough cash to buy a chainsaw.");
						ShowDialog(playerid, D_WEAPONS);
					}
				}
				case 2..13: ShowPlayerDialog(playerid, D_AMMO, DIALOG_STYLE_TABLIST_HEADERS, "Select ammo", ""#sc_white"Amount\t"#sc_white"Price\n"#sc_green"50\t"#sc_lightgrey"$1250\n"#sc_green"100\t"#sc_lightgrey"$2500\n"#sc_green"150\t"#sc_lightgrey"$5000\n"#sc_green"200\t"#sc_lightgrey"$10000\n"#sc_green"500\t"#sc_lightgrey"$15000", "Buy", "Back");
				case 14..18: ShowPlayerDialog(playerid, D_AMMO, DIALOG_STYLE_TABLIST_HEADERS, "Select ammo", ""#sc_white"Amount\t"#sc_white"Price\n"#sc_green"2\t"#sc_lightgrey"$12500\n"#sc_green"7\t"#sc_lightgrey"$25000\n"#sc_green"12\t"#sc_lightgrey"$50000", "Buy", "Back");
			}
		}
	}

	return 1;
}

dialog_Ammo(playerid, response, listitem)
{
	if (Var(playerid, LoggedIn))
 	{
		if (!response)
			return ShowDialog(playerid, D_WEAPONS);

		if (IsPlayerAtShop(playerid))
		{
			if (Var(playerid, WeaponClass) != 0)
			{
				new
					class = Var(playerid, WeaponClass),
					weapon_data[5][2] = {
						{50, 1250},
						{100, 2500},
						{150, 5000},
						{200, 10000},
						{500, 15000}
					},
					price = (class < 14) ? (weapon_data[listitem][1]) : (weapon_data[listitem][1] * 10);
				
				if (Player(playerid, Money) >= price)
				{
					new
						weapon = g_BuyableWeaponID[class][0],
						ammo = (class < 14) ? (weapon_data[listitem][0]) : ((weapon_data[listitem][0] / 10) - 3);

					SendClientMessage(playerid, c_lightyellow, sprintf("Bought a %s with %i rounds of ammo for $%i.", aWeaponNames[weapon], ammo, price));
					GivePlayerWeapon(playerid, weapon, ammo);
					RewardPlayer(playerid, -price, 0);
					ShowDialog(playerid, D_WEAPONS);
				}
				else
				{
					SendClientMessage(playerid, c_red, "* You do not have enough money to buy that much ammo."),
					ShowDialog(playerid, D_WEAPONS);
				}
			}
		}
	}

	return 1;
}

dialog_SpawnPoint(playerid, response, listitem)
{
	if (Var(playerid, LoggedIn))
	{
		if (response)
		{
			Var(playerid, SpawnPoint) = listitem;
			if (listitem)
			{
				if (Zone(listitem, Team) == Player(playerid, Team))
				{
					SendClientMessage(playerid, c_green, sprintf("Spawn point has been set at: %s.", Zone(listitem, Name)));
				}
				else
				{
					SendClientMessage(playerid, c_red, "* Selected zone is not owned by your team.");
					return ShowDialog(playerid, D_SPAWNPOINT);
				}
			}
			else if (!Var(playerid, ViewingDialog))
		    {
		        SendClientMessage(playerid, c_green, "Spawn point has been set at: Base.");
			}
			if (Var(playerid, Spawning) == 1)
			{
				if (Var(playerid, PlayerStatus) == PLAYER_STATUS_SWITCHING_CLASS)
				{
					Var(playerid, PlayerStatus) = PLAYER_STATUS_NONE;
				}
				SendClientMessage(playerid, c_orange, sprintf("You have chosen %s class, type '/chelp' to understand the basics of your class.", Class(Player(playerid, Class), Name)));
				Var(playerid, Spawning) = 0;
				TextDrawHideForPlayer(playerid, Server(Background));
				SpawnPlayer(playerid);
			}
		}
		else
		{
			if (Var(playerid, Spawning) == 1)
			{
				ShowClassInfo(playerid, Player(playerid, Class));
			}
		}
	}

	return 1;
}

dialog_Settings(playerid, response, listitem)
{
	if (Var(playerid, LoggedIn))
	{
		if (response)
		{
			switch (listitem)
			{
				case 0:
				{
					if (Var(playerid, HasHelmet))
					{
						ToggleHelmet(playerid, (Var(playerid, Helmet)) ? 0 : 1);
						SendClientMessage(playerid, -1, (Var(playerid, Helmet)) ? ("Helmet: "#sc_green"ON") : ("Helmet: "#sc_red"OFF"));
						ShowDialog(playerid, D_SETTINGS);
					}
					else
					{
						SendClientMessage(playerid, c_red, "* You do not have a helmet.");
						ShowDialog(playerid, D_SETTINGS);
					}
				}
				case 1:
				{
					if (Var(playerid, HasMask))
					{
						ToggleMask(playerid, (Var(playerid, Mask)) ? 0 : 1);
						SendClientMessage(playerid, -1, (Var(playerid, Mask)) ? ("Mask: "#sc_green"ON") : ("Mask: "#sc_red"OFF"));
						ShowDialog(playerid, D_SETTINGS);
					}
					else
					{
						SendClientMessage(playerid, c_red, "* You do not have a mask.");
						ShowDialog(playerid, D_SETTINGS);
					}
				}
				case 2:
				{
					Var(playerid, HitSound) = !Var(playerid, HitSound);
					SendClientMessage(playerid, -1, (Var(playerid, HitSound)) ? ("Hit Sound: "#sc_green"ON") : ("Hit Sound: "#sc_red"OFF"));
					ShowDialog(playerid, D_SETTINGS);
				}
				case 3:
				{
					Var(playerid, DND) = !Var(playerid, DND);
					SendClientMessage(playerid, -1, (Var(playerid, DND)) ? ("DND: "#sc_green"ON") : ("DND: "#sc_red"OFF"));
					ShowDialog(playerid, D_SETTINGS);
				}
			}
		}
	}

	return 1;
}

dialog_NukeMain(playerid, response, listitem)
{
	if (Var(playerid, LoggedIn))
	{
		if (response)
		{
			switch (listitem)
			{
				case 0: ShowDialog(playerid, D_NUKEZONES);
				case 1: ShowDialog(playerid, D_NUKEBASES);
			}
		}
	}

	return 1;
}

dialog_NukeZones(playerid, response, listitem)
{
	if (Var(playerid, LoggedIn))
	{
		if (!response)
			return ShowDialog(playerid, D_NUKEMAIN);

		new zoneid;

		switch (listitem)
		{
			case 0: zoneid = 3; // Abandoned Airport
			case 1: zoneid = 14; // Las Venturas Airport
			case 2: zoneid = 1; // Radio Station
			case 3: zoneid = 28; // Ground Zero island
			case 4: zoneid = 27; // Hunter Quary
		}

		if (Nuke(RecentZone) != zoneid)
		{
			if (Player(playerid, Money) < 200000)
				return SendClientMessage(playerid, c_red, "* You need $200000 in order to launch the nuclear bomb.");
			
			nuke_Launch(playerid, zoneid, NUKE_TYPE_ZONE);
		}
		else
		{
			SendClientMessage(playerid, c_red, "* This zone has been nuked recently, please select another one.");
			ShowDialog(playerid, D_NUKEBASES);
		}
	}

	return 1;
}

dialog_NukeBases(playerid, response, listitem)
{
	if (Var(playerid, LoggedIn))
	{
		if (!response)
			return ShowDialog(playerid, D_NUKEMAIN);

		new teamid = listitem + 1;

		if (Nuke(RecentTeam) != teamid)
		{
			if (Player(playerid, Money) < 200000)
				return SendClientMessage(playerid, c_red, "* You need $200000 in order to launch the nuclear bomb.");
				
			nuke_Launch(playerid, teamid, NUKE_TYPE_BASE);
		}
		else
		{
			SendClientMessage(playerid, c_red, "* Selected base has been nuked recently, please select another one.");
			ShowDialog(playerid, D_NUKEBASES);
		}
	}

	return 1;
}

dialog_BaseSAM(playerid, response)
{
	if (Var(playerid, LoggedIn))
	{
		if (!response)
		{
			Var(playerid, CurrentBaseSAM) = 0;
			return 1;
		}

		if (Player(playerid, Money) < 20000)
			return SendClientMessage(playerid, c_red, "You do not have enough money.");
		
		new Float:x, Float:y, Float:z, count = 0, teamid;

		RewardPlayer(playerid, -20000, 0);
		SendClientMessage(playerid, -1, "Base SAM launched for $20000.");
		teamid = Player(playerid, Team);

		foreach(new i : Player)
		{
			if (IsPlayerInDynamicArea(i, Team(teamid, ZoneArea)) && teamid != Player(i, Team))
			{
				if (vehicle_IsAircraft(GetPlayerVehicleID(i)))
				{
					++count;
					GetPlayerPos(i, x, y, z);
					SetPlayerHealth(i, 0.0);
					CreateExplosion(x, y, z, 2, 5.0);
					
					GameTextForPlayer(i, ""#TXT_LINE"~r~destroyed", 2000, 3);
					SendDeathMessage(playerid, i, 47);
					SendClientMessage(i, c_red, sprintf("Your aircraft has been destroyed by the SAM missile launched by %s.", playerName(playerid)));
					SendClientMessage(playerid, c_green, sprintf("You received +$2000 and +1 score for destroying %s's aircraft.", playerName(i)));
				}
			}
		}

		BaseSam(Var(playerid, CurrentBaseSAM), Time) = gettime() + 120;
		Var(playerid, CurrentBaseSAM) = 0;
		
		if (count)
		{
			Player(playerid, Kills) += count;

			RewardPlayer(playerid, (count * 2000), count, true);
			SendClientMessageToAll(c_lightyellow, sprintf("%s destroyed %i aircraft by launching the base SAM missile at %s's base.", playerName(playerid), count, Team(teamid, Name)));
		}
		else
		{
			SendClientMessage(playerid, c_red, "No aircraft were destroyed.");
		}
	}

	return 1;
}

dialog_SAM(playerid, response, listitem)
{
	if (response)
	{
		if (Player(playerid, Money) < 10000)
		{
			SendClientMessage(playerid, c_red, "* You need $10000 to launch.");
			return ShowDialog(playerid, D_SAM_MAIN);
		}
		
		if (Player(playerid, Rank) < 5)
		{
			SendClientMessage(playerid, c_red, "* You must be rank 4+ to launch.");
			return ShowDialog(playerid, D_SAM_MAIN);
		}

		switch (listitem)
		{
			case 0: sam_Launch(playerid, 2, SAM_TYPE_ZONE); // Area 51
			case 1: ShowDialog(playerid, D_SAM_ZONES);
			case 2: ShowDialog(playerid, D_SAM_BASES);
		}
	}

	return 1;
}

dialog_SAM_Zones(playerid, response, listitem)
{
	if (Var(playerid, LoggedIn))
	{
		if (!response)
			return ShowDialog(playerid, D_SAM_MAIN);

		new zoneids[10][1] = {
			{3}, {14}, {28}, {1}, {27}, {4}, {15}, {6}, {7}, {5}
		};
		
		sam_Launch(playerid, zoneids[listitem][0], SAM_TYPE_ZONE);
	}

	return 1;
}

dialog_SAM_Bases(playerid, response, listitem)
{
	if (response)
		return sam_Launch(playerid, (listitem + 1), SAM_TYPE_BASE);

	ShowDialog(playerid, D_SAM_MAIN);
	
	return 1;
}

dialog_AbandonedAirport(playerid, response)
{
	if (Var(playerid, LoggedIn) && response)
	{
		if (Nuke(AffectedArea) == -1)
		{
			SendClientMessage(playerid, c_red, "* None of the area is affected by the nuclear bomb.");
			return ShowDialog(playerid, D_ABANDONEDAIRPORT);
		}

		if (Player(playerid, Team) == Zone(3, Team))
			return ShowDialog(playerid, D_WIPENUKE);

		SendClientMessage(playerid, c_red, "* Your team must capture the 'Abandoned Airport' to use this feature.");
		ShowDialog(playerid, D_ABANDONEDAIRPORT);
	}

	return 1;
}

dialog_WipeNuke(playerid, response)
{
	if (Var(playerid, LoggedIn))
	{
		if (!response)
			return ShowDialog(playerid, D_ABANDONEDAIRPORT);

		if (Player(playerid, Money) < 20000)
		{
			SendClientMessage(playerid, c_red, "* Not enough money.");
			return ShowDialog(playerid, D_ABANDONEDAIRPORT);
		}

		if (Player(playerid, Rank) < 2)
		{
			SendClientMessage(playerid, c_red, "* You need to be rank 2+ to use this feature.");
			return ShowDialog(playerid, D_ABANDONEDAIRPORT);
		}

		RewardPlayer(playerid, -20000, 5, true);

		SendClientMessageToAll(c_lightyellow, sprintf("* %s from %s has wiped the nuclear effect out at %s.", playerName(playerid), Team(Player(playerid, Team), Name), nuke_ReturnAffectedAreaName()));
		IRC_Echo(g_IRC_Conn[IRC_MAIN_CHANNEL], sprintf("* %s from %s has wiped the nuclear effect out at %s.",  playerName(playerid), Team(Player(playerid, Team), Name), nuke_ReturnAffectedAreaName()));
		SendClientMessage(playerid, c_green, sprintf("You have successfully wiped the nuclear effect out at %s and received +5 score.", nuke_ReturnAffectedAreaName()));
		Nuke(AffectedArea) = -1;
		Nuke(TimeAffected) = 0;
	}

	return 1;
}

dialog_ClanName(playerid, response, inputtext[])
{
	if (Var(playerid, LoggedIn))
	{
		if (!response)
		{
			g_RegisteringClan[playerid][0] = '\0';
			return 1;
		}

		if (strlen(inputtext) < 10 || strlen(inputtext) > 45)
		{
			SendClientMessage(playerid, c_red, "* Name length should not be lower than 10 and higher than 45.");
			return ShowDialog(playerid, D_CLAN_NAME);
		}

		new query[128];

		Query("SELECT `clan_name` FROM `clans` WHERE `clan_name`='%e'", inputtext);
		mysql_tquery(connection, query, "ClanQuery", "iis", clan_res_checkname, playerid, inputtext);
	}

	return 1;
}

dialog_ClanTag(playerid, response, inputtext[])
{
	if (Var(playerid, LoggedIn))
	{
		if (!response)
			return ShowDialog(playerid, D_CLAN_NAME);
		
		if (strlen(inputtext) > 10 || strlen(inputtext) < 3)
		{
			SendClientMessage(playerid, c_red, "* Tag length should not be lower than 3 and higher than 10.");
			return ShowDialog(playerid, D_CLAN_TAG);
		}

		new query[128];

		Query("SELECT `clan_tag` FROM `clans` WHERE `clan_tag`='%e'", inputtext);
		mysql_tquery(connection, query, "ClanQuery", "iis", clan_res_checktag, playerid, inputtext);
	}

	return 1;
}

dialog_ClanFounder(playerid, response, inputtext[])
{
	if (Var(playerid, LoggedIn))
	{
		if (!response)
		{
			g_RegisteringClanTag[playerid][0] = '\0';
			return ShowDialog(playerid, D_CLAN_TAG);
		}

		if (strlen(inputtext) < 1)
		{
			SendClientMessage(playerid, c_red, "* Please enter a valid username.");
			return ShowDialog(playerid, D_CLAN_FOUNDER);
		}

		new query[128];

		Query("SELECT `id`,`nick`,`clanid` FROM `users` WHERE `nick`='%e'", inputtext);
		mysql_tquery(connection, query, "ClanQuery", "iis", clan_res_assignfounder, playerid, inputtext);
	}
	return 1;
}

dialog_CmdTitle(playerid, response, listitem)
{
    if (Var(playerid, LoggedIn) && response)
	{
		Var(playerid, ViewingCmd) = listitem;
		ShowCommands(playerid, listitem);
	}

	return 1;
}

dialog_Cmd(playerid, response)
{
    if (response)
		return ShowCommands(playerid, Var(playerid, ViewingCmd));

    Var(playerid, ViewingCmd) = -1;
	ShowCommandPage(playerid);

	return 1;
}

dialog_RadioMain(playerid, response, listitem)
{
	if (Var(playerid, LoggedIn) && response)
	{
		switch (listitem)
		{
			case 0:
			{
				if (Server(RadioHackTime) != 0)
				{
					SendClientMessage(playerid, c_red, "* The radio hack system is not ready yet.");
					return ShowDialog(playerid, D_RADIO_MAIN);
				}
		
				ShowDialog(playerid, D_RADIO_HACK_TEAM);
			}
			case 1:
			{
				if (Server(RadioFixTime) != 0)
				{
					SendClientMessage(playerid, c_red, "* The radio damage system is not ready yet.");
					return ShowDialog(playerid, D_RADIO_MAIN);
				}

				ShowDialog(playerid, D_RADIO_BREAK_TEAM);
			}
		}
	}

	return 1;
}

dialog_HackRadioTeam(playerid, response, listitem)
{
	if (Var(playerid, LoggedIn))
	{
		if (!response)
			return ShowDialog(playerid, D_RADIO_MAIN);

	    if (Player(playerid, Money) < 10000)
	    {
	        SendClientMessage(playerid, c_red, "* You do not have enough money for this feature.");
	        return ShowDialog(playerid, D_RADIO_HACK_TEAM);
		}
		
		if (Player(playerid, Rank) < 4)
		{
            SendClientMessage(playerid, c_red, "* You must be rank 4+ to use this feature.");
	        return ShowDialog(playerid, D_RADIO_HACK_TEAM);
		}

		new teamid = (listitem + 1);
		
		if (Player(playerid, Team) == teamid)
		{
		    SendClientMessage(playerid, c_red, "* You cannot hack your own team's radio.");
        	return ShowDialog(playerid, D_RADIO_HACK_TEAM);
		}

		Var(playerid, RadioActionTeam) = teamid;
		ShowPlayerDialog(playerid, D_RADIO_HACK_CONFIRM, DIALOG_STYLE_MSGBOX, "Radio Hack", sprintf("Are you sure you want to hack team %s's radio for 5 minutes?\n\nCost: $10000", Team(teamid, Name)), "Yes", "No");
	}

	return 1;
}

dialog_HackRadioConfirm(playerid, response)
{
	if (Var(playerid, LoggedIn))
	{
		if (!response)
		{
			Var(playerid, RadioActionTeam) = 0;
			return ShowDialog(playerid, D_RADIO_HACK_TEAM);
		}

		new team_1, team_2;
	
		team_1 = Var(playerid, RadioActionTeam);
		team_2 = Player(playerid, Team);

		Server(RadioHackTime) = gettime() + 300;
		Server(RadioHackedTeam) = team_1;
		Team(team_1, RadioHackingTeam) = team_2;

		SendClientMessageToAll(c_red, "Radio Station: The radio hack has just been used.");
		SendClientMessage(playerid, c_green, sprintf("You received +5 score for hacking the radio of team %s.", Team(team_1, Name)));
		team_SendMessage(team_2, c_lightyellow, sprintf("%s has hacked the radio of %s, team %s received +1 score and $1000.", playerName(playerid), Team(team_1, Name), Team(team_2, Name)));

		Var(playerid, RadioActionTeam) = 0;
		RewardPlayer(playerid, 0, 2);
	}

	return 1;
}

dialog_BreakRadioTeam(playerid, response, listitem)
{
	if (Var(playerid, LoggedIn))
	{
		if (!response)
			return ShowDialog(playerid, D_RADIO_MAIN);

	    if (Player(playerid, Money) < 20000)
	    {
	        SendClientMessage(playerid, c_red, "* You do not have enough money for this feature.");
	        return ShowDialog(playerid, D_RADIO_BREAK_TEAM);
		}
		
		if (Player(playerid, Rank) < 4)
		{
            SendClientMessage(playerid, c_red, "* You must be rank 4+ to use this feature.");
	        return ShowDialog(playerid, D_RADIO_BREAK_TEAM);
		}

		new teamid = (listitem + 1);

		if (Player(playerid, Team) == teamid)
		{
		    SendClientMessage(playerid, c_red, "* You cannot damage your own team's radio.");
        	return ShowDialog(playerid, D_RADIO_BREAK_TEAM);
		}

		Var(playerid, RadioActionTeam) = teamid;
		ShowPlayerDialog(playerid, D_RADIO_BREAK_CONFIRM, DIALOG_STYLE_MSGBOX, "Damage Radio", sprintf("Are you sure you want to damage team %s's radio for 5 minutes?\n\nCost: $20000", Team(teamid, Name)), "Yes", "No");
	}

	return 1;
}

dialog_VIPFeat(playerid, response)
{
	if (Var(playerid, LoggedIn))
	{
		switch (response)
		{
		    case 0, 1: ShowDialog(playerid, D_DONATE);
		}
	}
	return 1;
}

dialog_Donate(playerid, response)
{
	if (Var(playerid, LoggedIn))
	{
		if (response)
		{
		    ShowDialog(playerid, D_VIPFEAT);
		}
	}
	return 1;
}

dialog_BreakRadioConfirm(playerid, response)
{
	if (Var(playerid, LoggedIn))
	{
		if (response)
		{
			Var(playerid, RadioActionTeam) = 0;
			return ShowDialog(playerid, D_RADIO_BREAK_TEAM);
		}

		new team_1, team_2;

		team_1 = Var(playerid, RadioActionTeam);
        team_2 = Player(playerid, Team);
		Server(RadioFixTime) = gettime() + 300;
		Team(team_1, RadioBroken) = true;

		SendClientMessageToAll(c_red, "Radio Station: The radio damage feature has just been used.");
		SendClientMessage(playerid, c_green, sprintf("You received +10 score for damaging the radio of team %s.", Team(team_1, Name)));
		team_SendMessage(team_2, c_lightyellow, sprintf("%s has damaged the radio of %s, team %s received +1 score and $1000.", playerName(playerid), Team(team_1, Name), Team(team_2, Name)));

		Var(playerid, RadioActionTeam) = 0;
		RewardPlayer(playerid, 0, 10);
	}

	return 1;
}

dialog_GroundZeroMain(playerid, response, listitem)
{
	if (Var(playerid, LoggedIn) && response)
	{
	    switch (listitem)
	    {
	        case 0:
			{
			    if (Player(playerid, Money) < 500000)
			    {
			        SendClientMessage(playerid, c_red, "* You do not have enough money to launch.");
			        return ShowDialog(playerid, D_GZ_MAIN);
				}
				
				if (Player(playerid, Rank) < 5)
				{
					SendClientMessage(playerid, c_red, "* You must be rank 5+ to use this feature.");
					return ShowDialog(playerid, D_GZ_MAIN);
				}
				
				ShowPlayerDialog(playerid, D_GZ_MOAB, DIALOG_STYLE_MSGBOX, "MOAB", sprintf("Players on foot: %i\nPlayers in vehicle: %i\n\nAre you sure you want to launch the bomb for $500000?", CountOnFootPlayers(), CountInVehiclePlayers()), "Yes", "No");
			}
		}
	}

	return 1;
}

dialog_MOAB(playerid, response)
{
	if (Var(playerid, LoggedIn))
	{
	    if (!response)
	    	return ShowDialog(playerid, D_GZ_MAIN);

		new p_state, Float: health, count = 0;

		SetWeather(20);
		SetTimer("reset_Dust", 15000, 0);
		RewardPlayer(playerid, -500000, 0);
		Server(GroundZeroTime) = 0;

		foreach(new i : Player)
		{
			p_state = GetPlayerState(i);

			if (i == playerid)
				continue;

			if (p_state == PLAYER_STATE_ONFOOT)
			{
			    if (!IsPlayerPaused(i))
			    {
					if (Player(playerid, Team) != Player(i, Team) && !Var(i, Duty) && !Player(i, Protected))
					{
						GetPlayerHealth(i, health);
						GameTextForPlayer(i, ""#TXT_LINE"~r~affected!", 3000, 3);

						if (health < 50)
						{
							SendClientMessage(playerid, c_green, sprintf("You killed %s with the launched MOAB, +$1000.", playerName(i)));
							SetPlayerHealth(i, 0.0);
							SendDeathMessage(playerid, i, 53);
							RewardPlayer(playerid, 1000, 0);
							++count;
						}
						else
						{
							SetPlayerHealth(i, (health - 50));
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

		SendClientMessageToAll(c_red, "Ground Zero: The MOAB has just been launched.");
		
		if (count)
		{
		    Player(playerid, Kills) += count;
			SendClientMessageToAll(c_red, sprintf("Total of %i players were killed.", count));
		}
	}
	
	return 1;
}

dialog_Clans(playerid, response, listitem)
{
	if (response)
	{
		Var(playerid, ViewingDialog) = true;
		clan_ShowInfo(playerid, listitem);
	}

	return 1;
}

dialog_ClanInfo(playerid, response)
{
	switch (response)
	{
	    case 0, 1:
	    {
	        if (Var(playerid, ViewingDialog) == true)
	        {
	            ShowDialog(playerid, D_CLANS);
           		Var(playerid, ViewingDialog) = false;
	        }
	    }
	}
	return 1;
}

dialog_ClanSkin(playerid, response, inputtext[])
{
	if (!response)
	{
	    Var(playerid, TempClanSkin) = -1;
	    return ShowDialog(playerid, D_CLAN_SETTINGS);
	}

    new skinid;

    if (sscanf(inputtext, "i", skinid))
	{
	    SendClientMessage(playerid, c_red, "* Please enter the ID of the skin.");
	    return ShowDialog(playerid, D_CLAN_SKIN);
	}

    if (!IsValidSkin(playerid, skinid))
    	return ShowDialog(playerid, D_CLAN_SKIN);

    if (clan_IsSkinTaken(skinid))
    {
		SendClientMessage(playerid, c_red, "* Sorry, selected skin is already taken by another clan, please select another skin.");
        return ShowDialog(playerid, D_CLAN_SKIN);
	}

    Var(playerid, TempClanSkin) = skinid;
	ShowDialog(playerid, D_CLAN_SKIN_CONFIRM);

	return 1;
}

dialog_ClanSkinConfirm(playerid, response)
{
	if (!response)
	{
	    Var(playerid, TempClanSkin) = -1;
	    return ShowDialog(playerid, D_CLAN_SKIN);
	}

    new query[128], skinid, clanid;

	clanid = Player(playerid, ClanID);
	skinid = Var(playerid, TempClanSkin);
	Clan(clanid, Points) -= 100;
    Query("UPDATE `clans` SET `clan_skin`='%i',`clan_points`='%i' WHERE `clan_id`='%i'", skinid, Clan(clanid, Points), clanid);
    mysql_tquery(connection, query, "ExecuteQuery", "i", res_none);

	Clan(clanid, Skin) = skinid;
	clan_SendMessage(clanid, c_clan, sprintf("Clan leader %s has changed the clan skin to skin ID %i.", playerName(playerid), skinid));
	ShowPlayerDialog(playerid, D_MSG, DIALOG_STYLE_MSGBOX, "Success!", sprintf(""#sc_green"You have changed the clan skin to skin ID %i for 100 clan points.", skinid), "Close", "");
	Var(playerid, TempClanSkin) = -1;
	
	foreach(new i : Player)
	{
	    if (Player(i, ClanID) == clanid)
	    {
			SetSkin(i, skinid);
	    }
	}

	return 1;
}

dialog_ClanMembers(playerid, response)
{
	switch (response)
	{
	    case 0, 1: ShowDialog(playerid, D_CLAN_SETTINGS);
	}
	return 1;
}

dialog_ClanSettings(playerid, response, listitem)
{
	if (response)
	{
        new clanid = Player(playerid, ClanID);

		switch (listitem)
		{
			case 0: // Members
			{
				new query[100];

				Query("SELECT `nick` FROM `users` WHERE `clanid`='%i'", clanid);
				mysql_tquery(connection, query, "ClanQuery", "ii", clan_res_memlist, playerid);
			}
			case 1: // Change skin
			{
			    if (Clan(clanid, Points) < 100)
			    {
			        SendClientMessage(playerid, c_red, "* Not enough clan points, requires 100.");
			        return ShowDialog(playerid, D_CLAN_SETTINGS);
				}
		
			    ShowDialog(playerid, D_CLAN_SKIN);
			}
			case 2: ShowDialog(playerid, D_CLAN_MOTTO);
			case 3:
			{
			    new text[700];

				strcat(text, ""#sc_green"/cw"#sc_lightgrey" - Send a clan war request.\n");
				strcat(text, ""#sc_green"/cwaccept"#sc_lightgrey" - Accept a clan war request.\n");
				strcat(text, ""#sc_green"/cwdeny"#sc_lightgrey" - Deny a clan war request.\n");
				strcat(text, ""#sc_green"/cwadd"#sc_lightgrey" - Add a member to the clan war list.\n");
				strcat(text, ""#sc_green"/cwremove"#sc_lightgrey" - Remove a member from the clan war list.\n");
				strcat(text, ""#sc_green"/cwstart"#sc_lightgrey" - Start the clan war.\n");
				strcat(text, ""#sc_green"/cwcancel"#sc_lightgrey" - Cancel the clan war.\n");
			 	strcat(text, ""#sc_green"/cwmembers"#sc_lightgrey" - Display a list of clan war members.");
			 	ShowPlayerDialog(playerid, D_CWCMDS, DIALOG_STYLE_MSGBOX, "Clan war commands", text, "Back", "");
			}
		}
	}

	return 1;
}

dialog_CWCmds(playerid, response)
{
	switch (response)
	{
	    case 0, 1: ShowDialog(playerid, D_CLAN_SETTINGS);
	}
	return 1;
}

dialog_ClanMotto(playerid, response, inputtext[])
{
	if (!response)
		return ShowDialog(playerid, D_CLAN_SETTINGS);

	new motto[100];

	if (sscanf(inputtext, "s[100]", motto))
	{
	    SendClientMessage(playerid, c_red, "* Please enter valid text.");
	    return ShowDialog(playerid, D_CLAN_MOTTO);
	}

    if (strlen(motto) > 100)
	{
	    SendClientMessage(playerid, c_red, "* Text length exceeds the maximum character limit. Max: 100 chars.");
	    return ShowDialog(playerid, D_CLAN_MOTTO);
	}

    new clanid, query[200];

	clanid = Player(playerid, ClanID);
	Query("UPDATE `clans` SET `motto`='%s' WHERE `clan_id`='%i'", motto, clanid);
	mysql_tquery(connection, query, "ExecuteQuery", "i", res_none);
	
	SendClientMessage(playerid, c_green, "Clan motto has been set to:");
	SendClientMessage(playerid, c_green, sprintf("\"%s\"", motto));
	format(Clan(clanid, Motto), 100, "%s", motto);

	return 1;
}
