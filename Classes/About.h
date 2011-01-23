//
//  About.h
//  MaturaApp
//  © Zeno Koller 2010


#import "cocos2d.h"
#import "GameData.h"
#import "HelloWorldScene.h"

@interface About : CCLayer
{
	UITextView *textView;
	UITextView *textViewRight;
}

@property(nonatomic,retain) UITextView *textView, *textViewRight;

+(id) scene;
-(void)back:(CCMenuItem *) menuItem;

@end
