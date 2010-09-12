//
//  GameScene.m
//  MaturaApp


#import "GameScene.h"
#import "HelloWorldScene.h"
#import "CCTouchDispatcher.h"

#define kBallCollisionType	1	//Spielfigur
#define kCircleCollisionType	2 //Feind
#define kRectCollisionType	3
#define kFragShapeCollisionType	4

id action;

@implementation GameScene

@synthesize sphere, smgr;

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameScene *layer = [GameScene node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super initWithColor:ccc4(0,0,0,255)] )) {
		//Bildschirmgrösse bekommen für Mitte-Positionierung
		//TBD in AppData auslagern
		CGSize screenSize = [CCDirector sharedDirector].winSize;
		
		//Accelerometer benützen
		self.isAccelerometerEnabled = YES;
				
		//Level initialisieren
		//Später: level von LevelAuswahl heraus initialisieren
		[[GameData sharedData] initLevel];
		
		//Touches benützen können:
		//[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
				
		//Gamelogik initialisieren:
		[self schedule:@selector(nextFrame:)];
		
		//SpaceMgr
		//SpaceMgr initialisation plus Fenster-Wände
		smgr = [[SpaceManager alloc] init];
		smgr.gravity=ccp(0,0);
		[smgr start];	
		
		//Wände
		//TBD: Auslagern
		//TBD ins point system umschreiben
		
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
		
		
		//Spielfigur initialisieren
		
		sphere = [[Sphere alloc] initWithMgr:self.smgr level:1 position:ccp(-80,80) velocity:ccp(0,0)];
		[self addChild:sphere];
		
		//Feinde hinzufügen
		//TBD: jeweils Feind zu Array hinzufügen
		//TBD: aus XML lesen
		
		EnemySphere *feind = [[EnemySphere alloc] initWithMgr:self.smgr level:1 position:ccp(-35,-40) velocity:ccp(300,220)];
		[self addChild:feind];
		EnemySphere *feind2 = [[EnemySphere alloc] initWithMgr:self.smgr level:2 position:ccp(-140,-110) velocity:ccp(-300,40)];
		[self addChild:feind2];
		EnemySphere *feind3 = [[EnemySphere alloc] initWithMgr:self.smgr level:1 position:ccp(60,-80) velocity:ccp(400,-440)];
		[self addChild:feind3];
		EnemySphere *feind4 = [[EnemySphere alloc] initWithMgr:self.smgr level:1 position:ccp(40,140) velocity:ccp(200,-100)];
		[self addChild:feind4];
		
		//Registriere den Collision handler für Spielfigur:
		[smgr addCollisionCallbackBetweenType:kBallCollisionType
									otherType:kCircleCollisionType
									   target:self 
									 selector:@selector(handleOwnCollision:arbiter:space:)];
		
		//Registriere den Collision handler für Spielfigur:
		[smgr addCollisionCallbackBetweenType:kCircleCollisionType
									otherType:kCircleCollisionType
									   target:self 
									 selector:@selector(handleEnemyCollision:arbiter:space:)];
		
	}
	return self;
}

-(void) onEnter
{
	[super onEnter];
	[[UIAccelerometer sharedAccelerometer] setUpdateInterval:(1.0 / 60)];
}

//COLLISION HANDLING
- (void) handleOwnCollision:(CollisionMoment)moment arbiter:(cpArbiter*)arb space:(cpSpace*)space
{
	CP_ARBITER_GET_SHAPES(arb,a,b);
	switch(moment)
    {
        case COLLISION_BEGIN:
			NSLog(@"Collision detected!");
			cpCCSprite *sprite = (cpCCSprite*)b->data;
			int enemyMass = (int)round(fabs(sprite.shape->body->m));		
			if (enemyMass > sphere.level) {
				//Hier später Gefressenwerd-Animation einbauen, vorerst wird nur Spiel gestoppt
				[smgr stop];
				[[CCDirector sharedDirector] replaceScene:
				 [CCTransitionFade transitionWithDuration:0.5f scene:[HelloWorld scene]]];
			} else {
				if (sprite)
				{	
					[sprite.parent removeChild:sprite cleanup:YES];
					[smgr scheduleToRemoveAndFreeShape:b];
					b->data = nil;
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

			break;
        case COLLISION_PRESOLVE:
			//arb->e = 5;
			//Zum beispiel abstossende grössere feinde
			break;
        case COLLISION_POSTSOLVE:
			break;
        case COLLISION_SEPARATE:
			//shapes separated, do something awesome!
			break;
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

		[sprite.parent removeChild:sprite cleanup:YES];
		[smgr scheduleToRemoveAndFreeShape:a];
		a->data = nil;
		[sprite2.parent removeChild:sprite2 cleanup:YES];
		[smgr scheduleToRemoveAndFreeShape:b];
		b->data = nil;
		
		//Daten in EnemySpawnBuffer laden (prevPos, v, newMass)
		NSMutableArray *enemyToBeSpawned = [[NSMutableArray alloc] init];
		//Array mit Daten: size, position, velocity
		[enemyToBeSpawned addObject:[NSNumber numberWithInteger:newEnemySize]];
		[enemyToBeSpawned addObject:[NSValue valueWithCGPoint:newEnemyPosition]];
		[enemyToBeSpawned addObject:[NSValue valueWithCGPoint:newEnemyVelocity]];
		[[GameData sharedData].enemySpawnBuffer addObject:enemyToBeSpawned];
	}
				
}


//GAME LOGIK
- (void) nextFrame:(ccTime)dt {
	//neue Sphere
	if (![GameData sharedData].isThereAHero) {
		sphere = [[Sphere alloc] initWithMgr:smgr level:[GameData sharedData].heroNewSize position:[GameData sharedData].heroPrevPos velocity:[GameData sharedData].heroPrevVelocity];
		[self addChild:sphere];
		[GameData sharedData].isThereAHero = YES;
		//CCFiniteTimeAction *zoomAction = [CCScaleTo actionWithDuration:0.1f scale:1.1f];// zoom in
		//CCFiniteTimeAction *shrinkAction = [CCScaleTo actionWithDuration:0.1f scale:1];// zoom out
		//CCSequence *actions = [CCSequence actions:zoomAction, shrinkAction, nil];// zoom in, then zoom out
		//[sphere runAction:actions];// now
	}
	//neuer Feind
	//bis jetzt nur einer pro Frame
	if ([[GameData sharedData].enemySpawnBuffer count] != 0) {
		//NSMutableArray *enemyToBeSpawned = (NSMutableArray *)[levelData.enemySpawnBuffer objectAtIndex:0];
		NSMutableArray *enemyToBeSpawned = [[NSMutableArray alloc] initWithArray:[[GameData sharedData].enemySpawnBuffer objectAtIndex:0]];
		EnemySphere *feind = [[EnemySphere alloc] initWithMgr:self.smgr level:[[enemyToBeSpawned objectAtIndex:0]intValue] position:[[enemyToBeSpawned objectAtIndex:1] CGPointValue] velocity:[[enemyToBeSpawned objectAtIndex:2] CGPointValue]];
		[self addChild:feind];
		[[GameData sharedData].enemySpawnBuffer removeObjectAtIndex:0];
		[enemyToBeSpawned release];
	}
}


- (void)accelerometer:(UIAccelerometer*)accelerometer didAccelerate:(UIAcceleration*)acceleration
{	
	static float prevX=0, prevY=0, prevZ;
	
#define kFilterFactor 0.5f
	
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


// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	[sphere release];
	[smgr release];
	[super dealloc];
}
@end
