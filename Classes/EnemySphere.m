//
//  EnemySphere.m
//  MaturaApp
//  © Zeno Koller 2010


#import "EnemySphere.h"

#define kHeroCollisionType	1
#define kEnemyCollisionType	2
#define kInitSize 16
#define	kNormalEnemy 0
#define kShrinkEnemy 1

@implementation EnemySphere

static float prevDistance = 500;

@synthesize radius, sprite, moveVector; //level, enemyKind;

+(id) enemyWithMgr:(SpaceManager *)mgr kind:(int)kind level:(int)size position:(CGPoint)location
{
	return [[[self alloc] initWithMgr:(SpaceManager *)mgr kind:(int)kind level:(int)size position:(CGPoint)location] autorelease];
}



-(id) initWithMgr:(SpaceManager *)mgr kind:(int)kind level:(int)size position:(CGPoint)location
{

	if( (self=[super init])) {
		
		radius = sqrt(size*pow(kInitSize,2));
		
		cpShape *ball = [mgr addCircleAt:ccp(0,0) mass:size radius:radius];
		ball->collision_type = kEnemyCollisionType;
		
		switch (kind) {
			case kNormalEnemy:
				
				//FÜGE NORMALES SPRITE HINZU
				sprite = [[cpCCSprite alloc] initWithShape:ball file:[NSString stringWithFormat:@"enemy/Enemy%i.png",size]];
				sprite.position = ccp(location.x,location.y);
				sprite.level = size;
				sprite.enemyKind = kind;
				sprite.isShrinkKind = NO;
				break;
				
			case kShrinkEnemy:
				//FÜGE BOUNCY SPRITE HINZU
				sprite = [[cpCCSprite alloc] initWithShape:ball file:[NSString stringWithFormat:@"shrink/Shrink%i.png",size]];
				sprite.position = ccp(location.x,location.y);
				sprite.level = size;
				sprite.enemyKind = kind;
				sprite.isShrinkKind = YES;
				break;

			default:
				//FÜGE NORMALES SPRITE HINZU
				sprite = [[cpCCSprite alloc] initWithShape:ball file:[NSString stringWithFormat:@"enemy/Enemy%i.png",size]];
				sprite.position = ccp(location.x,location.y);
				sprite.level = size;
				sprite.enemyKind = kind;
				sprite.isShrinkKind = NO;
				break;
		}

		
		[self addChild:sprite];
		self.position = ccp(240,160);
		
		//MOVE LOGIK HINZUFÜGEN
		[self schedule:@selector(move:) interval:1/30];
		
		//****************************
		//[GameData sharedData].enemyCount += 1;
		[[GameData sharedData].enemyArray addObject:self];
	}
	NSLog(@"Adding Enemy");
	return self;
}

-(void)onEnter{
	float originalScale = self.scale;
	id zoomIn = [CCScaleTo actionWithDuration:0.1f scale:1.2f*originalScale];
	id zoomOut = [CCScaleTo actionWithDuration:0.1f scale:originalScale];
	[sprite runAction:[CCSequence actions:zoomIn,zoomOut, nil]];
	[super onEnter];
}

- (void)move:(ccTime)dt {
	//UNSCHÖN, ÄNDERN!
	//**********************
	if ([GameData sharedData].isPlaying) {
		prevDistance = 500;
		if ([GameData sharedData].enemyCount > 1) {
			for(EnemySphere *enemy in [GameData sharedData].enemyArray) {
				if (enemy != self) {
					if (ccpDistance(enemy.sprite.position, self.sprite.position) < prevDistance) {
						prevDistance = ccpDistance(enemy.sprite.position, self.sprite.position);
						moveVector = ccpNormalize(ccpSub(enemy.sprite.position, self.sprite.position));
					}
				}
			}
		} else {
			if ([GameData sharedData].isThereAHero) {
				moveVector = ccpNormalize(ccpSub([[self.parent sphere] sprite].position, self.sprite.position));
			}
		}
		
		sprite.shape->body->v = ccpMult(moveVector, [GameData sharedData].enemySpeedMultiplier);
		//ARGUMENT DES FEINDES ÄNDERN
		sprite.rotation = -1*ccpToAngle(sprite.shape->body->v)*180/M_PI-90;
	}

}

- (void) dealloc
{
	[sprite release];
	NSLog(@"Deallocating Enemy");
	[super dealloc];
}

@end
