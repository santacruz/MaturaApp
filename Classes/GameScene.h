//
//  GameScene.h
//  MaturaApp

#import "cocos2d.h"
#import "Sphere.h"
#import "EnemySphere.h"
#import "SpaceManager.h"
#import "GameData.h"


// HelloWorld Layer
@interface GameScene : CCColorLayer
{
	Sphere *sphere;
	SpaceManager *smgr;
}

@property(nonatomic,retain)Sphere *sphere;
@property(nonatomic,retain)SpaceManager *smgr;

+(id) scene;
- (void) handleOwnCollision:(CollisionMoment)moment arbiter:(cpArbiter*)arb space:(cpSpace*)space;
- (void) handleEnemyCollision:(CollisionMoment)moment arbiter:(cpArbiter*)arb space:(cpSpace*)space;

@end
