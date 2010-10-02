//
//  HelloWorldScene.m
//  MaturaApp
//  © Zeno Koller 2010

#import "HelloWorldScene.h"
#import "GameScene.h"

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
	if( (self=[super initWithColor:ccc4(220,220,220,255)] )) {
		
		CCLabelTTF* label = [CCLabelTTF labelWithString:@"Level 1" fontName:@"Helvetica" fontSize:50];
		label.color = ccc3(30,30,30);
		CCMenuItemLabel *menuItem1= [CCMenuItemLabel itemWithLabel:label target:self selector:@selector(runGame1:)];
		
		CCLabelTTF* label2 = [CCLabelTTF labelWithString:@"Level 2" fontName:@"Helvetica" fontSize:50];
		label2.color = ccc3(30,30,30);
		CCMenuItemLabel *menuItem2= [CCMenuItemLabel itemWithLabel:label2 target:self selector:@selector(runGame2:)];
		
		CCMenu * myMenu = [CCMenu menuWithItems:menuItem1,menuItem2,nil];
		[myMenu alignItemsVertically];
		[self addChild:myMenu];
	}
	return self;
}

-(void) runGame1:(CCMenuItem  *) menuItem  {
	//LEVELDATEN INITIALISIEREN
	[[GameData sharedData] initLevel:1];
	
	[[CCDirector sharedDirector] replaceScene:
	 [CCTransitionRadialCW transitionWithDuration:0.5f scene:[GameScene scene]]];
}

-(void) runGame2:(CCMenuItem  *) menuItem  {
	//LEVELDATEN INITIALISIEREN
	[[GameData sharedData] initLevel:2];

	
	[[CCDirector sharedDirector] replaceScene:
	 [CCTransitionRadialCW transitionWithDuration:0.5f scene:[GameScene scene]]];
}

- (void) dealloc
{
	NSLog(@"Menu dealloc");
	[super dealloc];
}
@end
