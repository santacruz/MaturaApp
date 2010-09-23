//
//  LevelParser.h
//  MaturaApp
//  © Zeno Koller 2010


#import <Foundation/Foundation.h>
#import "GameData.h"


@interface LevelParser : NSObject {

}



+(id)parseLevel:(int)level;
-(id)initWithLevel:(int)level;
@end
