//
//  EnemySphere.m
//  MaturaApp
//  © Zeno Koller 2010


#import "EnemySphere.h"

#define kHeroCollisionType	1
#define kEnemyCollisionType	2
#define kInitSize 12.5

@implementation EnemySphere
@synthesize radius, sprite, level;

+(id) enemyWithMgr:(SpaceManager *)mgr level:(int)size position:(CGPoint)location velocity:(CGPoint)velocity
{
	return [[[self alloc] initWithMgr:(SpaceManager *)mgr level:(int)size position:(CGPoint)location velocity:(CGPoint)velocity] autorelease];
}



-(id) initWithMgr:(SpaceManager *)mgr level:(int)size position:(CGPoint)location velocity:(CGPoint)velocity
{

	if( (self=[super init])) {
		
		level = size;
		
		radius = sqrt(level*pow(kInitSize,2));
		
		//FÜGE SPRITE HINZU
		cpShape *ball = [mgr addCircleAt:ccp(0,0) mass:size radius:radius];
		ball->collision_type = kEnemyCollisionType;
		sprite = [cpCCSprite spriteWithShape:ball file:[NSString stringWithFormat:@"level%i.png",size]];
		sprite.position = ccp(location.x,location.y);
		sprite.shape->body->v = velocity;
		[self addChild:sprite];
		
		self.position = ccp(240,160);
		
		[GameData sharedData].enemyCount += 1;
	}
	return self;
}

- (void) dealloc
{
	NSLog(@"Deallocating Enemy");
	[super dealloc];
}

@end
