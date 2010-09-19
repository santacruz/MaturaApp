//
//  GameData.h
//  MaturaApp
//  © Zeno Koller 2010


#import <Foundation/Foundation.h>
#import "LevelParser.h"

@interface GameData : NSObject {
	CGPoint heroPrevPos;
	CGPoint heroPrevVelocity;
	int heroNewSize;
	BOOL isThereAHero;
	NSMutableArray *enemySpawnBuffer;
	NSMutableArray *enemyArray; 
	int enemyCount;
}

@property(readwrite,assign) CGPoint heroPrevPos, heroPrevVelocity;
@property(readwrite,assign) int heroNewSize, enemyCount;
@property(readwrite,assign) BOOL isThereAHero;
@property(nonatomic,retain)NSMutableArray *enemySpawnBuffer, *enemyArray;

+(GameData *) sharedData;
-(void)initLevel;
@end
