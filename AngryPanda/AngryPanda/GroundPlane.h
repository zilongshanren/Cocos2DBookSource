//
//  GroundPlane.h
//  AngryPanda
/*
 
 用于创建游戏中的地平面物体
 
 和创建其它Box2D物体不同，GroundPlane在创建物体时需要使用完整的文件名，即添加.png后缀。
 在创建时，需要添加.png的文件后缀名
 无需在代码中为支持Retina添加-hd，也无需为在代码中为ipad版本添加-ipad
 
 
 */

#import "PhysicsNode.h"


@interface GroundPlane : PhysicsNode {
    
    b2World* theWorld;
    NSString* spriteImageName;
    CGPoint initialLocation;
    
}

+(id) groundWithWorld:(b2World*)world location:(CGPoint)location spriteFileName:(NSString*)spriteFileName;
-(id) initWithWorld:(b2World*)world location:(CGPoint)location spriteFileName:(NSString*)spriteFileName;
-(void) createGround;

@end
