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
		CCLabelBMFont* label1 = [CCLabelBMFont labelWithString:@"Calibrate" fntFile:@"diavlo.fnt"];
		CCMenuItemLabel *menuItem1= [CCMenuItemLabel itemWithLabel:label1 target:self selector:@selector(calibrate:)];
		
		CCLabelBMFont* label2 = [CCLabelBMFont labelWithString:@"Reset Calibration" fntFile:@"diavlo.fnt"];
		CCMenuItemLabel *menuItem2= [CCMenuItemLabel itemWithLabel:label2 target:self selector:@selector(resetCalibration:)];
		
		CCMenu * myMenu = [CCMenu menuWithItems:menuItem1,menuItem2,nil];
		myMenu.position = ccp(160, 220);
		[myMenu alignItemsVertically];
		[self addChild:myMenu];
		
		//BACK MENU
		CCSprite *backSprite = [CCSprite spriteWithFile:@"Buttons/backbutton.png"];
		CCSprite *backSpritePressed = [CCSprite spriteWithFile:@"Buttons/backbutton-pressed.png"];
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
	[GameData sharedData].accelCorrectionX = accelX;
	[GameData sharedData].accelCorrectionY = accelY;
	
}

-(void)resetCalibration:(CCMenuItem *) menuItem {
	//KORREKTIONSWERTE RESETTEN
	[GameData sharedData].accelCorrectionX = 0;
	[GameData sharedData].accelCorrectionY = 0;
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
