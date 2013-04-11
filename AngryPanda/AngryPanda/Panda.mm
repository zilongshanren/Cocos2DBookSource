//
//  Panda.mm
//  AngryPanda
//


#import "Panda.h"


@implementation Panda

@synthesize onGround;


+(id)pandaWithWorld:(b2World*)world location:(CGPoint)p baseFileName:(NSString*)name{
    
    return [[[self alloc] initWithWorld:world location:(CGPoint)p baseFileName:(NSString*)name] autorelease];
    
    
}

//在Box2D世界中创建并初始化熊猫

-(id) initWithWorld:(b2World*)world location:(CGPoint)p baseFileName:(NSString*)name {
    
    if ((self = [super init]))
    {
        theWorld = world;
        initialLocation = p;
        baseImageName = name;
        
        
        [self createPanda ];
        
    }
    return self;
}

//创建熊猫物体的具体实现方法

-(void) createPanda {
    
    
    spriteImageName = [NSString stringWithFormat:@"%@_standing.png", baseImageName];
    
    
    onGround = NO;
    
    // 创建物体定义
	b2BodyDef bodyDef;
	bodyDef.type = b2_staticBody;
	bodyDef.position.Set(initialLocation.x/PTM_RATIO, initialLocation.y/PTM_RATIO);
    
    b2CircleShape shape;
	float radiusInMeters = (40 / PTM_RATIO) * 0.5f; 
    
	shape.m_radius = radiusInMeters;
    
	
	// 创建物体夹具
	b2FixtureDef fixtureDef;
	fixtureDef.shape = &shape;
	fixtureDef.density = 1.0f;
	fixtureDef.friction = 1.0f;
    fixtureDef.restitution =  0.1;
    
    [super createBodyWithSpriteAndFixture:theWorld bodyDef:&bodyDef fixtureDef:&fixtureDef spriteName:spriteImageName];
    
}


//释放内存

-(void) dealloc
{
    
	[super dealloc];
}

@end

