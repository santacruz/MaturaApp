//
//  LevelChoice.h
//  MaturaApp
//  © Zeno Koller 2010


#import "cocos2d.h"
#import "GameData.h"
#import "GameScene.h"
#import "HelloWorldScene.h"
#import "ScrollView.h"

@interface LevelChoice : CCLayer
{
	ScrollView *scrollView;
	CCMenu *menu;
	CGPoint originalOffset;
	CGPoint originalMenuPosition;
}

@property(nonatomic,retain) ScrollView *scrollView;
@property(nonatomic,assign) CCMenu *menu;
@property(readwrite,assign) CGPoint originalOffset;
@property(readwrite,assign) CGPoint originalMenuPosition;


+(id) scene;
-(void)back:(CCMenuItem *)menuItem;
- (void) worldPicked:(CCMenuItem *)menuItem;

@end
