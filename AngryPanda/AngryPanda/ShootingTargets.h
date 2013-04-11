//
//  ShootingTargets.h

/*
 
 该类将用于在各关卡场景中创建遮挡物和敌人。
 游戏中的遮挡物和敌人都将使用该类创建
 该类是仅次于MainScene的类，因为游戏的关卡设计就在此进行。
 
 */



#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"

@interface ShootingTargets : CCNode {
    
    b2World* world;
    int currentLevelNumber;
    int currentChapterNumber;
    
    int stackLocationX;  //stack在x轴上的起始位置
    int stackLocationY; //stack在y轴上的起始位置
    
    int stackAdjustmentX;  //根据关卡来进行调整
    int stackAdjustmentY; //根据关卡来进行调整
    
    int enemyNumber;
    
}

+(id) setupStackWithWorld:(b2World*)theWorld;

@end
