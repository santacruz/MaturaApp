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
	//int level;
	//int enemyKind;
	cpCCSprite *sprite;
	CGPoint moveVector;
}

@property(nonatomic,retain)	cpCCSprite *sprite;
@property(readwrite,assign) float radius;
@property(readwrite,assign) CGPoint moveVector;
//@property(readwrite,assign) int level;
//@property(readwrite,assign) int enemyKind;
+(id) enemyWithMgr:(SpaceManager *)mgr kind:(int)kind level:(int)size position:(CGPoint)location;
-(id) initWithMgr:(SpaceManager *)mgr kind:(int)kind level:(int)size position:(CGPoint)location;
-(void) move:(ccTime)dt; 
@end