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
#define	kFollowEnemy 2
#define kFastEnemy 3
#define kUltraEnemy 4

@implementation EnemySphere

static float prevDistance = 1000;

@synthesize radius, sprite, moveVector, speed, emitter;

//NEUE INSTANZ MIT AUTORELEASE
+(id) enemyWithMgr:(SpaceManager *)mgr kind:(int)kind level:(int)size position:(CGPoint)location
{
	return [[[self alloc] initWithMgr:(SpaceManager *)mgr kind:(int)kind level:(int)size position:(CGPoint)location] autorelease];
}

//NEUE INSTANZ
-(id) initWithMgr:(SpaceManager *)mgr kind:(int)kind level:(int)size position:(CGPoint)location
{

	if( (self=[super init])) {
		
		radius = sqrt(size*pow(kInitSize,2));
		speed = [GameData sharedData].enemySpeedMultiplier;

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
				[self schedule:@selector(move1:) interval:1/30];
				break;
			case kShrinkEnemy:
				//FÜGE SHRINK SPRITE HINZU
				sprite = [[cpCCSprite alloc] initWithShape:ball file:[NSString stringWithFormat:@"shrink/Shrink%i.png",size]];
				sprite.position = ccp(location.x,location.y);
				sprite.level = size;
				sprite.enemyKind = kind;
				sprite.isShrinkKind = YES;
				[self schedule:@selector(move1:) interval:1/30];
				break;
			case kFollowEnemy:
				//FÜGE FOLLOW SPRITE HINZU
				sprite = [[cpCCSprite alloc] initWithShape:ball file:[NSString stringWithFormat:@"follow/Follow%i.png",size]];
				sprite.position = ccp(location.x,location.y);
				sprite.level = size;
				sprite.enemyKind = kind;
				sprite.isShrinkKind = NO;
				[self schedule:@selector(move2:) interval:1/30];
				break;
			case kFastEnemy:
				//FÜGE FAST SPRITE HINZU
				sprite = [[cpCCSprite alloc] initWithShape:ball file:[NSString stringWithFormat:@"fast/Fast%i.png",size]];
				sprite.position = ccp(location.x,location.y);
				sprite.level = size;
				sprite.enemyKind = kind;
				sprite.isShrinkKind = NO;
				speed = [GameData sharedData].enemySpeedMultiplier*5;
				[self schedule:@selector(move1:) interval:1/30];
				break;
			case kUltraEnemy:
				//FÜGE FAST SPRITE HINZU
				sprite = [[cpCCSprite alloc] initWithShape:ball file:[NSString stringWithFormat:@"ultra/Ultra%i.png",size]];
				sprite.position = ccp(location.x,location.y);
				sprite.level = size;
				sprite.enemyKind = kind;
				sprite.isShrinkKind = YES;
				speed = [GameData sharedData].enemySpeedMultiplier*5;
				[self schedule:@selector(move3:) interval:1/30];
				break;
			default:
				//FÜGE NORMALES SPRITE HINZU
				sprite = [[cpCCSprite alloc] initWithShape:ball file:[NSString stringWithFormat:@"enemy/Enemy%i.png",size]];
				sprite.position = ccp(location.x,location.y);
				sprite.level = size;
				sprite.enemyKind = kind;
				sprite.isShrinkKind = NO;
				[self schedule:@selector(move1:) interval:1/30];
				break;
		}
				
		[self addChild:sprite];
		self.position = ccp(240,160);

		[[GameData sharedData].enemyArray addObject:self];
	}
	NSLog(@"Adding Enemy");
	return self;
}

//ZOOM-EFFEKT
-(void)zoom {
	float originalScale = self.scale;
	id zoomIn = [CCScaleTo actionWithDuration:0.1f scale:1.2f*originalScale];
	id zoomOut = [CCScaleTo actionWithDuration:0.1f scale:originalScale];
	[sprite runAction:[CCSequence actions:zoomIn,zoomOut, nil]];
}

//BEWEGUNG FÜR NORMALE FEINDE
- (void)move1:(ccTime)dt {
	if ([GameData sharedData].isPlaying) {
		prevDistance = 1000;
		if ([GameData sharedData].enemyCount > 1) {
			//ÜBERPRÜFE ALLE FEINDE AUF DISTANZ UND SPEICHERE DIESE, FALLS ES DIE KÜRZESTE DISTANZ IST
			for(EnemySphere *enemy in [GameData sharedData].enemyArray) {
				if (enemy != self) {
					if (ccpDistance(enemy.sprite.position, self.sprite.position) < prevDistance) {
						prevDistance = ccpDistance(enemy.sprite.position, self.sprite.position);
						moveVector = ccpNormalize(ccpSub(enemy.sprite.position, self.sprite.position));
					}
				}
			}
		} else {
			//FALLS ICH DER LETZTE FEIND BIN, VERFOLGE ICH DEN HELDEN
			if ([GameData sharedData].isThereAHero) {
				moveVector = ccpNormalize(ccpSub([[self.parent sphere] sprite].position, self.sprite.position));
			}
		}
		//RICHTUNG ÄNDERN
		sprite.shape->body->v = ccpMult(moveVector, speed);
		//AUSRICHTUNG DES BILDES ÄNDERN
		sprite.rotation = -1*ccpToAngle(sprite.shape->body->v)*180/M_PI-90;
		emitter.position = sprite.position;
	}

}
//BEWEGUNG FÜR SCHNELLE FEINDE
-(void) move2:(ccTime)dt {
	if ([GameData sharedData].isPlaying && [GameData sharedData].isThereAHero) {
		prevDistance = 1000;
		if (sprite.level > [[self.parent sphere] level]) {
			//VERFOLGE DEN HELDEN, WENN ICH GRÖSSER BIN
			moveVector = ccpNormalize(ccpSub([[self.parent sphere] sprite].position, self.sprite.position));
		} else if ([GameData sharedData].enemyCount > 1) {
			//ÜBERPRÜFE ALLE FEINDE AUF DISTANZ UND SPEICHERE DIESE, FALLS ES DIE KÜRZESTE DISTANZ IST
			for(EnemySphere *enemy in [GameData sharedData].enemyArray) {
				if (enemy != self) {
					if (ccpDistance(enemy.sprite.position, self.sprite.position) < prevDistance) {
						prevDistance = ccpDistance(enemy.sprite.position, self.sprite.position);
						moveVector = ccpNormalize(ccpSub(enemy.sprite.position, self.sprite.position));
					}
				}
			}
		} else {
				//FALLS ICH DER LETZTE FEIND BIN, VERFOLGE ICH DEN HELDEN, AUCH WENN ICH KLEINER ALS ER BIN
				moveVector = ccpNormalize(ccpSub([[self.parent sphere] sprite].position, self.sprite.position));
		}
	}
	//RICHTUNG ÄNDERN
	sprite.shape->body->v = ccpMult(moveVector, speed);
	//AUSRICHTUNG DES FEINDES ÄNDERN
	sprite.rotation = -1*ccpToAngle(sprite.shape->body->v)*180/M_PI-90;
	emitter.position = sprite.position;
}

//BEWEGUNG FÜR ULTRA FEINDE
-(void) move3:(ccTime)dt {
	if ([GameData sharedData].isPlaying && [GameData sharedData].isThereAHero) {
		prevDistance = 1000;
		if (sprite.level >= [[self.parent sphere] level]) {
			//FALLS ICH DEN HELDEN FRESSEN KANN, VERFOLGE ICH IHN
			moveVector = ccpNormalize(ccpSub([[self.parent sphere] sprite].position, self.sprite.position));
		} else if ([GameData sharedData].enemyCount > 1) {
			for(EnemySphere *enemy in [GameData sharedData].enemyArray) {
				if (enemy != self) {
					if (ccpDistance(enemy.sprite.position, self.sprite.position) < prevDistance) {
						prevDistance = ccpDistance(enemy.sprite.position, self.sprite.position);
						moveVector = ccpNormalize(ccpSub(enemy.sprite.position, self.sprite.position));
					}
				}
			}
		} else {
			//FALLS ICH DER LETZTE FEIND BIN, VERFOLGE ICH DEN HELDEN, AUCH WENN ICH KLEINER ALS ER BIN
			moveVector = ccpNormalize(ccpSub([[self.parent sphere] sprite].position, self.sprite.position));
		}
	}
	//RICHTUNG ÄNDERN
	sprite.shape->body->v = ccpMult(moveVector, speed);
	//AUSRICHTUNG DES FEINDES ÄNDERN
	sprite.rotation = -1*ccpToAngle(sprite.shape->body->v)*180/M_PI-90;
	emitter.position = sprite.position;
}

//LÖSCHE DIESE INSTANZ
- (void) dealloc
{
	[sprite release];
	NSLog(@"Deallocating Enemy");
	[super dealloc];
}

@end
