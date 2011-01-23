//
//  Sphere.h
//  MaturaApp
//  © Zeno Koller 2010

#import "cocos2d.h"
#import "SpaceManager.h"
#import "cpCCSprite.h"

//Diese Klasse stellt den Helden dar.
@interface Sphere : CCNode {
	float radius;
	int level;
	cpCCSprite *sprite;
}

@property(nonatomic,retain)	cpCCSprite *sprite;
@property(readwrite,assign) float radius;
@property(readwrite,assign) int level;
+(id) sphereWithMgr:(SpaceManager *)mgr level:(int)size position:(CGPoint)location;
-(id) initWithMgr:(SpaceManager *)mgr level:(int)size position:(CGPoint)location;
-(void)zoom;
@end
