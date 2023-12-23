CreateBackground(playerid)
{
	TD(playerid, BG)[0] = CreatePlayerTextDraw(playerid, 320.0, 335.0, "~w~~h~CALL DUTY");
	PlayerTextDrawAlignment(playerid, TD(playerid, BG)[0], 2);
	PlayerTextDrawLetterSize(playerid, TD(playerid, BG)[0], 0.87, 4.8);
	PlayerTextDrawColor(playerid, TD(playerid, BG)[0], -86);
	PlayerTextDrawSetOutline(playerid, TD(playerid, BG)[0], 0);
	PlayerTextDrawSetShadow(playerid, TD(playerid, BG)[0], 0);
	PlayerTextDrawUseBox(playerid, TD(playerid, BG)[0], 1);
	PlayerTextDrawBoxColor(playerid, TD(playerid, BG)[0], 304422724);
	PlayerTextDrawTextSize(playerid, TD(playerid, BG)[0], 0.0, 640.0);

	TD(playerid, BG)[1] = CreatePlayerTextDraw(playerid, 206.0, 381.0, "~y~~h~W A R G R O U N D");
	PlayerTextDrawLetterSize(playerid, TD(playerid, BG)[1], 0.679996, 1.399996);
	PlayerTextDrawSetOutline(playerid, TD(playerid, BG)[1], 1);

	TD(playerid, BG)[2] = CreatePlayerTextDraw(playerid, 313.0, 347.0, "~w~~h~OF");
	PlayerTextDrawAlignment(playerid, TD(playerid, BG)[2], 2);
	PlayerTextDrawLetterSize(playerid, TD(playerid, BG)[2], 0.289999, 2.099998);
	PlayerTextDrawColor(playerid, TD(playerid, BG)[2], -86);
	PlayerTextDrawSetOutline(playerid, TD(playerid, BG)[2], 0);
	PlayerTextDrawSetShadow(playerid, TD(playerid, BG)[2], 0);

	TD(playerid, BG)[3] = CreatePlayerTextDraw(playerid, 318.0, 399.0, "v"#server_version"~n~~n~~w~~h~www.teamdss.com");
	PlayerTextDrawAlignment(playerid, TD(playerid, BG)[3], 2);
	PlayerTextDrawLetterSize(playerid, TD(playerid, BG)[3], 0.309998, 1.099998);
	PlayerTextDrawSetOutline(playerid, TD(playerid, BG)[3], 0);
	PlayerTextDrawSetShadow(playerid, TD(playerid, BG)[3], 1);
	
	for (new i = 0, j = 4; i != j; ++i)
	{
	    PlayerTextDrawShow(playerid, TD(playerid, BG)[i]);
	}
}


TD_Load(bool:gamemode, playerid = INVALID_PLAYER_ID)
{
	if (gamemode == true && playerid == INVALID_PLAYER_ID)
	{
		text_NewsBox[0] = TextDrawCreate(250.0, 354.0, "I");
		TextDrawLetterSize(text_NewsBox[0], 54.299743, 11.900001);
		TextDrawColor(text_NewsBox[0], 0x00000033);
		TextDrawSetOutline(text_NewsBox[0], 0);
		TextDrawSetShadow(text_NewsBox[0], 0);

		for(new i = 1, j = MAX_NEWSBOX_CONTENTS; i < j; i++)
		{
			text_NewsBox[i]  = TextDrawCreate(636.0, newsbox_Y[i][0], " ");
			TextDrawAlignment(text_NewsBox[i], 3);
			TextDrawLetterSize(text_NewsBox[i], 0.179998, 1.1);
			TextDrawSetOutline(text_NewsBox[i], 0);
			TextDrawSetShadow(text_NewsBox[i], 0);
		}
		
		Server(AnnText) = TextDrawCreate(320.0, 157.0, " ");
		TextDrawAlignment(Server(AnnText), 2);
		TextDrawBackgroundColor(Server(AnnText), 255);
		TextDrawLetterSize(Server(AnnText), 0.389997, 2.299997);
		TextDrawSetOutline(Server(AnnText), 1);
		
		Server(Website) = TextDrawCreate(266.0, 3.0, "www.teamdss.com");
		TextDrawBackgroundColor(Server(Website), 51);
		TextDrawLetterSize(Server(Website), 0.349999, 1.299998);
		TextDrawSetOutline(Server(Website), 1);
		
		Server(CmdsText) = TextDrawCreate(45.0, 431.0, "/HELP /CMDS /RULES /DONATE");
		TextDrawBackgroundColor(Server(CmdsText), 51);
		TextDrawLetterSize(Server(CmdsText), 0.159998, 0.899999);
		TextDrawSetOutline(Server(CmdsText), 1);
		
		Server(BombTime) = TextDrawCreate(630.0, 330.0, " ");
		TextDrawAlignment(Server(BombTime), 3);
		TextDrawBackgroundColor(Server(BombTime), 85);
		TextDrawLetterSize(Server(BombTime), 0.260000, 1.399999);
		TextDrawSetOutline(Server(BombTime), 1);
	}
	else
	{
	    TD(playerid, ZoneBar) = 							CreatePlayerProgressBar(playerid, 154.0, 426.0, 7.0, 140.699996, 0xD9262BFF, 0.0, BAR_DIRECTION_UP);
		
		TD(playerid, TeamName) =							CreatePlayerTextDraw(playerid,577.0, 23.0, " ");
		PlayerTextDrawAlignment(playerid,					TD(playerid, TeamName), 2);
		PlayerTextDrawBackgroundColor(playerid,				TD(playerid, TeamName), 68);
		PlayerTextDrawFont(playerid,						TD(playerid, TeamName), 3);
		PlayerTextDrawLetterSize(playerid,					TD(playerid, TeamName), 0.319997, 1.399999);
		PlayerTextDrawSetOutline(playerid,					TD(playerid, TeamName), 1);
		
		TD(playerid, Board_Header) =						CreatePlayerTextDraw(playerid, 39.0, 299.0, "~w~~h~Class~n~Kills~n~Deaths~n~Ratio");
		PlayerTextDrawBackgroundColor(playerid, 			TD(playerid, Board_Header), 34);
		PlayerTextDrawLetterSize(playerid, 					TD(playerid, Board_Header), 0.219986, 0.799987);
		PlayerTextDrawSetOutline(playerid, 					TD(playerid, Board_Header), 1);
		PlayerTextDrawUseBox(playerid, 						TD(playerid, Board_Header), 1);
		PlayerTextDrawBoxColor(playerid, 					TD(playerid, Board_Header), 0x00000022);
		PlayerTextDrawTextSize(playerid, 					TD(playerid, Board_Header), 73.0, 107.0);

		TD(playerid, Board_Contents) = 						CreatePlayerTextDraw(playerid, 77.0, 299.0, " ");
		PlayerTextDrawBackgroundColor(playerid, 			TD(playerid, Board_Contents), 34);
		PlayerTextDrawLetterSize(playerid, 					TD(playerid, Board_Contents), 0.219984, 0.799986);
		PlayerTextDrawSetOutline(playerid, 					TD(playerid, Board_Contents), 1);
		PlayerTextDrawUseBox(playerid, 						TD(playerid, Board_Contents), 1);
		PlayerTextDrawBoxColor(playerid, 					TD(playerid, Board_Contents), 0x00000022);
		PlayerTextDrawTextSize(playerid, 					TD(playerid, Board_Contents), 135.0, 107.0);
		
		TD(playerid, Star) = 								CreatePlayerTextDraw(playerid, 484.0, 97.0, "~y~~h~]");
		PlayerTextDrawBackgroundColor(playerid,				TD(playerid, Star), 0x00000022);
		PlayerTextDrawFont(playerid,						TD(playerid, Star), 2);
		PlayerTextDrawLetterSize(playerid,					TD(playerid, Star), 0.9899, 3.2);
		PlayerTextDrawSetOutline(playerid,					TD(playerid, Star), 1);
		
		TD(playerid, Rank) = 								CreatePlayerTextDraw(playerid, 500.0, 106, "0");
		PlayerTextDrawAlignment(playerid,					TD(playerid, Rank), 2);
		PlayerTextDrawLetterSize(playerid,					TD(playerid, Rank), 0.2199, 1.3999);
		PlayerTextDrawSetOutline(playerid,					TD(playerid, Rank), 0);
		PlayerTextDrawSetShadow(playerid,					TD(playerid, Rank), 0);

		TD(playerid, ScoreRank) = 							CreatePlayerTextDraw(playerid, 517.0, 98.0, " ");
		PlayerTextDrawBackgroundColor(playerid,				TD(playerid, ScoreRank), 0x000000FF);
		PlayerTextDrawFont(playerid,						TD(playerid, ScoreRank), 3);
		PlayerTextDrawLetterSize(playerid,					TD(playerid, ScoreRank), 0.239995, 1.399996);
		PlayerTextDrawSetOutline(playerid,					TD(playerid, ScoreRank), 1);

		TD(playerid, ScreenMsg)[0] = 						CreatePlayerTextDraw(playerid, 448.0, 248.0, "I");
		PlayerTextDrawLetterSize(playerid, 					TD(playerid, ScreenMsg)[0], -20.419982, 7.699997);
		PlayerTextDrawColor(playerid, 						TD(playerid, ScreenMsg)[0], 0x00000033);
		PlayerTextDrawSetOutline(playerid, 					TD(playerid, ScreenMsg)[0], 0);
		PlayerTextDrawSetShadow(playerid, 					TD(playerid, ScreenMsg)[0], 0);

		TD(playerid, ScreenMsg)[1] = 						CreatePlayerTextDraw(playerid, 319.0, 267.0, " ");
		PlayerTextDrawAlignment(playerid, 					TD(playerid, ScreenMsg)[1], 2);
		PlayerTextDrawLetterSize(playerid, 					TD(playerid, ScreenMsg)[1], 0.349999, 1.399999);
		PlayerTextDrawColor(playerid, 						TD(playerid, ScreenMsg)[1], -454177281);
		PlayerTextDrawSetOutline(playerid, 					TD(playerid, ScreenMsg)[1], 1);

		TD(playerid, ScreenMsg)[2] = 						CreatePlayerTextDraw(playerid, 314.0, 281.0, " ");
		PlayerTextDrawAlignment(playerid, 					TD(playerid, ScreenMsg)[2], 2);
		PlayerTextDrawFont(playerid, 						TD(playerid, ScreenMsg)[2], 3);
		PlayerTextDrawLetterSize(playerid, 					TD(playerid, ScreenMsg)[2], 0.529999, 2.399998);
		PlayerTextDrawSetOutline(playerid, 					TD(playerid, ScreenMsg)[2], 1);
		
		TD(playerid, ASK)[0] = 								CreatePlayerTextDraw(playerid, 267.0, 361.0, "I");
		PlayerTextDrawLetterSize(playerid,	 				TD(playerid, ASK)[0], 47.899765, 1.799998);
		PlayerTextDrawColor(playerid,			 			TD(playerid, ASK)[0], 0x00000033);
		PlayerTextDrawSetOutline(playerid, 					TD(playerid, ASK)[0], 0);
		PlayerTextDrawSetShadow(playerid, 					TD(playerid, ASK)[0], 0);

		TD(playerid, ASK)[1] = 								CreatePlayerTextDraw(playerid, 424.0, 366.0, " ");
		PlayerTextDrawLetterSize(playerid, 					TD(playerid, ASK)[1], 0.18, 0.699999);
		PlayerTextDrawSetOutline(playerid,				 	TD(playerid, ASK)[1], 0);
		PlayerTextDrawSetShadow(playerid, 					TD(playerid, ASK)[1], 0);
		
		TD(playerid, TeamSelection)[0] = 					CreatePlayerTextDraw(playerid,517.0, 112.0, "I");
		PlayerTextDrawAlignment(playerid,TD(playerid, 		TeamSelection)[0], 2);
		PlayerTextDrawBackgroundColor(playerid,TD(playerid, TeamSelection)[0], 255);
		PlayerTextDrawLetterSize(playerid,TD(playerid, 		TeamSelection)[0], 22.470048, 7.6);
		PlayerTextDrawColor(playerid,TD(playerid, 			TeamSelection)[0], 0x00000044);
		PlayerTextDrawSetOutline(playerid,TD(playerid, 		TeamSelection)[0], 0);

		TD(playerid, TeamSelection)[1] = 					CreatePlayerTextDraw(playerid,531.0, 153.0, " ");
		PlayerTextDrawAlignment(playerid,TD(playerid, 		TeamSelection)[1], 2);
		PlayerTextDrawLetterSize(playerid,TD(playerid, 		TeamSelection)[1], 0.529999, 1.499999);
		PlayerTextDrawSetOutline(playerid,TD(playerid, 		TeamSelection)[1], 1);

		TD(playerid, TeamSelection)[2] = 					CreatePlayerTextDraw(playerid,478.0, 128.0, " ");
		PlayerTextDrawFont(playerid,TD(playerid, 			TeamSelection)[2], 3);
		PlayerTextDrawLetterSize(playerid,TD(playerid, 		TeamSelection)[2], 0.569998, 2.499999);
		PlayerTextDrawSetOutline(playerid,TD(playerid, 		TeamSelection)[2], 1);
		
		TD(playerid, TeamSelection)[0] = 					CreatePlayerTextDraw(playerid,517.0, 62.0, "I");
		PlayerTextDrawAlignment(playerid,TD(playerid, 		TeamSelection)[0], 2);
		PlayerTextDrawBackgroundColor(playerid,TD(playerid, TeamSelection)[0], 255);
		PlayerTextDrawLetterSize(playerid,TD(playerid, 		TeamSelection)[0], 22.470048, 7.60);
		PlayerTextDrawColor(playerid,TD(playerid, 			TeamSelection)[0], 68);
		PlayerTextDrawSetOutline(playerid,TD(playerid, 		TeamSelection)[0], 0);
		PlayerTextDrawSetShadow(playerid,TD(playerid, 		TeamSelection)[0], 0);

		TD(playerid, TeamSelection)[1] = 					CreatePlayerTextDraw(playerid,531.0, 103.0, " ");
		PlayerTextDrawAlignment(playerid,TD(playerid, 		TeamSelection)[1], 2);
		PlayerTextDrawLetterSize(playerid,TD(playerid, 		TeamSelection)[1], 0.529999, 1.499999);
		PlayerTextDrawSetOutline(playerid,TD(playerid, 		TeamSelection)[1], 1);

		TD(playerid, TeamSelection)[2] = 					CreatePlayerTextDraw(playerid,531.0, 78.0, " ");
		PlayerTextDrawAlignment(playerid,TD(playerid, 		TeamSelection)[2], 2);
		PlayerTextDrawFont(playerid,TD(playerid, 			TeamSelection)[2], 3);
		PlayerTextDrawLetterSize(playerid,TD(playerid, 		TeamSelection)[2], 0.569998, 2.499999);
		PlayerTextDrawSetOutline(playerid,TD(playerid, 		TeamSelection)[2], 1);


		CreateBackground(playerid);
	}
}

TD_Destroy(playerid)
{
    for(new i = 0, j = 4; i != j; ++i)
    {
		PlayerTextDrawDestroy(playerid, 	TD(playerid, BG)[i]);
	}

	PlayerTextDrawDestroy(playerid, 		TD(playerid, TeamName));
	PlayerTextDrawDestroy(playerid, 		TD(playerid, Board_Header));
	PlayerTextDrawDestroy(playerid, 		TD(playerid, Board_Contents));
	PlayerTextDrawDestroy(playerid, 		TD(playerid, Star));
	PlayerTextDrawDestroy(playerid, 		TD(playerid, ScoreRank));
	PlayerTextDrawDestroy(playerid, 		TD(playerid, Rank));
	PlayerTextDrawDestroy(playerid, 		TD(playerid, ASK)[0]);
	PlayerTextDrawDestroy(playerid, 		TD(playerid, ASK)[1]);

	for (new i = 0, j = 3; i < j; i++)
	{
		PlayerTextDrawDestroy(playerid, 	TD(playerid, ScreenMsg)[i]);
		PlayerTextDrawDestroy(playerid, 	TD(playerid, TeamSelection)[i]);
	}
	
	DestroyPlayerProgressBar(playerid, 		TD(playerid, ZoneBar));
	TextDrawHideForPlayer(playerid, 		Server(AnnText));
	TextDrawHideForPlayer(playerid, 		Server(BombTime));
	news_Hide(playerid);
}

TD_Update(playerid, bool:hide = false)
{
	if (hide == false)
	{
	    PlayerTextDrawHide(playerid, 		TD(playerid, TeamName));
	 	PlayerTextDrawHide(playerid,	 	TD(playerid, Board_Header));
	 	PlayerTextDrawHide(playerid, 		TD(playerid, Board_Contents));
	    PlayerTextDrawHide(playerid, 		TD(playerid, Star));
		PlayerTextDrawHide(playerid, 		TD(playerid, ScoreRank));
		PlayerTextDrawHide(playerid, 		TD(playerid, Rank));

		TextDrawHideForPlayer(playerid, 	Server(Website));
		TextDrawHideForPlayer(playerid, 	Server(CmdsText));
		
		news_Hide(playerid);
	}
	else
	{
	    PlayerTextDrawShow(playerid, 		TD(playerid, Star));
		PlayerTextDrawShow(playerid, 		TD(playerid, Rank));
		PlayerTextDrawShow(playerid, 		TD(playerid, ScoreRank));
		PlayerTextDrawColor(playerid, 		TD(playerid, TeamName), Team(Player(playerid, Team), Color));
		PlayerTextDrawSetString(playerid, 	TD(playerid, TeamName), Team(Player(playerid, Team), Name));
		PlayerTextDrawShow(playerid, 		TD(playerid, TeamName));
		PlayerTextDrawShow(playerid, 		TD(playerid, Board_Header));

		TextDrawShowForPlayer(playerid, Server(Website));
		TextDrawShowForPlayer(playerid, Server(CmdsText));
	}
}
