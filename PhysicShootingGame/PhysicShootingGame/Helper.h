//
//  Helper.h
//  PhysicShootingGame
//
//  Created by guanghui on 8/4/12.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d/cocos2d.h"
#import "Box2D/Box2D.h"
//Pixel to metres ratio. Box2D uses metres as the unit for measurement.
//This ratio defines how many pixels correspond to 1 Box2D "metre"
//Box2D is optimized for objects of 1x1 metre therefore it makes sense
//to define the ratio so that your most common object type is 1x1 metre.
#define PTM_RATIO 32.0

@interface Helper : NSObject


+(b2Vec2) metersFromPoint:(CGPoint)pt;
+(CGPoint) pointFromMeters:(b2Vec2)pt;
@end
