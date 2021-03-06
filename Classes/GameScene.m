//
//  GameScene.m
//  MaturaApp
//  © Zeno Koller 2010
//	
//	Diese Klasse stellt den Spielbildschirm dar.

#import "GameScene.h"
#import <AudioToolbox/AudioToolbox.h>

#define kHeroCollisionType	1
#define kEnemyCollisionType	2 
#define kNormalEnemy 0
#define kShrinkEnemy 1
#define	kFollowEnemy 2
#define kFastEnemy 3
#define kUltraEnemy 4
#define kInitSize 16
#define kFilterFactor 0.5f
#define kImpulseMultiplier 100
#define kAccSteilheit 20
#define kAccInflektion 0.2


static float prevHeroRotation = 0;

@implementation GameScene

@synthesize sphere, smgr, pausedScreen, pauseButton, countdown, accHelper;

//FÜGE EINE INSTANZ DIESER KLASSE HINZU
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
						
		//BACKGROUND
		CCSprite *bg = [CCSprite spriteWithFile:@"BG/BG.png"];
		bg.position = ccp(160,240);
		[self addChild:bg z:-1];
		
		//PAUSEBUTTON
		CCSprite *paused = [CCSprite spriteWithFile:@"pause.png"];
		CCSprite *paused_s = [CCSprite spriteWithFile:@"pause.png"];
		[paused_s setColor:ccc3(172, 224, 250)];
		CCMenuItemSprite *pauseItem = [CCMenuItemSprite itemFromNormalSprite:paused selectedSprite:paused_s target:self selector:@selector(pause:)];
		pauseButton = [CCMenu menuWithItems:pauseItem, nil];
		pauseButton.position = ccp(35,445);
		[self addChild:pauseButton z:50];
		//PAUSELAYER
		pausedScreen = [CCSprite spriteWithFile:@"halfBlack.png"];
		pausedScreen.position = ccp(160,240);
		//TITLE
		CCSprite *title = [CCSprite spriteWithFile:@"pause_title.png"];
		title.position = ccp(160,420);
		[pausedScreen addChild:title];
		CCLabelBMFont* label1 = [CCLabelBMFont labelWithString:@"resume" fntFile:@"volter.fnt"];
		MenuFont *menuItem1= [MenuFont itemWithLabel:label1 target:self selector:@selector(resume:)];
		CCLabelBMFont* label2 = [CCLabelBMFont labelWithString:@"restart" fntFile:@"volter.fnt"];
		MenuFont *menuItem2= [MenuFont itemWithLabel:label2 target:self selector:@selector(restart:)];
		CCLabelBMFont* label3 = [CCLabelBMFont labelWithString:@"back to menu" fntFile:@"volter.fnt"];
		MenuFont *menuItem3= [MenuFont itemWithLabel:label3 target:self selector:@selector(backToMenu:)];
		CCMenu * myMenu = [CCMenu menuWithItems:menuItem1,menuItem2,menuItem3,nil];
		myMenu.position = ccp(160, 200);
		[myMenu alignItemsVertically];
		[pausedScreen addChild:myMenu];
		pausedScreen.visible = NO;
		[self addChild:pausedScreen z:2];
		
		//SPACEMGR
		smgr = [[SpaceManagerCocos2d alloc] init];
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
		
		//TOOL FÜR DIE BERECHNUNG VON VON SKALARPRODUKTEN
		accHelper = [[AccHelper alloc] init];
		
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
		
		//SOUND SETUP
		[self setupSound];
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
				[smgr removeAndFreeShape:a];
				a->data = nil;
			}
			
			if (sprite) {	
				[[GameData sharedData].enemyArray removeObject:sprite.parent];
				[self removeChild:sprite.parent cleanup:YES];
				[smgr removeAndFreeShape:b];
				b->data = nil;
			}
		}
    }	
}

//COLLISION HANDLING
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
		} else if (aSize == bSize && spriteA.isShrinkKind) {
			newKind = spriteA.enemyKind;
		} else if (aSize == bSize && spriteB.isShrinkKind) {
			newKind = spriteB.enemyKind;
		} 

		if (!spriteA.isShrinkKind && spriteB.isShrinkKind) {
			if (aSize > bSize) {
				newSize = aSize - bSize;
			}
		} else  if (spriteA.isShrinkKind && !spriteB.isShrinkKind) {
			if (bSize > aSize) {
				newSize = bSize - aSize;
			}
		} else if (spriteA.isShrinkKind && spriteB.isShrinkKind) {
			if (spriteA.enemyKind != spriteB.enemyKind) {
				newSize = aSize-bSize;
				if (bSize > aSize) {
					newSize = bSize - aSize;
				}
			}
		}
		
		//FEINDE ENTFERNEN
		[[GameData sharedData].enemyArray removeObject:spriteA.parent];
		[self removeChild:spriteA.parent cleanup:YES];
		[smgr removeAndFreeShape:a];
		a->data = nil;
		[[GameData sharedData].enemyArray removeObject:spriteB.parent];
		[self removeChild:spriteB.parent cleanup:YES];
		[smgr removeAndFreeShape:b];
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


//GAME LOOP
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
		[sphere zoom];
		[plop play];
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
		[feind zoom];
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

//BESCHLEUNGIGUNSSENSOR-LOOP
- (void)accelerometer:(UIAccelerometer*)accelerometer didAccelerate:(UIAcceleration*)acceleration
{	
	
	static float prevVx=0, prevVy=0;

	//BERECHNE BESCHLEUNIGUNG IN ALLEN MÖGLICHEN SYSTEMEN
	NSArray *accelData = [NSArray arrayWithObjects:[NSNumber numberWithFloat:acceleration.x],[NSNumber numberWithFloat:acceleration.y],[NSNumber numberWithFloat:acceleration.z],nil];
	float Vx = (float) -1*[accHelper dotVec1:[UserData sharedData].xGrund Vec2:accelData]*kFilterFactor + (1 - kFilterFactor)*prevVx;
	float Vy = (float) [accHelper dotVec1:[UserData sharedData].yGrund Vec2:accelData]*kFilterFactor + (1 - kFilterFactor)*prevVy;
	
	//VERHINDERT RAUSCHEN
	prevVx= Vx;
	prevVy = Vy;
	
	//ANGENEHMERE BEDIENUNG
	Vx = [accHelper sign:Vx]*1/(1+exp(-kAccSteilheit*([accHelper sign:Vx]*Vx-kAccInflektion)));
	Vy = [accHelper sign:Vy]*1/(1+exp(-kAccSteilheit*([accHelper sign:Vy]*Vy-kAccInflektion)));
	
	CGPoint v = ccp(Vx, Vy);
	if ([GameData sharedData].isThereAHero) {
		sphere.sprite.shape->body->v = ccpMult(v, kImpulseMultiplier);
	}
}

//PAUSIERE DAS SPIEL
-(void)pause:(CCMenuItem *) menuItem{
	if (![GameData sharedData].isGamePaused && [GameData sharedData].isPlaying) {
		[smgr stop];
		[GameData sharedData].isGamePaused = YES;
		pauseButton.visible = NO;
		pausedScreen.visible = YES;
	} 
}

//WIRD AUFGERUFEN, FALLS APPLIKATION IN DEN HINTERGRUND TRITT (WIRD GESCHLOSSEN ETC)
-(void)enterBackground {
	if (![GameData sharedData].isGamePaused && [GameData sharedData].isPlaying) {
		[smgr stop];
		[GameData sharedData].isGamePaused = YES;
		pauseButton.visible = NO;
		pausedScreen.visible = YES;
	} 
}

//PAUSIERTES SPIEL FORTFAHREN
-(void)resume:(CCMenuItem *) menuItem {
	if ([GameData sharedData].isGamePaused) {
		pausedScreen.visible = NO;
		pauseButton.visible = YES;
		[smgr start];
		[GameData sharedData].isGamePaused = NO;
	}
}

//FANGE SPIEL NEU AN
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

//BRECHE SPIEL AB UND GEHE ZURÜCK ZUM MENU
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

//BEGINNE DAS SPIEL NACHDEM DER COUNTDOWN ABGELAUFEN IST
-(void) startGame {
	NSLog(@"Starting Game");
	self.isAccelerometerEnabled = YES;
	[[UIAccelerometer sharedAccelerometer] setUpdateInterval:(1.0 / 60)];
	[self removeChild:countdown cleanup:YES];
	[smgr start];
	[GameData sharedData].isCountdownFinished = NO;
	[GameData sharedData].isPlaying = YES;
}

-(void)setupSound {
	sae = [SimpleAudioEngine sharedEngine];
	[[CDAudioManager sharedManager] setResignBehavior:kAMRBStopPlay autoHandle:YES];
	actionManager = [CCActionManager sharedManager];
	plop = [[sae soundSourceForFile:@"pop.wav"] retain];
}

//BEENDE DAS SPIEL
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

//INSTANZ WIRD AUS MEMORY GELÖSCHT
- (void) dealloc
{
	NSLog(@"Deallocating GameLayer");
	[[CCDirector sharedDirector] purgeCachedData];
	[accHelper release];
	[smgr release];
	[actionManager removeAllActionsFromTarget:plop];
	//This is to stop any actions that may be modifying the background music
	[actionManager removeAllActionsFromTarget:[[CDAudioManager sharedManager] audioSourceForChannel:kASC_Left]];
	//This is to stop any actions that may be running against the sound engine i.e. fade sound effects
	[actionManager removeAllActionsFromTarget:[CDAudioManager sharedManager].soundEngine];
	[plop release];
	
	[SimpleAudioEngine end];
	sae = nil;
	[super dealloc];
}
@end