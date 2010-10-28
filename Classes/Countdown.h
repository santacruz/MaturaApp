//
//  Countdown.h
//  MaturaApp
//  © Zeno Koller 2010


#import "cocos2d.h"
#import "GameData.h"


@interface Countdown : CCColorLayer {
	int count;
	CCLabelBMFont* countLabel;
}

@property(readwrite,assign) int count;
@property(nonatomic,retain) CCLabelBMFont* countLabel;

+(id)scene;
-(void)endCountdown;
@end