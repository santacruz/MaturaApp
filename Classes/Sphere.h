//
//  Sphere.h
//  MaturaApp
//  © Zeno Koller 2010

#import "cocos2d.h"
#import "SpaceManager.h"
#import "cpCCSprite.h"

@interface Sphere : CCNode {
	float radius;
	int level;
	cpCCSprite *sprite;
	CCParticleSystemQuad *emitter;
}

@property(nonatomic,retain)	cpCCSprite *sprite;
@property(nonatomic,assign) CCParticleSystemQuad *emitter;
@property(readwrite,assign) float radius;
@property(readwrite,assign) int level;
+(id) sphereWithMgr:(SpaceManager *)mgr level:(int)size position:(CGPoint)location;
-(id) initWithMgr:(SpaceManager *)mgr level:(int)size position:(CGPoint)location;
@end
