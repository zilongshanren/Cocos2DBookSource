//
//  HelloWorldLayer.m
//  VerticalShootingGame
//
//  Created by guanghui qu on 5/28/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"
#import "SimpleAudioEngine.h"

#pragma mark - HelloWorldLayer

enum  {
    kTagPalyer = 1,
};

@interface HelloWorldLayer()
-(void) spawnEnemy;
-(CCSprite*) getAvailableEnemySprite;
-(void) updatePlayerPosition:(ccTime)dt;
-(void) updatePlayerShooting:(ccTime)dt;
-(void) bulletFinishedMoving:(id)sender;
-(void) collisionDetection:(ccTime)dt;
-(CGRect) rectOfSprite:(CCSprite*)sprite;
-(void) updateHUD:(ccTime)dt;
-(void) onRestartGame;
@end

// HelloWorldLayer implementation
@implementation HelloWorldLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
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
        //1.get screen's size
		CGSize winSize = [[CCDirector sharedDirector] winSize];
        //2.add background
        CCSprite *bgSprite = [CCSprite spriteWithFile:@"background_1.jpg"];
        bgSprite.position = ccp(winSize.width / 2,winSize.height/2);
        [self addChild:bgSprite z:0];
        
        
        //3.add player's plane
        CCSprite *playerSprite = [CCSprite spriteWithFile:@"hero_1.png"];
        playerSprite.position = CGPointMake(winSize.width / 2, playerSprite.contentSize.height/2 + 20);
        [self addChild:playerSprite z:4 tag:kTagPalyer];

        //4.init enemy sprites array
        _enemySprites = [[CCArray alloc] init];
        
        //5.initialize 10 enemy sprites & add them to _enemySprites array for future useage
        const int NUM_OF_ENEMIES = 10;
        for (int i=0; i < NUM_OF_ENEMIES; ++i) {
            CCSprite *enemySprite = [CCSprite spriteWithFile:@"enemy1.png"];
            enemySprite.position = ccp(0,winSize.height + enemySprite.contentSize.height + 10);
            enemySprite.visible = NO;
            [self addChild:enemySprite z:4];
            
            [_enemySprites addObject:enemySprite];
        }

        //6.spawn enemy after 1.0 sec
        [self performSelector:@selector(spawnEnemy) 
                   withObject:nil
                   afterDelay:1.0f];

        //7.enable accelerometer
        self.isAccelerometerEnabled = YES;
        
        //8.game main loop
        [self scheduleUpdate];
        
        //9.enable touch
        self.isTouchEnabled = YES;
        _isTouchToShoot = NO;
        
        //10.init bullets
        _bulletSprite = [CCSprite spriteWithFile:@"bullet1.png"];
        _bulletSprite.visible = NO;
        [self addChild:_bulletSprite z:4];
        
        //11.add audio support
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"bullet.mp3"];
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"game_music.mp3" loop:YES];
        [[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:0.5];

        //12.init player lives & score
        CCLabelTTF *lifeIndicator = [CCLabelTTF labelWithString:@"生命值:" fontName:@"Arial" fontSize:20];
        lifeIndicator.anchorPoint = ccp(0.0,0.5);
        lifeIndicator.position = ccp(20,winSize.height - 20);
        [self addChild:lifeIndicator z:10];
        _lifeLabel = [CCLabelTTF labelWithString:@"3" fontName:@"Arial" fontSize:20];
        _lifeLabel.position = ccpAdd(lifeIndicator.position, ccp(lifeIndicator.contentSize.width+10,0));
        [self addChild:_lifeLabel z:10];
        
        
        CCLabelTTF *scoreIndicator = [CCLabelTTF labelWithString:@"分数：" fontName:@"Arial" fontSize:20];
        scoreIndicator.anchorPoint = ccp(0.0,0.5f);
        scoreIndicator.position = ccp(winSize.width - 100,winSize.height - 20);
        [self addChild:scoreIndicator z:10];
        _scoreLabel = [CCLabelTTF labelWithString:@"00" fontName:@"Arial" fontSize:20];
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
       
        
	}
	return self;
}



-(void) updateHUD:(ccTime)dt{
    [_lifeLabel setString:[NSString stringWithFormat:@"%2d",_totalLives]];
    [_scoreLabel setString:[NSString stringWithFormat:@"%04d",_totalScore]];
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	[_enemySprites release];
    _enemySprites = nil;
    
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
    CCLOG(@"touch!");
    _isTouchToShoot = YES;
}

-(void) update:(ccTime)dt{
    [self updatePlayerPosition:dt];
    [self updatePlayerShooting:dt];
    [self collisionDetection:dt];
    [self updateHUD:dt];
}

-(void) updatePlayerShooting:(ccTime)dt{
    if (_bulletSprite.visible || !_isTouchToShoot) {
        return;
    }
    
    CCSprite *playerSprite = (CCSprite*)[self getChildByTag:kTagPalyer];
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
    CGRect bulletRect = [self rectOfSprite:_bulletSprite];
    CCARRAY_FOREACH(_enemySprites, enemy)
    {
        if (enemy.visible) {
            //1.bullet & enemy collision detection
            CGRect enemyRect = [self rectOfSprite:enemy];
            if (_bulletSprite.visible && CGRectIntersectsRect(enemyRect, bulletRect)) {
                enemy.visible = NO;
                _bulletSprite.visible = NO;
                
                _totalScore += 100;
                
                if (_totalScore >= 1000) {
                    [_gameEndLabel setString:@"游戏胜利！"];
                    _gameEndLabel.visible = YES;
                    
                    id scaleTo = [CCScaleTo actionWithDuration:1.0 scale:1.2f];
                    [_gameEndLabel runAction:scaleTo];
                    
                    [self unscheduleUpdate];
                    [self performSelector:@selector(onRestartGame) withObject:nil afterDelay:2.0f];
                }
                
                [_bulletSprite stopAllActions];
                [enemy stopAllActions];
                CCLOG(@"collision bullet");
                break;
            }
            
            //2.enemy & player collision detection
            CCSprite *playerSprite = (CCSprite*)[self getChildByTag:kTagPalyer];
            CGRect playRect = [self rectOfSprite:playerSprite];
            if (playerSprite.visible &&
                playerSprite.numberOfRunningActions == 0
                && CGRectIntersectsRect(enemyRect, playRect)) {
                enemy.visible = NO;
                
                _totalLives -= 1;
                
                if (_totalLives <= 0) {
                    [_gameEndLabel setString:@"游戏失败!"];
                    _gameEndLabel.visible = YES;
                    id scaleTo = [CCScaleTo actionWithDuration:1.0 scale:1.2f];
                    [_gameEndLabel runAction:scaleTo];
                    
                    [self unscheduleUpdate];
                    [self performSelector:@selector(onRestartGame) withObject:nil afterDelay:3.0f];
                }
                
                id blink = [CCBlink actionWithDuration:2.0 blinks:4];
                [playerSprite stopAllActions];
                [playerSprite runAction:blink];
                CCLOG(@"collision player");
                break;
            }
        }
    }
}

-(void) onRestartGame{
    [[CCDirector sharedDirector] replaceScene:[HelloWorldLayer scene]];
}

-(void) bulletFinishedMoving:(id)sender{
    _bulletSprite.visible = NO;
}

-(void) updatePlayerPosition:(ccTime)dt{
    CCSprite *playerSprite = (CCSprite*)[self getChildByTag:kTagPalyer];
    CGPoint pos = playerSprite.position;
    pos.x += _playerVelocity.x;
    
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    float imageWidthHavled = playerSprite.texture.contentSize.width * 0.5f;
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
    //1.
    CGSize winSize = [CCDirector sharedDirector].winSize;
    CCSprite *enemySprite = [self getAvailableEnemySprite];
    
    enemySprite.visible = YES;
    enemySprite.position = ccp( arc4random() % (int)(winSize.width - enemySprite.contentSize.width) + enemySprite.contentSize.width/2 , winSize.height + enemySprite.contentSize.height + 10);
    
    //2.
    float durationTime = arc4random() % 4 + 1;
    id moveBy = [CCMoveBy actionWithDuration:durationTime 
                                position:ccp(0,-enemySprite.position.y-enemySprite.contentSize.height)];
    id callback = [CCCallBlockN actionWithBlock:^(id sender)
    {
        CCSprite *sp = (CCSprite*)sender;
        sp.visible = NO;
        sp.position = ccp(0,winSize.height + sp.contentSize.height + 10);
        CCLOG(@"reset enemy plane!");
    }];
    id action = [CCSequence actions:moveBy,callback, nil];
    
    
    CCLOG(@"enemySprite x = %f, y = %f",enemySprite.position.x, enemySprite.position.y);
    [enemySprite runAction:action];
    
    //3.
    [self performSelector:_cmd withObject:nil afterDelay:arc4random()%3 + 1];
    
}

-(CCSprite*) getAvailableEnemySprite{
    CCSprite *result = nil;
    CCARRAY_FOREACH(_enemySprites, result)
    {
        if (!result.visible) {
            break;
        }
    }
    return result;
}
@end
