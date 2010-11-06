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

}

+(id) sceneWithWorld:(int)world;
-(id) initWithWorld:(int)world;
-(void)back:(CCMenuItem *)menuItem;


@end
