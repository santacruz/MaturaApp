//
//  HelloWorldScene.m
//  MaturaApp
//  © Zeno Koller 2010

#import "HelloWorldScene.h"

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
		CCSprite *bg = [CCSprite spriteWithFile:@"BG/bg.png"];
		bg.position = ccp(160,240);
		[self addChild:bg];
		//TITLE
		CCSprite *title = [CCSprite spriteWithFile:@"Titles/omnivore_title.png"];
		title.position = ccp(160,420);
		[self addChild:title];
		
		CCLabelBMFont* label1 = [CCLabelBMFont labelWithString:@"play" fntFile:@"diavlo.fnt"];
		CCMenuItemLabel *menuItem1= [CCMenuItemLabel itemWithLabel:label1 target:self selector:@selector(start:)];
		
		/*CCLabelBMFont* label2 = [CCLabelBMFont labelWithString:@"SCORES" fntFile:@"diavlo.fnt"];
		CCMenuItemLabel *menuItem2= [CCMenuItemLabel itemWithLabel:label2 target:self selector:@selector(scores:)];*/
		
		CCLabelBMFont* label3 = [CCLabelBMFont labelWithString:@"settings" fntFile:@"diavlo.fnt"];
		CCMenuItemLabel *menuItem3= [CCMenuItemLabel itemWithLabel:label3 target:self selector:@selector(settings:)];
		
		CCLabelBMFont* label4 = [CCLabelBMFont labelWithString:@"about" fntFile:@"diavlo.fnt"];
		CCMenuItemLabel *menuItem4= [CCMenuItemLabel itemWithLabel:label4 target:self selector:@selector(about:)];
		
		CCLabelBMFont* label5 = [CCLabelBMFont labelWithString:@"help" fntFile:@"diavlo.fnt"];
		CCMenuItemLabel *menuItem5= [CCMenuItemLabel itemWithLabel:label5 target:self selector:@selector(help:)];
		
		CCMenu * myMenu = [CCMenu menuWithItems:menuItem1,menuItem3,menuItem4,menuItem5,nil];
		[myMenu alignItemsVerticallyWithPadding:20];
		myMenu.position = ccp(160, 200);
		[self addChild:myMenu];
	}
	return self;
}

-(void)start:(CCMenuItem  *) menuItem {
	//Hier World Auswahl starten mit aktueller Welt aus UserData
	[[CCDirector sharedDirector] replaceScene:
	 [CCTransitionCrossFade transitionWithDuration:0.2f scene:[WorldChoice sceneWithWorld:0]]];
}
-(void)scores:(CCMenuItem  *) menuItem {
	[[CCDirector sharedDirector] replaceScene:
	 [CCTransitionCrossFade transitionWithDuration:0.2f scene:[Scores scene]]];
}
-(void)settings:(CCMenuItem  *) menuItem {
	[[CCDirector sharedDirector] replaceScene:
	 [CCTransitionCrossFade transitionWithDuration:0.2f scene:[Settings scene]]];
}
-(void)about:(CCMenuItem  *) menuItem {
	[[CCDirector sharedDirector] replaceScene:
	 [CCTransitionCrossFade transitionWithDuration:0.2f scene:[About scene]]];
}
-(void)help:(CCMenuItem  *) menuItem {
	[[CCDirector sharedDirector] replaceScene:
	 [CCTransitionCrossFade transitionWithDuration:0.2f scene:[Help scene]]];
}

- (void) dealloc
{
	NSLog(@"Menu dealloc");
	[super dealloc];
}
@end
