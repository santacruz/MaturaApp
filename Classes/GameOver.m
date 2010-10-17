//
//  GameOver.m
//  MaturaApp
//  © Zeno Koller 2010


#import "GameOver.h"
#import "GameData.h"
#import "HelloWorldScene.h"
#import "GameScene.h"

@implementation GameOver

+(id)scene {
	CCScene *scene = [CCScene node];
	GameOver *layer = [GameOver	node];
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
		
		if ([GameData sharedData].wasGameWon) {
			CCLabelBMFont* title = [CCLabelBMFont labelWithString:@"YOU WON!" fntFile:@"bebas.fnt"];
			title.position = ccp(160,300);
			[self addChild:title];
			
			//MENU
			
			CCLabelBMFont* label0 = [CCLabelBMFont labelWithString:@"NEXT" fntFile:@"bebas.fnt"];
			CCMenuItemLabel *menuItem0= [CCMenuItemLabel itemWithLabel:label0 target:self selector:@selector(next:)];

			
			CCLabelBMFont* label1 = [CCLabelBMFont labelWithString:@"RETRY" fntFile:@"bebas.fnt"];
			CCMenuItemLabel *menuItem1= [CCMenuItemLabel itemWithLabel:label1 target:self selector:@selector(retry:)];
			
			CCLabelBMFont* label2 = [CCLabelBMFont labelWithString:@"BACK TO MAIN MENU" fntFile:@"bebas.fnt"];
			CCMenuItemLabel *menuItem2= [CCMenuItemLabel itemWithLabel:label2 target:self selector:@selector(menu:)];
			
			CCMenu * myMenu = [CCMenu menuWithItems:menuItem0,menuItem1,menuItem2,nil];
			[myMenu alignItemsVertically];
			myMenu.position = ccp(160, 220);
			[self addChild:myMenu];
			
			
		} else {
			CCLabelBMFont* title = [CCLabelBMFont labelWithString:@"YOU LOST!" fntFile:@"bebas.fnt"];
			title.position = ccp(160,300);
			[self addChild:title];
			
			//MENU
			CCLabelBMFont* label = [CCLabelBMFont labelWithString:@"RETRY" fntFile:@"bebas.fnt"];
			CCMenuItemLabel *menuItem1= [CCMenuItemLabel itemWithLabel:label target:self selector:@selector(retry:)];
			
			CCLabelBMFont* label2 = [CCLabelBMFont labelWithString:@"BACK TO MAIN MENU" fntFile:@"bebas.fnt"];
			CCMenuItemLabel *menuItem2= [CCMenuItemLabel itemWithLabel:label2 target:self selector:@selector(menu:)];
			
			CCMenu * myMenu = [CCMenu menuWithItems:menuItem1,menuItem2,nil];
			[myMenu alignItemsVertically];
			myMenu.position = ccp(160, 220);
			[self addChild:myMenu];
		}

		

		
	}
	return self;
}

-(void)next:(CCMenuItem *) menuItem {
	//LEVELDATEN INITIALISIEREN
	[[GameData sharedData] initLevel:[GameData sharedData].currentLevel+1];
	
	[[CCDirector sharedDirector] replaceScene:
	 [CCTransitionFade transitionWithDuration:0.3f scene:[GameScene scene]]];
	
}


-(void)retry:(CCMenuItem *) menuItem {
	//LEVELDATEN INITIALISIEREN
	[[GameData sharedData] initLevel:[GameData sharedData].currentLevel];
	
	[[CCDirector sharedDirector] replaceScene:
	 [CCTransitionFade transitionWithDuration:0.3f scene:[GameScene scene]]];

}

-(void)menu:(CCMenuItem *) menuItem {
	
	[[CCDirector sharedDirector] replaceScene:
	 [CCTransitionFade transitionWithDuration:0.3f scene:[HelloWorld scene]]];
	
}

- (void) dealloc
{
	NSLog(@"Deallocating GameOver");
	[super dealloc];
}

@end