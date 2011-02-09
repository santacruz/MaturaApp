//
//  GameOver.m
//  MaturaApp
//  © Zeno Koller 2010
//
//	Diese Klasse zeigt den Game-Over Screen an.

#import "GameOver.h"

@implementation GameOver
@synthesize hasFinishedGame;

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
		CCSprite *bg = [CCSprite spriteWithFile:@"BG/BG.png"];
		bg.position = ccp(160,240);
		[self addChild:bg];
		
		//HAS FINISHED GAME?
		hasFinishedGame = NO;
		
		if ([GameData sharedData].wasGameWon) {			
			//HÖCHSTES LEVEL?
			if ([UserData sharedData].highestLevel == [UserData sharedData].currentLevel) {
				//HÖCHSTE WELT?
				if ([UserData sharedData].highestWorld == [UserData sharedData].currentWorld) {
					if ([UserData sharedData].currentLevel == 9) { //WELT FERTIG, GIB NEUE WELT FREI
						[UserData sharedData].highestWorld += 1;
						[UserData sharedData].currentWorld += 1;
						[UserData sharedData].highestLevel = 1;
						[UserData sharedData].currentLevel = 1;
					} else {//LEVEL INNERHALB VON HÖCHSTER WELT ERHÖHEN
						[UserData sharedData].currentLevel += 1;
						[UserData sharedData].highestLevel += 1;
					}
				} else {//NICHT HÖCHSTE WELT, DAS HEISST HIGHESTLEVEL WIRD IGNORIERT
					if ([UserData sharedData].currentLevel == 9) { //WELT FERTIG, MIT NÄCHSTER WELT WEITERFAHREN
						[UserData sharedData].currentWorld += 1;
						[UserData sharedData].currentLevel = 1;
					} else { //LEVEL INNERHALB DER WELT ERHÖHEN
						[UserData sharedData].currentLevel += 1;
					}
				}
			} else { //NICHT HÖCHSTES LEVEL
				if ([UserData sharedData].currentLevel == 9) { //WELT FERTIG, MIT NÄCHSTER WELT WEITERFAHREN
					[UserData sharedData].currentWorld += 1;
					[UserData sharedData].currentLevel = 1;
				} else { //LEVEL INNERHALB DER WELT ERHÖHEN
					[UserData sharedData].currentLevel += 1;
				}
			}
			//FALLS LETZTES LEVEL FERTIG GEHABT:
			if ([UserData sharedData].highestWorld == 5) {
				[UserData sharedData].currentWorld = 4;
				[UserData sharedData].highestWorld = 4;
				[UserData sharedData].highestLevel = 9;
				[UserData sharedData].currentLevel = 9;
				hasFinishedGame = YES;
			}

			[[UserData sharedData] saveAllDataToUserDefaults];
		
			//TITLE
			CCSprite *title = [CCSprite spriteWithFile:@"Titles/youwon_title.png"];
			title.position = ccp(160,420);
			[self addChild:title z:200];
			
			//MENU
			CCLabelBMFont* label0 = [CCLabelBMFont labelWithString:@"next" fntFile:@"volter.fnt"];
			MenuFont *menuItem0= [MenuFont itemWithLabel:label0 target:self selector:@selector(next:)];
				
			CCLabelBMFont* label1 = [CCLabelBMFont labelWithString:@"retry" fntFile:@"volter.fnt"];
			MenuFont *menuItem1= [MenuFont itemWithLabel:label1 target:self selector:@selector(retry:)];
				
			CCLabelBMFont* label2 = [CCLabelBMFont labelWithString:@"back to menu" fntFile:@"volter.fnt"];
			MenuFont *menuItem2= [MenuFont itemWithLabel:label2 target:self selector:@selector(menu:)];
			
			if (hasFinishedGame == YES) {
				//kein next zeigen, da Spiel fertig ist
				//und dem User gratulieren:
				CCLabelBMFont* congrats = [CCLabelBMFont labelWithString:@"Congratulations!" fntFile:@"volter_small.fnt"];
				congrats.position = ccp(160, 280);
				[self addChild:congrats];
				CCLabelBMFont* beat = [CCLabelBMFont labelWithString:@"You beat the game!" fntFile:@"volter_small.fnt"];
				beat.position = ccp(160, 265);
				[self addChild:beat];
				CCMenu * myMenu = [CCMenu menuWithItems:menuItem1,menuItem2,nil];
				[myMenu alignItemsVertically];
				myMenu.position = ccp(160, 180);
				[self addChild:myMenu];
			} else {
				CCMenu * myMenu = [CCMenu menuWithItems:menuItem0,menuItem1,menuItem2,nil];
				[myMenu alignItemsVertically];
				myMenu.position = ccp(160, 220);
				[self addChild:myMenu];
			}			
			
		} else { //GAME WAS NOT WON
			//TITLE
			CCSprite *title = [CCSprite spriteWithFile:@"Titles/lost_title.png"];
			title.position = ccp(160,420);
			[self addChild:title z:200];
			
			//MENU
			CCLabelBMFont* label = [CCLabelBMFont labelWithString:@"retry" fntFile:@"volter.fnt"];
			MenuFont *menuItem1= [MenuFont itemWithLabel:label target:self selector:@selector(retry:)];
			
			CCLabelBMFont* label2 = [CCLabelBMFont labelWithString:@"back to menu" fntFile:@"volter.fnt"];
			MenuFont *menuItem2= [MenuFont itemWithLabel:label2 target:self selector:@selector(menu:)];
			
			CCMenu * myMenu = [CCMenu menuWithItems:menuItem1,menuItem2,nil];
			[myMenu alignItemsVertically];
			myMenu.position = ccp(160, 220);
			[self addChild:myMenu];
		}

		

		
	}
	return self;
}

//NÄCHSTES LEVEL
-(void)next:(CCMenuItem *) menuItem {
	//LEVELDATEN INITIALISIEREN
	[[GameData sharedData] initLevel:[UserData sharedData].currentLevel withWorld:[UserData sharedData].currentWorld];
	
	[[CCDirector sharedDirector] replaceScene:
	 [CCTransitionFade transitionWithDuration:0.3f scene:[GameScene scene]]];
	
}

//VERSUCHE DIESES LEVEL NOCH EINMAL
-(void)retry:(CCMenuItem *) menuItem {
	//LEVELDATEN INITIALISIEREN
	//********************************
	// WAS IST, WENN VORHER LEVEL 9 GESPIELT WURDE?
	if ([UserData sharedData].currentLevel == 1) {
		if ([GameData sharedData].wasGameWon) {
			[UserData sharedData].currentWorld -= 1;
			[[GameData sharedData] initLevel:9 withWorld:[UserData sharedData].currentWorld-1];
		} else {
			[[GameData sharedData] initLevel:[UserData sharedData].currentLevel withWorld:[UserData sharedData].currentWorld];
		}
	} else if (hasFinishedGame == YES) { //HAT SPIEL BEENDET
		[[GameData sharedData] initLevel:[UserData sharedData].currentLevel withWorld:[UserData sharedData].currentWorld];
	} else { //SONST
		if ([GameData sharedData].wasGameWon) {
			[[GameData sharedData] initLevel:[UserData sharedData].currentLevel-1 withWorld:[UserData sharedData].currentWorld];
		} else {
			[[GameData sharedData] initLevel:[UserData sharedData].currentLevel withWorld:[UserData sharedData].currentWorld];
		}
	}
	[[CCDirector sharedDirector] replaceScene:
	 [CCTransitionFade transitionWithDuration:0.3f scene:[GameScene scene]]];

}

//GEHE ZURÜCK ZUM HAUPTMENU
-(void)menu:(CCMenuItem *) menuItem {
	
	[[CCDirector sharedDirector] replaceScene:
	 [CCTransitionFade transitionWithDuration:0.3f scene:[HelloWorld scene]]];
	
}

//LÖSCHE DIESE INSTANZ
- (void) dealloc
{
	NSLog(@"Deallocating GameOver");
	[super dealloc];
}

@end