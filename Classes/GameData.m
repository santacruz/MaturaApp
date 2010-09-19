//
//  GameData.m
//  MaturaApp
//  © Zeno Koller 2010


#import "GameData.h"
#define kInitSize 12.5

//SINGLETON RELATED
static GameData *sharedData = NULL;

@implementation GameData

@synthesize heroNewSize, isThereAHero, heroPrevPos, heroPrevVelocity, enemySpawnBuffer, enemyArray, enemyCount;

- (id)init
{
	if ( self = [super init] )
	{
		heroNewSize = 1;
		isThereAHero = YES;
		heroPrevPos = ccp(0,0);
		heroPrevVelocity = ccp(0,0);
		enemySpawnBuffer = [[NSMutableArray alloc] init];
		enemyArray = [[NSMutableArray alloc] init];
		enemyCount = 0;
	}
	return self;
	
}

-(void)initLevel
{
	heroNewSize = 1;
	isThereAHero = YES;
	heroPrevPos = ccp(0,0);
	heroPrevVelocity = ccp(0,0);
	[enemySpawnBuffer removeAllObjects];
	[enemyArray removeAllObjects];
	enemyCount = 0;
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

