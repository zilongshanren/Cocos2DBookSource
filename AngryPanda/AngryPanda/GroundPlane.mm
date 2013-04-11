//
//  GroundPlane.mm
//  AngryPanda
//
//  Created by eseedo on 1/27/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "GroundPlane.h"


@implementation GroundPlane

+(id) groundWithWorld:(b2World*)world location:(CGPoint)location spriteFileName:(NSString*)spriteFileName{
    
    return [[[self alloc] initWithWorld:world location:(CGPoint)location spriteFileName:(NSString*)spriteFileName] autorelease];
    
    
}

//在Box2D世界中使用精灵帧图片创建并初始化地平面

-(id) initWithWorld:(b2World*)world location:(CGPoint)location spriteFileName:(NSString*)spriteFileName {
    
    if ((self = [super init]))
    {
        theWorld = world;
        initialLocation = location;
        spriteImageName = spriteFileName;
        
        [self createGround];
        
    }
    return self;
}

//创建地平面物体的具体实现方法

-(void) createGround {
    
    // 创建物体定义
	b2BodyDef bodyDef;
	bodyDef.type = b2_staticBody;
    
	bodyDef.position.Set(initialLocation.x/PTM_RATIO, initialLocation.y/PTM_RATIO);
    
    b2PolygonShape shape;
	
    int num = 4;
    b2Vec2 vertices[] = {
        b2Vec2(-1220.0f / PTM_RATIO, 54.0f / PTM_RATIO),
        b2Vec2(-1220.0f / PTM_RATIO, -52.0f / PTM_RATIO),
        b2Vec2(1019.0f / PTM_RATIO, -52.0f / PTM_RATIO),
        b2Vec2(1019.0f / PTM_RATIO, 54.0f / PTM_RATIO)
    };
    
    shape.Set(vertices, num);
    
	
	// 创建物体夹具
	b2FixtureDef fixtureDef;
	fixtureDef.shape = &shape;
	fixtureDef.density = 1.0f;
	fixtureDef.friction = 1.0f;
    fixtureDef.restitution =  0.1;
    
    [super createBodyWithSpriteAndFixture:theWorld bodyDef:&bodyDef fixtureDef:&fixtureDef spriteName:spriteImageName];
    
    sprite.scaleX = 1.05;
    
    
}
@end
