//
//  HelloWorldScene.m
//  MaturaApp

// Import the interfaces
#import "HelloWorldScene.h"
#import "GameScene.h"

// HelloWorld implementation
@implementation HelloWorld

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorld *layer = [HelloWorld node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super initWithColor:ccc4(220,220,220,255)] )) {
		
		CCLabelTTF* label = [CCLabelTTF labelWithString:@"start" fontName:@"Helvetica" fontSize:50];
		label.color = ccc3(30,30,30);
		CCMenuItemLabel *menuItem1= [CCMenuItemLabel itemWithLabel:label target:self selector:@selector(runGame:)];
		CCMenu * myMenu = [CCMenu menuWithItems:menuItem1,nil];
		[self addChild:myMenu];
	}
	return self;
}

-(void) runGame:(CCMenuItem  *) menuItem  {
	[[CCDirector sharedDirector] replaceScene:
	 [CCTransitionFade transitionWithDuration:0.5f scene:[GameScene scene]]];
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}
@end
