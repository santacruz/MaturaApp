//
//  Sphere.m
//  MaturaApp
//  © Zeno Koller 2010

#import "Sphere.h"

#define kHeroCollisionType	1
#define kEnemyCollisionType	2
#define kInitSize 12.5


@implementation Sphere
@synthesize radius, sprite, level;

+(id) sphereWithMgr:(SpaceManager *)mgr level:(int)size position:(CGPoint)location velocity:(CGPoint)velocity
{
	return [[[self alloc] initWithMgr:(SpaceManager *)mgr level:(int)size position:(CGPoint)location velocity:(CGPoint)velocity] autorelease];
}


-(id) initWithMgr:(SpaceManager *)mgr level:(int)size position:(CGPoint)location velocity:(CGPoint)velocity;
{
	
	if( (self=[super init])) {

		level = size;

		radius = sqrt(level*pow(kInitSize,2));
		
		//FÜGE SPRITE HINZU
		cpShape *ball = [mgr addCircleAt:ccp(0,0) mass:size radius:radius];
		ball->collision_type = kHeroCollisionType;
		sprite = [[cpCCSprite alloc] initWithShape:ball file:[NSString stringWithFormat:@"Hero/hero%i.png",size]];
		sprite.position = ccp(location.x,location.y);
		sprite.shape->body->v = velocity;
		//[sprite setIgnoreRotation:YES];
		[self addChild:sprite];
	
		self.position = ccp(240,160);
	}
	return self;
}

- (void) dealloc
{
	NSLog(@"Deallocating Hero");
	[sprite release];
	[super dealloc];
}

@end
