#import "ActionLayer.h"

#import "SimpleAudioEngine.h"
#import "CCParallaxNode-Extras.h"
#import "Constants.h"

@interface ActionLayer()

//场景初始化
- (void)setupBackground;


- (void)playTapped;
- (void)setupTitle;
-(void)invisNode:(CCNode*)sender;
- (void)setupBatchNode;
-(void)spawnPlayer;

- (void)setupArrays;
-(void)updateGroundObstacles:(ccTime)dt;
-(void)updateAirObstacles:(ccTime)dt;
-(void)updateCoins:(ccTime)dt;
- (void)updateMissles:(ccTime)dt;
-(void)updateAid:(ccTime)dt;

- (void)updatePlayerPos:(ccTime)dt;

//碰撞与游戏逻辑
-(void)updateGameStatus:(ccTime)dt;
-(void)setupTime;
- (void)updateCollisions:(ccTime)dt;
- (void)restartTapped:(id)sender;
- (void)endScene:(EndReason)endReason;

-(void)setupSound;

@end


@implementation ActionLayer


+(id)scene{
  
  CCScene *scene =[CCScene node];
  ActionLayer*layer = [ActionLayer node];
  [scene addChild:layer];
  return scene;
  
}


#pragma mark 添加背景

//添加滚动背景
- (void)setupBackground {
  
  CGSize winSize = [CCDirector sharedDirector].winSize;
  
  // 1) 创建 CCParallaxNode视差滚动节点
  backgroundNode = [CCParallaxNode node];
  [self addChild:backgroundNode z:-2];
  
  // 2) 创建需要添加到CCParallaxNode视差滚动节点的精灵对象
  
  
  mainBg = [CCSprite spriteWithFile:@"bg.png"];
  [[mainBg texture]setAliasTexParameters];
  mainBg2 =[CCSprite spriteWithFile:@"grass.png"];
 [[mainBg2 texture]setAliasTexParameters];
  
  cloud1 = [CCSprite spriteWithFile:@"bg_cloud_1.png"];
  cloud2 = [CCSprite spriteWithFile:@"bg_cloud_2.png"];
  cloud3 = [CCSprite spriteWithFile:@"bg_cloud_3.png"];
  
  
  // 3) 设置云彩的浮动速度 和背景速度
  CGPoint cloudSpeed = ccp(0.1,0.1);
  CGPoint bgSpeed = ccp(0.05, 0.05);

  
  // 4) 将精灵对象添加为CCParallaxNode视差滚动节点的子节点
  [backgroundNode addChild:cloud1 z:0 parallaxRatio:cloudSpeed positionOffset:ccp(0,winSize.height*0.6)];
  [backgroundNode addChild:cloud2 z:0 parallaxRatio:cloudSpeed positionOffset:ccp(winSize.width*0.5,winSize.height*0.7)];
  [backgroundNode addChild:cloud3 z:0 parallaxRatio:cloudSpeed positionOffset:ccp(winSize.width*0.9,winSize.height*0.8)];
  [backgroundNode addChild:mainBg z:-1
             parallaxRatio:bgSpeed
            positionOffset:ccp(200,winSize.height*0.5)];
  [backgroundNode addChild:mainBg2 z:0 parallaxRatio:bgSpeed positionOffset:ccp(winSize.width*0.5,0)];
}

#pragma mark 实时更新背景



//更新背景内容
- (void)updateBackground:(ccTime)dt {
  CGSize size = [CCDirector sharedDirector].winSize;

 CGPoint backgroundScrollVel = ccp(-size.width, 0);
  backgroundNode.position =
 ccpAdd(backgroundNode.position,
        ccpMult(backgroundScrollVel, dt));
 CGSize winSize = [CCDirector sharedDirector].winSize;
 
 
 NSArray *backgrounds = [NSArray arrayWithObjects:mainBg, mainBg2, cloud1, cloud2,cloud3, nil];
 for (CCSprite *background in backgrounds) {
  if ([backgroundNode convertToWorldSpace:background.position].x < -background.contentSize.width) {
     
    backgroundNode.position = ccp(winSize.width*4,0);
   }
  }
  
    

}


#pragma mark 菜单选项及玩家角色

//点按菜单后的操作

- (void)playTapped{
  
  
  NSArray * nodes = [NSArray arrayWithObjects:titleLabel1, titleLabel2, playItem, nil];
  for (CCNode *node in nodes) {
    [node runAction:
     [CCSequence actions:
      [CCEaseOut actionWithAction:
       [CCScaleTo actionWithDuration:0.5 scale:0] rate:4.0],
      [CCCallFuncN actionWithTarget:self selector:@selector(invisNode:)],
      nil]];
  }
    
  [self spawnPlayer];
  
    [self setupTime];
  
}


//设置游戏菜单
- (void)setupTitle {
  
  CGSize winSize = [CCDirector sharedDirector].winSize;
  
  NSString *fontName = @"Arial.fnt";
  
  //添加文本标签1
  titleLabel1 = [CCLabelBMFont labelWithString:@"Angel Panda" fntFile:fontName];


  titleLabel1.scale = 0;
  titleLabel1.position = ccp(winSize.width/2, winSize.height * 0.8);
  [self addChild:titleLabel1 z:100];
  [titleLabel1 runAction:
   [CCEaseOut actionWithAction:
    [CCScaleTo actionWithDuration:1.0 scale:1.5] rate:4.0]];
  
  //添加文本标签2
  titleLabel2 = [CCLabelBMFont labelWithString:@"The Way Home" fntFile:fontName];

    
  titleLabel2.position = ccp(winSize.width/2, winSize.height * 0.65);
  titleLabel2.scale = 0;
  [self addChild:titleLabel2 z:100];
  [titleLabel2 runAction:
   [CCSequence actions:
    [CCDelayTime actionWithDuration:1.0],
    [CCEaseOut actionWithAction:
     [CCScaleTo actionWithDuration:1.0 scale:1.5] rate:4.0],
    nil]];
  
  
  CCLabelBMFont *playLabel = [CCLabelBMFont labelWithString:@"Play" fntFile:fontName];

    
  playItem = [CCMenuItemLabel itemWithLabel:playLabel target:self selector:@selector(playTapped)];
  playItem.scale = 0;
  playItem.position = ccp(winSize.width/2, winSize.height * 0.5);
  
  CCMenu *menu = [CCMenu menuWithItems:playItem, nil];
  menu.position = CGPointZero;
  [self addChild:menu];
  
  [playItem runAction:
   [CCSequence actions:
    [CCDelayTime actionWithDuration:2.0],
    [CCEaseOut actionWithAction:
     [CCScaleTo actionWithDuration:0.5 scale:1.5] rate:4.0],
    nil]];
  
}

//让节点对象隐形
-(void)invisNode:(CCNode*)sender{
  
  sender.visible = FALSE;
}

//添加精灵表单
- (void)setupBatchNode {
  
  batchNode = [CCSpriteBatchNode batchNodeWithFile:@"panda.png"];
  [self addChild:batchNode z:-1];
  [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"panda.plist"];
}

//让玩家角色出现

-(void)spawnPlayer{
  
  CGSize winSize = [CCDirector sharedDirector].winSize;
  
  player = [CCSprite spriteWithSpriteFrameName:@"panda_1.png"];
  player.position = ccp(-player.contentSize.width/2,16+ player.contentSize.height/2);
  [batchNode addChild:player z:1];
  
  [player runAction:
   [CCSequence actions:
    [CCEaseOut actionWithAction:
     [CCMoveBy actionWithDuration:0.5
                         position:ccp(player.contentSize.width/2 + winSize.width*0.6, 0)]
                           rate:4.0],
    [CCEaseInOut actionWithAction:
     [CCMoveBy actionWithDuration:0.5
                         position:ccp(-winSize.width*0.1, 0)]
                             rate:4.0],
    nil]];
  
  NSMutableArray *animFrames = [NSMutableArray arrayWithCapacity:2];
  
  for(int i=1; i<2;i++){
    
    NSString *frameName = [NSString stringWithFormat:@"panda_%d.png",i];
    CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:frameName];
    [animFrames addObject:frame];
    
  }
  
  CCAnimation *animation = [CCAnimation animationWithSpriteFrames:animFrames delay:0.2];
  [player runAction:[CCRepeatForever actionWithAction:
                     [CCAnimate actionWithAnimation:animation]]];
  
}

//添加随机函数
float randomValueBetween(float low, float high) {
  return (((float) arc4random() / 0xFFFFFFFFu)
          * (high - low)) + low;
}
//初始化精灵数组
- (void)setupArrays {
  missleArray = [[SpriteArray alloc] initWithCapacity:30 spriteFrameName:@"missle.png" batchNode:batchNode];
  groundObjectsArray = [[SpriteArray alloc] initWithCapacity:30 spriteFrameName:@"carrot.png" batchNode:batchNode];
  airObjectsArray = [[SpriteArray alloc] initWithCapacity:30 spriteFrameName:@"plane3.png" batchNode:batchNode];
  coinsArray = [[SpriteArray alloc] initWithCapacity:30 spriteFrameName:@"coin.png" batchNode:batchNode];
  aidArray =[[SpriteArray alloc] initWithCapacity:30 spriteFrameName:@"aid.png" batchNode:batchNode];
}
//添加地面怪物
-(void)updateGroundObstacles:(ccTime)dt{
  
  CGSize winSize = [CCDirector sharedDirector].winSize;
  // 判断是否是添加地面怪物的时间？
  curTime = CACurrentMediaTime();
  if (curTime > nextGroundObstacleSpawn) {
    
    // 确认下一次出现地面怪物的时间
    float randSecs = randomValueBetween(3.0, 5.0);
    nextGroundObstacleSpawn = randSecs + curTime;
    // 计算一个让怪物穿越屏幕的随机时间
    float randDuration = randomValueBetween(1.5, 2.0);
    
    // 创建一个新的怪物精灵
    CCSprite *groundObject = [groundObjectsArray nextSprite];
    [groundObject stopAllActions];
    groundObject.visible = YES;
    
    // 设置其初始位置
    groundObject.position = ccp(winSize.width+groundObject.contentSize.width/2, groundObject.contentSize.height/2);
    
    // 设置一个随机大小
    int randNum = arc4random() % 3;
    if (randNum == 0) {
      groundObject.scale = 0.5;
    } else if (randNum == 1) {
      groundObject.scale = 0.8;
    } else {
      groundObject.scale = 1.2;
    }
    
    
    id delayTime = [CCDelayTime actionWithDuration:4.0f];
    
    [groundObject runAction:
     [CCSequence actions:
      delayTime,
      [CCMoveBy actionWithDuration:randDuration position:ccp(-winSize.width-groundObject.contentSize.width, 0)],
      [CCCallFuncN actionWithTarget:self selector:@selector(invisNode:)],
      nil]];
  }
  
}


//添加空中攻击玩家的飞机
-(void)updateAirObstacles:(ccTime)dt{
  
  CGSize winSize = [CCDirector sharedDirector].winSize;
  // 判断是否是出现飞机的时间
  curTime = CACurrentMediaTime();
  if (curTime > nextAirObstacleSpawn) {
    
    // 确认下一次出现飞机的时间
    float randSecs = randomValueBetween(3.0, 5.0);
    nextAirObstacleSpawn = randSecs + curTime;
    
    // 计算一个随机的Y坐标
    float randY = randomValueBetween(0.0,
                                     winSize.height);
    // 计算一个飞机横穿屏幕的随机时间
    float randDuration = randomValueBetween(1.5, 2.0);
    
    // 创建一个新的飞机精灵
    CCSprite *airObject = [airObjectsArray nextSprite];
    [airObject stopAllActions];
    airObject.visible = YES;
    
    // 设置初始位置
    airObject.position = ccp(winSize.width+airObject.contentSize.width/2, randY);
    
    // 设置随机大小
    int randNum = arc4random() % 3;
    if (randNum == 0) {
      airObject.scale = 0.5;
    } else if (randNum == 1) {
      airObject.scale = 0.8;
    } else {
      airObject.scale = 1.0;
    }
    
    // 让其穿过屏幕，然后消失
    
    id delayTime = [CCDelayTime actionWithDuration:4.0f];
    
    [airObject runAction:
     [CCSequence actions:
      delayTime,
      [CCMoveBy actionWithDuration:randDuration position:ccp(-winSize.width-airObject.contentSize.width, 0)],
      [CCCallFuncN actionWithTarget:self selector:@selector(invisNode:)],
      nil]];
    
  }
}

//添加奖赏玩家的金币
-(void)updateCoins:(ccTime)dt{
  
  CGSize winSize = [CCDirector sharedDirector].winSize;
  // 判断是否该出现金币？
  curTime = CACurrentMediaTime();
  if (curTime > nextCoinSpawn) {
    
    // 计算下一次出现金币的随机时间
    float randSecs = randomValueBetween(3.0, 6.0);
    nextCoinSpawn = randSecs + curTime;
    
    // 计算一个随机的y坐标
    float randY = randomValueBetween(winSize.height/2,
                                     winSize.height-100);
    
    float randCoinNumber = randomValueBetween(2.0, 5.0);
    //    int randNumber =int(randCoinNumber);
    
    // 计算金币穿越屏幕的随机时间
    float randDuration = randomValueBetween(3.5, 5.0);
    
    // 创建一堆金币
    for (int i=1;i<=randCoinNumber;i++)
      for (int j=1;j<=randCoinNumber;j++){
        CCSprite *coins = [coinsArray nextSprite];
        [coins stopAllActions];
        coins.visible = YES;
        
        
        // 设置其初始位置
        coins.position = ccp(winSize.width+coins.contentSize.width/2+30*i, randY+30*j);
        
        // 让金币穿越屏幕，然后消失
        
        [coins runAction:
         [CCSequence actions:
          
          [CCMoveBy actionWithDuration:randDuration position:ccp(-winSize.width-coins.contentSize.width, 0)],
          [CCCallFuncN actionWithTarget:self selector:@selector(invisNode:)],
          nil]];
        
      }
  }
}

//添加攻击玩家的导弹
- (void)updateMissles:(ccTime)dt {
  CGSize winSize = [CCDirector sharedDirector].winSize;
  BOOL firstSpawn;
  // 判断是否是出现导弹的时间
  curTime = CACurrentMediaTime();
  if (curTime > nextMissleSpawn) {
    
    // 计算下一次出现导弹的时间
    float randSecs = randomValueBetween(15.0, 18.0);
    nextMissleSpawn = randSecs + curTime;
    
    // 计算一个随机的y坐标
    float randY = randomValueBetween(0.0,
                                     winSize.height);
    
    // 计算让导弹飞过屏幕的随机时间
    float randDuration = randomValueBetween(0.3, 0.5);
    
    // 创建一个新的导弹精灵
    CCSprite *missle = [missleArray nextSprite];
    [missle stopAllActions];
    missle.visible = YES;
    
    // 设置其初始位置
    missle.position = ccp(winSize.width+missle.contentSize.width/2, randY);
    
    // 设置其随机大小
    int randNum = arc4random() % 3;
    if (randNum == 0) {
      missle.scale = 0.5;
    } else if (randNum == 1) {
      missle.scale = 0.7;
    } else {
      missle.scale = 0.8;
    }
    if(firstSpawn!=NO){
      //play sound
    }
    
    
    // 让导弹穿过屏幕然后消失
    
    id delayTime = [CCDelayTime actionWithDuration:4.0f];
    [missle runAction:
     [CCSequence actions:
      delayTime,
      [CCMoveBy actionWithDuration:randDuration position:ccp(-winSize.width-missle.contentSize.width, 0)],
      [CCCallFuncN actionWithTarget:self selector:@selector(invisNode:)],
      nil]];
    
  }
  firstSpawn = YES;
}
//添加对玩家提供疗伤的急救包
- (void)updateAid:(ccTime)dt {
  CGSize winSize = [CCDirector sharedDirector].winSize;
  
  // 判断是否出现急救包
  curTime = CACurrentMediaTime();
  if (curTime > nextAid) {
    
    // 计算下一次出现急救包的时间
    float randSecs = randomValueBetween(18.0, 20.0);
    nextAid = randSecs + curTime;
    
    // 计算一个随机的y坐标
    float randY = randomValueBetween(0.0,
                                     winSize.height);
    
    // 计算急救包穿过屏幕的随机时间
    float randDuration = randomValueBetween(2.5, 4.0);
    
    // 创建一个新的急救包精灵
    CCSprite *aid = [aidArray nextSprite];
    [aid stopAllActions];
    aid.visible = YES;
    
    // 设置其初始位置
    aid.position = ccp(winSize.width+aid.contentSize.width/2, randY);
    
    // 设置其随机大小
    int randNum = arc4random() % 3;
    if (randNum == 0) {
      aid.scale = 0.45;
    } else if (randNum == 1) {
      aid.scale = 0.65;
    } else {
      aid.scale = 0.9;
    }
    
    
    // 让急救包穿过屏幕然后消失
    
    id delayTime = [CCDelayTime actionWithDuration:4.0f];
    [aid runAction:
     [CCSequence actions:
      delayTime,
      [CCMoveBy actionWithDuration:randDuration position:ccp(-winSize.width-aid.contentSize.width, 0)],
      [CCCallFuncN actionWithTarget:self selector:@selector(invisNode:)],
      nil]];        
    
  }
}
-(void)updateGameStatus:(ccTime)dt{
  if (lives <= 0) {
    [player stopAllActions];
    player.visible = FALSE;
    [self endScene:kEndReasonLose];
  } else if (curTime >= gameOverTime) {
    [self endScene:kEndReasonWin];
  }
}
-(void)setupTime{
  
 
  curTime = CACurrentMediaTime();
  gameOverTime = curTime + 30.0;
      isGameStarted = YES;

}


//简单的碰撞检测
- (void)updateCollisions:(ccTime)dt {
  
  for (CCSprite *coins in coinsArray.array) {
    if (!coins.visible) continue;
    
    if(CGRectIntersectsRect(coins.boundingBox, player.boundingBox)){
      coins.visible = NO;
      score +=100;
      [[SimpleAudioEngine sharedEngine]playEffect:@"coin.mp3" pitch:1.0f pan:0.0f gain:0.25f];
    }
  }
  
  for (CCSprite *missle in missleArray.array){
    if(!missle.visible)continue;
    if(CGRectIntersectsRect(missle.boundingBox, player.boundingBox)){
      [[SimpleAudioEngine sharedEngine] playEffect:@"angry_girl.mp3" pitch:1.0f pan:0.0f gain:0.25f];
      missle.visible = NO;
      [player runAction:[CCBlink actionWithDuration:1.0 blinks:9]];
      lives-=2;
    }
  }
  
  for (CCSprite *groundObject in groundObjectsArray.array){
    if(!groundObject.visible)continue;
    if(CGRectIntersectsRect(groundObject.boundingBox, player.boundingBox)){
      [[SimpleAudioEngine sharedEngine] playEffect:@"angry_girl.mp3" pitch:1.0f pan:0.0f gain:0.25f];
      groundObject.visible = NO;
      [player runAction:[CCBlink actionWithDuration:1.0 blinks:9]];
      lives--;
    }
  }
  for (CCSprite *airObject in airObjectsArray.array){
    if(!airObject.visible)continue;
    if(CGRectIntersectsRect(airObject.boundingBox, player.boundingBox)){
      [[SimpleAudioEngine sharedEngine] playEffect:@"angry_girl.mp3" pitch:1.0f pan:0.0f gain:0.25f];
      airObject.visible = NO;
      [player runAction:[CCBlink actionWithDuration:1.0 blinks:9]];
      lives--;
    }
  }
  
  for (CCSprite *aid in aidArray.array){
    if(!aid.visible)continue;
    if(CGRectIntersectsRect(aid.boundingBox, player.boundingBox)){
      [[SimpleAudioEngine sharedEngine] playEffect:@"mother.mp3" pitch:1.0f pan:0.0f gain:0.25f];
      aid.visible = NO;
      //      [player runAction:[CCBlink actionWithDuration:1.0 blinks:9]];
      lives++;
    }
  }
  
}

//重启游戏
- (void)restartTapped:(id)sender {
    
  [[CCDirector sharedDirector] replaceScene:[ActionLayer scene]];
    
}


//游戏结束画面
- (void)endScene:(EndReason)endReason {
  
  if (gameOver) return;
  gameOver = true;
    
    isGameStarted = NO;
  
  CGSize winSize = [CCDirector sharedDirector].winSize;
  
  NSString *message;
  if (endReason == kEndReasonWin) {
    [[SimpleAudioEngine sharedEngine]playEffect:@"babylaugh.mp3"];
    message = @"You win!";
  } else if (endReason == kEndReasonLose) {
    message = @"You lose!";
    [[SimpleAudioEngine sharedEngine]playEffect:@"babycry.mp3"];
  }
  
  CCLabelBMFont *label;
  
  label = [CCLabelBMFont labelWithString:message fntFile:@"Arial.fnt"];
  
  label.scale = 0.1;
  label.position = ccp(winSize.width/2, winSize.height * 0.6);
  [self addChild:label];
  
  CCLabelBMFont *restartLabel;
  
  restartLabel = [CCLabelBMFont labelWithString:@"Restart" fntFile:@"Arial.fnt"];
  
  
  CCMenuItemLabel *restartItem = [CCMenuItemLabel itemWithLabel:restartLabel target:self selector:@selector(restartTapped:)];
  restartItem.scale = 0.1;
  restartItem.position = ccp(winSize.width/2, winSize.height * 0.4);
  
  CCMenu *menu = [CCMenu menuWithItems:restartItem, nil];
  menu.position = CGPointZero;
  [self addChild:menu];
  
  [restartItem runAction:[CCScaleTo actionWithDuration:0.5 scale:1.0]];
  [label runAction:[CCScaleTo actionWithDuration:0.5 scale:1.0]];
  
}

//设置声音
-(void)setupSound{
  
  
  [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"begin.mp3" loop:YES];
}

#pragma mark 设置游戏初始化数据

-(void)setGameData{
    isGameStarted = NO;
    lives = 10;
    offset =1;
}

#pragma mark 初始化

//初始化方法
-(id)init{
  
  if((self  =[super init])){
      
      
        [self setGameData];
      
     

        [self setupBackground];
          
        [self setupBatchNode];
        [self setupTitle];
        [self setupArrays];
        [self setupSound];
 
        self.isTouchEnabled = YES;
      
        [self scheduleUpdate];


  }
  return self;
}

//使用触摸事件来控制熊猫天使
- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  
  
  playerPointsPerSecY =100.0f;
  
}
-(void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
  playerPointsPerSecY =-150.0f;
  
}

//更新熊猫天使的位置
- (void)updatePlayerPos:(ccTime)dt {
  
  CGSize winSize = [CCDirector sharedDirector].winSize;
  
  float maxY = winSize.height - player.contentSize.height/2;
  float minY = 15+player.contentSize.height/2;
  
  float newY = player.position.y + (playerPointsPerSecY * dt);
  newY = MIN(MAX(newY, minY), maxY);
  player.position = ccp(player.position.x, newY);
  
  
}


//实时更新
- (void)update:(ccTime)dt {
    
      [self updateBackground:dt];
    
    if(isGameStarted == YES){
  
  [self updatePlayerPos:dt];

  [self updateMissles:dt];
  [self updateAirObstacles:dt];
  [self updateGroundObstacles:dt];
  [self updateCoins:dt];
  [self updateAid:dt];
  
  [self updateGameStatus:dt];
  [self updateCollisions:dt];
    }

}


@end
