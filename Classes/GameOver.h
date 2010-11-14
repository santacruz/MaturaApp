//
//  GameOver.h
//  MaturaApp
//  © Zeno Koller 2010


#import "cocos2d.h"
#import "GameData.h"
#import "HelloWorldScene.h"
#import "GameScene.h"
#import "UserData.h"

@interface GameOver : CCLayer {

}


+(id)scene;
-(void)next:(CCMenuItem *) menuItem;
-(void)retry:(CCMenuItem *) menuItem;
-(void)menu:(CCMenuItem *) menuItem;

@end