//
//  StackObject.h
//  AngryPanda

/*
 
 该类将用于创建及并管理游戏中的遮挡物
 该类将在ShootingTargets类中创建，它继承自PhysicsNode
 在创建时，无需添加.png的文件后缀名
 无需在代码中为支持Retina添加-hd，也无需为在代码中为ipad版本添加-ipad
 
 
 */

#import "PhysicsNode.h"
#import "GameSounds.h"

@interface StackObject : PhysicsNode {
    
    b2World* theWorld;
    NSString* spriteImageName;
    NSString* baseImageName;
    CGPoint initialLocation;
    
    bool addedAnimatedBreakFrames;
    bool breakOnGroundContact;
    bool breakOnPandaContact;
    bool canDamageEnemy;
    bool isStatic;  //是否是静态物体
    float theDensity;
    unsigned char shapeCreationMethod;
    
    int angle;
    
    int currentFrame;
    int framesToAnimate;
    
    int  pointValue;
    
}


@property (nonatomic) bool isStatic;
@property (nonatomic) bool breakOnGroundContact;
@property (nonatomic) bool canDamageEnemy;

@property (nonatomic) int pointValue;
@property (nonatomic) int simpleScore;

+(id) objectWithWorld:(b2World*)world location:(CGPoint)location spriteFileName:(NSString*)spriteFileName breakOnGround:(BOOL)breakOnGround breakFromPanda:(BOOL)breakFromPanda hasAnimatedBreakFrames:(bool)hasAnimatedBreakFrames damageEnemy:(BOOL)damageEnemy density:(float)density createHow:(int)createHow angleChange:(int)angleChange makeImmovable:(bool)makeImmovable points:(int)points simpleScoreType:(int)simpleScoreType;

-(id) initWithWorld:(b2World*)world location:(CGPoint)location spriteFileName:(NSString*)spriteFileName breakOnGround:(BOOL)breakOnGround breakFromPanda:(BOOL)breakFromPanda hasAnimatedBreakFrames:(bool)hasAnimatedBreakFrames damageEnemy:(BOOL)damageEnemy density:(float)density createHow:(int)createHow angleChange:(int)angleChange makeImmovable:(bool)makeImmovable points:(int)points simpleScoreType:(int)simpleScoreType;
-(void) createObject;

-(void) startBreakAnimation:(ccTime) delta;
-(void) playBreakAnimationFromGroundContact;
-(void) playBreakAnimationFromPandaContact ;
-(void) makeUnScoreable;

@end

