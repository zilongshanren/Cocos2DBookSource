//
//  PhysicsNode.h
//  AngryPanda
//
//  Created by eseedo on 1/27/12.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

/*
 该类直接继承自CCNode类，是CCNode类和b2Body类的拓展，其中的实例方法分别用于使用精灵帧来创建物体，删除物体，删除精灵，淡出并消失，让物体成为静态，删除精灵和物体。
 
 */

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"
#import "Constants.h"

@interface PhysicsNode : CCNode {
    
    b2Body* body;
    CCSprite* sprite;
    
}

@property (readonly, nonatomic) b2Body* body;
@property (readonly, nonatomic)  CCSprite* sprite;

-(void) createBodyWithSpriteAndFixture:(b2World*)world bodyDef:(b2BodyDef*)bodyDef fixtureDef:(b2FixtureDef*)fixtureDef spriteName:(NSString*)spriteName;

-(void) removeBody;
-(void) removeSprite;
-(void) removeSpriteAndBody;
-(void) fadeThenRemove;

-(void) makeBodyStatic;
-(void) makeBodyDynamic;



@end
