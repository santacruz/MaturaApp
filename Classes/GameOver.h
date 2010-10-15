//
//  GameOver.h
//  MaturaApp
//  © Zeno Koller 2010


#import "cocos2d.h"


@interface GameOver : CCLayer {

}


+(id)scene;
-(void)retry:(CCMenuItem *) menuItem;
-(void)menu:(CCMenuItem *) menuItem;

@end