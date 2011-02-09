//
//  Settings.m
//  MaturaApp
//  © Zeno Koller 2010
//
//	Diese Klasse zeigt die Einstellungen des Spiels an.

#import "Settings.h"

@implementation Settings

@synthesize accelX, accelY, accelZ;
@synthesize cross;
@synthesize accHelper;

+(id) scene
{
	CCScene *scene = [CCScene node];
	Settings *layer = [Settings node];
	[scene addChild: layer];
	return scene;
}

//INITIALISIERE INSTANZ
-(id) init
{
	if( (self=[super init] )) {
		//BACKGROUND
		CCSprite *bg = [CCSprite spriteWithFile:@"BG/BG.png"];
		bg.position = ccp(160,240);
		[self addChild:bg];
		//TITLE
		CCSprite *title = [CCSprite spriteWithFile:@"Titles/settings_title.png"];
		title.position = ccp(160,420);
		[self addChild:title];
		
		//CALIBRATION TITLE
		CCLabelBMFont *labelCalibrate = [CCLabelBMFont labelWithString:@"calibration" fntFile:@"volter_small.fnt"];
		labelCalibrate.position = ccp(95,332);
		[self addChild:labelCalibrate];
		//BOX&CROSS
		CCSprite *box = [CCSprite spriteWithFile:@"Buttons/box.png"];
		cross = [CCSprite spriteWithFile:@"Buttons/cross.png"];
		box.position = ccp(78,278);
		cross.position = ccp(78,278);
		[self addChild:box];
		[self addChild:cross];
		//SET BUTTON
		CCSprite *setSprite = [CCSprite spriteWithFile:@"Buttons/set.png"];
		CCSprite *setSprite_s = [CCSprite spriteWithFile:@"Buttons/set.png"];
		[setSprite_s setColor:ccc3(172, 224, 250)];
		CCMenuItemSprite *setSpriteItem = [CCMenuItemSprite itemFromNormalSprite:setSprite selectedSprite:setSprite_s target:self selector:@selector(calibrate:)];
		CCMenu *setMenu = [CCMenu menuWithItems:setSpriteItem,nil];
		setMenu.position = ccp(164, 278);
		[self addChild:setMenu];
		//RESET BUTTON
		CCSprite *resetSprite = [CCSprite spriteWithFile:@"Buttons/reset.png"];
		CCSprite *resetSprite_s = [CCSprite spriteWithFile:@"Buttons/reset.png"];
		[resetSprite_s setColor:ccc3(172, 224, 250)];
		CCMenuItemSprite *resetSpriteItem = [CCMenuItemSprite itemFromNormalSprite:resetSprite selectedSprite:resetSprite_s target:self selector:@selector(resetCalibration:)];
		CCMenu *resetMenu = [CCMenu menuWithItems:resetSpriteItem,nil];
		resetMenu.position = ccp(240, 278);
		[self addChild:resetMenu];
		//OPTIONAL: VIBRATION
		if ([UserData sharedData].isVibrationDevice) {
			//VIBRATION TITLE
			CCLabelBMFont *labelVibration = [CCLabelBMFont labelWithString:@"vibration" fntFile:@"volter_small.fnt"];
			labelVibration.position = ccp(87,191);
			[self addChild:labelVibration];
			//SECOND LINE
			CCSprite *line = [CCSprite spriteWithFile:@"Buttons/smallline.png"];
			line.position = ccp(160,222);
			[self addChild:line];
			
			CCSprite *state1Sprite;
			CCSprite *state1Sprite_s;
			CCMenuItemSprite *state1SpriteItem;
			CCSprite *state2Sprite;
			CCSprite *state2Sprite_s;
			CCMenuItemSprite *state2SpriteItem;
			
			if ([UserData sharedData].isVibrationEnabled) {
				state1Sprite = [CCSprite spriteWithFile:@"Buttons/vibrationon.png"];
				state1Sprite_s = [CCSprite spriteWithFile:@"Buttons/vibrationon.png"];
				[state1Sprite_s setColor:ccc3(172, 224, 250)];
				state2Sprite = [CCSprite spriteWithFile:@"Buttons/vibrationoff.png"];
				state2Sprite_s = [CCSprite spriteWithFile:@"Buttons/vibrationoff.png"];
				[state2Sprite_s setColor:ccc3(172, 224, 250)];
			} else {
				state1Sprite = [CCSprite spriteWithFile:@"Buttons/vibrationoff.png"];
				state1Sprite_s = [CCSprite spriteWithFile:@"Buttons/vibrationoff.png"];
				[state1Sprite_s setColor:ccc3(172, 224, 250)];
				state2Sprite = [CCSprite spriteWithFile:@"Buttons/vibrationon.png"];
				state2Sprite_s = [CCSprite spriteWithFile:@"Buttons/vibrationon.png"];
				[state2Sprite_s setColor:ccc3(172, 224, 250)];
			}
			state1SpriteItem = [CCMenuItemSprite itemFromNormalSprite:state1Sprite selectedSprite:state1Sprite_s target:self selector:nil];
			state2SpriteItem = [CCMenuItemSprite itemFromNormalSprite:state2Sprite selectedSprite:state2Sprite_s target:self selector:nil];
			
			CCMenuItemToggle *menuItemToggle = [CCMenuItemToggle itemWithTarget:self selector:@selector(toggleVibration:) items:state1SpriteItem,state2SpriteItem,nil];
			CCMenu * vibrateMenu = [CCMenu menuWithItems:menuItemToggle,nil];
			vibrateMenu.position = ccp(250,175);
			[self addChild:vibrateMenu];
		}
			
		//BACK MENU
		CCSprite *backSprite = [CCSprite spriteWithFile:@"Buttons/backbutton.png"];
		CCSprite *backSpritePressed = [CCSprite spriteWithFile:@"Buttons/backbutton.png"];
		[backSpritePressed setColor:ccc3(172, 224, 250)];
		CCMenuItemSprite *menuItemBack = [CCMenuItemSprite itemFromNormalSprite:backSprite selectedSprite:backSpritePressed target:self selector:@selector(back:)];
		CCMenu *backMenu = [CCMenu menuWithItems:menuItemBack,nil];
		backMenu.position = ccp(160, 50);
		[self addChild:backMenu];
		
		//ACCELEROMETER FÜR KALIBRATION
		self.isAccelerometerEnabled = YES;
		[[UIAccelerometer sharedAccelerometer] setUpdateInterval:(1.0 / 60)];
		
		//SCHEDULER FÜR BOX
		[self schedule:@selector(nextFrame:) interval:(1.0 / 60)];
		
		//ACCHELPER
		accHelper = [[AccHelper alloc] init];
	}
	return self;
}

//BESCHLEUNIGUNGSSENSOR-LOOP
- (void)accelerometer:(UIAccelerometer*)accelerometer didAccelerate:(UIAcceleration*)acceleration
{		

	accelX = (float) acceleration.x;
	accelY = (float) acceleration.y;
	accelZ = (float) acceleration.z;
	
}

//LOOP, WELCHER DAS X AUF DEM BILDSCHIRM NEU POSITIONIERT
-(void)nextFrame:(ccTime)dt {
	NSArray *accelData = [NSArray arrayWithObjects:[NSNumber numberWithFloat:accelX],[NSNumber numberWithFloat:accelY],[NSNumber numberWithFloat:accelZ],nil];
	float crossAccelX = -1*[accHelper dotVec1:[UserData sharedData].xGrund Vec2:accelData];
	float crossAccelY = [accHelper dotVec1:[UserData sharedData].yGrund Vec2:accelData];
	
	CGPoint v = ccpMult(ccp(crossAccelX,crossAccelY),150);
	
	if (!self.isCrossOutOfBoundsOfBox) {
		cross.position = ccpAdd(cross.position, ccpMult(v, dt));
	} else {
		cross.position = ccpAdd(cross.position, ccpMult(ccpSub(cross.position, ccp(78,278)),-0.02));
	}
}

//SETZE DIE KALIBRATION IM SPIEL
-(void)calibrate:(CCMenuItem *) menuItem {
	//KORREKTIONSWERTE SETZEN
	if (accelZ > 0) { //GERÄT STEHT KOPF
		[UserData sharedData].xGrund = [NSArray arrayWithObjects:[NSNumber numberWithFloat:-1],[NSNumber numberWithFloat:0], [NSNumber numberWithFloat:0], nil];
	} else { //GERÄT IST NORMAL ORIENTIERT
		[UserData sharedData].xGrund = [NSArray arrayWithObjects:[NSNumber numberWithFloat:1],[NSNumber numberWithFloat:0], [NSNumber numberWithFloat:0], nil];
	}
	NSArray *zGrund = [NSArray arrayWithObjects:[NSNumber numberWithFloat:accelX],[NSNumber numberWithFloat:accelY], [NSNumber numberWithFloat:accelZ], nil];
	[UserData sharedData].yGrund = [accHelper crossVec1:[UserData sharedData].xGrund Vec2:zGrund];
	[UserData sharedData].xGrund = [accHelper crossVec1:[UserData sharedData].yGrund Vec2:zGrund];
	
	cross.position = ccp(78,278);
	//SYNCHRONISIEREN
	[[UserData sharedData] saveAllDataToUserDefaults];
	
}

//SETZE DIE AKTUELLE KALIBRATION ZURÜCK AUF DEFAULT
-(void)resetCalibration:(CCMenuItem *) menuItem {
	//KORREKTIONSWERTE RESETTEN
	[UserData sharedData].xGrund = [NSArray arrayWithObjects:[NSNumber numberWithFloat:-1], [NSNumber numberWithFloat:0], [NSNumber numberWithFloat:0], nil];
	[UserData sharedData].yGrund = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0], [NSNumber numberWithFloat:1], [NSNumber numberWithFloat:0], nil];
	cross.position = ccp(78,278);
	//SYNCHRONISIEREN
	[[UserData sharedData] saveAllDataToUserDefaults];
}

//VIBRATION AN UND AUSSCHALTEN
-(void)toggleVibration:(CCMenuItem *)menuItem {
	if ([UserData sharedData].isVibrationEnabled) {
		[UserData sharedData].isVibrationEnabled = NO;
	} else {
		[UserData sharedData].isVibrationEnabled = YES;
	}
	[[UserData sharedData] saveAllDataToUserDefaults];
}

//ZURÜCK
-(void)back:(CCMenuItem *)menuItem {
	[[CCDirector sharedDirector] replaceScene:
	 [CCTransitionCrossFade transitionWithDuration:0.2f scene:[HelloWorld scene]]];
	
}

//IST DAS X AUSSERHALB DER BOX?
-(BOOL)isCrossOutOfBoundsOfBox {
	CGRect box = CGRectMake(46 ,246 , 65, 65); 
	if (CGRectContainsPoint(box, cross.position)) return NO;
	return YES;
}

//LÖSCHE DIESE INSTANZ
- (void) dealloc
{
	NSLog(@"Settings dealloc");
	[accHelper release];
	[super dealloc];
}
@end