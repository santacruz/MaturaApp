//
//  LevelChoice.m
//  MaturaApp
//  © Zeno Koller 2010

#import "LevelChoice.h"
#import "GameScene.h"
#import "HelloWorldScene.h"

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
		CCSprite *bg = [CCSprite spriteWithFile:@"BG/bg.png"];
		bg.position = ccp(160,240);
		[self addChild:bg];
		//TITLE
		CCSprite *title = [CCSprite spriteWithFile:@"Titles/level_title.png"];
		title.position = ccp(160,420);
		[self addChild:title];
		
		//LEVEL MENU
		CCLabelBMFont* label = [CCLabelBMFont labelWithString:@"LEVEL 1" fntFile:@"bebas.fnt"];
		CCMenuItemLabel *menuItem1= [CCMenuItemLabel itemWithLabel:label target:self selector:@selector(runGame1:)];
		
		CCLabelBMFont* label2 = [CCLabelBMFont labelWithString:@"LEVEL 2" fntFile:@"bebas.fnt"];
		CCMenuItemLabel *menuItem2= [CCMenuItemLabel itemWithLabel:label2 target:self selector:@selector(runGame2:)];
		
		CCMenu * myMenu = [CCMenu menuWithItems:menuItem1,menuItem2,nil];
		[myMenu alignItemsVertically];
		myMenu.position = ccp(160, 220);
		[self addChild:myMenu];
		
		//BACK MENU
		CCSprite *backSprite = [CCSprite spriteWithFile:@"Buttons/backbutton.png"];
		CCSprite *backSpritePressed = [CCSprite spriteWithFile:@"Buttons/backbutton-pressed.png"];
		CCMenuItemSprite *menuItemBack = [CCMenuItemSprite itemFromNormalSprite:backSprite selectedSprite:backSpritePressed target:self selector:@selector(back:)];
		CCMenu *backMenu = [CCMenu menuWithItems:menuItemBack,nil];
		backMenu.position = ccp(160, 50);
		[self addChild:backMenu];
	}
	return self;
}

-(void) runGame1:(CCMenuItem  *) menuItem  {
	//LEVELDATEN INITIALISIEREN
	[[GameData sharedData] initLevel:1];
	
	[[CCDirector sharedDirector] replaceScene:
	 [CCTransitionFade transitionWithDuration:0.3f scene:[GameScene scene]]];
}

-(void) runGame2:(CCMenuItem  *) menuItem  {
	//LEVELDATEN INITIALISIEREN
	[[GameData sharedData] initLevel:2];
	
	
	[[CCDirector sharedDirector] replaceScene:
	 [CCTransitionFade transitionWithDuration:0.3f scene:[GameScene scene]]];
}

-(void)back:(CCMenuItem *)menuItem {
	[[CCDirector sharedDirector] replaceScene:
	 [CCTransitionSlideInL transitionWithDuration:0.4f scene:[HelloWorld scene]]];

}

- (void) dealloc
{
	NSLog(@"LevelChoice dealloc");
	[super dealloc];
}
@end
