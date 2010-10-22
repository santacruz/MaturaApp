//
//  PauseLayer.h
//  MaturaApp
//  © Zeno Koller 2010


#import "cocos2d.h"


@interface PauseLayer : CCColorLayer {
}

+(id)scene;
-(void)resume:(CCMenuItem *) menuItem;
-(void)backToMenu:(CCMenuItem *) menuItem;

@end