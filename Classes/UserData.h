//
//  UserData.h
//  MaturaApp
//
//  Created by Zeno Koller on 10.11.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

//	In dieser Klasse werden die Daten bezüglich dem Benutzer gespeichert.
@interface UserData : NSObject {
	int highestLevel;
	int currentLevel;
	int highestWorld;
	int currentWorld;
	BOOL isVibrationDevice;
	BOOL isVibrationEnabled;
	NSArray * xGrund;
	NSArray * yGrund;
}

@property(readwrite,assign) int highestLevel, currentLevel, highestWorld, currentWorld;
@property(readwrite,assign) BOOL isVibrationDevice, isVibrationEnabled;
@property(nonatomic,retain) NSArray *xGrund, *yGrund;

//erstellt einen Singleton der Klasse GameData:
+(UserData *) sharedData;
//speichert die aktuellen Daten ab
-(void)saveAllDataToUserDefaults;

@end