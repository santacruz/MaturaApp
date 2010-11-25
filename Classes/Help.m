//
//  Help.m
//  MaturaApp
//  © Zeno Koller 2010

#import "Help.h"

@implementation Help

@synthesize textView, sprite, originalOffset;

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
		textView.text = @"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras sagittis porta porttitor. Vestibulum vitae nunc non enim tempus fringilla eget sed libero. Vestibulum hendrerit nisl eget leo tempus sed commodo felis varius.\n\n\n\n Donec dui arcu, pellentesque ut tempor sed, aliquam at dui. Curabitur commodo urna ac dolor eleifend in fringilla tellus pretium. Ut massa arcu, volutpat a volutpat tincidunt, aliquet nec felis. Donec id nunc justo, quis blandit erat. Suspendisse cursus massa non ligula varius adipiscing pretium justo mattis. Curabitur mollis erat metus, sed egestas odio. Aliquam justo dolor, dignissim dignissim mollis sed, molestie sit amet mi. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Ut tempor nisl eget lectus tincidunt fringilla adipiscing nisi consequat. Morbi porta semper vestibulum. Nam non dolor eget massa pharetra pretium eu id magna.Duis sollicitudin rhoncus felis, nec varius velit pulvinar vitae. Sed eleifend diam et nisi imperdiet ultricies. Proin tempus tortor eget dolor facilisis feugiat. Aliquam at imperdiet felis. Aenean egestas tellus pharetra tortor luctus aliquet. Maecenas nunc diam, viverra nec bibendum vel, scelerisque dapibus tellus. Curabitur eu nunc ante, ut facilisis nunc. Maecenas ut est eu enim placerat mollis et ac nunc. Praesent rhoncus elit in nunc faucibus scelerisque. Duis ullamcorper elementum nisl vel accumsan. Vestibulum lobortis imperdiet arcu suscipit dignissim.";
		[textView setEditable:NO];
		
		[[[CCDirector sharedDirector]openGLView]addSubview:textView];
		
		originalOffset = textView.contentOffset;
		
		//SPRITE
		sprite = [CCSprite spriteWithFile:@"hero/Hero1.png"];
		sprite.position = ccp(160,237);
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
	sprite.position = ccpAdd(ccp(160,237), ccpSub(textView.contentOffset, originalOffset));
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
