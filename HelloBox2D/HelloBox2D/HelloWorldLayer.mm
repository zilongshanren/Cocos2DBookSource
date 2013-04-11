//
//  HelloWorldLayer.mm
//  HelloBox2D
//
//  Created by eseedo on 2/12/12.
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
-(void) addNewSpriteAtPosition:(CGPoint)p;
-(void) createMenu;
-(void)addPaddleBodyAtPosition:(CGPoint)p;
-(void)setupContactListener;
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

-(void)setupContactListener{
  //创建接触监听器
  contactListener = new MyContactListener();
  world->SetContactListener(contactListener);
  
}

-(id) init
{
	if( (self=[super init])) {
		
		// enable events
		
		self.isTouchEnabled = YES;
		self.isAccelerometerEnabled = YES;
		CGSize s = [CCDirector sharedDirector].winSize;
		
		// init physics
		[self initPhysics];
    
    //添加球拍
    [self addPaddleBodyAtPosition:ccp(s.width*0.5,50)];
		
		// create reset button
		[self createMenu];
		[self setupContactListener];
    
		//添加标签
		CCLabelTTF *label = [CCLabelTTF labelWithString:@"Tap screen" fontName:@"Marker Felt" fontSize:32];
		[self addChild:label z:0];
		[label setColor:ccc3(0,0,255)];
		label.position = ccp( s.width*0.8, s.height-30);
		
		[self scheduleUpdate];
	}
	return self;
}

-(void) dealloc
{
	delete world;
	world = NULL;
	
	delete m_debugDraw;
	m_debugDraw = NULL;
	
	[super dealloc];
}	

-(void) createMenu
{
	// Default font size will be 22 points.
	[CCMenuItemFont setFontSize:22];
	
	// Reset Button
	CCMenuItemLabel *reset = [CCMenuItemFont itemWithString:@"Reset" block:^(id sender){
		[[CCDirector sharedDirector] replaceScene: [HelloWorldLayer scene]];
	}];
	
	CCMenu *menu = [CCMenu menuWithItems:reset, nil];
	
	[menu alignItemsVertically];
	
	CGSize size = [[CCDirector sharedDirector] winSize];
	[menu setPosition:ccp( size.width*0.2, size.height*0.8)];
	
	
	[self addChild: menu z:-1];	
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
	
//	m_debugDraw = new GLESDebugDraw( PTM_RATIO );
//	world->SetDebugDraw(m_debugDraw);
//	
//	uint32 flags = 0;
//	flags += b2Draw::e_shapeBit;
//	//		flags += b2Draw::e_jointBit;
//	//		flags += b2Draw::e_aabbBit;
//	//		flags += b2Draw::e_pairBit;
//	//		flags += b2Draw::e_centerOfMassBit;
//	m_debugDraw->SetFlags(flags);		
	
	
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
	bottomFixture = groundBody->CreateFixture(&groundBox,0);
	
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

-(void) addNewSpriteAtPosition:(CGPoint)p
{
//	CCLOG(@"Add sprite %0.2f x %02.f",p.x,p.y);
//	CCNode *parent = [self getChildByTag:kTagParentNode];
//	
//	//We have a 64x64 sprite sheet with 4 different 32x32 images.  The following code is
//	//just randomly picking one of the images
//	int idx = (CCRANDOM_0_1() > .5 ? 0:1);
//	int idy = (CCRANDOM_0_1() > .5 ? 0:1);
//	PhysicsSprite *sprite = [PhysicsSprite spriteWithTexture:spriteTexture_ rect:CGRectMake(32 * idx,32 * idy,32,32)];						
//	[parent addChild:sprite];
	
	ball = [PhysicsSprite spriteWithFile:@"ball.png"];
  ball.tag =1;
  [self addChild:ball];
  ball.position = ccp( p.x, p.y);
  
  //创建小球物体及其夹具
  b2BodyDef ballBodyDef;
  ballBodyDef.type = b2_dynamicBody;
  ballBodyDef.position.Set(p.x/PTM_RATIO, p.y/PTM_RATIO);
  ballBody = world->CreateBody(&ballBodyDef);
  
  //创建小球物体的形状
  b2CircleShape circle;
  circle.m_radius = 8.0/PTM_RATIO;
  
  //创建小球物体的夹具
  b2FixtureDef ballShapeDef;
  ballShapeDef.shape = &circle;
  ballShapeDef.density = 1.0f;
  ballShapeDef.friction = 0.3f;
  ballShapeDef.restitution = 1.0f;
  ballFixture= ballBody->CreateFixture(&ballShapeDef);
  
  [ball setPhysicsBody:ballBody];
  
}

-(void)addPaddleBodyAtPosition:(CGPoint)p{
  
  
  //创建球拍精灵，并将其添加为当前层的子节点
  
  paddle = [PhysicsSprite spriteWithFile:@"paddle.png"];
  paddle.position = ccp(p.x,p.y);
  [self addChild:paddle];
  
  //创建球拍物体定义，设置物体的属性
  b2BodyDef paddleBodyDef;
  paddleBodyDef.type = b2_dynamicBody;
  paddleBodyDef.position.Set(p.x/PTM_RATIO, p.y/PTM_RATIO);
  
  //使用世界对象来创建物体
  paddleBody = world->CreateBody(&paddleBodyDef);
  
  
  //创建球拍的形状
  b2PolygonShape paddleShape;
  paddleShape.SetAsBox(paddle.contentSize.width/PTM_RATIO/2, paddle.contentSize.height/PTM_RATIO/2);
  
  //创建夹具定义，设置夹具属性，并使用物体来创建夹具
  b2FixtureDef paddleShapeDef;
  paddleShapeDef.shape = &paddleShape;
  paddleShapeDef.density = 10.0f;
  paddleShapeDef.friction = 0.4f;
  paddleShapeDef.restitution = 0.1f;
  paddleFixture = paddleBody->CreateFixture(&paddleShapeDef);
  
  [paddle setPhysicsBody:paddleBody];
  
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
  
  
  //碰撞检测
  std::vector<MyContact>::iterator pos;
  for (pos = contactListener->contacts.begin();pos != contactListener->contacts.end();++pos){
    MyContact contact = *pos;
    if((contact.fixtureA == paddleFixture &&contact.fixtureB ==ballFixture) || 
       (contact.fixtureA == ballFixture && contact.fixtureB == paddleFixture)){
      NSLog(@"You scored!");
      
    }else if((contact.fixtureA == bottomFixture &&contact.fixtureB ==ballFixture) || 
             (contact.fixtureA == ballFixture && contact.fixtureB == bottomFixture)){
      NSLog(@"Ball fell!");
      
    }
  }
  
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	//Add a new body/atlas sprite at the touched location
	for( UITouch *touch in touches ) {
		CGPoint location = [touch locationInView: [touch view]];
		
		location = [[CCDirector sharedDirector] convertToGL: location];
		
		[self addNewSpriteAtPosition: location];
	}
}

#pragma mark 重力感应
- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
  
  // Landscape left values
  b2Vec2 gravity(-acceleration.y * 15, acceleration.x *15);
  world->SetGravity(gravity);
  
}

#pragma mark GameKit delegate

-(void) achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}

-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}

@end
