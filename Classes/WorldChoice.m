//
//  LevelChoice.m
//  MaturaApp
//  © Zeno Koller 2010

#import "WorldChoice.h"
#define kSpriteRadius 120

@implementation WorldChoice

@synthesize scrollView, menu, glow, originalOffset, originalMenuPosition;

+(id) scene
{
	CCScene *scene = [CCScene node];
	WorldChoice *layer = [WorldChoice node];
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
		
		//GLOW SPRITE
		glow = [CCSprite spriteWithFile:@"LargeSprites/glow.png"];
		glow.position = ccp(160,240);
		glow.visible = NO;
		[self addChild:glow];
		
		//SCROLLVIEW
		NSArray *worlds = [NSArray arrayWithObjects:@"enemy",@"shrink",@"hero",nil];
		int panelCount = worlds.count;
		
		scrollView = [[ScrollView alloc] initWithFrame:CGRectMake(0, 112, 320, 260)];
		
		[scrollView setContentSize:CGSizeMake(320*panelCount, 260)];
		scrollView.panelCount = panelCount;
		scrollView.levelChoice = self;
		
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
	//COOLER EFFEKT
	glow.visible = YES;
	
	//LEVELDATEN INITIALISIEREN
	[[GameData sharedData] initLevel:1];
	[[CCDirector sharedDirector] replaceScene:
	 [CCTransitionCrossFade transitionWithDuration:0.2f scene:[GameScene scene]]];
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
	[super dealloc];
}
@end
