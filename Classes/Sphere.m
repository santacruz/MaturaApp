//
//  Sphere.m
//  MaturaApp
//  © Zeno Koller 2010

#import "Sphere.h"

#define kHeroCollisionType	1
#define kEnemyCollisionType	2
#define kInitSize 16


@implementation Sphere
@synthesize radius, sprite, level, emitter;

+(id) sphereWithMgr:(SpaceManager *)mgr level:(int)size position:(CGPoint)location
{
	return [[[self alloc] initWithMgr:(SpaceManager *)mgr level:(int)size position:(CGPoint)location] autorelease];
}


-(id) initWithMgr:(SpaceManager *)mgr level:(int)size position:(CGPoint)location;
{
	
	if( (self=[super init])) {

		level = size;
		float gewicht = 0.5f*size;

		radius = sqrt(level*pow(kInitSize,2));
		
		//FÜGE SPRITE HINZU
		cpShape *ball = [mgr addCircleAt:ccp(0,0) mass:gewicht radius:radius];
		ball->collision_type = kHeroCollisionType;
		sprite = [[cpCCSprite alloc] initWithShape:ball file:[NSString stringWithFormat:@"hero/Hero%i.png",size]];
		sprite.position = ccp(location.x,location.y);
		[self addChild:sprite];
		//WENN DER FEIND NICHT BEIM LEVELAUFSTELLEN HINZUGEFÜGT WURDE, EINEN EMITTER HINZUFÜGEN
		emitter = [CCParticleSystemQuad particleWithFile:@"emitterHero.plist"];
		emitter.position = ccp(location.x, location.y);
		emitter.autoRemoveOnFinish = YES;
		[self addChild:emitter z:-10];

		self.position = ccp(240,160);
	}
	return self;
}

-(void)onEnter{
	float originalScale = self.scale;
	id zoomIn = [CCScaleTo actionWithDuration:0.1f scale:1.2f*originalScale];
	id zoomOut = [CCScaleTo actionWithDuration:0.1f scale:originalScale];
	[sprite runAction:[CCSequence actions:zoomIn,zoomOut, nil]];
	[super onEnter];
}

- (void) dealloc
{
	NSLog(@"Deallocating Hero");
	[sprite release];
	[super dealloc];
}

@end
