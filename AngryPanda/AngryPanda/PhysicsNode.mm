//
//  PhysicsNode.mm
//  AngryPanda
//
//  Created by eseedo on 3/3/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//

#import "PhysicsNode.h"


@implementation PhysicsNode

@synthesize body, sprite;

//使用精灵帧图片来创建物体

-(void) createBodyWithSpriteAndFixture:(b2World*)world bodyDef:(b2BodyDef*)bodyDef fixtureDef:(b2FixtureDef*)fixtureDef spriteName:(NSString*)spriteName {
    
    // this is the meat of our class, it creates (OR recreates) the body in the world with the body definition, fixture definition and sprite name
    
    [self removeBody]; //if remove the body if it already exists
    [self removeSprite]; //if remove the sprite if it already exists
    
    sprite = [CCSprite spriteWithFile:spriteName];
    [self addChild:sprite];
    
    body = world->CreateBody(bodyDef);
    body->SetUserData(self);
    
    if ( fixtureDef != NULL)
    {
        
        body->CreateFixture(fixtureDef);
        
    }
    
}

//将物体类型设置为静态物体

-(void) makeBodyStatic {
    
    body->SetType(b2_staticBody);
    
    
}

//将物体类型设置为动态物体

-(void)makeBodyDynamic{
    
    body->SetType(b2_dynamicBody);
}


//执行序列动作，让精灵和物体淡出并消失
-(void) fadeThenRemove
{
    
    CCSequence *seq = [CCSequence actions:
                       [CCFadeTo actionWithDuration:1.0f opacity:0],
                       [CCCallFunc actionWithTarget:self selector:@selector(removeSpriteAndBody)], nil];
    [[self sprite] runAction:seq];
}


//从Box2D世界中删除物体
-(void) removeBody {
    
    if( body != NULL)
    {
        body->GetWorld()->DestroyBody(body);
        body = NULL;
        
    }
    
}
//从Cocos2D中删除精灵

-(void) removeSprite  {
    
    if (sprite != nil) {
        
        [self removeAllChildrenWithCleanup:YES];
        sprite = nil;
        
    }
    
}

//删除物体和精灵
-(void) removeSpriteAndBody  {
    
    if (sprite != nil) {
        
        [self removeAllChildrenWithCleanup:YES];
        sprite = nil;
        
    }
    if( body != NULL)
    {
        body->GetWorld()->DestroyBody(body);
        body = NULL;
        
    }
    
}

//释放内存

-(void) dealloc
{
    [self removeBody];
    [self removeSprite];
    
    [super dealloc];
    
}



@end
