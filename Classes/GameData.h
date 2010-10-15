//
//  GameData.h
//  MaturaApp
//  © Zeno Koller 2010


#import <Foundation/Foundation.h>
#import "LevelParser.h"
#import "cocos2d.h"

@interface GameData : NSObject {
	BOOL isThereAHero;
	BOOL isGamePaused;
	BOOL isCountdownFinished;
	BOOL wasGameWon;
	CCArray *newHero;
	CCArray *enemySpawnBuffer;
	CCArray *enemyArray; 
	int enemyCount;
	int currentLevel;
}

@property(readwrite,assign) int enemyCount, currentLevel;
@property(readwrite,assign) BOOL isThereAHero, isGamePaused, isCountdownFinished, wasGameWon;
@property(nonatomic,retain) CCArray *newHero, *enemySpawnBuffer, *enemyArray;

+(GameData *) sharedData;
-(void)initLevel:(int)level;

@end
