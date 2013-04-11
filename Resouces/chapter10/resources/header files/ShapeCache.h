//
//  ShapeCache.h
//  TurtlePower
//
//  Created by Andreas Löw on 19.07.10.
//  Copyright 2010 code-and-web. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Box2D.h>


@protocol ShapeCacheUserdataCallBack
-(void*) shapeCacheFixtureUserdataForValue:(int)value;
@end

@interface ShapeCache : NSObject 
{
    NSMutableDictionary *shapeObjects;
}

+ (ShapeCache *)sharedShapeCache;

-(void) addShapesWithFile:(NSString*)plist;
-(void) addFixturesToBody:(b2Body*)body forShapeName:(NSString*)shape scale:(float)scale;
-(void) addFixturesToBody:(b2Body*)body forShapeName:(NSString*)shape userdataCallBack:(id<ShapeCacheUserdataCallBack>)userdataCallBack scale:(float)scale;
-(CGPoint) anchorPointForShape:(NSString*)shape;
@end
