//
//  UserData.m
//  MaturaApp
//
//  Created by Zeno Koller on 10.11.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "UserData.h"

//SINGLETON RELATED
static UserData *sharedData = NULL;

@implementation UserData

@synthesize highestLevel, currentLevel, highestWorld, currentWorld, accelCorrectionX, accelCorrectionY, isVibrationDevice, isVibrationEnabled;

-(id)init {
	if (self = [super init]) {
		//PROPERTIES INITIALISIEREN
		highestLevel = 1;
		currentLevel = 1;
		highestWorld = 2;
		currentWorld = 0;
		accelCorrectionX = 0;
		accelCorrectionY = 0;
		if ([[UIDevice currentDevice].model isEqualToString:@"iPhone"]) {
			isVibrationDevice = YES;
		} else {
			isVibrationDevice = NO;
		}
		isVibrationEnabled = YES;
		//ERSTER APPSTART: USERDEFAULTS MIT PROPERTIES FÜLLEN
		NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
		if([defaults objectForKey:@"highestLevel"] == nil) {
			[defaults setValue:[NSNumber numberWithInt:highestLevel] forKey:@"highestLevel"];
		}
		if([defaults objectForKey:@"currentLevel"] == nil) {
			[defaults setValue:[NSNumber numberWithInt:currentLevel] forKey:@"currentLevel"];
		}
		if ([defaults objectForKey:@"highestWorld"] == nil) {
			[defaults setValue:[NSNumber numberWithInt:highestWorld] forKey:@"highestWorld"];
		}
		if ([defaults objectForKey:@"currentWorld"] == nil) {
			[defaults setValue:[NSNumber numberWithInt:currentWorld] forKey:@"currentWorld"];
		}
		if ([defaults objectForKey:@"accelCorrectionX"] == nil) {
			[defaults setValue:[NSNumber numberWithFloat:accelCorrectionX] forKey:@"accelCorrectionX"];
		}
		if ([defaults objectForKey:@"accelCorrectionY"] == nil) {
			[defaults setValue:[NSNumber numberWithFloat:accelCorrectionY] forKey:@"accelCorrectionY"];
		}
		if ([defaults objectForKey:@"isVibrationDevice"] == nil) {
			[defaults setValue:[NSNumber numberWithBool:isVibrationDevice] forKey:@"isVibrationDevice"];
		}		
		if ([defaults objectForKey:@"isVibrationEnabled"] == nil) {
			[defaults setValue:[NSNumber numberWithFloat:isVibrationEnabled] forKey:@"isVibrationEnabled"];
		}
		//FÜR JEDEN WEITEREN APPSTART: PROPERTIES AUS NSUSERDEFAULTS LESEN
		if (defaults) {
			highestLevel = [[defaults objectForKey:@"highestLevel"] intValue];
			currentLevel = [[defaults objectForKey:@"currentLevel"] intValue];
			highestWorld = [[defaults objectForKey:@"highestWorld"] intValue];
			currentWorld = [[defaults objectForKey:@"currentWorld"] intValue];
			accelCorrectionX = [[defaults objectForKey:@"accelCorrectionX"] intValue];
			accelCorrectionY = [[defaults objectForKey:@"accelCorrectionY"] intValue];
			isVibrationDevice = [[defaults objectForKey:@"isVibrationDevice"] boolValue];
			isVibrationEnabled = [[defaults objectForKey:@"isVibrationEnabled"] boolValue];
		}
		
	}
	return self;
}


+(UserData *)sharedData {
	@synchronized([UserData class]) 
	{
		if ( !sharedData || sharedData == NULL) {
			sharedData = [[UserData alloc] init];
		}
		return sharedData;
	}
}

-(void)saveAllDataToUserDefaults {
	NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
	if (defaults) {
		[defaults setValue:[NSNumber numberWithInt:highestLevel] forKey:@"highestLevel"];
		[defaults setValue:[NSNumber numberWithInt:currentLevel] forKey:@"currentLevel"];
		[defaults setValue:[NSNumber numberWithInt:highestWorld] forKey:@"highestWorld"];
		[defaults setValue:[NSNumber numberWithInt:currentWorld] forKey:@"currentWorld"];
		[defaults setValue:[NSNumber numberWithFloat:accelCorrectionX] forKey:@"accelCorrectionX"];
		[defaults setValue:[NSNumber numberWithFloat:accelCorrectionY] forKey:@"accelCorrectionY"];
		[defaults setValue:[NSNumber numberWithBool:isVibrationDevice] forKey:@"isVibrationDevice"];
		[defaults setValue:[NSNumber numberWithBool:isVibrationEnabled] forKey:@"isVibrationEnabled"];
		[defaults synchronize];
	}
	
}

-(void)dealloc {
	NSLog(@"Deallocating UserData singleton");
	//Release Properties
	[super dealloc];
}

@end
