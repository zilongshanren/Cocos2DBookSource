//
//  ShapeCache.mm
//  TurtlePower
//
//  Created by Andreas Löw on 19.07.10.
//  Copyright 2010 code-and-web. All rights reserved.
//

#import "ShapeCache.h"
#import "CCFileUtils.h"

#define PTM_RATIO 100.0

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


@implementation ShapeCache

+ (ShapeCache *)sharedShapeCache
{
    static ShapeCache *shapeCache = 0;
    if(!shapeCache)
    {
        shapeCache = [[ShapeCache alloc] init];
    }
    return shapeCache;
}

-(id) init
{
    self = [super init];
    if(self)
    {
        shapeObjects = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(void) dealloc
{
    [shapeObjects release];
    [super dealloc];
}

-(void) addFixturesToBody:(b2Body*)body forShapeName:(NSString*)shape userdataCallBack:(id<ShapeCacheUserdataCallBack>)userdataCallBack scale:(float)scale
{
    BodyDef *so = [shapeObjects objectForKey:shape];
    assert(so);
       
    FixtureDef *fix = so->fixtures;
    while(fix)
    {        
        // Make a copy of the shape and scale it
        b2PolygonShape *shape = (b2PolygonShape *) fix->fixture.shape;                
        b2PolygonShape shapeCopy;
        shapeCopy.Set(shape->m_vertices, shape->m_vertexCount);
        for(int i = 0; i < shapeCopy.m_vertexCount; ++i) {
            shapeCopy.m_vertices[i] *= scale;
        }
        b2FixtureDef fdCopy = fix->fixture;
        fdCopy.shape = &shapeCopy;
        
        //b2Fixture *f = body->CreateFixture(&fix->fixture);
        b2Fixture *f = body->CreateFixture(&fdCopy);

        // use the delegate to get user data value
        if(fix->callbackData && userdataCallBack)
        {
            f->SetUserData([userdataCallBack shapeCacheFixtureUserdataForValue:fix->callbackData]);
        }
        
        fix = fix->next;
    }
}

-(void) addFixturesToBody:(b2Body*)body forShapeName:(NSString*)shape scale:(float)scale
{
    [self addFixturesToBody:body forShapeName:shape userdataCallBack:0 scale:scale];
}

-(CGPoint) anchorPointForShape:(NSString*)shape
{
    BodyDef *bd = [shapeObjects objectForKey:shape];
    assert(bd);
    return bd->anchorPoint;
}


-(void) addShapesWithDictionary:(NSDictionary*)dictionary
{
    NSDictionary *bodyDict = [dictionary objectForKey:@"bodies"];

    b2Vec2 vertices[b2_maxPolygonVertices];

    for(NSString *bodyName in bodyDict) 
    {
        // get the body data
        NSDictionary *bodyData = [bodyDict objectForKey:bodyName];

        // create body object
        BodyDef *bodyDef = [[[BodyDef alloc] init] autorelease];

        bodyDef->anchorPoint = CGPointFromString([bodyData objectForKey:@"anchorpoint"]);
        
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
            basicData.isSensor = [[fixtureData objectForKey:@"fixtureData"] boolValue];
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
                        CGPoint offset = CGPointFromString(pointString);
                        vertices[vindex].x = (offset.x / PTM_RATIO) / 2.0 ;  // sprites in editor are highres, points in cocos are lowres
                        vertices[vindex].y = (offset.y / PTM_RATIO) / 2.0 ;  // sprites in editor are highres, points in cocos are lowres
                        vindex++;
                    }
                    
                    polyshape->Set(vertices, vindex);
                    fix->fixture.shape = polyshape;
                    
                    // create a list
                    *nextFixtureDef = fix;
                    nextFixtureDef = &(fix->next);
                }
            }
            else
            {
                assert(0);
            }
        }
     
        // add the body element to the hash
        [shapeObjects setObject:bodyDef forKey:bodyName];
    }
}

-(void) addShapesWithFile:(NSString*)plist
{
	NSString *path = [CCFileUtils fullPathFromRelativePath:plist];
	NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    
	return [self addShapesWithDictionary:dict];
}

@end

