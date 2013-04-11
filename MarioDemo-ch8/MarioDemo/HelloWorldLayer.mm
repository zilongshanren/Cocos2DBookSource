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

enum {
	kTagParentNode = 1,
};


#pragma mark - HelloWorldLayer

@interface HelloWorldLayer()
-(void) initPhysics;
-(void) initJoystick;
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
		
		self.isTouchEnabled = YES;
		self.isAccelerometerEnabled = YES;		
		// init physics
		[self initPhysics];
        
        //1.add tiled map 
        _gameMap = [CCTMXTiledMap tiledMapWithTMXFile:@"level.tmx"];
        _gameMap.anchorPoint = CGPointZero;
        _gameMap.position = CGPointZero;
        [self addChild:_gameMap];
		
        //2.retrieve object layer, get player spwanPoint
        CCTMXObjectGroup *objects = [_gameMap objectGroupNamed:@"objects"];
        NSMutableDictionary *spawnPoint = [objects objectNamed:@"StartPoint"]; 
        float x = [[spawnPoint valueForKey:@"x"] floatValue];
        float y = [[spawnPoint valueForKey:@"y"] floatValue];
        
        //3.add player to the spawnPoint
        _player = [CCSprite spriteWithFile:@"Player1.png"];
        _player.position = ccp(x, y);
        [self addChild:_player]; 
        
        //4.reset layer's view point
        [self setViewpointCenter:_player.position];
        
        
        //5.初始化joystick
        [self initJoystick];
		
		[self scheduleUpdate];
	}
	return self;
}

-(void) initJoystick{
    
    ZJoystick *_joystick2		 = [ZJoystick joystickNormalSpriteFile:@"JoystickContainer_norm.png"
                                               selectedSpriteFile:@"JoystickContainer_trans.png"
                                             controllerSpriteFile:@"Joystick_norm.png"];
    _joystick2.position          = ccp(_joystick2.contentSize.width/2 + 10,
                                       _joystick2.contentSize.height/2 + 10);
    _joystick2.delegate          = self;    //Joystick Delegate
    _joystick2.controlledObject  = _player;
    _joystick2.speedRatio        = 2.0f;
    _joystick2.joystickRadius    = 50.0f;   //added in v1.2
    _joystick2.joystickTag       = 999;
    [self addChild:_joystick2];

}

-(void)setViewpointCenter:(CGPoint) position {
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    int x = MAX(position.x, winSize.width /2);
    int y = MAX(position.y, winSize.height /2);
    x = MIN(x, (_gameMap.mapSize.width * _gameMap.tileSize.width)
            - winSize.width /2);
    y = MIN(y, (_gameMap.mapSize.height * _gameMap.tileSize.height) 
            - winSize.height/2);
    CGPoint actualPosition = ccp(x, y);
    
    CGPoint centerOfView = ccp(winSize.width/2, winSize.height/2);
    CGPoint viewPoint = ccpSub(centerOfView, actualPosition);
    self.position = viewPoint;
    
}


-(void) dealloc
{
	delete world;
	world = NULL;
	
	delete m_debugDraw;
	m_debugDraw = NULL;
	
	[super dealloc];
}	


-(void) initPhysics
{
	
	CGSize s = [[CCDirector sharedDirector] winSize];
	
	b2Vec2 gravity;
	gravity.Set(0.0f, -10.0f);
	world = new b2World(gravity);
	
	
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
	
	groundBox.Set(b2Vec2(0,0), b2Vec2(s.width/PTM_RATIO,0));
	groundBody->CreateFixture(&groundBox,0);
	
	// top
	groundBox.Set(b2Vec2(0,s.height/PTM_RATIO), b2Vec2(s.width/PTM_RATIO,s.height/PTM_RATIO));
	groundBody->CreateFixture(&groundBox,0);
	
	// left
	groundBox.Set(b2Vec2(0,s.height/PTM_RATIO), b2Vec2(0,0));
	groundBody->CreateFixture(&groundBox,0);
	
	// right
	groundBox.Set(b2Vec2(s.width/PTM_RATIO,s.height/PTM_RATIO), b2Vec2(s.width/PTM_RATIO,0));
	groundBody->CreateFixture(&groundBox,0);
}

-(void) draw
{
	//
	// IMPORTANT:
	// This is only for debug purposes
	// It is recommend to disable it
	//
	[super draw];
	
	ccGLEnableVertexAttribs( kCCVertexAttribFlag_Position );
	
	kmGLPushMatrix();
	
	world->DrawDebugData();	
	
	kmGLPopMatrix();
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
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
}

#pragma mark - zJoystick delegate methods
-(void)joystickControlBegan {
//	CCLOG(@"Joystick Began Controlling");
	
}

-(void)joystickControlMoved {
//	CCLOG(@"Joystick Move Controlling");
	
}

-(void)joystickControlEnded {
//	CCLOG(@"Joystick End Controlling");
	
}

-(void)joystickControlDidUpdate:(id)joystick toXSpeedRatio:(CGFloat)xSpeedRatio toYSpeedRatio:(CGFloat)ySpeedRatio{
    
    ZJoystick *zJoystick = (ZJoystick *)joystick;
    
    if (zJoystick.joystickTag == 999) {
        CGFloat xPos = _player.position.x;
        CGFloat yPos = _player.position.y;
        _player.position = ccp(xPos + xSpeedRatio, yPos + ySpeedRatio);
    }
}
@end
