//
//  GameData.m
//  MaturaApp
//  © Zeno Koller 2010


#import "GameData.h"
#define kInitSize 12.5

//SINGLETON RELATED
static GameData *sharedData = NULL;

@implementation GameData

@synthesize newHero, isThereAHero, isGamePaused, isPlaying, isCountdownFinished, enemySpawnBuffer, enemyArray, enemyCount, enemySpeedMultiplier, wasGameWon, heroStartLevel;
@synthesize gameScene;

- (id)init
{
	if ( self = [super init] )
	{	
		gameScene == NULL;
		heroStartLevel = 1;
		enemySpeedMultiplier;
		isThereAHero = YES;
		isGamePaused = NO;
		isCountdownFinished = NO;
		isPlaying = NO;
		wasGameWon = NO;
		newHero = [[CCArray alloc] init];
		enemySpawnBuffer = [[CCArray alloc] init];
		enemyArray = [[CCArray alloc] init];
		enemyCount = 0;
	}
	return self;
	
}

-(void)initLevel:(int)level withWorld:(int)world
{
	enemySpeedMultiplier = 10;
	[UserData sharedData].currentLevel = level;
	isThereAHero = YES;
	isGamePaused = NO;
	isCountdownFinished = NO;
	isPlaying = NO;
	wasGameWon = YES;
	[newHero removeAllObjects];
	[enemySpawnBuffer removeAllObjects];
	[enemyArray removeAllObjects];
	LevelParser *parser = [LevelParser parseLevel:level withWorld:world];
	[parser release];
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
	NSLog(@"Deallocating GameData singleton...");
	[enemySpawnBuffer release];
	[enemyArray release];
	[super dealloc];
}

@end

