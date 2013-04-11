/*
 *  ContactListener.mm
 
 */

#import "ContactListener.h"


#import "Constants.h"
#import "MainScene.h"
#import "PhysicsNode.h"
#import "Panda.h"
#import "GroundPlane.h"
#import "FirePlatform.h"
#import "StackObject.h"
#import "Enemy.h"
#import "GameData.h"
#import "SimpleAudioEngine.h"


//碰撞检测和处理机制

void ContactListener::BeginContact(b2Contact* contact)
{
	b2Body* bodyA = contact->GetFixtureA()->GetBody();
	b2Body* bodyB = contact->GetFixtureB()->GetBody();
	PhysicsNode* physicsNodeA = (PhysicsNode*)bodyA->GetUserData();
	PhysicsNode* physicsNodeB = (PhysicsNode*)bodyB->GetUserData();
	
    
	//熊猫碰到地平面上
	
    if ([physicsNodeA isKindOfClass:[Panda class]] && [physicsNodeB isKindOfClass:[GroundPlane class]])
	{
		
        Panda* thePanda = (Panda*)physicsNodeA;
        
        [[MainScene sharedScene] stopDotting];
        [[MainScene sharedScene] showPandaOnGround:thePanda ];
        [[MainScene sharedScene] proceedToNextTurn:thePanda ];
        
        
	}
    else  if ([physicsNodeA isKindOfClass:[GroundPlane class]] && [physicsNodeB isKindOfClass:[Panda class]])
	{
		
        Panda* thePanda = (Panda*)physicsNodeB;
        
        [[MainScene sharedScene] stopDotting];
        [[MainScene sharedScene] showPandaOnGround:thePanda ];
        [[MainScene sharedScene] proceedToNextTurn:thePanda];
        
	}
    
    
    //熊猫碰到遮挡物上
    
    if ([physicsNodeA isKindOfClass:[Panda class]] && [physicsNodeB isKindOfClass:[StackObject class]])
	{
		
        if ([GameData sharedData].soundEffectMuted  == NO) {
            
            
            [[SimpleAudioEngine sharedEngine]playEffect:@"impact.mp3"];
            
        }
        
        Panda* thePanda = (Panda*)physicsNodeA;
        StackObject* theStackObject = (StackObject*)physicsNodeB;
        
        [[MainScene sharedScene] stopDotting];
        [[MainScene sharedScene] showPandaImpactingStack:thePanda ];
        
        [theStackObject playBreakAnimationFromPandaContact];
        
        if (theStackObject.pointValue != 0) { // 如果和熊猫碰撞时有得分
            
            [[MainScene sharedScene] showPoints:theStackObject.pointValue positionToShowScore:theStackObject.position theSimpleScore:theStackObject.simpleScore];  //显示分数
            [theStackObject makeUnScoreable]; //防止在同一物体上两次得分
        }
        
        
	}
    else  if ([physicsNodeA isKindOfClass:[StackObject class]] && [physicsNodeB isKindOfClass:[Panda class]])
	{
        
        if ([GameData sharedData].soundEffectMuted  == NO) {
            
            
            [[SimpleAudioEngine sharedEngine]playEffect:@"impact.mp3"];
            
        }
		
        Panda* thePanda = (Panda*)physicsNodeB;
        StackObject* theStackObject = (StackObject*)physicsNodeA;
        
        [[MainScene sharedScene] stopDotting];
        [[MainScene sharedScene] showPandaImpactingStack:thePanda ];
        
        [theStackObject playBreakAnimationFromPandaContact];
        
        if (theStackObject.pointValue != 0) { // 如果和熊猫碰撞时有得分
            [[MainScene sharedScene] showPoints:theStackObject.pointValue positionToShowScore:theStackObject.position  theSimpleScore:theStackObject.simpleScore]; //显示分数
            [theStackObject makeUnScoreable];  //防止在同一物体上两次得分
            
        }
        
	}
    
    
    //熊猫碰到外星怪物上
    
    if ([physicsNodeA isKindOfClass:[Panda class]] && [physicsNodeB isKindOfClass:[Enemy class]])
	{
		
        Panda* thePanda = (Panda*)physicsNodeA;
        Enemy* theEnemy = (Enemy*)physicsNodeB;
        
        [[MainScene sharedScene] stopDotting];
        [[MainScene sharedScene] showPandaImpactingStack:thePanda ];  //施加在遮挡物或外星怪物上
        
        
        
        if ( theEnemy.breakOnNextDamage == YES ) {
            
            if (theEnemy.pointValue != 0) { // 如果和熊猫碰撞时有得分
                
                [[MainScene sharedScene] showPoints:theEnemy.pointValue positionToShowScore:theEnemy.position  theSimpleScore:theEnemy.simpleScore]; //显示得分
                [theEnemy makeUnScoreable];  //防止在同一物体上两次得分
                
            }
            [theEnemy breakEnemy];
            
        } else {
            
            [theEnemy damageEnemy];
            
        }
        
        
        
        
        
	}
    else  if ([physicsNodeA isKindOfClass:[Enemy class]] && [physicsNodeB isKindOfClass:[Panda class]])
	{
		
        Panda* thePanda = (Panda*)physicsNodeB;
        Enemy* theEnemy = (Enemy*)physicsNodeA;
        
        [[MainScene sharedScene] stopDotting];
        [[MainScene sharedScene] showPandaImpactingStack:thePanda ]; //施加在遮挡物或外星怪物上
        
        
        if ( theEnemy.breakOnNextDamage == YES ) {
            
            if (theEnemy.pointValue != 0) { // 如果和熊猫碰撞时有得分
                
                [[MainScene sharedScene] showPoints:theEnemy.pointValue positionToShowScore:theEnemy.position  theSimpleScore:theEnemy.simpleScore]; //显示得分
                [theEnemy makeUnScoreable];  //防止在同一物体上两次得分
                
            }
            [theEnemy breakEnemy];
            
        } else {
            
            [theEnemy damageEnemy];
            
        }
        
	}
    
    
    //遮挡物碰到外星怪物上
    
    if ([physicsNodeA isKindOfClass:[StackObject class]] && [physicsNodeB isKindOfClass:[Enemy class]])
	{
		
        StackObject* theStackObject = (StackObject*)physicsNodeA;
        Enemy* theEnemy = (Enemy*)physicsNodeB;
        
        if (theStackObject.canDamageEnemy == YES && theEnemy.damageFromDamageEnabledStackObjects == YES ) {
            
            if ( theEnemy.breakOnNextDamage == YES ) {
                
                if (theEnemy.pointValue != 0) { // 如果和熊猫碰撞时有得分
                    
                    [[MainScene sharedScene] showPoints:theEnemy.pointValue positionToShowScore:theEnemy.position  theSimpleScore:theEnemy.simpleScore]; //显示得分
                    [theEnemy makeUnScoreable];  //防止在同一物体上两次得分
                    
                }
                [theEnemy breakEnemy];
                
            } else {
                
                [theEnemy damageEnemy];
                
            }
            
            
        }
        
        
	}
    else  if ([physicsNodeA isKindOfClass:[Enemy class]] && [physicsNodeB isKindOfClass:[StackObject class]])
	{
		
        StackObject* theStackObject = (StackObject*)physicsNodeB;
        Enemy* theEnemy = (Enemy*)physicsNodeA;
        
        if (theStackObject.canDamageEnemy == YES && theEnemy.damageFromDamageEnabledStackObjects == YES ) {
            
            if ( theEnemy.breakOnNextDamage == YES ) {
                
                if (theEnemy.pointValue != 0) { // 如果和熊猫碰撞时有得分
                    
                    [[MainScene sharedScene] showPoints:theEnemy.pointValue positionToShowScore:theEnemy.position  theSimpleScore:theEnemy.simpleScore]; //显示得分
                    [theEnemy makeUnScoreable];  //防止在同一物体上两次得分
                    
                }
                [theEnemy breakEnemy];
                
            } else {
                
                [theEnemy damageEnemy];
                
            }
            
            
        }
        
        
	}
    
    
    //外星怪物碰到地面上
    
    if ([physicsNodeA isKindOfClass:[GroundPlane class]] && [physicsNodeB isKindOfClass:[Enemy class]])
	{
		
        
        Enemy* theEnemy = (Enemy*)physicsNodeB;
        
        if ( theEnemy.damageFromGroundContact == YES ) {
            
            if ( theEnemy.breakOnNextDamage == YES ) {
                
                if (theEnemy.pointValue != 0) { // 如果和熊猫碰撞时有得分
                    
                    [[MainScene sharedScene] showPoints:theEnemy.pointValue positionToShowScore:theEnemy.position  theSimpleScore:theEnemy.simpleScore]; //显示得分
                    [theEnemy makeUnScoreable];  //防止在同一物体上两次得分
                    
                }
                [theEnemy breakEnemy];
                
            } else {
                
                [theEnemy damageEnemy];
                
            }
            
            
        }
        
        
	}
    else  if ([physicsNodeA isKindOfClass:[Enemy class]] && [physicsNodeB isKindOfClass:[GroundPlane class]])
	{
		
        
        Enemy* theEnemy = (Enemy*)physicsNodeA;
        
        if ( theEnemy.damageFromGroundContact == YES ) {
            
            if ( theEnemy.breakOnNextDamage == YES ) {
                
                if (theEnemy.pointValue != 0) { // 如果和熊猫碰撞时有得分
                    
                    [[MainScene sharedScene] showPoints:theEnemy.pointValue positionToShowScore:theEnemy.position  theSimpleScore:theEnemy.simpleScore]; //显示得分
                    [theEnemy makeUnScoreable];  //防止在同一物体上两次得分
                    
                }
                [theEnemy breakEnemy];
                
            } else {
                
                [theEnemy damageEnemy];
                
            }
            
            
        }
        
        
	}
    
    
    
    //遮挡物碰到地面上
    
    if ([physicsNodeA isKindOfClass:[GroundPlane class]] && [physicsNodeB isKindOfClass:[StackObject class]])
	{
		
        
        
        StackObject* theStackObject = (StackObject*)physicsNodeB;
        
        [theStackObject playBreakAnimationFromGroundContact];
        
        if (theStackObject.pointValue != 0 && theStackObject.breakOnGroundContact == YES) { // 如果和熊猫碰撞时有得分
            
            [[MainScene sharedScene] showPoints:theStackObject.pointValue positionToShowScore:theStackObject.position theSimpleScore:theStackObject.simpleScore];  //显示得分
            
            
            [theStackObject makeUnScoreable]; //防止在同一物体上两次得分
        }
        
        
	}
    else  if ([physicsNodeA isKindOfClass:[StackObject class]] && [physicsNodeB isKindOfClass:[GroundPlane class]])
	{
        
        
		
        StackObject* theStackObject = (StackObject*)physicsNodeA;
        
        [theStackObject playBreakAnimationFromGroundContact];
        
        if (theStackObject.pointValue != 0 && theStackObject.breakOnGroundContact == YES) { // 如果和熊猫碰撞时有得分
            
            [[MainScene sharedScene] showPoints:theStackObject.pointValue positionToShowScore:theStackObject.position theSimpleScore:theStackObject.simpleScore]; //显示得分
            [theStackObject makeUnScoreable];  //防止在同一物体上两次得分
            
        }
        
	}
    
}


//以下方法并未实现任何作用

void ContactListener::PreSolve(b2Contact* contact, const b2Manifold* oldManifold)
{
    
}

void ContactListener::PostSolve(b2Contact* contact, const b2ContactImpulse* impulse)
{
    
    
}

void ContactListener::EndContact(b2Contact* contact)
{
}
