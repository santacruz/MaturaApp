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

@synthesize heroPrevSize, isThereAHero, heroPrevPos, heroPrevVelocity, enemySpawnBuffer, enemyArray;

- (id)init
{
	if ( self = [super init] )
	{
		heroPrevSize = 1;
		isThereAHero = YES;
		heroPrevPos = ccp(0,0);
		heroPrevVelocity = ccp(0,0);
		enemySpawnBuffer = [[NSMutableArray alloc] init];
		enemyArray = [[NSMutableArray alloc] init];
	}
	return self;
	
}

-(void)initLevel
{
	heroPrevSize = 1;
	isThereAHero = YES;
	heroPrevPos = ccp(0,0);
	heroPrevVelocity = ccp(0,0);
	[enemySpawnBuffer removeAllObjects];
	[enemyArray removeAllObjects];
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
	[enemySpawnBuffer release];
	[enemyArray release];
	[super dealloc];
}

@end

