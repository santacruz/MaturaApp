//
//  EnemySphere.h
//  MaturaApp

#import "cocos2d.h"
#import "SpaceManager.h"
#import "cpCCSprite.h"

@interface EnemySphere : CCSprite {
	float radius;
	int level;
	cpCCSprite *sprite;
}

@property(nonatomic,retain)	cpCCSprite *sprite;
@property(readwrite,assign) float radius;
@property(readwrite,assign) int level;
-(id) initWithMgr:(SpaceManager *)mgr level:(int)size;
@end
