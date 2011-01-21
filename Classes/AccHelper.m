//
//  AccHelper.m
//  MaturaApp
//  © Zeno Koller 2011
//
//	Diese Klasse erledigt Vektorgeometrie.

#import "AccHelper.h"


@implementation AccHelper

-(id) init {
	if (self = [super init]) {
	}
	return self;
}

-(float)dotVec1:(NSArray *)vec1 Vec2:(NSArray *) vec2 {
	float a = (float)([[vec1 objectAtIndex:0] floatValue] * [[vec2 objectAtIndex:0] floatValue]);
	float b = (float)([[vec1 objectAtIndex:1] floatValue] * [[vec2 objectAtIndex:1] floatValue]);
	float c = (float)([[vec1 objectAtIndex:2] floatValue] * [[vec2 objectAtIndex:2] floatValue]);
	float result = (float) (a+b+c);
	
	return result;
}

-(NSArray *)crossVec1:(NSArray *)vec1 Vec2:(NSArray *) vec2 {
	float x = (float)([[vec1 objectAtIndex:1] floatValue]*[[vec2 objectAtIndex:2] floatValue]-[[vec1 objectAtIndex:2] floatValue]*[[vec2 objectAtIndex:1] floatValue]);
	float y = (float)([[vec1 objectAtIndex:2] floatValue]*[[vec2 objectAtIndex:0] floatValue]-[[vec1 objectAtIndex:0] floatValue]*[[vec2 objectAtIndex:2] floatValue]);
	float z = (float)([[vec1 objectAtIndex:0] floatValue]*[[vec2 objectAtIndex:1] floatValue]-[[vec1 objectAtIndex:1] floatValue]*[[vec2 objectAtIndex:0] floatValue]);
		
	NSArray *result = [NSArray arrayWithObjects:[NSNumber numberWithFloat:x],[NSNumber numberWithFloat:y],[NSNumber numberWithFloat:z],nil];
	
	return result;
}

-(int)sign:(float)number {
	if (number > 0) return 1;
	return -1;
}

@end
