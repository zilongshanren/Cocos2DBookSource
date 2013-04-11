//
//  GB2ShapeCache.h
//  
//  Loads physics sprites created with http://www.PhysicsEditor.de
//
//  Generic Shape Cache for box2d
//
//  Copyright by Andreas Loew 
//      http://www.PhysicsEditor.de
//      http://texturepacker.com
//      http://www.code-and-web.de
//  
//  All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//  
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "GB2ShapeCache.h"

#if defined(__IPHONE_OS_VERSION_MIN_REQUIRED)
#   define CGPointFromString_ CGPointFromString
#else
// well - not nice but works for now
static CGPoint CGPointFromString_(NSString* str)
{
    NSString* theString = str;
    theString = [theString stringByReplacingOccurrencesOfString:@"{ " withString:@""];
    theString = [theString stringByReplacingOccurrencesOfString:@" }" withString:@""];
    NSArray *array = [theString componentsSeparatedByString:@","];
    return CGPointMake([[array objectAtIndex:0] floatValue], [[array objectAtIndex:1] floatValue]);
}
#endif

/**
 * Internal class to hold the fixtures
 */
class FixtureDef 
{
public:
    FixtureDef()
    : next(0)
    {}
    
    ~FixtureDef()
    {
        delete next;
        delete fixture.shape;
    }
    
    FixtureDef *next;
    b2FixtureDef fixture;
    int callbackData;
};

/**
 * Body definition
 * Holds the body and the anchor point
 */
@interface BodyDef : NSObject
{
@public
    FixtureDef *fixtures;
    CGPoint anchorPoint;
}
@end


@implementation BodyDef

-(id) init
{
    self = [super init];
    if(self)
    {
        fixtures = 0;
    }
    return self;
}

-(void) dealloc
{
    delete fixtures;
    [super dealloc];
}

@end


@implementation GB2ShapeCache


+ (GB2ShapeCache *)sharedShapeCache
{
    static GB2ShapeCache *shapeCache = 0;
    if(!shapeCache)
    {
        shapeCache = [[GB2ShapeCache alloc] init];
    }
    return shapeCache;
}

-(id) init
{
    self = [super init];
    if(self)
    {
        shapeObjects_ = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(void) dealloc
{
    [shapeObjects_ release];
    [super dealloc];
}

-(void) addFixturesToBody:(b2Body*)body forShapeName:(NSString*)shape
{
    BodyDef *so = [shapeObjects_ objectForKey:shape];
    assert(so);
    
    FixtureDef *fix = so->fixtures;
    while(fix)
    {
        body->CreateFixture(&fix->fixture);
        fix = fix->next;
    }
}

-(CGPoint) anchorPointForShape:(NSString*)shape
{
    BodyDef *bd = [shapeObjects_ objectForKey:shape];
    assert(bd);
    return bd->anchorPoint;
}

-(void) addShapesWithFile:(NSString*)plist
{
    NSString *path = [[NSBundle mainBundle] pathForResource:plist
                                               ofType:nil
                                          inDirectory:nil];

	NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:path];

    NSDictionary *metadataDict = [dictionary objectForKey:@"metadata"];
    int format = [[metadataDict objectForKey:@"format"] intValue];
    ptmRatio_ =  [[metadataDict objectForKey:@"ptm_ratio"] floatValue];

    NSAssert(format == 1, @"Format not supported");
    
    NSDictionary *bodyDict = [dictionary objectForKey:@"bodies"];

    b2Vec2 vertices[b2_maxPolygonVertices];

    for(NSString *bodyName in bodyDict) 
    {
        // get the body data
        NSDictionary *bodyData = [bodyDict objectForKey:bodyName];

        // create body object
        BodyDef *bodyDef = [[[BodyDef alloc] init] autorelease];

        bodyDef->anchorPoint = CGPointFromString_([bodyData objectForKey:@"anchorpoint"]);
        
        // iterate through the fixtures
        NSArray *fixtureList = [bodyData objectForKey:@"fixtures"];
        FixtureDef **nextFixtureDef = &(bodyDef->fixtures);

        for(NSDictionary *fixtureData in fixtureList)
        {
            b2FixtureDef basicData;
            
            basicData.filter.categoryBits = [[fixtureData objectForKey:@"filter_categoryBits"] intValue];
            basicData.filter.maskBits = [[fixtureData objectForKey:@"filter_maskBits"] intValue];
            basicData.filter.groupIndex = [[fixtureData objectForKey:@"filter_groupIndex"] intValue];
            basicData.friction = [[fixtureData objectForKey:@"friction"] floatValue];
            basicData.density = [[fixtureData objectForKey:@"density"] floatValue];
            basicData.restitution = [[fixtureData objectForKey:@"restitution"] floatValue];
            basicData.isSensor = [[fixtureData objectForKey:@"isSensor"] boolValue];
            int callbackData = [[fixtureData objectForKey:@"userdataCbValue"] intValue];
            
            NSString *fixtureType = [fixtureData objectForKey:@"fixture_type"];

            // read polygon fixtures. One convave fixture may consist of several convex polygons
            if([fixtureType isEqual:@"POLYGON"])
            {
                NSArray *polygonsArray = [fixtureData objectForKey:@"polygons"];
                
                for(NSArray *polygonArray in polygonsArray)
                {
                    FixtureDef *fix = new FixtureDef();
                    fix->fixture = basicData; // copy basic data
                    fix->callbackData = callbackData;

                    b2PolygonShape *polyshape = new b2PolygonShape();
                    int vindex = 0;
                    
                    assert([polygonArray count] <= b2_maxPolygonVertices);
                    for(NSString *pointString in polygonArray)
                    {
                        CGPoint offset = CGPointFromString_(pointString);
                        vertices[vindex].x = (offset.x / ptmRatio_) ; 
                        vertices[vindex].y = (offset.y / ptmRatio_) ; 
                        vindex++;
                    }
                    
                    polyshape->Set(vertices, vindex);
                    fix->fixture.shape = polyshape;
                    
                    // create a list
                    *nextFixtureDef = fix;
                    nextFixtureDef = &(fix->next);
                }
            }
            else if([fixtureType isEqual:@"CIRCLE"])
            {
                FixtureDef *fix = new FixtureDef();
                fix->fixture = basicData; // copy basic data
                fix->callbackData = callbackData;
                
                NSDictionary *circleData = [fixtureData objectForKey:@"circle"];
                
                b2CircleShape *circleShape = new b2CircleShape();
                circleShape->m_radius = [[circleData objectForKey:@"radius"] floatValue]  / ptmRatio_;
                CGPoint p = CGPointFromString_([fixtureData objectForKey:@"position"]);
                circleShape->m_p = b2Vec2(p.x / ptmRatio_, p.y / ptmRatio_);
                fix->fixture.shape = circleShape;

                // create a list
                *nextFixtureDef = fix;
                nextFixtureDef = &(fix->next);
            }
            else
            {
                // unknown type
                assert(0);
            }
        }
     
        // add the body element to the hash
        [shapeObjects_ setObject:bodyDef forKey:bodyName];
    }
}

-(float) ptmRatio
{
    return ptmRatio_;
}


@end

