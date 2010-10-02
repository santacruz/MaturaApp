//
//  HelloWorldScene.h
//  MaturaApp
//  © Zeno Koller 2010


#import "cocos2d.h"
#import "GameData.h"

@interface HelloWorld : CCColorLayer
{
}

+(id) scene;
-(void)runGame1:(CCMenuItem  *) menuItem;
-(void)runGame2:(CCMenuItem  *) menuItem;

@end
