//
//  LevelChoice.h
//  MaturaApp
//  © Zeno Koller 2010


#import "cocos2d.h"
#import "GameData.h"
#import "GameScene.h"
#import "HelloWorldScene.h"
#import "ScrollView.h"

@interface WorldChoice : CCLayer
{
	ScrollView *scrollView;
	CCNode *menu;
	CGPoint originalOffset;
	CGPoint originalMenuPosition;
	CCArray *panels;
}

@property(nonatomic,retain) ScrollView *scrollView;
@property(nonatomic,assign) CCNode *menu;
@property(readwrite,assign) CGPoint originalOffset;
@property(readwrite,assign) CGPoint originalMenuPosition;
@property(nonatomic,retain) CCArray *panels;

+(id) sceneWithWorld:(int)world;
-(id)initWithWorld:(int)world;
-(void)back:(CCMenuItem *)menuItem;
-(void)changeSceneTo:(int)world;
-(void)activate:(int)panel;
-(void)deactivate:(int)panel;

@end
