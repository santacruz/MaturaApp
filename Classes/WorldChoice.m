//
//  LevelChoice.m
//  MaturaApp
//  © Zeno Koller 2010

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
		CCSprite *bg = [CCSprite spriteWithFile:@"BG/bg.png"];
		bg.position = ccp(160,240);
		[self addChild:bg];
		//TITLE
		CCSprite *title = [CCSprite spriteWithFile:@"Titles/level_title.png"];
		title.position = ccp(160,420);
		[self addChild:title];
		
		//SCROLLVIEW
		NSArray *worlds = [NSArray arrayWithObjects:@"enemy",@"shrink",@"follow",@"fastfollow",@"evil",nil];
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
			[menu addChild:worldImg];
			//auch zu Array
			[panels addObject:worldImg];
		}
		menu.position = ccp(160,230);
		originalMenuPosition = menu.position;
		[self addChild:menu];
		
		//LOGIK HINZUFÜGEN
		[self schedule:@selector(nextFrame:)];
		
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

- (void) nextFrame:(ccTime)dt {
	menu.position = ccpAdd(originalMenuPosition, ccpMult(ccp((originalOffset.x-scrollView.contentOffset.x),0),0.554f));
}

-(void)changeSceneTo:(int)world {
	//LEVELDATEN INITIALISIEREN
	[[GameData sharedData] initLevel:1];
	//Hier World Auswahl starten mit aktueller Welt aus UserData
	[[CCDirector sharedDirector] replaceScene:
	 [CCTransitionCrossFade transitionWithDuration:0.5f scene:[LevelChoice sceneWithWorld:world]]];
}

-(void)activate:(int)panel {
	CCSprite *sprite = (CCSprite *)[panels objectAtIndex:panel];
	id zoomIn = [CCScaleTo actionWithDuration:0.1f scale:1.2f];
	[sprite runAction:zoomIn];
}

-(void)deactivate:(int)panel {
	CCSprite *sprite = (CCSprite *)[panels objectAtIndex:panel];
	id zoomOut = [CCScaleTo actionWithDuration:0.1f scale:1.0f];
	[sprite runAction:zoomOut];
}

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

- (void) dealloc
{
	NSLog(@"LevelChoice dealloc");
	[panels release];
	[super dealloc];
}
@end
