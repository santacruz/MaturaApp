//
//  HelloWorldScene.h
//  MaturaApp
//  © Zeno Koller 2010


#import "cocos2d.h"
#import "GameData.h"
#import "WorldChoice.h"
#import "GameScene.h"
#import "Settings.h"
#import "About.h"
#import "Help.h"
#import "MenuFont.h"

@interface HelloWorld : CCLayer
{
}

+(id) scene;
-(void)start:(CCMenuItem  *) menuItem;
-(void)settings:(CCMenuItem  *) menuItem;
-(void)about:(CCMenuItem  *) menuItem;
-(void)help:(CCMenuItem  *) menuItem;
@end
