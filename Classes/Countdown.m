//
//  Countdown.m
//  MaturaApp
//  © Zeno Koller 2010
//
//	Diese Klasse zeigt den Countdown an, welcher zu Beginn des Spiels abläuft.

#import "Countdown.h"

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
		CCLabelBMFont *levelDisplay = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"Level %i-%i",[UserData sharedData].currentWorld+1,[UserData sharedData].currentLevel] fntFile:@"volter.fnt"];
		levelDisplay.position = ccp(160, 320);
		[self addChild:levelDisplay];
		countLabel = [[CCLabelBMFont alloc] initWithString:@"3" fntFile:@"volter.fnt"];
		countLabel.position = ccp(160,240);
		[self addChild: countLabel];
		[self schedule:@selector(countdown:) interval:1.0];
		
	}
	return self;
}

//FÜHRE DEN 3-SEKUNDEN COUNTDOWN AUS
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

//COUNTDOWN FERTIG, BEGINNE SPIEL
-(void) endCountdown {
	[self unschedule:@selector(countdown:)];
	[GameData sharedData].isCountdownFinished = YES;
}

//LÖSCHE INSTANZ AUS MEMORY
- (void) dealloc
{
	NSLog(@"Deallocating Countdown");
	[countLabel release];
	[super dealloc];
}

@end