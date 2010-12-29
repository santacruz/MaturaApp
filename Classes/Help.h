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
		CGPoint originalOffset;
		CCSprite *sprite;
		CCSprite *normalEnemy;
		CCSprite *shrinkEnemy;
		CCSprite *smartEnemy;
		CCSprite *fastEnemy;
		CCSprite *ultraEnemy;
		CGPoint spriteOriginalPosition;
		CGPoint normalSpriteOriginalPosition;
		CGPoint shrinkSpriteOriginalPosition;
		CGPoint smartSpriteOriginalPosition;
		CGPoint fastSpriteOriginalPosition;
		CGPoint ultraSpriteOriginalPosition;
}

@property(nonatomic,retain) UITextView *textView;
@property(nonatomic,assign) CCSprite *sprite, *normalEnemy, *shrinkEnemy, *smartEnemy, *fastEnemy, *ultraEnemy;
@property(readwrite,assign) CGPoint originalOffset, spriteOriginalPosition, normalSpriteOriginalPosition, shrinkSpriteOriginalPosition, smartSpriteOriginalPosition, fastSpriteOriginalPosition, ultraSpriteOriginalPosition;

+(id) scene;
-(void)back:(CCMenuItem *) menuItem;

@end
