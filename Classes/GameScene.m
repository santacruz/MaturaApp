//
//  GameScene.m
//  MaturaApp
//  © Zeno Koller 2010


#import "GameScene.h"
#import "HelloWorldScene.h"
#import "CCTouchDispatcher.h"

#define kHeroCollisionType	1
#define kEnemyCollisionType	2 
#define kInitSize 12.5
#define kFilterFactor 0.5f
#define kImpulseMultiplier 5

id action;

@implementation GameScene

@synthesize sphere, smgr, pausedScreen, countdown;

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
	if( (self=[super init] )) {
		
		//BILDSCHIRMGRÖSSE
		CGSize screenSize = [CCDirector sharedDirector].winSize;
		
		//ACCELEROMETER UND TOUCHES BENÜTZEN
		self.isAccelerometerEnabled = YES;
		self.isTouchEnabled = YES;
		
		/*
		//LEVELDATEN INITIALISIEREN
		[[GameData sharedData] initLevel:1];
		*/
		
		//BACKGROUND
		CCSprite *bg = [CCSprite spriteWithFile:@"bg.png"];
		bg.position = ccp(160,240);
		[self addChild:bg z:-1];
		//PAUSELAYER
		pausedScreen = [[CCSprite alloc] initWithFile:@"pausedScreen.png"];
		pausedScreen.position = ccp(160,240);
		pausedScreen.visible = NO;
		[self addChild:pausedScreen z:2];
		
		//SPACEMGR
		smgr = [[SpaceManager alloc] init];
		smgr.gravity=ccp(0,0);
		
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
		for (int i=0; i<[[GameData sharedData].enemySpawnBuffer count]; i++) {
			CCArray *enemyToBeSpawned = [[CCArray alloc] initWithArray:[[GameData sharedData].enemySpawnBuffer objectAtIndex:i]];
			if ([enemyToBeSpawned count] != 0) {
				EnemySphere *feind = [EnemySphere enemyWithMgr:self.smgr level:[[enemyToBeSpawned objectAtIndex:0]intValue] position:[[enemyToBeSpawned objectAtIndex:1] CGPointValue] velocity:[[enemyToBeSpawned objectAtIndex:2] CGPointValue]];
				[self addChild:feind];
			} else {
				NSLog(@"enemyToBeSpawned has 0 Elements");
			}

			[enemyToBeSpawned release];
		}
		[[GameData sharedData].enemySpawnBuffer removeAllObjects];
		
		//GAMELOGIK REGISTRIEREN
		[self schedule:@selector(nextFrame:)];
		
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
		
		//COUNTDOWN
		countdown = [Countdown scene];
		[self addChild:countdown];
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
				//Sprite.parent vom enemyArray entfernen
				[[GameData sharedData].enemyArray removeObject:sprite.parent];
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
		
		[[GameData sharedData].enemyArray removeObject:sprite.parent];
		[self removeChild:sprite.parent cleanup:YES];
		[smgr scheduleToRemoveAndFreeShape:a];
		a->data = nil;
		[[GameData sharedData].enemyArray removeObject:sprite2.parent];
		[self removeChild:sprite2.parent cleanup:YES];
		[smgr scheduleToRemoveAndFreeShape:b];
		b->data = nil;
		
		[GameData sharedData].enemyCount -= 2;

		
		//LADE DATEN FÜR FEIND, DER KREIERT WERDEN SOLL, IN ARRAY
		CCArray *enemyToBeSpawned = [[CCArray alloc] init];
		//ARRAY MIT DATEN FÜLLEN:GRÖSSE, POSITION, GESCHWINDIGKEIT
		[enemyToBeSpawned addObject:[NSNumber numberWithInteger:newEnemySize]];
		[enemyToBeSpawned addObject:[NSValue valueWithCGPoint:newEnemyPosition]];
		[enemyToBeSpawned addObject:[NSValue valueWithCGPoint:newEnemyVelocity]];
		[[GameData sharedData].enemySpawnBuffer addObject:enemyToBeSpawned];
		[enemyToBeSpawned release];
	}
	
}


//GAME LOGIK
- (void) nextFrame:(ccTime)dt {
	if ([GameData sharedData].isCountdownFinished) {
		[self removeChild:countdown cleanup:YES];
		[smgr start];
		[GameData sharedData].isCountdownFinished = NO;
	}
	
	//WENN KEINE FEINDE MEHR, SPIEL BEENDEN
	if ([GameData sharedData].enemyCount == 0) {
		[self endGame];
	}
	
	//NEUER HERO
	if (![GameData sharedData].isThereAHero) {
		sphere = [Sphere sphereWithMgr:smgr level:[GameData sharedData].heroNewSize position:[GameData sharedData].heroPrevPos velocity:[GameData sharedData].heroPrevVelocity];
		[self addChild:sphere];
		[GameData sharedData].isThereAHero = YES;
	} else {
		//WENN HELD DA, ROTATION ÄNDERN
		sphere.sprite.rotation = -1*ccpToAngle(sphere.sprite.shape->body->v)*180/M_PI-90;
	}
	
	//1 NEUER FEIND PRO SCHRITT
	if ([[GameData sharedData].enemySpawnBuffer count] != 0) {
		CCArray *enemyToBeSpawned = [[CCArray alloc] initWithArray:[[GameData sharedData].enemySpawnBuffer objectAtIndex:0]];
		EnemySphere *feind = [EnemySphere enemyWithMgr:self.smgr level:[[enemyToBeSpawned objectAtIndex:0]intValue] position:[[enemyToBeSpawned objectAtIndex:1] CGPointValue] velocity:[[enemyToBeSpawned objectAtIndex:2] CGPointValue]];
		[self addChild:feind];
		[[GameData sharedData].enemySpawnBuffer removeObjectAtIndex:0];
		[enemyToBeSpawned release];
	}
	
	//ARGUMENT DER FEINDE ÄNDERN UND FEINDE BESCHLEUNIGEN
	for(EnemySphere *enemy in [GameData sharedData].enemyArray) {
		enemy.sprite.rotation = -1*ccpToAngle(enemy.sprite.shape->body->v)*180/M_PI-90;
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
		[sphere.sprite applyImpulse:ccpMult(v, kImpulseMultiplier)];
	}
	
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
}

- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        if (touch.tapCount >= 2) {
			if ([GameData sharedData].isGamePaused) {
				pausedScreen.visible = NO;
				[[CCDirector sharedDirector] resume];
				[GameData sharedData].isGamePaused = NO;
			}	else {
				[[CCDirector sharedDirector] pause];
				[GameData sharedData].isGamePaused = YES;
				pausedScreen.visible = YES;
			}
		}
    }
}

- (void)ccTouchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
}



-(void) onEnter
{
	[super onEnter];
	[[UIAccelerometer sharedAccelerometer] setUpdateInterval:(1.0 / 60)];
}

-(void)endGame
{
	NSLog(@"Ending Game");
	//ALLE OBJEKTE IN ENEMYARRAY WERDEN ENTFERNT, UM RETAINCOUNTS ZU VERRINGERN->KEINE MEMORY LEAKS
	[[GameData sharedData].enemyArray removeAllObjects];
	//SCHEDULERS ENTFERNEN, DASS GAMELAYER NICHT RETAINED WIRD
	[self unschedule:@selector(nextFrame:)];
	[smgr removeCollisionCallbackBetweenType:kHeroCollisionType otherType:kEnemyCollisionType];
	[smgr removeCollisionCallbackBetweenType:kEnemyCollisionType otherType:kEnemyCollisionType];
	[smgr stop];
	//ZURÜCK ZUM HAUPTMENU
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:[HelloWorld scene]]];
}

- (void) dealloc
{
	NSLog(@"Deallocating GameLayer");
	[pausedScreen release];
	[smgr release];
	[super dealloc];
}
@end
