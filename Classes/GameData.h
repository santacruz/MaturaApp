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
	int heroStartLevel;
	int enemyCount;
	int currentLevel;
	/*Zum Abspeichern von Kalibrationsdaten, später in Klasse UserData auslagern*/
	float accelCorrectionX;
	float accelCorrectionY;
}

@property(readwrite,assign) int enemyCount, currentLevel, heroStartLevel;
@property(readwrite,assign) BOOL isThereAHero, isGamePaused, isCountdownFinished, wasGameWon;
@property(nonatomic,retain) CCArray *newHero, *enemySpawnBuffer, *enemyArray;
@property(readwrite,assign) float accelCorrectionX, accelCorrectionY;

+(GameData *) sharedData;
-(void)initLevel:(int)level;

@end
