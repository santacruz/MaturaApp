//
//  HelloWorldScene.m
//  MaturaApp

#import "HelloWorldScene.h"
#import "GameScene.h"

@implementation HelloWorld

+(id) scene
{
	CCScene *scene = [CCScene node];
	HelloWorld *layer = [HelloWorld node];
	[scene addChild: layer];
	return scene;
}

//INITIALISIERE INSTANZ
-(id) init
{
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

- (void) dealloc
{
	NSLog(@"Menu dealloc");
	[super dealloc];
}
@end
