//
//  LevelChoice.h
//  MaturaApp
//
//  Created by Zeno Koller on 06.11.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "WorldChoice.h"

@interface LevelChoice : CCLayer {
	CCMenu *menu;
	int count;
}

@property(nonatomic,assign)CCMenu *menu;
@property(readwrite,assign)int count;

+(id) sceneWithWorld:(int)world;
-(id) initWithWorld:(int)world;
-(void)back:(CCMenuItem *)menuItem;
-(void)selectedLevel:(id)sender;

@end
