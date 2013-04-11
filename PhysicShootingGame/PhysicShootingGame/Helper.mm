//
//  Helper.m
//  PhysicShootingGame
//
//  Created by guanghui on 8/4/12.
//
//

#import "Helper.h"

@implementation Helper

+(b2Vec2) metersFromPoint:(CGPoint)pt{
    return b2Vec2(pt.x / PTM_RATIO, pt.y / PTM_RATIO);
}

+(CGPoint) pointFromMeters:(b2Vec2)pt{
    return CGPointMake(pt.x * PTM_RATIO, pt.y * PTM_RATIO);
}
@end
