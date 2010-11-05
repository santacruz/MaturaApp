//
//  ScrollView.h
//  MaturaApp
//  © Zeno Koller 2010


#import <Foundation/Foundation.h>
@class WorldChoice;

@interface ScrollView : UIScrollView {
	int panelCount;
	int chosenPanel;
	WorldChoice *worldChoice;
}

@property(readwrite,assign)int panelCount;
@property(readwrite,assign)int chosenPanel;
@property(nonatomic,assign)WorldChoice *worldChoice;

-(BOOL) tappedSprite:(CGPoint)touch; 

@end
