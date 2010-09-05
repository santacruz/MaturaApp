//
//  GameScene.m
//  MaturaApp


#import "GameScene.h"
#import "HelloWorldScene.h"
#import "CCTouchDispatcher.h"

#define kBallCollisionType	1
#define kCircleCollisionType	2
#define kRectCollisionType	3
#define kFragShapeCollisionType	4

id action;

@implementation GameScene

@synthesize smgr, prevSize, isThereASphere, prevPos, prevVelocity;
@synthesize sphere;

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
		CGSize screenSize = [CCDirector sharedDirector].winSize;
		
		//Accelerometer benützen
		self.isAccelerometerEnabled = YES;
		
		
		//Touches benützen können:
		//[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
		
		//No Sphere:
		isThereASphere = YES;
		
		//Gamelogik initialisieren:
		[self schedule:@selector(nextFrame:)];
		
		//SpaceMgr
		//SpaceMgr initialisation plus Fenster-Wände
		smgr = [[SpaceManager alloc] init];
		smgr.gravity=ccp(0,0);
		[smgr start];	
		
		//Wände
		
		cpShape *bottomRect = [smgr addRectAt:cpv(0,-1*screenSize.height/2) mass:STATIC_MASS width:screenSize.width height:1 rotation:0];
		cpCCSprite *sBottomSprite = [cpCCSprite spriteWithShape:bottomRect file:@"blank.png"];
		sBottomSprite.position = ccp(0,0);
		//bottomRect->e=2.0;
		[self addChild:sBottomSprite];
		cpShape *upperRect = [smgr addRectAt:cpv(0,screenSize.height/2) mass:STATIC_MASS width:screenSize.width height:1 rotation:0];
		cpCCSprite *sUpperSprite = [cpCCSprite spriteWithShape:upperRect file:@"blank.png"];
		sUpperSprite.position = ccp(0,0);
		[self addChild:sUpperSprite];		
		cpShape *leftRect = [smgr addRectAt:cpv(-1*screenSize.width/2,0) mass:STATIC_MASS width:1 height:screenSize.height rotation:0];
		cpCCSprite *sLeftSprite = [cpCCSprite spriteWithShape:leftRect file:@"blank.png"];
		sLeftSprite.position = ccp(0,0);
		[self addChild:sLeftSprite];		
		cpShape *rightRect = [smgr addRectAt:cpv(screenSize.width/2,0) mass:STATIC_MASS width:1 height:screenSize.height rotation:0];
		cpCCSprite *sRightSprite = [cpCCSprite spriteWithShape:rightRect file:@"blank.png"];
		sRightSprite.position = ccp(0,0);
		[self addChild:sRightSprite];
		
		
		//Spielfigur initialisieren (Später: Level-Layouts aus Tabellen lesen):
		sphere = [[Sphere alloc] initWithMgr:self.smgr level:1 position:ccp(0,0) velocity:ccp(0,0)];
		[self addChild:sphere];
		
		EnemySphere *feind = [[EnemySphere alloc] initWithMgr:self.smgr level:1];
		feind.sprite.position = ccp(200,80);
		[feind.sprite applyImpulse:ccp(150,110)];
		[self addChild:feind];
		
		EnemySphere *feind2 = [[EnemySphere alloc] initWithMgr:self.smgr level:2];
		feind2.sprite.position = ccp(-300,-200);
		[feind2.sprite applyImpulse:ccp(-150,20)];
		[self addChild:feind2];
		
		EnemySphere *feind3 = [[EnemySphere alloc] initWithMgr:self.smgr level:1];
		feind3.sprite.position = ccp(100,-200);
		[feind3.sprite applyImpulse:ccp(200,-220)];
		[self addChild:feind3];
		
		EnemySphere *feind4 = [[EnemySphere alloc] initWithMgr:self.smgr level:1];
		feind4.sprite.position = ccp(-400,150);
		[feind4.sprite applyImpulse:ccp(100,-50)];
		[self addChild:feind4];
		
		//Registriere den Collision handler:
		[smgr addCollisionCallbackBetweenType:kBallCollisionType
									otherType:kCircleCollisionType
									   target:self 
									 selector:@selector(handleCollision:arbiter:space:)];
		
	}
	return self;
}

-(void) onEnter
{
	[super onEnter];
	
	[[UIAccelerometer sharedAccelerometer] setUpdateInterval:(1.0 / 60)];
}

//COLLISION HANDLING
- (void) handleCollision:(CollisionMoment)moment arbiter:(cpArbiter*)arb space:(cpSpace*)space
{
	CP_ARBITER_GET_SHAPES(arb,a,b);
	switch(moment)
    {
        case COLLISION_BEGIN:
			//Auslagern?
			NSLog(@"Collision detected!");
			cpCCSprite *sprite = (cpCCSprite*)b->data;
			NSLog(@"Mass:%f",sprite.shape->body->m);
			if (sprite.shape->body->m > sphere.level+0.1) {
				//Hier später Gefressenwerd-Animation einbauen, vorerst wird nur Spiel gestoppt
				[smgr stop];
				[[CCDirector sharedDirector] replaceScene:
				 [CCFadeTransition transitionWithDuration:0.5f scene:[HelloWorld scene]]];
			} else {
				if (sprite)
				{	
					[sprite.parent removeChild:sprite cleanup:YES];
					[smgr scheduleToRemoveAndFreeShape:b];
					b->data = nil;
				}
				if (sphere) {
					prevSize = sphere.level;
					prevPos = sphere.sprite.position;
					prevVelocity = sphere.sprite.shape->body->v;
					NSLog(@"prevV:%f,%f",prevVelocity.x,prevVelocity.y);
					isThereASphere = NO;
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
			//if grösser als etc
			//ZB sprite entfernen
			//[smgr scheduleToRemoveAndFreeShape:b];
			//b = nil;
			//neues Sprite spawnen
			break;
        case COLLISION_SEPARATE:
			//shapes separated, do something awesome!
			break;
    }
	
}


//GAME LOGIK
- (void) nextFrame:(ccTime)dt {
	if (!isThereASphere) {
		sphere = [[Sphere alloc] initWithMgr:smgr level:prevSize+1 position:prevPos velocity:prevVelocity];
		[self addChild:sphere];
		isThereASphere = YES;
		CCFiniteTimeAction *zoomAction = [CCScaleTo actionWithDuration:0.1f scale:1.1f];// zoom in
		CCFiniteTimeAction *shrinkAction = [CCScaleTo actionWithDuration:0.1f scale:1];// zoom out
		CCSequence *actions = [CCSequence actions:zoomAction, shrinkAction, nil];// zoom in, then zoom out
		[sphere runAction:actions];// now
		
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
	
	CGPoint v = ccp( -1*accelY, accelX);
	
	if (isThereASphere) {
		[sphere.sprite applyImpulse:ccpMult(v, 15)];
	}
	
}


// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}
@end
