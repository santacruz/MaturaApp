//
//  LevelParser.m
//  MaturaApp
//  © Zeno Koller 2010

//IMPORTANT NOTE
//Die Positionen im XML File sind auf einem Koordinatensystem anzugeben, welches
//den Ursprung im linken unteren Bildschirmrand besitzt und als Maximalwerte (240,480) besitzt.

#import "LevelParser.h"

@implementation LevelParser



+(id)parseLevel:(int)level withWorld:(int)world{
	return [[self alloc] initWithLevel:level withWorld:world];
}

-(id) initWithLevel:(int)level withWorld:(int)world{
	if ((self=[super init])) {
		/***************************************
		HIER PASSIERT EIN FEHLER!!!!!!
		***************************************/
		NSString *pfad = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"world%ilevel%i.plist",world,level]];
		NSMutableDictionary* plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:pfad];
        int numberOfEnemies = [[plistDict objectForKey:@"numberOfEnemies"] intValue];
		NSLog(@"NumberOfEnemies:%i",numberOfEnemies);
		[GameData sharedData].heroStartLevel = [[plistDict objectForKey:@"heroStartLevel"] intValue];
		[GameData sharedData].enemySpeedMultiplier = [[plistDict objectForKey:@"enemySpeedMultiplier"] intValue];
		
		for (int i=1; i<numberOfEnemies+1; i++) {
			NSDictionary *currentEnemy = [plistDict objectForKey:[NSString stringWithFormat:@"enemy%i",i]];
			//LADE DATEN FÜR FEIND, DER KREIERT WERDEN SOLL, IN ARRAY
			CCArray *enemyToBeSpawned = [[CCArray alloc] initWithCapacity:3];
			//ARRAY MIT DATEN FÜLLEN:GRÖSSE, POSITION, GESCHWINDIGKEIT
			[enemyToBeSpawned addObject:[currentEnemy objectForKey:@"enemyKind"]];
			[enemyToBeSpawned addObject:[currentEnemy objectForKey:@"enemyLevel"]];
			[enemyToBeSpawned addObject:[NSValue valueWithCGPoint:ccp([[currentEnemy objectForKey:@"enemyPosX"] floatValue]-240.0f, [[currentEnemy objectForKey:@"enemyPosY"] floatValue]-160.0f)]];
			[[GameData sharedData].enemySpawnBuffer addObject:enemyToBeSpawned];
			[enemyToBeSpawned release];
		}
		
		[plistDict release];
	}
	return self;
}


- (void) dealloc {

	[super dealloc];
}


@end

