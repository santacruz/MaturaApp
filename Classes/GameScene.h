//
//  GameScene.h
//  MaturaApp

#import "cocos2d.h"
#import "Sphere.h"
#import "SpaceManager.h"
#import "GameData.h"
#import "EnemySphere.h"

// HelloWorld Layer
@interface GameScene : CCColorLayer
{
	Sphere *sphere;
	SpaceManager *smgr;
}

@property(nonatomic, assign)Sphere *sphere;
@property(nonatomic, retain)SpaceManager *smgr;

+(id) scene;
- (void) handleOwnCollision:(CollisionMoment)moment arbiter:(cpArbiter*)arb space:(cpSpace*)space;
- (void) handleEnemyCollision:(CollisionMoment)moment arbiter:(cpArbiter*)arb space:(cpSpace*)space;
- (void) endGame;
@end
