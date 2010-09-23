//
//  LevelParser.m
//  MaturaApp
//  © Zeno Koller 2010

//IMPORTANT NOTE
//Die Positionen im XML File sind auf einem Koordinatensystem anzugeben, welches
//den Ursprung im linken unteren Bildschirmrand besitzt und als Maximalwerte (240,480) besitzt.

#import "LevelParser.h"

@implementation LevelParser



+(id)parseLevel:(int)level {
	return [[self alloc] initWithLevel:level];
}

-(id) initWithLevel:(int)level {
	if ((self=[super init])) {
		NSString *pfad = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"level%i.plist",level]];
		NSMutableDictionary* plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:pfad];
		
        int numberOfEnemies = [[plistDict objectForKey:@"numberOfEnemies"] intValue];
		
		for (int i=1; i<numberOfEnemies+1; i++) {
			NSArray *currentEnemy = [plistDict objectForKey:[NSString stringWithFormat:@"enemy%i",i]];
			//LADE DATEN FÜR FEIND, DER KREIERT WERDEN SOLL, IN ARRAY
			NSMutableArray *enemyToBeSpawned = [[NSMutableArray alloc] init];
			//ARRAY MIT DATEN FÜLLEN:GRÖSSE, POSITION, GESCHWINDIGKEIT
			[enemyToBeSpawned addObject:[NSNumber numberWithInteger:[[currentEnemy objectAtIndex:0] intValue]]];
			[enemyToBeSpawned addObject:[NSValue valueWithCGPoint:ccp([[currentEnemy objectAtIndex:1] floatValue]-240.0f, [[currentEnemy objectAtIndex:2] floatValue]-160.0f)]];
			[enemyToBeSpawned addObject:[NSValue valueWithCGPoint:ccp([[currentEnemy objectAtIndex:3] floatValue], [[currentEnemy objectAtIndex:4] floatValue])]];
			[[GameData sharedData].enemySpawnBuffer addObject:enemyToBeSpawned];
			[enemyToBeSpawned release];
			[currentEnemy release];
		}
	}
	return self;
}


- (void) dealloc {

	[super dealloc];
}


@end

