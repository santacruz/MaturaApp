//
//  Help.h
//  MaturaApp
//  © Zeno Koller 2010


#import "cocos2d.h"
#import "GameData.h"
#import "HelloWorldScene.h"

@interface Help : CCLayer
{
		UITextView *textView;
		CCSprite *sprite;
		CGPoint spriteOriginalPosition;	
		CGPoint originalOffset;
}

@property(nonatomic,retain) UITextView *textView;
@property(nonatomic,assign) CCSprite *sprite;
@property(readwrite,assign) CGPoint originalOffset, spriteOriginalPosition;

+(id) scene;
-(void)back:(CCMenuItem *) menuItem;

@end
