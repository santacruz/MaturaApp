//
//  About.h
//  MaturaApp
//  © Zeno Koller 2010


#import "cocos2d.h"
#import "GameData.h"

@interface About : CCLayer
{
	UITextView *textView;
}

@property(nonatomic,retain) UITextView *textView;

+(id) scene;
-(void)back:(CCMenuItem *) menuItem;

@end
