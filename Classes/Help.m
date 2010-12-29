//
//  Help.m
//  MaturaApp
//  © Zeno Koller 2010

#import "Help.h"

@implementation Help

@synthesize textView, sprite, originalOffset, spriteOriginalPosition;

+(id) scene
{
	CCScene *scene = [CCScene node];
	Help *layer = [Help node];
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
		
		//SCROLLMASK
		CCSprite *scrollMask = [CCSprite spriteWithFile:@"scrollMask.png"];
		scrollMask.position = ccp(160,240);
		[self addChild:scrollMask z:100];
		
		//TITLE
		CCSprite *title = [CCSprite spriteWithFile:@"Titles/help_title.png"];
		title.position = ccp(160,420);
		[self addChild:title z:200];
		
		//TEXT
		textView = [[UITextView alloc] initWithFrame:CGRectMake(38,122,235,260)];
		textView.backgroundColor = [UIColor clearColor];
		textView.textColor = [UIColor colorWithRed:239 green:233 blue:223 alpha:255];
		textView.text = @"This is you, the little blue ball: \n\n\n\nYour goal is to eat all the other balls on the screen. You move about by tilting the device and you grow whenever you touch an enemy like this one: \n\n\n\nBut stay alert! If you touch an enemy which is bigger than you, you'll lose the game.\nMoreover, not all of the enemies behave the same. ";
		[textView setEditable:NO];
		
		[[[CCDirector sharedDirector]openGLView]addSubview:textView];
		
		originalOffset = textView.contentOffset;
		
		//SPRITE
		spriteOriginalPosition = ccp(160,310);
		sprite = [CCSprite spriteWithFile:@"hero/Hero1.png"];
		sprite.position = spriteOriginalPosition;
		[self addChild:sprite];
		
		//BACK MENU
		CCSprite *backSprite = [CCSprite spriteWithFile:@"Buttons/backbutton.png"];
		CCSprite *backSpritePressed = [CCSprite spriteWithFile:@"Buttons/backbutton.png"];
		CCMenuItemSprite *menuItemBack = [CCMenuItemSprite itemFromNormalSprite:backSprite selectedSprite:backSpritePressed target:self selector:@selector(back:)];
		CCMenu *backMenu = [CCMenu menuWithItems:menuItemBack,nil];
		backMenu.position = ccp(160, 50);
		[self addChild:backMenu z:200];
		
		//LOGIK HINZUFÜGEN
		[self schedule:@selector(nextFrame:)];
	}
	return self;
}

-(void)nextFrame:(ccTime)dt {
	sprite.position = ccpAdd(spriteOriginalPosition, ccpSub(textView.contentOffset, originalOffset));
}

-(void)back:(CCMenuItem *)menuItem {
	[self unschedule:@selector(nextFrame:)];
	[textView removeFromSuperview];
	[textView release];
	
	[[CCDirector sharedDirector] replaceScene:
	 [CCTransitionCrossFade transitionWithDuration:0.2f scene:[HelloWorld scene]]];
	
}

- (void) dealloc
{
	NSLog(@"Help dealloc");
	[super dealloc];
}
@end
