//
//  EnemySphere.h
//  MaturaApp
//  © Zeno Koller 2010

#import "cocos2d.h"
#import "SpaceManager.h"
#import "cpCCSprite.h"
#import "GameData.h"

//Diese Klasse stellt einen Feind dar.
@interface EnemySphere : CCNode {
	//Radius des Feindes:
	float radius;
	//Faktor fuer die Geschwindigkeit des Feindes:
	float speed;
	//Bild, das den Feind anzeigt:
	cpCCSprite *sprite;
	//aktuelle Geschwindigkeit und Richtung:
	CGPoint moveVector;
}

@property(nonatomic,retain)	cpCCSprite *sprite;
@property(readwrite,assign) float radius, speed;
@property(readwrite,assign) CGPoint moveVector;

//Fuegt einen Feind mit einer bestimmten Art, Groesse und Position hinzu, 
//der nach der entfernung automatisch aus dem Speicher geloescht wird
+(id) enemyWithMgr:(SpaceManager *)mgr kind:(int)kind level:(int)size position:(CGPoint)location;
//Initialisiert den Feind
-(id) initWithMgr:(SpaceManager *)mgr kind:(int)kind level:(int)size position:(CGPoint)location;
//Bewegungs-Loop fuer normale Feinde
-(void) move1:(ccTime)dt;
//Bewegungs-Loop fuer den Verfolger-Feind
-(void) move2:(ccTime)dt;
//Bewegungs-Loop fuer den Alleskönner-Feind
-(void) move3:(ccTime)dt;
//Spielt einen Zoom-Effekt ab
-(void)zoom;
@end