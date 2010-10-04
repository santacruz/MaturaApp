//
//  GameScene.h
//  MaturaApp
//  © Zeno Koller 2010

#import "cocos2d.h"
#import "Sphere.h"
#import "SpaceManager.h"
#import "GameData.h"
#import "EnemySphere.h"

// HelloWorld Layer
@interface GameScene : CCLayer
{
	Sphere *sphere;
	SpaceManager *smgr;
	CCSprite *pausedScreen;
}

@property(nonatomic, assign)Sphere *sphere;
@property(nonatomic, retain)SpaceManager *smgr;
@property(nonatomic, retain)CCSprite *pausedScreen;

+(id) scene;
- (void) handleOwnCollision:(CollisionMoment)moment arbiter:(cpArbiter*)arb space:(cpSpace*)space;
- (void) handleEnemyCollision:(CollisionMoment)moment arbiter:(cpArbiter*)arb space:(cpSpace*)space;
- (void) endGame;
@end
