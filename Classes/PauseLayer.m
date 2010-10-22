//
//  PauseLayer.m
//  MaturaApp
//  © Zeno Koller 2010


#import "PauseLayer.h"
#import "GameData.h"
#import "HelloWorldScene.h"

@implementation PauseLayer

+(id) scene
{
	CCScene *scene = [CCScene node];
	PauseLayer *layer = [PauseLayer node];
	[scene addChild: layer];
	return scene;
}

//INITIALISIERE INSTANZ
-(id) init
{
	if( (self=[super initWithColor:ccc4(0, 0, 0, 120)] )) {
		CCSprite *pausedTitle = [CCSprite spriteWithFile:@"gamePaused.png"];
		pausedTitle.position = ccp(160, 260);
		[self addChild:pausedTitle];
		
		
		CCLabelBMFont* label1 = [CCLabelBMFont labelWithString:@"resume" fntFile:@"bebas.fnt"];
		CCMenuItemLabel *menuItem1= [CCMenuItemLabel itemWithLabel:label1 target:self selector:@selector(resume:)];
		
		CCLabelBMFont* label2 = [CCLabelBMFont labelWithString:@"back to menu" fntFile:@"bebas.fnt"];
		CCMenuItemLabel *menuItem2= [CCMenuItemLabel itemWithLabel:label2 target:self selector:@selector(backToMenu:)];
		
		CCMenu * myMenu = [CCMenu menuWithItems:menuItem1,menuItem2,nil];
		myMenu.position = ccp(160, 150);
		[myMenu alignItemsVertically];
		[self addChild:myMenu];
		
	}
	return self;
}


-(void)resume:(CCMenuItem *) menuItem {
	self.visible = NO;	
	[[CCDirector sharedDirector] resume];
	[GameData sharedData].isGamePaused = NO;
}
-(void)backToMenu:(CCMenuItem *) menuItem {
	[[CCDirector sharedDirector] replaceScene:
	 [CCTransitionFade transitionWithDuration:0.3f scene:[HelloWorld scene]]];
}

- (void) dealloc
{
	NSLog(@"Deallocating Countdown");
	[super dealloc];
}

@end