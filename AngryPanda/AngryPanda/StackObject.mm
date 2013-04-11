//
//  StackObject.mm
//  AngryPanda
//
//  Created by eseedo on 1/27/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "StackObject.h"


@implementation StackObject

@synthesize breakOnGroundContact, canDamageEnemy, pointValue, simpleScore, isStatic;

//类方法
+(id) objectWithWorld:(b2World*)world location:(CGPoint)location spriteFileName:(NSString*)spriteFileName breakOnGround:(BOOL)breakOnGround breakFromPanda:(BOOL)breakFromPanda hasAnimatedBreakFrames:(bool)hasAnimatedBreakFrames damageEnemy:(BOOL)damageEnemy density:(float)density createHow:(int)createHow angleChange:(int)angleChange makeImmovable:(bool)makeImmovable points:(int)points simpleScoreType:(int)simpleScoreType{
    
    return [[[self alloc] initWithWorld:(b2World*)world location:(CGPoint)location spriteFileName:(NSString*)spriteFileName breakOnGround:(BOOL)breakOnGround breakFromPanda:(BOOL)breakFromPanda hasAnimatedBreakFrames:(bool)hasAnimatedBreakFrames damageEnemy:(BOOL)damageEnemy density:(float)density createHow:(int)createHow angleChange:(int)angleChange makeImmovable:(bool)makeImmovable points:(int)points simpleScoreType:(int)simpleScoreType] autorelease];
    
    
}

//创建并初始化遮挡物，并设置相关属性
-(id) initWithWorld:(b2World*)world location:(CGPoint)location spriteFileName:(NSString*)spriteFileName breakOnGround:(BOOL)breakOnGround breakFromPanda:(BOOL)breakFromPanda hasAnimatedBreakFrames:(bool)hasAnimatedBreakFrames damageEnemy:(BOOL)damageEnemy density:(float)density createHow:(int)createHow angleChange:(int)angleChange makeImmovable:(bool)makeImmovable points:(int)points simpleScoreType:(int)simpleScoreType{
    
    if ((self = [super init]))
    {
        theWorld = world;
        initialLocation = location;
        baseImageName = spriteFileName;
        spriteImageName =  [NSString stringWithFormat:@"%@.png", baseImageName];
        
        breakOnGroundContact = breakOnGround;
        breakOnPandaContact = breakFromPanda;
        addedAnimatedBreakFrames = hasAnimatedBreakFrames;
        canDamageEnemy = damageEnemy;
        theDensity = density;
        shapeCreationMethod = createHow;
        angle = angleChange;
        isStatic = makeImmovable;
        
        currentFrame = 0;
        framesToAnimate = 10;
        
        pointValue = points ;
        simpleScoreType = simpleScoreType;
        
        [self createObject];
        
    }
    return self;
}

//创建物体的具体实现方法

-(void) createObject {
    
    
    // 创建物体定义
	b2BodyDef bodyDef;
	bodyDef.type = b2_dynamicBody;
    
	bodyDef.position.Set(initialLocation.x/PTM_RATIO, initialLocation.y/PTM_RATIO);
    
    b2PolygonShape shape;
    b2CircleShape shapeCircle;
    
    
    //根据不同的形状类型来设置物体形状
    
    if (shapeCreationMethod == useDiameterOfImageForCircle) {
        
        CCSprite* tempSprite = [CCSprite spriteWithFile:spriteImageName];
        float radiusInMeters = (tempSprite.contentSize.width / PTM_RATIO) * 0.5f;
        
        shapeCircle.m_radius = radiusInMeters;
        
    }
    
	
    else if ( shapeCreationMethod == useShapeOfSourceImage) {
        
        CCSprite* tempSprite = [CCSprite spriteWithFile:spriteImageName];
        
        int num = 4;
        b2Vec2 vertices[] = {
            b2Vec2( (tempSprite.contentSize.width / -2 ) / PTM_RATIO, (tempSprite.contentSize.height / 2 ) / PTM_RATIO), //左上角
            b2Vec2( (tempSprite.contentSize.width / -2 ) / PTM_RATIO, (tempSprite.contentSize.height / -2 ) / PTM_RATIO), //左下角
            b2Vec2( (tempSprite.contentSize.width / 2 ) / PTM_RATIO, (tempSprite.contentSize.height / -2 )/ PTM_RATIO), //右下角
            b2Vec2( (tempSprite.contentSize.width / 2 ) / PTM_RATIO, (tempSprite.contentSize.height / 2 ) / PTM_RATIO)  //右上角
        };
        shape.Set(vertices, num);
    }
    
    else if ( shapeCreationMethod == useTriangle) {
        CCSprite* tempSprite = [CCSprite spriteWithFile:spriteImageName];
        
        int num = 3;
        b2Vec2 vertices[] = {
            b2Vec2((tempSprite.contentSize.width / -2 ) / PTM_RATIO, (tempSprite.contentSize.height / -2 ) / PTM_RATIO), //左下角
            b2Vec2( (tempSprite.contentSize.width / 2 ) / PTM_RATIO, (tempSprite.contentSize.height / -2 ) / PTM_RATIO), //右上角
            b2Vec2( 0.0f / PTM_RATIO, (tempSprite.contentSize.height / 2 )/ PTM_RATIO) // 图片上中部
        };
        
        shape.Set(vertices, num);
    }
    
    else if ( shapeCreationMethod == customCoordinates) {  //可以使用类似Vertex Helper Pro等软件来创建定制的顶点坐标
        
        int num = 4;
        b2Vec2 vertices[] = {
            b2Vec2(-64.0f / PTM_RATIO, 16.0f / PTM_RATIO),
            b2Vec2(-64.0f / PTM_RATIO, -16.0f / PTM_RATIO),
            b2Vec2(64.0f / PTM_RATIO, -16.0f / PTM_RATIO),
            b2Vec2(64.0f / PTM_RATIO, 16.0f / PTM_RATIO)
        };
        shape.Set(vertices, num);
    }
	
	//创建物体夹具定义
	b2FixtureDef fixtureDef;
    
    if ( shapeCreationMethod == useDiameterOfImageForCircle) {
        
        fixtureDef.shape = &shapeCircle;
        
    } else {
        fixtureDef.shape = &shape;
        
    }
	
	fixtureDef.density = theDensity;
	fixtureDef.friction = 0.3f;
    fixtureDef.restitution =  0.1;
    
    [super createBodyWithSpriteAndFixture:theWorld bodyDef:&bodyDef fixtureDef:&fixtureDef spriteName:spriteImageName];
    
    
    if ( angle != 0 ) {
        
        int currentAngle = body->GetAngle() ;
        b2Vec2 locationInMeters = body->GetPosition();
        body->SetTransform( locationInMeters , CC_DEGREES_TO_RADIANS( currentAngle + angle  )  );
        
    }
    
    if (isStatic == YES ) {
        
        [self makeBodyStatic];
    }
}

//当遮挡物碰到熊猫时播放动画

-(void) playBreakAnimationFromPandaContact {
    
    if ( breakOnPandaContact == YES) {
        
        [self schedule:@selector(startBreakAnimation:) interval:1.0f/30.0f];
    }
    
    
}

//当遮挡物碰到地面时播放动画

-(void) playBreakAnimationFromGroundContact {
    
    if ( breakOnGroundContact == YES) {
        
        [self schedule:@selector(startBreakAnimation:) interval:1.0f/30.0f];
    }
    
}

//启动分解动画
-(void) startBreakAnimation:(ccTime) delta {
    
    if ( currentFrame == 0) {
        
        [self removeBody];
        
        
    }
    
    currentFrame ++; //当前帧加1
    
    if (currentFrame <= framesToAnimate && addedAnimatedBreakFrames == YES ) {  //如果提供了演示分解的动画帧，且当前帧小雨最大帧数。
        
        if (currentFrame < 10) {
            
            [sprite  setTexture:[[CCSprite spriteWithFile:[NSString stringWithFormat:@"%@_000%i.png", baseImageName, currentFrame]] texture] ];
            
        } else if (currentFrame < 100) {
            
            [sprite setTexture:[[CCSprite spriteWithFile:[NSString stringWithFormat:@"%@_00%i.png", baseImageName,  currentFrame]] texture] ];
            
        }
        
    }
    
    if (currentFrame > framesToAnimate || addedAnimatedBreakFrames == NO) {
        
        //如果currentFrame 等于要演示的动画帧数，就删除精灵，或是遮挡物不包含分解动画帧
        
        [self removeSprite];
        [self unschedule:_cmd];
        
    }
    
    
}

//设置碰到遮挡物时不会得分

-(void) makeUnScoreable {
    
    pointValue = 0;
}



@end
