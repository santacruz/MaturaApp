//
//  HelloWorldScene.h
//  MaturaApp


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

// HelloWorld Layer
@interface HelloWorld : CCLayer
{
}

// returns a Scene that contains the HelloWorld as the only child
+(id) scene;
-(void)runGame:(CCMenuItem  *) menuItem;
@end
