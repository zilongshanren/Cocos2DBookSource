//
//  FirePlatform.h
//  AngryPanda
//
/*
 
 该类用于创建抛投熊猫所使用的平台物体
 在创建时，需要添加.png的文件后缀名
 无需在代码中为支持Retina添加-hd，也无需为在代码中为ipad版本添加-ipad
 
 */

#import "PhysicsNode.h"

@interface FirePlatform : PhysicsNode {
    
    b2World* theWorld;
    NSString* spriteImageName;
    CGPoint initialLocation;
    
}

+(id) platformWithWorld:(b2World*)world location:(CGPoint)location spriteFileName:(NSString*)spriteFileName;
-(id) initWithWorld:(b2World*)world location:(CGPoint)location spriteFileName:(NSString*)spriteFileName;
-(void) createPlatform;

@end
