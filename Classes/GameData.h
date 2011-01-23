//
//  GameData.h
//  MaturaApp
//  © Zeno Koller 2010


#import <Foundation/Foundation.h>
#import "LevelParser.h"
#import "cocos2d.h"
#import "UserData.h"
@class GameScene;

//	In dieser Klasse werden die Daten bezueglich des Spiels gespeichert.
//	Ausserdem wird hier das Lesen der XML-Leveldatei veranlasst.
@interface GameData : NSObject {
	//enthaelt Daten fuer einen neu zu erstellenden Held:
	CCArray *newHero;
	//enthaelt Daten fuer neu zu erstellende Feinde:
	CCArray *enemySpawnBuffer;
	//enthaelt Pointer zu allen existierenden Feinden:
	CCArray *enemyArray; 
	//Pointer zu aktueller Spielszene:
	GameScene *gameScene;
	//Grösse des Helden beim Spielstart:
	int heroStartLevel;
	//aktuelle Anzahl der Feinde:
	int enemyCount;
	//Faktor für Grundgeschwindigkeit der Feinde:
	int enemySpeedMultiplier;
	BOOL isThereAHero;
	BOOL isGamePaused;
	BOOL isCountdownFinished;
	BOOL isPlaying;
	BOOL wasGameWon;
}

@property(readwrite,assign) int enemyCount, heroStartLevel, enemySpeedMultiplier;
@property(readwrite,assign) BOOL isThereAHero, isGamePaused, isCountdownFinished, isPlaying, wasGameWon;
@property(nonatomic,retain) CCArray *newHero, *enemySpawnBuffer, *enemyArray;
@property(nonatomic,retain) GameScene *gameScene;

//erstellt einen Singleton der Klasse GameData:
+(GameData *) sharedData;
//Initialisiert das Auslesen eines Levels
-(void)initLevel:(int)level withWorld:(int)world;

@end
