//
//  AccHelper.h
//  MaturaApp
//  © Zeno Koller 2011

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface AccHelper : NSObject {
	
}

-(float)dotVec1:(NSArray *)vec1 Vec2:(NSArray *) vec2;
-(NSArray *)crossVec1:(NSArray *)vec1 Vec2:(NSArray *) vec2;
-(int)sign:(float)number;

@end
