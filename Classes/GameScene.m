//
//  GameScene.m
//  MaturaApp
//  © Zeno Koller 2010


#import "GameScene.h"
#import <AudioToolbox/AudioToolbox.h>

#define kHeroCollisionType	1
#define kEnemyCollisionType	2 
#define kNormalEnemy 0
#define kShrinkEnemy 1
#define kInitSize 16
#define kFilterFactor 0.5f
#define kImpulseMultiplier 100
#define kAccSteilheit 20
#define kAccInflektion 0.2


static float prevHeroRotation = 0;

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
		
		//GAMESCENE POINTER
		[GameData sharedData].gameScene = self;
		
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
		CCSprite *bg = [CCSprite spriteWithFile:@"BG/BG.png"];
		bg.position = ccp(160,240);
		[self addChild:bg z:-1];
		
		//PAUSELAYER
		pausedScreen = [CCSprite spriteWithFile:@"halfBlack.png"];
		pausedScreen.position = ccp(160,240);
		//TITLE
		CCSprite *title = [CCSprite spriteWithFile:@"pause_title.png"];
		title.position = ccp(160,420);
		[pausedScreen addChild:title];
		CCLabelBMFont* label1 = [CCLabelBMFont labelWithString:@"resume" fntFile:@"volter.fnt"];
		CCMenuItemLabel *menuItem1= [CCMenuItemLabel itemWithLabel:label1 target:self selector:@selector(resume:)];
		CCLabelBMFont* label2 = [CCLabelBMFont labelWithString:@"restart" fntFile:@"volter.fnt"];
		CCMenuItemLabel *menuItem2= [CCMenuItemLabel itemWithLabel:label2 target:self selector:@selector(restart:)];
		CCLabelBMFont* label3 = [CCLabelBMFont labelWithString:@"back to menu" fntFile:@"volter.fnt"];
		CCMenuItemLabel *menuItem3= [CCMenuItemLabel itemWithLabel:label3 target:self selector:@selector(backToMenu:)];
		CCMenu * myMenu = [CCMenu menuWithItems:menuItem1,menuItem2,menuItem3,nil];
		myMenu.position = ccp(160, 200);
		[myMenu alignItemsVertically];
		[pausedScreen addChild:myMenu];
		pausedScreen.visible = NO;
		[self addChild:pausedScreen z:2];
				
		//SPACEMGR
		smgr = [[SpaceManager alloc] init];
		smgr.gravity=ccp(0,0);
		
		//WÄNDE
		cpShape *bottomRect = [smgr addRectAt:cpv(-80,-160) mass:STATIC_MASS width:screenSize.width height:1 rotation:0];
		cpCCSprite *sBottomSprite = [cpCCSprite spriteWithShape:bottomRect file:@"blank.png"];
		sBottomSprite.position = ccp(0,0);
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
		sphere = [Sphere sphereWithMgr:self.smgr level:[GameData sharedData].heroStartLevel position:ccp(-80,80)];
		[self addChild:sphere];
		
		//FEINDE HINZUFÜGEN
		for (int i=0; i<[[GameData sharedData].enemySpawnBuffer count]; i++) {
			CCArray *enemyToBeSpawned = [[CCArray alloc] initWithArray:[[GameData sharedData].enemySpawnBuffer objectAtIndex:i]];
			if ([enemyToBeSpawned count] != 0) {
				EnemySphere *feind = [EnemySphere enemyWithMgr:self.smgr 
														  kind:[[enemyToBeSpawned objectAtIndex:0]intValue] 
														 level:[[enemyToBeSpawned objectAtIndex:1]intValue] 
													  position:[[enemyToBeSpawned objectAtIndex:2] CGPointValue]];
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
		cpCCSprite *sprite = (cpCCSprite*)b->data;
		int enemyMass = sprite.level;		
		if (enemyMass > sphere.level) {
			if ([UserData sharedData].isVibrationEnabled) {
				AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
			}
			[GameData sharedData].wasGameWon = NO;
			[GameData sharedData].enemyCount = 0;
			return;
		} else {
			if (sprite.isShrinkKind) {
					if (sphere.level == sprite.level) {
						if ([UserData sharedData].isVibrationEnabled) {
							AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
						}
						[GameData sharedData].wasGameWon = NO;
						[GameData sharedData].enemyCount = 0;
						return;
					}
					[[GameData sharedData].newHero addObject:[NSNumber numberWithInt:sphere.level-enemyMass]];
					[[GameData sharedData].newHero addObject:[NSValue valueWithCGPoint:sphere.sprite.position]];
			} else {
					[[GameData sharedData].newHero addObject:[NSNumber numberWithInt:sphere.level+enemyMass]];
					[[GameData sharedData].newHero addObject:[NSValue valueWithCGPoint:sphere.sprite.position]];
			}
			if (sphere) {
				[GameData sharedData].isThereAHero = NO;
				[self removeChild:sphere cleanup:YES];
				[smgr scheduleToRemoveAndFreeShape:a];
				a->data = nil;
			}
		
			if (sprite) {	
				[[GameData sharedData].enemyArray removeObject:sprite.parent];
				[self removeChild:sprite.parent cleanup:YES];
				[smgr scheduleToRemoveAndFreeShape:b];
				b->data = nil;
			}
		}
    }	
}
- (void) handleEnemyCollision:(CollisionMoment)moment arbiter:(cpArbiter*)arb space:(cpSpace*)space
{
	CP_ARBITER_GET_SHAPES(arb,a,b);
	if (moment == COLLISION_BEGIN) {
		cpCCSprite *spriteA = (cpCCSprite*)a->data;
		cpCCSprite *spriteB = (cpCCSprite*)b->data;
		int aSize = spriteA.level;
		int bSize = spriteB.level;
		int newKind = spriteA.enemyKind;
		CGPoint newPos = spriteA.position;
		int newSize = aSize	+ bSize;
		if (aSize < bSize) {
			newKind = spriteB.enemyKind;
			newPos = spriteB.position;
		}
		
		if (spriteA.isShrinkKind && spriteB.isShrinkKind) {
			if (aSize < bSize) {
				newSize = bSize - aSize;
			}
		} else if (!spriteA.isShrinkKind && spriteB.isShrinkKind) {
			if (aSize > bSize) {
				newSize = aSize - bSize;
			}
		}
		
		//FEINDE ENTFERNEN
		[[GameData sharedData].enemyArray removeObject:spriteA.parent];
		[self removeChild:spriteA.parent cleanup:YES];
		[smgr scheduleToRemoveAndFreeShape:a];
		a->data = nil;
		[[GameData sharedData].enemyArray removeObject:spriteB.parent];
		[self removeChild:spriteB.parent cleanup:YES];
		[smgr scheduleToRemoveAndFreeShape:b];
		b->data = nil;
		
		//DATEN FÜR NEUEN FEIND IN ARRAY
		CCArray *enemyToBeSpawned = [[CCArray alloc] init];
		[enemyToBeSpawned addObject:[NSNumber numberWithInteger:newKind]];
		[enemyToBeSpawned addObject:[NSNumber numberWithInteger:newSize]];
		[enemyToBeSpawned addObject:[NSValue valueWithCGPoint:newPos]];
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
							  position:[[[GameData sharedData].newHero objectAtIndex:1] CGPointValue]];
		[self addChild:sphere];
		[[GameData sharedData].newHero removeAllObjects];
		[GameData sharedData].isThereAHero = YES;
		//REDUZIERE ENEMYCOUNT		
		[GameData sharedData].enemyCount -= 1;
	} else if (![GameData sharedData].isGamePaused) {
		//ARGUMENT ÄNDERN
		sphere.sprite.rotation = (-1*ccpToAngle(sphere.sprite.shape->body->v)*180/M_PI-90)*0.2+prevHeroRotation*0.8;
		prevHeroRotation = sphere.sprite.rotation; 
	}

	
	//1 NEUER FEIND PRO SCHRITT
	if ([[GameData sharedData].enemySpawnBuffer count] != 0) {
		CCArray *enemyToBeSpawned = [[CCArray alloc] initWithArray:[[GameData sharedData].enemySpawnBuffer objectAtIndex:0]];
		EnemySphere *feind = [EnemySphere enemyWithMgr:self.smgr 
												  kind:[[enemyToBeSpawned objectAtIndex:0]intValue] 
												 level:[[enemyToBeSpawned objectAtIndex:1]intValue] 
											  position:[[enemyToBeSpawned objectAtIndex:2] CGPointValue]];
		[self addChild:feind];
		[[GameData sharedData].enemySpawnBuffer removeObjectAtIndex:0];
		[enemyToBeSpawned release];
		//REDUZIERE ENEMYCOUNT		
		[GameData sharedData].enemyCount -= 1;
	}
	
	//WENN KEINE FEINDE MEHR, SPIEL BEENDEN 
	if ([GameData sharedData].enemyCount == 0) {
		[self endGame];
	}
}


- (void)accelerometer:(UIAccelerometer*)accelerometer didAccelerate:(UIAcceleration*)acceleration
{	
	static float prevX=0, prevY=0;
		
	float accelX = (float) (acceleration.x -[UserData sharedData].accelCorrectionX) * kFilterFactor + (1- kFilterFactor)*prevX;
	float accelY = (float) (acceleration.y -[UserData sharedData].accelCorrectionY) * kFilterFactor + (1- kFilterFactor)*prevY;
	
	prevX = accelX;
	prevY = accelY;

	if (accelX > 0) {
		accelX = 1/(1+exp(-kAccSteilheit*(accelX-kAccInflektion)));
	} else {
		accelX = -1/(1+exp(-kAccSteilheit*(-1*accelX-kAccInflektion)));
	}
	
	if (accelY > 0) {
		accelY = 1/(1+exp(-kAccSteilheit*(accelY-kAccInflektion)));
	} else {
		accelY = -1/(1+exp(-kAccSteilheit*(-1*accelY-kAccInflektion)));
	}

	CGPoint v = ccp(accelX, accelY);
	if ([GameData sharedData].isThereAHero) {
		sphere.sprite.shape->body->v = ccpMult(v, kImpulseMultiplier);
	}
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
}

- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
		if (![GameData sharedData].isGamePaused && [GameData sharedData].isPlaying) {
			[self pause];
		} 
	}
}

- (void)ccTouchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
}

-(void) pause {
	NSLog(@"App pauses");
	[smgr stop];
	[GameData sharedData].isGamePaused = YES;
	pausedScreen.visible = YES;
}

-(void)resume:(CCMenuItem *) menuItem {
	if ([GameData sharedData].isGamePaused) {
		pausedScreen.visible = NO;	
		[smgr start];
		[GameData sharedData].isGamePaused = NO;
	}
}

-(void)restart:(CCMenuItem *)menuItem {
	if ([GameData sharedData].isGamePaused) {
		NSLog(@"Ending Game");
		[GameData sharedData].isPlaying = NO;
		//ALLE OBJEKTE IN ENEMYARRAY WERDEN ENTFERNT, UM RETAINCOUNTS ZU VERRINGERN->KEINE MEMORY LEAKS
		[[GameData sharedData].enemyArray removeAllObjects];
		//SCHEDULERS ENTFERNEN, DASS GAMELAYER NICHT RETAINED WIRD
		[self unschedule:@selector(nextFrame:)];
		[smgr stop];
		[smgr removeCollisionCallbackBetweenType:kHeroCollisionType otherType:kEnemyCollisionType];
		[smgr removeCollisionCallbackBetweenType:kEnemyCollisionType otherType:kEnemyCollisionType];
		//INITIALISIERE GLEICHES LEVEL
		[[GameData sharedData] initLevel:[UserData sharedData].currentLevel withWorld:[UserData sharedData].currentWorld];
		[[CCDirector sharedDirector] replaceScene:
		 [CCTransitionFade transitionWithDuration:0.5f scene:[GameScene scene]]];
	}
}

-(void)backToMenu:(CCMenuItem *) menuItem {
	if ([GameData sharedData].isGamePaused) {
		NSLog(@"Ending Game");
		[GameData sharedData].isPlaying = NO;
		if ([GameData sharedData].isThereAHero) {
			sphere.sprite.rotation = prevHeroRotation;
		}		
		//ALLE OBJEKTE IN ENEMYARRAY WERDEN ENTFERNT, UM RETAINCOUNTS ZU VERRINGERN->KEINE MEMORY LEAKS
		[[GameData sharedData].enemyArray removeAllObjects];
		//SCHEDULERS ENTFERNEN, DASS GAMELAYER NICHT RETAINED WIRD
		[self unschedule:@selector(nextFrame:)];
		[smgr stop];
		[smgr removeCollisionCallbackBetweenType:kHeroCollisionType otherType:kEnemyCollisionType];
		[smgr removeCollisionCallbackBetweenType:kEnemyCollisionType otherType:kEnemyCollisionType];
		//ZU HELLOWORLD LAYER
		[[CCDirector sharedDirector] replaceScene:
		 [CCTransitionFade transitionWithDuration:0.5f scene:[HelloWorld scene]]];
	}
}

-(void) startGame {
	NSLog(@"Starting Game");
	self.isAccelerometerEnabled = YES;
	[[UIAccelerometer sharedAccelerometer] setUpdateInterval:(1.0 / 60)];
	[self removeChild:countdown cleanup:YES];
	[smgr start];
	[GameData sharedData].isCountdownFinished = NO;
	[GameData sharedData].isPlaying = YES;
}


-(void)endGame
{
	NSLog(@"Ending Game");
	[GameData sharedData].isPlaying = NO;
	if ([GameData sharedData].isThereAHero) {
		sphere.sprite.rotation = prevHeroRotation;
	}
	//SCHEDULERS ENTFERNEN, DASS GAMELAYER NICHT RETAINED WIRD
	[self unschedule:@selector(nextFrame:)];
	[smgr stop];
	[smgr removeCollisionCallbackBetweenType:kHeroCollisionType otherType:kEnemyCollisionType];
	[smgr removeCollisionCallbackBetweenType:kEnemyCollisionType otherType:kEnemyCollisionType];
	//***************
	//ALLE OBJEKTE IN ENEMYARRAY WERDEN ENTFERNT, UM RETAINCOUNTS ZU VERRINGERN->KEINE MEMORY LEAKS
	[[GameData sharedData].enemyArray removeAllObjects];
	//ZU GAMEOVER LAYER

	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:[GameOver scene]]];
}


- (void) dealloc
{
	NSLog(@"Deallocating GameLayer");
	[smgr release];
	[super dealloc];
}
@end
