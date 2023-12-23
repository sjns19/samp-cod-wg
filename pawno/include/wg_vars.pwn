#define server_name               	".: Call of Duty :. Warground • TeamDSS"
#define server_version              "2.1.0"
#define server_update_date          "4/17/2017"

#undef INVALID_3DTEXT_ID
#undef MAX_PLAYERS

#define INVALID_3DTEXT_ID 			Text3D:0xFFFF
#define MAX_PLAYERS         	   	100
/*-------------------------- Max array cells ---------------------------------*/

#define MAX_RANKS           		13
#define MAX_WEAPON_SLOT         	15
#define MAX_WEAPONS                 47
#define MAX_TEAMS                    9
#define MAX_CLASSES                 12
#define MAX_ADMIN               	 7
#define MAX_SHOPS                   50
#define MAX_CZ                      80
#define MAX_SQUADS              	50
#define MAX_SQUAD_MEMBERS       	15
#define MAX_SPAWNS                  60
#define MAX_CLANS					50
#define MAX_CLANWAR                 10
#define MAX_REASON					35
#define MAX_BRIDGES					17
#define MAX_BRIDGE_GROUP			 5
#define MAX_NEWSBOX_CONTENTS		 7
#define MAX_DUELS       			10
#define MAX_DM						 4
#define MAX_WEAPON_TYPE             14

/*---------------------------- Small macros ----------------------------------*/
#define is_connected(%1)        	(0 <= %1 < MAX_PLAYERS ? g_Player[%1][Connected] : false)

#define clear_Chat(%0)              for (new i = 0, j = 25; i != j; ++i) \
										SendClientMessage(%0, -1, "")

#define released(%0) 				(((newkeys & (%0)) != (%0)) && ((oldkeys & (%0)) == (%0)))
#define pressed(%0) 				(((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))

#define Query( 						mysql_format(connection, query, sizeof(query),
#define Format:%0( 					format(%0, sizeof(%0),

#define function%0(%1) 				forward %0(%1); \
									public %0(%1)

#define PUTMASK(%0) 				SetPlayerAttachedObject(%0, GASMASK, 19036, 2, 0.093730, 0.031213, -0.003463, 89.660316, 88.277458, 4.669996, 1.0, 1.0, 1.0)

#define REMOVEMASK(%0) 				if (IsPlayerAttachedObjectSlotUsed(%0, GASMASK)) \
										RemovePlayerAttachedObject(%0, GASMASK)

#define PUTHELMET(%0) 				SetPlayerAttachedObject(%0, HELMET, 19514, 2, 0.107293, 0.024471, 0.0, 0.0, 0.0, 0.0, 1.281942, 1.0, 1.0)

#define REMOVEHELMET(%0) 			if (IsPlayerAttachedObjectSlotUsed(%0, HELMET)) \
										RemovePlayerAttachedObject(%0, HELMET)

#define AttachFlag(%0) 				SetPlayerAttachedObject(%0, FLAG, 2993, 1, -0.585601, -0.076416, -0.437628, 185.835174, 124.919952, 358.802429, 0.540304, 1.0, 0.823759)

#define DetachFlag(%0) 				if (IsPlayerAttachedObjectSlotUsed(%0, FLAG)) \
										RemovePlayerAttachedObject(%0, FLAG)
										
#define BG_TeamSelection(%0)      	SetPlayerPos(%0, cs_X, cs_Y, cs_Z); \
								    SetPlayerFacingAngle(%0, cs_A); \
								    SetPlayerCameraPos(%0, cs_CamX, cs_CamY, cs_CamZ); \
									SetPlayerCameraLookAt(%0, cs_Look_X, cs_Look_Y, cs_Look_Z); \
									SetPlayerVirtualWorld(%0, playerid + 6000);
											

#define Player(%1,%2) 				g_Player[%1][%2]
#define Var(%1,%2)         			g_Var[%1][%2]
#define Vehicle(%1,%2) 				g_Vehicle[%1][%2]
#define Team(%1,%2)            		g_TeamInfo[%1][%2]
#define Zone(%1,%2)            		g_CapZone[%1][%2]
#define Flag(%1,%2)            		g_ZoneFlags[%1][%2]
#define TD(%1,%2)              		g_TextDraw[%1][%2]
#define Class(%1,%2)               	g_ClassInfo[%1][%2]
#define Bridge(%1,%2)              	g_Bridge[%1][%2]
#define BridgeObjects(%1,%2)       	g_BridgeObjects[%1][%2]
#define Timer(%1,%2)               	g_Timer[%1][%2]
#define Rank(%1,%2)                	g_RankInfo[%1][%2]
#define Sync(%1,%2)                	g_SyncData[%1][%2]
#define Spec(%1,%2)                	g_SpecData[%1][%2]
#define Shop(%1,%2)                	g_Shop[%1][%2]
#define Duel(%1,%2)                	g_Duel[%1][%2]
#define Clan(%1,%2)                	g_Clans[%1][%2]
#define CW(%1,%2)                   g_ClanWar[%1][%2]
#define DM(%1,%2)                  	g_DM[%1][%2]
#define Report(%1,%2)              	g_Report[%1][%2]
#define Spawn(%1,%2)               	g_Spawn[%1][%2]
#define BaseSam(%1,%2)             	g_BaseSam[%1][%2]

#define Nuke(%1)                	g_Nuke[%1]
#define Server(%1) 					g_ServerData[%1]

#define playerName(%1)          	Player(%1, Name)

#define HideMarker(%1,%2) 			SetPlayerMarkerForPlayer(%1, %2, (GetPlayerColor(%2) & 0xFFFFFF00))
#define ShowMarker(%1,%2) 			SetPlayerMarkerForPlayer(%1, %2, (GetPlayerColor(%2) & 0xFFFFFFCC))

#define error:%0(%1,%2) 			SendClientMessage(%1, -1, sprintf("%s %s", error_Prefix[%0], %2))
#define freeze_screen(%0) 			TogglePlayerSpectating(%0, true), \
									InterpolateCameraLookAt(%0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.1, 100, CAMERA_MOVE)
/*----------------------------------------------------------------------------*/

#define FLOAT_INFINITE		(Float:0x7F800000)
#define TXT_LINE		  "~n~~n~~n~~n~~n~~n~"
#define _gen                    		 	 0
#define _usage                     		 	 1
/*------------------------------- Colors -------------------------------------*/
#define opacity                     0xFFFFFF88

// Colors for players
#define c_green             		0x80FF00FF
#define c_blue                    	0x0080FFFF
#define c_tomato                  	0xFD4102FF
#define c_yellow                    0xFFFF00FF
#define c_red                     	0xFA2405FF
#define c_grey                    	0x808080FF
#define c_darkgreen               	0x58B000FF
#define c_purple                    0xA07ACFFF
#define c_orange                    0xFF8000FF
#define c_lightgrey                 0xDDDDDDFF
#define c_lightyellow 	        	0xFFEA9FFF
#define c_lime                      0xC1FFC1FF

// Colors for admin
#define ac_cmd_usage                0x008080FF
#define ac_gcmd                     0x00A6A6FF
#define ac_duty                		0xCAAAFFFF
#define ac_cmd1                  	0xC0DC98FF
#define ac_cmd2                 	0x80FF00FF
#define ac_chat                     0xD09F57FF

#define c_vcmd               		0x63E26CFF

#define c_clan                      0xEED211FF
// Sub color for the chat messages
#define sc_ac_gcmd                  "{00A6A6}"

#define sc_white                    "{FFFFFF}"
#define sc_green             		"{80FF00}"
#define sc_blue                    	"{0080FF}"
#define sc_tomato                  	"{FD4102}"
#define sc_yellow                   "{FFFF00}"
#define sc_red                     	"{FA2405}"
#define sc_grey                    	"{808080}"
#define sc_darkgreen               	"{58B000}"
#define sc_purple                   "{A07ACF}"
#define sc_orange                   "{FF8000}"
#define sc_lightgrey                "{DDDDDD}"
#define sc_lightyellow 	        	"{FFEA9F}"

/*----------------------------------------------------------------------------*/
#define c_sub(%1)                	(%1 >>> 8)

#define bot                    "Captain_Price"

#define GASMASK 							 1
#define HELMET 								 2
#define FLAG                        		 3
#define BODYPART_HEAD   					 9

#define DEFAULT_WEATHER             		 3

// For supporter class
#define CARGOBOB 						   548
#define BARRACKS                    	   433

#define BOT_1_NICKNAME 				  "DSSWG1"
#define BOT_1_REALNAME 			  "Bot1@codwg"
#define BOT_1_USERNAME 					 "DSS"
#define BOT_1_PASSWORD 			"echobot1@dss"

#define BOT_2_NICKNAME 				  "DSSWG2"
#define BOT_2_REALNAME 			  "Bot2@codwg"
#define BOT_2_USERNAME 					 "DSS"
#define BOT_2_PASSWORD 			"echobot2@dss"

#define DAYS                        		 0
#define HOURS                       		 1
#define MINUTES                     		 2

/*------------------------- Coordiante defines -------------------------------*/
// Jail
#define INTERIOR_JAIL 						10
#define JAIL_X							 220.0
#define JAIL_Y							 110.0
#define JAIL_Z							999.10

// Ground zero weapons
#define gz_x                          149.7678
#define gz_y						 3560.3037
#define gz_z							2.1620
// Nuke object
#define nuke_x						  273.8497
#define nuke_y						 1882.3623
#define nuke_z						  -30.3906

// Coordinate for 3D text label near nuclear bomb
#define nuke_X          			 268.70752
#define nuke_Y						1883.76501
#define nuke_Z						 -31.10630

// Class/team selection position
#define cs_X						 -162.7402
#define cs_Y					  	-3874.7498
#define cs_Z						   34.5327
#define cs_A						   16.5990

// Camera pos for class/team selection
#define cs_CamX					  	 -161.7045
#define cs_CamY                     -3870.2024
#define cs_CamZ         			   34.7712

#define cs_Look_X				  	 -161.9195
#define cs_Look_Y				 	-3871.1814
#define cs_Look_Z				       34.8213

#define NUKE_TYPE_ZONE              		 1
#define NUKE_TYPE_BASE              		 2

#define SAM_TYPE_ZONE               		 1
#define SAM_TYPE_BASE               		 2

#define IRC_PREFIX_BAN           "0,4 BAN  "
#define IRC_PREFIX_SUCCESS	 "0,3 SUCCESS  "
#define IRC_PREFIX_RESULT	 "0,10 RESULT  "
#define IRC_PREFIX_ERROR	   "0,5 ERROR  "

/*----------------------------------------------------------------------------*/

/*-------------------------- Server settings ----------------------------------*/
native WP_Hash(buffer[], len, const str[]);

new error_Prefix[2][16] =
{
    {""#sc_red"*"},
    {""#sc_lightgrey"Usage:"}
};

enum e_IRC_DATA
{
	IRC_HOST[50],
	IRC_PORT,
	IRC_MAIN_CHANNEL[50],
	IRC_ADMIN_CHANNEL[50]
}

new g_IRC_Conn[e_IRC_DATA],
 	IRC_BOT_1,
	IRC_BOT_2,
	IRC_GROUP_1,
	IRC_GROUP_2;
	
enum E_SERVER_DATA
{
			MaxPing,
	bool:	ChatDisabled,
	Text:	AnnText,
	Text:	Website,
	Text:   CmdsText,
	Text:   Background,
	Text:   BombTime,
	        Players,
			Zones,
			Time,
			Weather,
			GroundZeroTime,
	Text3D: GroundZeroTimeDisp,
			RadioHackedTeam,
			RadioHackTime,
   			RadioFixTime,
			RadioPickup,
			AnnTextTimer,
			SpawnPoints,
			SAMTime,
			SAMPickup,
			AbandonedAirportPickup,
			TimedMsg,
			MOTD[128]
};

new g_ServerData[E_SERVER_DATA];
/*----------------------------------------------------------------------------*/

/*-------------------------- Bridge settings ---------------------------------*/
enum
{
	BRIDGE_STATUS_FIXED,
	BRIDGE_STATUS_COLLAPSED
}

enum
{
	TIERRA_ROBADA_BRIDGE,
	FALLOW_BRIDGE,
	BONE_COUNTY_BRIDGE,
	MARTIN_BRIDGE
}

enum E_BRIDGEOBJECT_DATA
{
			GroupID,
	Float:	Fixed_X,
	Float:	Fixed_Y,
	Float:	Fixed_Z,
	Float:	Fixed_RX,
	Float:	Fixed_RY,
	Float:	Fixed_RZ,
	Float:	Damaged_X,
	Float:	Damaged_Y,
	Float:	Damaged_Z,
	Float:	Damaged_RX,
	Float:	Damaged_RY,
	Float:	Damaged_RZ,
			Object
}

new g_BridgeObjects[MAX_BRIDGES][E_BRIDGEOBJECT_DATA];

new Iterator:BridgeObjects<MAX_BRIDGES>;
new Iterator:Bridges<MAX_BRIDGE_GROUP>;

enum E_BRIDGE_DATA
{
			Name[25],
	Float:	PointX,
	Float:	PointY,
	Float:	PointZ,
			ExplodeTime,
			RepairTime,
			Status,
	bool:	Planted,
	bool:	Repaired,
			PlantingPlayer
}
new g_Bridge[MAX_BRIDGE_GROUP][E_BRIDGE_DATA] =
{
    {"Tierra Robada Bridge", -1087.5135, 2685.2502, 42.2983},
    {"Fallow Bridge", 585.0275,394.4706,11.5736},
    {"Bone County Bridge", -409.4123, 1023.6417, 3.8891},
    {"Martin Bridge", -147.8760, 480.8916, 7.8391},
    {"", 9999.9, 9999.9, 9999.9}
};

/*----------------------------------------------------------------------------*/

/*---------------------------- Class settings --------------------------------*/
enum
{
	C_NAN,
	SOLDIER,
	SNIPER,
	ENGINEER,
	PILOT,
	MEDIC,
	SPY,
	SUPPORTER,
	VIPCLASS,
	ASSAULT,
	DEMOLISHER,
	SUICIDE_BOMBER
}

enum E_CLASS_DATA
{
	Name[30],
	RequiredRank,
	Weapons[8],
	WeaponAmmo[8],
	Desc[200],
	Ability[128]
};

new g_ClassInfo[MAX_CLASSES][E_CLASS_DATA];
new Iterator:Classes<MAX_CLASSES>;

/*----------------------------------------------------------------------------*/

/*--------------------------- Team settings ----------------------------------*/
enum
{
	T_NAN,
	AMERICA,
	EUROPE,
	AUSTRALIA,
	RUSSIA,
	ARABIA,
	ASIA,
	TERRORIST,
	MERCENARY
}

enum E_TEAM_DATA
{
			Name[50],
			Skin,
			Color,
			Players,
			RadioHackingTeam,
	bool:	RadioBroken,
	Float:	base_MinX,
	Float:	base_MinY,
	Float:	base_MaxX,
	Float:	base_MaxY,
	Float:	FlagX,
	Float:	FlagY,
	Float:	FlagZ,
			Zones,
			ZoneArea
};

new g_TeamInfo[MAX_TEAMS][E_TEAM_DATA];
new Iterator:Teams<MAX_TEAMS>;

new g_Team_IRC_Color[][MAX_TEAMS] =
{
    {""}, {"2"}, {"10"}, {"7"}, {"4"}, {"6"}, {"3"}, {"5"}, {"14"}
};

new g_TeamVehicleColors[MAX_TEAMS][2] =
{
	{0, 0},
	{201, 205},
	{98, 97},
	{194, 199},
 	{3, 85},
 	{179, 177},
	{174, 244},
 	{1, 140},
 	{16, 44}
};

/*----------------------------------------------------------------------------*/

/*----------------------------------------------------------------------------*/
enum
{
	res_none,
	res_check_useracc,
	res_load_useracc,
	res_register_user,
	res_check_ban,
	res_search_ban,
	res_insert_sv,
	res_load_sv,
	res_load_zones,
	res_load_teams,
	res_load_classes,
	res_load_bridges,
    res_set_level,
   	res_set_vip,
    res_load_spawns,
    res_load_shops,
    res_load_clans,
    res_fetch_level,
    res_fetch_vip,
    res_set_credits,
    res_fetch_cr
}

enum
{
    clan_res_checkname,
	clan_res_checktag,
	clan_res_assignfounder,
	clan_res_removemember,
	clan_res_setleader,
	clan_res_memlist,
	clan_res_delete
}

/*----------------------------------------------------------------------------*/

/*------------------------------- Nuclear ------------------------------------*/
enum E_NUKE_DATA
{
	Object,
	Time,
	RecentTeam,
	RecentZone,
	Type,
	Player,
	AffectedArea,
	TimeAffected
};

new g_Nuke[E_NUKE_DATA];

/*----------------------------------------------------------------------------*/

/*------------------------------- Textdraws ----------------------------------*/

enum E_TEXT_DRAWS
{
	PlayerText:	BG[4],
	PlayerText: TeamName,
	PlayerText:	Board_Header,
	PlayerText: Board_Contents,
	PlayerText:	Star,
	PlayerText:	ScoreRank,
	PlayerText: Rank,
	PlayerText: ASK[2],
	PlayerText: TeamSelection[3],
	PlayerText:	ScreenMsg[3],
	PlayerBar:	ZoneBar
};

new g_TextDraw[MAX_PLAYERS][E_TEXT_DRAWS];

/*----------------------------------------------------------------------------*/

/*------------------------------- Timers -------------------------------------*/
enum E_TIMER_DATA
{
	Teargas,
	Jail
}

new g_Timer[MAX_PLAYERS][E_TIMER_DATA];

/*----------------------------------------------------------------------------*/

/*------------------------------- Player -------------------------------------*/
new g_VIPName[4][7] = {
	{"None"},
	{"Bronze"},
	{"Silver"},
	{"Gold"}
};

enum 
{
	SPEC_TYPE_NONE,
	SPEC_TYPE_PLAYER,
	SPEC_TYPE_VEHICLE
}

enum
{
	PLAYER_STATUS_NONE,
	PLAYER_STATUS_SWITCHING_TEAM,
	PLAYER_STATUS_SWITCHING_CLASS
}

enum
{
    HS_BREAKHELMET,
    HS_KILLPLAYER
}

enum {
	W_FIST,
	W_KNIFE,
	W_SILENCED,
	W_DESERT_EAGLE,
	W_NORMAL_SHOTGUN,
	W_COMBAT_SHOTGUN,
	W_UZI,
	W_MP5,
	W_AK47,
	W_M4,
	W_TEC9,
	W_SNIPER,
	W_RIFLE,
	W_EXPLOSIVES
}

new g_WeaponKillsInName[MAX_WEAPON_TYPE][24] = {
	{"Fist"},
	{"Knife"},
	{"Silenced Pistol"},
	{"Desert Eagle"},
	{"Shotgun"},
	{"Combat Shotgun"},
	{"Micro UZI"},
	{"MP5"},
	{"AK-47"},
	{"M4"},
	{"Tec-9"},
	{"Sniper"},
	{"Country Rifle"},
	{"Explosives"}
};

enum E_PLAYER_DATA
{
bool:   Connected,
		Name[MAX_PLAYER_NAME],
		Pass[129],
		RecoveryPass[129],
		Ip[16],
		UserID,
		HelmetActivated,
		MaskActivated,
		BoostActivated,
		Credits,
		ClanID,
		ClanLeader,
		Team,
	 	PlayingTeam,
		Class,
		Score,
		Kills,
		Deaths,
		Money,
		Rank,
		Level,
		VIP,
		VIP_Time,
		Muted,
		Headshots,
		CapturedZones,
		CapturedFlags,
		Jailed,
		ChatMessage[128],
		ChatTime,
	 	KillStreak,
		ZoneStreak,
		SessionKills,
		SessionDeaths,
		SessionCaps,
		RegDate[24],
		LoginAttempts,
		Protected,
		WeaponKills[MAX_WEAPON_TYPE],
		Weapons[MAX_WEAPONS],
Text3D:	RankText
};

new g_Player[MAX_PLAYERS][E_PLAYER_DATA];

// Temporary in-game variables. Most of these variables only holds true/false.
// Used as the replacement for SetPVar/GetPVar.

enum
{
	PROTECTION_START,
	PROTECTION_END
}

enum E_VAR_DATA
{
			TempIP[16],
		    SupplyTime,
			PlayerStatus,
			SpecType,
			DrunkLevel,
			FPS,
			BridgeID,
			DM,
			SpawnPoint,
			JustRepaired,
			JustHealed,
			JustArmoured,
			SelectingClass,
			LastPM,
			RecentZone,
			ClassSpawned,
			WeaponClass,
			ReportTime,
			SupplyingVehicle,
			MuteWarns,
			BridgeTimer,
			Spawning,
			Mask,
			Helmet,
			HasMask,
			HasHelmet,
			CurrentVehicle,
			Warns,
			CurrentBaseSAM,
			StatsSaved,
			MediKits,
			AmmoPack,
			BulletsShot,
			BulletsHit,
			PauseCheck,
			VIPWepsUsed,
			VIPAmmoTime,
			Skin,
			Money,
			Score,
			LastKilled,
	bool:	DND,
	bool:	Duty,
	bool:	Spawned,
	bool:	Frozen,
	bool:	Headshot,
	bool:	HasBombs,
	bool:	HitSound,
	bool:	Assisting,
	bool:	LoggedIn,
	bool:   ViewingDialog,
	bool:   Timeout,
	bool:   PlayingInCW,
	bool:   WaitingRound,
			DeathCount,
			LastKillTime,
			CapturingFlag,
			TempClanSkin,
			RadioActionTeam,
			InvitedClan,
			ClanInvitePlayer,
			SquadID,
		    FromCommand,
			Disguised,
			DisKit,
			InvitedSquadID,
			DuelInvitePlayer,
			RequestedPlayer,
			JustReported,
			q_Asked,
			DuelID,
			BT_Used,
			UsingJetpack,
			DFR_Used,
			PausedFor,
			VSpawned,
			WeaponCheck,
			ReportedTime,
			ScreenMsgTime,
			CappingZone,
			Vehicle,
			PlayingCW,
			Warned,
			WeapTime,
			ViewingCmd
}

new g_Var[MAX_PLAYERS][E_VAR_DATA];

// Synchronization
enum E_SYNC_DATA
{
			Synced,
	Float:	Health,
	Float:	Armour,
	Float:	X,
	Float:	Y,
	Float:	Z,
	Float:	A,
			World,
			Int,
			Time
};

new g_SyncData[MAX_PLAYERS][E_SYNC_DATA];

// Admin spectate
enum E_SPEC_DATA
{
	Float:	Health,
	Float:	Armour,
	Float:	X,
	Float:	Y,
	Float:	Z,
	Float:	A,
			Weapon[MAX_WEAPON_SLOT],
			Ammo[MAX_WEAPON_SLOT],
			World,
			Int
};

new g_SpecData[MAX_PLAYERS][E_SPEC_DATA];
/*----------------------------------------------------------------------------*/

enum A_Cmds
{
	acmd_Level,
	acmd_Msg[144]
}

new g_AdminCmds[11][A_Cmds] = {
	{1, "  /reports, /kick, /spec, /specoff, /warn, /async, /aduty, /cc, /jail, /unjail, /mute, /check, /afk, /afklist, /tcsync,  /muted, /jailed"},
	{1, "  /acar, /abike, /aheli, /aboat, /frozen, /unmute, /freeze, /unfreeze /slap, /weaps, /rsv, /rsvall, /asay, /clearbox, /site, /miniguns"},
	{2, "  /apm, /disarm, /bancheck, /lockveh, /unlockveh, /getveh, /gotoveh, /explode, /fps, /pl, /goto, /get, /eject"},
    {2, "  /astats, /async, /ban, /tban, /flip, /unban"},
	{3, "  /healall, /armourall, /skin, /setskin, /v, /giveveh, /vcol, /fix, /fixall, /freezeall, /unfreezeall, /ints, /int"},
	{3, "  /exitint, /world, /delv, /ajp, /rsp, /cleancars, /sethp, /setarmour, /aka, /ip"},
	{4, "  /settime, /setweather, /getteam, /freezeteam, /unfreezeteam, /weapteam, /armteam, /hteam, /scoreteam, /rban, /disarmteam"},
	{4, "  /moneyteam, /xpteam, /gotozone, /forceteam, /forceclass, /dischat, /enchat, /msg, /weaponall, /moneyall, /scoreall, /xpall"},
	{4, "  /helmetall, /maskall, /ann, /givescore, /setping, /armour, /heal, /givecash, /givexp, /gotobase, /weapon, /giveweapon"},
	{5, "  /pos, /gotopos, /setdeaths, /setscore, /setxp, /setcash, /setkills, /giveweapon, /weapon, /setadmin"},
	{5, "  /savevehicle, /delvehicle, /addflag, /delflag, /cregister, /cdelete"}
};

/*----------------------------------------------------------------------------*/

/*-------------------------- Base SAM ------------------------------------*/
enum E_BASESAM_COORDS
{
	Float:	Team,
	Float:	X,
	Float:	Y,
	Float:	Z,
			Pickup,
			Time
}

new g_BaseSam[TERRORIST][E_BASESAM_COORDS];

/*----------------------------------------------------------------------------*/

/*------------------------------- Ranks --------------------------------------*/

enum E_RANK_DATA
{
			Name[30],
			Score,
	Float:	Armour
};

new g_RankInfo[MAX_RANKS][E_RANK_DATA] =
{
	{"Recruit", 			 0, 		0.00},
	{"Private", 		    50, 		2.00},
	{"Corporal", 		   100, 		5.00},
	{"Sergeant", 		   200, 		8.00},
	{"Lieutenant", 		   500, 		12.00},
	{"Veteran", 		  1000, 		20.00},
	{"Captain", 		  5000, 		25.00},
	{"Colonel", 		 10000, 		30.00},
	{"Major", 			 15000, 		35.00},
	{"Brigadier", 		 20000, 		40.00},
	{"General", 		 25000, 		50.00},
	{"Marshal", 		 50000, 		55.00},
	{"War Lord", 		100000, 		60.00}
};

/*----------------------------------------------------------------------------*/

/*------------------------------- Shops --------------------------------------*/
enum E_SHOP_DATA
{
			ID,
			Icon,
			TeamID,
			Area,
	Text3D:	Label,
	Float:	X,
	Float:	Y,
	Float:	Z
};

new g_Shop[MAX_SHOPS][E_SHOP_DATA];
new Iterator:Shops<MAX_SHOPS>;

/*----------------------------------------------------------------------------*/

/*-------------------------------- Reports -----------------------------------*/
enum e_REPORT_DATA
{
	bool:	Used,
			Name[35],
			By[30],
			Reason[84],
			Date[30]
}

new g_Report[10][e_REPORT_DATA];

/*----------------------------------------------------------------------------*/

/*------------------------------ Deathmatch ----------------------------------*/
// 1v1 duel
enum E_DUEL_DATA
{
	bool:   Started,
			Player1,
			Player2,
			Weapon1,
			Weapon2,
			Bet,
			Timer,
			Count
}

new g_Duel[MAX_DUELS][E_DUEL_DATA];

// DM arena
enum E_DM_DATA
{
	Name[24],
	Interior,
	World,
	Weapons[3]
}

new g_DM[MAX_DM][E_DM_DATA] =
{
	{"", 0, 0, {0, 0, 0}},
	{"Normal Deathmatch", 1, 7000, {24, 27, 31}},
	{"C-Bug Deathmatch", 16, 8000, {24, 25, 34}},
	{"Sniper Deathmatch", 4, 9000, {34, 0, 0}}
};

/*----------------------------------------------------------------------------*/

enum E_ADMIN_INTS
{
			int_Name[35],
			int_ID,
	Float:	int_X,
	Float:	int_Y,
	Float:	int_Z
}

new g_AdminInteriors[26][E_ADMIN_INTS] =
{
	{"", 0, 0.0, 0.0, 0.0},
    {"LS Atruim", 18, 1710.433715, -1669.379272, 20.225049},
	{"Warehouse 1", 0, 1059.895996, 2081.685791, 10.820312},
	{"Warehouse 2", 18, 1302.519897, -1.787510, 1001.028259},
	{"Vice Stadium", 1, -1401.829956, 107.051300, 1032.273437},
	{"Kickstart", 14, -1465.268676, 1557.868286, 1052.531250},
	{"Dirt Track", 4, -1444.645507, -664.526000, 1053.572998},
	{"Bloodbowl", 15, -1398.103515, 937.631164, 1036.479125},
	{"8-Track", 7, -1398.065307, -217.028900, 1051.115844},
	{"LV police HQ", 3, 288.745971, 169.350997, 1007.171875},
	{"SF police HQ", 10, 246.375991, 109.245994, 1003.218750},
	{"LS police HQ", 6, 246.783996, 63.900199, 1003.640625},
	{"RC Battlefield", 10, -975.975708, 1060.983032, 1345.671875},
	{"Liberty City (Outside)", 1, -729.276000, 503.086944, 1371.971801},
	{"Liberty City (Inside)", 1, -794.806396, 497.738037, 1376.195312},
	{"Pleasure Domes", 3, -2640.762939, 1406.682006, 906.460937},
	{"Strip Club", 2, 1204.809936, -11.586799, 1000.921875},
	{"Crack Factory", 2, 2543.462646, -1308.379882, 1026.728393},
	{"Madd Doggs Mansion", 5, 1267.663208, -781.323242, 1091.906250},
	{"LV Gym", 7, 773.579956, -77.096694, 1000.655029},
	{"SF Gym", 6, 774.213989, -48.924297, 1000.585937},
	{"LS Gym", 5, 772.111999, -3.898649, 1000.728820},
	{"Planning Dept.", 3, 384.808624, 173.804992,1008.382812},
	{"Sherman dDam", 17, -959.564392, 1848.576782, 9.000000},
	{"Meat Factory", 1, 963.418762, 2108.292480, 1011.030273},
	{"Jefferson Motel", 15, 2215.454833, -1147.475585, 1025.796875}
};

/*-----------------------===---- Spawns --------------------------------------*/
enum E_SPAWN_DATA
{
	Float:	X,
	Float:	Y,
	Float:	Z,
	Float:	A
};

enum E_SPAWN_DATA1
{
			TeamID,
			DM,
	Float:	X,
	Float:	Y,
	Float:	Z,
	Float:	A
}

new g_Spawn[MAX_SPAWNS][E_SPAWN_DATA1];

/*----------------------------------------------------------------------------*/

new g_VehicleNames[212][] =
{
	"Landstalker","Bravura","Buffalo","Linerunner","Pereniel","Sentinel","Dumper","Firetruck","Trashmaster","Stretch","Manana","Infernus",
	"Voodoo","Pony","Mule","Cheetah","Ambulance","Leviathan","Moonbeam","Esperanto","Taxi","Washington","Bobcat","Mr Whoopee","BF Injection",
	"Hunter","Premier","Enforcer","Securicar","Banshee","Predator","Bus","Rhino","Barracks","Hotknife","Trailer","Previon","Coach","Cabbie",
	"Stallion","Rumpo","RC Bandit","Romero","Packer","Monster","Admiral","Squalo","Seasparrow","Pizzaboy","Tram","Trailer","Turismo","Speeder",
	"Reefer","Tropic","Flatbed","Yankee","Caddy","Solair","Berkley's RC Van","Skimmer","PCJ-600","Faggio","Freeway","RC Baron","RC Raider",
	"Glendale","Oceanic","Sanchez","Sparrow","Patriot","Quad","Coastguard","Dinghy","Hermes","Sabre","Rustler","ZR3 50","Walton","Regina",
	"Comet","BMX","Burrito","Camper","Marquis","Baggage","Dozer","Maverick","News Chopper","Rancher","FBI Rancher","Virgo","Greenwood",
	"Jetmax","Hotring","Sandking","Blista Compact","Police Maverick","Boxville","Benson","Mesa","RC Goblin","Hotring Racer A","Hotring Racer B",
	"Bloodring Banger","Rancher","Super GT","Elegant","Journey","Bike","Mountain Bike","Beagle","Cropdust","Stunt","Tanker","RoadTrain",
	"Nebula","Majestic","Buccaneer","Shamal","Hydra","FCR-900","NRG-500","HPV1000","Cement Truck","Tow Truck","Fortune","Cadrona","FBI Truck",
	"Willard","Forklift","Tractor","Combine","Feltzer","Remington","Slamvan","Blade","Freight","Streak","Vortex","Vincent","Bullet","Clover",
	"Sadler","Firetruck","Hustler","Intruder","Primo","Cargobob","Tampa","Sunrise","Merit","Utility","Nevada","Yosemite","Windsor","Monster A",
	"Monster B","Uranus","Jester","Sultan","Stratum","Elegy","Raindance","RC Tiger","Flash","Tahoma","Savanna","Bandito","Freight","Trailer",
	"Kart","Mower","Duneride","Sweeper","Broadway","Tornado","AT-400","DFT-30","Huntley","Stafford","BF-400","Newsvan","Tug","Trailer A","Emperor",
	"Wayfarer","Euros","Hotdog","Club","Trailer B","Trailer C","Andromada","Dodo","RC Cam","Launch","Police Car (LSPD)","Police Car (SFPD)",
	"Police Car (LVPD)","Police Ranger","Picador","S.W.A.T. Van","Alpha","Phoenix","Glendale","Sadler","Luggage Trailer A","Luggage Trailer B",
	"Stair Trailer","Boxville","Farm Plow","Utility Trailer"
};

new g_BuyableWeaponID[18][1] =
{
    {4}, {9}, {33}, {34}, {27}, {28}, {29}, {24}, {22},
	{31}, {23}, {32}, {25}, {30}, {17}, {18}, {16}, {35}
};

new aWeaponNames[][32] =
{
	{"Unarmed (Fist)"}, 		// 0
	{"Brass Knuckles"}, 		// 1
	{"Golf Club"}, 				// 2
	{"Night Stick"}, 			// 3
	{"Knife"}, 					// 4
	{"Baseball Bat"}, 			// 5
	{"Shovel"}, 				// 6
	{"Pool Cue"}, 				// 7
	{"Katana"}, 				// 8
	{"Chainsaw"}, 				// 9
	{"Purple Dildo"}, 			// 10
	{"Big White Vibrator"}, 	// 11
	{"Medium White Vibrator"}, 	// 12
	{"Small White Vibrator"}, 	// 13
	{"Flowers"}, 				// 14
	{"Cane"}, 					// 15
	{"Grenade"}, 				// 16
	{"Teargas"}, 				// 17
	{"Molotov"}, 				// 18
	{" "}, 						// 19
	{" "}, 						// 20
	{" "}, 						// 21
	{"Colt 45"}, 				// 22
	{"Colt 45 (Silenced)"}, 	// 23
	{"Desert Eagle"}, 			// 24
	{"Normal Shotgun"}, 		// 25
	{"Sawnoff Shotgun"}, 		// 26
	{"Combat Shotgun"}, 		// 27
	{"Micro Uzi (Mac 10)"}, 	// 28
	{"MP5"}, 					// 29
	{"AK47"}, 					// 30
	{"M4"}, 					// 31
	{"Tec9"}, 					// 32
	{"Country Rifle"}, 			// 33
	{"Sniper Rifle"}, 			// 34
	{"Rocket Launcher"}, 		// 35
	{"Heat-Seeking Rocket Launcher"}, // 36
	{"Flamethrower"}, 			// 37
	{"Minigun"}, 				// 38
	{"Satchel Charge"}, 		// 39
	{"Detonator"}, 				// 40
	{"Spray Can"}, 				// 41
	{"Fire Extinguisher"}, 		// 42
	{"Camera"}, 				// 43
	{"Night Vision Goggles"}, 	// 44
	{"Infrared Vision Goggles"}, // 45
	{"Parachute"}, 					// 46
	{"Fake Pistol"}, 				// 47
	{" "},                          // 48
	{"Vehicle"},                    // 49
	{"Heliblade"},                  // 50
	{"Explosion"},                  // 51
	{" "},                          // 52
	{"Drown"},                  	// 53
	{"Splat"}	                  	// 54
};

/*------------------------------- Vehicles -----------------------------------*/

enum
{
	VEHICLE_TYPE_NONE,
	VEHICLE_TYPE_HYDRA,
	VEHICLE_TYPE_HUNTER,
	VEHICLE_TYPE_SPARROW,
	VEHICLE_TYPE_RHINO
}

enum E_VEHICLE_DATA
{
			dbID,
			DriverID,
			BombLoadCounter,
			BombLoadTimer,
	Text3D:	TimeDisplayLabel,
	bool:	Loaded,
	bool:	BombingPlane,
	bool:	Bombed,
	bool:	Static,
			Type,
			SupplyingPlayer
}
new g_Vehicle[MAX_VEHICLES][E_VEHICLE_DATA];

enum E_ARMED_VEHICLE_DATA
{
			av_RequiredRank,
	Float:	av_Health
}

new g_ArmedVehicle[5][E_ARMED_VEHICLE_DATA] =
{
	{0, 0.0},
	{4, 500.0}, // Hydra
	{5, 500.0}, // Hunter
	{3, 800.0}, // Sparrow
	{3, 5000.0} // Rhino
};

/*----------------------------------------------------------------------------*/

/*------------------------------- Squads ------===----------------------------*/

enum E_SQUAD_DATA
{
	sq_Name[15],
	sq_Team,
	sq_Members[MAX_SQUAD_MEMBERS]
}

new g_Squads[MAX_SQUADS][E_SQUAD_DATA];

new Iterator:Squads<MAX_SQUADS>;
new Iterator:SquadMembers[MAX_SQUADS]<MAX_SQUAD_MEMBERS>;

/*----------------------------------------------------------------------------*/

/*------------------------------- Zones --------------------------------------*/
// Capture
enum E_ZONE_DATA
{
			Name[50],
	Float:	PointX,
	Float:	PointY,
	Float:	PointZ,
	Float:	ZoneMinX,
	Float:	ZoneMinY,
	Float:	ZoneMaxX,
	Float:	ZoneMaxY,
	Float:	SpawnX,
	Float:	SpawnY,
	Float:	SpawnZ,
	Float:	SpawnA,
			Team,
			Pickup,
			PointArea,
			Icon,
			Zone,
	bool:	Capturing,
	bool:   HasFlag,
			CappingPlayer,
	Float:	CapTime,
			Area,
			CapturingTeam,
	Text3D:	Label,
			CheckPoint,
	Float:	TotalCapTime,
			Score,
			AmmoTime
};

new g_CapZone[MAX_CZ][E_ZONE_DATA];
new Iterator:Zones<MAX_CZ>;

new Float:cap_Time[4][] = {
	0.0,
	0.50,
	1.00,
	1.50
};

// Flags
enum E_ZONEFLAG_DATA
{
			Pickup,
			FlagObject,
			HoldingObj,
	Float:	FlagX,
	Float:	FlagY,
	Float:	FlagZ,
			Time,
	Text3D:	FlagLabel,
	bool:	Captured,
			CapturedTeam,
			CapturingPlayer
}

new g_ZoneFlags[MAX_CZ][E_ZONEFLAG_DATA];

/*----------------------------------------------------------------------------*/

/*------------------------------ Clans ---------------------------------------*/
enum E_CW_COORDINATES
{
			Interior,
	Float:  MainSpawnX,
	Float:  MainSpawnY,
	Float:  MainSpawnZ,
	Float:  MainSpawnA,
	Float:  clan1_SX,
	Float:  clan1_SY,
	Float:  clan1_SZ,
	Float:  clan1_SA,
	Float:  clan2_SX,
	Float:  clan2_SY,
	Float:  clan2_SZ,
	Float:  clan2_SA
}

new g_CWSpawns[4][E_CW_COORDINATES] =
{
	{0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0},
    {10, -1062.4181, 1068.4590, 1358.9142, 87.9344, -974.5332, 1060.9845, 1345.6772, 88.7094, -1130.6205, 1057.8020, 1346.4141, 270.1719},
	{0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0},
	{0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0}
};

new g_CWInteriorName[4][24] =
{
	{"N/A"},
	{"RC Battlefield"},
	{"-"},
	{"-"}
};

enum E_CLANWAR_DATA
{
	bool:   Started,
			Clan1,
			Clan2,
			Clan1_Members,
			Clan2_Members,
			Clan1_Win,
			Clan2_Win,
			Rounds,
			MaxRounds,
			Members,
			Timer,
			Counter,
			Bet,
			Interior,
	Text: 	TD_Main,
	Text: 	TD_Clan1,
	Text: 	TD_Clan2
}

new g_ClanWar[MAX_CLANWAR][E_CLANWAR_DATA];

enum E_CLAN_DATA
{
	bool:   Exist,
			Name[36],
			Tag[10],
			Founder[24],
			Motto[100],
			Registered[24],
			Points,
			Skin,
			MemberCount,
			CW_Requested,
			CW_Win,
			CW_Lost,
			CW_InvitingPlayer,
  	bool:   CW_Invited
}

new g_Clans[MAX_CLANS][E_CLAN_DATA];
new Iterator:Clans<MAX_CLANS>;

/*----------------------------------------------------------------------------*/
new g_TimedMsgs[][144] =
{
	{"If you caught any hacker/cheater or rule breaker, please '/report' them."},
	{"Buy anti teargas mask and helmet from the weapon shop to avoid teargas and getting headshot."},
	{"You can donate too become a VIP along with side perks that helps you boost your stats. Type '/donate' for more info."},
	{"The nuclear bomb takes 10 minutes to be fully charged once used. Use '/times' to see the remaining time."},
	{"Please respect all the players and staff members."},
	{"You can type '/topclans' to see the list of top 10 clans."},
	{"You can use '/set' to toggle stuff for your character."},
	{"Use '/affected' to see which area is currently affected by the nuclear bomb."},
	{"You can capture zones to earn score and money. Read '/help' for more info."},
	{"The nuclear effect in the targeted area will last until the nuclear bomb is fully charged. Type '/nukehelp' for more."},
	{"Wear an anti teargas mask while you are inside the nuclear affected area to avoid getting affected."}
};

new g_Reporter[MAX_PLAYERS];
new g_HealthPickup[MAX_PLAYERS];
new g_ArmourPickup[MAX_PLAYERS];
new g_RconAttempts[MAX_PLAYERS];
new g_SpecID[MAX_PLAYERS];

new Text:	text_NewsBox[MAX_NEWSBOX_CONTENTS];

new Float:	newsbox_Y[MAX_NEWSBOX_CONTENTS][1] =
{
	{0.0}, {430.0}, {420.0}, {410.0}, {400.0}, {390.0}, {380.0}
};

new g_VehicleMods[8][2] = {
	{1138, 1049},
	{1033, 1053},
	{1026, 1045},
	{1028, 1080},
	{1085, 1087},
	{1087, 1153},
	{1169, 1153},
	{1141, 1151}
};

new Float:	g_WD_DroppedX[MAX_PLAYERS][MAX_WEAPON_SLOT];
new Float:	g_WD_DroppedY[MAX_PLAYERS][MAX_WEAPON_SLOT];
new Float:	g_WD_DroppedZ[MAX_PLAYERS][MAX_WEAPON_SLOT];

new g_RegisteringPassword[MAX_PLAYERS][129];
new g_RegisteringClan[MAX_PLAYERS][45];
new g_RegisteringClanTag[MAX_PLAYERS][10];
new g_NewsString[MAX_NEWSBOX_CONTENTS][128];
new g_SyncWeaponData[MAX_PLAYERS][MAX_WEAPON_SLOT][2];
new g_WD_Data[MAX_PLAYERS][MAX_WEAPON_SLOT][3];
new g_WD_Pickup[MAX_PLAYERS][MAX_WEAPON_SLOT];

new connection;

new g_CmdTitle[][36] = {
	{"Messaging commands"},
	{"Player commands"},
	{"Team and class commands"},
	{"Help commands"},
	{"Server commands"},
	{"Account commands"},
	{"Squad commands"}
};
	
enum {
	CMD_MESSAGING,
	CMD_PLAYER,
	CMD_TEAM_CLASS,
	CMD_HELP,
	CMD_SERVER,
	CMD_ACCOUNT,
	CMD_SQUAD
}

enum E_CMD_DATA
{
	cmd_ID,
	cmd_Text[128]
}

new g_Cmd[][E_CMD_DATA] =
{
    {CMD_MESSAGING, "Full\tShort\tDescription"},
	{CMD_MESSAGING, ""#sc_green"/pm\t-\t"#sc_lightgrey"Send a private message."},
	{CMD_MESSAGING, ""#sc_green"/rpm\t-\t"#sc_lightgrey"Reply to a private message."},
	{CMD_MESSAGING, ""#sc_green"/irc\t-\t"#sc_lightgrey"Send a message to IRC."},
	{CMD_MESSAGING, ""#sc_green"/say\t"#sc_green"/s\t"#sc_lightgrey"Chat with nearby players."},
	{CMD_MESSAGING, ""#sc_green"/radio\t"#sc_green"/r\t"#sc_lightgrey"Talk with your teammates."},
	{CMD_MESSAGING, ""#sc_green"/ask\t-\t"#sc_lightgrey"Ask a question to online administrators"},
	
    {CMD_PLAYER, "Full\tShort\tDescription"},
	{CMD_PLAYER, ""#sc_green"/kill\t-\t"#sc_lightgrey"Commit suicide."},
	{CMD_PLAYER, ""#sc_green"/stats\t-\t"#sc_lightgrey"Display statistics."},
	{CMD_PLAYER, ""#sc_green"/wepstats\t-\t"#sc_lightgrey"Display weapon statistics."},
	{CMD_PLAYER, ""#sc_green"/sp\t-\t"#sc_lightgrey"Set spawn point."},
	{CMD_PLAYER, ""#sc_green"/rank\t-\t"#sc_lightgrey"Display a list of ranks."},
	{CMD_PLAYER, ""#sc_green"/spree\t-\t"#sc_lightgrey"Display current spree."},
	{CMD_PLAYER, ""#sc_green"/settings\t"#sc_green"/set\t"#sc_lightgrey"Open settings to toggle stuff."},
	{CMD_PLAYER, ""#sc_green"/qdm\t-\t"#sc_lightgrey"Quit deathmatch stadium"},
	{CMD_PLAYER, ""#sc_green"/sync\t-\t"#sc_lightgrey"Synchronize yourself"},
	{CMD_PLAYER, ""#sc_green"/inventory\t"#sc_green"/inv\t"#sc_lightgrey"Display inventory items"},
	{CMD_PLAYER, ""#sc_green"/givemoney\t"#sc_green"/gm\t"#sc_lightgrey"Give your money to other players."},
	{CMD_PLAYER, ""#sc_green"/para\t-\t"#sc_lightgrey"Emergency parachute for $500."},
	{CMD_PLAYER, ""#sc_green"/duel\t-\t"#sc_lightgrey"Send a duel request to other player."},
	{CMD_PLAYER, ""#sc_green"/cduel\t-\t"#sc_lightgrey"Cancel a duel request."},
	{CMD_PLAYER, ""#sc_green"/vfeat\t-\t"#sc_lightgrey"Display VIP features."},

    {CMD_TEAM_CLASS, "Full\tShort\tDescription"},
	{CMD_TEAM_CLASS, ""#sc_green"/switchteam\t"#sc_green"/st\t"#sc_lightgrey"Switch your team."},
	{CMD_TEAM_CLASS, ""#sc_green"/reclass\t"#sc_green"/rc\t"#sc_lightgrey"Switch your class."},
	{CMD_TEAM_CLASS, ""#sc_green"/h\t-\t"#sc_lightgrey"Heal your teammates. (VIP and Paramedic classes only)"},
	{CMD_TEAM_CLASS, ""#sc_green"/rbridge\t-\t"#sc_lightgrey"Repair a collapsed bridge."},
	{CMD_TEAM_CLASS, ""#sc_green"/bridges\t-\t"#sc_lightgrey"Display a list of bridges."},
	{CMD_TEAM_CLASS, ""#sc_green"/supply\t-\t"#sc_lightgrey"Supply team with armour, health and weapons. (Supporter class only)"},
	{CMD_TEAM_CLASS, ""#sc_green"/load\t-\t"#sc_lightgrey"Load supplies to your vehicle. (Supporter class only)"},
	{CMD_TEAM_CLASS, ""#sc_green"/plant\t-\t"#sc_lightgrey"Plant bombs under the bridge. (Demolisher class only)"},
	{CMD_TEAM_CLASS, ""#sc_green"/disguise\t"#sc_green"/dis\t"#sc_lightgrey"Disguise as enemy team. (Spy class only)"},
	{CMD_TEAM_CLASS, ""#sc_green"/undis\t-\t"#sc_lightgrey"Un-disguise yourself."},
	{CMD_TEAM_CLASS, ""#sc_green"/repair\t-\t"#sc_lightgrey"Repair team's vehicle. (Engineer class only)"},
	
    {CMD_HELP, "Full\tShort\tDescription"},
	{CMD_HELP, ""#sc_green"/help\t-\t"#sc_lightgrey"Display help about server."},
	{CMD_HELP, ""#sc_green"/zonehelp\t-\t"#sc_lightgrey"Display help about zone system."},
	{CMD_HELP, ""#sc_green"/flaghelp\t-\t"#sc_lightgrey"Display help about flag system."},
	{CMD_HELP, ""#sc_green"/chelp\t-\t"#sc_lightgrey"Display help about your current class."},
	{CMD_HELP, ""#sc_green"/bshelp\t-\t"#sc_lightgrey"Display help about base SAM system."},
	{CMD_HELP, ""#sc_green"/bridgehelp\t-\t"#sc_lightgrey"Display help about bridge system."},
	{CMD_HELP, ""#sc_green"/nukehelp\t-\t"#sc_lightgrey"Display help about nuclear system."},
	{CMD_HELP, ""#sc_green"/abhelp\t-\t"#sc_lightgrey"Display help about andromada bombing system."},
	{CMD_HELP, ""#sc_green"/invhelp\t-\t"#sc_lightgrey"Display help about inventory system."},
	{CMD_HELP, ""#sc_green"/mhelp\t-\t"#sc_lightgrey"Display help about MOAB bomb system."},
	{CMD_HELP, ""#sc_green"/rhelp\t-\t"#sc_lightgrey"Display help about radio station's features."},
    
    {CMD_SERVER, "Full\tShort\tDescription"},
	{CMD_SERVER, ""#sc_green"/report\t-\t"#sc_lightgrey"Report a player to online administrators."},
	{CMD_SERVER, ""#sc_green"/vips\t-\t"#sc_lightgrey"Display a list of online VIPs."},
	{CMD_SERVER, ""#sc_green"/admins\t-\t"#sc_lightgrey"Display a list of on-duty administrators."},
	{CMD_SERVER, ""#sc_green"/serverstats\t-\t"#sc_lightgrey"Display server statistics."},
	{CMD_SERVER, ""#sc_green"/affected\t-\t"#sc_lightgrey"Display the name of area currently affected by the nuclear bomb."},
	{CMD_SERVER, ""#sc_green"/richlist\t-\t"#sc_lightgrey"Display a list of top 10 richest players online."},
	{CMD_SERVER, ""#sc_green"/topstats\t-\t"#sc_lightgrey"Display a list of players with top statistics."},
	{CMD_SERVER, ""#sc_green"/times\t-\t"#sc_lightgrey"Display a list of super weapons time."},
	{CMD_SERVER, ""#sc_green"/teams\t-\t"#sc_lightgrey"Display a list of teams."},
	{CMD_SERVER, ""#sc_green"/ranks\t-\t"#sc_lightgrey"Display a list of ranks."},
	{CMD_SERVER, ""#sc_green"/rules\t-\t"#sc_lightgrey"Display a list of server rules."},
	{CMD_SERVER, ""#sc_green"/getid\t-\t"#sc_lightgrey"Search ID of players."},
	
	{CMD_ACCOUNT, "Full\tShort\tDescription"},
    {CMD_ACCOUNT, ""#sc_green"/changepass\t-\t"#sc_lightgrey"Change your account's password."},
 	
 	{CMD_SQUAD, "Full\tShort\tDescription"},
 	{CMD_SQUAD, ""#sc_green"/squads\t-\t"#sc_lightgrey"Display a list of craeted squads."},
 	{CMD_SQUAD, ""#sc_green"/screate\t-\t"#sc_lightgrey"Create a squad."},
 	{CMD_SQUAD, ""#sc_green"/sinfo\t-\t"#sc_lightgrey"Display information of a squad."},
 	{CMD_SQUAD, ""#sc_green"/invite\t-\t"#sc_lightgrey"Invite a player to your squad (For leader only)."},
 	{CMD_SQUAD, ""#sc_green"/qsquad\t-\t"#sc_lightgrey"Quit a squad."},
 	{CMD_SQUAD, ""#sc_green"/skick\t-\t"#sc_lightgrey"Kick a squad member. (For leader only)"},
  	{CMD_SQUAD, ""#sc_green"/sname\t-\t"#sc_lightgrey"Change the squad name. (For leader only)"},
 	{CMD_SQUAD, ""#sc_green"/sdrop\t-\t"#sc_lightgrey"Drop a squad. (For leader only)."}
};

GivePlayerWeaponEx(playerid, weaponid, ammo)
{
	g_Player[playerid][Weapons][weaponid] = 1;
	GivePlayerWeapon(playerid, weaponid, ammo);
}

new
    g_pLastCBCall[MAX_PLAYERS],
    g_pCBSpamWarns[MAX_PLAYERS]
;

#if defined _ALS_GivePlayerWeapon
	#undef GivePlayerWeapon
#else
	#define _ALS_GivePlayerWeapon
#endif

#define GivePlayerWeapon GivePlayerWeaponEx

ResetPlayerWeaponEx(playerid)
{
	for (new i = 0, j = 47; i < j; i++)
	{
		g_Player[playerid][Weapons][i] = 0;
	}
	ResetPlayerWeapons(playerid);
}

#if defined _ALS_ResetPlayerWeapons
	#undef ResetPlayerWeapons
#else
	#define _ALS_ResetPlayerWeapons
#endif

#define ResetPlayerWeapons ResetPlayerWeaponEx
