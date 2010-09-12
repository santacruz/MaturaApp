//
//  EnemySphere.m
//  MaturaApp


#import "EnemySphere.h"

#define kBallCollisionType	1
#define kCircleCollisionType	2
#define kRectCollisionType	3
#define kFragShapeCollisionType	4
#define kInitSize 12.5

@implementation EnemySphere
@synthesize radius, sprite, level;
-(id) initWithMgr:(SpaceManager *)mgr level:(int)size position:(CGPoint)location velocity:(CGPoint)velocity
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
		//Set Level
		level = size;
		
		radius = sqrt(level*pow(kInitSize,2));
		
		//Sprite hinzufügen
		cpShape *ball = [mgr addCircleAt:ccp(0,0) mass:size radius:radius];
		ball->collision_type = kCircleCollisionType;
		sprite = [cpCCSprite spriteWithShape:ball file:[NSString stringWithFormat:@"level%i.png",size]];
		sprite.position = location;
		sprite.shape->body->v = velocity;
		[self addChild:sprite];
		
		self.position = ccp(240,160);
		
	}
	return self;
}

- (void) dealloc
{

	[super dealloc];
}

@end
