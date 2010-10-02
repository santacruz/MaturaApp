//
//  GameData.m
//  MaturaApp
//  © Zeno Koller 2010


#import "GameData.h"
#define kInitSize 12.5

//SINGLETON RELATED
static GameData *sharedData = NULL;

@implementation GameData

@synthesize heroNewSize, isThereAHero, isGamePaused, heroPrevPos, heroPrevVelocity, enemySpawnBuffer, enemyArray, enemyCount;

- (id)init
{
	if ( self = [super init] )
	{
		heroNewSize = 1;
		isThereAHero = YES;
		isGamePaused = NO;
		heroPrevPos = ccp(0,0);
		heroPrevVelocity = ccp(0,0);
		enemySpawnBuffer = [[CCArray alloc] init];
		enemyArray = [[CCArray alloc] init];
		enemyCount = 0;
	}
	return self;
	
}

-(void)initLevel:(int)level
{
	heroNewSize = 1;
	isThereAHero = YES;
	isGamePaused = NO;
	heroPrevPos = ccp(0,0);
	heroPrevVelocity = ccp(0,0);
	[enemySpawnBuffer removeAllObjects];
	[enemyArray removeAllObjects];
	enemyCount = 0;
	LevelParser *parser = [LevelParser parseLevel:level];
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
	NSLog(@"Deallocating singleton...");
	[enemySpawnBuffer release];
	[enemyArray release];
	[super dealloc];
}

@end

