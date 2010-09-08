//
//  GameData.m
//  MaturaApp
//
//  Created by Zeno Koller on 07.09.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GameData.h"

//Singleton stuff
static GameData *sharedData = NULL;

@implementation GameData

- (id)init
{
	if ( self = [super init] )
	{
		//Hier GameDaten initialisieren
		//Variabeln für Anz. Feinde, Score, Powerups gegessen etc, 
		//Hier evtl. level aus xml lesen
		//Hier enemySpawnBuffer Array behalten
	}
	return self;
	
}

+ (GameData *)sharedData
{
	@synchronized([GameData class])
	{
		if ( !sharedData || sharedData == NULL )
		{
			sharedData = [[GameData alloc] init];
		}
		
		return sharedData;
	}
}

- (void)dealloc
{
	NSLog(@"Deallocating singleton...");
	//release allocated stuff
	
	[super dealloc];
}

@end

