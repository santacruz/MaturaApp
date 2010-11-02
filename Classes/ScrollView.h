//
//  ScrollView.h
//  MaturaApp
//  © Zeno Koller 2010


#import <Foundation/Foundation.h>


@interface ScrollView : UIScrollView {
	int panelCount;
}

@property(readwrite,assign)int panelCount;

-(BOOL) tappedSprite:(CGPoint)touch; 

@end
