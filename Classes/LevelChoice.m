//
//  LevelChoice.m
//  MaturaApp
//  © Zeno Koller 2010

#import "LevelChoice.h"
#define kSpriteRadius 120

@implementation LevelChoice

@synthesize scrollView, menu, originalOffset, originalMenuPosition;

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
		
		//SCROLLVIEW
		NSArray *worlds = [NSArray arrayWithObjects:@"enemy",@"shrink",nil];
		int panelCount = worlds.count;
		
		scrollView = [[ScrollView alloc] initWithFrame:CGRectMake(0, 112, 320, 260)];
		
		[scrollView setContentSize:CGSizeMake(320*panelCount, 260)];
	
		originalOffset = scrollView.contentOffset;
		
		[[[CCDirector sharedDirector]openGLView]addSubview:scrollView];

		menu = [CCMenu menuWithItems:nil];
		
		//WELT AUSWAHL MENU
		for (int i=0; i<panelCount; i++) {
			CCSprite *worldImg = [CCSprite spriteWithFile:[NSString stringWithFormat:@"LargeSprites/%@.png",[worlds objectAtIndex:i]]];
			CCMenuItemSprite *worldItem = [CCMenuItemSprite itemFromNormalSprite:worldImg selectedSprite:worldImg target:self selector:@selector(worldPicked:)];
			[menu addChild:worldItem];
		}
		
		[menu alignItemsHorizontallyWithPadding:50];
		menu.position = ccp(320,220); // <-- !!!
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

- (void) worldPicked:(CCMenuItem *)menuItem{
	NSLog(@"world Picked");
	//TODO: METHODE ENTFERNEN
}

- (void) nextFrame:(ccTime)dt {
	menu.position = ccpAdd(originalMenuPosition, ccp((originalOffset.x-scrollView.contentOffset.x),0));
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
