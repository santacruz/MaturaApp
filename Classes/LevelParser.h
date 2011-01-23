//
//  LevelParser.h
//  MaturaApp
//  © Zeno Koller 2010


#import <Foundation/Foundation.h>
#import "GameData.h"
#import "cocos2d.h"

@interface LevelParser : NSObject {

}

//Erstellt Instanz des Levelparsers, welche ein 
//bestimmtes Level aus dem Speicher liest
+(id)parseLevel:(int)level withWorld:(int)world;
//Initialisiere die Instanz
-(id)initWithLevel:(int)level withWorld:(int)world;
@end
