//
//  Scores.h
//  MaturaApp
//  © Zeno Koller 2010


#import "cocos2d.h"
#import "GameData.h"
#import "HelloWorldScene.h"

@interface Settings : CCLayer
{
	float accelX;
	float accelY;
}

@property(readwrite,assign) float accelX, accelY;

+(id) scene;
-(void)calibrate:(CCMenuItem *) menuItem;
-(void)resetCalibration:(CCMenuItem *) menuItem;
-(void)back:(CCMenuItem *) menuItem;

@end
