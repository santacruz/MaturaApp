//
//  LevelParser.m
//  MaturaApp
//  © Zeno Koller 2010

#import "LevelParser.h"


@implementation LevelParser

+(id)parseLevel {
	return [[self alloc] init];
}

-(void) init {
	if ((self=[super init])) {
		//Pfad für XML Datei bekommen
		NSString *pfad = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"level1.xml"];
		//Daten aus XML lesen
		NSData *data = [[NSData alloc] initWithContentsOfFile:path]; 
		//Parser initialisieren
		NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
		//Parser-Delegate setzen
		[parser setDelegate:self];
		BOOL success = [parser parse];
		if (!success) {
			NSLog(@"Parser Error, bitte Leveldatei überprüfen");
		}
		[parser release];
		return self;
	}
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
	attributes:(NSDictionary *)attributeDict {
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName {   
}

- (void) dealloc {
	[super dealloc];
}


@end
