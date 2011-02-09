//
//  LevelChoice.m
//  MaturaApp
//  © Zeno Koller 2010
//
//	Diese Klasse stellt die Welt-Auswahl dar.

#import "WorldChoice.h"
#import "LevelChoice.h"
#define kSpriteRadius 120

@implementation WorldChoice

@synthesize scrollView, menu, originalOffset, originalMenuPosition, panels;

+(id) sceneWithWorld:(int)world
{
	CCScene *scene = [CCScene node];
	WorldChoice *layer = [[[WorldChoice alloc] initWithWorld:world] autorelease];
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
		CCSprite *title = [CCSprite spriteWithFile:@"Titles/worlds_title.png"];
		title.position = ccp(160,420);
		[self addChild:title];
		
		//SCROLLVIEW
		NSArray *worlds = [NSArray arrayWithObjects:@"enemy",@"shrink",@"follow",@"fast",@"evil",nil];
		int panelCount = worlds.count;
		
		//zu diesem Array werden die einzelnen Bilder hinzugefügt
		panels = [[CCArray alloc] init];
		
		scrollView = [[ScrollView alloc] initWithFrame:CGRectMake(0, 112, 320, 260)];
		
		[scrollView setContentSize:CGSizeMake(320*panelCount, 260)];
		scrollView.panelCount = panelCount;
		scrollView.worldChoice = self;
		
		originalOffset = scrollView.contentOffset;
		
		[[[CCDirector sharedDirector]openGLView]addSubview:scrollView];
		
		//Zu diesem Node fügen wir Bilder hinzu
		menu = [CCNode node];
		menu.position = ccp(0,0);
		
		//WELT AUSWAHL MENU
		for (int i=0; i<panelCount; i++) {
			CCSprite *worldImg = [CCSprite spriteWithFile:[NSString stringWithFormat:@"LargeSprites/%@.png",[worlds objectAtIndex:i]]];
			worldImg.position = ccpMult(ccp(177.5,0),i);
			if (i>[UserData sharedData].highestWorld) {
				worldImg.opacity = 50;
			}
			[menu addChild:worldImg];
			//auch zu Array
			[panels addObject:worldImg];
		}
		
		menu.position = ccp(160,230);
		originalMenuPosition = menu.position;
		[self addChild:menu];
		
		//LOGIK HINZUFÜGEN
		[self schedule:@selector(nextFrame:)];
		
		//OFFSET SETZEN
		[scrollView setContentOffset:ccp(320*world,0)];
		menu.position = ccpAdd(originalMenuPosition, ccpMult(ccp((originalOffset.x-scrollView.contentOffset.x),0),0.554f));
		
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

//LOOP, WELCHER DIE POSITION DER BILDER UPDATET
- (void) nextFrame:(ccTime)dt {
	menu.position = ccpAdd(originalMenuPosition, ccpMult(ccp((originalOffset.x-scrollView.contentOffset.x),0),0.554f));
}

//EINE WELT WURDE AUSGEWÄHLT, LADE DIE LEVEL-AUSWAHL
-(void)changeSceneTo:(int)world {
	if (!(world>[UserData sharedData].highestWorld)) {
		[UserData sharedData].currentWorld = world;
		[[UserData sharedData] saveAllDataToUserDefaults];
		//Hier World Auswahl starten mit aktueller Welt aus UserData
		[[CCDirector sharedDirector] replaceScene:
		 [CCTransitionCrossFade transitionWithDuration:0.5f scene:[LevelChoice sceneWithWorld:world]]];
	}
}

//ZOOM IN EFFEKT
-(void)activate:(int)panel {
	CCSprite *sprite = (CCSprite *)[panels objectAtIndex:panel];
	id zoomIn = [CCScaleTo actionWithDuration:0.1f scale:1.2f];
	[sprite runAction:zoomIn];
}

//ZOOM OUT EFFEKT
-(void)deactivate:(int)panel {
	CCSprite *sprite = (CCSprite *)[panels objectAtIndex:panel];
	id zoomOut = [CCScaleTo actionWithDuration:0.1f scale:1.0f];
	[sprite runAction:zoomOut];
}

//ZURÜCK
-(void)back:(CCMenuItem *)menuItem {
	[[CCDirector sharedDirector] replaceScene:
	 [CCTransitionCrossFade transitionWithDuration:0.2f scene:[HelloWorld scene]]];
}

- (void) onExit 
{
	[self unschedule:@selector(nextFrame:)];
    [scrollView removeFromSuperview];
	[scrollView release];
    [super onExit];
}

//LÖSCHE DIESE INSTANZ
- (void) dealloc
{
	NSLog(@"WorldChoice dealloc");
	[[CCDirector sharedDirector] purgeCachedData];
	[panels release];
	[super dealloc];
}
@end