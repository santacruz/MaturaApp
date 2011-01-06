//
//  UserData.h
//  MaturaApp
//
//  Created by Zeno Koller on 10.11.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface UserData : NSObject {
	int highestLevel;
	int currentLevel;
	int highestWorld;
	int currentWorld;
	BOOL isVibrationDevice;
	BOOL isVibrationEnabled;
	NSArray * xNorm;
	NSArray * yNorm;
}

@property(readwrite,assign) int highestLevel, currentLevel, highestWorld, currentWorld;
@property(readwrite,assign) BOOL isVibrationDevice, isVibrationEnabled;
@property(nonatomic,retain) NSArray *xNorm, *yNorm;

+(UserData *) sharedData;
-(void)saveAllDataToUserDefaults;

@end