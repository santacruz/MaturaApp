//
//  Help.m
//  MaturaApp
//  © Zeno Koller 2010

#import "Help.h"

@implementation Help

@synthesize textView, sprite, originalOffset, normalEnemy, shrinkEnemy, smartEnemy, fastEnemy, ultraEnemy;
@synthesize spriteOriginalPosition, normalSpriteOriginalPosition, shrinkSpriteOriginalPosition, smartSpriteOriginalPosition, fastSpriteOriginalPosition, ultraSpriteOriginalPosition;

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
		textView.text = @"This is you, the little blue ball: \n\n\n\nYour goal is to eat all the other balls on the screen. You move about by tilting the device and you grow whenever you touch an enemy like this one: \n\n\n\nBut stay alert! If you touch an enemy which is bigger than you, you'll lose the game. Moreover, not all of the enemies behave the same. For example there's this red one: \n\n\n\nIf you try to eat him, he'll make you shrink, so beware.\nThen there's the one with the glasses:\n\n\n\nHe'll follow you around as long as he's bigger than you.\nHere's another strange looking fella:\n\n\n\nThis one is very fast, you'll have to move quickly to match his speed.\nAnd the master of them all is the dark blue one:\n\n\n\nHe combines all of the special properties of the other enemies: He'll make his predators shrink, he's smart, so he follows you around and on top of that, he's pretty fast too.";
		[textView setEditable:NO];
		
		[[[CCDirector sharedDirector]openGLView]addSubview:textView];
		
		originalOffset = textView.contentOffset;
		
		//SPRITES
		spriteOriginalPosition = ccp(160,310);
		sprite = [CCSprite spriteWithFile:@"hero/Hero1.png"];
		sprite.position = spriteOriginalPosition;
		[self addChild:sprite];
		
		normalSpriteOriginalPosition = ccp(160,207);
		normalEnemy = [CCSprite spriteWithFile:@"enemy/Enemy1.png"];
		normalEnemy.position = normalSpriteOriginalPosition;
		[self addChild:normalEnemy];
		
		shrinkSpriteOriginalPosition = ccp(160,95);
		shrinkEnemy = [CCSprite spriteWithFile:@"shrink/Shrink1.png"];
		shrinkEnemy.position = shrinkSpriteOriginalPosition;
		[self addChild:shrinkEnemy];
		
		smartSpriteOriginalPosition = ccp(160,-2);
		smartEnemy = [CCSprite spriteWithFile:@"follow/Follow1.png"];
		smartEnemy.position = smartSpriteOriginalPosition;
		[self addChild:smartEnemy];
		
		fastSpriteOriginalPosition = ccp(160,-93);
		fastEnemy = [CCSprite spriteWithFile:@"fast/Fast1.png"];
		fastEnemy.position = fastSpriteOriginalPosition;
		[self addChild:fastEnemy];
		
		ultraSpriteOriginalPosition = ccp(160,-190);
		ultraEnemy = [CCSprite spriteWithFile:@"ultra/Ultra1.png"];
		ultraEnemy.position = ultraSpriteOriginalPosition;
		[self addChild:ultraEnemy];
		
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
	normalEnemy.position = ccpAdd(normalSpriteOriginalPosition, ccpSub(textView.contentOffset, originalOffset));
	shrinkEnemy.position = ccpAdd(shrinkSpriteOriginalPosition, ccpSub(textView.contentOffset, originalOffset));
	smartEnemy.position = ccpAdd(smartSpriteOriginalPosition, ccpSub(textView.contentOffset, originalOffset));
	fastEnemy.position = ccpAdd(fastSpriteOriginalPosition, ccpSub(textView.contentOffset, originalOffset));
	ultraEnemy.position = ccpAdd(ultraSpriteOriginalPosition, ccpSub(textView.contentOffset, originalOffset));
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
