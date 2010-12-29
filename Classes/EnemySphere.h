//
//  EnemySphere.h
//  MaturaApp
//  © Zeno Koller 2010

#import "cocos2d.h"
#import "SpaceManager.h"
#import "cpCCSprite.h"
#import "GameData.h"

@interface EnemySphere : CCNode {
	float radius;
	float speed;
	cpCCSprite *sprite;
	CGPoint moveVector;
	CCParticleSystemQuad *emitter;
}

@property(nonatomic,retain)	cpCCSprite *sprite;
@property(nonatomic,assign) CCParticleSystemQuad *emitter;
@property(readwrite,assign) float radius, speed;
@property(readwrite,assign) CGPoint moveVector;
+(id) enemyWithMgr:(SpaceManager *)mgr kind:(int)kind level:(int)size position:(CGPoint)location;
-(id) initWithMgr:(SpaceManager *)mgr kind:(int)kind level:(int)size position:(CGPoint)location;
-(void) move1:(ccTime)dt;
-(void) move2:(ccTime)dt;
-(void) move3:(ccTime)dt;
-(void)zoom;
@end