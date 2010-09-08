//
//  EnemySphere.m
//  MaturaApp


#import "EnemySphere.h"

#define kBallCollisionType	1
#define kCircleCollisionType	2
#define kRectCollisionType	3
#define kFragShapeCollisionType	4

@implementation EnemySphere
@synthesize radius, sprite, level;
-(id) initWithMgr:(SpaceManager *)mgr level:(int)size position:(CGPoint)location velocity:(CGPoint)velocity
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
		//Set Level
		level = size;
		
		//TBD 
		//unhardcode->kommt mit hi res fix
		CGSize screenSize = [CCDirector sharedDirector].winSize;
		radius = size*screenSize.width/(19.2*2);
		NSLog(@"Radius:%f",radius);
		
		//Sprite hinzufügen
		cpShape *ball = [mgr addCircleAt:ccp(0,0) mass:size radius:radius];
		ball->collision_type = kCircleCollisionType;
		sprite = [cpCCSprite spriteWithShape:ball file:[NSString stringWithFormat:@"level%i.png",size]];
		sprite.position = location;
		sprite.shape->body->v = velocity;
		[self addChild:sprite];
		
		self.position = ccp(screenSize.width/2,screenSize.height/2);
		
	}
	return self;
}

- (void) dealloc
{

	[super dealloc];
}

@end
