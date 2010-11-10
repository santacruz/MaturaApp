//
//  LevelParser.h
//  MaturaApp
//  © Zeno Koller 2010


#import <Foundation/Foundation.h>
#import "GameData.h"
#import "cocos2d.h"

@interface LevelParser : NSObject {

}



+(id)parseLevel:(int)level withWorld:(int)world;
-(id)initWithLevel:(int)level withWorld:(int)world;
@end
