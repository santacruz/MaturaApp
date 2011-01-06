//
//  Settings.h
//  MaturaApp
//  © Zeno Koller 2010


#import "cocos2d.h"
#import "UserData.h"
#import "HelloWorldScene.h"
#import "AccHelper.h"

@interface Settings : CCLayer
{
	float accelX;
	float accelY;
	float accelZ;
	CCSprite *cross;
	AccHelper *accHelper;
}

@property(readwrite,assign) float accelX, accelY, accelZ;
@property(nonatomic,assign) CCSprite *cross;
@property(nonatomic,retain) AccHelper *accHelper;

+(id) scene;
-(void)calibrate:(CCMenuItem *) menuItem;
-(void)resetCalibration:(CCMenuItem *) menuItem;
-(void)back:(CCMenuItem *) menuItem;
-(void)toggleVibration:(CCMenuItem *)menuItem;
-(BOOL)isCrossOutOfBoundsOfBox;

@end