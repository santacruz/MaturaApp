//
//  GameData.h
//  MaturaApp
//
//  Created by Zeno Koller on 07.09.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GameData : NSObject {
	CGPoint heroPrevPos;
	CGPoint heroPrevVelocity;
	int heroPrevSize;
	BOOL isThereAHero;
	NSMutableArray *enemySpawnBuffer;
	NSMutableArray *enemyArray; 
}

@property(readwrite,assign) CGPoint heroPrevPos, heroPrevVelocity;
@property(readwrite,assign) int heroPrevSize;
@property(readwrite,assign) BOOL isThereAHero;
@property(nonatomic,retain)NSMutableArray *enemySpawnBuffer, *enemyArray;

+(GameData *) sharedData;
@end