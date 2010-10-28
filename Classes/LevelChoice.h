//
//  LevelChoice.h
//  MaturaApp
//  © Zeno Koller 2010


#import "cocos2d.h"
#import "GameData.h"
#import "GameScene.h"
#import "HelloWorldScene.h"

@interface LevelChoice : CCLayer
{
}

+(id) scene;
-(void)runGame1:(CCMenuItem  *) menuItem;
-(void)runGame2:(CCMenuItem  *) menuItem;
-(void)runGame3:(CCMenuItem  *) menuItem;
-(void)runGame4:(CCMenuItem  *) menuItem;
-(void)runGame5:(CCMenuItem  *) menuItem;
-(void)runGame6:(CCMenuItem  *) menuItem;
-(void)back:(CCMenuItem *) menuItem;

@end
