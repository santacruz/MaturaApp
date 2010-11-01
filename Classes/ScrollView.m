//
//  ScrollView.m
//  MaturaApp
//  © Zeno Koller 2010


#import "ScrollView.h"
#define kRadius 60

@implementation ScrollView

-(id)initWithFrame:(CGRect)frame{
	if ((self=[super initWithFrame:frame])) {
		self.pagingEnabled = YES;
		self.bounces = YES;
		self.showsHorizontalScrollIndicator = NO;
		[self setUserInteractionEnabled:TRUE];
		self.backgroundColor = [UIColor clearColor];
		[self setContentOffset:ccp(0,0)];
	}
	return self;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	if (!self.dragging) {
		NSLog(@"touched");
		//ÜBERPRÜFEN, OB TOUCH IM RADIUS VOM SPRITE IST. WENN JA, 
		//GLOW (GLOWSPRITE Z:-2 IN LEVELCHOICE VISIBILITY = YES) LEVELCHOICE ->SCROLLVIEW MIT POINTER INITIALISIEREN!!
		//SOUND
		//[CCDIRECTOR REPLACESCENE:LEVEL_SUBCHOICE]
	}
}

@end
