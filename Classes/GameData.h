//
//  GameData.h
//  MaturaApp
//  © Zeno Koller 2010


#import <Foundation/Foundation.h>
#import "LevelParser.h"
#import "cocos2d.h"

@interface GameData : NSObject {
	CGPoint heroPrevPos;
	CGPoint heroPrevVelocity;
	int heroNewSize;
	BOOL isThereAHero;
	BOOL isGamePaused;
	CCArray *enemySpawnBuffer;
	CCArray *enemyArray; 
	int enemyCount;
}

@property(readwrite,assign) CGPoint heroPrevPos, heroPrevVelocity;
@property(readwrite,assign) int heroNewSize, enemyCount;
@property(readwrite,assign) BOOL isThereAHero, isGamePaused;
@property(nonatomic,retain) CCArray *enemySpawnBuffer, *enemyArray;

+(GameData *) sharedData;
-(void)initLevel:(int)level;
@end
