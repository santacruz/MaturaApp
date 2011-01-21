//
//  About.m
//  MaturaApp
//  © Zeno Koller 2010
//
//	Diese Klasse zeigt den About-Screen an.

#import "About.h"
#import "HelloWorldScene.h"

@implementation About

@synthesize textView;

+(id) scene
{
	CCScene *scene = [CCScene node];
	About *layer = [About node];
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
		//TITLE
		CCSprite *title = [CCSprite spriteWithFile:@"Titles/about_title.png"];
		title.position = ccp(160,420);
		[self addChild:title];
		
		//TEXT
		textView = [[UITextView alloc] initWithFrame:CGRectMake(38,122,235,260)];
		textView.backgroundColor = [UIColor clearColor];
		textView.textColor = [UIColor colorWithRed:239 green:233 blue:223 alpha:255];
		textView.text = @"Code & Design - Zeno Koller\nFont - Volter\n\nCreated with Cocos2d";
		[textView setEditable:NO];
		
		[[[CCDirector sharedDirector]openGLView]addSubview:textView];
		
		//BACK MENU
		CCSprite *backSprite = [CCSprite spriteWithFile:@"Buttons/backbutton.png"];
		CCSprite *backSpritePressed = [CCSprite spriteWithFile:@"Buttons/backbutton.png"];
		CCMenuItemSprite *menuItemBack = [CCMenuItemSprite itemFromNormalSprite:backSprite selectedSprite:backSpritePressed target:self selector:@selector(back:)];
		CCMenu *backMenu = [CCMenu menuWithItems:menuItemBack,nil];
		backMenu.position = ccp(160, 50);
		[self addChild:backMenu];
	}
	return self;
}

//ZURÜCK
-(void)back:(CCMenuItem *)menuItem {
	[textView removeFromSuperview];
	[textView release];
	
	[[CCDirector sharedDirector] replaceScene:
	 [CCTransitionCrossFade transitionWithDuration:0.2f scene:[HelloWorld scene]]];
	
}

//LÖSCHE DIESE INSTANZ
- (void) dealloc
{
	NSLog(@"About dealloc");
	[super dealloc];
}
@end
