//
//  Help.m
//  MaturaApp
//  © Zeno Koller 2010

#import "Help.h"
#import "HelloWorldScene.h"

@implementation Help

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
		CCSprite *bg = [CCSprite spriteWithFile:@"BG/bg.png"];
		bg.position = ccp(160,240);
		[self addChild:bg];
		//TITLE
		CCSprite *title = [CCSprite spriteWithFile:@"Titles/help_title.png"];
		title.position = ccp(160,420);
		[self addChild:title];
		
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

-(void)back:(CCMenuItem *)menuItem {
	[[CCDirector sharedDirector] replaceScene:
	 [CCTransitionSlideInL transitionWithDuration:0.4f scene:[HelloWorld scene]]];
	
}

- (void) dealloc
{
	NSLog(@"Help dealloc");
	[super dealloc];
}
@end