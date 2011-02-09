//
//  MenuFont.m
//  MaturaApp
//  © Zeno Koller 2010


#import "MenuFont.h"

enum {
	kCurrentItem = 0xc0c05001,
};

@implementation MenuFont

-(void) selected
{
	// subclass to change the default action
	if(isEnabled_) {	
		[super setColor:ccc3(172, 224, 250)];		
	}
}

-(void) unselected
{
	// subclass to change the default action
	if(isEnabled_) {
		[super setColor:ccc3(255, 255, 255)];
	}
}

@end
