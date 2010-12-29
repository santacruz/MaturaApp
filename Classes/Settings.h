//
//  Settings.h
//  MaturaApp
//  © Zeno Koller 2010


#import "cocos2d.h"
#import "UserData.h"
#import "HelloWorldScene.h"

@interface Settings : CCLayer
{
	float accelX;
	float accelY;
	float accelZ;
	CCSprite *cross;
}

@property(readwrite,assign) float accelX, accelY, accelZ;
@property(nonatomic,assign) CCSprite *cross;

+(id) scene;
-(void)calibrate:(CCMenuItem *) menuItem;
-(void)resetCalibration:(CCMenuItem *) menuItem;
-(void)back:(CCMenuItem *) menuItem;
-(void)toggleVibration:(CCMenuItem *)menuItem;
-(BOOL)isCrossOutOfBoundsOfBox;

@end