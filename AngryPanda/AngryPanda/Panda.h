//
//  Panda.h
//  AngryPanda



/*
 
 该类将用于创建和管理游戏中的熊猫角色（玩家控制角色）
 该类将在ShootingTargets类中创建，它继承自PhysicsNode，其中所定义的几个实例方法分别用于在Box2D中创建熊猫。
 在创建时，无需添加.png的文件后缀名
 无需在代码中为支持Retina添加-hd，也无需为在代码中为ipad版本添加-ipad
 */




#import "PhysicsNode.h"

@interface Panda : PhysicsNode {
    
    b2World* theWorld;
    NSString* baseImageName;
    NSString* spriteImageName;
    CGPoint initialLocation;
    
    bool onGround;
    unsigned char counter;
    
}

@property (nonatomic) bool onGround;

+(id)   pandaWithWorld:(b2World*)world location:(CGPoint)p baseFileName:(NSString*)name;
-(id)   initWithWorld:(b2World*)world location:(CGPoint)p baseFileName:(NSString*)name;
-(void) createPanda;


@end
