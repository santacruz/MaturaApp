//
//  LevelChoice.m
//  MaturaApp
//
//  Created by Zeno Koller on 06.11.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LevelChoice.h"

@implementation LevelChoice

+(id) sceneWithWorld:(int)world
{
	CCScene *scene = [CCScene node];
	LevelChoice *layer = [[[LevelChoice alloc] initWithWorld:world] autorelease];
	[scene addChild: layer];
	return scene;
}


//INITIALISIERE INSTANZ
-(id) initWithWorld:(int)world
{
	if( (self=[super init] )) {
		//BACKGROUND
		CCSprite *bg = [CCSprite spriteWithFile:@"BG/bg.png"];
		bg.position = ccp(160,240);
		[self addChild:bg];
		//TITLE
		CCSprite *title = [CCSprite spriteWithFile:@"Titles/level_title.png"];
		title.position = ccp(160,420);
		[self addChild:title];
		
		//BACK MENU
		CCSprite *backSprite = [CCSprite spriteWithFile:@"Buttons/backbutton.png"];
		CCSprite *backSpritePressed = [CCSprite spriteWithFile:@"Buttons/backbutton-pressed.png"];
		CCMenuItemSprite *menuItemBack = [CCMenuItemSprite itemFromNormalSprite:backSprite selectedSprite:backSpritePressed target:self selector:@selector(back:)];
		CCMenu *backMenu = [CCMenu menuWithItems:menuItemBack,nil];
		backMenu.position = ccp(160, 50);
		[self addChild:backMenu];
	}
	return self;
}

-(void)back:(CCMenuItem *)menuItem {
	[[CCDirector sharedDirector] replaceScene:
	 [CCTransitionCrossFade transitionWithDuration:0.2f scene:[WorldChoice scene]]];
}

@end
