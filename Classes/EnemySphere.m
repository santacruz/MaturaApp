//
//  EnemySphere.m
//  MaturaApp
//  © Zeno Koller 2010


#import "EnemySphere.h"

#define kHeroCollisionType	1
#define kEnemyCollisionType	2
#define kInitSize 12.5
#define	kNormalEnemy 1

@implementation EnemySphere
@synthesize radius, sprite; //level, enemyKind;

+(id) enemyWithMgr:(SpaceManager *)mgr kind:(int)kind level:(int)size position:(CGPoint)location velocity:(CGPoint)velocity
{
	return [[[self alloc] initWithMgr:(SpaceManager *)mgr kind:(int)kind level:(int)size position:(CGPoint)location velocity:(CGPoint)velocity] autorelease];
}



-(id) initWithMgr:(SpaceManager *)mgr kind:(int)kind level:(int)size position:(CGPoint)location velocity:(CGPoint)velocity
{

	if( (self=[super init])) {
		
		radius = sqrt(size*pow(kInitSize,2));
		
		//FÜGE SPRITE HINZU
		cpShape *ball = [mgr addCircleAt:ccp(0,0) mass:size radius:radius];
		ball->collision_type = kEnemyCollisionType;
		sprite = [[cpCCSprite alloc] initWithShape:ball file:[NSString stringWithFormat:@"Enemy/enemy%i.png",size]];
		sprite.position = ccp(location.x,location.y);
		sprite.shape->body->v = velocity;
		sprite.level = size;
		sprite.enemyKind = kind;
		
		[self addChild:sprite];
		
		self.position = ccp(240,160);
		
		[GameData sharedData].enemyCount += 1;
		[[GameData sharedData].enemyArray addObject:self];
	}
	NSLog(@"Adding Enemy");
	return self;
}

- (void) dealloc
{
	[sprite release];
	NSLog(@"Deallocating Enemy");
	[super dealloc];
}

@end
