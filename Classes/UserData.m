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

@synthesize highestLevel, currentLevel, highestWorld, currentWorld, isVibrationDevice, isVibrationEnabled;
@synthesize xGrund, yGrund;

-(id)init {
	if (self = [super init]) {
		//PROPERTIES INITIALISIEREN
		highestLevel = 1;
		currentLevel = 1;
		highestWorld = 0;
		currentWorld = 0;
		if ([[UIDevice currentDevice].model isEqualToString:@"iPhone"]) {
			isVibrationDevice = YES;
		} else {
			isVibrationDevice = NO;
		}
		isVibrationEnabled = YES;
		//ARRAYS
		xGrund = [NSArray arrayWithObjects:[NSNumber numberWithFloat:-1], [NSNumber numberWithFloat:0], [NSNumber numberWithFloat:0], nil];
		yGrund = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0], [NSNumber numberWithFloat:1], [NSNumber numberWithFloat:0], nil];

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
		if ([defaults objectForKey:@"isVibrationDevice"] == nil) {
			[defaults setValue:[NSNumber numberWithBool:isVibrationDevice] forKey:@"isVibrationDevice"];
		}		
		if ([defaults objectForKey:@"isVibrationEnabled"] == nil) {
			[defaults setValue:[NSNumber numberWithBool:isVibrationEnabled] forKey:@"isVibrationEnabled"];
		}
		if ([defaults objectForKey:@"xGrund"] == nil) {
			[defaults setValue:xGrund forKey:@"xGrund"];
		}
		if ([defaults objectForKey:@"yGrund"] == nil) {
			[defaults setValue:yGrund forKey:@"yGrund"];
		}
		//FÜR JEDEN WEITEREN APPSTART: PROPERTIES AUS NSUSERDEFAULTS LESEN
		if (defaults) {
			highestLevel = [[defaults objectForKey:@"highestLevel"] intValue];
			currentLevel = [[defaults objectForKey:@"currentLevel"] intValue];
			highestWorld = [[defaults objectForKey:@"highestWorld"] intValue];
			currentWorld = [[defaults objectForKey:@"currentWorld"] intValue];
			isVibrationDevice = [[defaults objectForKey:@"isVibrationDevice"] boolValue];
			isVibrationEnabled = [[defaults objectForKey:@"isVibrationEnabled"] boolValue];
			xGrund = [defaults objectForKey:@"xGrund"];
			yGrund = [defaults objectForKey:@"yGrund"];
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
		[defaults setValue:[NSNumber numberWithBool:isVibrationDevice] forKey:@"isVibrationDevice"];
		[defaults setValue:[NSNumber numberWithBool:isVibrationEnabled] forKey:@"isVibrationEnabled"];
		[defaults setValue:xGrund forKey:@"xGrund"];
		[defaults setValue:yGrund forKey:@"yGrund"];
		[defaults synchronize];
	}
	
}

-(void)dealloc {
	NSLog(@"Deallocating UserData singleton");
	//Release Properties
	[xGrund release];
	[yGrund release];
	[super dealloc];
}

@end