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

@synthesize highestLevel, highestWorld, currentWorld, accelCorrectionX, accelCorrectionY;

-(id)init {
	if (self = [super init]) {
		//PROPERTIES INITIALISIEREN
		highestLevel = 1;
		highestWorld = 0;
		currentWorld = 0;
		accelCorrectionX = 0;
		accelCorrectionY = 0;
		//ERSTER APPSTART: USERDEFAULTS MIT PROPERTIES FÜLLEN
		NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
		if([defaults objectForKey:@"highestLevel"] == nil) {
			[defaults setValue:[NSNumber numberWithInt:highestLevel] forKey:@"highestLevel"];
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
		//FÜR JEDEN WEITEREN APPSTART: PROPERTIES AUS NSUSERDEFAULTS LESEN
		if (defaults) {
			highestLevel = [[defaults objectForKey:@"highestLevel"] intValue];
			highestWorld = [[defaults objectForKey:@"highestWorld"] intValue];
			currentWorld = [[defaults objectForKey:@"currentWorld"] intValue];
			accelCorrectionX = [[defaults objectForKey:@"accelCorrectionX"] intValue];
			accelCorrectionY = [[defaults objectForKey:@"accelCorrectionY"] intValue];
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
		[defaults setValue:[NSNumber numberWithInt:highestWorld] forKey:@"highestWorld"];
		[defaults setValue:[NSNumber numberWithInt:currentWorld] forKey:@"currentWorld"];
		[defaults setValue:[NSNumber numberWithFloat:accelCorrectionX] forKey:@"accelCorrectionX"];
		[defaults setValue:[NSNumber numberWithFloat:accelCorrectionY] forKey:@"accelCorrectionY"];
		[defaults synchronize];
	}
	
}

-(void)dealloc {
	NSLog(@"Deallocating UserData singleton");
	//Release Properties
	[super dealloc];
}

@end