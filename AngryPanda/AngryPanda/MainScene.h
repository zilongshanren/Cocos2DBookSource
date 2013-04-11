//
//  MainScene.h




/* 游戏中最为重要的类，它也是游戏的主场景，在教程中将详细讲解
 难以重用到其它项目
 该类非常重要，是游戏最核心的引擎。
 
 */


#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"
#import "Constants.h"
#import "PhysicsNode.h"
#import "Panda.h"

#import "ContactListener.h"





// MainScene

@interface MainScene : CCLayer
{
    
    //设备类型
    int deviceType;
    
    int screenWidth;
    int screenHeight;
    
    int currentLevel;
    int scoreForCurrentLevel;
    int scoreToPassLevel;
    int bonusThisRound;
    int bonusPerLeftPanda;
    
    int enemyNumber;
    
    unsigned char fontSizeForScore;
    
    float panAmount;
    int initialPanAmount;
    int extraAmountOnPanBack;
    int maxStretchOfSlingShot;
    
    
    
    BOOL stackIsNowDynamic;
    
    BOOL areWeOnTheIPad;
    
    BOOL useImagesForPointScoreLabels;
    
    BOOL somethingJustScored;
    BOOL dottingOn;
    BOOL areWeInTheStartingPosition;
    BOOL slingShotPandaInHand;  //熊猫是否在弹弓中
    BOOL throwInProgress;  //是否熊猫正在被抛投
    BOOL autoPanningInProgress;
    BOOL reverseHowFingerPansScreen; //根据手指向左或向右移动来切换屏幕的移动方向
    BOOL panningTowardSling;
    BOOL continuePanningScreenOnFingerRelease;
    BOOL autoReverseOn;
    
    float multipyThrowPower;
    
    float yAxisGravity;
    bool gravityOn;
    
	b2World* world;
	GLESDebugDraw *m_debugDraw;
    ContactListener* contactListener;
    
    // 当前被抛投的熊猫角色
    
    Panda* currentBodyNode;
    Panda* panda1;
    
    // 等待被抛投的熊猫角色
    
    Panda* panda2;
    Panda* panda3;
    Panda* panda4;
    Panda* panda5;
    
    unsigned char pandasToTossThisLevel;
    unsigned char pandaBeingThrown;
    
    //背景
    
    CCSprite* backgroundLayerClouds;
    CCSprite* backgroundLayerHills;
    
    //粒子效果
    CCParticleSystem *system;
    
    
    //初始位置
    CGPoint cloudLayerStartPosition;
    CGPoint hillsLayerStartPosition;
    CGPoint particleSystemStartPosition;
    CGPoint labelStartingPoint;
    
    //弹弓
    
    CCSprite *slingShotFront;
    
    CCSprite *strapFront;
    CCSprite *strapBack;
    CCSprite *strapEmpty;
    
    //BOX2D 物体的起始位置
    
    CGPoint groundPlaneStartPosition;
    CGPoint platformStartPosition;
    CGPoint pandaStartPosition1;
    CGPoint pandaStartPosition2;
    CGPoint pandaStartPosition3;
    CGPoint pandaStartPosition4;
    CGPoint pandaStartPosition5;
    
    
    // 用于移动场景以查看目标
    
    float worldMaxHorizontalShift;
    float previousTouchLocationX;
    
    float adjustY;
    float maxScaleDownValue;
    float scaleAmount;
    float speed;
    
    //标签相关的变量

    CCLabelTTF *currentScoreLabel;
    CGPoint currentScoreLabelPosition;
 
    CGPoint pauseButtonPosition;
    
    CGPoint slingShotCenterPosition;
    CGPoint positionInSling;
    
    //熊猫在空中的白色点痕迹
    
    int dotCount;
    int throwCount;
    int dotTotalOnEvenNumberedTurn;
    int dotTotalOnOddNumberedTurn;
    
    
    //菜单按钮
    
    CCMenu *pauseButtonMenu;
    
    //拉伸弹弓到最大范围的次数
    int stretchBeyondRange;
    

    
    //地面物体
    NSString* groundPlaneFileName;
    
    //当前关卡是否通过
    BOOL levelClear;
    
}




+(MainScene*) sharedScene;

+(CCScene *) scene;


-(void) enableDebugMode ;


//碰撞检测机制将会调用以下方法

-(void) proceedToNextTurn:(Panda*)thePanda;
-(void) stopDotting;
-(void) showPandaImpactingStack:(Panda*)thePanda;
-(void) showPandaOnGround:(Panda*)thePanda;

//

-(void) removePreviousDots;

-(void) switchAllStackObjectsToStatic ;

-(void) showLevelResult;

//场景的移动

-(void) moveScreen:(int)amountToShiftScreen;
-(void) putEverythingInStartingViewOfSlingShot;
-(void) putEverythingInViewOfTargets;

-(void) startScreenPanToTargets;
-(void) startScreenPanToTargetsWithAutoReverseOn;
-(void) autoScreenPanToTargets:(ccTime)delta;

-(void) startScreenPanToSling;
-(void) autoScreenPanToSling:(ccTime)delta;

-(void) moveScreenUp:(ccTime) delta;
-(void) moveScreenDown:(ccTime) delta;

-(void) cancelAutoPan;

//熊猫在弹弓时的调整

-(void) adjustBackStrap:(float)angle;
-(int)  returnAmountToShiftScreen:(int)diff;
- (GLfloat) calculateAngle:(GLfloat)x1 :(GLfloat)y1 :(GLfloat)x2 :(GLfloat)y2;
-(BOOL) checkCircleCollision:(CGPoint)center1  :(float)radius1  :(CGPoint) center2  :(float) radius2;


-(void) jumpToLevelResultScene;



//显示游戏分值
//-(void) updatePointsLabel;

-(void) showPoints:(int)pointValue positionToShowScore:(CGPoint)positionToShowScore  theSimpleScore:(int)theSimpleScore ;
-(void) showPointsWithImagesForValue:(int) pointValue positionToShowScore:(CGPoint)positionToShowScore ;



@end
