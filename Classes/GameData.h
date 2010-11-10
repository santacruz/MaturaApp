//
//  GameData.h
//  MaturaApp
//  © Zeno Koller 2010


#import <Foundation/Foundation.h>
#import "LevelParser.h"
#import "cocos2d.h"
@class GameScene;

@interface GameData : NSObject {
	BOOL isThereAHero;
	BOOL isGamePaused;
	BOOL isCountdownFinished;
	BOOL isPlaying;
	BOOL wasGameWon;
	CCArray *newHero;
	CCArray *enemySpawnBuffer;
	CCArray *enemyArray; 
	int heroStartLevel;
	int enemyCount;
	int currentLevel;
	int enemySpeedMultiplier;
	GameScene *gameScene;
}

@property(readwrite,assign) int enemyCount, currentLevel, heroStartLevel, enemySpeedMultiplier;
@property(readwrite,assign) BOOL isThereAHero, isGamePaused, isCountdownFinished, isPlaying, wasGameWon;
@property(nonatomic,retain) CCArray *newHero, *enemySpawnBuffer, *enemyArray;
@property(nonatomic,retain) GameScene *gameScene;

+(GameData *) sharedData;
-(void)initLevel:(int)level;

@end
