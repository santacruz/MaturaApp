//
//  Scores.h
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
	CCLabelBMFont *accLabel;
}

@property(readwrite,assign) float accelX, accelY, accelZ;
@property(nonatomic,assign) CCLabelBMFont *accLabel;

+(id) scene;
-(void)calibrate:(CCMenuItem *) menuItem;
-(void)resetCalibration:(CCMenuItem *) menuItem;
-(void)back:(CCMenuItem *) menuItem;
-(void)toggleVibration:(CCMenuItem *)menuItem;

@end
