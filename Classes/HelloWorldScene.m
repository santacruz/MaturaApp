//
//  HelloWorldScene.m
//  MaturaApp
//  © Zeno Koller 2010

#import "HelloWorldScene.h"
#import "LevelChoice.h"

@implementation HelloWorld

+(id) scene
{
	CCScene *scene = [CCScene node];
	HelloWorld *layer = [HelloWorld node];
	[scene addChild: layer];
	return scene;
}

//INITIALISIERE INSTANZ
-(id) init
{
	if( (self=[super init] )) {
		//BACKGROUND
		CCSprite *bg = [CCSprite spriteWithFile:@"bg.png"];
		bg.position = ccp(160,240);
		[self addChild:bg];
		//TITLE
		CCSprite *title = [CCSprite spriteWithFile:@"omnivore_title.png"];
		title.position = ccp(160,420);
		[self addChild:title];
		
		CCLabelBMFont* label1 = [CCLabelBMFont labelWithString:@"START" fntFile:@"bebas.fnt"];
		CCMenuItemLabel *menuItem1= [CCMenuItemLabel itemWithLabel:label1 target:self selector:@selector(start:)];
		
		CCLabelBMFont* label2 = [CCLabelBMFont labelWithString:@"SCORES" fntFile:@"bebas.fnt"];
		CCMenuItemLabel *menuItem2= [CCMenuItemLabel itemWithLabel:label2 target:self selector:@selector(scores:)];
		
		CCLabelBMFont* label3 = [CCLabelBMFont labelWithString:@"SETTINGS" fntFile:@"bebas.fnt"];
		CCMenuItemLabel *menuItem3= [CCMenuItemLabel itemWithLabel:label3 target:self selector:@selector(settings:)];
		
		CCLabelBMFont* label4 = [CCLabelBMFont labelWithString:@"ABOUT" fntFile:@"bebas.fnt"];
		CCMenuItemLabel *menuItem4= [CCMenuItemLabel itemWithLabel:label4 target:self selector:@selector(about:)];
		
		CCLabelBMFont* label5 = [CCLabelBMFont labelWithString:@"HELP" fntFile:@"bebas.fnt"];
		CCMenuItemLabel *menuItem5= [CCMenuItemLabel itemWithLabel:label5 target:self selector:@selector(help:)];
		
		CCMenu * myMenu = [CCMenu menuWithItems:menuItem1,menuItem2,menuItem3,menuItem4,menuItem5,nil];
		[myMenu alignItemsVertically];
		myMenu.position = ccp(160, 200);
		[self addChild:myMenu];
	}
	return self;
}

-(void)start:(CCMenuItem  *) menuItem {
	[[CCDirector sharedDirector] replaceScene:
	 [CCTransitionFlipX transitionWithDuration:0.3f scene:[LevelChoice scene]]];
}
-(void)scores:(CCMenuItem  *) menuItem {}
-(void)settings:(CCMenuItem  *) menuItem {}
-(void)about:(CCMenuItem  *) menuItem {}
-(void)help:(CCMenuItem  *) menuItem {}

- (void) dealloc
{
	NSLog(@"Menu dealloc");
	[super dealloc];
}
@end
