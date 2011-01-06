//
//  GameScene.h
//  MaturaApp
//  © Zeno Koller 2010

#import "cocos2d.h"
#import "Sphere.h"
#import "SpaceManager.h"
#import "GameData.h"
#import "UserData.h"
#import "EnemySphere.h"
#import "Countdown.h"
#import "CCTouchDispatcher.h"
#import "GameOver.h"
#import "HelloWorldScene.h"
#import "AccHelper.h"

// HelloWorld Layer
@interface GameScene : CCLayer
{
	Sphere *sphere;
	SpaceManager *smgr;
	CCSprite *pausedScreen;
	CCMenu *pauseButton;
	Countdown *countdown;
	AccHelper *accHelper;
}

@property(nonatomic, assign)Sphere *sphere;
@property(nonatomic, retain)SpaceManager *smgr;
@property(nonatomic, assign)CCSprite *pausedScreen;
@property(nonatomic, assign)CCMenu *pauseButton;
@property(nonatomic, assign)Countdown *countdown;
@property(nonatomic, retain)AccHelper *accHelper;

+ (id) scene;
- (void) handleOwnCollision:(CollisionMoment)moment arbiter:(cpArbiter*)arb space:(cpSpace*)space;
- (void) handleEnemyCollision:(CollisionMoment)moment arbiter:(cpArbiter*)arb space:(cpSpace*)space;
- (void) startGame;
- (void) endGame;
- (void) pause:(CCMenuItem *) menuItem;
- (void) resume:(CCMenuItem *) menuItem;
- (void) restart:(CCMenuItem *) menuItem;
- (void) backToMenu:(CCMenuItem *) menuItem;
- (void) enterBackground;
@end