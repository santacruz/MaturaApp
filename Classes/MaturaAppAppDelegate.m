//
//  MaturaAppAppDelegate.m
//  MaturaApp
//  © Zeno Koller 2010

#import "MaturaAppAppDelegate.h"
#import "cocos2d.h"
#import "HelloWorldScene.h"
#import "GameScene.h"

@implementation MaturaAppAppDelegate
@synthesize window;

- (void) applicationDidFinishLaunching:(UIApplication*)application
{
	// CC_DIRECTOR_INIT()
	//
	// 1. Initializes an EAGLView with 0-bit depth format, and RGB565 render buffer
	// 2. EAGLView multiple touches: disabled
	// 3. creates a UIWindow, and assign it to the "window" var (it must already be declared)
	// 4. Parents EAGLView to the newly created window
	// 5. Creates Display Link Director
	// 5a. If it fails, it will use an NSTimer director
	// 6. It will try to run at 60 FPS
	// 7. Display FPS: NO
	// 8. Device orientation: Portrait
	// 9. Connects the director to the EAGLView
	//
	CC_DIRECTOR_INIT();
	
	// Obtain the shared director in order to...
	CCDirector *director = [CCDirector sharedDirector];
		
	//GameData initialisieren
	GameData *levelData = [GameData sharedData];
	//UserData initialisieren
	UserData *userData = [UserData sharedData];
	
	//Temporärer Resolution-Fix 
	if( [[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
		[[CCDirector sharedDirector] setContentScaleFactor: [[UIScreen mainScreen] scale] ];
	}
	// Turn on display FPS
	[director setDisplayFPS:NO];
	
	// Turn on multiple touches
	EAGLView *view = [director openGLView];
	[view setMultipleTouchEnabled:YES];
	// Default texture format for PNG/BMP/TIFF/JPEG/GIF images
	// It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
	// You can change anytime.
	[CCTexture2D setDefaultAlphaPixelFormat:kTexture2DPixelFormat_RGBA8888];	
	
	
	[[CCDirector sharedDirector] runWithScene: [HelloWorld scene]];
}

- (void)applicationWillResignActive:(UIApplication *)application {
	NSLog(@"Application resigned Active");
	if ([GameData sharedData].isPlaying && [GameData sharedData].gameScene != NULL) {
		[[GameData sharedData].gameScene enterBackground];
	}
	[[CCDirector sharedDirector] pause];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	[[CCDirector sharedDirector] resume];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
	[[CCDirector sharedDirector] purgeCachedData];
}

-(void) applicationDidEnterBackground:(UIApplication*)application {
	NSLog(@"Application did enter Background");
	if ([GameData sharedData].isPlaying && [GameData sharedData].gameScene != NULL) {
		[[GameData sharedData].gameScene enterBackground];
	}	[[CCDirector sharedDirector] stopAnimation];
}

-(void) applicationWillEnterForeground:(UIApplication*)application {
	[[CCDirector sharedDirector] startAnimation];
}

- (void)applicationWillTerminate:(UIApplication *)application {
	[[CCDirector sharedDirector] end];
}

- (void)applicationSignificantTimeChange:(UIApplication *)application {
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}

- (void)dealloc {
	[[GameData sharedData] release];
	[[UserData sharedData] release];
	[[CCDirector sharedDirector] release];
	[window release];
	[super dealloc];
}

@end
