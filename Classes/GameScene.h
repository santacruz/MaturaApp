//
//  GameScene.h
//  MaturaApp
//  © Zeno Koller 2010

#import "cocos2d.h"
#import "Sphere.h"
#import "SpaceManagerCocos2d.h"
#import "GameData.h"
#import "UserData.h"
#import "EnemySphere.h"
#import "Countdown.h"
#import "CCTouchDispatcher.h"
#import "GameOver.h"
#import "HelloWorldScene.h"
#import "AccHelper.h"
#import "MenuFont.h"

// HelloWorld Layer
//	Diese Klasse stellt den Spielbildschirm dar.
@interface GameScene : CCLayer
{
	//Held:
	Sphere *sphere;
	//Wrapper für Chipmunk:
	SpaceManager *smgr;
	//Ansicht, wenn das Spiel pausiert ist:
	CCSprite *pausedScreen;
	CCMenu *pauseButton;
	//Layer, auf welcher der Countdown angezeigt ist:
	Countdown *countdown; 
	//Hilfsklasse für Vektorgeometrie:
	AccHelper *accHelper;
}

@property(nonatomic, assign)Sphere *sphere;
@property(nonatomic, retain)SpaceManager *smgr;
@property(nonatomic, assign)CCSprite *pausedScreen;
@property(nonatomic, assign)CCMenu *pauseButton;
@property(nonatomic, assign)Countdown *countdown;
@property(nonatomic, retain)AccHelper *accHelper;

//Fuegt eine Instanz dieser Klasse hinzu:
+ (id) scene;
//Game Loop:
- (void) nextFrame:(ccTime)dt;
//Beschleunigungssensor-Loop
- (void)accelerometer:(UIAccelerometer*)accelerometer didAccelerate:(UIAcceleration*)acceleration;
//Kollisionsmanagement für Held:
- (void) handleOwnCollision:(CollisionMoment)moment arbiter:(cpArbiter*)arb space:(cpSpace*)space;
//Kollisionsmanagement für Feinde:
- (void) handleEnemyCollision:(CollisionMoment)moment arbiter:(cpArbiter*)arb space:(cpSpace*)space;
//beginnt das Spiel:
- (void) startGame; 
//beendet das Spiel:
- (void) endGame; 
//pausiert das Spiel:
- (void) pause:(CCMenuItem *) menuItem; 
//führt pausiertes Spiel fort:
- (void) resume:(CCMenuItem *) menuItem; 
//beginnt das aktuelle Level neu:
- (void) restart:(CCMenuItem *) menuItem; 
//beendet das Spiel und startet das Hauptmenu:
- (void) backToMenu:(CCMenuItem *) menuItem; 
//handhabt den Eintritt der Applikation in den Hintergrund:
- (void) enterBackground; 
@end