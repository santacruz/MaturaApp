//
//  HelloWorldScene.h
//  MaturaApp
//  © Zeno Koller 2010


#import "cocos2d.h"
#import "GameData.h"

@interface HelloWorld : CCLayer
{
}

+(id) scene;
-(void)start:(CCMenuItem  *) menuItem;
-(void)scores:(CCMenuItem  *) menuItem;
-(void)settings:(CCMenuItem  *) menuItem;
-(void)about:(CCMenuItem  *) menuItem;
-(void)help:(CCMenuItem  *) menuItem;
@end
