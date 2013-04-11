//
//  HelloWorldLayer.mm
//  MarioDemo
//
//  Created by guanghui qu on 7/11/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//

// Import the interfaces
#import "HelloWorldLayer.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

#import "PhysicsSprite.h"
#import "GB2ShapeCache.h"
#import "CocosDenshion/SimpleAudioEngine.h"
#import "HUDLayer.h"

enum {
	kTagParentNode = 1,
    kTagCoinSprite = 101,
    kTagBoxSprite ,
    kTagObstacleSprite,
    kTagWaterSprite,
    kTagVictorySprite,
};


#pragma mark - HelloWorldLayer

@interface HelloWorldLayer()
-(void) initPhysics;
-(void) initPlayer;
-(void) initWallAndWater;
- (void) makeBox2dObjAt:(CGPoint)p
               withSize:(CGPoint)size
                dynamic:(BOOL)d
               rotation:(long)r
               friction:(long)f
                density:(long)dens
            restitution:(long)rest
                 sprite:(CCSprite*)sprite
                isSensor:(BOOL)s;
-(void) playerJump;
-(void) updatePlayerJump:(ccTime)dt;
-(void) initCoins;
-(void) initBoxes;
-(void) collisionDetection:(ccTime)dt;
-(void) queryAABB;
-(void) cancelCrazyState;

-(void) initScore;
-(void) updateScore:(ccTime)dt;
-(void) preloadAudioEffects;
-(void) gameEnd:(BOOL)isWin;
-(void) initVictoryPoint;


@end

@implementation HelloWorldLayer

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

-(id) init
{
	if( (self=[super init])) {
		
		// enable events
		[[GB2ShapeCache sharedShapeCache] addShapesWithFile:@"physicShape.plist"];
        
		self.isTouchEnabled = YES;
		self.isAccelerometerEnabled = YES;		
		
        
        //1.add tiled map 
        _gameMap = [CCTMXTiledMap tiledMapWithTMXFile:@"level.tmx"];
        _gameMap.anchorPoint = CGPointZero;
        _gameMap.position = CGPointZero;
        [self addChild:_gameMap z:-2];
        
        // init physics
		[self initPhysics];
		
        [self initPlayer];

        [self initCoins];
        
        [self initBoxes];

        //4.reset layer's view point
        [self setViewpointCenter:_player.position];
        
        //5.init hudlayer
        _hudLayer = [HUDLayer HUDLayerWithSprite:_player body:_playerBody];
        _hudLayer.position = CGPointZero;
        [self addChild:_hudLayer];
        
        //6.初始化墙壁和水
        [self initWallAndWater];
        
        //7.make mario jump
        _isOnGround = YES;
        _isJumpPressed = NO;
        
        [self initScore];
        
        [self preloadAudioEffects];
        
        
        [self initVictoryPoint];
        
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"background.caf"];
		
		[self scheduleUpdate];
	}
	return self;
}


-(void) preloadAudioEffects{
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"jump.caf"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"coin.caf"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"dead.caf"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"game_over.caf"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"victory.caf"];

}

-(void) initScore{
    _totalScore = 0;
    
    
}

-(void) initBoxes{
    CCTMXLayer *tmxLayer = [_gameMap layerNamed:@"background"];
    
    for (NSUInteger y = 0; y < tmxLayer.layerSize.height; y++) {
        for (NSUInteger x = 0; x < tmxLayer.layerSize.width; x++) {
            NSUInteger pos = x + tmxLayer.layerSize.width * y;
            uint32_t gid = tmxLayer.tiles[pos];
            if (gid > 0) {
                NSDictionary *tileProperty = [_gameMap propertiesForGID:gid];
                
                BOOL isBox = [tileProperty objectForKey:@"box"] != nil;
                BOOL isObstacle  = [tileProperty objectForKey:@"obstacle"] != nil;
                if (isBox) {
                    CCSprite *sprite = [tmxLayer tileAt:ccp(x,y)];
                    sprite.tag = kTagBoxSprite;
                    sprite.anchorPoint = ccp(0.5f,0.5f);  //一定要设置anchorPoint!否则box2D显示不正确
                    float x = sprite.position.x;
                    float y = sprite.position.y;
                    CGPoint coinSize = ccp(sprite.contentSize.width,sprite.contentSize.height);
                    [self makeBox2dObjAt:ccp(x + coinSize.x / 2, y + coinSize.y / 2)
                                withSize:coinSize
                                 dynamic:NO
                                rotation:0.0
                                friction:0.4
                                 density:0
                             restitution:0
                                  sprite:sprite
                                isSensor:NO];
                }
                if (isObstacle) {
                    CCSprite *sprite = [tmxLayer tileAt:ccp(x,y)];
                    sprite.tag = kTagObstacleSprite;
                    sprite.anchorPoint = ccp(0.5f,0.5f);  //一定要设置anchorPoint!否则box2D显示不正确
                    float x = sprite.position.x;
                    float y = sprite.position.y;
                    CGPoint coinSize = ccp(sprite.contentSize.width,sprite.contentSize.height);
                    [self makeBox2dObjAt:ccp(x + coinSize.x / 2, y + coinSize.y / 2)
                                withSize:coinSize
                                 dynamic:NO
                                rotation:0.0
                                friction:0.4
                                 density:20
                             restitution:0
                                  sprite:sprite
                                isSensor:NO];
                }

            }
        }
    }

}

-(void) initVictoryPoint{ 
    //2.retrieve object layer, get player spwanPoint
    CCTMXObjectGroup *objects = [_gameMap objectGroupNamed:@"objects"];
    NSMutableDictionary *spawnPoint = [objects objectNamed:@"victoryPoint"];
    float x = [[spawnPoint valueForKey:@"x"] floatValue];
    float y = [[spawnPoint valueForKey:@"y"] floatValue];
    
    //3.add player to the spawnPoint
    CCSprite *sprite = [CCSprite node];
    sprite.tag = kTagVictorySprite;
    [self addChild:sprite];
    
    [self makeBox2dObjAt:ccp(x,y)
                withSize:ccp(10,10)
                 dynamic:NO
                rotation:0
                friction:0
                 density:0
             restitution:0
                  sprite:sprite
                isSensor:YES];
    
}

-(void)initPlayer{
    //2.retrieve object layer, get player spwanPoint
    CCTMXObjectGroup *objects = [_gameMap objectGroupNamed:@"objects"];
    NSMutableDictionary *spawnPoint = [objects objectNamed:@"StartPoint"];
    float x = [[spawnPoint valueForKey:@"x"] floatValue];
    float y = [[spawnPoint valueForKey:@"y"] floatValue];
    
    //3.add player to the spawnPoint
    _player = [CCSprite spriteWithFile:@"Player1.png"];
    _player.position = ccp(x, y);
    [self addChild:_player];
    
    b2BodyDef playerBodyDef;
    playerBodyDef.type = b2_dynamicBody;
    playerBodyDef.fixedRotation = true;
    playerBodyDef.position.Set(x / PTM_RATIO, y / PTM_RATIO);
    
    _playerBody = world->CreateBody(&playerBodyDef);
    _playerBody->SetUserData(_player);
    [[GB2ShapeCache sharedShapeCache] addFixturesToBody:_playerBody forShapeName:@"Player1"];
}

-(void) initCoins{
    CCTMXLayer *tmxLayer = [_gameMap layerNamed:@"coinLayer"];
    
    for (NSUInteger y = 0; y < tmxLayer.layerSize.height; y++) {
        for (NSUInteger x = 0; x < tmxLayer.layerSize.width; x++) {
            NSUInteger pos = x + tmxLayer.layerSize.width * y;
            uint32_t gid = tmxLayer.tiles[pos];
            if (gid > 0) {
//                NSDictionary *tileProperty = [_gameMap propertiesForGID:gid];
                CCSprite *coinSprite = [tmxLayer tileAt:ccp(x,y)];
                coinSprite.tag = kTagCoinSprite;
                coinSprite.anchorPoint = ccp(0.5f,0.5f);  //一定要设置anchorPoint!否则box2D显示不正确
                float x = coinSprite.position.x;
                float y = coinSprite.position.y;
                CGPoint coinSize = ccp(coinSprite.contentSize.width,coinSprite.contentSize.height);
                [self makeBox2dObjAt:ccp(x + coinSize.x / 2, y + coinSize.y / 2)
                            withSize:coinSize
                             dynamic:NO
                            rotation:0.0
                            friction:1.0
                             density:20
                         restitution:0
                               sprite:coinSprite
                            isSensor:YES];
                CCLOG(@"x = %f, y= %f",coinSprite.anchorPoint.x, coinSprite.anchorPoint.y);
            }
        }
    }
}

        
- (void) makeBox2dObjAt:(CGPoint)p
               withSize:(CGPoint)size
                dynamic:(BOOL)d
               rotation:(long)r
               friction:(long)f
                density:(long)dens
            restitution:(long)rest
                  sprite:(CCSprite*)sprite
               isSensor:(BOOL)s{
    
    // Define the dynamic body.
    //Set up a 1m squared box in the physics world
    b2BodyDef bodyDef;
    bodyDef.angle = r;
    if (d) {
        bodyDef.type = b2_dynamicBody;
    }else{
        bodyDef.type = b2_staticBody;
    }
    
    bodyDef.position.Set(p.x/PTM_RATIO, p.y/PTM_RATIO);
    bodyDef.userData = sprite;
    
    b2Body *body = world->CreateBody(&bodyDef);
    
    // Define another box shape for our dynamic body.
    b2PolygonShape dynamicBox;
    dynamicBox.SetAsBox(size.x/2/PTM_RATIO, size.y/2/PTM_RATIO);
    
    // Define the dynamic body fixture.
    b2FixtureDef fixtureDef;
    fixtureDef.shape =&dynamicBox;
    fixtureDef.density = dens;
    fixtureDef.friction = f;
    fixtureDef.restitution = rest;
    fixtureDef.isSensor = s;
    body->CreateFixture(&fixtureDef);
}
-(void) initWallAndWater{
    //1.提取wall的信息    
    CCTMXObjectGroup *objects = [_gameMap objectGroupNamed:@"wall"];
    NSMutableDictionary * objPoint;
    
    float x, y, w, h;
    int isSensor = 0;
    for (objPoint in [objects objects]) {
        x = [[objPoint valueForKey:@"x"] floatValue];
        y = [[objPoint valueForKey:@"y"] floatValue];
        w = [[objPoint valueForKey:@"width"] floatValue];
        h = [[objPoint valueForKey:@"height"] floatValue];
        isSensor = [[ objPoint valueForKey:@"isSensor"] intValue];
        
        CGPoint _point=ccp(x+w/2.0f,y+h/2.0f);
        CGPoint _size=ccp(w,h);
        
        if (isSensor != 1) {
            //创建墙壁
            [self makeBox2dObjAt:_point
                        withSize:_size
                         dynamic:false
                        rotation:0
                        friction:0.2f
                         density:0.0f
                     restitution:0
                           sprite:NULL
                        isSensor:false];
        }else{
            //创建水域
            CCSprite *water = [CCSprite node];
            water.tag = kTagWaterSprite;
            [self addChild:water];
            
            [self makeBox2dObjAt:_point
                        withSize:_size
                         dynamic:false
                        rotation:0
                        friction:0.0f
                         density:0.0f
                     restitution:0
                           sprite:water
                        isSensor:true];
        }
       
    }

    
}



-(void)setViewpointCenter:(CGPoint) position {
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    int x = MAX(position.x, winSize.width /2);
    int y = MAX(position.y, winSize.height /2);
    x = MIN(x, (_gameMap.mapSize.width * _gameMap.tileSize.width ) / CC_CONTENT_SCALE_FACTOR()
            - winSize.width /2);
    y = MIN(y, (_gameMap.mapSize.height * _gameMap.tileSize.height) / CC_CONTENT_SCALE_FACTOR()
            - winSize.height/2);
    CGPoint actualPosition = ccp(x, 0);
    
    CGPoint centerOfView = ccp(winSize.width/2, 0);
    CGPoint viewPoint = ccpSub(centerOfView, actualPosition);
    self.position = viewPoint;
    _hudLayer.position = ccp(-self.position.x ,0);
    
    
}


-(void) dealloc
{
	delete world;
	world = NULL;
	
	delete m_debugDraw;
	m_debugDraw = NULL;
    
    delete _contactListener;
    _contactListener = NULL;
	
	[super dealloc];
}	


-(void) initPhysics
{
	
	CGSize s = [[CCDirector sharedDirector] winSize];
	
	b2Vec2 gravity;
	gravity.Set(0.0f, -10.0f);
	world = new b2World(gravity);
	
    _contactListener = new MyContactListener;
    world->SetContactListener(_contactListener);
	
	// Do we want to let bodies sleep?
	world->SetAllowSleeping(true);
	
	world->SetContinuousPhysics(true);
	
	m_debugDraw = new GLESDebugDraw( PTM_RATIO );
	world->SetDebugDraw(m_debugDraw);
	
	uint32 flags = 0;
	flags += b2Draw::e_shapeBit;
	//		flags += b2Draw::e_jointBit;
	//		flags += b2Draw::e_aabbBit;
	//		flags += b2Draw::e_pairBit;
	//		flags += b2Draw::e_centerOfMassBit;
	m_debugDraw->SetFlags(flags);		
	
	
	// Define the ground body.
	b2BodyDef groundBodyDef;
	groundBodyDef.position.Set(0, 0); // bottom-left corner
	
	// Call the body factory which allocates memory for the ground body
	// from a pool and creates the ground box shape (also from a pool).
	// The body is also added to the world.
	b2Body* groundBody = world->CreateBody(&groundBodyDef);
	
	// Define the ground box shape.
	b2EdgeShape groundBox;		
	
	// bottom
    float levelWidth = _gameMap.mapSize.width * (_gameMap.tileSize.width / CC_CONTENT_SCALE_FACTOR());
	
	groundBox.Set(b2Vec2(0,0), b2Vec2(levelWidth/PTM_RATIO,0));
	groundBody->CreateFixture(&groundBox,0);
	
	// top
	groundBox.Set(b2Vec2(0,s.height/PTM_RATIO), b2Vec2(levelWidth/PTM_RATIO,s.height/PTM_RATIO));
	groundBody->CreateFixture(&groundBox,0);
	
	// left
	groundBox.Set(b2Vec2(0,s.height/PTM_RATIO), b2Vec2(0,0));
	groundBody->CreateFixture(&groundBox,0);
	
	// right
	groundBox.Set(b2Vec2(levelWidth/PTM_RATIO,s.height/PTM_RATIO), b2Vec2(levelWidth/PTM_RATIO,0));
	groundBody->CreateFixture(&groundBox,0);
}

-(void) draw
{
	//
	// IMPORTANT:
	// This is only for debug purposes
	// It is recommend to disable it
	//
	
	
	ccGLEnableVertexAttribs( kCCVertexAttribFlag_Position );
	
	kmGLPushMatrix();
#ifdef DEBUG
	world->DrawDebugData();
#endif
    if (_isCrazy) {
        [self queryAABB];
    }
	
	kmGLPopMatrix();
    
    [super draw];
}


-(void) update: (ccTime) dt
{
	//It is recommended that a fixed time step is used with Box2D for stability
	//of the simulation, however, we are using a variable time step here.
	//You need to make an informed choice, the following URL is useful
	//http://gafferongames.com/game-physics/fix-your-timestep/
	
	int32 velocityIterations = 8;
	int32 positionIterations = 1;
	
	// Instruct the world to perform a single step of simulation. It is
	// generally best to keep the time step and iterations fixed.
	world->Step(dt, velocityIterations, positionIterations);
    
    for(b2Body *b = world->GetBodyList(); b; b=b->GetNext()) {
        
        
        if (b->GetUserData() != NULL) {
            CCSprite *sprite = (CCSprite *)b->GetUserData();
            if (sprite != nil) {
                b2Vec2 bodyPos = b->GetPosition();
                CGPoint pos = CGPointMake(bodyPos.x * PTM_RATIO, bodyPos.y * PTM_RATIO);
                float32 rotation = -1 * CC_RADIANS_TO_DEGREES(b->GetAngle());
                sprite.position = pos;
                sprite.rotation = rotation;
            }
        }
    }
    
    
    //根据角色的位置移动游戏背景
    [self setViewpointCenter:_player.position];
    
    [self updatePlayerJump:dt];
    
    [self collisionDetection:dt];
    
    [self updateScore:dt];

}

-(void) updateScore:(ccTime)dt{
    NSString *score = [NSString stringWithFormat:@"%2d",_totalScore];
    [_hudLayer.scoreLabel setString:score];
}

-(void) collisionDetection:(ccTime)dt{
    
    std::vector<b2Body*> toDestroy;
    
    std::vector<MyContact>::iterator pos;
    for(pos = _contactListener->_contacts.begin();
        pos != _contactListener->_contacts.end(); ++pos) {
        MyContact contact =*pos;
        
        CCSprite *sprite;
        if (contact.fixtureA->GetBody() == _playerBody) {
            b2Body *body = contact.fixtureB->GetBody();
            sprite = (CCSprite*)body->GetUserData();
            if (sprite != nil  ) {
                if (sprite.tag == kTagCoinSprite) {
                    toDestroy.push_back(body);
                    _totalScore++;
                    [[SimpleAudioEngine sharedEngine] playEffect:@"coin.caf"];
                }else if(sprite.tag == kTagObstacleSprite){
                    //吸金币
                    //只有踩在上面的刺上，才触发吸收金币的动作
                    b2WorldManifold manifold;
                    _playerBody->GetContactList()->contact->GetWorldManifold(&manifold);
                    CCLOG(@"normal : x = %f, y= %f",manifold.normal.x, manifold.normal.y);
                    //碰撞的时候会产生一个单位法向量，这个法向量默认从是fixtureA->fixtureB的
                    //因为玩家在上，所以法向量朝下。如果玩家踩在这个箱子上面的话，那么法向量理论上为(0,-1)
                    //读者可以尝试从多个不同的角度去与箱子碰撞，然后看看输出的法向量的值 
                    if (manifold.normal.y < -0.5 ) {
                        CCLOG(@"踩");
//                        [self queryAABB];
                        _isCrazy = YES;
                        if ([_player numberOfRunningActions] == 0) {
                            [_player runAction:[CCBlink actionWithDuration:2.5 blinks:8]];
                        }
                        [self performSelector:@selector(cancelCrazyState)
                                   withObject:nil
                                   afterDelay:3.0];
                    }
                    
                }else if(sprite.tag == kTagWaterSprite){
                    toDestroy.push_back(body);
                    [self gameEnd:NO];
                }else if(sprite.tag == kTagVictorySprite){
                    toDestroy.push_back(body);
                    [self gameEnd:YES];
                }
            }
        }
        //因为contact并不能保证fixtureA和fixtureB的顺序，所以，两种情况都需要加以判断
        else if(contact.fixtureB->GetBody() == _playerBody){
            b2Body *body = contact.fixtureA->GetBody();
            sprite = (CCSprite*)body->GetUserData();
            if (sprite != nil) {
                if (sprite.tag == kTagCoinSprite) {
                    toDestroy.push_back(body);
                    _totalScore++;
                    [[SimpleAudioEngine sharedEngine] playEffect:@"coin.caf"];
                }else if(sprite.tag == kTagObstacleSprite){
                    //吸金币
                    //只有踩在上面的刺上，才触发吸收金币的动作
                    b2WorldManifold manifold;
                    _playerBody->GetContactList()->contact->GetWorldManifold(&manifold);
                    CCLOG(@"normal : x = %f, y= %f",manifold.normal.x, manifold.normal.y);
                    //碰撞的时候会产生一个单位法向量，这个法向量默认从是fixtureA->fixtureB的
                    //因为玩家在上，所以法向量朝下。如果玩家踩在这个箱子上面的话，那么法向量理论上为(0,-1)
                    //读者可以尝试从多个不同的角度去与箱子碰撞，然后看看输出的法向量的值
                    if (manifold.normal.y < -0.5 ) {
                        CCLOG(@"踩");
                        _isCrazy = YES;
                        if ([_player numberOfRunningActions] == 0) {
                            [_player runAction:[CCBlink actionWithDuration:2.5 blinks:8]];
                        }
                        [self performSelector:@selector(cancelCrazyState)
                                   withObject:nil
                                   afterDelay:3.0];
                    }

                }else if(sprite.tag == kTagWaterSprite){
                    toDestroy.push_back(body);
                    [self gameEnd:NO];
                }else if(sprite.tag == kTagVictorySprite){
                    toDestroy.push_back(body);
                    [self gameEnd:YES];
                }
            }
        }
    }
    
    std::vector<b2Body *>::iterator pos2;
    for(pos2 = toDestroy.begin(); pos2 != toDestroy.end(); ++pos2) {
        b2Body *body =*pos2;
        if (body->GetUserData() != NULL) {
            CCSprite *sprite = (CCSprite *) body->GetUserData();
             [sprite removeFromParentAndCleanup:YES];
        }
        world->DestroyBody(body);
    }
}

-(void) updatePlayerJump:(ccTime)dt{
    //Decrement jump counter
	_jumpCounter -= dt;
    
	//Did the gunman just hit the ground?
	if(!_isOnGround){
		if((_playerBody->GetLinearVelocity().y - _lastVelocity) > 2 && _lastVelocity < -2){
			_playerBody->SetLinearVelocity(b2Vec2(_playerBody->GetLinearVelocity().x,0));
			_isOnGround = YES;
            CCLOG(@"跳下来，着地！1");
		}else if(_playerBody->GetLinearVelocity().y == 0 && _lastVelocity == 0){
			_playerBody->SetLinearVelocity(b2Vec2(_playerBody->GetLinearVelocity().x,0));
			_isOnGround = YES;
            CCLOG(@"跳下来，着地！2");
		}
	}
	
	//Did he just fall off the ground without jumping?
	if(_isOnGround){
		if(_playerBody->GetLinearVelocity().y < -2.0f && _lastVelocity < -2.0f
           && (_playerBody->GetLinearVelocity().y < _lastVelocity)){
			_isOnGround = NO;
            CCLOG(@"往下落！");
		}
	}
    
	//Store last velocity
	_lastVelocity = _playerBody->GetLinearVelocity().y;
    
	//Keep him upright on the ground
	if(_isOnGround){
		_playerBody->SetTransform(_playerBody->GetPosition(),0);
	}
    
    //处理角色跳跃
    if ( _isJumpPressed) {
        [self playerJump];
    }else{
        _jumpCounter = -10;
    }
    
    float velocityX = _playerBody->GetLinearVelocity().x;
    if(velocityX < 0){
        _player.flipX = YES;
    }else{
        _player.flipX = NO;
    }
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    _isJumpPressed = YES;
   
}

-(void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    _isJumpPressed = NO;
}

-(void) playerJump{
    if(_isOnGround && _jumpCounter < 0){
		_jumpCounter = 1.5f;
        [[SimpleAudioEngine sharedEngine] playEffect:@"jump.caf"];
		_playerBody->ApplyLinearImpulse(b2Vec2(0,18.0f),_playerBody->GetPosition());
		_isOnGround = NO;
	}else if(_jumpCounter > 0){
		//Continue a jump
		_playerBody->ApplyForce(b2Vec2(0,15.0f), _playerBody->GetPosition());
	}
}


-(void) gameEnd:(BOOL)isWin{
    if (![[SimpleAudioEngine sharedEngine] isBackgroundMusicPlaying]) {
        return;
    }
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];

    if (isWin) {
        [[SimpleAudioEngine sharedEngine] playEffect:@"victory.caf"];
        [_hudLayer.gameOverLabel setString:@"You Win!"];
        
        
    }else{
        [[SimpleAudioEngine sharedEngine] playEffect:@"game_over.caf"];
        [_hudLayer.gameOverLabel setString:@"You Lose!"];
    }
    
    _hudLayer.gameOverLabel.visible = YES;
    _hudLayer.gameOverLabel.scale = 0.2f;
    
    id scaleTo = [CCScaleTo actionWithDuration:1.0 scale:1.2];
    id scaleBack = [CCScaleTo actionWithDuration:1.0 scale:1.0];
    id callback = [CCCallBlock actionWithBlock:^(){
        [[CCDirector sharedDirector] replaceScene:[HelloWorldLayer scene]];
    }];
    id delay = [CCDelayTime actionWithDuration:2.0];
    id action = [CCSequence actions:scaleTo,scaleBack, delay,callback, nil];
    [_hudLayer.gameOverLabel runAction:action];
    
}

-(void) queryAABB{
    CoinQueryCallback callback;
    callback.m_circle.m_radius = 80.0f / PTM_RATIO;
    callback.m_circle.m_p.Set(_player.position.x  / PTM_RATIO,
                              _player.position.y  / PTM_RATIO);
    callback.m_transform.SetIdentity();
    callback.world = world;
    b2AABB aabb;
    callback.m_circle.ComputeAABB(&aabb, callback.m_transform,0);
#ifdef DEBUG
    b2Color color(0.0f, 0.0f, 0.0f);
    m_debugDraw->DrawCircle(callback.m_circle.m_p, callback.m_circle.m_radius, color);
#endif
    world->QueryAABB(&callback, aabb);
    
}

-(void) cancelCrazyState{
    [_player stopAllActions];
    _player.opacity = 255;
    _isCrazy = NO;
}

@end
