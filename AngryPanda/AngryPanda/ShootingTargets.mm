//
//  ShootingTargets.mm
//  AngryPanda
//

#import "ShootingTargets.h"

#import "PhysicsNode.h"
#import "StackObject.h"
#import "Constants.h"
#import "GameData.h"
#import "Enemy.h"

//判断设备属于iPhone还是iPad
#define IS_IPHONE (!IS_IPAD)
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPhone)



@implementation ShootingTargets

//在世界中初始化遮挡物和外星怪物

-(id) initStackWithWorld:(b2World*)theWorld
{
	if ((self = [super init]))
	{
		// 到世界的弱引用
		world = theWorld;
		
		
        if (IS_IPAD) {
            stackLocationX = 1400;  //整个stack在iPad中x轴上的起始位置
            stackLocationY = 100; //整个stack在iPad中y轴上的起始位置
        } else if(IS_IPHONE){
            
            stackLocationX = 900;  //整个stack在iPhone中x轴上的起始位置
            stackLocationY = 35; //整个stack在iPhone中y轴上的起始位置
        }
        
        currentLevelNumber = [GameData sharedData].selectedLevel;
        
        currentChapterNumber = [GameData sharedData].selectedChapter;
        
        //根据大场景和关卡的不同来放置障碍物
        
        if(currentChapterNumber ==1){
        
        switch (currentLevelNumber) {
                
            case 1:
                [self createLevel1];
                break;
            case 2:
                [self createLevel2];
                break;
            case 3:
                [self createLevel2];
                break;
            case 4:
                [self createLevel2];
            case 5:
                [self createLevel2];
                break;
            case 6:
                [self createLevel2];
                break;
            case 7:
                [self createLevel2];
                break;
            case 8:
                [self createLevel2];
            case 9:
                [self createLevel2];
                break;
            case 10:
                [self createLevel2];
                break;

            default:
                [self createLevel1];
                break;
                
        }
        }else if(currentChapterNumber ==2){
            
            switch (currentLevelNumber) {
                    
                case 1:
                    [self createLevel1];
                    break;
                case 2:
                    [self createLevel2];
                    break;
                case 3:
                    [self createLevel2];
                    break;
                case 4:
                    [self createLevel2];
                case 5:
                    [self createLevel2];
                    break;
                case 6:
                    [self createLevel2];
                    break;
                case 7:
                    [self createLevel2];
                    break;
                case 8:
                    [self createLevel2];
                case 9:
                    [self createLevel2];
                    break;
                case 10:
                    [self createLevel2];
                    break;
                    
                default:
                    [self createLevel1];
                    break;
                    
            }
            
        }else if(currentChapterNumber ==3){
            
            switch (currentLevelNumber) {
                    
                case 1:
                    [self createLevel1];
                    break;
                case 2:
                    [self createLevel2];
                    break;
                case 3:
                    [self createLevel2];
                    break;
                case 4:
                    [self createLevel2];
                case 5:
                    [self createLevel2];
                    break;
                case 6:
                    [self createLevel2];
                    break;
                case 7:
                    [self createLevel2];
                    break;
                case 8:
                    [self createLevel2];
                case 9:
                    [self createLevel2];
                    break;
                case 10:
                    [self createLevel2];
                    break;
                    
                default:
                    [self createLevel1];
                    break;
                    
            }
            
        }else if(currentChapterNumber ==4){
            
            switch (currentLevelNumber) {
                    
                case 1:
                    [self createLevel1];
                    break;
                case 2:
                    [self createLevel2];
                    break;
                case 3:
                    [self createLevel2];
                    break;
                case 4:
                    [self createLevel2];
                case 5:
                    [self createLevel2];
                    break;
                case 6:
                    [self createLevel2];
                    break;
                case 7:
                    [self createLevel2];
                    break;
                case 8:
                    [self createLevel2];
                case 9:
                    [self createLevel2];
                    break;
                case 10:
                    [self createLevel2];
                    break;
                    
                default:
                    [self createLevel1];
                    break;
                    
            }
            
        }else if(currentChapterNumber ==5){
            
            switch (currentLevelNumber) {
                    
                case 1:
                    [self createLevel1];
                    break;
                case 2:
                    [self createLevel2];
                    break;
                case 3:
                    [self createLevel2];
                    break;
                case 4:
                    [self createLevel2];
                case 5:
                    [self createLevel2];
                    break;
                case 6:
                    [self createLevel2];
                    break;
                case 7:
                    [self createLevel2];
                    break;
                case 8:
                    [self createLevel2];
                case 9:
                    [self createLevel2];
                    break;
                case 10:
                    [self createLevel2];
                    break;
                    
                default:
                    [self createLevel1];
                    break;
                    
            }
            
        }
        
        
		
	}
	
	return self;
}

//类方法

+(id) setupStackWithWorld:(b2World*)theWorld
{
	return [[[self alloc] initStackWithWorld:theWorld] autorelease];
}



//创建关卡1

-(void) createLevel1 {
    
    if (IS_IPAD) {
        
        stackAdjustmentX = 0;
        stackLocationX = stackLocationX -  stackAdjustmentX;
        
        stackAdjustmentY = 0;
        stackLocationY = stackLocationY -  stackAdjustmentY;
        
        
    } else {
        
        stackAdjustmentX = 0;
        stackLocationX = stackLocationX -  stackAdjustmentX;
        
        
        stackAdjustmentY = 0;
        stackLocationY = stackLocationY -  stackAdjustmentY;
        
    }
    
    
    StackObject* object1 = [StackObject objectWithWorld:world location:ccp( 0 + stackLocationX , 65 + stackLocationY) spriteFileName:@"woodShape1" breakOnGround:NO breakFromPanda:YES  hasAnimatedBreakFrames:YES  damageEnemy:NO density:0.25f createHow:useShapeOfSourceImage angleChange:90 makeImmovable:NO points:100 simpleScoreType:breakEffectSmokePuffs];
    [self addChild:object1 z:zOrderStack];
    
    StackObject* object2 = [StackObject objectWithWorld:world location:ccp(95 + stackLocationX , 65 + stackLocationY) spriteFileName:@"woodShape1" breakOnGround:NO breakFromPanda:YES  hasAnimatedBreakFrames:YES damageEnemy:NO density:0.25f createHow:useShapeOfSourceImage angleChange:90 makeImmovable:NO points:100 simpleScoreType:breakEffectSmokePuffs];
    [self addChild:object2 z:zOrderStack];
    
    StackObject* object3 = [StackObject objectWithWorld:world location:ccp(47 + stackLocationX, 145 + stackLocationY) spriteFileName:@"woodShape1" breakOnGround:NO breakFromPanda:YES  hasAnimatedBreakFrames:YES damageEnemy:NO density:0.25f createHow:useShapeOfSourceImage angleChange:0 makeImmovable:NO points:100 simpleScoreType:breakEffectExplosion];
    [self addChild:object3 z:zOrderStack];
    
    StackObject* object4 = [StackObject objectWithWorld:world location:ccp( 0 + stackLocationX, 225 + stackLocationY) spriteFileName:@"woodShape1" breakOnGround:NO breakFromPanda:YES  hasAnimatedBreakFrames:YES damageEnemy:NO density:0.25f createHow:useShapeOfSourceImage angleChange:90 makeImmovable:NO points:100 simpleScoreType:breakEffectExplosion];
    [self addChild:object4 z:zOrderStack];
    
    StackObject* object5 = [StackObject objectWithWorld:world location:ccp(95 + stackLocationX, 225 + stackLocationY) spriteFileName:@"woodShape1" breakOnGround:NO breakFromPanda:YES  hasAnimatedBreakFrames:YES damageEnemy:NO density:0.25f createHow:useShapeOfSourceImage angleChange:90 makeImmovable:NO points:100 simpleScoreType:breakEffectExplosion];
    [self addChild:object5 z:zOrderStack];
    
    
    
    Enemy* enemy1 = [Enemy enemyWithWorld:world location:ccp(45 + stackLocationX , 200 + stackLocationY) spriteFileName:@"dragon" isTheRotationFixed:YES getDamageFromGround:YES doesGetDamageFromDamageEnabledStackObjects:YES  breaksFromHowMuchContact:0 hasDifferentSpritesForDamage:YES numberOfFramesToAnimateOnBreak:10 density:1.0f createHow:useShapeOfSourceImage points:10000 simpleScoreType:breakEffectSmokePuffs];
    [self addChild:enemy1 z:zOrderStack];
    
    enemyNumber ++;
    [GameData sharedData].enemyNumberForCurrentLevel = enemyNumber;
    
}

//创建关卡2

-(void) createLevel2 {
    
    if (IS_IPAD) {
        
        stackAdjustmentX = 0;
        stackLocationX = stackLocationX -  stackAdjustmentX;
        
        stackAdjustmentY = 0;
        stackLocationY = stackLocationY -  stackAdjustmentY;
        
        
    } else {
        
        stackAdjustmentX = 0;
        stackLocationX = stackLocationX -  stackAdjustmentX;
        
        
        stackAdjustmentY = 0;
        stackLocationY = stackLocationY -  stackAdjustmentY;
        
    }
    
    
    StackObject* object1 = [StackObject objectWithWorld:world location:ccp( 40 + stackLocationX , 40 + stackLocationY) spriteFileName:@"bluebrick" breakOnGround:NO breakFromPanda:NO  hasAnimatedBreakFrames:NO  damageEnemy:NO density:1.0f createHow:useShapeOfSourceImage angleChange:0 makeImmovable:YES points:0 simpleScoreType:breakEffectNone];
    [self addChild:object1 z:zOrderStack];
    
    
    StackObject* object2 = [StackObject objectWithWorld:world location:ccp( 190 + stackLocationX , 40 + stackLocationY) spriteFileName:@"bluebrick" breakOnGround:NO breakFromPanda:NO  hasAnimatedBreakFrames:NO  damageEnemy:NO density:1.0f createHow:useShapeOfSourceImage angleChange:90 makeImmovable:YES points:0 simpleScoreType:breakEffectNone];
    [self addChild:object2 z:zOrderStack];
    
    
    
    StackObject* object3 = [StackObject objectWithWorld:world location:ccp(113 + stackLocationX, 88 + stackLocationY) spriteFileName:@"woodShape2" breakOnGround:NO breakFromPanda:YES  hasAnimatedBreakFrames:NO damageEnemy:YES density:0.25f createHow:useShapeOfSourceImage angleChange:0 makeImmovable:NO points:100 simpleScoreType:breakEffectExplosion];
    [self addChild:object3 z:zOrderStack];
    
    StackObject* object4 = [StackObject objectWithWorld:world location:ccp(57 + stackLocationX, 128 + stackLocationY) spriteFileName:@"woodShape4" breakOnGround:NO breakFromPanda:YES  hasAnimatedBreakFrames:NO damageEnemy:YES density:0.25f createHow:useShapeOfSourceImage angleChange:90 makeImmovable:NO points:100 simpleScoreType:breakEffectExplosion];
    [self addChild:object4 z:zOrderStack];
    
    StackObject* object5 = [StackObject objectWithWorld:world location:ccp(114 + stackLocationX, 128 + stackLocationY) spriteFileName:@"woodShape4" breakOnGround:NO breakFromPanda:YES  hasAnimatedBreakFrames:NO damageEnemy:YES density:0.25f createHow:useShapeOfSourceImage angleChange:90 makeImmovable:NO points:100 simpleScoreType:breakEffectExplosion];
    [self addChild:object5 z:zOrderStack];
    
    StackObject* object6 = [StackObject objectWithWorld:world location:ccp(168 + stackLocationX, 128 + stackLocationY) spriteFileName:@"woodShape4" breakOnGround:NO breakFromPanda:YES  hasAnimatedBreakFrames:NO damageEnemy:YES density:0.25f createHow:useShapeOfSourceImage angleChange:90 makeImmovable:NO points:100 simpleScoreType:breakEffectExplosion];
    [self addChild:object6 z:zOrderStack];
    
    StackObject* object7 = [StackObject objectWithWorld:world location:ccp(124 + stackLocationX, 166 + stackLocationY) spriteFileName:@"woodShape3" breakOnGround:NO breakFromPanda:YES  hasAnimatedBreakFrames:NO damageEnemy:YES density:0.25f createHow:useShapeOfSourceImage angleChange:0 makeImmovable:NO points:100 simpleScoreType:breakEffectExplosion];
    [self addChild:object7 z:zOrderStack];
    
 
    
    Enemy* enemy1 = [Enemy enemyWithWorld:world location:ccp(117 + stackLocationX , 45 + stackLocationY) spriteFileName:@"dragon" isTheRotationFixed:YES getDamageFromGround:NO doesGetDamageFromDamageEnabledStackObjects:YES  breaksFromHowMuchContact:1 hasDifferentSpritesForDamage:YES numberOfFramesToAnimateOnBreak:10 density:1.0f createHow:useShapeOfSourceImage points:10000 simpleScoreType:breakEffectSmokePuffs];
    [self addChild:enemy1 z:zOrderStack];
    enemyNumber ++;
    [GameData sharedData].enemyNumberForCurrentLevel = enemyNumber;
}

//创建关卡3

-(void) createLevel3{
    
    //参考关卡1和2创建该关卡
}

//创建关卡5

-(void) createLevel4{
    
     //参考关卡1和2创建该关卡
    
}

//创建关卡6

-(void) createLevel6{
    
     //参考关卡1和2创建该关卡
    
}

//创建关卡7

-(void) createLevel7{
    
     //参考关卡1和2创建该关卡
    
}

//创建关卡8

-(void) createLevel8{
    
     //参考关卡1和2创建该关卡
    
}

//创建关卡9

-(void) createLevel9{
    
     //参考关卡1和2创建该关卡
    
}

//创建关卡10

-(void) createLevel10{
    
     //参考关卡1和2创建该关卡
    
}

//创建场景2的关卡1-10
//......

//创建场景3的关卡1-10
//......

//创建场景4的关卡1-10
//......

//创建场景5的关卡1-10
//......

@end
