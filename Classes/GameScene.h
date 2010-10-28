//
//  GameScene.h
//  MaturaApp
//  © Zeno Koller 2010

#import "cocos2d.h"
#import "Sphere.h"
#import "SpaceManager.h"
#import "GameData.h"
#import "EnemySphere.h"
#import "Countdown.h"
#import "CCTouchDispatcher.h"
#import "GameOver.h"
#import "HelloWorldScene.h"


// HelloWorld Layer
@interface GameScene : CCLayer
{
	Sphere *sphere;
	SpaceManager *smgr;
	CCSprite *pausedScreen;
	Countdown *countdown;
}

@property(nonatomic, assign)Sphere *sphere;
@property(nonatomic, retain)SpaceManager *smgr;
@property(nonatomic, assign)CCSprite *pausedScreen;
@property(nonatomic, assign)Countdown *countdown;

+(id) scene;
- (void) handleOwnCollision:(CollisionMoment)moment arbiter:(cpArbiter*)arb space:(cpSpace*)space;
- (void) handleEnemyCollision:(CollisionMoment)moment arbiter:(cpArbiter*)arb space:(cpSpace*)space;
- (void) startGame;
- (void) endGame;
- (void) pause;
- (void) resume:(CCMenuItem *) menuItem;
- (void) backToMenu:(CCMenuItem *) menuItem;
@end
