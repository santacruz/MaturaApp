//
//  Settings.m
//  MaturaApp
//  © Zeno Koller 2010

#import "Settings.h"

@implementation Settings

@synthesize accelX, accelY;

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
		CCSprite *bg = [CCSprite spriteWithFile:@"BG/bg.png"];
		bg.position = ccp(160,240);
		[self addChild:bg];
		//TITLE
		CCSprite *title = [CCSprite spriteWithFile:@"Titles/settings_title.png"];
		title.position = ccp(160,420);
		[self addChild:title];
		
		//SETTINGS MENU
		CCLabelBMFont* labelCalibrate = [CCLabelBMFont labelWithString:@"Calibrate" fntFile:@"volter_small.fnt"];
		CCMenuItemLabel *menuItemCalibrate= [CCMenuItemLabel itemWithLabel:labelCalibrate target:self selector:@selector(calibrate:)];
		
		CCLabelBMFont* labelResetCalibration = [CCLabelBMFont labelWithString:@"Reset Calibration" fntFile:@"volter_small.fnt"];
		CCMenuItemLabel *menuItemResetCalibration = [CCMenuItemLabel itemWithLabel:labelResetCalibration target:self selector:@selector(resetCalibration:)];
		
		if ([UserData sharedData].isVibrationDevice) {
			CCLabelBMFont *labelToggle1 = [CCLabelBMFont labelWithString:@"Disable Vibration" fntFile:@"volter_small.fnt"];
			CCMenuItemLabel *menuItemToggle1 = [CCMenuItemLabel itemWithLabel:labelToggle1 target:nil selector:nil];
			CCLabelBMFont *labelToggle2 = [CCLabelBMFont labelWithString:@"Enable Vibration" fntFile:@"volter_small.fnt"];
			CCMenuItemLabel *menuItemToggle2 = [CCMenuItemLabel itemWithLabel:labelToggle2 target:nil selector:nil];
			CCMenuItemToggle *menuItemToggle = [CCMenuItemToggle itemWithTarget:self selector:@selector(toggleVibration:) items:menuItemToggle1,menuItemToggle2,nil];
						
			CCMenu * myMenu = [CCMenu menuWithItems:menuItemCalibrate,menuItemResetCalibration,menuItemToggle,nil];
			myMenu.position = ccp(160, 220);
			[myMenu alignItemsVertically];
			[self addChild:myMenu];
		} else {
			CCMenu * myMenu = [CCMenu menuWithItems:menuItemCalibrate,menuItemResetCalibration,nil];
			myMenu.position = ccp(160, 220);
			[myMenu alignItemsVertically];
			[self addChild:myMenu];
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

	}
	return self;
}


- (void)accelerometer:(UIAccelerometer*)accelerometer didAccelerate:(UIAcceleration*)acceleration
{		
	accelX = (float) acceleration.x;
	accelY = (float) acceleration.y;	
}

-(void)calibrate:(CCMenuItem *) menuItem {
	//KORREKTIONSWERTE SETZEN
	[UserData sharedData].accelCorrectionX = accelX;
	[UserData sharedData].accelCorrectionY = accelY;
	//******************
	//HIER NOCH SYNCHRONISIEREN!!!!!
	
}

-(void)resetCalibration:(CCMenuItem *) menuItem {
	//KORREKTIONSWERTE RESETTEN
	[UserData sharedData].accelCorrectionX = 0;
	[UserData sharedData].accelCorrectionY = 0;
	//******************
	//HIER NOCH SYNCHRONISIEREN!!!!!
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

- (void) dealloc
{
	NSLog(@"Settings dealloc");
	[super dealloc];
}
@end
