//
//  FirePlatform.mm
//  Angryplatforms
//
//  Created by eseedo on 1/27/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "FirePlatform.h"


@implementation FirePlatform


//类方法

+(id)platformWithWorld:(b2World*)world location:(CGPoint)location spriteFileName:(NSString*)spriteFileName{
    
    return [[[self alloc] initWithWorld:world location:(CGPoint)location spriteFileName:(NSString*)spriteFileName] autorelease];
    
    
}

//使用精灵帧图片来创建Box2D世界中的平台物体

-(id) initWithWorld:(b2World*)world location:(CGPoint)location spriteFileName:(NSString*)spriteFileName {
    
    if ((self = [super init]))
    {
        theWorld = world;
        initialLocation = location;
        spriteImageName = spriteFileName;
        
        
        [self createPlatform];
        
    }
    return self;
}

//创建平台物体的具体实现方法
-(void) createPlatform {
    
    // 创建物体定义
	b2BodyDef bodyDef;
	bodyDef.type = b2_staticBody;
    
	bodyDef.position.Set(initialLocation.x/PTM_RATIO, initialLocation.y/PTM_RATIO);
    
    b2PolygonShape shape;
    
	
    int num = 4;
    b2Vec2 vertices[] = {
        b2Vec2(-102.0f / PTM_RATIO, -49.5f / PTM_RATIO),
        b2Vec2(-113.0f / PTM_RATIO, -81.5f / PTM_RATIO),
        b2Vec2(113.0f / PTM_RATIO, -84.5f / PTM_RATIO),
        b2Vec2(106.0f / PTM_RATIO, -47.5f / PTM_RATIO)
    };
    
    shape.Set(vertices, num);
    
	
	// 创建物体夹具定义
	b2FixtureDef fixtureDef;
	fixtureDef.shape = &shape;
	fixtureDef.density = 1.0f;
	fixtureDef.friction = 0.3f;
    fixtureDef.restitution =  0.1;
    
    [super createBodyWithSpriteAndFixture:theWorld bodyDef:&bodyDef fixtureDef:&fixtureDef spriteName:spriteImageName];
    
    
}

@end
