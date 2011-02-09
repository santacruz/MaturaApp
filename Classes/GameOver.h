//
//  GameOver.h
//  MaturaApp
//  © Zeno Koller 2010


#import "cocos2d.h"
#import "GameData.h"
#import "HelloWorldScene.h"
#import "GameScene.h"
#import "UserData.h"
#import "MenuFont.h"

@interface GameOver : CCLayer {
	BOOL hasFinishedGame;
}
@property(readwrite, assign)BOOL hasFinishedGame;

+(id)scene;
-(void)next:(CCMenuItem *) menuItem;
-(void)retry:(CCMenuItem *) menuItem;
-(void)menu:(CCMenuItem *) menuItem;

@end