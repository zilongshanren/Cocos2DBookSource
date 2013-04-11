//
//  CCTMXXMLParser+parser.h
//
//  Created by WB on 12/6/10.
//  Copyright 2010 WasabiBit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface CCTMXMapInfo (parser) 

-(void) parseXMLFile:(NSString *)xmlFilename;
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict;

@end
