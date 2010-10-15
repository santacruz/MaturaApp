//
//  GameScene.m
//  MaturaApp
//  © Zeno Koller 2010


#import "GameScene.h"
#import "CCTouchDispatcher.h"
#import "GameOver.h"
#import "HelloWorldScene.h"

#define kHeroCollisionType	1
#define kEnemyCollisionType	2 
#define kInitSize 12.5
#define kFilterFactor 0.5f
#define kImpulseMultiplier 500
#define kNormalEnemy 0

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
		/*PASSIERT, WENN DER COUNTDOWN FERTIG IST
		self.isAccelerometerEnabled = YES;*/
		self.isTouchEnabled = YES;
	
		/*
		//LEVELDATEN INITIALISIEREN
		passiert in [LevelChoice runGameX]
		[[GameData sharedData] initLevel:1];
		*/
		
		//BACKGROUND
		CCSprite *bg = [CCSprite spriteWithFile:@"BG/bg.png"];
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
				EnemySphere *feind = [EnemySphere enemyWithMgr:self.smgr 
														  kind:[[enemyToBeSpawned objectAtIndex:0]intValue] 
														 level:[[enemyToBeSpawned objectAtIndex:1]intValue] 
													  position:[[enemyToBeSpawned objectAtIndex:2] CGPointValue] 
													  velocity:[[enemyToBeSpawned objectAtIndex:3] CGPointValue]];
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
		int enemyMass = sprite.level;		
		if (enemyMass > sphere.level) {
			[GameData sharedData].wasGameWon = NO;
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
				[[GameData sharedData].newHero addObject:[NSNumber numberWithInt:sphere.level+enemyMass]];
				[[GameData sharedData].newHero addObject:[NSValue valueWithCGPoint:sphere.sprite.position]];
				[[GameData sharedData].newHero addObject:[NSValue valueWithCGPoint:sphere.sprite.shape->body->v]];
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
		int aSize = sprite.level;
		int bSize = sprite2.level;
		int newEnemySize = aSize + bSize;
		int newKind = kNormalEnemy;
		CGPoint newEnemyPosition = ccp(0,0);
		CGPoint newEnemyVelocity = ccp(0,0);
		
		if (aSize > bSize) {
			newKind = sprite.enemyKind;
			newEnemyPosition = sprite.position;
			newEnemyVelocity = sprite.shape->body->v;
		} else if (bSize > aSize) {
			newKind = sprite2.enemyKind;
			newEnemyPosition = sprite2.position;
			newEnemyVelocity = sprite2.shape->body->v;
		} else {
			newKind = sprite.enemyKind;
			newEnemyPosition = ccpMidpoint(sprite.position, sprite2.position);
			newEnemyVelocity = ccpAdd(sprite.shape->body->v, sprite2.shape->body->v);
		}
				
		[[GameData sharedData].enemyArray removeObject:sprite.parent];
		[self removeChild:sprite.parent cleanup:YES];
		[smgr scheduleToRemoveAndFreeShape:a];
		a->data = nil;
		[[GameData sharedData].enemyArray removeObject:sprite2.parent];
		[self removeChild:sprite2.parent cleanup:YES];
		[smgr scheduleToRemoveAndFreeShape:b];
		b->data = nil;
		
		//[GameData sharedData].enemyCount -= 2;
		
		
		//LADE DATEN FÜR FEIND, DER KREIERT WERDEN SOLL, IN ARRAY
		CCArray *enemyToBeSpawned = [[CCArray alloc] init];
		//ARRAY MIT DATEN FÜLLEN:GRÖSSE, POSITION, GESCHWINDIGKEIT
		[enemyToBeSpawned addObject:[NSNumber numberWithInteger:newKind]];
		[enemyToBeSpawned addObject:[NSNumber numberWithInteger:newEnemySize]];
		[enemyToBeSpawned addObject:[NSValue valueWithCGPoint:newEnemyPosition]];
		[enemyToBeSpawned addObject:[NSValue valueWithCGPoint:newEnemyVelocity]];
		[[GameData sharedData].enemySpawnBuffer addObject:enemyToBeSpawned];
		[enemyToBeSpawned release];
	}
	
}


//GAME LOGIK
- (void) nextFrame:(ccTime)dt {
	//COUNTDOWN BEENDEN UND SPIEL STARTEN
	if ([GameData sharedData].isCountdownFinished) {
		[self startGame];
	}
		
	//NEUER HERO
	if (![GameData sharedData].isThereAHero) {
		sphere = [Sphere sphereWithMgr:smgr level:[[[GameData sharedData].newHero objectAtIndex:0] intValue] 
							  position:[[[GameData sharedData].newHero objectAtIndex:1] CGPointValue] 
							  velocity:[[[GameData sharedData].newHero objectAtIndex:2] CGPointValue]];
		[self addChild:sphere];
		[[GameData sharedData].newHero removeAllObjects];
		[GameData sharedData].isThereAHero = YES;
		//ANIMATION
		float originalScale = sphere.scale;
		id zoomIn = [CCScaleTo actionWithDuration:0.1f scale:1.2f*originalScale];
		id zoomOut = [CCScaleTo actionWithDuration:0.1f scale:originalScale];
		[sphere.sprite runAction:[CCSequence actions:zoomIn,zoomOut, nil]];
	} else {
		//WENN HELD DA, ROTATION ÄNDERN
		sphere.sprite.rotation = -1*ccpToAngle(sphere.sprite.shape->body->v)*180/M_PI-90;
	}
	
	//WENN KEINE FEINDE MEHR, SPIEL BEENDEN 
	if ([GameData sharedData].enemyCount == 0) {
		[GameData sharedData].wasGameWon = YES;
		[self endGame];
	}
	
	//1 NEUER FEIND PRO SCHRITT
	if ([[GameData sharedData].enemySpawnBuffer count] != 0) {
		CCArray *enemyToBeSpawned = [[CCArray alloc] initWithArray:[[GameData sharedData].enemySpawnBuffer objectAtIndex:0]];
		EnemySphere *feind = [EnemySphere enemyWithMgr:self.smgr 
												  kind:[[enemyToBeSpawned objectAtIndex:0]intValue] 
												 level:[[enemyToBeSpawned objectAtIndex:1]intValue] 
											  position:[[enemyToBeSpawned objectAtIndex:2] CGPointValue] 
											  velocity:[[enemyToBeSpawned objectAtIndex:3] CGPointValue]];
		[self addChild:feind];
		[[GameData sharedData].enemySpawnBuffer removeObjectAtIndex:0];
		[enemyToBeSpawned release];
		
		//ANIMATION
		float originalScale = feind.scale;
		id zoomIn = [CCScaleTo actionWithDuration:0.1f scale:1.2f*originalScale];
		id zoomOut = [CCScaleTo actionWithDuration:0.1f scale:originalScale];
		[feind.sprite runAction:[CCSequence actions:zoomIn,zoomOut, nil]];
		
		//ENEMYCOUNT VON DER VORHERIGEN KOLLISION ERST HIER REDUZIEREN
		[GameData sharedData].enemyCount -= 2;
	}
	
	//ARGUMENT DER FEINDE ÄNDERN UND FEINDE BESCHLEUNIGEN
	for(EnemySphere *enemy in [GameData sharedData].enemyArray) {
		enemy.sprite.rotation = -1*ccpToAngle(enemy.sprite.shape->body->v)*180/M_PI-90;
	}
}

- (void)accelerometer:(UIAccelerometer*)accelerometer didAccelerate:(UIAcceleration*)acceleration
{	
	static float prevX=0, prevY=0;
		
	float accelX = (float) acceleration.x * kFilterFactor + (1- kFilterFactor)*prevX;
	float accelY = (float) acceleration.y * kFilterFactor + (1- kFilterFactor)*prevY;
	//float accelZ = (float) acceleration.z; //* kFilterFactor + (1- kFilterFactor)*prevZ;
	
	prevX = accelX;
	prevY = accelY;
	//prevZ = accelZ;
	
	CGPoint v = ccp( accelX, accelY);
	
	if ([GameData sharedData].isThereAHero) {
		sphere.sprite.shape->body->v = ccpMult(v, kImpulseMultiplier);
	}
	/*
	if ([GameData sharedData].isThereAHero) {
		[sphere.sprite applyImpulse:ccpMult(v, kImpulseMultiplier)];
	}
	*/
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
	/*PASSIERT, WENN DER COUNTDOWN FERTIG IST
	 !!!
	 FALLS ES SO BLEIBT, METHODE onEnter ENTFERNEN
	 !!!
	[[UIAccelerometer sharedAccelerometer] setUpdateInterval:(1.0 / 60)];*/
}

-(void) startGame {
	NSLog(@"Starting Game");
	self.isAccelerometerEnabled = YES;
	[[UIAccelerometer sharedAccelerometer] setUpdateInterval:(1.0 / 60)];
	[self removeChild:countdown cleanup:YES];
	[smgr start];
	[GameData sharedData].isCountdownFinished = NO;
}


-(void)endGame
{
	NSLog(@"Ending Game");
	if ([GameData sharedData].isThereAHero) {
		sphere.sprite.rotation = -1*ccpToAngle(sphere.sprite.shape->body->v)*180/M_PI-90;
	}
	//ALLE OBJEKTE IN ENEMYARRAY WERDEN ENTFERNT, UM RETAINCOUNTS ZU VERRINGERN->KEINE MEMORY LEAKS
	[[GameData sharedData].enemyArray removeAllObjects];
	//SCHEDULERS ENTFERNEN, DASS GAMELAYER NICHT RETAINED WIRD
	[self unschedule:@selector(nextFrame:)];
	[smgr removeCollisionCallbackBetweenType:kHeroCollisionType otherType:kEnemyCollisionType];
	[smgr removeCollisionCallbackBetweenType:kEnemyCollisionType otherType:kEnemyCollisionType];
	[smgr stop];
	//ZU GAMEOVER LAYER
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:[GameOver scene]]];
}

- (void) dealloc
{
	NSLog(@"Deallocating GameLayer");
	[pausedScreen release];
	[smgr release];
	[super dealloc];
}
@end
