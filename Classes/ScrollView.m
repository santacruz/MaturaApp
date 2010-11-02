//
//  ScrollView.m
//  MaturaApp
//  © Zeno Koller 2010


#import "ScrollView.h"
#define kRadius 70

@implementation ScrollView

@synthesize panelCount;

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
	UITouch *myTouch = [touches anyObject];
	CGPoint convert = [[CCDirector sharedDirector] convertToGL:[myTouch locationInView:[myTouch view]]];
	//NSLog(@"Touched at X: %f Y: %f", convert.x,convert.y);
	if (!self.dragging && [self tappedSprite:convert]) {
		NSLog(@"tapped");
	}
}


-(BOOL) tappedSprite:(CGPoint)touch {
	for (int i=0; i<panelCount; i++) {
		float distance = ccpDistance(ccp(160+320*i,340),touch);
		if (distance <= kRadius) return YES;
	}
	return NO;
}


@end
