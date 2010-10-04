//
//  HelloWorldScene.m
//  MaturaApp
//  © Zeno Koller 2010

#import "LevelChoice.h"
#import "GameScene.h"

@implementation LevelChoice

+(id) scene
{
	CCScene *scene = [CCScene node];
	LevelChoice *layer = [LevelChoice node];
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
		
		CCLabelBMFont* label = [CCLabelBMFont labelWithString:@"LEVEL 1" fntFile:@"bebas.fnt"];
		CCMenuItemLabel *menuItem1= [CCMenuItemLabel itemWithLabel:label target:self selector:@selector(runGame1:)];
		
		CCLabelBMFont* label2 = [CCLabelBMFont labelWithString:@"LEVEL 2" fntFile:@"bebas.fnt"];
		CCMenuItemLabel *menuItem2= [CCMenuItemLabel itemWithLabel:label2 target:self selector:@selector(runGame2:)];
		
		CCMenu * myMenu = [CCMenu menuWithItems:menuItem1,menuItem2,nil];
		[myMenu alignItemsVertically];
		myMenu.position = ccp(160, 200);
		[self addChild:myMenu];
	}
	return self;
}

-(void) runGame1:(CCMenuItem  *) menuItem  {
	//LEVELDATEN INITIALISIEREN
	[[GameData sharedData] initLevel:1];
	
	[[CCDirector sharedDirector] replaceScene:
	 [CCTransitionFade transitionWithDuration:0.5f scene:[GameScene scene]]];
}

-(void) runGame2:(CCMenuItem  *) menuItem  {
	//LEVELDATEN INITIALISIEREN
	[[GameData sharedData] initLevel:2];
	
	
	[[CCDirector sharedDirector] replaceScene:
	 [CCTransitionFade transitionWithDuration:0.5f scene:[GameScene scene]]];
}

- (void) dealloc
{
	NSLog(@"LevelChoice dealloc");
	[super dealloc];
}
@end
