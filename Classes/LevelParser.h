//
//  LevelParser.h
//  MaturaApp
//  © Zeno Koller 2010


#import <Foundation/Foundation.h>

@protocol NSXMLParserDelegate;
@interface LevelParser : NSObject <NSXMLParserDelegate> {

}

+(id)parseLevel;
//Später
//+(id)parseLevel:(int)level;
@end
