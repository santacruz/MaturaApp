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
	CGPoint prevVelocity; //Später in GameData
	BOOL isThereASphere;
	NSMutableArray *enemySpawnBuffer; //Später in GameData
	NSMutableArray *enemyArray; //Später in GameData
}

@property(nonatomic,retain)Sphere *sphere;
@property(nonatomic,retain)SpaceManager *smgr;
@property(nonatomic,retain)NSMutableArray *enemySpawnBuffer, *enemyArray;
@property(readwrite,assign) int prevSize;
@property(readwrite,assign) BOOL isThereASphere;
@property(readwrite,assign) CGPoint prevPos, prevVelocity;

+(id) scene;
- (void) handleOwnCollision:(CollisionMoment)moment arbiter:(cpArbiter*)arb space:(cpSpace*)space;
- (void) handleEnemyCollision:(CollisionMoment)moment arbiter:(cpArbiter*)arb space:(cpSpace*)space;

@end
