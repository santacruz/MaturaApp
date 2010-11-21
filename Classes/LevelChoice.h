//
//  LevelChoice.h
//  MaturaApp
//  © Zeno Koller 2010


#import "cocos2d.h"
#import "WorldChoice.h"
#import "UserData.h"

@interface LevelChoice : CCLayer {
	CCMenu *menu;
	int count;
}

@property(nonatomic,assign)CCMenu *menu;
@property(readwrite,assign)int count;

+(id) sceneWithWorld:(int)world;
-(id) initWithWorld:(int)world;
-(void)back:(CCMenuItem *)menuItem;
-(void)selectedLevel:(id)sender;

@end
