//
//  Enemy.h


/*
 
 顾名思义，该类将用于创建和管理游戏中的敌人角色
 该类将在ShootingTargets类中创建，它继承自PhysicsNode

 在创建时，无需添加.png的文件后缀名
 无需在代码中为支持Retina添加-hd，也无需为在代码中为ipad版本添加-ipad
 
 */



#import "PhysicsNode.h"
#import "GameSounds.h"


@interface Enemy : PhysicsNode {
    
    b2World* theWorld;
    NSString* spriteImageName;
    NSString* baseImageName;
    CGPoint initialLocation;
    
    
    int breakAfterHowMuchContact; //如果为0，则在首次接触后将敌人分解
    int damageLevel; //记录已完成的伤害程度
    bool breakOnNextDamage;
    
    bool isRotationFixed; //如果设置为YES，则外星怪物不会旋转
    
    float theDensity;
    unsigned char shapeCreationMethod; //和所有遮挡物体相同， 在Constants.h中检查形状定义
    
    bool damageFromGroundContact;
    bool damageFromDamageEnabledStackObjects;  //遮挡物被启用可以伤害敌人
    bool differentSpritesForDamage; //是否已在伤害过程中包含不同的图片
    
    
    int pointValue;
    int simpleScore;  //在constants中定义，当敌人分解时使用何种视觉效果
    
    int currentFrame;
    int framesToAnimateOnBreak; //如果设置为0，则不显示任何分解动画帧
    
    bool enemyCannotBeDamagedForShortInterval; // 在伤害发生后，外星怪物会获得一定时间的“无敌”状态
    
    int enemyLeft;
    
}

@property (nonatomic) bool damageFromGroundContact;
@property (nonatomic) bool damageFromDamageEnabledStackObjects;

@property (nonatomic) bool breakOnNextDamage;
@property (nonatomic) int pointValue;
@property (nonatomic) int simpleScore,enemyLeft;


+(id) enemyWithWorld:(b2World*)world location:(CGPoint)location spriteFileName:(NSString*)spriteFileName isTheRotationFixed:(bool)isTheRotationFixed getDamageFromGround:(BOOL)getDamageFromGround  doesGetDamageFromDamageEnabledStackObjects:(BOOL)doesGetDamageFromDamageEnabledStackObjects breaksFromHowMuchContact:(int)breaksFromHowMuchContact  hasDifferentSpritesForDamage:(bool)hasDifferentSpritesForDamage numberOfFramesToAnimateOnBreak:(int)numberOfFramesToAnimateOnBreak  density:(float)density createHow:(int)createHow  points:(int)points simpleScoreType:(int)simpleScoreType;

-(id) initWithWorld:(b2World*)world location:(CGPoint)location spriteFileName:(NSString*)spriteFileName isTheRotationFixed:(bool)isTheRotationFixed getDamageFromGround:(BOOL)getDamageFromGround  doesGetDamageFromDamageEnabledStackObjects:(BOOL)doesGetDamageFromDamageEnabledStackObjects breaksFromHowMuchContact:(int)breaksFromHowMuchContact  hasDifferentSpritesForDamage:(bool)hasDifferentSpritesForDamage numberOfFramesToAnimateOnBreak:(int)numberOfFramesToAnimateOnBreak  density:(float)density createHow:(int)createHow  points:(int)points simpleScoreType:(int)simpleScoreType;

-(void) createEnemy;
-(void) damageEnemy;
-(void) breakEnemy;
-(void) makeUnScoreable;



@end
