//
//  Countdown.m
//  MaturaApp
//  © Zeno Koller 2010


#import "Countdown.h"
#import "GameData.h"

@implementation Countdown

@synthesize count, countLabel;

+(id) scene
{
	CCScene *scene = [CCScene node];
	Countdown *layer = [Countdown node];
	[scene addChild: layer];
	return scene;
}

//INITIALISIERE INSTANZ
-(id) init
{
	if( (self=[super initWithColor:ccc4(0, 0, 0, 120)] )) {
		
		count = 0;
		countLabel = [[CCLabelBMFont alloc] initWithString:@"3" fntFile:@"bebas.fnt"];
		countLabel.position = ccp(160,240);
		[self addChild: countLabel];
		[self schedule:@selector(countdown:) interval:1.0];
		
	}
	return self;
}

- (void) countdown:(ccTime)dt {
	count += 1;

		switch (count) {
			case 1:
				[countLabel setString:@"2"];
				break;
			case 2:
				[countLabel setString:@"1"];
				break;
			case 3:
				[countLabel setString:@"GO!"];
				break;
			default:
				break;
		}
	
	if (count == 4) {
		
		[self endCountdown];
	}
	
}

-(void) endCountdown {
	[self unschedule:@selector(countdown:)];
	[GameData sharedData].isCountdownFinished = YES;
}

- (void) dealloc
{
	NSLog(@"Deallocating Countdown");
	[countLabel release];
	[super dealloc];
}

@end