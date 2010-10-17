//
//  GameData.m
//  MaturaApp
//  © Zeno Koller 2010


#import "GameData.h"
#define kInitSize 12.5

//SINGLETON RELATED
static GameData *sharedData = NULL;

@implementation GameData

@synthesize newHero, isThereAHero, currentLevel, isGamePaused, isCountdownFinished, enemySpawnBuffer, enemyArray, enemyCount, wasGameWon, heroStartLevel;
/*Zum Abspeichern von Kalibrationsdaten, später in Klasse UserData auslagern*/
@synthesize accelCorrectionX, accelCorrectionY;

- (id)init
{
	if ( self = [super init] )
	{
		heroStartLevel = 1;
		isThereAHero = YES;
		isGamePaused = NO;
		isCountdownFinished = NO;
		wasGameWon = NO;
		newHero = [[CCArray alloc] init];
		enemySpawnBuffer = [[CCArray alloc] init];
		enemyArray = [[CCArray alloc] init];
		enemyCount = 0;
		currentLevel = 0;
		/*Zum Abspeichern von Kalibrationsdaten, später in Klasse UserData auslagern*/
		accelCorrectionX = 0;
		accelCorrectionY = 0;
	}
	return self;
	
}

-(void)initLevel:(int)level
{
	currentLevel = level;
	isThereAHero = YES;
	isGamePaused = NO;
	isCountdownFinished = NO;
	wasGameWon = NO;
	[newHero removeAllObjects];
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

