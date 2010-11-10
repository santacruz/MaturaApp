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
	int highestWorld;
	int currentWorld;
	float accelCorrectionX;
	float accelCorrectionY;
}

@property(readwrite,assign) float accelCorrectionX, accelCorrectionY;
@property(readwrite,assign) int highestLevel, highestWorld, currentWorld;

+(UserData *) sharedData;
-(void)saveAllDataToUserDefaults;

@end
