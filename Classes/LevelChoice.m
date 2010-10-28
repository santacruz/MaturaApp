//
//  LevelChoice.m
//  MaturaApp
//  © Zeno Koller 2010

#import "LevelChoice.h"

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
		
		//LEVEL MENU 1
 		CCLabelBMFont* label1 = [CCLabelBMFont labelWithString:@"1" fntFile:@"bebas.fnt"];
		CCMenuItemLabel *menuItem1= [CCMenuItemLabel itemWithLabel:label1 target:self selector:@selector(runGame1:)];
		
		CCLabelBMFont* label2 = [CCLabelBMFont labelWithString:@"2" fntFile:@"bebas.fnt"];
		CCMenuItemLabel *menuItem2= [CCMenuItemLabel itemWithLabel:label2 target:self selector:@selector(runGame2:)];
		
		CCLabelBMFont* label3 = [CCLabelBMFont labelWithString:@"3" fntFile:@"bebas.fnt"];
		CCMenuItemLabel *menuItem3= [CCMenuItemLabel itemWithLabel:label3 target:self selector:@selector(runGame3:)];
		
		CCMenu * myMenu = [CCMenu menuWithItems:menuItem1,menuItem2,menuItem3,nil];
		[myMenu alignItemsHorizontallyWithPadding:50];
		myMenu.position = ccp(160, 240);
		[self addChild:myMenu];
		
		//LEVEL MENU 2
 		CCLabelBMFont* label4 = [CCLabelBMFont labelWithString:@"4" fntFile:@"bebas.fnt"];
		CCMenuItemLabel *menuItem4= [CCMenuItemLabel itemWithLabel:label4 target:self selector:@selector(runGame4:)];
		
		CCLabelBMFont* label5 = [CCLabelBMFont labelWithString:@"5" fntFile:@"bebas.fnt"];
		CCMenuItemLabel *menuItem5= [CCMenuItemLabel itemWithLabel:label5 target:self selector:@selector(runGame5:)];
		
		CCLabelBMFont* label6 = [CCLabelBMFont labelWithString:@"6" fntFile:@"bebas.fnt"];
		CCMenuItemLabel *menuItem6= [CCMenuItemLabel itemWithLabel:label6 target:self selector:@selector(runGame6:)];
		
		CCMenu * myMenu2 = [CCMenu menuWithItems:menuItem4,menuItem5,menuItem6,nil];
		[myMenu2 alignItemsHorizontallyWithPadding:50];
		myMenu2.position = ccp(160, 180);
		[self addChild:myMenu2];
		
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


-(void)runGame3:(CCMenuItem  *) menuItem {
	//LEVELDATEN INITIALISIEREN
	[[GameData sharedData] initLevel:3];
	
	[[CCDirector sharedDirector] replaceScene:
	 [CCTransitionFade transitionWithDuration:0.3f scene:[GameScene scene]]];
	
}
-(void)runGame4:(CCMenuItem  *) menuItem {
	//LEVELDATEN INITIALISIEREN
	[[GameData sharedData] initLevel:4];
	
	[[CCDirector sharedDirector] replaceScene:
	 [CCTransitionFade transitionWithDuration:0.3f scene:[GameScene scene]]];
	
}
-(void)runGame5:(CCMenuItem  *) menuItem {
	//LEVELDATEN INITIALISIEREN
	[[GameData sharedData] initLevel:5];
	
	[[CCDirector sharedDirector] replaceScene:
	 [CCTransitionFade transitionWithDuration:0.3f scene:[GameScene scene]]];
	
}
-(void)runGame6:(CCMenuItem  *) menuItem {
	//LEVELDATEN INITIALISIEREN
	[[GameData sharedData] initLevel:6];
	
	[[CCDirector sharedDirector] replaceScene:
	 [CCTransitionFade transitionWithDuration:0.3f scene:[GameScene scene]]];
	
}

-(void)back:(CCMenuItem *)menuItem {
	[[CCDirector sharedDirector] replaceScene:
	 [CCTransitionCrossFade transitionWithDuration:0.2f scene:[HelloWorld scene]]];

}



- (void) dealloc
{
	NSLog(@"LevelChoice dealloc");
	[super dealloc];
}
@end
