//
//  Enemy.mm


#import "Enemy.h"


@implementation Enemy

@synthesize pointValue, simpleScore, breakOnNextDamage, damageFromGroundContact, damageFromDamageEnabledStackObjects,enemyLeft;

//类方法

+(id) enemyWithWorld:(b2World*)world location:(CGPoint)location spriteFileName:(NSString*)spriteFileName isTheRotationFixed:(bool)isTheRotationFixed getDamageFromGround:(BOOL)getDamageFromGround  doesGetDamageFromDamageEnabledStackObjects:(BOOL)doesGetDamageFromDamageEnabledStackObjects breaksFromHowMuchContact:(int)breaksFromHowMuchContact  hasDifferentSpritesForDamage:(bool)hasDifferentSpritesForDamage numberOfFramesToAnimateOnBreak:(int)numberOfFramesToAnimateOnBreak  density:(float)density createHow:(int)createHow  points:(int)points simpleScoreType:(int)simpleScoreType {
    
    
    return [[[self alloc] initWithWorld:(b2World*)world location:(CGPoint)location spriteFileName:(NSString*)spriteFileName isTheRotationFixed:(bool)isTheRotationFixed getDamageFromGround:(BOOL)getDamageFromGround  doesGetDamageFromDamageEnabledStackObjects:(BOOL)doesGetDamageFromDamageEnabledStackObjects breaksFromHowMuchContact:(int)breaksFromHowMuchContact  hasDifferentSpritesForDamage:(bool)hasDifferentSpritesForDamage numberOfFramesToAnimateOnBreak:(int)numberOfFramesToAnimateOnBreak  density:(float)density createHow:(int)createHow  points:(int)points simpleScoreType:(int)simpleScoreType] autorelease];
    
    
}

//用于在世界中创建并初始化外星怪物，同时指定多种属性
-(id) initWithWorld:(b2World*)world location:(CGPoint)location spriteFileName:(NSString*)spriteFileName isTheRotationFixed:(bool)isTheRotationFixed getDamageFromGround:(BOOL)getDamageFromGround  doesGetDamageFromDamageEnabledStackObjects:(BOOL)doesGetDamageFromDamageEnabledStackObjects breaksFromHowMuchContact:(int)breaksFromHowMuchContact  hasDifferentSpritesForDamage:(bool)hasDifferentSpritesForDamage numberOfFramesToAnimateOnBreak:(int)numberOfFramesToAnimateOnBreak  density:(float)density createHow:(int)createHow  points:(int)points simpleScoreType:(int)simpleScoreType {
    
    if ((self = [super init]))
    {
        theWorld = world;
        initialLocation = location;
        baseImageName = spriteFileName;
        spriteImageName =  [NSString stringWithFormat:@"%@.png", baseImageName];
        
        damageFromGroundContact = getDamageFromGround; // 从地面受到伤害
        
        damageLevel = 0; //初始值为0，如果breaksAfterHowMuchContact也等于0，则敌人在首次被碰后就会消失
        breakAfterHowMuchContact = breaksFromHowMuchContact; //在碰撞几次后分解
        differentSpritesForDamage = hasDifferentSpritesForDamage; //如果设置为YES，则会显示受伤害的动画帧
        
        currentFrame = 0;
        framesToAnimateOnBreak = numberOfFramesToAnimateOnBreak;  //要分解的动画帧
        
        
        theDensity = density;
        shapeCreationMethod = createHow;
        
        isRotationFixed = isTheRotationFixed;
        
        pointValue = points ;
        simpleScore = simpleScoreType;
        
        damageFromDamageEnabledStackObjects = doesGetDamageFromDamageEnabledStackObjects;
        
        
        if ( damageLevel == breakAfterHowMuchContact) {
            breakOnNextDamage = YES;
        } else {
            breakOnNextDamage = NO;
            
        }
        
        
        [self createEnemy];
        
        
        
    }
    return self;
    
}

//创建外星怪物的具体方法

-(void) createEnemy{
    
    
    // Define the dynamic body.
	b2BodyDef bodyDef;
	bodyDef.type = b2_dynamicBody; //or you could use b2_staticBody
    
    bodyDef.fixedRotation = isRotationFixed;
    
	bodyDef.position.Set(initialLocation.x/PTM_RATIO, initialLocation.y/PTM_RATIO);
    
    b2PolygonShape shape;
    b2CircleShape shapeCircle;
    
    if (shapeCreationMethod == useDiameterOfImageForCircle) {
        
        CCSprite* tempSprite = [CCSprite spriteWithFile:spriteImageName];
        float radiusInMeters = (tempSprite.contentSize.width / PTM_RATIO) * 0.5f;
        
        shapeCircle.m_radius = radiusInMeters;
        
    }
    
	
    else if ( shapeCreationMethod == useShapeOfSourceImage) {
        
        CCSprite* tempSprite = [CCSprite spriteWithFile:spriteImageName];
        
        int num = 4;
        b2Vec2 vertices[] = {
            b2Vec2( (tempSprite.contentSize.width / -2 ) / PTM_RATIO, (tempSprite.contentSize.height / 2 ) / PTM_RATIO), //top left corner
            b2Vec2( (tempSprite.contentSize.width / -2 ) / PTM_RATIO, (tempSprite.contentSize.height / -2 ) / PTM_RATIO), //bottom left corner
            b2Vec2( (tempSprite.contentSize.width / 2 ) / PTM_RATIO, (tempSprite.contentSize.height / -2 )/ PTM_RATIO), //bottom right corner
            b2Vec2( (tempSprite.contentSize.width / 2 ) / PTM_RATIO, (tempSprite.contentSize.height / 2 ) / PTM_RATIO) //top right corner
        };
        shape.Set(vertices, num);
    }
    
    else if ( shapeCreationMethod == useTriangle) {
        CCSprite* tempSprite = [CCSprite spriteWithFile:spriteImageName];
        
        int num = 3;
        b2Vec2 vertices[] = {
            b2Vec2((tempSprite.contentSize.width / -2 ) / PTM_RATIO, (tempSprite.contentSize.height / -2 ) / PTM_RATIO), //bottom left corner
            b2Vec2( (tempSprite.contentSize.width / 2 ) / PTM_RATIO, (tempSprite.contentSize.height / -2 ) / PTM_RATIO), //bottom right corner
            b2Vec2( 0.0f / PTM_RATIO, (tempSprite.contentSize.height / 2 )/ PTM_RATIO) // top center of image
        };
        
        shape.Set(vertices, num);
    }
    
    
    else if ( shapeCreationMethod == customCoordinates) {  //use your own custom coordinates from a program like Vertex Helper Pro
        
        int num = 4;
        b2Vec2 vertices[] = {
            b2Vec2(-64.0f / PTM_RATIO, 16.0f / PTM_RATIO),
            b2Vec2(-64.0f / PTM_RATIO, -16.0f / PTM_RATIO),
            b2Vec2(64.0f / PTM_RATIO, -16.0f / PTM_RATIO),
            b2Vec2(64.0f / PTM_RATIO, 16.0f / PTM_RATIO)
        };
        shape.Set(vertices, num);
    }
    
    
    
	
	// Define the dynamic body fixture.
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
    
    
    
}

//外星怪物受到伤害

-(void) damageEnemy {
    
    
    
    if ( enemyCannotBeDamagedForShortInterval == NO ) {
        
        damageLevel ++;
        enemyCannotBeDamagedForShortInterval = YES;
        [self performSelector:@selector(enemyCanBeDamagedAgain) withObject:nil afterDelay:1.0f];
        
        if ( differentSpritesForDamage == YES) {
            
            [sprite  setTexture:[[CCSprite spriteWithFile:[NSString stringWithFormat:@"%@_damage%i.png", baseImageName, damageLevel]] texture] ];
        }
        
        
        if ( damageLevel == breakAfterHowMuchContact ) {
            
            breakOnNextDamage = YES;
        }
        
    }
    
    
}

//判断外星怪物是否可再次受到伤害

-(void) enemyCanBeDamagedAgain {
    
    enemyCannotBeDamagedForShortInterval = NO;
}

//外星怪物分解
-(void) breakEnemy {
    
    [self schedule:@selector(startBreakAnimation:) interval:1.0f/30.0f];
    
    
}

//启动分解动画

-(void) startBreakAnimation:(ccTime) delta {
    
    
    
    if ( currentFrame == 0) {
        
        [self removeBody];
    }
    
    currentFrame ++; //当前帧加1
    
    if (currentFrame <= framesToAnimateOnBreak ) {  //如果已提供用于显示分解的动画帧，且当前帧数小雨要播放的帧数的最大值
        
        if (currentFrame < 10) {
            
            [sprite  setTexture:[[CCSprite spriteWithFile:[NSString stringWithFormat:@"%@_break000%i.png", baseImageName, currentFrame]] texture] ];
            
        } else if (currentFrame < 100) {
            
            [sprite setTexture:[[CCSprite spriteWithFile:[NSString stringWithFormat:@"%@_break00%i.png", baseImageName,  currentFrame]] texture] ];
            
        }
        
    }
    
    if (currentFrame > framesToAnimateOnBreak ) {
        
        //如果currentFrame和要演示的动画帧数相同，则删除精灵
        
        [self removeSprite];
        [self unschedule:_cmd];
        
    }
    
    
    
}



//设置不可获得分数

-(void) makeUnScoreable {
    
    pointValue = 0;
    
}



@end
