//
//  GameOver.m
//  MaturaApp
//  © Zeno Koller 2010


#import "GameOver.h"

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
			//UPDATE USERDATA
			/*//IST GESPIELTES LEVEL HÖCHSTES LEVEL?
			if ([UserData sharedData].highestLevel == [UserData sharedData].currentLevel) {
				//IST GESPIELTE WELT HÖCHSTE WELT?
				if ([UserData sharedData].highestWorld == [UserData sharedData].currentWorld) {
					//WIRD LETZTES LEVEL GESPIELT?
					if ([UserData sharedData].currentLevel == 9) {
						[UserData sharedData].highestWorld += 1;
						[UserData sharedData].currentWorld += 1;
						[UserData sharedData].highestLevel = 1;
						[UserData sharedData].currentLevel = 1;
					} else {
						[UserData sharedData].highestLevel += 1;
						[UserData sharedData].currentLevel += 1;
					}
				} else { //WENN NICHT IN DER HÖCHSTEN WELT, NUR CURRENTLEVEL ERHÖHEN
					//WIRD LETZTES LEVEL GESPIELT?
					if ([UserData sharedData].currentLevel == 9) {
						[UserData sharedData].currentWorld += 1;
						[UserData sharedData].currentLevel = 1;
					} else {
						[UserData sharedData].currentLevel += 1;
					}
				}
			} else { //WENN GESPIELTES LEVEL NICHT HÖCHSTES LEVEL
				[UserData sharedData].currentLevel += 1;
			}*/
			
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
	

			[[UserData sharedData] saveAllDataToUserDefaults];
			
			//TITLE
			CCSprite *title = [CCSprite spriteWithFile:@"Titles/youwon_title.png"];
			title.position = ccp(160,420);
			[self addChild:title z:200];
			
			//MENU
			CCLabelBMFont* label0 = [CCLabelBMFont labelWithString:@"next" fntFile:@"volter.fnt"];
			CCMenuItemLabel *menuItem0= [CCMenuItemLabel itemWithLabel:label0 target:self selector:@selector(next:)];

			
			CCLabelBMFont* label1 = [CCLabelBMFont labelWithString:@"retry" fntFile:@"volter.fnt"];
			CCMenuItemLabel *menuItem1= [CCMenuItemLabel itemWithLabel:label1 target:self selector:@selector(retry:)];
			
			CCLabelBMFont* label2 = [CCLabelBMFont labelWithString:@"back to menu" fntFile:@"volter.fnt"];
			CCMenuItemLabel *menuItem2= [CCMenuItemLabel itemWithLabel:label2 target:self selector:@selector(menu:)];
			
			CCMenu * myMenu = [CCMenu menuWithItems:menuItem0,menuItem1,menuItem2,nil];
			[myMenu alignItemsVertically];
			myMenu.position = ccp(160, 220);
			[self addChild:myMenu];
			
			
		} else { //GAME WAS NOT WON
			//TITLE
			CCSprite *title = [CCSprite spriteWithFile:@"Titles/lost_title.png"];
			title.position = ccp(160,420);
			[self addChild:title z:200];
			
			//MENU
			CCLabelBMFont* label = [CCLabelBMFont labelWithString:@"retry" fntFile:@"volter.fnt"];
			CCMenuItemLabel *menuItem1= [CCMenuItemLabel itemWithLabel:label target:self selector:@selector(retry:)];
			
			CCLabelBMFont* label2 = [CCLabelBMFont labelWithString:@"back to menu" fntFile:@"volter.fnt"];
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
	[[GameData sharedData] initLevel:[UserData sharedData].currentLevel withWorld:[UserData sharedData].currentWorld];
	
	[[CCDirector sharedDirector] replaceScene:
	 [CCTransitionFade transitionWithDuration:0.3f scene:[GameScene scene]]];
	
}


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