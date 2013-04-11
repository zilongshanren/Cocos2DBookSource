//
//  HelloWorldLayer.m
//  VerticalShootingGame
//
//  Created by guanghui qu on 5/28/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


// Import the interfaces
#import "GameLayer.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"
#import "SimpleAudioEngine.h"
#import "CCParallaxNode-Extras.h"
#import "GameManager.h"
#import "GameOverLayer.h"
#import "Constants.h"




#pragma mark - HelloWorldLayer

enum  {
    kTagPalyer = 1,
    kTagBatchNode = 2,
};

const int offset = 1;


@interface GameLayer()
-(void) spawnEnemy;
-(CCSprite*) getAvailableEnemySprite;
-(void) updatePlayerPosition:(ccTime)dt;
-(void) updatePlayerShooting:(ccTime)dt;
-(void) updateBackground:(ccTime)dt;
-(void) bulletFinishedMoving:(id)sender;
-(void) collisionDetection:(ccTime)dt;
-(CGRect) rectOfSprite:(CCSprite*)sprite;
-(void) updateHUD:(ccTime)dt;
-(void) onRestartGame;
-(CCSprite*) getPlayerSprite;
-(void) gameOver;
-(CCAnimation*)getAnimationByName:(NSString *)animName delay:(float)delay animNum:(int)num;

@end

// HelloWorldLayer implementation
@implementation GameLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameLayer *layer = [GameLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}



// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
        CCSpriteBatchNode *batchNode = [CCSpriteBatchNode batchNodeWithFile:@"gameArts.png"];
        batchNode.position = CGPointZero;
        [self addChild:batchNode z:0 tag:kTagBatchNode];
        
        
        //1.get screen's size
		CGSize winSize = [[CCDirector sharedDirector] winSize];
        //2.add background
//        CCSprite *bgSprite = [CCSprite spriteWithSpriteFrameName:@"background.png"];
//        bgSprite.position = ccp(winSize.width / 2,winSize.height/2);
//        [batchNode addChild:bgSprite z:-100];
        
        
        //3.add player's plane
        CCSprite *playerSprite = [CCSprite spriteWithSpriteFrameName:@"hero_1.png"];
        playerSprite.position = CGPointMake(winSize.width / 2, playerSprite.contentSize.height/2 + 20);
        [batchNode addChild:playerSprite z:4 tag:kTagPalyer];
        
        //4.init enemy sprites array
        _enemySprites = [[CCArray alloc] init];
        
        //5.initialize 10 enemy sprites & add them to _enemySprites array for future useage
        const int NUM_OF_ENEMIES = 10;
        for (int i=0; i < NUM_OF_ENEMIES; ++i) {
            CCSprite *enemySprite = [CCSprite spriteWithSpriteFrameName:@"enemy1.png"];
            enemySprite.position = ccp(0,winSize.height + enemySprite.contentSize.height + 10);
            enemySprite.visible = NO;
            [batchNode addChild:enemySprite z:4];
            
            [_enemySprites addObject:enemySprite];
        }
        
        //8.game main loop
        [self scheduleUpdate];
        
       
        _isTouchToShoot = NO;
        
        //10.init bullets
        _bulletSprite = [CCSprite spriteWithSpriteFrameName:@"bullet1.png"];
        _bulletSprite.visible = NO;
        [batchNode addChild:_bulletSprite z:4];
        
        //11.add audio support
       
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"game_music.mp3" loop:YES];
        
        //12.init player lives & score
        CCLabelTTF *lifeIndicator = [CCLabelTTF labelWithString:@"生命值:" fontName:@"Arial" fontSize:20];
        lifeIndicator.anchorPoint = ccp(0.0,0.5);
        lifeIndicator.color = ccc3(255, 0, 0);
        lifeIndicator.position = ccp(20,winSize.height - 20);
        [self addChild:lifeIndicator z:10];
        
        _lifeLabel = [CCLabelBMFont labelWithString:@"0" fntFile:@"num.fnt"];
        _lifeLabel.position = ccpAdd(lifeIndicator.position, ccp(lifeIndicator.contentSize.width+10,0));
        [self addChild:_lifeLabel z:10];
        
        
        CCLabelTTF *scoreIndicator = [CCLabelTTF labelWithString:@"分数：" fontName:@"Arial" fontSize:20];
        scoreIndicator.anchorPoint = ccp(0.0,0.5f);
        scoreIndicator.color = ccc3(255, 0, 0);
        scoreIndicator.position = ccp(winSize.width - 100,winSize.height - 20);
        [self addChild:scoreIndicator z:10];
        
        _scoreLabel = [CCLabelBMFont labelWithString:@"00" fntFile:@"num.fnt"];
        _scoreLabel.position = ccpAdd(scoreIndicator.position, ccp(scoreIndicator.contentSize.width+ 10,0));
        [self addChild:_scoreLabel z:10];
        
        
        //13.init lives & score variable
        _totalLives = 3;
        _totalScore = 0;
        
        //14.add game end label
        _gameEndLabel = [CCLabelTTF labelWithString:@"" fontName:@"Arial" fontSize:40];
        _gameEndLabel.position = ccp(winSize.width/2,winSize.height/2);
        _gameEndLabel.visible = NO;
        [self addChild:_gameEndLabel z:10];
        
        //15.add game start menu & relative game logic
        _isGameStarted = NO;
        
        
        //16.添加连续滚动背景
        _backgroundNode = [CCParallaxNode node];
        [self addChild:_backgroundNode z:-1];
        
        CGPoint ratio = ccp(1.0,0.5);
        CCSprite *bgSprite1 = [CCSprite spriteWithSpriteFrameName:@"background_1.jpg"];
        [[bgSprite1 texture] setAliasTexParameters];
        bgSprite1.anchorPoint = ccp(0,0);
        [_backgroundNode addChild:bgSprite1 z:1 parallaxRatio:ratio positionOffset:ccp(0,0)];
        
        CCSprite *bgSprite2 = [CCSprite spriteWithSpriteFrameName:@"background_2.jpg"];
        [[bgSprite2 texture] setAliasTexParameters];
        bgSprite2.anchorPoint = ccp(0,0);        
        [_backgroundNode addChild:bgSprite2 z:1 parallaxRatio:ratio positionOffset:ccp(0,winSize.height - offset)];
        
               
        //17.init consumedTime
        _totalSeconds = kTotalGameSeconds;
        _consumedTime = 0.0f;
        
        
        //18.init player fly animation
        CCAnimation *playerFlyAnimation = [self getAnimationByName:@"hero_" delay:0.08 animNum:2];
        _playerFlyAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:playerFlyAnimation]];
        [_playerFlyAction retain];
        [playerSprite runAction:_playerFlyAction];
        
        //19.init player & enemy 's blow up animation
        _playerBlowupAnimation = [self getAnimationByName:@"plane_bao_" delay:0.08 animNum:5];
        [_playerBlowupAnimation retain];
        _enemyBlowupAnimation = [self getAnimationByName:@"plane2_bao_" delay:0.08f animNum:5];
        [_enemyBlowupAnimation retain];
        
        
        
        
        //20.init collidable flags
        _isEnemyCollidable = YES;
        _isPlayerCollidable = YES;
        
        
        //21.init count down bmfont label
        NSString *totoalSecStr = [NSString stringWithFormat:@"%2d %02d",_totalSeconds,0];
        _countdownLabel = [CCLabelBMFont labelWithString:totoalSecStr fntFile:@"num.fnt"];
        _countdownLabel.position = ccp(winSize.width / 2, winSize.height - 50);
        [self addChild:_countdownLabel z:1000];
        
        CCSprite *char1 = (CCSprite*)[_countdownLabel getChildByTag:0];
        CCSprite *char4 = (CCSprite*)[_countdownLabel getChildByTag:3];
        id scaleTo = [CCScaleBy actionWithDuration:1.0 scale:1.5];
        id scaleBack= [scaleTo reverse];
        id seq = [CCSequence actions:scaleTo,scaleBack, nil];
        id ac = [CCRepeatForever actionWithAction:seq];
        [char1 runAction:ac];
        [char4 runAction:[[ac copy] autorelease]];
        
        //22.添加暂停按钮和暂停画面
        CCMenuItem *pauseItem = [CCMenuItemFont itemWithString:@"暂停"
                                                         block:^(id sender){
                                                             //add pause layer
                                                             PauseLayer *pl = [PauseLayer node];
                                                             pl.position = CGPointZero;
                                                             [self addChild:pl z:100];
                                                             
                                                             pl.delegate = self;
                                                             
                                                             //pause game logic & animation
                                                             [[CCDirector sharedDirector] pause];
                                                             _isGamePause = YES;
                                                         }];
        pauseItem.position = ccp(winSize.width - 60,winSize.height - 100);
        CCMenu *menu = [CCMenu menuWithItems:pauseItem, nil];
        menu.position = CGPointZero;
        [self addChild:menu z:10];
        
        _isGamePause = NO;
        
	}
	return self;
}

-(CCAnimation*)getAnimationByName:(NSString *)animName delay:(float)delay animNum:(int)num{
    NSMutableArray *animFrames = [NSMutableArray arrayWithCapacity:num];
    for (int i=1; i<= num; ++i) {
        NSString *frameName = [NSString stringWithFormat:@"%@%d.png",animName,i];
        
        CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName];
        [animFrames addObject:frame];
    }
    CCAnimation *animation = [CCAnimation animationWithSpriteFrames:animFrames delay:delay];
    return animation;
    
}

-(void) onEnter{
    [super onEnter];
    
    CGSize winSize = [CCDirector sharedDirector].winSize;
    [CCMenuItemFont setFontSize:20];
    [CCMenuItemFont setFontName:@"Arial"];
    

    
    CCMenuItemFont *startItem = [CCMenuItemFont itemWithString:@"开始游戏" block:^(id sender)
                                 {
                                     _isGameStarted = YES;
                                     CCMenuItem *item = (CCMenuItemFont*)sender;
                                     item.visible = NO;
                                     
                                     //6.spawn enemy after 1.0 sec
                                     [self performSelector:@selector(spawnEnemy) 
                                                withObject:nil
                                                afterDelay:1.0f];
                                     
                                     //7.enable accelerometer
                                     self.isAccelerometerEnabled = YES;
                                     //9.enable touch
                                     self.isTouchEnabled = YES;
                                     
                                     //8.添加开始连续滚动背景的代码
                                     const int MAX_LEVEL_WIDTH = 320;
                                     const int MAX_LEVEL_HEIGHT = 480 * 100;
                                     CCSprite *hiddenPlayerSprite = [CCSprite spriteWithSpriteFrameName:@"hero_1.png"];
                                     hiddenPlayerSprite.position = ccp(winSize.width / 2, winSize.height / 2);
                                     [self addChild:hiddenPlayerSprite z:-4 tag:1024];
                                     
                                     id move = [CCMoveBy actionWithDuration:_totalSeconds position:ccp(0,MAX_LEVEL_HEIGHT)];
                                     [hiddenPlayerSprite runAction:move];
                                     //让背景开始滚动
                                     [_backgroundNode runAction:[CCFollow actionWithTarget:hiddenPlayerSprite 
                                                                             worldBoundary:CGRectMake(0, 0, MAX_LEVEL_WIDTH, MAX_LEVEL_HEIGHT)]];

                                 }];
    startItem.position = ccp(winSize.width / 2, -winSize.height / 2);
    _startGameMenu = [CCMenu menuWithItems:startItem, nil];
    _startGameMenu.position = CGPointZero;
    [self addChild:_startGameMenu];
    
    
    //1.add moveBy action to startGameMenu
    id moveBy = [CCMoveBy actionWithDuration:1.0 position:ccp(0,winSize.height)];
    [_startGameMenu runAction:moveBy];
    
    //2.pause _startGameMenu action
    [[[CCDirector sharedDirector] actionManager] pauseTarget:_startGameMenu];
    
    //3.resume _startGameMenu action after 1 sec
    [self schedule:@selector(resumeStartMenuAction:) interval:1.0];
}

-(void) resumeStartMenuAction:(ccTime)dt{
    [self unschedule:_cmd];
    
    [[[CCDirector sharedDirector] actionManager] resumeTarget:_startGameMenu];
}


-(CCSprite*)getPlayerSprite{
    CCSpriteBatchNode *batchNode = (CCSpriteBatchNode*)[self getChildByTag:kTagBatchNode];
    return (CCSprite*)[batchNode getChildByTag:kTagPalyer];
    
}

-(void) updateHUD:(ccTime)dt{
    [_lifeLabel setString:[NSString stringWithFormat:@"%2d",_totalLives]];
    [_scoreLabel setString:[NSString stringWithFormat:@"%04d",_totalScore]];
}

-(void) onExit{
    [_enemySprites release];
    _enemySprites = nil;
    
    [super onExit];
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	[_enemySprites release];
    _enemySprites = nil;
    
    CCLOG(@"GameLayer dealloc!");
    
	// don't forget to call "super dealloc"
	[super dealloc];
}

#pragma mark - accelerometer callback
-(void) accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration{
    float deceleration = 0.4f;
    float sensitivity = 6.0f;
    
    float maxVelocity = 100;
    
    _playerVelocity.x = _playerVelocity.x * deceleration + acceleration.x * sensitivity;
    if (_playerVelocity.x > maxVelocity) {
        _playerVelocity.x = maxVelocity;
    }else if(_playerVelocity.x < -maxVelocity){
        _playerVelocity.x = -maxVelocity;
    }
    
    
}

-(void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{    
    //修改成，必须点选中playerSprite才能够发射子弹
    
    //方法1：因为boundingBox是相对于世界坐标系而言的，所以要用self convertTouchToNodeSpace
    UITouch *touch = [touches anyObject];
    CCSprite *playerSprite = [self getPlayerSprite];
    
    CGPoint pt;
//    pt = [touch locationInView:[touch view]];
//    pt = [[CCDirector sharedDirector] convertToGL:pt];
//    pt = [self convertToNodeSpace:pt];
    //上面三句调用，可以简化为下面一句调用
    //CGPoint pt = [self convertTouchToNodeSpace:touch];
        
//    if (CGRectContainsPoint(playerSprite.boundingBox, pt)) {
//        _isTouchToShoot = YES;
//    }
    
    //===================================================================
    //方法2：
//    pt = [touch locationInView:[touch view]];
//    pt = [[CCDirector sharedDirector] convertToGL:pt];
//    pt = [playerSprite convertToNodeSpace:pt];
    //简化为下面的一句代码调用
    CCSpriteBatchNode *batchNode = (CCSpriteBatchNode*)[self getChildByTag:kTagBatchNode];
    pt = [batchNode convertTouchToNodeSpace:touch];
    
    CCLOG(@"pt.x = %f, pt.y = %f",pt.x, pt.y);
        
    if (CGRectContainsPoint(playerSprite.boundingBox, pt)) {
        _isTouchToShoot = YES;
        CCLOG(@"touched!");
    }
    
}

//
//-(void) draw{   
//    [super draw];
//    
//    ccDrawColor4F(255,0,0,0);
//    glLineWidth(8);
//
//    ccDrawLine(ccp(10,10),ccp(200,200));
//    
//}

-(void) update:(ccTime)dt{
    if (!_isGameStarted) {
        return;
    }
    
    _consumedTime += dt;
    if (_consumedTime >= _totalSeconds) {
        //game over
        [self gameOver];
        return;
    }
    
    float result =  _totalSeconds-_consumedTime;
    int sec = result * 100 / 100;
    int microsec = (int)(result * 100) % 100;
    NSString *str = [NSString stringWithFormat:@"%2d %2d",sec,microsec];
    [_countdownLabel setString:str];
    
    
    [self updatePlayerPosition:dt];
    [self updatePlayerShooting:dt];
    [self collisionDetection:dt];
    [self updateHUD:dt];
    [self updateBackground:dt];
}

-(void) updateBackground:(ccTime)dt{
    CCSprite *sprite;
    int index = 0;
	CCARRAY_FOREACH([_backgroundNode children],sprite)
	{
        CGPoint pt = [_backgroundNode convertToWorldSpace:sprite.position];
//        CCLOG(@"pt.x = %f, pt.y = %f",pt.x,  pt.y);
        if ( pt.y <= -sprite.contentSize.height) {
            CCLOG(@"===============");
            [_backgroundNode incrementOffset:ccp(0,(sprite.contentSize.height - offset) * 2.0f) forChild:sprite];
        }
        
        index++;
	}

}

-(void) updatePlayerShooting:(ccTime)dt{
    if (_bulletSprite.visible || !_isTouchToShoot) {
        return;
    }
    
    CCSprite *playerSprite = [self getPlayerSprite];
    CGPoint pos = playerSprite.position;
    
    CGPoint bulletPos = CGPointMake(pos.x, 
                                    pos.y + playerSprite.contentSize.height/ 2 + _bulletSprite.contentSize.height);
    _bulletSprite.position = bulletPos;
    _bulletSprite.visible = YES;
    
    CGSize winSize = [CCDirector sharedDirector].winSize;
    id moveBy = [CCMoveBy actionWithDuration:1.0 position:ccp(0,winSize.height - bulletPos.y)];
    id callback = [CCCallFuncN actionWithTarget:self selector:@selector(bulletFinishedMoving:)];
    id ac = [CCSequence actions:moveBy,callback, nil];
    [_bulletSprite runAction:ac];
    
    
    [[SimpleAudioEngine sharedEngine] playEffect:@"bullet.mp3"];
    CCLOG(@"_bulletSprite runAction");
}

-(CGRect) rectOfSprite:(CCSprite*)sprite{
    return CGRectMake(sprite.position.x - sprite.contentSize.width / 2, 
                      sprite.position.y - sprite.contentSize.height /2, 
                      sprite.contentSize.width, sprite.contentSize.height);
}

-(void) collisionDetection:(ccTime)dt{
    
    CCSprite *enemy;
   // CGRect bulletRect = [self rectOfSprite:_bulletSprite];
    CCARRAY_FOREACH(_enemySprites, enemy)
    {
        if (enemy.visible  && _isEnemyCollidable) {
            //1.bullet & enemy collision det ection
           // CGRect enemyRect = [self rectOfSprite:enemy];
            if (_bulletSprite.visible && CGRectIntersectsRect(enemy.boundingBox, _bulletSprite.boundingBox)) {
//                enemy.visible = NO;
                _isEnemyCollidable = NO;
                id ac1 = [CCScaleTo actionWithDuration:1.0 scale:1.2];
                id ac2 = [CCRotateBy actionWithDuration:1.0 angle:720];
                id ac3 = [CCFadeOut actionWithDuration:1.0];
                id ac4 = [CCHide action];
                id blowup = [CCAnimate actionWithAnimation:_enemyBlowupAnimation];
                id block = ^(){
                    _isEnemyCollidable = YES;
                };
                id ac5 = [CCSequence actions:ac3,ac4,[CCCallBlock actionWithBlock:block], nil];
                
                id action = [CCSpawn actions:ac1,ac2,ac5,blowup, nil];
                [enemy stopAllActions];
                [enemy runAction:action];

                CCLOG(@"enemy collision!");
                
                _bulletSprite.visible = NO;
                
                _totalScore += 100;
                
                if (_totalScore > kGameWinScore) {
                    [_gameEndLabel setString:@"游戏胜利！"];
                    _gameEndLabel.visible = YES;
                    
                    id scaleTo = [CCScaleTo actionWithDuration:1.0 scale:1.2f];
                    [_gameEndLabel runAction:scaleTo];
                    
                    [self unscheduleUpdate];
                    [_backgroundNode stopAllActions];
                    
                    [self performSelector:@selector(onRestartGame) withObject:nil afterDelay:2.0f];
                    [self unscheduleAllSelectors];
                    
                }
                
                [_bulletSprite stopAllActions];
                CCLOG(@"collision bullet");
                break;
            }
            
            //2.enemy & player collision detection
            CCSprite *playerSprite = [self getPlayerSprite];
//            CGRect playRect = [self rectOfSprite:playerSprite];
            if (playerSprite.visible && _isPlayerCollidable
                && CGRectIntersectsRect(enemy.boundingBox, playerSprite.boundingBox)) {
                enemy.visible = NO;
                _isPlayerCollidable = NO;

                _totalLives -= 1;
                
                if (_totalLives <= 0) {
                    [self gameOver];
                }
                
                id blink = [CCBlink actionWithDuration:2.0 blinks:4];
                id blowup = [CCAnimate actionWithAnimation:_playerBlowupAnimation];
                id action = [CCSequence actions:blowup,blink, [CCCallBlock actionWithBlock:^(){
                    _isPlayerCollidable = YES;
                    //重新运行飞机动画
                    [playerSprite stopAllActions];
                    [playerSprite runAction:_playerFlyAction];
                    playerSprite.opacity = 255;
                    playerSprite.visible = YES;
                }],nil];
                [playerSprite stopAllActions];
                [playerSprite runAction:action];
                CCLOG(@"collision player");
                break;
            }
        }
    }
}

-(void) gameOver{
    [_gameEndLabel setString:@"游戏失败!"];

    _gameEndLabel.visible = YES;
    id scaleTo = [CCScaleTo actionWithDuration:1.0 scale:1.2f];
    [_gameEndLabel runAction:scaleTo];
    
    [self unscheduleUpdate];
    [_backgroundNode stopAllActions];
    [self unscheduleAllSelectors];
    

    
    [GameManager sharedGameManager].isWin = NO;
    [GameManager sharedGameManager].score = _totalScore;
    [GameManager sharedGameManager].playTimes = [GameManager sharedGameManager].playTimes + 1;
    
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
    
    CCTransitionFade* transitionScene = [CCTransitionFade transitionWithDuration:2
                                                                           scene:[GameOverLayer scene]
                                                                       withColor:ccWHITE];
    [[CCDirector sharedDirector] replaceScene:transitionScene];
//    [self performSelector:@selector(onRestartGame) withObject:nil afterDelay:3.0f];
}

-(void) onRestartGame{
    
    [GameManager sharedGameManager].isWin = YES;
    
    //计算生命值的得分
    while (_totalLives > 0) {
        _totalScore += 1000;
        _totalLives--;
    }
    //计算剩余时间所得分
    _totalScore += (_totalSeconds - _consumedTime) * 100;
    
    
    [GameManager sharedGameManager].score = _totalScore;
    
    [GameManager sharedGameManager].playTimes = [GameManager sharedGameManager].playTimes + 1;
    
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
    
    CCTransitionFade* transitionScene = [CCTransitionFade transitionWithDuration:1
                                                                           scene:[GameOverLayer scene]
                                                                       withColor:ccWHITE];
    [[CCDirector sharedDirector] replaceScene:transitionScene];
    
    [[GameManager sharedGameManager] addNewHighScore:_totalScore];
}

-(void) bulletFinishedMoving:(id)sender{
    _bulletSprite.visible = NO;
}

-(void) updatePlayerPosition:(ccTime)dt{
    CCSprite *playerSprite = [self getPlayerSprite];
    CGPoint pos = playerSprite.position;
    pos.x += _playerVelocity.x;
    
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    float imageWidthHavled = playerSprite.textureRect.size.width * 0.5f;
    //警惕使用sprite.texture.contentSize,这种写法只有当使用sprite file来初始化精灵的时候有效，
    //如果是使用spriteBatchNode，则会失效！！！
//    float imageWidthHavled = playerSprite.texture.contentSize.width * 0.5f;

    float leftBoderLimit = imageWidthHavled;
    float rightBoderLimit = screenSize.width - imageWidthHavled;
    
    if (pos.x < leftBoderLimit) {
        pos.x = leftBoderLimit;
        _playerVelocity = CGPointZero;
    }else if(pos.x > rightBoderLimit){
        pos.x = rightBoderLimit;
        _playerVelocity = CGPointZero;
    }
    
    playerSprite.position = pos;
}



#pragma mark - private methods
-(void) spawnEnemy{
    if (_isGamePause) {
        [self performSelector:_cmd withObject:nil afterDelay:arc4random()%3 + 1];
        return;
    }
    
    //1.
    CGSize winSize = [CCDirector sharedDirector].winSize;
    CCSprite *enemySprite = [self getAvailableEnemySprite];
    
    enemySprite.visible = YES;
    enemySprite.position = ccp( arc4random() % (int)(winSize.width - enemySprite.contentSize.width) + enemySprite.contentSize.width/2 , winSize.height + enemySprite.contentSize.height + 10);
    
    //2.
    float durationTime = arc4random() % 4 + 1;
    id moveBy = [CCMoveBy actionWithDuration:durationTime 
                                position:ccp(0,-enemySprite.position.y-enemySprite.contentSize.height)];
    int choice = arc4random() % 4 + 1;
    id easedMoveBy = nil;
    switch (choice) {
        case 1:
            easedMoveBy = [CCEaseIn actionWithAction:moveBy];
            break;
        case 2:
            easedMoveBy = [CCEaseExponentialIn actionWithAction:moveBy];
            break;
        case 3:
            easedMoveBy = [CCEaseBounceIn actionWithAction:moveBy];
            break;
        case 4:
            easedMoveBy = [CCEaseBackIn actionWithAction:moveBy];
            break;
        default:
            break;
    }
    
    
    id callback = [CCCallBlockN actionWithBlock:^(id sender)
    {
        CCSprite *sp = (CCSprite*)sender;
        sp.visible = NO;
        sp.position = ccp(0,winSize.height + sp.contentSize.height + 10);
        CCLOG(@"reset enemy plane!");
    }];
    CCSequence *action = [CCSequence actions:easedMoveBy,callback, nil];
    
    
    CCLOG(@"enemySprite x = %f, y = %f",enemySprite.position.x, enemySprite.position.y);
    [enemySprite runAction:action];
     
    
    //3.
    [self performSelector:_cmd withObject:nil afterDelay:arc4random()%3 + 1];
    
}

-(CCSprite*) getAvailableEnemySprite{
    CCSprite *result = nil;
    int count = 0;
    CCARRAY_FOREACH(_enemySprites, result)
    {
        count++;
        if (!result.visible) {
            result.opacity = 255;
            break;
        }
    }
    CCLOG(@"spawn num %d enemy sprite",count);
    return result;
}

#pragma mark - pauseLayer protocol
-(void) didRecieveResumeEvent:(PauseLayer *)layer{
    [[CCDirector sharedDirector] resume];
    _isGamePause = NO;
    [self removeChild:layer cleanup:YES];
    [[SimpleAudioEngine sharedEngine] resumeBackgroundMusic];
}

-(void) didRecieveRestartEvent:(PauseLayer *)layer{
    [[CCDirector sharedDirector] resume];
    [self removeChild:layer cleanup:YES];
    
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
    
    [[CCDirector sharedDirector] replaceScene:[GameLayer scene]];
}
@end
