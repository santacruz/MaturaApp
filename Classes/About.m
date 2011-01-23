//
//  About.m
//  MaturaApp
//  © Zeno Koller 2010
//
//	Diese Klasse zeigt den About-Screen an.

#import "About.h"
#import "HelloWorldScene.h"

@implementation About

@synthesize textView, textViewRight;

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
		
		//LOGO
		CCSprite *logo = [CCSprite spriteWithFile:@"logo.png"];
		logo.position = ccp(160, 260);
		[self addChild:logo];
		
		//TEXT
		textView = [[UITextView alloc] initWithFrame:CGRectMake(38,122,235,260)];
		textView.backgroundColor = [UIColor clearColor];
		textView.textColor = [UIColor colorWithRed:239 green:233 blue:223 alpha:255];
		textView.text = @"Code & Graphics\nFont";
		[textView setEditable:NO];
		[[[CCDirector sharedDirector]openGLView]addSubview:textView];
		
		textViewRight = [[UITextView alloc] initWithFrame:CGRectMake(44,122,235,260)];
		textViewRight.textAlignment = UITextAlignmentRight;
		textViewRight.backgroundColor = [UIColor clearColor];
		textViewRight.textColor = [UIColor colorWithRed:239 green:233 blue:223 alpha:255];
		textViewRight.text = @"Zeno Koller\nVolter via daFont.com";
		[textViewRight setEditable:NO];
		[[[CCDirector sharedDirector]openGLView]addSubview:textViewRight];		
		
		CCLabelBMFont *cocos = [CCLabelBMFont labelWithString:@"Created with Cocos2d" fntFile:@"volter_small.fnt"];
		cocos.position = ccp(160,290);
		[self addChild:cocos];
		
		CCLabelBMFont *copyright = [CCLabelBMFont labelWithString:@"(c) 2011 by Zeno Koller" fntFile:@"volter_small.fnt"];
		copyright.position = ccp(160,225<);
		[self addChild:copyright];
		
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
	[textViewRight removeFromSuperview];
	[textViewRight release];
	
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
