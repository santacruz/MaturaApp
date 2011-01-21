//
//  LevelParser.m
//  MaturaApp
//  © Zeno Koller 2010
//
//	Dies ist der XML-Parser für Level-Dateien

//IMPORTANT NOTE
//Die Positionen im XML File sind auf einem Koordinatensystem anzugeben, welches
//den Ursprung im linken unteren Bildschirmrand besitzt und als Maximalwerte (240,480) besitzt.

#import "LevelParser.h"

@implementation LevelParser

//PARSE EIN LEVEL
+(id)parseLevel:(int)level withWorld:(int)world{
	return [[self alloc] initWithLevel:level withWorld:world];
}

//INITIALISIERE INSTANZ
-(id) initWithLevel:(int)level withWorld:(int)world{
	if ((self=[super init])) {
		NSString *pfad = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"world%ilevel%i.plist",world,level]];
		NSMutableDictionary* plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:pfad];
        int numberOfEnemies = [[plistDict objectForKey:@"numberOfEnemies"] intValue];
		[GameData sharedData].heroStartLevel = [[plistDict objectForKey:@"heroStartLevel"] intValue];
		[GameData sharedData].enemySpeedMultiplier = [[plistDict objectForKey:@"enemySpeedMultiplier"] intValue];
		[GameData sharedData].enemyCount = numberOfEnemies;
		for (int i=1; i<numberOfEnemies+1; i++) {
			NSDictionary *currentEnemy = [plistDict objectForKey:[NSString stringWithFormat:@"enemy%i",i]];
			//LADE DATEN FÜR FEIND, DER KREIERT WERDEN SOLL, IN ARRAY
			CCArray *enemyToBeSpawned = [[CCArray alloc] initWithCapacity:3];
			//ARRAY MIT DATEN FÜLLEN:GRÖSSE, POSITION, GESCHWINDIGKEIT
			[enemyToBeSpawned addObject:[currentEnemy objectForKey:@"kind"]];
			[enemyToBeSpawned addObject:[currentEnemy objectForKey:@"level"]];
			[enemyToBeSpawned addObject:[NSValue valueWithCGPoint:ccp([[currentEnemy objectForKey:@"x"] floatValue]-240.0f, [[currentEnemy objectForKey:@"y"] floatValue]-160.0f)]];
			[[GameData sharedData].enemySpawnBuffer addObject:enemyToBeSpawned];
			[enemyToBeSpawned release];
		}
		
		[plistDict release];
	}
	return self;
}

//LÖSCHE DIESE INSTANZ
- (void) dealloc {

	[super dealloc];
}


@end

