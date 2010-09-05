//
//  GameScene.h
//  MaturaApp

#import "cocos2d.h"
#import "Sphere.h"
#import "EnemySphere.h"
#import "SpaceManager.h"


// HelloWorld Layer
@interface GameScene : CCColorLayer
{
	Sphere *sphere;
	CGPoint prevPos;
	int prevSize;
	CGPoint prevVelocity;
	BOOL isThereASphere;
}

@property(nonatomic,retain)Sphere *sphere;
@property(nonatomic,retain)SpaceManager *smgr;
@property(readwrite,assign) int prevSize;
@property(readwrite,assign) BOOL isThereASphere;
@property(readwrite,assign) CGPoint prevPos, prevVelocity;

+(id) scene;
- (void) handleCollision:(CollisionMoment)moment arbiter:(cpArbiter*)arb space:(cpSpace*)space;
@end
