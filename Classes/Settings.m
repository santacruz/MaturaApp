//
//  Settings.m
//  MaturaApp
//  © Zeno Koller 2010

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
		CCMenuItemSprite *setSpriteItem = [CCMenuItemSprite itemFromNormalSprite:setSprite selectedSprite:setSprite target:self selector:@selector(calibrate:)];
		CCMenu *setMenu = [CCMenu menuWithItems:setSpriteItem,nil];
		setMenu.position = ccp(164, 278);
		[self addChild:setMenu];
		//RESET BUTTON
		CCSprite *resetSprite = [CCSprite spriteWithFile:@"Buttons/reset.png"];
		CCMenuItemSprite *resetSpriteItem = [CCMenuItemSprite itemFromNormalSprite:resetSprite selectedSprite:resetSprite target:self selector:@selector(resetCalibration:)];
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
			CCMenuItemSprite *state1SpriteItem;
			CCSprite *state2Sprite;
			CCMenuItemSprite *state2SpriteItem;
			
			if ([UserData sharedData].isVibrationEnabled) {
				state1Sprite = [CCSprite spriteWithFile:@"Buttons/vibrationon.png"];
				state2Sprite = [CCSprite spriteWithFile:@"Buttons/vibrationoff.png"];
			} else {
				state1Sprite = [CCSprite spriteWithFile:@"Buttons/vibrationoff.png"];
				state2Sprite = [CCSprite spriteWithFile:@"Buttons/vibrationon.png"];
			}
			state1SpriteItem = [CCMenuItemSprite itemFromNormalSprite:state1Sprite selectedSprite:state1Sprite target:self selector:nil];
			state2SpriteItem = [CCMenuItemSprite itemFromNormalSprite:state2Sprite selectedSprite:state2Sprite target:self selector:nil];
			
			CCMenuItemToggle *menuItemToggle = [CCMenuItemToggle itemWithTarget:self selector:@selector(toggleVibration:) items:state1SpriteItem,state2SpriteItem,nil];
			CCMenu * vibrateMenu = [CCMenu menuWithItems:menuItemToggle,nil];
			vibrateMenu.position = ccp(250,175);
			[self addChild:vibrateMenu];
		}
			
		//BACK MENU
		CCSprite *backSprite = [CCSprite spriteWithFile:@"Buttons/backbutton.png"];
		CCSprite *backSpritePressed = [CCSprite spriteWithFile:@"Buttons/backbutton.png"];
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


- (void)accelerometer:(UIAccelerometer*)accelerometer didAccelerate:(UIAcceleration*)acceleration
{		

	accelX = (float) acceleration.x;
	accelY = (float) acceleration.y;
	accelZ = (float) acceleration.z;
	
}

-(void)nextFrame:(ccTime)dt {
	NSArray *accelData = [NSArray arrayWithObjects:[NSNumber numberWithFloat:accelX],[NSNumber numberWithFloat:accelY],[NSNumber numberWithFloat:accelZ],nil];
	float crossAccelX = -1*[accHelper dotVec1:[UserData sharedData].xNorm Vec2:accelData];
	float crossAccelY = [accHelper dotVec1:[UserData sharedData].yNorm Vec2:accelData];
	
	CGPoint v = ccpMult(ccp(crossAccelX,crossAccelY),150);
	
	if (!self.isCrossOutOfBoundsOfBox) {
		cross.position = ccpAdd(cross.position, ccpMult(v, dt));
	} else {
		cross.position = ccpAdd(cross.position, ccpMult(ccpSub(cross.position, ccp(78,278)),-0.02));
	}
}

-(void)calibrate:(CCMenuItem *) menuItem {
	//KORREKTIONSWERTE SETZEN
	if (accelZ > 0) { //GERÄT STEHT KOPF
		[UserData sharedData].xNorm = [NSArray arrayWithObjects:[NSNumber numberWithFloat:-1],[NSNumber numberWithFloat:0], [NSNumber numberWithFloat:0], nil];
	} else { //GERÄT IST NORMAL ORIENTIERT
		[UserData sharedData].xNorm = [NSArray arrayWithObjects:[NSNumber numberWithFloat:1],[NSNumber numberWithFloat:0], [NSNumber numberWithFloat:0], nil];
	}
	NSArray *zNorm = [NSArray arrayWithObjects:[NSNumber numberWithFloat:accelX],[NSNumber numberWithFloat:accelY], [NSNumber numberWithFloat:accelZ], nil];
	[UserData sharedData].yNorm = [accHelper crossVec1:[UserData sharedData].xNorm Vec2:zNorm];
	[UserData sharedData].xNorm = [accHelper crossVec1:[UserData sharedData].yNorm Vec2:zNorm];
	
	cross.position = ccp(78,278);
	//SYNCHRONISIEREN
	[[UserData sharedData] saveAllDataToUserDefaults];
	
}

-(void)resetCalibration:(CCMenuItem *) menuItem {
	//KORREKTIONSWERTE RESETTEN
	[UserData sharedData].xNorm = [NSArray arrayWithObjects:[NSNumber numberWithFloat:-1], [NSNumber numberWithFloat:0], [NSNumber numberWithFloat:0], nil];
	[UserData sharedData].yNorm = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0], [NSNumber numberWithFloat:1], [NSNumber numberWithFloat:0], nil];
	cross.position = ccp(78,278);
	//SYNCHRONISIEREN
	[[UserData sharedData] saveAllDataToUserDefaults];
}

-(void)toggleVibration:(CCMenuItem *)menuItem {
	if ([UserData sharedData].isVibrationEnabled) {
		[UserData sharedData].isVibrationEnabled = NO;
	} else {
		[UserData sharedData].isVibrationEnabled = YES;
	}
	[[UserData sharedData] saveAllDataToUserDefaults];
}

-(void)back:(CCMenuItem *)menuItem {
	[[CCDirector sharedDirector] replaceScene:
	 [CCTransitionCrossFade transitionWithDuration:0.2f scene:[HelloWorld scene]]];
	
}

-(BOOL)isCrossOutOfBoundsOfBox {
	CGRect box = CGRectMake(46 ,246 , 65, 65); 
	if (CGRectContainsPoint(box, cross.position)) return NO;
	return YES;
}

- (void) dealloc
{
	NSLog(@"Settings dealloc");
	[accHelper release];
	[super dealloc];
}
@end