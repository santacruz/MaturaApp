//
//  LevelChoice.m
//  MaturaApp
//  © Zeno Koller 2010
//
//	Diese Klasse zeigt den Bildschirm mit der Levelauswahl an.

#import "LevelChoice.h"

@implementation LevelChoice

@synthesize menu, count;

+(id) sceneWithWorld:(int)world
{
	CCScene *scene = [CCScene node];
	LevelChoice *layer = [[[LevelChoice alloc] initWithWorld:world] autorelease];
	[scene addChild: layer];
	return scene;
}


//INITIALISIERE INSTANZ
-(id) initWithWorld:(int)world
{
	if( (self=[super init] )) {
		//BACKGROUND
		CCSprite *bg = [CCSprite spriteWithFile:@"BG/BG.png"];
		bg.position = ccp(160,240);
		[self addChild:bg];
		//TITLE
		CCSprite *title = [CCSprite spriteWithFile:@"Titles/levels_title.png"];
		title.position = ccp(160,420);
		[self addChild:title];
		
		menu = [CCMenu menuWithItems:nil];
		count = 0;
		
		//3x3 MENU ZEICHNEN
		for (int i=0;i<3;i++) {
			for (int k=0;k<3;k++) {
				count += 1;
				CCSprite *levelButton = [CCSprite spriteWithFile:[NSString stringWithFormat:@"LevelButtons/level0%i.png", count]];
				CCSprite *levelButton_s = [CCSprite spriteWithFile:[NSString stringWithFormat:@"LevelButtons/level0%i.png", count]];
				[levelButton_s setColor:ccc3(172, 224, 250)];
				CCMenuItemSprite *menuItemLevelButton = [CCMenuItemSprite itemFromNormalSprite:levelButton selectedSprite:levelButton_s target:self selector:@selector(selectedLevel:)]; 
				menuItemLevelButton.position = ccp(k*80,0-i*80);
				menuItemLevelButton.tag = count;
				//SETZE TRANSPARENZ UND BEDIENBARKEIT, FALLS LEVEL NOCH NICHT ERREICHT
				if (count>[UserData sharedData].highestLevel && world==[UserData sharedData].highestWorld) {
					levelButton.opacity = 100;
					menuItemLevelButton.isEnabled = NO;
				} else if (count==[UserData sharedData].highestLevel && world==[UserData sharedData].highestWorld) {//FALLS "ON THE EDGE"
					//FÄRBE LEVEL GELB
					[levelButton setColor:ccc3(251, 227, 69)];
				}
				[menu addChild:menuItemLevelButton];
			}
		}
		
		menu.position = ccp(80,300);
		[self addChild:menu];
		
		//BACK MENU
		CCSprite *backSprite = [CCSprite spriteWithFile:@"Buttons/backbutton.png"];
		CCSprite *backSpritePressed = [CCSprite spriteWithFile:@"Buttons/backbutton.png"];
		[backSpritePressed setColor:ccc3(172, 224, 250)];
		CCMenuItemSprite *menuItemBack = [CCMenuItemSprite itemFromNormalSprite:backSprite selectedSprite:backSpritePressed target:self selector:@selector(back:)];
		CCMenu *backMenu = [CCMenu menuWithItems:menuItemBack,nil];
		backMenu.position = ccp(160, 50);
		[self addChild:backMenu];
	}
	return self;
}

//LADE DAS AUSGEWÄHLTE LEVEL
-(void)selectedLevel:(id)sender {
	CCMenuItem *item = (CCMenuItem *)sender;
	int level = item.tag;
	[[GameData sharedData] initLevel:level withWorld:[UserData sharedData].currentWorld];
	[[CCDirector sharedDirector] replaceScene:
	 [CCTransitionFade transitionWithDuration:0.5f scene:[GameScene scene]]];
	
}

//ZURÜCK
-(void)back:(CCMenuItem *)menuItem {
	[[CCDirector sharedDirector] replaceScene:
	 [CCTransitionCrossFade transitionWithDuration:0.2f scene:[WorldChoice sceneWithWorld:[UserData sharedData].currentWorld]]];
}

//LÖSCHE DIESE INSTANZ
- (void) dealloc
{
	NSLog(@"LevelChoice dealloc");
	[[CCDirector sharedDirector] purgeCachedData];
	[super dealloc];
}

@end
