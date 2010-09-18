//
//  GameScene.m
//  MaturaApp


#import "GameScene.h"
#import "HelloWorldScene.h"
#import "CCTouchDispatcher.h"

#define kHeroCollisionType	1
#define kEnemyCollisionType	2 
#define kInitSize 12.5
#define kFilterFactor 0.5f

id action;

@implementation GameScene

@synthesize sphere, smgr;

+(id) scene
{
	CCScene *scene = [CCScene node];
	GameScene *layer = [GameScene node];
	[scene addChild: layer];
	return scene;
}

//INITIALISIERE INSTANZ
-(id) init
{
	if( (self=[super initWithColor:ccc4(0,0,0,255)] )) {
		
		//BILDSCHIRMGRÖSSE
		CGSize screenSize = [CCDirector sharedDirector].winSize;
		
		//ACCELEROMETER BENÜTZEN
		self.isAccelerometerEnabled = YES;
		
		//LEVELDATEN INITIALISIEREN
		[[GameData sharedData] initLevel];
		
		//TOUCHES BENÜTZEN (UNCOMMENT)
		//[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
		
		//GAMELOGIK REGISTRIEREN
		[self schedule:@selector(nextFrame:)];
		
		//SPACEMGR
		smgr = [[SpaceManager alloc] init];
		smgr.gravity=ccp(0,0);
		[smgr start];	
		
		//WÄNDE
		cpShape *bottomRect = [smgr addRectAt:cpv(-80,-160) mass:STATIC_MASS width:screenSize.width height:1 rotation:0];
		cpCCSprite *sBottomSprite = [cpCCSprite spriteWithShape:bottomRect file:@"blank.png"];
		sBottomSprite.position = ccp(0,0);
		//bottomRect->e=2.0;
		[self addChild:sBottomSprite];
		cpShape *upperRect = [smgr addRectAt:cpv(-80,320) mass:STATIC_MASS width:screenSize.width height:1 rotation:0];
		cpCCSprite *sUpperSprite = [cpCCSprite spriteWithShape:upperRect file:@"blank.png"];
		sUpperSprite.position = ccp(0,0);
		[self addChild:sUpperSprite];		
		cpShape *leftRect = [smgr addRectAt:cpv(-240,80) mass:STATIC_MASS width:1 height:screenSize.height rotation:0];
		cpCCSprite *sLeftSprite = [cpCCSprite spriteWithShape:leftRect file:@"blank.png"];
		sLeftSprite.position = ccp(0,0);
		[self addChild:sLeftSprite];		
		cpShape *rightRect = [smgr addRectAt:cpv(80,80) mass:STATIC_MASS width:1 height:screenSize.height rotation:0];
		cpCCSprite *sRightSprite = [cpCCSprite spriteWithShape:rightRect file:@"blank.png"];
		sRightSprite.position = ccp(0,0);
		[self addChild:sRightSprite];
		
		
		//HELD INITIALISIEREN
		sphere = [Sphere sphereWithMgr:self.smgr level:1 position:ccp(-80,80) velocity:ccp(0,0)];
		[self addChild:sphere];
		
		//FEINDE HINZUFÜGEN
		EnemySphere *feind = [EnemySphere enemyWithMgr:self.smgr level:1 position:ccp(-35,-40) velocity:ccp(300,220)];
		[self addChild:feind];
		EnemySphere *feind2 = [EnemySphere enemyWithMgr:self.smgr level:2 position:ccp(-140,-110) velocity:ccp(-300,40)];
		[self addChild:feind2];
		EnemySphere *feind3 = [EnemySphere enemyWithMgr:self.smgr level:1 position:ccp(60,-80) velocity:ccp(400,-440)];
		[self addChild:feind3];
		EnemySphere *feind4 = [EnemySphere enemyWithMgr:self.smgr level:1 position:ccp(40,140) velocity:ccp(200,-100)];
		[self addChild:feind4];
		

		//REGISTRIERE COLLISION HANDLER FÜR HELD
		[smgr addCollisionCallbackBetweenType:kHeroCollisionType
									otherType:kEnemyCollisionType
									   target:self 
									 selector:@selector(handleOwnCollision:arbiter:space:)];
		
		//REGISTRIERE COLLISION HANDLER FÜR FEINDE
		[smgr addCollisionCallbackBetweenType:kEnemyCollisionType
									otherType:kEnemyCollisionType
									   target:self 
									 selector:@selector(handleEnemyCollision:arbiter:space:)];
		
	}
	return self;
}

//COLLISION HANDLING
- (void) handleOwnCollision:(CollisionMoment)moment arbiter:(cpArbiter*)arb space:(cpSpace*)space
{
	CP_ARBITER_GET_SHAPES(arb,a,b);
	if (moment == COLLISION_BEGIN) {
		NSLog(@"Collision detected!");
		cpCCSprite *sprite = (cpCCSprite*)b->data;
		int enemyMass = (int)round(fabs(sprite.shape->body->m));		
		if (enemyMass > sphere.level) {
			[self endGame];
		} else {
			if (sprite)
			{	
				[self removeChild:sprite.parent cleanup:YES];
				[smgr scheduleToRemoveAndFreeShape:b];
				b->data = nil;
				[GameData sharedData].enemyCount -= 1;
			}
			if (sphere) {
				[GameData sharedData].heroNewSize = sphere.level+enemyMass;
				[GameData sharedData].heroPrevPos = sphere.sprite.position;
				[GameData sharedData].heroPrevVelocity = sphere.sprite.shape->body->v;
				[GameData sharedData].isThereAHero = NO;
				[self removeChild:sphere cleanup:YES];
				[smgr scheduleToRemoveAndFreeShape:a];
				a->data = nil;
			}
		}
    }	
}
- (void) handleEnemyCollision:(CollisionMoment)moment arbiter:(cpArbiter*)arb space:(cpSpace*)space
{
	CP_ARBITER_GET_SHAPES(arb,a,b);
	if (moment == COLLISION_BEGIN) {
		
		NSLog(@"Collision detected!");
		cpCCSprite *sprite = (cpCCSprite*)a->data;
		cpCCSprite *sprite2 = (cpCCSprite*)b->data;
		int aSize = (int)round(fabs(sprite.shape->body->m));
		int bSize = (int)round(fabs(sprite2.shape->body->m));
		int newEnemySize = aSize + bSize;
		CGPoint newEnemyPosition = ccp(0,0);
		
		if (aSize > bSize) {
			newEnemyPosition = sprite.position;
		} else if (bSize > aSize) {
			newEnemyPosition = sprite2.position;
		} else {
			newEnemyPosition = ccpMidpoint(sprite.position, sprite2.position);
		}
		
		CGPoint newEnemyVelocity = ccpAdd(sprite.shape->body->v, sprite2.shape->body->v);
		
		[self removeChild:sprite.parent cleanup:YES];
		[smgr scheduleToRemoveAndFreeShape:a];
		a->data = nil;
		[self removeChild:sprite2.parent cleanup:YES];
		[smgr scheduleToRemoveAndFreeShape:b];
		b->data = nil;
		
		[GameData sharedData].enemyCount -= 2;

		
		//LADE DATEN FÜR FEIND, DER KREIERT WERDEN SOLL, IN ARRAY
		NSMutableArray *enemyToBeSpawned = [[NSMutableArray alloc] init];
		//ARRAY MIT DATEN FÜLLEN:GRÖSSE, POSITION, GESCHWINDIGKEIT
		[enemyToBeSpawned addObject:[NSNumber numberWithInteger:newEnemySize]];
		[enemyToBeSpawned addObject:[NSValue valueWithCGPoint:newEnemyPosition]];
		[enemyToBeSpawned addObject:[NSValue valueWithCGPoint:newEnemyVelocity]];
		[[GameData sharedData].enemySpawnBuffer addObject:enemyToBeSpawned];
	}
	
}


//GAME LOGIK
- (void) nextFrame:(ccTime)dt {
	//NEUER HERO
	if (![GameData sharedData].isThereAHero) {
		sphere = [Sphere sphereWithMgr:smgr level:[GameData sharedData].heroNewSize position:[GameData sharedData].heroPrevPos velocity:[GameData sharedData].heroPrevVelocity];
		[self addChild:sphere];
		[GameData sharedData].isThereAHero = YES;
	}
	//1 NEUER FEIND PRO SCHRITT
	if ([[GameData sharedData].enemySpawnBuffer count] != 0) {
		NSMutableArray *enemyToBeSpawned = [[NSMutableArray alloc] initWithArray:[[GameData sharedData].enemySpawnBuffer objectAtIndex:0]];
		EnemySphere *feind = [EnemySphere enemyWithMgr:self.smgr level:[[enemyToBeSpawned objectAtIndex:0]intValue] position:[[enemyToBeSpawned objectAtIndex:1] CGPointValue] velocity:[[enemyToBeSpawned objectAtIndex:2] CGPointValue]];
		[self addChild:feind];
		[[GameData sharedData].enemySpawnBuffer removeObjectAtIndex:0];
		[enemyToBeSpawned release];
	}
		
	if ([GameData sharedData].enemyCount == 0) {
		[self endGame];
	}

}

- (void)accelerometer:(UIAccelerometer*)accelerometer didAccelerate:(UIAcceleration*)acceleration
{	
	static float prevX=0, prevY=0, prevZ;
		
	float accelX = (float) acceleration.x * kFilterFactor + (1- kFilterFactor)*prevX;
	float accelY = (float) acceleration.y * kFilterFactor + (1- kFilterFactor)*prevY;
	float accelZ = (float) acceleration.z * kFilterFactor + (1- kFilterFactor)*prevZ;
	
	prevX = accelX;
	prevY = accelY;
	prevZ = accelZ;
	
	CGPoint v = ccp( accelX, accelY);
	
	if ([GameData sharedData].isThereAHero) {
		[sphere.sprite applyImpulse:ccpMult(v, 15)];
	}
	
}

-(void) onEnter
{
	[super onEnter];
	[[UIAccelerometer sharedAccelerometer] setUpdateInterval:(1.0 / 60)];
}

-(void)endGame
{
	NSLog(@"Ending Game");
	[self unschedule:@selector(nextFrame:)];
	[smgr removeCollisionCallbackBetweenType:kHeroCollisionType otherType:kEnemyCollisionType];
	[smgr removeCollisionCallbackBetweenType:kEnemyCollisionType otherType:kEnemyCollisionType];
	[smgr stop];
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:[HelloWorld scene]]];
}

- (void) dealloc
{
	NSLog(@"Deallocating GameLayer");
	[smgr release];
	[super dealloc];
}
@end
