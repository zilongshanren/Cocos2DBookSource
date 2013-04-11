//
//  MainScene.mm
//  AngryPanda
//
//  Created by eseedo on 1/27/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


#import "MainScene.h"
#import "CustomAnimation.h"
#import "LevelResult.h"
#import "GamePause.h"
#import "Level.h"
#import "Levels.h"
#import "LevelParser.h"
#import "SimpleAudioEngine.h"
#import "SceneManager.h"
#import "GameData.h"
#import "Constants.h"
#import "StackObject.h"
#import "GameData.h"
#import "ShootingTargets.h"
#import "LevelSelection.h"
#import "GameSounds.h"
#import "GamePause.h"
#import "FirePlatform.h"
#import "GroundPlane.h"



//判断设备是iPHone还是iPad
#define IS_IPHONE (!IS_IPAD)
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPhone)




// MainScene implementation
@implementation MainScene


static MainScene* layerInstance;

//单例类方法

+(MainScene*) sharedScene
{
	NSAssert(layerInstance != nil, @"初始化未成功!");
    
	return layerInstance;
}


//场景类方法
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	MainScene *layer = [MainScene node];

    
	// add layer as a child to scene
	[scene addChild: layer z:-1];
    

    
	
	// return the scene
	return scene;
}


//获取设备类型
-(void)getDeviceType{
    
    if([GameData sharedData].isDeviceIphone5 == NO){
        deviceType = kDeviceTypeNotIphone5;
    }else{
        deviceType = kDeviceTypeIphone5OrNewTouch;
    }
}


//从GameData读取数据，并设置一些基本的参数

-(void)readData{
    
    
    throwInProgress = NO; // 是否当前有抛投在进行中， 用于防止同时抛投两个熊猫
    areWeInTheStartingPosition = YES;  //场景在x轴是否为0（如果是，则将熊猫放置到弹弓上）
    
    throwCount = 0;
    dotTotalOnOddNumberedTurn = 0;
    dotTotalOnEvenNumberedTurn = 0;
    
    currentLevel = [GameData sharedData].selectedLevel;
    scoreForCurrentLevel = 0;
    
    
    //根据关卡编号的不同设置背景和其它数值，此处可以优化为放到plist,xml或Constants.h中
    switch (currentLevel) {

        case 1:
            backgroundLayerClouds = [CCSprite spriteWithFile: @"background_clouds.png"];
            backgroundLayerHills = [CCSprite spriteWithFile: @"background_hills.png"];
            groundPlaneFileName = @"ground_plane.png";
            scoreToPassLevel = 10000;
            bonusPerLeftPanda = 10000;
            pandasToTossThisLevel = 1;
            break;
        case 2:
            backgroundLayerClouds = [CCSprite spriteWithFile: @"background_clouds.png"];
            backgroundLayerHills = [CCSprite spriteWithFile: @"background_hills.png"];
            groundPlaneFileName = @"ground_plane.png";
            scoreToPassLevel = 12000;
            bonusPerLeftPanda = 10000;
            pandasToTossThisLevel = 2;
            break;
        case 3:
            backgroundLayerClouds = [CCSprite spriteWithFile: @"background_clouds.png"];
            backgroundLayerHills = [CCSprite spriteWithFile: @"background_hills.png"];
            groundPlaneFileName = @"ground_plane.png";
            scoreToPassLevel = 15000;
            bonusPerLeftPanda = 10000;
            pandasToTossThisLevel = 3;
            break;
        case 4:
            backgroundLayerClouds = [CCSprite spriteWithFile: @"background_clouds.png"];
            backgroundLayerHills = [CCSprite spriteWithFile: @"background_hills.png"];
            groundPlaneFileName = @"ground_plane.png";
            scoreToPassLevel = 15000;
            bonusPerLeftPanda = 10000;
            pandasToTossThisLevel = 4;
            break;
        case 5:
            backgroundLayerClouds = [CCSprite spriteWithFile: @"background_clouds.png"];
            backgroundLayerHills = [CCSprite spriteWithFile: @"background_hills.png"];
            groundPlaneFileName = @"ground_plane.png";
            scoreToPassLevel = 15000;
            bonusPerLeftPanda = 10000;
            pandasToTossThisLevel = 4;
            break;
        case 6:
            backgroundLayerClouds = [CCSprite spriteWithFile: @"background_clouds.png"];
            backgroundLayerHills = [CCSprite spriteWithFile: @"background_hills.png"];
            groundPlaneFileName = @"ground_plane.png";
            scoreToPassLevel = 15000;
            bonusPerLeftPanda = 10000;
            pandasToTossThisLevel = 4;
            break;
        case 7:
            backgroundLayerClouds = [CCSprite spriteWithFile: @"background_clouds.png"];
            backgroundLayerHills = [CCSprite spriteWithFile: @"background_hills.png"];
            groundPlaneFileName = @"ground_plane.png";
            scoreToPassLevel = 15000;
            bonusPerLeftPanda = 10000;
            pandasToTossThisLevel = 4;
            break;
        case 8:
            backgroundLayerClouds = [CCSprite spriteWithFile: @"background_clouds.png"];
            backgroundLayerHills = [CCSprite spriteWithFile: @"background_hills.png"];
            groundPlaneFileName = @"ground_plane.png";
            scoreToPassLevel = 15000;
            bonusPerLeftPanda = 10000;
            pandasToTossThisLevel = 4;
            break;
        case 9:
            backgroundLayerClouds = [CCSprite spriteWithFile: @"background_clouds.png"];
            backgroundLayerHills = [CCSprite spriteWithFile: @"background_hills.png"];
            groundPlaneFileName = @"ground_plane.png";
            scoreToPassLevel = 15000;
            bonusPerLeftPanda = 10000;
            pandasToTossThisLevel = 4;
            break;
        case 10:
            backgroundLayerClouds = [CCSprite spriteWithFile: @"background_clouds.png"];
            backgroundLayerHills = [CCSprite spriteWithFile: @"background_hills.png"];
            groundPlaneFileName = @"ground_plane.png";
            scoreToPassLevel = 15000;
            bonusPerLeftPanda = 10000;
            pandasToTossThisLevel = 4;
            break;
            
        default:
            backgroundLayerClouds = [CCSprite spriteWithFile: @"background_clouds.png"];
            backgroundLayerHills = [CCSprite spriteWithFile: @"background_hills.png"];
            groundPlaneFileName = @"ground_plane.png";
            scoreToPassLevel = 15000;
            bonusPerLeftPanda = 10000;
            pandasToTossThisLevel = 1;
            break;
    }
    
    
    
    //参数设置
    
    continuePanningScreenOnFingerRelease = YES; // 如果场景平移正在弹弓或目标间移动，当玩家松开手指时，场景会继续朝之前的方向平移
    reverseHowFingerPansScreen = NO; //如果要反向则设置为YES
    
    
    //设置背景图片
    
    
    [self addChild:backgroundLayerClouds z:zOrderClouds];
    [self addChild:backgroundLayerHills z:zOrderHills];
    backgroundLayerHills.scaleX = 1.05;
    
    //弹弓的视觉效果
    
    slingShotFront = [CCSprite spriteWithFile:@"slingshot_front.png"];
    [self addChild:slingShotFront z:zOrderSlingShotFront];
    
    strapFront = [CCSprite spriteWithFile:@"strap.png"];
    [self addChild:strapFront z:zOrderStrapFront];
    
    strapBack = [CCSprite spriteWithFile:@"strapBack.png"];
    [self addChild:strapBack z:zOrderStrapBack];
    
    strapEmpty = [CCSprite spriteWithFile:@"strapEmpty.png"];
    [self addChild:strapEmpty z:zOrderStrapBack];
    
    strapBack.visible = NO;  //仅在拉伸时可见
    strapFront.visible = NO; //仅在拉伸时可见
    
}

//设置初始位置

-(void)setInitialPosition{
    
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    
    screenWidth = screenSize.width;
    screenHeight = screenSize.height;
    
    currentScoreLabelPosition = ccp( screenWidth*0.5 , screenSize.height*0.9);

    
    //为iPad或iPhone设备设置初始位置和参数
    
    if (IS_IPAD) {
        
        areWeOnTheIPad = YES;
        
        //参数设置
        
        maxStretchOfSlingShot = 75; //应为源图片大小的1/4
        multipyThrowPower = 1; // 数值可以在0.5到1.5之间，需要精细调整
        
        worldMaxHorizontalShift = -(screenWidth);  // 玩家可以朝左或朝右滑动以查看整个平台，通常为负值
        maxScaleDownValue = 1.0; //固定值
        scaleAmount = 0; // 当拖动场景时用于调整场景比例的增量
        initialPanAmount = 30; //屏幕场景开始拖动时的速度
        extraAmountOnPanBack = 10; // 向回拖动时的增量
        adjustY = 0;
        
        //背景
        
        backgroundLayerClouds.position = ccp(screenWidth, screenHeight / 2 );
        backgroundLayerHills.position = ccp(screenWidth, screenHeight / 2 );
        
        pauseButtonPosition = ccp( 60 , screenSize.height-40);
        
        //地平面和平台
        
        groundPlaneStartPosition = ccp(screenWidth, 50 );
        platformStartPosition = ccp(400,  173 );
        
        //弹弓
        slingShotCenterPosition = ccp(370,  225 );
        
        slingShotFront.position = ccp(377, 201 );
        strapFront.position = ccp(slingShotCenterPosition.x, slingShotCenterPosition.y  );
        strapBack.position = ccp(slingShotCenterPosition.x + 33 , slingShotCenterPosition.y - 10 );
        strapEmpty.position = ccp(378, 205 );
        
        //熊猫
        
        pandaStartPosition1 = ccp(385,  240 );
        pandaStartPosition2 = ccp(300,  155 );
        pandaStartPosition3 = ccp(260,  155 );
        pandaStartPosition4 = ccp(200,  120 );
        pandaStartPosition5 = ccp(160,  120 );
        

    }
    
    else if (IS_IPHONE) {
        
        areWeOnTheIPad = NO ;
        
        //变量
        maxStretchOfSlingShot = 75; //应为源图片大小的1/4
        multipyThrowPower = 1.0; // 数值可以在0.5到1.5之间，需要精细调整
        
        worldMaxHorizontalShift = -(screenWidth); // 玩家可以朝左或朝右滑动以查看整个平台，通常为负值
        maxScaleDownValue = 0.65; //范围应在0.75到1.0之间
        scaleAmount = .01; // 当拖动场景时用于调整场景比例的增量
        adjustY = -34;
        
        initialPanAmount = 20; //屏幕场景开始拖动时的速度
        extraAmountOnPanBack = 0; // 在iPhone版本中最好设置为0
        
        //背景
        
        backgroundLayerClouds.position = ccp(screenWidth, 192 );
        backgroundLayerClouds.scale = .7;
        backgroundLayerHills.position = ccp(screenWidth, 245  );
        backgroundLayerHills.scale = .7;
        
        
        pauseButtonPosition = ccp( 50 , screenSize.height-30);
        
        
        fontSizeForScore =  18;
        
        //地平面和平台
        
        groundPlaneStartPosition = ccp(screenWidth, -25 );
        platformStartPosition = ccp(185,  110 );
        
        //弹弓
        
        slingShotCenterPosition = ccp(160,  160 );
        slingShotFront.position = ccp(164, 145 );
        strapFront.position = ccp(slingShotCenterPosition.x, slingShotCenterPosition.y  );
        strapBack.position = ccp(slingShotCenterPosition.x + 33 , slingShotCenterPosition.y - 10 );
        strapEmpty.position = ccp(168, 145 );
        
        //熊猫
        
        pandaStartPosition1 = ccp(170,  175 );
        pandaStartPosition2 = ccp(110,  82 );
        pandaStartPosition3 = ccp(65,  82 );
        pandaStartPosition4 = ccp(90,  65 );
        pandaStartPosition5 = ccp(43,  65 );
    }
    
    //记录物体的起始位置
    
    hillsLayerStartPosition = backgroundLayerHills.position;
    cloudLayerStartPosition = backgroundLayerClouds.position;
    
    
}

//添加暂停按钮
-(void)addPauseButton{
    
    CCMenuItemImage* pauseButton = [CCMenuItemImage itemWithNormalImage:@"button_pause.png" selectedImage:@"button_pause.png" target:self selector:@selector(pauseGame)];
    pauseButtonMenu = [CCMenu menuWithItems:pauseButton,  nil];
    pauseButtonMenu.position = pauseButtonPosition;
    [self addChild:pauseButtonMenu z:zOrderScore];
    
    
}

#pragma mark 菜单按钮等基本场景视觉元素

//切换到暂停画面

-(void) pauseGame {
    
    
    //暂停游戏
    
    ccColor4B c = {0,0,0,0};
    [GamePause layerWithColor:c delegate:self];
    
}

//初始化box2d物理世界
-(void)initPhysics{
    // 设置重力参数
    
    yAxisGravity = -10;
    
    b2Vec2 gravity;
    gravity.Set(0.0f, yAxisGravity);
    
    world = new b2World(gravity);
    
    
    // Do we want to let bodies sleep?
    world->SetAllowSleeping(true);
    
    world->SetContinuousPhysics(true);
    
    //[self enableDebugMode];
    
    
    
    // 定义地面物体
    b2BodyDef groundBodyDef;
    groundBodyDef.position.Set(0, 0); // bottom-left corner
    
    // Call the body factory which allocates memory for the ground body
    // from a pool and creates the ground box shape (also from a pool).
    // The body is also added to the world.调用物体工厂来创建地面物体
    b2Body* groundBody = world->CreateBody(&groundBodyDef);
    
    // Define the ground box shape.创建地面盒定义
    b2EdgeShape groundBox;
    
    int worldMaxWidth = screenWidth * 4; //Box2D世界的最大宽度
    int worldMaxHeight = screenHeight * 3; //Box2D世界的最大高度
    
    // 底部
    groundBox.Set(b2Vec2(-4,0), b2Vec2( worldMaxWidth /PTM_RATIO,0));
    groundBody->CreateFixture(&groundBox,0);
    
    // 顶部
    groundBox.Set(b2Vec2(-4,worldMaxHeight/PTM_RATIO), b2Vec2( worldMaxWidth /PTM_RATIO, worldMaxHeight /PTM_RATIO));
    groundBody->CreateFixture(&groundBox,0);
    
    // 左侧
    groundBox.Set(b2Vec2(-4,worldMaxHeight/PTM_RATIO), b2Vec2(-4,0));
    groundBody->CreateFixture(&groundBox,0);
    
    // 右侧
    groundBox.Set(b2Vec2( worldMaxWidth /PTM_RATIO,worldMaxHeight/PTM_RATIO), b2Vec2(worldMaxWidth /PTM_RATIO,0));
    groundBody->CreateFixture(&groundBox,0);
    
}

//启用碰撞检测

-(void)initContactListener{
    
    //启用碰撞检测机制
    
    contactListener = new ContactListener();
    world->SetContactListener(contactListener);
    
}

//添加地平面物体

-(void)addGroundPlaneBody{
    //设置地平面物体
    
    GroundPlane* theGroundPlane = [GroundPlane groundWithWorld:world location:groundPlaneStartPosition spriteFileName:groundPlaneFileName];
    [self addChild:theGroundPlane z:zOrderFloor];
    
    
}

//添加弹弓平台
-(void)addFirePlatform{
    //设置弹弓的放置平台物体
    
    FirePlatform* platform = [FirePlatform platformWithWorld:world location:platformStartPosition spriteFileName:@"platform.png"];
    [self addChild:platform z:zOrderPlatform];
    
}

//添加熊猫物体
-(void)addPanda{
    //设置熊猫
    
    pandaBeingThrown = 1; //从第一个熊猫开始
    
    
    panda1 = [Panda pandaWithWorld:world location:pandaStartPosition1 baseFileName:@"panda"];
    [self addChild:panda1 z:zOrderPandas];
    
    currentBodyNode = panda1;
    
    
    if ( pandasToTossThisLevel >= 2) {
        
        panda2 = [Panda pandaWithWorld:world location:pandaStartPosition2 baseFileName:@"pandaYellow"];
        
        [self addChild:panda2 z:zOrderPandas];
        
        
    }
    if ( pandasToTossThisLevel >= 3) {
        
        panda3 = [Panda pandaWithWorld:world location:pandaStartPosition3 baseFileName:@"pandaBlue"];
        [self addChild:panda3 z:zOrderPandas];
        
    }
    if ( pandasToTossThisLevel >= 4) {
        
        panda4 = [Panda pandaWithWorld:world location:pandaStartPosition4 baseFileName:@"pandaGreen"];
        [self addChild:panda4 z:zOrderPandas];
        
    }
    
    
}


//创建遮挡物和外星怪物
-(void)addTargets{
    
    //创建遮挡物和外星怪物
    
    ShootingTargets* targets = [ShootingTargets setupStackWithWorld:world];
    [self addChild:targets z:zOrderStack];
    
    
    //给遮挡物和怪物一定的时间来掉落，然后将其中的每一部分设置为静态（锁定其位置，直到第一次弹弓发射开始）
    [self performSelector:@selector(switchAllStackObjectsToStatic) withObject:nil afterDelay:1.0f];
}


//添加得分和历史最高得分标签
-(void)addScoreLabel{
    
    currentScoreLabel = [CCLabelTTF labelWithString:@"" fontName:@"Marker Felt" fontSize:fontSizeForScore ];
    [self addChild:currentScoreLabel z:zOrderPointScore];
    [currentScoreLabel setColor:ccc3(255,255,255)];
    currentScoreLabel.position = currentScoreLabelPosition;

}

-(void)updatePointsLabel{
    
    //顶部标签
    
    NSString* scoreLabel = [NSString stringWithFormat:@"Score: %i ", scoreForCurrentLevel];
    
    [self->currentScoreLabel setString:scoreLabel];
}


//添加关卡介绍标签

-(void)addLevelIntroLabel{
    
    NSString* levelString = [NSString stringWithFormat:@"Level: %i", [GameData sharedData].selectedLevel ];
    CCLabelTTF* message = [CCLabelTTF labelWithString:levelString fontName:@"Marker Felt" fontSize:18];
    [self addChild:message z:1];
    [message setColor:ccc3(255,255,255)];
    message.position = ccp( screenWidth /2, screenHeight * 0.6 );

    
    CCSequence *seq = [CCSequence actions:
                       
                       [CCScaleTo actionWithDuration:1.0f scale:2.0f],
                       [CCFadeTo actionWithDuration:1.0f opacity:0.0f],
                       [CCCallFuncN actionWithTarget:self selector:@selector(removeMessage:)], nil];
    
    [message runAction:seq];
    
    
}


//删除信息

-(void) removeMessage:(id)sender {
    
    
    CCLabelTTF *message = (CCLabelTTF *)sender;
    
	[self removeChild:message cleanup:YES];
    
    
}

#pragma mark 场景初始化

//初始化音效和背景音乐

-(void)initSounds{
    
    if ( [GameData sharedData].soundEffectMuted  == NO ) {

        [[SimpleAudioEngine sharedEngine]playBackgroundMusic:@"birds.mp3"];
        
    }
    
    
}


//场景初始化
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
		
        layerInstance = self;
        
        
		//在场景中启用对触摸事件的支持
		self.isTouchEnabled = YES;
		
        [self getDeviceType];
        
        //读取GameData中的数据，并设置一些基本的参数
        [self readData];
        
        //设置初始位置
        [self setInitialPosition];
        
        //添加关卡介绍标签
        [self addLevelIntroLabel];
        
        //添加得分和历史最高得分标签
        [self addScoreLabel];
        [self updatePointsLabel];

        
        //添加暂停按钮
        [self addPauseButton];
        
        //设置box2d
        [self initPhysics];
        [self initContactListener];
        
        //添加游戏世界中的各种物体
        [self addGroundPlaneBody];
        [self addFirePlatform];
        [self addPanda];
        [self addTargets];
        
        //加载游戏音效和背景音乐
        [self initSounds];
        
        
        //实时更新游戏中的物体所在位置
		
		[self schedule: @selector(tick:)];
     
        
	}
	return self;
}

#pragma mark Box2D物理世界相关的方法

//将shootingtargets中的物体转换为静态物体

-(void) switchAllStackObjectsToStatic {
    
    stackIsNowDynamic = NO;
    
    //遍历物理世界中的所有物体
	for (b2Body* b = world->GetBodyList(); b; b = b->GetNext())
	{
		if (b->GetUserData() != NULL) {
			
			StackObject *myActor = (StackObject*)b->GetUserData();
            
            if ( [myActor isKindOfClass:[StackObject class]] ) {
                
                myActor.body->SetType(b2_staticBody);
                
            }
            
		}
	}
    
}

//将shootingtargets中的所有物体转换为动态物体

-(void) switchAllStackObjectsToDynamic {
    
    
    if ( stackIsNowDynamic == NO ) {
        
        stackIsNowDynamic = YES;
        
        //遍历物理世界中的所有物体
        for (b2Body* b = world->GetBodyList(); b; b = b->GetNext())
        {
            if (b->GetUserData() != NULL) {
                
                StackObject *myActor = (StackObject*)b->GetUserData();
                if ( [myActor isKindOfClass:[StackObject class]] ) {
                    
                    if ( myActor.isStatic == NO  ) {
                        myActor.body->SetType(b2_dynamicBody);
                        myActor.body->SetAwake(true);
                        
                    }
                    
                }
            }
        }
        
        
    }
    
}



//启用调试模式

-(void) enableDebugMode {
    
    
	m_debugDraw = new GLESDebugDraw( PTM_RATIO );
	world->SetDebugDraw(m_debugDraw);
	
	uint32 flags = 0;
	flags += b2Draw::e_shapeBit;
	//		flags += b2Draw::e_jointBit;
	//		flags += b2Draw::e_aabbBit;
	//		flags += b2Draw::e_pairBit;
	//		flags += b2Draw::e_centerOfMassBit;
	m_debugDraw->SetFlags(flags);
}



//每帧更新世界中的内容

-(void) tick: (ccTime) dt
{
	
	
	int32 velocityIterations = 8;
	int32 positionIterations = 1;
	
	// Instruct the world to perform a single step of simulation. It is
	// generally best to keep the time step and iterations fixed.
	world->Step(dt, velocityIterations, positionIterations);
    
	
	//Iterate over the bodies in the physics world
	for (b2Body* b = world->GetBodyList(); b; b = b->GetNext())
	{
		if (b->GetUserData() != NULL) {
			//让Box2D世界的物体和Cocos2D的精灵位置一一对应
			CCSprite *myActor = (CCSprite*)b->GetUserData();
			myActor.position = CGPointMake( b->GetPosition().x * PTM_RATIO, b->GetPosition().y * PTM_RATIO);
			myActor.rotation = -1 * CC_RADIANS_TO_DEGREES(b->GetAngle());
		}
	}
}



#pragma mark 和碰撞检测机制相关的方法

//切换到下一次抛投

-(void) proceedToNextTurn:(Panda*)thePanda { //如果熊猫碰到地面
    
    if (thePanda == currentBodyNode) {
        
        
        [self unschedule:@selector(timerAfterThrow:)]; // 由于熊猫已碰到地面，因此取消消息预定
        [self schedule:@selector(moveNextPandaIntoSling:) interval:1.0f];
        
    } else {
        
        
    }
    
}



//将下一个熊猫放到弹弓上

-(void) moveNextPandaIntoSling:(ccTime) delta {
    
    
    if (somethingJustScored == NO) { //在完成得分前不要移动熊猫
        
        [self unschedule:_cmd];
        
        enemyNumber = [GameData sharedData].enemyNumberForCurrentLevel;
        
        pandaBeingThrown ++;
        
        if ( pandaBeingThrown <= pandasToTossThisLevel && scoreForCurrentLevel < scoreToPassLevel ) {
            
            switch (pandaBeingThrown) {
                case 2:
                    currentBodyNode = panda2;
                    break;
                case 3:
                    currentBodyNode = panda3;
                    break;
                case 4:
                    currentBodyNode = panda4;
                    break;
                    
            }
            
            b2Vec2 locationInMeters = b2Vec2(pandaStartPosition1.x / PTM_RATIO, pandaStartPosition1.y / PTM_RATIO);
            currentBodyNode.body->SetTransform( locationInMeters , CC_DEGREES_TO_RADIANS( 0  )  );
            
            
            
            throwInProgress = NO;
            
        }  else if ( pandaBeingThrown > pandasToTossThisLevel || scoreForCurrentLevel >= scoreToPassLevel) {
            
            
            [self performSelector:@selector(showLevelResult) withObject:nil afterDelay:2.0f];
            
        }
        
    }
}

//停止添加白色点痕迹

-(void) stopDotting {
    
    dottingOn = NO;
    
}

//显示熊猫碰撞目标的动画

-(void) showPandaImpactingStack:(Panda*)thePanda {
    
    
    if (thePanda == currentBodyNode) { //确保currentBodyNode 就是和目标发生碰撞的同一个熊猫
        
        
        // 此处可添加其它音效
        // 此处可添加动画或执行其它动作
        
    }
    
}

//熊猫在地面上时所调用的方法
-(void) showPandaOnGround:(Panda*)thePanda {
    
    
    if (thePanda == currentBodyNode) { //确保currentBodyNode 就是和地面发生碰撞的同一个熊猫
        
        [self schedule:@selector(makePandaStaticOnGround:) interval:1.0f/60.0f];
        
        // 此处可添加其它音效，如果需要的话
        // 此处可添加动画或执行其它动作
        
        [currentBodyNode performSelector:@selector(fadeThenRemove) withObject:nil afterDelay:2.0f];  //在几秒钟后让熊猫淡出并消失
        
    }
}


//让熊猫在地面上成为静态物体

-(void) makePandaStaticOnGround:(ccTime)delta {
    
    currentBodyNode.body->SetType(b2_staticBody );
    currentBodyNode.body->SetTransform( currentBodyNode.body->GetPosition() , CC_DEGREES_TO_RADIANS( 0  )  );
    
    [self unschedule:_cmd];
}


#pragma mark 触摸事件处理

//开始触摸

-(void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    for( UITouch *touch in touches ) {
		CGPoint location = [touch locationInView: [touch view]];
		
		location = [[CCDirector sharedDirector] convertToGL: location];
        
        previousTouchLocationX = location.x;
        
        if ( throwInProgress == NO ) {
            
            currentBodyNode.body->SetType(b2_staticBody);
            
        }
    }
}

//触摸点移动

-(void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if ( autoPanningInProgress == YES) {
        
        [self cancelAutoPan];
    }
    
    
    
    //触摸交互
    
	for( UITouch *touch in touches ) {
		CGPoint location = [touch locationInView: [touch view]];
		
		location = [[CCDirector sharedDirector] convertToGL: location];
		
        
        // 移动弹弓中的熊猫。  如果场景在起始位置(self.position.x == 0) ，且还未开始抛投，而玩家手指正在弹弓周围触摸
        
        if (  ( [self checkCircleCollision:location :2 :slingShotCenterPosition:maxStretchOfSlingShot] == YES || slingShotPandaInHand == YES ) && throwInProgress == NO && areWeInTheStartingPosition == YES ) {
            
            if ( slingShotPandaInHand == NO) {
                
                positionInSling = slingShotCenterPosition;
                slingShotPandaInHand = YES;
                
                strapBack.visible = YES;
                strapFront.visible = YES;
                strapEmpty.visible = NO;
            }
            
            
            int currentAngle = currentBodyNode.body->GetAngle() ;
//            b2Vec2 bodyPos = currentBodyNode.body->GetWorldCenter();
            
            
            for( UITouch *touch in touches ) {
                CGPoint location = [touch locationInView: [touch view]];
                
                location = [[CCDirector sharedDirector] convertToGL: location];
                
                
                float radius = maxStretchOfSlingShot; //radius of slingShot
                
                GLfloat angle = [self calculateAngle:location.x :location.y :slingShotCenterPosition.x :slingShotCenterPosition.y] ;  //从弹弓中心到触摸位置的角度
                
                
                
                // 如果玩家在弹弓的最大拉伸半径范围内移动熊猫
                
                if ( [self checkCircleCollision:location :2 :slingShotCenterPosition: radius] == YES) {
                    
                    positionInSling = ccp(location.x , location.y);
                    
                    //根据触摸点和弹弓中心点的位置来判断弹弓皮带的缩放大小
                    
                    float scaleStrap =  (abs( slingShotCenterPosition.x - location.x )) / radius;
                    
                    scaleStrap = scaleStrap + 0.3;  //添加一点增量
                    
                    if ( scaleStrap > 1) {  //判断是否100%缩放
                        scaleStrap = 1;
                    }
                    
                    strapFront.scaleX = scaleStrap;
                    strapBack.scaleX = strapFront.scaleX ;  //弹弓的后部和前面是相同大小
                    
                    
                    
                } else {
                    // 如果玩家向弹弓的最大拉伸半径范围外移动熊猫
                    
                    GLfloat angleRadians = CC_DEGREES_TO_RADIANS (angle - 90);
                    positionInSling = ccp( slingShotCenterPosition.x - (cos(angleRadians) * radius) , slingShotCenterPosition.y + (sin(angleRadians) * radius) );
                    
                    strapFront.scaleX = 1;
                    strapBack.scaleX = 1;
                    
                    if(stretchBeyondRange ==0){
                        
                        //播放音效
                        if([GameData sharedData].soundEffectMuted  == NO){
                            [[SimpleAudioEngine sharedEngine]playEffect:@"slingshotstretch.mp3"];
                        }
                        
                        stretchBeyondRange++;
                    }
                    
                }
                
                strapFront.rotation = angle - 90;
                [self adjustBackStrap:(float)angle ];
                
                
                //设置熊猫物体的位置
                
                b2Vec2 locationInMeters = b2Vec2(positionInSling.x / PTM_RATIO, positionInSling.y / PTM_RATIO);
                
                
                currentBodyNode.body->SetTransform( locationInMeters , CC_DEGREES_TO_RADIANS( currentAngle));
                
            }
            
            
        }
        
        // 如果不满足以上条件则移动屏幕中的场景
        else {
            
            int amountToShiftScreen;
            
            int diff = (location.x - previousTouchLocationX); //起始（上一个）触摸点和当前触摸点的位置差别
            
            amountToShiftScreen = [self returnAmountToShiftScreen:diff];  //仅用于放置场景移动过多
            
            
            // 如果玩家手中没有熊猫，则将屏幕场景前后平移
            
            if ( self.position.x <= 0 && self.position.x >= worldMaxHorizontalShift && slingShotPandaInHand == NO  ) {
                
                areWeInTheStartingPosition = NO;
                
                [self moveScreen:(int)amountToShiftScreen];
                
                
                if (self.position.x > 0 ) { // 如果场景向左移动的过多，则重新设置到起始位置。
                    
                    [self putEverythingInStartingViewOfSlingShot];
                    
                    
                }
                
                else if (self.position.x < worldMaxHorizontalShift ) { // 如果场景向相反方向移动的过多，则重新设置到最大位置。
                    
                    [self putEverythingInViewOfTargets];
                    
                    
                }
            }
            
            
            
        }
        
        
        previousTouchLocationX = location.x;
	}
    
    
}

//触摸结束

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	//在触碰位置添加新的物体和精灵
    
	for( UITouch *touch in touches ) {
		CGPoint location = [touch locationInView: [touch view]];
		
		location = [[CCDirector sharedDirector] convertToGL: location];
		
        
        
        if (  slingShotPandaInHand == YES) {
            
            //播放音效
            
            if ([GameData sharedData].soundEffectMuted  == NO) {
                
                [[SimpleAudioEngine sharedEngine] playEffect:@"whoosh.mp3"];
                [[SimpleAudioEngine sharedEngine]playEffect:@"bird.mp3"];
                
            }
            
            //将所有障碍物转换为动态物体
            
            [self switchAllStackObjectsToDynamic];
            
            
            throwCount ++;
            dotCount = 0;
            
            throwInProgress = YES;
            
            currentBodyNode.body->SetType(b2_dynamicBody);
            currentBodyNode.body->SetAwake(true);
            
            
            strapBack.visible = NO;
            strapFront.visible = NO;
            strapEmpty.visible = YES;
            
            
            // 计算速度
            
            speed = (abs( slingShotCenterPosition.x - positionInSling.x )) + (abs( slingShotCenterPosition.y - positionInSling.y )) ;
            
            speed = speed / 5;
            
            speed = speed * multipyThrowPower;
            
            
            
            
            // targetPosition即触摸点
//            b2Vec2 targetInWorld = b2Vec2(location.x, location.y);
            
            // 判断熊猫的实际运动方向，从弹弓中心到触摸点
            
            b2Vec2 direction = b2Vec2(slingShotCenterPosition.x - location.x, slingShotCenterPosition.y - location.y);
            
            
            direction.Normalize();
            
            // 移动物体， 设置线性速度
            
            currentBodyNode.body->SetLinearVelocity( speed * direction );
            
            
            slingShotPandaInHand = NO;
            
            
            // 添加熊猫的运行轨迹白点
            
            [self removePreviousDots];
            
            dottingOn = YES;  //正在添加白点中
            
            [self schedule:@selector(placeWhiteDots:) interval:1.0f/45.0f];  //根据间隔增加或减少白点的密度
            
            
            //确保在6秒后将throwInProgress设置为NO
            
            [self unschedule:@selector(timerAfterThrow:)];
            [self schedule:@selector(timerAfterThrow:) interval:6.0f];
            
            if (location.x < slingShotCenterPosition.x ) {
                
                [self startScreenPanToTargetsWithAutoReverseOn];
                
            }
            
            
        }
        
        else if (continuePanningScreenOnFingerRelease == YES) {
            
            if ( panningTowardSling == YES) {
                
                [self startScreenPanToSling];
                
            } else {
                
                [self startScreenPanToTargets];
            }
            
        }
        
        
        
	}
    stretchBeyondRange =0;
}



//判断圆形间的碰撞

-(BOOL) checkCircleCollision:(CGPoint)center1  :(float)radius1  :(CGPoint) center2  :(float) radius2
{
    float a = center2.x - center1.x;
    float b = center2.y - center1.y;
    float c = radius1 + radius2;
    float distanceSqrd = (a * a) + (b * b);
    
    if (distanceSqrd < (c * c) ) {
        
        return YES;
    } else {
        return NO;
    }
    
}


//计算角度
- (GLfloat) calculateAngle:(GLfloat)x1 :(GLfloat)y1 :(GLfloat)x2 :(GLfloat)y2
{
    // DX
    GLfloat x = x2 - x1;
    
    // DY
    GLfloat y = y2 - y1;
    
    
    GLfloat angle = 180 + (atan2(-x, -y) * (180/M_PI));
    
    return angle;  //degrees
}


//返回平移场景的偏移量

-(int) returnAmountToShiftScreen:(int)diff {
    
    int amountToShiftScreen;
    
    
    
    if ( diff > 50) {
        
        amountToShiftScreen = 50;
        
    }  else if ( diff < -50) {
        
        amountToShiftScreen = -50;
        
    } else {
        
        amountToShiftScreen = diff ;
    }
    
    
    
    
    
    
    if (reverseHowFingerPansScreen == NO) {
        
        amountToShiftScreen = amountToShiftScreen * -1;
        
        
    }
    
    if ( amountToShiftScreen < 0 ) {
        
        panningTowardSling = YES;
        
    } else {
        
        panningTowardSling = NO;
    }
    
    
    return amountToShiftScreen;
}



//删除之前的白点

-(void) removePreviousDots {
    
    int someNum = 0;
    
    if (throwCount % 2){  //返回奇数
        
        
        
        while(someNum <= dotTotalOnOddNumberedTurn ) {
            
            [self removeChildByTag:tagForWhiteDotsOddNumberedTurn + someNum cleanup:NO];
            someNum ++;
            
            
        }
        
        dotTotalOnOddNumberedTurn = 0;
        
    } else { //返回偶数
        
        
        
        while(someNum <= dotTotalOnEvenNumberedTurn ) {
            
            [self removeChildByTag:tagForWhiteDotsEvenNumberedTurn + someNum cleanup:NO];
            someNum ++;
            
            
        }
        
        dotTotalOnEvenNumberedTurn = 0;
    }
    
    
}

//放置白色点

-(void) placeWhiteDots:(ccTime) delta {
    
    
    
    if (dottingOn == YES) {
        
        dotCount ++;
        
        CCSprite* whiteDot = [CCSprite spriteWithFile:@"circle.png"];
        
        if (throwCount % 2){  //奇数
            
            [self addChild:whiteDot z:zOrderWhiteDots tag:tagForWhiteDotsOddNumberedTurn + dotCount];
            dotTotalOnOddNumberedTurn = dotCount;
            
        } else {
            
            [self addChild:whiteDot z:zOrderWhiteDots tag:tagForWhiteDotsEvenNumberedTurn + dotCount];
            dotTotalOnEvenNumberedTurn = dotCount;
        }
        
        
        whiteDot.position = ccp( currentBodyNode.position.x , currentBodyNode.position.y);
        
        if (dotCount % 2){  //奇数
            
            whiteDot.scale = .5;
            
        }
        
        
    } else {
        
        [self unschedule:_cmd];
        
        
    }
    
}

//抛投后的计时器

-(void) timerAfterThrow:(ccTime) delta {
    
    // 当熊猫碰到地面时不会调用该方法
    // 但如果熊猫被卡在遮挡物上而没有击中地面，则调用该方法
    
    [self proceedToNextTurn:currentBodyNode];
    
    [self unschedule:_cmd];
}


#pragma mark 屏幕场景的平移

//启动场景向目标的平移

-(void) startScreenPanToTargets {
    
    panAmount = initialPanAmount;
    
    autoPanningInProgress = YES;
    autoReverseOn = NO;
    panningTowardSling = NO;
    
    [self unschedule:@selector(autoScreenPanToSling:)];
    [self schedule:@selector(autoScreenPanToTargets:) interval:1.0f/60.0f];
    
    if ( areWeOnTheIPad == NO ) {
        
        [self unschedule:@selector(moveScreenUp:)];
        [self schedule:@selector(moveScreenDown:) interval:1.0f/60.0f];
    }
    
}

//启动场景向目标的平移，此时启用自动转向

-(void) startScreenPanToTargetsWithAutoReverseOn {
    
    panAmount = initialPanAmount;
    
    autoPanningInProgress = YES;
    autoReverseOn = YES;
    panningTowardSling = NO;
    
    [self unschedule:@selector(autoScreenPanToSling:)];
    [self schedule:@selector(autoScreenPanToTargets:) interval:1.0f/60.0f];
    
    if ( areWeOnTheIPad == NO ) {
        [self unschedule:@selector(moveScreenUp:)];
        [self schedule:@selector(moveScreenDown:) interval:1.0f/60.0f];
    }
    
}


//屏幕场景自动向目标平移

-(void) autoScreenPanToTargets:(ccTime)delta {
    
    if (panAmount > 3 ) {
        
        panAmount = panAmount - .5;
        
    }
    
    
    if ( self.position.x > worldMaxHorizontalShift ) {
        
        
        if (  self.position.x > worldMaxHorizontalShift && self.position.x < worldMaxHorizontalShift + 50) {  //slows down panning when close to finishing
            
            [self moveScreen:3 ];
            
        } else {
            
            [self moveScreen:panAmount];
        }
        
        
        
    } else {
        
        [self unschedule:_cmd];
        [self putEverythingInViewOfTargets];
        
        if ( autoReverseOn == YES) {
            
            [self schedule:@selector(startScreenPanToSlingIfScoringIsNotOccuring:) interval:2.0f];
        }
    }
    
}


//如果没有得分，则启用屏幕场景向弹弓的平移

-(void) startScreenPanToSlingIfScoringIsNotOccuring:(ccTime)delta {
    
    if ( somethingJustScored == NO) {
        
        
        [self startScreenPanToSling];
        [self unschedule:_cmd];
    } else {
        
        
    }
    
}

//启用屏幕场景向弹弓的平移

-(void) startScreenPanToSling {
    
    panAmount = initialPanAmount + extraAmountOnPanBack;
    
    autoPanningInProgress = YES;
    panningTowardSling = YES;
    
    [self unschedule:@selector(autoScreenPanToTargets:)];
    [self schedule:@selector(autoScreenPanToSling:) interval:1.0f/60.0f];
    
    if ( areWeOnTheIPad == NO ) {
        
        [self unschedule:@selector(moveScreenDown:)];
        [self schedule:@selector(moveScreenUp:) interval:1.0f/60.0f];
    }
    
}

//场景自动向弹弓平移

-(void) autoScreenPanToSling:(ccTime)delta {
    
    if (panAmount > 3 ) {
        
        panAmount = panAmount - .5;
        
    }
    
    if ( self.position.x < 0 ) {
        
        
        if (  self.position.x < 0 && self.position.x > -50) {  //slows down panning when close to finishing
            
            [self moveScreen:-3 ];
            
        } else {
            
            [self moveScreen:(panAmount * -1) ];
        }
        
        
        
    } else {
        
        [self unschedule:_cmd];
        [self putEverythingInStartingViewOfSlingShot];
        
        
        
        autoPanningInProgress = NO;
        self.scale = 1;
    }
    
}

//取消自动平移

-(void) cancelAutoPan {
    
    autoPanningInProgress = NO;
    [self unschedule:@selector(autoScreenPanToSling:)];
    [self unschedule:@selector(autoScreenPanToTargets:)];
    [self unschedule:@selector(startScreenPanToSlingIfScoringIsNotOccuring:)];
}


//按一定增量移动场景

-(void) moveScreen:(int)amountToShiftScreen {
    
    self.position = ccp( self.position.x - amountToShiftScreen, self.position.y  );
    
    if (areWeOnTheIPad == YES) { //看起来标签保持在原位置，实际上整个层都在移动
        
        pauseButtonMenu.position = ccp( pauseButtonMenu.position.x + amountToShiftScreen, pauseButtonMenu.position.y );
        currentScoreLabel.position = ccp( currentScoreLabel.position.x + amountToShiftScreen, currentScoreLabel.position.y  );
          }
    
    //背景云彩和粒子系统移动的视觉效果
    
    backgroundLayerHills.position = ccp( backgroundLayerHills.position.x + (amountToShiftScreen * .5), backgroundLayerHills.position.y  );
    backgroundLayerClouds.position = ccp( backgroundLayerClouds.position.x + (amountToShiftScreen * .75 ), backgroundLayerClouds.position.y  );
    system.position = ccp( system.position.x + (amountToShiftScreen * .75), system.position.y  );
    
    
    // 处理缩放
    
    if (amountToShiftScreen > 0) { //等比缩小
        
        if ( self.scale > maxScaleDownValue) {
            
            self.scale = self.scale - scaleAmount;
            
        }
        
        
        
    } else { //等比放大
        
        if ( self.scale < 1) {
            
            self.scale = self.scale + scaleAmount;
            
        }
        
    }
    
    
    
    
    
    
}

//重置所有场景元素到弹弓起始视角

-(void) putEverythingInStartingViewOfSlingShot {
    
    self.position = ccp( 0, 0  );
    
    pauseButtonMenu.position = pauseButtonPosition;

    system.position = particleSystemStartPosition;
    backgroundLayerClouds.position = cloudLayerStartPosition;
    backgroundLayerHills.position = hillsLayerStartPosition;
    
    self.scale = 1;
    
    areWeInTheStartingPosition = YES;
    
}

//将所有场景元素放置到目标视角

-(void) putEverythingInViewOfTargets {
    
    self.position = ccp( worldMaxHorizontalShift, adjustY );
    
    if (areWeOnTheIPad == YES) {  //在iPad中不存在缩放
        pauseButtonMenu.position = ccp( pauseButtonPosition.x - worldMaxHorizontalShift, pauseButtonMenu.position.y );
        currentScoreLabel.position = ccp(currentScoreLabelPosition.x - worldMaxHorizontalShift , currentScoreLabel.position.y );
      
    }
    
    
    backgroundLayerHills.position = ccp(hillsLayerStartPosition.x - (worldMaxHorizontalShift * .5), backgroundLayerHills.position.y  );
    backgroundLayerClouds.position = ccp( cloudLayerStartPosition.x - (worldMaxHorizontalShift * .75), backgroundLayerClouds.position.y  );
    system.position = ccp( particleSystemStartPosition.x - (worldMaxHorizontalShift * .75) , system.position.y );
    
    
    if ( self.scale < maxScaleDownValue) {
        
        self.scale = maxScaleDownValue;
        
    }
    
    areWeInTheStartingPosition = NO;
}

//让场景上移

-(void) moveScreenUp:(ccTime) delta {
    
    
    
    if ( self.position.y < 0 ) {
        
        self.position = ccp( self.position.x , self.position.y + 2 );
        
        
    } else {
        
        self.position = ccp( self.position.x , 0 );
        
        [self unschedule:_cmd];
    }
    
    
}

//让场景下移

-(void) moveScreenDown:(ccTime) delta {
    
    
    
    if ( self.position.y > adjustY) {
        
        self.position = ccp( self.position.x , self.position.y - 2 );
        
        
    } else {
        
        self.position = ccp( self.position.x , adjustY );
        [self unschedule:_cmd];
    }
    
    
    
}




#pragma mark 游戏分值



//辅助方法，当有得分时调用

-(void)somethingJustScored {
    
    
    somethingJustScored = YES;
    
    [self unschedule:@selector(resetSomethingJustScored)];
    [self schedule:@selector(resetSomethingJustScored:) interval:3.0f];
    
}

//重置得分后的属性

-(void)resetSomethingJustScored:(ccTime) delta {
    
    somethingJustScored = NO;
    [self unschedule:_cmd];
}


//显示得分

-(void) showPoints:(int) pointValue positionToShowScore:(CGPoint)positionToShowScore  theSimpleScore:(int)theSimpleScore{
    
    scoreForCurrentLevel = scoreForCurrentLevel + pointValue;
    [self updatePointsLabel];
    
    [self somethingJustScored];
    
    [self showPointsWithImagesForValue:pointValue positionToShowScore:positionToShowScore];
    
}


//使用分值图片来显示得分

-(void) showPointsWithImagesForValue:(int) pointValue positionToShowScore:(CGPoint)positionToShowScore  {
    
    
    CCSprite* scoreLabel;
    
    if (pointValue == 100) {
        
        scoreLabel = [CCSprite spriteWithFile:@"100points.png"];
    }
    else if (pointValue == 500) {
        
        scoreLabel = [CCSprite spriteWithFile:@"500points.png"];
    }
    else if (pointValue == 1000) {
        
        scoreLabel = [CCSprite spriteWithFile:@"1000points.png"];
    }
    else if (pointValue == 5000) {
        
        scoreLabel = [CCSprite spriteWithFile:@"5000points.png"];
    }  
    else if (pointValue == 10000) {
        
        scoreLabel = [CCSprite spriteWithFile:@"10000points.png"];
    } 
    else { 
        
        scoreLabel = [CCSprite spriteWithFile:@"100points.png"];
        
    }
    
    
    [self addChild:scoreLabel z:zOrderPointScore];
    scoreLabel.position = positionToShowScore;
    
    
    CCMoveTo* moveAction = [CCMoveTo actionWithDuration:1.0f position:ccp ( scoreLabel.position.x  , scoreLabel.position.y + 25 )];
    
    [scoreLabel runAction:moveAction];
    
    CCSequence *seq = [CCSequence actions:
                       [CCFadeTo actionWithDuration:1.5f opacity:20.0f],          
                       [CCCallFuncN actionWithTarget:self selector:@selector(removeThisChild:)], nil];
    
    [scoreLabel runAction:seq];
    
}


//删除子节点

-(void) removeThisChild:(id)sender {
    
    
    CCSprite *theSprite = (CCSprite *)sender;
    
	[self removeChild:theSprite cleanup:YES];
    
    
    
}


//删除标签

-(void) removeThisLabel:(id)sender {
    
    
    CCLabelTTF *theLabel = (CCLabelTTF *)sender;
    
	[self removeChild:theLabel cleanup:YES];
    
    
    
}


//调整弹弓的皮带

-(void) adjustBackStrap:(float)angle  {
    
    
    
    if (angle < 30) {
        
        
        strapBack.scaleX = strapBack.scaleX * 1.0;
        strapBack.rotation = strapFront.rotation * .8;
        
    } else if (angle < 60) {
        
        
        strapBack.scaleX = strapBack.scaleX * 1.05;
        strapBack.rotation = strapFront.rotation * .80;
        
    } else if (angle < 90) {
        
        
        strapBack.scaleX = strapBack.scaleX * 1.1;
        strapBack.rotation = strapFront.rotation * .85;
        
    } else if (angle < 120) {
        
        
        strapBack.scaleX = strapBack.scaleX * 1.2;
        strapBack.rotation = strapFront.rotation * .95;
        
    } else if (angle < 150) {
        
        
        strapBack.scaleX = strapBack.scaleX * 1.2;
        strapBack.rotation = strapFront.rotation * .9;
        
    } 
    
    else if (angle < 180) {
        
        
        strapBack.scaleX = strapBack.scaleX * 1.10;
        strapBack.rotation = strapFront.rotation * .85;
        
    } 
    else if (angle < 210) {
        
        
        strapBack.scaleX = strapBack.scaleX * .95;
        strapBack.rotation = strapFront.rotation * .85;
        
    } 
    else if (angle < 240) {
        
        
        strapBack.scaleX = strapBack.scaleX * .7;
        strapBack.rotation = strapFront.rotation * .85;
        
    }
    
    else if (angle < 270) {
        
        
        strapBack.scaleX = strapBack.scaleX * .6;
        strapBack.rotation = strapFront.rotation * .9;
        
    } 
    
    else if (angle < 300) {
        
        
        strapBack.scaleX = strapBack.scaleX * .5;
        strapBack.rotation = strapFront.rotation * 1.0;
        
    }
    else if (angle < 330) {
        
        
        strapBack.scaleX = strapBack.scaleX * .6;
        strapBack.rotation = strapFront.rotation * 1.1;
        
    }
    
    else if (angle < 360) {
        
        
        strapBack.scaleX = strapBack.scaleX * .6;
        strapBack.rotation = strapFront.rotation * 1.1;
    }
    
    
}



#pragma mark 重置游戏或进入下一关卡

//为剩下的熊猫获得额外奖励得分

-(void) provideBonusForLeftPandas {
    
    
    int pandasLeft = (pandasToTossThisLevel - pandaBeingThrown) + 1;
    
    bonusThisRound = ( bonusPerLeftPanda * pandasLeft);
    scoreForCurrentLevel = scoreForCurrentLevel  + bonusThisRound ;
    [self updatePointsLabel];
    
}



//进入显示当前关卡的游戏结果界面

-(void) showLevelResult {
    
        GameData *data = [GameData sharedData];
    
    if ( scoreForCurrentLevel >= scoreToPassLevel ) {
         levelClear = YES;
        
        [self provideBonusForLeftPandas];
        

        data.currentLevelScore = scoreForCurrentLevel;
        data.currentLevelSolved = YES;
        
        [[GameData sharedData] setHighScoreForCurrentLevel:scoreForCurrentLevel]; //设置最高得分        
        

        [[SimpleAudioEngine sharedEngine]playEffect:@"levelwin.mp3"];
        
    } else {
        
        levelClear = NO;
        [[GameData sharedData] setHighScoreForCurrentLevel:scoreForCurrentLevel]; //即便未能通过关卡也会设置最高得分

        data.currentLevelScore = scoreForCurrentLevel;
        data.currentLevelSolved = NO;
        
         [[SimpleAudioEngine sharedEngine]playEffect:@"levelfailure.mp3"];
        
    }
    
    //保存关卡的信息
    
    Levels *selectedLevels = [LevelParser loadLevelsForChapter:data.selectedChapter];
    
    // Iterate through the array of levels
    for (Level *level in selectedLevels.levels) {
        
        // look for currently selected level
        if (level.number == data.selectedLevel)
        {
            
            [level setLevelClear:levelClear];
            [level setNumber:data.selectedLevel];
            
            
     }
        //如果当前关卡编号不为10，则将下一关卡解锁
        
        if(data.selectedLevel !=10)
        {
            
            if(level.number == data.selectedLevel +1)
            {
                
                if(levelClear)
                {
                    [level setUnlocked:YES];
                }
            }
        }
        
    }
    
    // Write the new xml
    [LevelParser saveData:selectedLevels forChapter:data.selectedChapter];

    
    [self performSelector:@selector(jumpToLevelResultScene) withObject:nil afterDelay:6.5f];
    
}




//切换到关卡场景


-(void) jumpToLevelResultScene {
 
    [SceneManager goLevelResult];
}


//释放内存

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
    
    // delete contactListener;
	//contactListener = NULL;
    
	// in case you have something to dealloc, do it in this method
	//delete world;
	//world = NULL;
	
	//delete m_debugDraw;
    
	// don't forget to call "super dealloc"
	[super dealloc];
}
@end

